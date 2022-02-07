_command_time_preexec() {
  # check excluded
  if [ -n "$ZSH_COMMAND_TIME_EXCLUDE" ]; then
    local cmd="$1"
    for exc ($ZSH_COMMAND_TIME_EXCLUDE) do;
      if [[ "$cmd" == "$exc" ]]; then
        # echo "command excluded: $exc"
        return
      fi
    done
  fi

  __zsh_extesion_command_time_var_timer=${__zsh_extesion_command_time_var_timer:-$SECONDS}
  ZSH_COMMAND_TIME_COLOR=${ZSH_COMMAND_TIME_COLOR:-"cyan"}
}

_command_time_precmd() {
  local timer=$__zsh_extesion_command_time_var_timer
  unset __zsh_extesion_command_time_var_timer
  if [ $timer ]; then
    local time_diff=$(($SECONDS - $timer))
    zsh_command_time "$time_diff"
  fi
}

zsh_command_time() {
  local time_diff=$1
  if [ $time_diff -ge ${ZSH_COMMAND_TIME_MIN_SECONDS:-3} ]; then
      if [[ ${time_diff} -ge $((60 * 60)) ]]; then
        local msg=$(printf '%dh:%dm:%ds' $(($time_diff/3600)) $(($time_diff%3600/60)) $(($time_diff%60)))
      elif [[ ${time_diff} -ge $((60)) ]]; then
        local msg=$(printf '%dm:%ds' $(($time_diff%3600/60)) $(($time_diff%60)))
      else
        local msg=$(printf '%ds' $(($time_diff)))
      fi
      RPROMPT="%F{${ZSH_COMMAND_TIME_COLOR}}${msg}"
  else
      # clear previous right prompt
      RPROMPT=""
  fi
}

precmd_functions+=(_command_time_precmd)
preexec_functions+=(_command_time_preexec)

