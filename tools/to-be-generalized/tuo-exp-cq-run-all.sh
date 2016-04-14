#!/bin/bash

mode=${1:-both}

#yforts=""
#yforts="Andar Quarantine-2, Red Maw Base-2, Baron's Claw Labs-2, The Spire-2, Phobos Station-2"
yforts="Baron's Claw Labs-3, Red Maw Base-3, Andar Quarantine-2, Phobos Station-2, Magma Foundry"


eforts="$yforts"

attack_effects=(
    #-e ""
    #-e "The Spire"
    -e "Phobos Station"
    #-e "Red Maw Base"
    #-e "Andar Quarantine"
)

defense_effects=(
    -e ""
    -e "Phobos Station"
    -e "The Spire"
    -e "Red Maw Base"
    -e "Baron's Claw Labs"
    -e "Andar Quarantine"
)

flags=(
    -f _gt_20160324
    -f _gt_20160326
    -f _ham
    -G 1
    -F 300
    -f allow-candidates -f "Loathe Gravewing, Hatred, Griller, Oppressor, Slenditer, Glade Resistor, Total Control, Beta Zoid"
    -f disallow-recipes -f "Dune Runner, Kor Ragetrooper, Shock Disruptor, Ternary Dreadshot"
)

attack=(
    -t 4
    -i 15${TUO_DECK:+00}
    -I 150
)

defense=(
    -t 6
    -i 20${TUO_DECK:+00}
    -I 400
    -d
    #-f enemy:ordered
)

declare -A attack_enemies defense_enemies

# enemy def-decks for 'attack' simming
attack_enemies=(
    [top_def]="arena_p2w:4;ddd"
)

# enemy atk-decks for 'defense' simming
defense_enemies=(
    [top_atk]="arena_p2w:4;arena_mix:2"
)

if [[ $mode = attack ]] || [[ $mode = both ]]; then
    attack_commanders=(
        silus_cq
        typhon_cq
        #any
    )
fi

if [[ $mode = defense ]] || [[ $mode = both ]]; then
    defense_commanders=(
        silus_cq
        typhon_cq
        #any
    )
fi

if [[ $TUO_LOGIN == "lugofira" ]]; then
    if [[ $mode = attack ]] || [[ $mode = both ]]; then
        attack_commanders=(
            vex5
            ded
            nexor
        )
    fi
    if [[ $mode = defense ]] || [[ $mode = both ]]; then
        defense_commanders=(
            vex5
            ded
            nexor
        )
    fi
elif [[ $TUO_LOGIN == "pryyf" ]]; then
    if [[ $mode = attack ]] || [[ $mode = both ]]; then
        attack_commanders=(
            dracorex
            krellus
            any
        )
    fi
    if [[ $mode = defense ]] || [[ $mode = both ]]; then
        defense_commanders=(
            dracorex
            krellus
            any
        )
    fi
elif [[ $TUO_LOGIN == "type55" ]]; then
    if [[ $mode = attack ]] || [[ $mode = both ]]; then
        attack_commanders=(
            silus
        )
    fi
    if [[ $mode = defense ]] || [[ $mode = both ]]; then
        defense_commanders=(
            silus
        )
    fi
elif [[ $TUO_LOGIN == "ken" ]]; then
    if [[ $mode = attack ]] || [[ $mode = both ]]; then
        attack_commanders=(
            barracus
            typhon
            halcyon
            malort
            any
        )
    fi
    if [[ $mode = defense ]] || [[ $mode = both ]]; then
        defense_commanders=(
            typhon
            barracus
            any
        )
    fi
fi

if [[ -n $TUO_DECK ]]; then
    attack_commanders=()
    defense_commanders=()
    if [[ $mode = attack ]] || [[ $mode = both ]]; then
        attack_commanders=(deck)
    fi
    if [[ $mode = defense ]] || [[ $mode = both ]]; then
        defense_commanders=(deck)
    fi
fi


for enemy in "${!attack_enemies[@]}"; do
    for commander in "${attack_commanders[@]}"; do
        tuo-exp-cq.sh ${TUO_DECK:+-s -D "$TUO_DECK"} -c $commander \
            -Y "$yforts" -E "$eforts" \
            "${attack_effects[@]}" "${attack[@]}" "${flags[@]}" "${attack_enemies[$enemy]}" "$enemy"
    done
done
for enemy in "${!defense_enemies[@]}"; do
    for commander in "${defense_commanders[@]}"; do
        tuo-exp-cq.sh ${TUO_DECK:+-s -D "$TUO_DECK"} -c $commander \
            -Y "$yforts" -E "$eforts" \
            "${defense_effects[@]}" "${defense[@]}" "${flags[@]}" "${defense_enemies[$enemy]}" "$enemy"
    done
done
