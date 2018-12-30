#ifdef TEST
#ifdef NQUEST // only without quests
#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MODULE sim

#include <boost/test/included/unit_test.hpp>
#include <boost/test/output_test_stream.hpp>
#include <iostream>
#include "tyrant.h"
#include "tyrant_optimize.h"
#include "sim.h"
using namespace std;

typedef std::pair<FinalResults<long double>,std::string> Result;

struct cout_redirect {
    cout_redirect( std::streambuf * new_buffer )
        : old( std::cout.rdbuf( new_buffer ) )
    { }

    ~cout_redirect( ) {
        std::cout.rdbuf( old );
    }

private:
    std::streambuf * old;
};

inline Result run_sim(int argc,const char** argv)
{
    Result res;
    FinalResults<long double> fr;
    debug_str.clear();
    std::stringstream output;
    {
        cout_redirect guard( output.rdbuf( ) );
        //////////////////////
        // only single thread for string stream build
        //////////////////////
        char** param = new char*[argc+2];
        for(int i = 0; i < argc;i++)
          param[i] = const_cast<char*>(argv[i]);
        param[argc] = const_cast<char*>("-t");
        param[argc+1] = const_cast<char*>("1");
        fr = run(argc+2,param);
    }
    res= std::make_pair(fr,"\n" + debug_str + output.str());
    return res;
}

inline void check_win(Result result) {
    BOOST_CHECK_MESSAGE(
      1==result.first.wins &&
      0==result.first.losses &&
      0==result.first.draws
      ,result.second);
    //BOOST_CHECK(100==result.points);
}
inline void check_win_sim(const char* your_deck, const char* enemy_deck) {
    const char* argv[] = {"tuo",your_deck,enemy_deck,"sim", "10"}; //TODO hardcoede 10 iterations?
    Result result(run_sim(sizeof(argv)/sizeof(*argv),argv));
    check_win(result);
}
BOOST_AUTO_TEST_CASE(test_sim_init)
{
    init();
    debug_print++;
    debug_cached++;
    debug_line =true;
    BOOST_CHECK(1==1);
}

BOOST_AUTO_TEST_SUITE(test_single_units)
BOOST_AUTO_TEST_CASE(test_obsidian_infantry)
{
    check_win_sim("Darius,Obsidian Overlord","Darius,Infantry");
}
BOOST_AUTO_TEST_SUITE_END()

BOOST_AUTO_TEST_SUITE(test_whole_decks)
BOOST_AUTO_TEST_CASE(test_m142_m1)
{
    check_win_sim("Mission#2","Mission#1");
}
BOOST_AUTO_TEST_SUITE_END()
#endif
#endif
