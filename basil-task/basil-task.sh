#!/bin/bash -eu

export BIN="${@: -1}"
export NO_COLOR=1
export OUT=$(mktemp -p . --suffix=-out)
export LOG=$(mktemp -p . --suffix=-log)

# TODO: to defeat the randomly-generated temp directories
# and enable caching of intermediate objects, cd each task
# into a directory based on the hash of the binary
# (or all files in the directory?)
# (how would this interact with spec files?)

# export TASK_TEMP_DIR=/tmp/task

[[ -n "$OUT" ]] && [[ -n "$BIN" ]] && [[ -n "$LOG" ]]

task_cmd=(task --taskfile "$(dirname "$0")/Taskfile.yml" --dir "$(pwd)" "$@")

if "${task_cmd[@]}" > $LOG 2>&1 && [[ -s "$OUT" ]]; then
  exec cat "$OUT"
else
  echo 'error executing command:'
  echo
  printf '  '; printf '%q ' "${task_cmd[@]}"; echo
  # echo "in directory $(pwd)"
  echo
  echo 'error output:'
  echo
  exec cat "$LOG"
fi

