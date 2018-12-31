// exec: ./tuo-test , verbose: ./tuo-test --log_level=all
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

//pipe output: https://stackoverflow.com/questions/5405016/can-i-check-my-programs-output-with-boost-test
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
    //pipe output
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
inline void check_win_sim(const char* your_deck, const char* enemy_deck, const char* bge="") {
    const char* argv[] = {"tuo",your_deck,enemy_deck,"-e",bge,"sim", "10"}; //TODO hardcoded 10 iterations?
    Result result(run_sim(sizeof(argv)/sizeof(*argv),argv));
    check_win(result);
}
BOOST_AUTO_TEST_CASE(test_sim_init)
{
    init();
    debug_print++;
    debug_cached++;
    debug_line =true;
    BOOST_CHECK(1==1);//..
}
/////////////////////////////////////
// Test Cases !should! be very close fights for maximum sensitivity of errors
/////////////////////////////////////
BOOST_AUTO_TEST_SUITE(test_single_units)
//single units to avoid randomness
BOOST_AUTO_TEST_CASE(test_obsidian_infantry)
{
    check_win_sim("Darius,Obsidian Overlord","Darius,Infantry");
}
BOOST_AUTO_TEST_CASE(test_evermourner_evermourner)
{
    check_win_sim("Barracus the Traitor, Alpha Hardened, Evermourner","Barracus the Traitor, Alpha Hardened, Evermourner");
}
BOOST_AUTO_TEST_CASE(test_hellking_zuruwing)
{
    check_win_sim("Nexor the Farseer, Broodmother's Nexus, Hell King Hades","Barracus the Traitor, Alpha Hardened, Zuruwing Flock");
}
BOOST_AUTO_TEST_CASE(test_valley_optinax)
{
    check_win_sim("Dracorex Hivegod, Alpha Hardened, Valley Glider","Vyander Hazix, Alpha Hardened, Optinax Starcore");
}
BOOST_AUTO_TEST_CASE(test_hyper_prixis)
{
    check_win_sim("Cassius the Centurion, HyperSec Hunter,Alpha Cooperator ","Typhon the Insane, Alpha Cooperator, Prixis Worldbender");
}
BOOST_AUTO_TEST_CASE(test_toxblade_incisor)
{
    check_win_sim("Barracus the Traitor, Toxblade Squad,Alpha Cooperator ","Gaia the Purifier, Archmatron's Incisor,Alpha Cooperator");
}
BOOST_AUTO_TEST_CASE(test_toxblade_incisor)
{
    check_win_sim("Arkadios Ultimate, Coleopt Slash,Alpha Cooperator ","Barracus the Traitor, Examit Tranq,,Alpha Cooperator");
}

BOOST_AUTO_TEST_SUITE_END()
//------------------------
BOOST_AUTO_TEST_SUITE(test_multi_units)
//multiple units to test, with minimized randomness (same units and non-target skills)
BOOST_AUTO_TEST_CASE(test_hellkings_ruinmakers)
{
    check_win_sim("Nexor the Farseer, Broodmother's Nexus, Hell King Hades#2","Barracus the Traitor, Alpha Hardened, Enyo Ruinmaker");
}
BOOST_AUTO_TEST_CASE(test_vermins_samsons)
{
    check_win_sim("Dracorex Hivegod, Alpha Hardened, Writhing Vermin-1#4","Tabitha Liberated, Alpha Hardened, Samson the Hunter-1#4");
}
BOOST_AUTO_TEST_CASE(test_hellwings_rangers)
{
    check_win_sim("Dracorex Hivegod, Alpha Hardened, Scorched Hellwing#2","Nexor the Farseer, Alpha Hardened, Reunited Ranger#2");
}
BOOST_AUTO_TEST_CASE(test_rustwranglers_flayers)
{
    check_win_sim("Barracus the Traitor, Broodmother's Nexus, Rustwrangler","Dracorex Hivegod, Broodmother's Nexus, Sheol Flayer-1#8");
}
BOOST_AUTO_TEST_CASE(test_voxanis_ocelots)
{
    check_win_sim("Imperator Halcyon, Voxani Modus#2,Alpha Cooperator ","Typhon the Insane, Alpha Cooperator, Aerial Ocelot#3");
}
BOOST_AUTO_TEST_CASE(test_cataclysmitrices_eons)
{
    check_win_sim("Barracus the Traitor, Cataclysmitrice,Alpha Cooperator ","Arkadios Ultimate, Eon United#2, Broodmother's Nexus,");
}
BOOST_AUTO_TEST_CASE(test_echos_bonegatherers)
{
    check_win_sim("Barracus the Traitor, Echo Huntmaster,Alpha Cooperator ","Arkadios Ultimate, Bonegatherer-1#10, Broodmother's Nexus,");
}
BOOST_AUTO_TEST_SUITE_END()
//------------------------
BOOST_AUTO_TEST_SUITE(test_bges)
BOOST_AUTO_TEST_CASE(test_toxblades_incisors_virulence)
{
    check_win_sim("Barracus the Traitor, Toxblade Squad,Alpha Cooperator ","Gaia the Purifier, Archmatron's Incisor#2,Alpha Cooperator","Virulence");
}
BOOST_AUTO_TEST_CASE(test_parapets_darters_virulence)
{
    check_win_sim("Barracus the Traitor, Parapet Welder#3,Alpha Cooperator ","Broodmother Queen, Vile Darter#4,Alpha Cooperator","Virulence");
}
BOOST_AUTO_TEST_CASE(test_virklaws_parapets_virulence)
{
    check_win_sim("Arkadios Ultimate, Virklaw#4,Alpha Cooperator ","Barracus the Traitor, Parapet Welder#2,Alpha Cooperator","Virulence");
}
BOOST_AUTO_TEST_SUITE_END()
//------------------------
BOOST_AUTO_TEST_SUITE(test_whole_decks)
//full decks that always result in 100% WR
BOOST_AUTO_TEST_CASE(test_m142_m1)
{
    check_win_sim("Mission#142","Mission#1");
}
BOOST_AUTO_TEST_SUITE_END()
//------------------------
#endif
#endif
