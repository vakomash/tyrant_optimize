#!/bin/bash

declare -i FUND=000
declare -i ENDGAME=1

# phase 1
#gbge="ZealotsPreservation"

# phase 2
gbge="Empowered Phalanx"

# phase 3
#gbge="Metamorphosis"


ybges=(
    #""
    #"Inspired"
    #"Blightblast"
    #"Bombing Run"
    "Triage"
    #"Charged Up"
    #"Combined Arms"
    #"Blitzkrieg"
    #"Paladin's Presence"
    #"Viral Warfare"
    #"Progenitor Tech"
    #"Diminisher"
    #"Divine Blessing"
    #"Opalescence"
    #"Power Source"
)


ebges=(
    #""
    #"Inspired"
    #"Blightblast"
    #"Bombing Run"
    #"Triage"
    #"Charged Up"
    #"Combined Arms"
    #"Blitzkrieg"
    "Paladin's Presence"
    #"Viral Warfare"
    #"Progenitor Tech"
    #"Diminisher"
    #"Divine Blessing"
    #"Opalescence"
    #"Power Source"
    #"Ferocity"
)


defense=""
if [[ $1 == "defense" ]]; then
    defense=1
    shift
fi

declare -A atk_yforts=(
    [ia_ia]="Inspiring Altar #2"

    #[cs_lc]="Corrosive Spore, Lightning Cannon"
    #[lc_lc]="Lightning Cannon #2"
    #[lc_ia]="Lightning Cannon, Inspiring Altar"
    #[df_df]="Death Factory #2"
    #[lc_df]="Lightning Cannon, Death Factory"
    
    #[cs_cs]="Corrosive Spore #2"
    #[cs_mt]="Corrosive Spore, Mortar Tower"

    #[mt_mt]="Mortar Tower #2"
    #[sf_sf3]="Sky Fortress, Sky Fortress-3"
    #[sf_lc3]="Sky Fortress, Lightning Cannon-3"
    #[df3_df3]="Death Factory-3(2)"
    #[cs_cs]="Corrosive Spore #2"
    #[cs_df]="Corrosive Spore, Death Factory"
    #[cs_ia]="Corrosive Spore, Inspiring Altar"

    #[xx_xx]=""
)

declare -A def_yforts=(
    [mf_xx]="Minefield"
    #[tc_xx]="Tesla Coil"
    #[fa_xx]="Foreboding Archway"
    #[ib_xx]="Illuminary Blockade"
    #[ff_xx]="Forcefield"

    #[tc3_xx]="Tesla Coil-3"
    #[ff3_xx]="Forcefield-3"
    #[ib3_xx]="Illuminary Blockade-3"

    #[tc_tc]="Tesla Coil #2"
    #[mf_mf]="Minefield #2"
    #[fa_fa]="Foreboding Archway #2"
    #[ff_ff]="Forcefield #2"
    #[ib_ib]="Illuminary Blockade #2"
    #[ff_ib]="Forcefield, Illuminary Blockade"

    #[xx_xx]=""
)

declare -A atk_eforts=(
    [ia_ia]="Inspiring Altar #2"
    #[df_df]="Death Factory #2"
    #[lc_lc]="Lightning Cannon #2"
    #[sf_sf]="Sky Fortress #2"

    #[ia_xx]="Inspiring Altar"
    #[lc_xx]="Lightning Cannon"

    #[cs_lc]="Corrosive Spore, Lightning Cannon"
    #[ia_lc]="Inspiring Altar, Lightning Cannon"
    #[df_lc]="Death Factory, Lightning Cannon"
    #[cs_df]="Corrosive Spore, Death Factory"
    #[df3_df]="Death Factory-3, Death Factory"
    #[df_lc]="Death Factory, Lightning Cannon"
    #[sf3_sf3]="Sky Fortress-3(2)"
    #[cs_cs]="Corrosive Spore #2"
    #[cs_mt]="Corrosive Spore, Mortar Tower"
    #[mt_mt3]="Mortar Tower, Mortar Tower-3"
)

declare -A def_eforts=(
    [mf_xx]="Minefield"
    #[tc_xx]="Tesla Coil"
    #[fa_xx]="Foreboding Archway"
    #[ib_xx]="Illuminary Blockade"
    #[ff_xx]="Forcefield"

    #[ff3_xx]="Forcefield-3"
    #[tc3_xx]="Tesla Coil-3"
    #[fa3_xx]="Foreboding Archway-3"

    #[tc_tc]="Tesla Coil #2"
    #[mf_mf]="Minefield #2"
    #[fa_fa]="Foreboding Archway #2"
    #[ff_ff]="Forcefield #2"
    #[ib_ib]="Illuminary Blockade #2"
    #[ib_ib3]="Illuminary Blockade, Illuminary Blockade-3"
    #[ib_ff3]="Illuminary Blockade, Forcefield-3"
    
    ## attack forts
    #[ia_xx]="Inspiring Altar"
    #[lc_xx]="Lightning Cannon"
    #[df_xx]="Death Factory"
)

commanders=(
    silus_gw
    typhon_gw
    #ded
    #malort
    any
)

if [[ $TUO_LOGIN == "lugofira" ]]; then
    commanders=(
        ded
        any
    )
elif [[ $TUO_LOGIN == "type55" ]]; then
    commanders=(
        silus
        #barracus
    )
elif [[ $TUO_LOGIN == "pryyf" ]]; then
    commanders=(
        krellus
        dracorex
        malort
        ded
        any
    )
elif [[ $TUO_LOGIN == "prokop" ]]; then
    commanders=(
        silus
        any
    )
elif [[ $TUO_LOGIN == "heid" ]]; then
    commanders=(
        krellus
        any
    )
elif [[ $TUO_LOGIN == "lexicus86" ]]; then
    commanders=(
        silus
        any
    )
elif [[ $TUO_LOGIN == "kapturov" ]]; then
    commanders=(
        krellus
        any
    )
elif [[ $TUO_LOGIN == "777stas777" ]]; then
    commanders=(
        silus
        ded
        any
    )
fi


declare -A yforts eforts
declare -a opts

if (( $defense )); then
    for x in "${!def_yforts[@]}"; do
        yforts[$x]="${def_yforts[$x]}"
    done
    for x in "${!atk_eforts[@]}"; do
        eforts[$x]="${atk_eforts[$x]}"
    done

    enemy_alias="comp_strong"
    enemy="arena_p2w:3;arena_mix:2;Core+:2"
    #enemy="arena_p2w:3;Core+:2"
    opts=(-d -f _ham -f _arena -i 25${TUO_DECK:+00} -I 250 -t 2)
else
    for x in "${!atk_yforts[@]}"; do
        yforts[$x]="${atk_yforts[$x]}"
    done
    for x in "${!def_eforts[@]}"; do
        eforts[$x]="${def_eforts[$x]}"
    done

    enemy_alias="comp_strong"
    enemy="arena_p2w:3;arena_mix:2;Core+:2"
    #enemy="arena_p2w:3;Core+:2"
    opts=(-f _ham -f _arena -i 10${TUO_DECK:+00} -I 100 -t 2)
fi

## append allowed candidates cards
opts+=(
    #-f "allow-candidates" -f "Loathe Gravewing, Stronghold, Griller, Quicksilver, Living Dam, Surn of the Shadows, Ozone Contender, Harsh Symbiotic, Cobalt Scutter, Junk Hauler, Erebus Outpost, Raider Observatory, Sidewinder Cobra, Chasmwyrm, Ditch Digger, Inquisitor, Hatred, Psycher, Vrost, Dion, Dionys"
    -f "allow-candidates" -f "Loathe Gravewing, Griller"
    -f "disallow-recipes" -f "Wastes Ark, Dune Runner, Ternary Dreadshot, Kor Ragetrooper, Shock Disruptor"
)

if [[ -n $TUO_DECK ]]; then
    commanders=(deck)
fi

for yfort in "${!yforts[@]}"; do
    for efort in "${!eforts[@]}"; do
        for ybge in "${ybges[@]}"; do
            for ebge in "${ebges[@]}"; do
                for commander in "${commanders[@]}"; do
                    tuo-exp-gw.sh \
                        -c "$commander" \
                        -Y "${yforts[$yfort]}" \
                        -E "${eforts[$efort]}" \
                        -e "${gbge}:${ybge}:${ebge}" \
                        -G "$ENDGAME" -F "$FUND" \
                        -L 5 -U 10 \
                        ${TUO_DECK:+-s -D "$TUO_DECK"} \
                        "${opts[@]}" \
                        "${enemy}" "${enemy_alias}.${yfort}.${efort}"
                done
            done
        done
    done
done
