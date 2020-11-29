#!/bin/bash

########################################
#                                      #
#         Mailcow Borg Restore         #
#                                      #
########################################
# Author:       Matthis B.             #
# Created:      20201106               #
# Lastchange:   20201129               #
########################################
# Changelog:                           #
# - 20201106: init                     #
# - 20201107: small changes            #
# - 20201129: fix shellcheck warnings  #
########################################

#
# Settings
#

dockerDir="/opt/mailcow-dockerized"						# path to docker-compose.yml

restoreVolumesFrom="/path/to/extracted/borgbackup"		# path to EXTRACTED backup directory
restoreVolumesTo="/var/lib/docker/volumes"				# path to volumes directory


dirnameVMail="mailcowdockerized_vmail-vol-1"
dirnameCrypt="mailcowdockerized_crypt-vol-1"
dirnameRedis="mailcowdockerized_redis-vol-1"
dirnameRSpamd="mailcowdockerized_rspamd-vol-1"
dirnamePostfix="mailcowdockerized_postfix-vol-1"
dirnameMySQL="mailcowdockerized_mysql-vol-1"



#
# Pre-Restore
#
if [[ "$(id -u)" != "0" ]] ; then
  echo "- ERROR: no root!"
  exit 1
fi
if [[ ! -d "${dockerDir}" ]] ; then
  echo "- ERROR: docker directory does not exist (${dockerDir})!"
  exit 1
fi
if [[ ! -d "${restoreVolumesFrom}" ]] ; then
  echo "- ERROR: directory to restore data from does not exist (${restoreVolumesFrom})!"
  exit 1
fi
if [[ ! -d "${restoreVolumesTo}" ]] ; then
  echo "- ERROR: volumes directory does not exist (${restoreVolumesTo})!"
  echo "- HINT: before running this script you have to install and start+stop mailcow once!"
  exit 1
fi
volumeDirs=("$dirnameVMail" "$dirnameCrypt" "$dirnameRedis" "$dirnameRSpamd" "$dirnamePostfix" "$dirnameMySQL")
for dir in "${volumeDirs[@]}" ; do
  dir="${restoreVolumesTo}/${dir}"
  if [[ ! -d "$dir" ]] ; then
    echo "- ERROR: volume directory does not exist (${dir})!"
    echo "- HINT: before running this script you have to install and start+stop mailcow once!"
    exit 1
  fi
done


#
# Restore
#
echo "- start restoring data"

echo
echo "-- vmail"
echo "--- ${restoreVolumesFrom}${restoreVolumesTo}/${dirnameVMail}/ -> ${restoreVolumesTo}/${dirnameVMail}/"
rm -rf "${restoreVolumesTo:?}/${dirnameVMail}/"*
rsync -axh --stats "${restoreVolumesFrom}${restoreVolumesTo}/${dirnameVMail}/" "${restoreVolumesTo}/${dirnameVMail}/"

echo
echo "-- crypt"
echo "--- ${restoreVolumesFrom}${restoreVolumesTo}/${dirnameCrypt}/ -> ${restoreVolumesTo}/${dirnameCrypt}/"
rm -rf "${restoreVolumesTo:?}/${dirnameCrypt}/"*
rsync -axh --stats "${restoreVolumesFrom}${restoreVolumesTo}/${dirnameCrypt}/" "${restoreVolumesTo}/${dirnameCrypt}/"

echo
echo "-- redis"
echo "--- ${restoreVolumesFrom}${restoreVolumesTo}/${dirnameRedis}/ -> ${restoreVolumesTo}/${dirnameRedis}/"
rm -rf "${restoreVolumesTo:?}/${dirnameRedis}/"*
rsync -axh --stats "${restoreVolumesFrom}${restoreVolumesTo}/${dirnameRedis}/" "${restoreVolumesTo}/${dirnameRedis}/"

echo
echo "-- rspamd"
echo "--- ${restoreVolumesFrom}${restoreVolumesTo}/${dirnameRSpamd}/ -> ${restoreVolumesTo}/${dirnameRSpamd}/"
rm -rf "${restoreVolumesTo:?}/${dirnameRSpamd}/"*
rsync -axh --stats "${restoreVolumesFrom}${restoreVolumesTo}/${dirnameRSpamd}/" "${restoreVolumesTo}/${dirnameRSpamd}/"

echo
echo "-- postfix"
echo "--- ${restoreVolumesFrom}${restoreVolumesTo}/${dirnamePostfix}/ -> ${restoreVolumesTo}/${dirnamePostfix}/"
rm -rf "${restoreVolumesTo:?}/${dirnamePostfix}/"*
rsync -axh --stats "${restoreVolumesFrom}${restoreVolumesTo}/${dirnamePostfix}/" "${restoreVolumesTo}/${dirnamePostfix}/"

echo
echo "-- mysql"
echo "--- ${restoreVolumesFrom}${restoreVolumesTo}/${dirnameMySQL}/_data/tmp_backup/ -> ${restoreVolumesTo}/${dirnameMySQL}/_data/"
rm -rf "${restoreVolumesTo:?}/${dirnameMySQL}/"*
rsync -axh --stats "${restoreVolumesFrom}${restoreVolumesTo}/${dirnameMySQL}/_data/tmp_backup/" "${restoreVolumesTo}/${dirnameMySQL}/_data/"

echo
echo "-- mailcow"
echo "--- ${restoreVolumesFrom}/${dockerDir}/ -> ${dockerDir}/"
rsync -axh --stats "${restoreVolumesFrom}${dockerDir}/" "${dockerDir}/"



#
# Pre-Restore
#

echo
echo "- Done!"
echo "- You should be able to start your mailcow as usual (docker-compose up -d)."
echo "- Have fun :)"
