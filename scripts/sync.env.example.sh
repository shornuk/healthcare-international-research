# Minimal sync settings for local development.
# Copy this file to: scripts/sync.env.sh

# SSH connection to production box
REMOTE_SSH_LOGIN="forge@212.71.252.218"
REMOTE_SSH_PORT="22"

# Assets sync paths
REMOTE_ASSETS_DIR="/home/forge/parkershaw.co.uk/web/assets/"
LOCAL_ASSETS_DIR="/Users/Sean/Sites/parkershaw/web/assets/"

REMOTE_REBRAND_DIR="/home/forge/parkershaw.co.uk/storage/rebrand/"
LOCAL_REBRAND_DIR="/Users/Sean/Sites/parkershaw/storage/rebrand/"

# Remote production DB
REMOTE_DB_HOST="127.0.0.1"
REMOTE_DB_PORT="3306"
REMOTE_DB_NAME="parkershaw"
REMOTE_DB_USER="REPLACE_ME"
REMOTE_DB_PASSWORD="REPLACE_ME"

# Local DB to overwrite
LOCAL_DB_HOST="127.0.0.1"
LOCAL_DB_PORT="3306"
LOCAL_DB_NAME="parkershaw_local"
LOCAL_DB_USER="root"
LOCAL_DB_PASSWORD=""

# Optional command overrides
MYSQL_CMD="mysql"
MYSQLDUMP_CMD="mysqldump"
