dofile("server-scripts\\AIOScripts\\PlayerParameters.nut");
dofile("server-scripts\\AIOScripts\\HeroAttributes.nut");
dofile("server-scripts\\AIOScripts\\HeroEquipment.nut");

enum GameBeziFuncs
{
	BEZI_KILL_SOLDIER,
	SOLDIER_KILL_BEZI,
	SOLDIER_HIT_BEZI
}

	
class GameBezimienny
{
	timers = null;
	system = null;
	events = null;

	
	constructor()
	{
		timers ={};
		system ={};
		events ={};
	}
	function OnInit()
	{
		system ={
			state = GameState.OFF,
			players	= [],
			soldiers = [],
			bezimienny = -1,
			
			gameTime = -1,
			roundTime = 5*60,
			delayTime = 1*60,
			
			soldierAtr = HeroAttributes(100, 0, 50, 50,
									2, 2, 2, 2, 0,
									0, 0, 0, 0),
			soldierEq = HeroEquipment(),
									
			beziAtr = HeroAttributes(1000, 0, 100, 0,
									2, 2, 0, 0, 0,
									0, 0, 0, 0),
			beziEq = HeroEquipment(),

		}
		system.state = GameState.WAIT;
		system.gameTime = delayTime;
		StandardEquipment();
		StandardFunctions();
		LoadPlayers();
	}
	
	function LoadPlayers()
	{
		foreach(id in game.players)
		{
			players.push(PlayerParameters(id));
		}
	}
	
	function StandardFunctions()
	{
		events[GameBeziFuncs.BEZI_KILL_SOLDIER] = EventHandler();
		events[GameBeziFuncs.SOLDIER_KILL_BEZI] = EventHandler();
		events[GameBeziFuncs.SOLDIER_HIT_BEZI]  = EventHandler();
		
		events[GameBeziFuncs.BEZI_KILL_SOLDIER] + BeziKillSoldier;
		events[GameBeziFuncs.SOLDIER_KILL_BEZI] + SoldierKillBezi;
		events[GameBeziFuncs.SOLDIER_HIT_BEZI]  + SoldierHitBezi;
	} 
	
	
	function StandardEquipment()
	{
		//Soldier equipment
		soldierEq.Add("GRD_ARMOR_M", 1, 1);
		soldierEq.Add("ITMW_1H_SWORD_LONG_05", 1, 1);
		soldierEq.Add("ITRW_CROSSBOW_03", 1, 1);
		soldierEq.Add("ITAMBOLT", 10, 1);
		
		//Bezimienny equipment
		beziEq.Add("ORE_ARMOR_H", 1, 1);
		beziEq.Add("MYTHRILKLINGE03", 1, 1);
	}
	
	function OnKill(eventParams)
	{
		//pid, kid
	}
	
	function OnHit(eventParams)
	{
		//pid, tid
	}
	
	function GameStart()
	{
		// Get Bezimienny
		local nextBezi = rand(0, system.players.len() - 1);
		for(local i= 0; i < system.players.len(); i++)
		{
			if(i == nextBezi){ continue;}
			system.soldiers.push(system.players[i].id);
		}
		
		system.bezimienny = system.players[nextBezi].id;
	}
	
	//Logic 
	function BeziKillSoldier(beziID, soldierID)
	{
	
	}
	
	function SoldierKillBezi(soldierID, beziID)
	{
	
	}
	
	function SoldierHitBezi(soldierID, beziID)
	{
	
	}
	
	function AddPoints()
	{
	
	}

}

