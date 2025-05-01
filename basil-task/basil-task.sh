#!/bin/bash -eu
# vim: sts=2 ts=2 sw=2 et

export BIN="${@: -1}"
export NO_COLOR=1
mkdir -p .godbolt-out
export OUT=$(mktemp -p .godbolt-out --suffix=-out)
export LOG=$(mktemp -p .godbolt-out --suffix=-log)

# TODO: to defeat the randomly-generated temp directories
# and enable caching of intermediate objects, cd each task
# into a directory based on the hash of the binary
# (or all files in the directory?)
# (how would this interact with spec files?)

# export TASK_TEMP_DIR=/tmp/task

[[ -n "$OUT" ]] && [[ -n "$BIN" ]] && [[ -n "$LOG" ]]

task_cmd=(task --taskfile "$(dirname "$0")/Taskfile.yml" --dir "$(pwd)" "$@")

print_log_reason=''

if mutex.sh "${task_cmd[@]}" > $LOG 2>&1; then
  if [[ -s "$OUT" ]]; then
    cat "$OUT"
  else
    print_log_reason='successful, but no output file from'
  fi
else
  print_log_reason="ERROR while"
fi

date

if [[ -n "$print_log_reason" ]]; then
  echo "$print_log_reason" 'executing command:'
  echo
  printf '  '; printf '%q ' "${task_cmd[@]}"; echo
  echo
  echo "in directory $(pwd)"
  echo
  echo 'command output:'
  echo
  cat "$LOG"
fi

