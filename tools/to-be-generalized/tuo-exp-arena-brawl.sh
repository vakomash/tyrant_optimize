#!/bin/bash

FUND=900

RUN_BRAWL=1
RUN_ARENA=0

RUN_ATTACK=1
RUN_DEFENSE=0

RANDOM_ATTACK=0

ATTACK_ITERS=(20 200)
DEFENSE_ITERS=(100 1000)

ENEMY_DECK="apr_top_50:1;apr_top_200:3"
#ENEMY_ALIAS="$ENEMY_DECK"
ENEMY_ALIAS="comp"

COMMON_OPTIONS=(
    _brawl_apr
    -e "ZealotsPreservation"
    endgame 1
    -t 2
    allow-candidates "Loathe Gravewing, Hatred, Griller, Oppressor, Slenditer, Glade Resistor, Subsonic Deity, Eidolon, Vrost, Psycher, Inquisitor"
    #disallow-candidates 'Steel Ram'
    #disallow-recipes "Stonewall Garrison, Xeno Harvestman, Nettle Miscreant, Ward Bombardier, Ternary Dreadshot, Patriarch's Bidding"
    disallow-recipes "Dune Runner, Kor Ragetrooper, Shock Disruptor, Ternary Dreadshot, Atomic Wardriver"
)

BRAWL_OPTIONS=(
    -L 7 10
)

ARENA_OPTIONS=(
)

#ATK_COMMANDERS=({any,typhon,silus}_punct {typhon,silus}_3ek silus ded typhon malort ark emp const any)
#ATK_COMMANDERS=(silus typhon ded malort any)
ATK_COMMANDERS=({silus,typhon}_{2ek{,_mortar},mortar} any ded)
[[ $TUO_LOGIN == pryyf ]] && ATK_COMMANDERS=(dracorex krellus any)

#DEF_COMMANDERS=(silus)


## setup fund option or unset variable

if ((FUND)); then
    COMMON_OPTIONS+=("fund" "$FUND")
else
    unset FUND
fi


### BEGIN OF INITIAL DECKS ###

declare -A TUO_INITIAL_DECKS

TUO_EXP_SETTINGS="$HOME/.tuo-exp${TUO_LOGIN:+.$TUO_LOGIN}"

if ! source "$TUO_EXP_SETTINGS"; then
    echo "No such file (TUO-EXP SETTINGS): $TUO_EXP_SETTINGS" 2>&1
    exit 255
fi

## if 'any' commander is not set: set any first found as 'any'
if [[ -z ${TUO_INITIAL_DECKS[any]+x} ]]; then
    for x in "${TUO_INITIAL_DECKS[@]}"; do
        TUO_INITIAL_DECKS[any]=$x
        break
    done
fi

### END OF INITIAL DECKS ###

[[ -z ${DEF_COMMANDERS+x} ]] && [[ ! -z ${ATK_COMMANDERS+x} ]] && DEF_COMMANDERS=("${ATK_COMMANDERS[@]}")

[[ -z ${ATK_COMMANDERS+x} ]] && ATK_COMMANDERS=("${!TUO_INITIAL_DECKS[@]}")
[[ -z ${DEF_COMMANDERS+x} ]] && DEF_COMMANDERS=("${!TUO_INITIAL_DECKS[@]}")

[[ -z ${ENEMY_DEF_DECK+x} ]] && [[ -n $ENEMY_DECK ]] && ENEMY_DEF_DECK=$ENEMY_DECK
[[ -z ${ENEMY_DEF_ALIAS+x} ]] && [[ -n $ENEMY_ALIAS ]] && ENEMY_DEF_ALIAS=$ENEMY_ALIAS

[[ -z ${ENEMY_ATK_DECK+x} ]] && [[ -n $ENEMY_DECK ]] && ENEMY_ATK_DECK=$ENEMY_DECK
[[ -z ${ENEMY_ATK_ALIAS+x} ]] && [[ -n $ENEMY_ALIAS ]] && ENEMY_ATK_ALIAS=$ENEMY_ALIAS

declare -a OPTIONS
declare -a opts

check_commander() {
    local commander=$1
    if [[ -z ${TUO_INITIAL_DECKS[$commander]} ]]; then
        echo "No such commander: $commander (available commanders: ${!TUO_INITIAL_DECKS[@]})"
        return 255
    fi
    return 0
}

run_command() {
    local log=$1
    shift
    local command=("$@")
    ( echo "run: ${command[@]}"; echo ) | tee "$log" >&2
    "${command[@]}" &>> "$log" &
}

## brawl
if ((RUN_BRAWL)); then
    if ((RUN_ATTACK)); then
        ((RANDOM_ATTACK)) && order="random" || order="ordered"
        OPTIONS=("${COMMON_OPTIONS[@]}" "${BRAWL_OPTIONS[@]}" "$order" brawl climbex "${ATTACK_ITERS[@]}")
        for commander in "${ATK_COMMANDERS[@]}"; do
            check_commander "$commander" || continue
            log="tuo-brawl.attack-${order}.${commander}-vs-${ENEMY_DEF_ALIAS}${FUND:+.fund${FUND}}.log"
            opts=("${OPTIONS[@]}")
            [[ $commander =~ ^any(_|$) ]] || opts+=("keep-commander")
            run_command "$log" tuo.sh "${TUO_INITIAL_DECKS[$commander]}" "$ENEMY_DEF_DECK" "${opts[@]}"
        done
    fi
    if ((RUN_DEFENSE)); then
        OPTIONS=("${COMMON_OPTIONS[@]}" "${BRAWL_OPTIONS[@]}" random brawl-defense climbex "${DEFENSE_ITERS[@]}")
        for commander in "${DEF_COMMANDERS[@]}"; do
            check_commander "$commander" || continue
            log="tuo-brawl.defense-random.${commander}-vs-${ENEMY_ATK_ALIAS}${FUND:+.fund${FUND}}.log"
            opts=("${OPTIONS[@]}")
            [[ $commander =~ ^any(_|$) ]] || opts+=("keep-commander")
            run_command "$log" tuo.sh "${TUO_INITIAL_DECKS[$commander]}" "$ENEMY_ATK_DECK" "${opts[@]}"
        done
    fi
fi

## arena
if ((RUN_ARENA)); then
    if ((RUN_ATTACK)); then
        ((RANDOM_ATTACK)) && order="random" || order="ordered"
        OPTIONS=("${COMMON_OPTIONS[@]}" "${ARENA_OPTIONS[@]}" "$order" fight win climbex "${ATTACK_ITERS[@]}")
        for commander in "${ATK_COMMANDERS[@]}"; do
            check_commander "$commander" || continue
            log="tuo-arena.attack-${order}.${commander}-vs-${ENEMY_DEF_ALIAS}${FUND:+.fund${FUND}}.log"
            opts=("${OPTIONS[@]}")
            [[ $commander =~ ^any(_|$) ]] || opts+=("keep-commander")
            run_command "$log" tuo.sh "${TUO_INITIAL_DECKS[$commander]}" "$ENEMY_DEF_DECK" "${opts[@]}"
        done
    fi
    if ((RUN_DEFENSE)); then
        OPTIONS=("${COMMON_OPTIONS[@]}" "${ARENA_OPTIONS[@]}" random surge defense climbex "${DEFENSE_ITERS[@]}")
        for commander in "${DEF_COMMANDERS[@]}"; do
            check_commander "$commander" || continue
            log="tuo-arena.defense-random.${commander}-vs-${ENEMY_ATK_ALIAS}${FUND:+.fund${FUND}}.log"
            opts=("${OPTIONS[@]}")
            [[ $commander =~ ^any(_|$) ]] || opts+=("keep-commander")
            run_command "$log" tuo.sh "${TUO_INITIAL_DECKS[$commander]}" "$ENEMY_ATK_DECK" "${opts[@]}"
        done
    fi
fi
