INFO_FILE="${HOME}/.ssh-agent"
PID_FILE="${HOME}/.ssh-agent.pid"

check_sshagent() {
    pgrep -lf -u ${USER} ssh-agent | grep -E -- "-a +${INFO_FILE}"
    return $?
}

load_sshagent() {
    if check_sshagent ; then
        source ${INFO_FILE}
    else
        if [ -e ${PID_FILE} ] ; then
            rm ${PID_FILE}
        fi 
        ssh-agent -s -a ${PID_FILE} >${INFO_FILE}
        source ${INFO_FILE}
    fi
}

terminate_sshagent() {
    if check_sshagent ; then
        source ${INFO_FILE}
        ssh-agent -k
    fi
}

### config for saving script 
#local SCRIPTDIR=~/scr
#local TIMING=timing
SCRIPTDIR=~/scr
TIMING=timing

function scr {
    if [ ! -e ${SCRIPTDIR} ]; then
        mkdir -p ${SCRIPTDIR}
    fi
    ARG=$1
#    local SCRIPTFILE=${SCRIPTDIR}/`date "+%F_%H%M_%s"`_${ARG}
    local SCRIPTFILE=${SCRIPTDIR}/`date "+%F_%H%M_%S"`_${ARG}
#    LANG=C script -t -f ${SCRIPTFILE} 2> ${SCRIPTFILE}.${TIMING}
    LANG=C script ${SCRIPTFILE}
    gzip ${SCRIPTFILE}
#    gzip ${SCRIPTFILE}.${TIMING}
}

function scrreplay {
    SCRIPTFILE=${1%.gz}
    gunzip ${SCRIPTFILE}.gz
#    gunzip ${SCRIPTFILE}.${TIMING}.gz
    echo
#    echo "scriptreplay:begin $1 / divisor=$2"
    echo "scriptreplay:begin $1"
    echo
#    scriptreplay ${SCRIPTFILE}.${TIMING} ${SCRIPTFILE} $2
#    scriptreplay ${SCRIPTFILE}
    cat ${SCRIPTFILE}
    echo
    echo "scriptreplay:end"
    echo
    gzip ${SCRIPTFILE}
#    gzip ${SCRIPTFILE}.${TIMING}
}
