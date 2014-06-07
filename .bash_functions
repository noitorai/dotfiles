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
