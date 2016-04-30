#!/bin/bash

sign=${1:-0}
shift

check_tuo_pid() {
    local -i pid=$1
    local cmdline="/proc/$pid/cmdline"
    [[ -r "$cmdline" ]] || return 1
    cmd=$(basename $(tr '\0' '\n' < "$cmdline" | head -n1))
    [[ $cmd == tuo ]] || return 2
    return 0
}

for i in "$@"; do
    xname=$(basename "$i")
    pid=$(head -n10 "$i" | grep -P -o '(?<=^pid: )\d+')
    if ! check_tuo_pid "$pid"; then
        echo "$xname => $pid (dead)" 1>&2
        continue
    fi
    echo "$xname => $pid (kill -${sign})" 1>&2
    kill -"${sign}" "$pid"
done
