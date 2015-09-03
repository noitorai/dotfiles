#!/bin/bash
#
# locates dot files to user's home directory
#

SETUP_DIR=`dirname $0`
expr "$0" : "/.*" >/dev/null || SETUP_DIR=`(cd ${SETUP_DIR} && pwd) `

prepare_dir() {

        DIR=${HOME}/$1 

        if [ ! -e ${DIR} ]; then
                mkdir -p ${DIR}
        fi

        if [ ! -d ${DIR} -o ! -r ${DIR} ]; then
                echo "$0: failed to prepare ${DIR}"
                exit 1
        fi
}

set -x

for d in "bin" "conf"
do
        prepare_dir $d
done

for d in "." "bin" "conf"
do
        files=`find ${SETUP_DIR}/$d  -maxdepth 1`
        for f in ${files}
        do
                ln -s ${SETUP_DIR}/$d/$f ${HOME}/
        done
done

set +x
