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
Result run_sim(int argc,const char** argv)
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
    res= std::make_pair(fr,debug_str + output.str());
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


BOOST_AUTO_TEST_CASE(test_sim_init)
{
    init();
    debug_print++;
    debug_cached++;
    debug_line =true;
    BOOST_CHECK(1==1);
}

BOOST_AUTO_TEST_CASE(test_run_sim2)
{
    const char* argv[] = {"tuo","Darius, Obsidian Overlord","Darius, Infantry","sim", "10"}; //single thread!
    Result result(run_sim(sizeof(argv)/sizeof(*argv),argv));
    check_win(result);
}
BOOST_AUTO_TEST_CASE(test_run_sim)
{
    //const char* argv[] = {"tuo","Mission#10","Mission#10","sim", "10"};
    //Result result(run_sim(sizeof(argv)/sizeof(*argv),argv));
    BOOST_CHECK(1==1);
}
BOOST_AUTO_TEST_CASE(test_run_sim3)
{
    BOOST_CHECK(1==2);
}
#endif
#endif
