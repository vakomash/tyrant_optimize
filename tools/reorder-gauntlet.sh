#!/bin/bash

INPUT_FILE="$1"
OUTPUT_FILE="${2:-$(dirname "$1")/reordered.$(basename "$1")}"

declare -i ITERS=1

ENEMY="arena_all"

TUO_OPTIONS=(
    _arena
    -t 2
)

TMP_DIR="/tmp"
TMP_FILE_PREFIX="."
TMP_FILE_SUFFIX=".reordering~"

die() {
    echo " ** ERROR ** $@" 1>&2
    exit 255
}

msg() {
    echo "[$(date +%F' '%T)] $@"
}

# check input file
[[ -f $INPUT_FILE ]] || die "Bad input file (no such file or file isn't regular): $INPUT_FILE"

# reset output file or die
:> "$OUTPUT_FILE" || die "Can't open file for writing: $OUTPUT_FILE"

# show start message
msg "Starting reorder for gauntlet $INPUT_FILE (output to $OUTPUT_FILE)"

IFS=$'\n'
while read -r line; do
    if [[ $line =~ (^[a-zA-Z0-9_.+-]+):\ ([^/].+[^/])$ ]]; then
        user="${BASH_REMATCH[1]}"
        deck="${BASH_REMATCH[2]}"
        msg "Reordering $user ..."
        TMP_FILE="${TMP_DIR}/${TMP_FILE_PREFIX}${user}${TMP_FILE_SUFFIX}"
        [[ -f $TMP_FILE ]] && die "Temporary file already exists: $TMP_FILE"
        tuo.sh "$deck" "$ENEMY" "${TUO_OPTIONS[@]}" reorder $ITERS &> "$TMP_FILE" &
        declare -i tuo_pid=$!
        wait $tuo_pid
        last_line=$(tail -n1 "$TMP_FILE")
        if [[ $last_line =~ ^Optimized\ Deck:.*[0-9.]+:\ ([^:]+)$ ]]; then
            opt_deck="${BASH_REMATCH[1]}"
            echo "$user: $opt_deck" >> "$OUTPUT_FILE"
            rm -rf "$TMP_FILE"
        else
            die "Failed at $user (deck: $deck), see $TMP_FILE for more details"
        fi
    else
        echo "$line" >> "$OUTPUT_FILE"
    fi
done < "$INPUT_FILE"

# show finish message
msg "Reordering finished"
