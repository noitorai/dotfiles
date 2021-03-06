# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
for d in $HOME/{,.local/,local/}bin
do
    if [ -d "$d" ] ; then
        PATH="$d:$PATH"
    fi
done

export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin

env PATH="$HOME/.rbenv/bin:$PATH" which rbenv >/dev/null
if [ $? -eq 0 ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

if [ "x$DISPLAY" = "x" ]; then
  export DISPLAY=127.0.0.1:0.0
fi
