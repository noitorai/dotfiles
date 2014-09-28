INFO_FILE="${HOME}/.ssh-agent"
PID_FILE="${HOME}/.ssh-agent.pid"
GREP=

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

set_grep() {
        if [ ! "x${GREP}" = "x" ] ; then
              return 0
        fi

        if [ is_debian = 0 -o is_ubuntu = 0 ] ; then
                GREP="/bin/grep"
        elif is_solaris ; then
                GREP="/usr/sfw/bin/ggrep"
        else
                GREP="/bin/grep"
        fi
        return 0
}

check_sshagent() {
    set_grep
    pgrep -V |grep 3.3.9 >/dev/null
    if [ $? -eq 0 ] ; then
      pgrep_op="-a"
    else
      pgrep_op="-lf"
    fi
    pgrep ${pgrep_op} -u ${USER} ssh-agent | ${GREP} -E -- "-a +${INFO_FILE}"
    return $?
}

load_sshagent() {
    check_sshagent
    if [ $? -ne 0 ] ; then
        if [ -e ${PID_FILE} ] ; then
            rm ${PID_FILE}
        fi
        ssh-agent -s -t 4h30m -a ${PID_FILE} >${INFO_FILE}
    fi
    source ${INFO_FILE}

    # add key if not exists
    if ! ssh-add -l ; then
        ssh-add
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
    `which ssh` $@
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
