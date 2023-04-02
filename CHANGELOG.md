
**v6.0.0**
* Add machine learning in data/*.pmml
* To train you own model checkout ml/README.md

**v5.0.0**
* Add database in data/database.yml 

**v4.0.0**
* With '-p' or 'params' you can specify a file from where to load tuo parameters.

**v2.58.10**
* Renamed Dominion options are 'dom-none', 'dom-owned' and 'dom-maxed'. 
* 'dom+' = 'dom-owned', dominions from deck and ownedcards. **(default)**
* 'dom-' = 'dom-maxed', all maxed dominions and those from deck and ownedcards.
* nothing = 'dom-none', only the dominion in the deck will be used as a dominion.

**v2.58.07**
*  Support Bravery Skill 

**v2.58.04**
* New option 'mono' or '-m' followed by a faction's name.
* E.g. 'mono imperial', will only consider imperial cards (commander, units, structures and dominion) to improve the start deck.
* Note that, when the sim is started with cards from other factions these might still show up in the final simmed deck.

**v2.58.00 **    
* New climb-algorithm simulated annealing
* The algorithm is heavily stochastic, so don't expect the same results from runnning the same sim (except using same seeds).
* By now this algorithm is still being tested.
* It takes(similar to climbex) three parameters:
	* itterations (recommended: 500)
	* initial 'temperature' (recommended: 100)
	* exponetial decrease of temperature (recommended: 0.001)

**v2.57.05**
*  Support Absorb Skill 

**v2.56.0**
*  Negative Attacks Subdue Bug fixed
*  New dominion options:
  * 'dom+': will sim all dominions in your inventory and deck
  * 'dom-': will sim all maximum dominions and all dominions in your inventory and deck
  * '   ' : the dominion in the curent deck will be used
  * Adding Dominion Shards to your inv doesn't change anything now.
  * To see which dominions are simmed use the verbose option '+v' and look for the message 'next Alpha Dominion candidate'

**v2.55.1:**
* 		The options/modes gw and gw-defense calculate the core damage score now.

**v2.54.8:**
* 		Cards like Hell King Hades, Bunker Builder,etc. did summon their cards on the trigger and at the end of their delay.
		