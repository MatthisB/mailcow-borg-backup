# mailcow backup with borg 🐮🐋 + 🤖 = 💕

Thanks to these awesome projects!
- [mailcow-dockerized](https://github.com/mailcow/mailcow-dockerized)
- [borgbackup](https://github.com/borgbackup/borg)

Unlike the provided helper-scripts/backup_and_restore.sh, this one uses borgbackup which works incrementally and does not need to tar everything at every single backup.
Means it is very, very, very much faster and saves a huge amount of storage space!


## Backup
This script disables dovecot and postfix at first and lets nginx just return a 503-Error, to ensure no files will be changed during backup process.
Next it prepares the backup (database dump, etc.), when done triggers the borgbackup itself and saves all the data.
Afterwards the stopped services are started again and temporary files are cleaned up.

Its pretty easy to use: adjust (system and borg variables) to your needs and run manually or as a cronjob (example in script) while mailcow is running.
If you have added or customized some mailcow files or configurations just add them to the borg create command.

Dont forget to prune your borg repository from time to time. For example an extra cron on the borg-host-system - if external.


## Restore
**_! not finally tested for production yet_**

Steps to restore:
- adjust the scripts settings-variables
- extract your borg repository snapshot completely into `restoreVolumesFrom="/path/to/extracted/borgbackup"`
- install mailcow as [shown](https://mailcow.github.io/mailcow-dockerized-docs/i_u_m_install/)
- adjust paths in new mailcow.conf as in old installation
- start it once, to create all required files and directories and stop it again\
`docker-compose pull`, `docker-compose up`, wait a few minutes until setup is done, `control+c`
- run restore.sh when containers are completely downed
- start mailcow again and check if everything worked
