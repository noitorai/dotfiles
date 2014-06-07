# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

BASH_FUNCTIONS_FILE="${HOME}/.bash_functions"

if [ -e ${BASH_FUNCTIONS_FILE} ] ; then
    source ${BASH_FUNCTIONS_FILE}
    LOGIN_COUNT=$(who | grep ${USER} | wc -l | sed -e "s/ *//")
    if [ $LOGIN_COUNT -eq 1 ] ; then
        terminate_sshagent
    fi
fi

