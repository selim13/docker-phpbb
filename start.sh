#!/bin/sh

set -e

[[ "${PHPBB_INSTALL}" = "true" ]] && rm config.php
[[ "${PHPBB_INSTALL}" != "true" ]] && rm -rf install

db_wait() {
        if [[ "${PHPBB_DB_WAIT}" = "true" &&  "${PHPBB_DB_DRIVER}" != "sqlite3" && "${PHPBB_DB_DRIVER}" != "sqlite" ]]; then
            until nc -z ${PHPBB_DB_HOST} ${PHPBB_DB_PORT}; do
                echo "$(date) - waiting for database on ${PHPBB_DB_HOST}:${PHPBB_DB_PORT} to start before applying migrations"
                sleep 3
            done
        fi
}

db_migrate() {
    if [[ "${PHPBB_DB_AUTOMIGRATE}" = "true" && "${PHPBB_INSTALL}" != "true" ]]; then
        echo "$(date) - applying migrations"
        su-exec apache php bin/phpbbcli.php db:migrate
    fi
}

# Apache gets grumpy about PID files pre-existing
rm -f /run/apache2/httpd.pid

db_wait && db_migrate && exec httpd -DFOREGROUND "$@"
