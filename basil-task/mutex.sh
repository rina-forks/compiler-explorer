#!/bin/bash -u

# executes its given command while holding a mutex.
# https://stackoverflow.com/questions/6870221/is-there-any-mutex-semaphore-mechanism-in-shell-scripts

# lock="./.lock-$@"
# lock="${lock//\//_}"
lock="${LOCK:-./.lock}"

: >> "$lock"
{
  flock $fd || exit 100
  exec "$@"
} {fd}<"$lock"
