#!/bin/bash -u

# set -o pipefail

# executes its given command while holding a mutex.
# https://stackoverflow.com/questions/6870221/is-there-any-mutex-semaphore-mechanism-in-shell-scripts

lock=".lock-$1-$(sha1sum <<< "$@")"
lock="${lock// /}"

# lock="./${lock//\//_}"
# lock="${LOCK:-./.lock}"

: >> "$lock"
{
  flock $fd || exit 100

  if [[ -f "$lock-code" ]]; then
    # echo "($1 result cached)"
    cat "$lock-out"
    cat "$lock-err" >&2
    exit $(cat "$lock-code")
  fi

  "$@" > "$lock-out" 2> "$lock-err"
  code=$?
  cat "$lock-out"
  cat "$lock-err" >&2
  echo $code > "$lock-code"
  exit $code
} {fd}<"$lock"


