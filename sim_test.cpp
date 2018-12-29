#ifdef TEST
#ifdef NQUEST // only without quests
#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MODULE sim

#include<boost/test/included/unit_test.hpp>

#include "tyrant_optimize.h"

inline FinalResults<long double> run_sim(int argc,const char** argv)
{
    char** param = new char*[argc];
    for(int i = 0; i < argc;i++)
      param[i] = const_cast<char*>(argv[i]);
    unsigned seed =0; //hard seed
    ParsedInput pi(parse_input(argc,param));
    BOOST_CHECK(!pi.err);
    SimulationData* sd = new SimulationData(seed,pi.all_cards,pi.decks,pi.your_decks.size(),pi.enemy_decks.size(),pi.factors,pi.gamemode,
                  pi.opt_bg_effects[0],pi.opt_bg_effects[1],pi.opt_bg_skills[0],pi.opt_bg_skills[1]);
    sd->set_decks(pi.your_decks,pi.enemy_decks);
    BOOST_CHECK(!pi.err);
    std::vector<Results<uint64_t>> results{sd->evaluate()};
    BOOST_CHECK(!pi.err);
    EvaluatedResults er = {EvaluatedResults::first_type(pi.enemy_decks.size()*pi.your_decks.size()),0};
    for(unsigned i =0; i < results.size();i++)
    {
        er.first[i] += results[i];
    }
    ++er.second;
    FinalResults<long double> fr = compute_score(er,sd->factors);
    return fr;
}


BOOST_AUTO_TEST_CASE(test_test1)
{
    ++(++debug_print);
    BOOST_CHECK(1==1);
}

BOOST_AUTO_TEST_CASE(test_run_sim2)
{
    std::cout << "Test" << std::endl;

    int argc = 5;
    const char* argv[argc] = {"tuo","Mission#10","Mission#10","sim", "10"};

    std::cout << "Test" << std::endl;
    FinalResults<long double> result(run_sim(argc,argv));
    BOOST_CHECK(1==2);
}
BOOST_AUTO_TEST_CASE(test_run_sim)
{
    int argc = 5;
    const char* argv[argc] = {"tuo","Mission#10","Mission#10","sim", "10"};

    std::cout << "Test" << std::endl;
    FinalResults<long double> result(run_sim(argc,argv));
    BOOST_REQUIRE_MESSAGE(1==2,"Test");
    BOOST_TEST_MESSAGE("" << 5 << "|" << 6);
    BOOST_TEST_MESSAGE("" << result.points << "|" << result.wins) ;
    BOOST_CHECK(1==1);
}
BOOST_AUTO_TEST_CASE(test_run_sim3)
{
    BOOST_CHECK(1==2);
}
#endif
#endif
