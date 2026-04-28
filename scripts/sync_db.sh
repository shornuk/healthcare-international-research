#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${SCRIPT_DIR}/sync.env.sh"

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "Missing ${ENV_FILE}"
  echo "Copy scripts/sync.env.example.sh to scripts/sync.env.sh and fill values."
  exit 1
fi

source "${ENV_FILE}"

MYSQL_CMD="${MYSQL_CMD:-mysql}"
MYSQLDUMP_CMD="${MYSQLDUMP_CMD:-mysqldump}"

required_vars=(
  REMOTE_SSH_LOGIN
  REMOTE_SSH_PORT
  REMOTE_DB_HOST
  REMOTE_DB_PORT
  REMOTE_DB_NAME
  REMOTE_DB_USER
  REMOTE_DB_PASSWORD
  LOCAL_DB_HOST
  LOCAL_DB_PORT
  LOCAL_DB_NAME
  LOCAL_DB_USER
  LOCAL_DB_PASSWORD
)

for var_name in "${required_vars[@]}"; do
  if [[ -z "${!var_name:-}" && "${var_name}" != "LOCAL_DB_PASSWORD" ]]; then
    echo "Required variable is missing: ${var_name}"
    exit 1
  fi
done

timestamp="$(date '+%Y%m%d-%H%M%S')"
tmp_dump="/tmp/${REMOTE_DB_NAME}-${timestamp}.sql.gz"
local_backup="/tmp/${LOCAL_DB_NAME}-backup-${timestamp}.sql.gz"

echo "Backing up local database to ${local_backup} ..."
MYSQL_PWD="${LOCAL_DB_PASSWORD}" "${MYSQLDUMP_CMD}" \
  -h "${LOCAL_DB_HOST}" \
  -P "${LOCAL_DB_PORT}" \
  -u "${LOCAL_DB_USER}" \
  --single-transaction \
  --quick \
  "${LOCAL_DB_NAME}" | gzip > "${local_backup}"

echo "Pulling production dump to ${tmp_dump} ..."
ssh -p "${REMOTE_SSH_PORT}" "${REMOTE_SSH_LOGIN}" \
  "MYSQL_PWD='${REMOTE_DB_PASSWORD}' ${MYSQLDUMP_CMD} -h '${REMOTE_DB_HOST}' -P '${REMOTE_DB_PORT}' -u '${REMOTE_DB_USER}' --single-transaction --quick --set-gtid-purged=OFF '${REMOTE_DB_NAME}' | gzip -c" \
  > "${tmp_dump}"

echo "Importing production dump into local database ${LOCAL_DB_NAME} ..."
gunzip -c "${tmp_dump}" | MYSQL_PWD="${LOCAL_DB_PASSWORD}" "${MYSQL_CMD}" \
  -h "${LOCAL_DB_HOST}" \
  -P "${LOCAL_DB_PORT}" \
  -u "${LOCAL_DB_USER}" \
  "${LOCAL_DB_NAME}"

echo "Done."
echo "Local backup: ${local_backup}"
echo "Downloaded dump: ${tmp_dump}"
