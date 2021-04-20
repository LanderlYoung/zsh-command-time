_command_time_preexec() {
  # check excluded
  if [ -n "$ZSH_COMMAND_TIME_EXCLUDE" ]; then
    cmd="$1"
    for exc ($ZSH_COMMAND_TIME_EXCLUDE) do;
      if [ "$(echo $cmd | grep -c "$exc")" -gt 0 ]; then
        # echo "command excluded: $exc"
        return
      fi
    done
  fi

  __zsh_extesion_command_time_var_timer=${__zsh_extesion_command_time_var_timer:-$SECONDS}
  ZSH_COMMAND_TIME_COLOR=${ZSH_COMMAND_TIME_COLOR:-"cyan"}
}

_command_time_precmd() {
  if [ $__zsh_extesion_command_time_var_timer ]; then
    local time_diff=$(($SECONDS - $__zsh_extesion_command_time_var_timer))
    if [ -n "$TTY" ] && [ $time_diff -ge ${ZSH_COMMAND_TIME_MIN_SECONDS:-3} ]; then
      zsh_command_time "$time_diff"
    fi
  fi
  unset __zsh_extesion_command_time_var_timer
}

zsh_command_time() {
  local ZSH_COMMAND_TIME=$1
  if [ -n "$ZSH_COMMAND_TIME" ]; then
      if [[ ${ZSH_COMMAND_TIME} -ge $((60 * 60)) ]]; then
        local msg=$(printf '%dh:%dm:%ds' $(($ZSH_COMMAND_TIME/3600)) $(($ZSH_COMMAND_TIME%3600/60)) $(($ZSH_COMMAND_TIME%60)))
      elif [[ ${ZSH_COMMAND_TIME} -ge $((60)) ]]; then
        msg=$(printf '%dm:%ds' $(($ZSH_COMMAND_TIME%3600/60)) $(($ZSH_COMMAND_TIME%60)))
      else
        msg=$(printf '%ds' $(($ZSH_COMMAND_TIME)))
      fi
      export RPROMPT="%F{${ZSH_COMMAND_TIME_COLOR}}${msg}" #%{$reset_color%}"`
  fi
}

precmd_functions+=(_command_time_precmd)
preexec_functions+=(_command_time_preexec)
