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

required_vars=(
  REMOTE_SSH_LOGIN
  REMOTE_SSH_PORT
  REMOTE_ASSETS_DIR
  LOCAL_ASSETS_DIR
  REMOTE_REBRAND_DIR
  LOCAL_REBRAND_DIR
)

for var_name in "${required_vars[@]}"; do
  if [[ -z "${!var_name:-}" ]]; then
    echo "Required variable is missing: ${var_name}"
    exit 1
  fi
done

mkdir -p "${LOCAL_ASSETS_DIR}" "${LOCAL_REBRAND_DIR}"

echo "Syncing web/assets ..."
rsync -avz --delete-after --progress \
  -e "ssh -p ${REMOTE_SSH_PORT}" \
  "${REMOTE_SSH_LOGIN}:${REMOTE_ASSETS_DIR}" \
  "${LOCAL_ASSETS_DIR}"

echo "Syncing storage/rebrand ..."
rsync -avz --delete-after --progress \
  -e "ssh -p ${REMOTE_SSH_PORT}" \
  "${REMOTE_SSH_LOGIN}:${REMOTE_REBRAND_DIR}" \
  "${LOCAL_REBRAND_DIR}"

echo "Done."
