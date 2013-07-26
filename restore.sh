#!/bin/bash
# A shell script to update large SQL dumps for quicker restoration.
# Usage: ./restore.sh dump.sql
#
# Author: Michael de Silva (michael@mwdesilva.com / http://github.com/bsodmike)

(( $# != 1 )) && { echo "Usage: $0 dump.sql"; exit 1; }
[ ! -f $1 ] && { echo "$1 not found1"; exit 1; }

echo "SET AUTOCOMMIT=0;
SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;" > restore.sql
cat $1 >> restore.sql
echo "SET FOREIGN_KEY_CHECKS=1;
SET UNIQUE_CHECKS=1;
SET AUTOCOMMIT=1;" >> restore.sql
echo "COMMIT;" >> restore.sql
