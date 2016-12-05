#include "tyrant.h"

#include <string>

const std::string faction_names[Faction::num_factions] =
{ "", "imperial", "raider", "bloodthirsty", "xeno", "righteous", "progenitor" };

const std::string skill_names[Skill::num_skills] =
{
    // Placeholder for no-skill:
    "<Error>",

    // Activation (harmful):
    "Enfeeble", "Jam", "Mortar", "Siege", "Strike", "Sunder", "Weaken",

    // Activation (helpful):
    "Enhance", "Evolve", "Heal", "Mend", "Overload", "Protect", "Rally", "Enrage", "Rush",

    // Activation (unclassified/polymorphic):
    "Mimic",

    // Defensive:
    "Armor", "Avenge", "Corrosive", "Counter", "Evade", "Payback", "Revenge", "Refresh", "Wall",

    // Combat-Modifier:
    "Coalition", "Legion", "Pierce", "Rupture", "Swipe", "Drain", "Venom",

    // Damage-Dependant:
    "Berserk", "Inhibit", "Sabotage", "Leech", "Poison",

    // Triggered:
    "Allegiance", "Flurry", "Valor", "Stasis",
};

const std::string passive_bge_names[PassiveBGE::num_passive_bges] =
{
    // Placeholder for no-bge:
    "<Error>",

    // Passive BGEs
    "Bloodlust", "Brigade", "Counterflux", "Divert", "EnduringRage", "Fortification", "Heroism",
    "ZealotsPreservation", "Metamorphosis", "Revenge", "TurningTides", "Virulence", "HaltedOrders",
    "Devour", "CriticalReach", "TemporalBacklash", "Furiosity",
};

const std::string cardtype_names[CardType::num_cardtypes]{"Commander", "Assault", "Structure", };

const std::string rarity_names[]{"", "common", "rare", "epic", "legend", "vindi", "mythic", };

unsigned const upgrade_cost[]{0, 5, 15, 30, 75, 150};
unsigned const salvaging_income[][7]{{}, {0, 1, 2, 5}, {0, 5, 10, 15, 20}, {0, 20, 25, 30, 40, 50, 65}, {0, 40, 45, 60, 75, 100, 125}, {0, 80, 85, 100, 125, 175, 250}};

unsigned min_possible_score[]{0, 0, 0, 10, 5, 5, 5, 0
#ifndef NQUEST
, 0
#endif
};
unsigned max_possible_score[]{100, 100, 100, 100, 66, 66, 100, 100
#ifndef NQUEST
, 100
#endif
};

std::string decktype_names[DeckType::num_decktypes]{"Deck", "Mission", "Raid", "Campaign", "Custom Deck", };

signed debug_print(0);
unsigned debug_cached(0);
bool debug_line(false);
std::string debug_str("");
