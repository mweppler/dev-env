# .zshrc
# Maintained by: Matt Weppler, matt@weppler.me, @mattweppler
# http://matt.weppler.me

# start the path variable
PATH=''

# editors
EDITOR='mvim -f'
SVN_EDITOR='mvim -f'
VISUAL='mvim -f'

# path
PATH=$PATH:$HOME/developer/bin
PATH=$PATH:/usr/local/bin
PATH=$PATH:/usr/local/sbin
PATH=$PATH:/Developer/usr/bin
PATH=$PATH:/Applications

# normal path stuff
PATH=$PATH:/usr/bin:/bin:/usr/sbin:/sbin

ZSH=$HOME/.oh-my-zsh

if [ -f $ZSH/oh-my-zsh.sh ] ; then
  source $ZSH/oh-my-zsh.sh
fi

# Path to your sh extensions.
PRIV_SH_EXTS=$HOME/developer/private/shell_exts

PUB_SH_EXTS=$HOME/developer/public/shell_exts

if [ -f $PRIV_SH_EXTS/main.sh ] ; then
  source $PRIV_SH_EXTS/main.sh
fi

if [ -f $PUB_SH_EXTS/main.sh ] ; then
  source $PUB_SH_EXTS/main.sh
fi

# use unset ENV_VAR to remove an environment variable (where ENV_VAR is something like PATH, etc.)

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
#elif [ $HOSTNAME = '' ] ; then
  # ...
#else
  # ...
#fi
