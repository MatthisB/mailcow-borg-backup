# Backup mailcow with borg 🐮 + 🤖 = 💕

Thanks to these awesome projects!
- [mailcow-dockerized](https://github.com/mailcow/mailcow-dockerized)
- [borgbackup](https://github.com/borgbackup/borg)

Unlike the provided helper-scripts/backup_and_restore.sh, this one uses borgbackup which works incrementally and does not need to tar everything at every single backup.
Means it is very, very, very much faster and saves a huge amount of storage space!


## Backup
This script disables dovecot and postfix at first and lets nginx just return a 503-Error, to ensure no files will be changed during backup.
Next it prepares the backup (database dump, etc.)
When done it triggers the borgbackup itself and saves all the data.
Afterwards the stopped services are started again and temporary files are cleaned up.

Just customize the script to your needs and run it as a cronjob.


## Restore
**_! not finally tested yet_**

Steps to restore:
- adjust the scripts settings-variables
- extract your repository snapshot completely into `restoreVolumesFrom="/path/to/extracted/borgbackup"`
- install mailcow as [shown](https://mailcow.github.io/mailcow-dockerized-docs/i_u_m_install/)
- start it once, to create all required files and directories and stop it again\
`docker-compose pull`, `docker-compose up -d`, wait a few minutes, `docker-compose down`
- run restore.sh when containers are completely downed
- start mailcow again and check if everything worked
