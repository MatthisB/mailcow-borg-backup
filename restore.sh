#!/bin/bash

###############################
#                             #
#     Mailcow Borg Restore    #
#                             #
###############################
# Author:       Matthis B.    #
# Created:      20201106      #
# Lastchange:   20201106      #
###############################
# Changelog:                  #
# - 20201106: init            #
###############################

#
# Settings
#

dockerDir="/opt/mailcow-dockerized"

restoreVolumesFrom="/path/to/extracted/borgbackup"
restoreVolumesTo="/var/lib/docker/volumes"

dirnameVMail="mailcowdockerized_vmail-vol-1"
dirnameCrypt="mailcowdockerized_crypt-vol-1"
dirnameRedis="mailcowdockerized_redis-vol-1"
dirnameRSpamd="mailcowdockerized_rspamd-vol-1"
dirnamePostfix="mailcowdockerized_postfix-vol-1"
dirnameMySQL="mailcowdockerized_mysql-vol-1"



#
# Pre-Restore
#
if [[ ! -d "${dockerDir}" ]] ; then
  echo "- ERROR: docker directory does not exist (${dockerDir})!"
  exit 1
fi
if [[ ! -d "${restoreVolumesFrom}" ]] ; then
  echo "- ERROR: directory to restore data from does not exist (${restoreVolumesFrom})!"
  exit 1
fi
if [[ ! -d "${restoreVolumesTo}" ]] ; then
  echo "- ERROR: before running this script you have to install and start+stop mailcow once!"
  exit 1
fi



#
# Restore
#
echo "- start restoring data"

echo
echo "-- vmail"
rm -rf "${restoreVolumesTo}/${dirnameVMail}/"/*
rsync -avx "${restoreVolumesFrom}/${restoreVolumesTo}/${dirnameVMail}/" "${restoreVolumesTo}/${dirnameVMail}/"

echo
echo "-- crypt"
rm -rf "${restoreVolumesTo}/${dirnameCrypt}/"/*
rsync -avx "${restoreVolumesFrom}/${restoreVolumesTo}/${dirnameCrypt}/" "${restoreVolumesTo}/${dirnameCrypt}/"

echo
echo "-- redis"
rm -rf "${restoreVolumesTo}/${dirnameRedis}/"/*
rsync -avx "${restoreVolumesFrom}/${restoreVolumesTo}/${dirnameRedis}/" "${restoreVolumesTo}/${dirnameRedis}/"

echo
echo "-- rspamd"
rm -rf "${restoreVolumesTo}/${dirnameRSpamd}/"/*
rsync -avx "${restoreVolumesFrom}/${restoreVolumesTo}/${dirnameRSpamd}/" "${restoreVolumesTo}/${dirnameRSpamd}/"

echo
echo "-- postfix"
rm -rf "${restoreVolumesTo}/${dirnamePostfix}/"/*
rsync -avx "${restoreVolumesFrom}/${restoreVolumesTo}/${dirnamePostfix}/" "${restoreVolumesTo}/${dirnamePostfix}/"

echo
echo "-- mysql"
rm -rf "${restoreVolumesTo}/${dirnameMySQL}/"/*
rsync -avx "${restoreVolumesFrom}/${restoreVolumesTo}/${dirnameMySQL}/_data/tmp_backup/" "${restoreVolumesTo}/${dirnameMySQL}/_data/"

echo
echo "-- mailcow"
rsync -avx "${restoreVolumesFrom}${dockerDir}/" "${dockerDir}/"



#
# Pre-Restore
#

echo
echo "- Done!"
echo "- You should be able to start your mailcow as usual."
echo "- Have fun :)"
