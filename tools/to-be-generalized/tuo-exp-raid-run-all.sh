#!/bin/bash

raid_name="Warden Raid"
effect="Virulence"
#levels=({07..15})
#levels=({10..19})
#levels=({15..25})
#levels=({20..22})
levels=({22..25})
#levels=(14)

declare -i FUND=0 #550 # SP for commander upping

declare -A yforts=(
    #[mt_mt]="Mortar Tower #2"
    #[sf_sf]="Sky Fortress #2"
    [lc_lc]="Lightning Cannon #2"
    #[cs3_lc3]="Corrosive Spore-3, Lightning Cannon-3"
    #[lc3_lc3]="Lightning Cannon-3(2)"
    #[cs_cs]="Corrosive Spore #2"
    #[df_df]="Death Factory #2"
    #[ia_ia]="Inspiring Altar #2"
    #[ia1_ia1]="Inspiring Altar-1(2)"
    #[cs_lc]="Corrosive Spore, Lightning Cannon"
    #[cs_df]="Corrosive Spore, Death Factory"
    #[cs_ia]="Corrosive Spore, Inspiring Altar"
    #[cs_mt]="Corrosive Spore, Mortar Tower"
    #[lc_df]="Lightning Cannon, Death Factory"
    #[lc_ia]="Lightning Cannon, Inspiring Altar"
)

commanders=(
    silus
    typhon
    malort
    ded

    any

    #halc
    #petr
)
if [[ $TUO_LOGIN == "lugofira" ]]; then
    commanders=(
        #vex5
        #petr
        ded
        #nexor
        any
    )
elif [[ $TUO_LOGIN == "type55" ]]; then
    commanders=(
        silus
    )
elif [[ $TUO_LOGIN == "pryyf" ]]; then
    commanders=(
        dracorex
        krellus
        any
    )
elif [[ $TUO_LOGIN == "alexan64" ]]; then
    commanders=(
        barracus
        any
    )
fi

for level in "${levels[@]}"; do
    for yfort in "${!yforts[@]}"; do
        for commander in "${commanders[@]}"; do
            tuo-exp-raid.sh \
                -c "$commander" \
                -Y "${yforts[$yfort]}" \
                -e "$effect" \
                -i 2000 -I 20000 -t 6 \
                -G 1 -F $FUND \
                "${raid_name}-${level##0}" "raid_${level}_${yfort}"
                #-f allow-candidates -f 'Loathe Gravewing' \
                #-f disallow-candidates -f 'Dune Runner, Ternary Dreadshot, Gun Virtuoso, Kor Ragetrooper, Shock Disruptor' \
                #-f disallow-candidates -f 'Kor Ragetrooper, Shock Disruptor' \
        done
    done
done
