#!/bin/bash
# Maintained by: Matt Weppler, matt@weppler.me, @mattweppler
# http://matt.weppler.me

# start the path variable
PATH=''

# editors
EDITOR='vim'
SVN_EDITOR='vim'
VISUAL='vim'

# path
PATH=$PATH:$HOME/developer/bin
PATH=$PATH:/usr/local/bin
PATH=$PATH:/usr/local/sbin
PATH=$PATH:/Developer/usr/bin
PATH=$PATH:/Applications

# normal path stuff
PATH=$PATH:/usr/bin:/bin:/usr/sbin:/sbin

if [ -f $HOME/developer/private/shell_exts/main.sh ] ; then
  source $HOME/developer/private/shell_exts/main.sh
fi

if [ -f $HOME/developer/public/shell_exts/main.sh ] ; then
  source $HOME/developer/public/shell_exts/main.sh
fi

# use unset ENV_VAR to remove an environment variable (where ENV_VAR is something like PATH, etc.)

PS1="\[\033[0;32m\]($?):\[\033[0;33m\]\u\[\033[1;30m\]@\h \[\033[0;32m\]:\[\033[00m\] "
PS2="\[\033[0;32m\] > \[\033[0;33m\] > \[\033[1;30m\] > \[\033[00m\] "

export EDITOR
export PATH
export PS1
export PS2
export SVN_EDITOR
export VISUAL

PLATFORM=`uname`
#if [ $PLATFORM = 'Linux' ] ; then
  #echo 'linux'
#elif [ $PLATFORM = 'Darwin' ] ; then
  #echo 'darwin'
#fi

HOSTNAME=`hostname`
#if [ $HOSTNAME = 'localhost' ] ; then
  # ...
#elif [ $HOSTNAME = 'local' ] ; then
  # ...
#else
  # ...
#fi
