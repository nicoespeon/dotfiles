# nicolas.zsh-theme
# Forked from avit: https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/avit.zsh-theme

PROMPT='
$(_user_host)${_current_dir} $(git_prompt_info)
%{$fg[$CARETCOLOR]%}▶%{$resetcolor%} '

PROMPT2='%{$fg[$CARETCOLOR]%}◀%{$reset_color%} '

RPROMPT='$(_vi_status)%{$(echotc UP 1)%}$(_cmd_exec_time)%{$fg[white]%}%D{%H:%M:%S}%{$reset_color%} $(git_prompt_status) ${_return_status}%{$(echotc DO 1)%}'

local _current_dir="%{$fg_bold[blue]%}%3~%{$reset_color%} "
local _return_status="%{$fg_bold[red]%}%(?..⍉)%{$reset_color%}"
local _hist_no="%{$fg[grey]%}%h%{$reset_color%}"

function _current_dir() {
  local _max_pwd_length="65"
  if [[ $(echo -n $PWD | wc -c) -gt ${_max_pwd_length} ]]; then
    echo "%{$fg_bold[blue]%}%-2~ ... %3~%{$reset_color%} "
  else
    echo "%{$fg_bold[blue]%}%~%{$reset_color%} "
  fi
}

function _user_host() {
  if [[ -n $SSH_CONNECTION ]]; then
    me="%n@%m"
  elif [[ $LOGNAME != $USER ]]; then
    me="%n"
  fi
  if [[ -n $me ]]; then
    echo "%{$fg[cyan]%}$me%{$reset_color%}:"
  fi
}

zmodload zsh/datetime

_cmd_timer_preexec() {
  _cmd_start=$EPOCHREALTIME
}

_cmd_timer_precmd() {
  if [[ -n $_cmd_start ]]; then
    local elapsed=$(( EPOCHREALTIME - _cmd_start ))
    local ms=$(( elapsed * 1000 ))
    unset _cmd_start

    if (( ms < 2000 )); then
      unset _cmd_exec_time_str
      return
    elif (( elapsed < 60 )); then
      _cmd_exec_time_str="$(printf '%.1fs' $elapsed)"
    elif (( elapsed < 3600 )); then
      _cmd_exec_time_str="$(( ${elapsed%.*} / 60 ))m$(( ${elapsed%.*} % 60 ))s"
    else
      _cmd_exec_time_str="$(( ${elapsed%.*} / 3600 ))h$(( (${elapsed%.*} % 3600) / 60 ))m"
    fi
  else
    unset _cmd_exec_time_str
  fi
}

function _cmd_exec_time() {
  if [[ -n $_cmd_exec_time_str ]]; then
    echo "%{$fg[yellow]%}(${_cmd_exec_time_str})%{$reset_color%} "
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _cmd_timer_preexec
add-zsh-hook precmd _cmd_timer_precmd

function _vi_status() {
  if {echo $fpath | grep -q "plugins/vi-mode"}; then
    echo "$(vi_mode_prompt_info)"
  fi
}

if [[ $USER == "root" ]]; then
  CARETCOLOR="red"
else
  CARETCOLOR="white"
fi

MODE_INDICATOR="%{$fg_bold[yellow]%}❮%{$reset_color%}%{$fg[yellow]%}❮❮%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}⚑ "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖ "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}▴ "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}§ "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%}◒ "

ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[white]%}"

export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
export GREP_COLOR='1;33'
