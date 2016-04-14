#!/bin/bash

declare -A INITIAL_DECKS

INITIAL_DECKS=(
    [silus]="Silus the Corrupt, Extreme Barrager, Atomic Wardriver, Cobalt Scutter, Atlantis, Constantine's Lab, Infernal Diabolic, Chasmwyrm, Sleek Beamshot"
    [vex]="Typhon Vex, Extreme Barrager, Atomic Wardriver, Cobalt Scutter, Atlantis, Constantine's Lab, Infernal Diabolic, Chasmwyrm, Sleek Beamshot"
    [ded]="Daedalus, Extreme Barrager, Atomic Wardriver, Cobalt Scutter, Atlantis, Constantine's Lab, Infernal Diabolic, Chasmwyrm, Sleek Beamshot"

    #[mad]="Typhon the Mad, Sleek Beamshot #2, Peirthius, Soul Annex, Infernal Diabolic, Atlantis"
    #[drac]="Dracorex Hivelord, Extreme Barrager, Luminous Jester, Bio Equalizer, Sleek Beamshot, Deserted Baughe, Infernal Diabolic, Atlantis"

    #[ded]="Daedalus Enraged, Extreme Barrager, Barracus Redeemed, Mangle Loader, Dune Runner #3"
    #[nexor]="Nexor, Extreme Barrager, Jilted Baughe, Ezamit Tranq, Barracus Redeemed"
)

ENEMY_ATK_DECK="arena_all;brawl_all;ApsychoAAkillerAATK;BlackSailsATK"
ENEMY_ATK_ALIAS="arena+brawl+bs+pk"
#ENEMY_DEF_DECK="arena_p2w:1;arena_mix:8;arena_f2p:5;BlackSailsDEF:3;ApsychoAAkillerADEF:6;brawl_p2w:2;brawl_mix:5;brawl_f2p:5"
#ENEMY_DEF_DECK="arena_mix:1;arena_f2p:4;BlackSailsDEF:1;ApsychoAAkillerADEF:2;brawl_mix:2;brawl_f2p:5"
ENEMY_DEF_DECK="comp_strong_decks"
ENEMY_DEF_ALIAS="$ENEMY_DEF_DECK"
#ENEMY_DEF_DECK="comp"

FUND=0

RUN_BRAWL=1
RUN_ARENA=0

RUN_ATTACK=0
RUN_DEFENSE=1

RUN_ANY_COMMANDER=0

ATTACK_ITERS=(10 500)
DEFENSE_ITERS=(20 2000)

COMMON_OPTIONS=(
    #_{arena,brawl,bs,pk}_20160131
    _comp_20160131
    -e "Enhance All Berserk 3"
    endgame 1
    -L 5 10
    -t 6
    allow-candidates 'Loathe Gravewing, Slenditer, Quicksilver, Peirthius, Deflector, Organic Artillery, Taser, Buried Eater, Dune Glider, Ostrix'
    #disallow-candidates 'Dune Runner, Ternary Dreadshot, Gun Virtuoso, Kor Ragetrooper, Shock Disruptor'
    #disallow-candidates 'Kor Ragetrooper, Shock Disruptor'
)

if ((FUND)); then
    COMMON_OPTIONS+=("fund" "$FUND")
else
    unset FUND
fi

## if 'any' commander is not set: set any first found as 'any'
if ((RUN_ANY_COMMANDER)) && [[ -z ${INITIAL_DECK[any]+x} ]]; then
    for x in "${INITIAL_DECKS[@]}"; do
        INITIAL_DECKS[any]=$x
        break
    done
fi

declare -a OPTIONS
declare -a opts

run_for_each_commander() {
    for commander in "${!INITIAL_DECKS[@]}"; do
        INITIAL_DECK=${INITIAL_DECKS[$commander]}
        tuo.sh 
    done
}

## brawl
if ((RUN_BRAWL)); then
    if ((RUN_ATTACK)); then
        OPTIONS=("${COMMON_OPTIONS[@]}" ordered brawl climbex "${ATTACK_ITERS[@]}")
        for commander in "${!INITIAL_DECKS[@]}"; do
            log="tuo-brawl.attack.${commander}-vs-${ENEMY_DEF_ALIAS}${FUND:+.fund${FUND}}.log"
            opts=("${OPTIONS[@]}")
            [[ $commander != "any" ]] && opts+=("keep-commander")
            tuo.sh "${INITIAL_DECKS[$commander]}" "$ENEMY_DEF_DECK" "${opts[@]}" &> "$log" &
        done
    fi
    if ((RUN_DEFENSE)); then
        OPTIONS=("${COMMON_OPTIONS[@]}" random surge win climbex "${DEFENSE_ITERS[@]}")
        for commander in "${!INITIAL_DECKS[@]}"; do
            log="tuo-brawl.defense.${commander}-vs-${ENEMY_ATK_ALIAS}${FUND:+.fund${FUND}}.log"
            opts=("${OPTIONS[@]}")
            [[ $commander != "any" ]] && opts+=("keep-commander")
            tuo.sh "${INITIAL_DECKS[$commander]}" "$ENEMY_ATK_DECK" "${opts[@]}" &> "$log" &
        done
    fi
fi

## arena
if ((RUN_ARENA)); then
    if ((RUN_ATTACK)); then
        OPTIONS=("${COMMON_OPTIONS[@]}" ordered fight win climbex "${ATTACK_ITERS[@]}")
        for commander in "${!INITIAL_DECKS[@]}"; do
            log="tuo-arena.attack.${commander}-vs-${ENEMY_DEF_ALIAS}${FUND:+.fund${FUND}}.log"
            opts=("${OPTIONS[@]}")
            [[ $commander != "any" ]] && opts+=("keep-commander")
            tuo.sh "${INITIAL_DECKS[$commander]}" "$ENEMY_DEF_DECK" "${opts[@]}" &> "$log" &
        done
    fi
    if ((RUN_DEFENSE)); then
        OPTIONS=("${COMMON_OPTIONS[@]}" random surge defense climbex "${DEFENSE_ITERS[@]}")
        for commander in "${!INITIAL_DECKS[@]}"; do
            log="tuo-arena.defense.${commander}-vs-${ENEMY_ATK_ALIAS}${FUND:+.fund${FUND}}.log"
            opts=("${OPTIONS[@]}")
            [[ $commander != "any" ]] && opts+=("keep-commander")
            tuo.sh "${INITIAL_DECKS[$commander]}" "$ENEMY_ATK_DECK" "${opts[@]}" &> "$log" &
        done
    fi
fi
