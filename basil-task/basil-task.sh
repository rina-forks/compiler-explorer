#!/bin/bash -eu

export BIN="${@: -1}"
export NO_COLOR=1
export OUT=$(mktemp -p .)
export LOG=$(mktemp -p .)

[[ -n "$OUT" ]] && [[ -n "$BIN" ]] && [[ -n "$LOG" ]]

task_cmd=(task --taskfile "$(dirname "$0")/Taskfile.yml" --dir "$(pwd)" "$@")

if "${task_cmd[@]}" > $LOG 2>&1; then
  exec cat "$OUT"
else
  echo 'error executing basil-task command:'
  printf '  '
  printf '%q ' "${task_cmd[@]}" 
  echo
  exec cat "$LOG"
fi

