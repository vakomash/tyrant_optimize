
#include <tuple>
#include <unordered_map>
#include <vector>
#include "card.h"
#include "cards.h"
#include "deck.h"
#include "tyrant.h"
/*
namespace TO {
  extern gamemode_t gamemode;
#ifndef NQUEST
  extern Quest quest;
#endif
  extern unsigned flexible_iter;
  extern unsigned flexible_turn;
  extern bool mode_open_the_deck;
  extern OptimizationMode optimization_mode;
};
*/
//using namespace TO;
//------------------------------------------------------------------------------
struct Requirement
{
    std::unordered_map<const Card*, unsigned> num_cards;
};
//------------------------------------------------------------------------------
enum Operation {
    noop,
    simulate,
    climb,
    climb_forts,
    anneal,
    reorder,
    debug,
    debuguntil,
};
//------------------------------------------------------------------------------
struct ParsedInput
{
    bool err;
    unsigned opt_num_threads;
    Cards all_cards;
    Decks decks;
    std::vector<Deck*> your_decks;
    std::vector<Deck*> enemy_decks;
    std::vector<long double> factors;
    gamemode_t gamemode;
    std::array<signed short, PassiveBGE::num_passive_bges> opt_bg_effects[2];
    std::vector<SkillSpec> opt_bg_skills[2];
    std::vector<std::tuple<unsigned, unsigned, Operation>> opt_todo;
};

//------------------------------------------------------------------------------
#ifndef TEST
int main(int argc, char** argv);
#endif

ParsedInput parse_input(int argc, char** argv);
FinalResults<long double> compute_score(const EvaluatedResults& results, std::vector<long double>& factors);
