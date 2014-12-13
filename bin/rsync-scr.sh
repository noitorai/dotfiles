#!/bin/sh

# TODO: description this script
# TODO: usage
# TODO: --version option
# TODO: option to set CONF_DIR

CONF_DIR=${HOME}/conf
CONF_FILENAME=rsync-scr.conf
CONF_FILE_PATH=${CONF_DIR}/${CONF_FILENAME}
if [ -r ${CONF_FILE_PATH} ]; then
        . ${CONF_FILE_PATH}
else
        echo "ERROR: This script requires ${CONF_FILE_PATH}"
        exit
fi

for i in "x${DST_HOST}" "x${DST_DIR}" "x${DST_USER}" "x${SRC_DIR}"
do
        # degug
        # echo $i
        if [ $i = "x" ]; then
                echo "ERROR: follwing variables not defined"
                echo "ERROR:   DST_HOST or DST_DIR or DST_USER or SRC_DIR"
                exit
        fi
done

OPT=
# debug
# OPT="--dry-run"
rsync -av -e ssh ${OPT} ${SRC_DIR} ${DST_USER}@${DST_HOST}:${DST_DIR}
