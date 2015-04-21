print("LOAD: GAME BEZIMIENNY");

dofile("server-scripts\\AIOScripts\\PlayerParameters.nut");
dofile("server-scripts\\AIOScripts\\HeroAttributes.nut");
dofile("server-scripts\\AIOScripts\\HeroEquipment.nut");


enum GameBeziPackets
{
	GBP_EQFORSOLDIER = 1001,
	GBP_EQFORBEZI = 1002,
	GBP_ATRFORSOLDIER = 1003,
	GBP_ATRFORBEZI = 1004,
	GBP_IDOFBEZI = 1005,
}

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
		system.state = GameState.INITALIZE;
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
		soldierEq.Add("GRD_ARMOR_M", 1, 1, ItemType.IT_ARMOR);
		soldierEq.Add("ITMW_1H_SWORD_LONG_05", 1, 1, ItemType.IT_MELLE);
		soldierEq.Add("ITRW_CROSSBOW_03", 1, 1, ItemType.IT_DISTANCE);
		soldierEq.Add("ITAMBOLT", 10, 1, ItemType.IT_OTHER);
		
		//Bezimienny equipment
		beziEq.Add("ORE_ARMOR_H", 1, 1, ItemType.IT_ARMOR);
		beziEq.Add("MYTHRILKLINGE03", 1, 1, ItemType.IT_MELLE);
	}
	
	// CallBacks
	function OnDie(pid, kid)
	{
	
	}
	
	function OnHit(pid, tid)
	{

	}
	//GAME START
	function GameStart()
	{
		GameStartSendParameters();
		ChooseBezimienny();
	}
	
	function GameStartSendParameters()
	{
		local paramsAtrB = GBP_ATRFORBEZI + " " + system.beziAtr.tostring();
		local paramsEqB = GBP_EQFORBEZI + " " + system.beziEq.tostring();
		
		local paramsAtrS = GBP_ATRFORSOLDIER + " " + system.soldierAtr.tostring();
		local paramsEqS = GBP_EQFORSOLDIER + " " + system.soldierEq.tostring();
		
		foreach(pid in game.players)
		{
			sendPacket(pid, paramsAtrB);
			sendPacket(pid, paramsEqB);
			sendPacket(pid, paramsAtrS);
			sendPacket(pid, paramsEqS);
		}
	}
	
	function ChooseBezimienny()
	{
		local nextBezi = rand(0, system.players.len() - 1);
		system.bezimienny = system.players[nextBezi].id;
		for(local i= 0; i < system.players.len(); i++)
		{
			if(i != nextBezi)
			{
				system.soldiers.push(system.players[i].id);
			}
			sendPacket(system.bezimienny, paramsAtrB);
		}
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
