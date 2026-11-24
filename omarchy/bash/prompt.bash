# Agnoster-style prompt for bash: a port of mattweppler-agnoster.zsh-theme.
#
# Replaces Omarchy's starship prompt. Starship can't do agnoster's arrow
# transitions (each arrow is coloured by the segment on BOTH sides, and most
# segments are optional), so this draws the prompt itself, like the zsh theme.
#
# Segments, left to right, each shown only when relevant:
#   status   ✘ <exit code>, ⚡ root, ⚙ background jobs     black
#   venv     (name), only when VIRTUAL_ENV_DISABLE_PROMPT    blue
#   context  user@host, only over SSH or as another user     black
#   dir      last two path components                        blue
#   git      branch, ● unstaged, ✚ staged, >M< >R> <B>       green clean / yellow dirty
#   duration ⏱ Ns, when the last command took 5s or more     magenta
#
# The [INSERT]/[NORMAL] vi-mode block in front of it is drawn by readline
# (see inputrc), because bash gives the prompt no way to see the vi keymap.
#
# Untrusted text (directory names, branch names, $USER) is never pasted into
# PS1 directly: PS1 undergoes command substitution, so a branch named
# '$(rm -rf ~)' would run. Instead each piece is stored in __mw_txt and PS1
# references it as ${__mw_txt[N]}; expanded variable values are not re-expanded.

__mw_sep=$''      # powerline right arrow
__mw_branch=$''   # powerline branch glyph
__mw_default_user=${__mw_default_user:-$USER}

declare -A __mw_col=([black]=0 [red]=1 [green]=2 [yellow]=3 [blue]=4 [magenta]=5 [cyan]=6 [white]=7)

# __mw_seg <bg> <fg> <text> [raw]
# Appends a segment. With "raw", <text> is trusted prompt markup and is
# inserted as-is; otherwise it is stored and referenced (see header).
__mw_seg() {
  local bg=$1 fg=$2 bgc fgc
  if [[ $bg == default ]]; then bgc=49; else bgc=$((40 + __mw_col[$bg])); fi
  if [[ $fg == default ]]; then fgc=39; else fgc=$((30 + __mw_col[$fg])); fi

  if [[ $__mw_bg != NONE && $bg != "$__mw_bg" ]]; then
    __mw_ps+=" \[\e[${bgc}m\e[$((30 + __mw_col[$__mw_bg]))m\]${__mw_sep}\[\e[${fgc}m\] "
  else
    __mw_ps+="\[\e[${bgc}m\e[${fgc}m\] "
  fi
  __mw_bg=$bg

  if [[ ${4-} == raw ]]; then
    __mw_ps+=$3
  else
    __mw_txt+=("$3")
    __mw_ps+="\${__mw_txt[$(( ${#__mw_txt[@]} - 1 ))]}"
  fi
}

__mw_prompt() {
  local rv=$? dur=0
  if [[ -n ${__mw_t0-} ]]; then
    dur=$((SECONDS - __mw_t0))
    unset __mw_t0
  fi

  __mw_ps='\[\e[0m\]'
  __mw_bg=NONE
  __mw_txt=()

  # status
  local sym=()
  (( rv != 0 )) && sym+=("\[\e[31m\]✘ $rv")
  (( EUID == 0 )) && sym+=("\[\e[33m\]⚡")
  [[ -n $(jobs -p) ]] && sym+=("\[\e[36m\]⚙")
  (( ${#sym[@]} )) && __mw_seg black default "${sym[*]}" raw

  # virtualenv
  if [[ -n ${VIRTUAL_ENV-} && -n ${VIRTUAL_ENV_DISABLE_PROMPT-} ]]; then
    __mw_seg blue black "(${VIRTUAL_ENV##*/})"
  fi

  # context
  if [[ $USER != "$__mw_default_user" || -n ${SSH_CLIENT-} ]]; then
    if (( EUID == 0 )); then
      __mw_seg black yellow "$USER@${HOSTNAME%%.*}"
    else
      __mw_seg black default "$USER@${HOSTNAME%%.*}"
    fi
  fi

  # dir: like zsh's %2~
  local d=${PWD/#"$HOME"/\~}
  [[ $d == ?*/*/* ]] && d=${d#"${d%/*/*}/"}
  __mw_seg blue black "$d"

  # git
  local gitdir inside
  { read -r gitdir; read -r inside; } < <(git rev-parse --git-dir --is-inside-work-tree 2>/dev/null)
  if [[ $inside == true ]]; then
    local ref st line unstaged="" staged="" mode=""
    ref=$(git symbolic-ref --short HEAD 2>/dev/null) || ref="➦ $(git rev-parse --short HEAD 2>/dev/null)"
    st=$(git status --porcelain --ignore-submodules=dirty 2>/dev/null)
    while IFS= read -r line; do
      [[ -z $line ]] && continue
      [[ ${line:0:1} != [\ ?] ]] && staged="✚"
      [[ ${line:1:1} != [\ ?] ]] && unstaged="●"
    done <<< "$st"

    if [[ -e $gitdir/BISECT_LOG ]]; then
      mode=" <B>"
    elif [[ -e $gitdir/MERGE_HEAD ]]; then
      mode=" >M<"
    elif [[ -e $gitdir/rebase || -e $gitdir/rebase-apply || -e $gitdir/rebase-merge || -e $gitdir/../.dotest ]]; then
      mode=" >R>"
    fi

    local text="$__mw_branch $ref"
    [[ -n $unstaged$staged ]] && text+=" $unstaged$staged"
    text+=$mode

    if [[ -n $st ]]; then
      __mw_seg yellow black "$text"
    else
      __mw_seg green black "$text"
    fi
  fi

  # duration
  (( dur >= 5 )) && __mw_seg magenta white "⏱ ${dur}s"

  # end: close the last segment onto the default background
  __mw_ps+=" \[\e[49m\e[$((30 + __mw_col[$__mw_bg]))m\]${__mw_sep}\[\e[0m\] "
  PS1=$__mw_ps
  return $rv
}

# Command timer: PS0 is expanded just before a command runs, in this shell, so
# the arithmetic side effect records the start time (same trick starship uses).
# The offset is only evaluated when the variable being sliced is non-empty,
# hence the always-set anchor.
__mw_anchor=x
__mw_ps0='${__mw_anchor:$((__mw_t0=SECONDS,0)):0}'

# Take over from starship, which Omarchy's bash rc has already initialised.
# Starship replaces PROMPT_COMMAND with starship_precmd and stashes whatever
# was there before (mise, ...) in STARSHIP_PROMPT_COMMAND; restore that, drop
# starship's hooks, and put __mw_prompt first so it sees the real $?.
if [[ $PROMPT_COMMAND != *__mw_prompt* ]]; then
  __mw_pc=${PROMPT_COMMAND//starship_precmd/}
  __mw_pc=${__mw_pc#;}
  if [[ $PROMPT_COMMAND == *starship_precmd* && -n ${STARSHIP_PROMPT_COMMAND-} ]]; then
    __mw_pc="${STARSHIP_PROMPT_COMMAND}${__mw_pc:+;$__mw_pc}"
  fi
  PROMPT_COMMAND="__mw_prompt${__mw_pc:+;$__mw_pc}"
  unset __mw_pc

  [[ ${PS0-} == *starship_preexec_ps0* ]] && PS0=""
  if [[ $(trap -p DEBUG) == *starship_preexec* && -z ${STARSHIP_DEBUG_TRAP-} ]]; then
    trap - DEBUG
  fi
  PS0="${__mw_ps0}${PS0-}"
fi
