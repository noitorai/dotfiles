CONF_DIR=${HOME}/conf
CONF_FILENAME=bash_functions.conf
CONF_FILE_PATH=${CONF_DIR}/${CONF_FILENAME}

[ -r ${CONF_FILE_PATH}.default ] && . ${CONF_FILE_PATH}.default 
[ -r ${CONF_FILE_PATH} ] && . ${CONF_FILE_PATH}
if [ ! -r ${CONF_FILE_PATH}.default -a ! -r ${CONF_FILE_PATH} ]; then
    echo "WARN: This script requires ${CONF_FILE_PATH} or ${CONF_FILE_PATH}.default"
fi
if [ "x${INFO_FILE}" = "x" ]; then
    INFO_FILE="${HOME}/.ssh-agent"
fi
if [ "x${PID_FILE}" = "x" ]; then
    PID_FILE="${HOME}/.ssh-agent.pid"
fi
if [ "x${SSH_AGENT_LIFETIME}" = "x" ]; then
    SSH_AGENT_LIFETIME="8h"
fi

is_debian() {
    if [ ! -x /usr/bin/lsb_release ] ; then
        return 1
    fi
    lsb_release -a |grep Debian >/dev/null 2>&1
    return $?
}

is_ubuntu() {
    if [ ! -x /usr/bin/lsb_release ] ; then
        return 1
    fi
    lsb_release -a |grep Ubuntu >/dev/null 2>&1
    return $?
}

is_solaris() {
   if [ ! -r /etc/release ] ; then
           return 1
   fi
   cat /etc/release |grep Solaris >/dev/null 2>&1
   return $?
}

is_rhel() {
  if [ ! -e /etc/redhat-release ] ; then
          return 1
  fi
  return 0
}

set_grep() {
        if [ ! "x${GREP}" = "x" ] ; then
              return 0
        fi

        if [ is_debian = 0 -o is_ubuntu = 0 ] ; then
                GREP="/bin/grep"
        elif is_solaris ; then
                GREP="/usr/sfw/bin/ggrep"
        elif [ is_rhel = 0 ]; then
                GREP="/usr/bin/grep"
        else
                GREP="/bin/grep"
        fi
        return 0
}

check_sshagent() {
    set_grep
    which pgrep >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        pgrep_op="-a"
        pgrep ${pgrep_op} -u ${USER} ssh-agent | ${GREP} -E -- "-a +${INFO_FILE}"
        return $?
    else
        ps -efu ${USER} |${GREP} ssh-agent >/dev/null
        return $?
    fi
}

load_sshagent() {
    check_sshagent
    if [ $? -ne 0 ] ; then
        if [ -e ${PID_FILE} ] ; then
            rm ${PID_FILE}
        fi
        ssh-agent -s -t ${SSH_AGENT_LIFETIME} -a ${PID_FILE} >${INFO_FILE}
    fi
    source ${INFO_FILE}

    # add key if not exists
    if ! ssh-add -l ; then
        ssh-add
        [ -r ~/.ssh/nii-vm.key ] && ssh-add ~/.ssh/nii-vm.key
    fi

}
terminate_sshagent() {
    if check_sshagent ; then
        source ${INFO_FILE}
        ssh-agent -k
    fi
}

ssh_chkagent() {
    load_sshagent
    `type -P ssh` $@
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

pls_usage() {
        echo "usage: $0 [option] [pattern1] [pattern2]..."
}

pls() {

        if [ $# -eq 0 ]; then
                pls_usage
                exit 1
        fi
        
        lspat="*"
        grpat=""
        while [ $# -gt 0 ]
        do
                lspat="${lspat}$1*"
                if [ "x${grpat}" = "x" ]; then
                        grpat=$1
                else
                        grpat="${grpat}\|$1"
                fi
                shift
        done
        
        ls -altr $lspat |grep --color "$grpat"
}
