#!/bin/bash -eu

set -o pipefail

# executes its given command while holding a mutex.
# https://stackoverflow.com/questions/6870221/is-there-any-mutex-semaphore-mechanism-in-shell-scripts

lock=".lock-$@"
lock="./${lock//\//_}"
# lock="${LOCK:-./.lock}"

: >> "$lock"
{
  flock $fd || exit 100

  if [[ -f "$lock-done" ]]; then
    echo 'cached command.'
    cat "$lock-done"
    exit
  fi

  "$@" | tee "$lock-done"
} {fd}<"$lock"


