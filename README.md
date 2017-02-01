# docker-postgres-backup [![Docker Repository on Quay](https://quay.io/repository/tamu_cpt/postgres-backup/status "Docker Repository on Quay")](https://quay.io/repository/tamu_cpt/postgres-backup)

This image runs pg_dumpall to backup data using cronjob to folder `/backup`

## Usage:

    docker run -d \
        --env PGHOST=mysql.host \
        --env PGPORT=27017 \
        --env PGUSER=admin \
        --env PGPASSWORD=password \
        --volume host.folder:/backup
        quay.io/tamu_cpt/docker-postgres-backup

## Parameters

    PGHOST          the host/ip of your postgres database
    PGPORT          the port number of your postgres database
    PGUSER          the username of your postgres database
    PGPASSWORD      the password of your postgres database

    EXTRA_OPTS      the extra options to pass to pg_dump command
    CRON_TIME       the interval of cron job to run pg_dump. `0 0 * * *` by default, which is every day at 00:00
    MAX_BACKUPS     the number of backups to keep. When reaching the limit, the old backup will be discarded. No limit by default

    INIT_BACKUP     if set, create a backup when the container starts
    INIT_RESTORE_LATEST if set, restores latest backup

## Restore from a backup

See the list of backups, you can run:

    docker exec docker-postgres-backup ls /backup

To restore database from a certain backup, simply run:

    docker exec docker-postgres-backup /restore.sh /backup/2015.08.06.171901
