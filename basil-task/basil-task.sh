#!/bin/bash -eu
# vim: sts=2 ts=2 sw=2 et

# get last command-line argument
export BIN="${@: -1}"

# remove last command-line argument from the "$@" list
set -- "${@: 1: $#-1}"

export NO_COLOR=1
mkdir -p .godbolt-out
export OUT=$(mktemp -p .godbolt-out --suffix=-out)
export LOG=$(mktemp -p .godbolt-out --suffix=-log)

# TODO: to defeat the randomly-generated temp directories
# and enable caching of intermediate objects, cd each task
# into a directory based on the hash of the binary
# (or all files in the directory?)
# (how would this interact with spec files?)

[[ -n "$OUT" ]] && [[ -n "$BIN" ]] && [[ -n "$LOG" ]]

. .env

task_cmd=(task --taskfile "$(dirname "$0")/Taskfile.yml" --dir "$(pwd)" "$@")

print_log_reason=''
if [[ "${verbose:-}" == 1 ]]; then
  print_log_reason='verbosely'
fi

if "${task_cmd[@]}" > $LOG 2>&1; then
  code=$?
else
  code=$?
fi

if [[ -s "$OUT" ]]; then
  cat "$OUT"
  echo
elif [[ "$code" == 0 ]]; then
  print_log_reason='successful, but no output file from'
else
  print_log_reason="ERROR, while"
fi

if [[ -n "$print_log_reason" ]]; then
  echo "$print_log_reason" 'executing command:'
  echo
  printf '  '; printf '%q ' "${task_cmd[@]}"; echo
  echo
  echo "at $(date),"
  echo "in directory $(pwd)"
  echo
  echo 'command output:'
  echo
  cat "$LOG"
fi

exit "$code"
