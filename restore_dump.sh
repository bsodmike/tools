#!/bin/bash
# A shell script to restore a large SQL dump using root login.
# Usage: ./restore_dump.sh dump.sql app_devdb
#
# Author: Michael de Silva (michael@mwdesilva.com / http://github.com/bsodmike)

(( $# != 2 )) && { echo "Usage: $0 dump.sql database_name"; exit 1; }
[ ! -f $1 ] && { echo "$1 not found1"; exit 1; }

RESULT=`mysql -u root -p --skip-column-names -e "SHOW DATABASES LIKE '$2'"`
if [ "$RESULT" != $2 ]; then
    echo "Database '$2' does not exist; creating it...";
    mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS $2;"
    [ $? -ne 0 ] && { echo "Unknown error in attempting to create database '$2'"; exit 1; }
fi

(
  echo "SET AUTOCOMMIT=0;"
  echo "SET UNIQUE_CHECKS=0;"
  echo "SET FOREIGN_KEY_CHECKS=0;"
  cat $1
  echo "SET FOREIGN_KEY_CHECKS=1;"
  echo "SET UNIQUE_CHECKS=1;"
  echo "SET AUTOCOMMIT=1;"
  echo "COMMIT;"
) | mysql -o -u root -p "$2"
