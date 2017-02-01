#!/bin/bash

BACKUP_CMD="pg_dumpall -f /backup/\${BACKUP_NAME} ${EXTRA_OPTS}"

echo "=> Creating backup script"
rm -f /backup.sh
cat <<EOF >> /backup.sh
#!/bin/bash
MAX_BACKUPS=${MAX_BACKUPS}

BACKUP_NAME=\$(date +\%Y.\%m.\%d.\%H\%M\%S).sql

echo "=> Backup started: \${BACKUP_NAME}"
if ${BACKUP_CMD} ;then
    echo "   Backup succeeded"
else
    echo "   Backup failed"
    rm -rf /backup/\${BACKUP_NAME}
fi

if [ -n "\${MAX_BACKUPS}" ]; then
    while [ \$(find /backup -type f | wc -l) -gt \${MAX_BACKUPS} ];
    do
        BACKUP_TO_BE_DELETED=\$(find /backup -type f | sort | head -n 1)
        echo "   Backup \${BACKUP_TO_BE_DELETED} is deleted"
        rm -f /backup/\${BACKUP_TO_BE_DELETED}
    done
fi
echo "=> Backup done"
EOF
chmod +x /backup.sh

echo "=> Creating restore script"
rm -f /restore.sh
cat <<EOF >> /restore.sh
#!/bin/bash

echo "=> Restore database from \$1"
if psql < \$1 ;then
    echo "   Restore succeeded"
else
    echo "   Restore failed"
fi
echo "=> Done"
EOF
chmod +x /restore.sh

touch /postgres_backup.log
tail -F /postgres_backup.log &

if [ -n "${INIT_BACKUP}" ]; then
    echo "=> Create a backup on the startup"
    /backup.sh
elif [ -n "${INIT_RESTORE_LATEST}" ]; then
    echo "=> Restore latest backup"
    until pg_isready
    do
        echo "waiting database container..."
        sleep 1
    done
    find /backup/ -type f | tail -1 | xargs /restore.sh
fi

echo "${CRON_TIME} /backup.sh >> /postgres_backup.log 2>&1" > /rontab.conf
crontab  /crontab.conf
echo "=> Running cron job"
exec crond -f -d8
