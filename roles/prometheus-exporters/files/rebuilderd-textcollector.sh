#!/bin/bash

set -o errexit
set -o nounset

HOSTNAME=$(hostname)
TEXTFILE_COLLECTOR_DIR=${1}
PROM_FILE=$TEXTFILE_COLLECTOR_DIR/rebuilderd.prom

TMP_FILE=$PROM_FILE.$$
[ -e $TMP_FILE ] && rm -f $TMP_FILE

queuelength=$(rebuildctl queue ls --json | jq '.queue | length')

echo "# HELP rebuilderd_queue_length number of packages in rebuilderd queue" >> $TMP_FILE
echo "# TYPE rebuilderd_queue_length gauge" >> $TMP_FILE
echo "rebuilderd_queue_length{host=\"${HOSTNAME}\"} $queuelength" >> $TMP_FILE

mv -f $TMP_FILE $PROM_FILE
