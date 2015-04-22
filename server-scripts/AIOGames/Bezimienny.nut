print("LOAD: GAME BEZIMIENNY");

enum GameBeziPackets
{
	EQFORSOLDIER = 1001,
	EQFORBEZI = 1002,
	ATRFORSOLDIER = 1003,
	ATRFORBEZI = 1004,
	IDOFBEZI = 1005,
	UPDATESCORE = 1006,
	STARTGAME = 1007
}

enum GameBeziFuncs
{
	BEZI_KILL_SOLDIER,
	SOLDIER_KILL_BEZI,
	SOLDIER_HIT_BEZI
}

class GameBezimienny
{
	//O F F
	timers = null;
	system = null;
	events = null;
	
	constructor()
	{
		timers ={};
		system ={ state = GameState.OFF,};
		events ={};
	}
	// I N I T
	function OnInit()
	{
		system ={
			state = GameState.INIT,
			players	= [],
			soldiers = [],
			bezimienny = -1,
			
			gameTime = -1,
			roundTime = 5*60,
			delayTime = 1*60,
			points ={
				beziSuicide = -500,
				teamKill = -150,
				suicide = -100,
				hitBezi = 10,
				killSoldier = 50,
				killBezi = 100,
			},
			
			soldierAtr = HeroAttributes(100, 0, 50, 50,
									2, 2, 2, 2, 0,
									0, 0, 0, 0),
			soldierEq = HeroEquipment(),
									
			beziAtr = HeroAttributes(1000, 0, 100, 0,
									2, 2, 0, 0, 0,
									0, 0, 0, 0),
			beziEq = HeroEquipment(),

		}
		StandardEquipment();
		StandardFunctions();
		//eventsStart
		//eventsEnd
	}
		
	function StandardFunctions()
	{
		events[GameBeziFuncs.BEZI_KILL_SOLDIER] <- EventHandler();
		events[GameBeziFuncs.SOLDIER_KILL_BEZI] <- EventHandler();
		events[GameBeziFuncs.SOLDIER_HIT_BEZI]  <- EventHandler();
		
		events[GameBeziFuncs.BEZI_KILL_SOLDIER].Add("BeziKillSoldier", this);
		events[GameBeziFuncs.SOLDIER_KILL_BEZI].Add("SoldierKillBezi", this);
		events[GameBeziFuncs.SOLDIER_HIT_BEZI].Add("SoldierHitBezi", this);
	} 
		
	function StandardEquipment()
	{
		//Soldier equipment
		system.soldierEq.Add("GRD_ARMOR_M", 1, 1, ItemType.ARMOR);
		system.soldierEq.Add("ITMW_1H_SWORD_LONG_05", 1, 1, ItemType.MELLE);
		system.soldierEq.Add("ITRW_CROSSBOW_03", 1, 1, ItemType.DISTANCE);
		system.soldierEq.Add("ITAMBOLT", 10, 1, ItemType.OTHER);
		
		//Bezimienny equipment
		system.beziEq.Add("ORE_ARMOR_H", 1, 1, ItemType.ARMOR);
		system.beziEq.Add("MYTHRILKLINGE03", 1, 1, ItemType.MELLE);
	}
	
	//W A I T ___ F O R ___ P L A Y E R S
	function GameInitPlayers()
	{
		LoadPlayers();
		foreach(player in system.players)
		{
			sendPacket(2, player.id, format("%d Bezimienny" ,GameSystemPacket.INIT_GAME));
		}
		
		GameStartSendParameters();
		ChooseBezimienny();
		HookCallbackToGlobal();
		timers.startGame <- setTimer(this["GameStart"], 3000, false);
	}
	
	function LoadPlayers()
	{
		foreach(id in game.players)
		{
			system.players.push(PlayerParameters(id));
		}
	}
		
	function GameStartSendParameters(player = -1)
	{
		local paramsAtrB = GameBeziPackets.ATRFORBEZI + " " + system.beziAtr.tostring();
		local paramsEqB = GameBeziPackets.EQFORBEZI + " " + system.beziEq.tostring();
		
		local paramsAtrS = GameBeziPackets.ATRFORSOLDIER + " " + system.soldierAtr.tostring();
		local paramsEqS = GameBeziPackets.EQFORSOLDIER + " " + system.soldierEq.tostring();
		
		if(player == -1)
		{
			foreach(pid in game.players)
			{
				sendPacket(1, pid, paramsAtrB);
				sendPacket(1, pid, paramsEqB);
				sendPacket(1, pid, paramsAtrS);
				sendPacket(1, pid, paramsEqS);
			}
		}
		else
		{
			sendPacket(1, player, paramsAtrB);
			sendPacket(1, player, paramsEqB);
			sendPacket(1, player, paramsAtrS);
			sendPacket(1, player, paramsEqS);
		}
	}
	
	function ChooseBezimienny()
	{
		local nextBezi = 0 //rand(0, system.players.len() - 1);
		system.bezimienny = system.players[nextBezi].id;
		for(local i= 0; i < system.players.len(); i++)
		{
			if(i != nextBezi)
			{
				system.soldiers.push(system.players[i].id);
			}
			sendPacket(1, system.players[i].id, format("%d %d", GameBeziPackets.IDOFBEZI, system.bezimienny));
		}
	}
	
	//G A M E ___ S T A R T 
	function GameStart()
	{
		print("start Game");
		HookCallbackToGlobal();
		SendPacketToAll(format("%d XXX", GameBeziPackets.STARTGAME));
		timers.scoreboard = setTimer(this.SendScroreBoard, 3000, true);
	}
	
	function HookCallbackToGlobal()
	{
		eventsJoin.Add("onJoin", this);
		eventsDisconect.Add("onDisconnect", this);
		eventsHit.Add("onHit", this);
		eventsDie.Add("onDie", this);
	}
	//G A M E ___ L O G I C
	function BeziKillSoldier(beziID, soldierID)
	{
	}
	
	function SoldierKillBezi(soldierID, beziID)
	{
	
	}
	
	function SoldierHitBezi(soldierID, beziID)
	{
	
	}
	
	function AddPoints(id, value)
	{
		system.players[GetIndexPlayer(id)].SetPoints(value, "+");
	}

	function GetIndexPlayer(id)
	{
		for(local i=0; i<system.players.len(); i++)
		{
			if(system.players[i].id = id)
			{
				return i;
			}
		}
		//Wykluczone!!!
		return -1;
	}
	
	function SendScroreBoard()
	{
		local packet = GameBeziPackets.UPDATESCORE.tostring();
		foreach(player in system.players)
		{
			packet += format(" %d %s %d", player.id, ConvertName(player.name, " ", "_"), player.points);
		}
		
		print("Score board " + packet);
		SendPacketToAll(packet)
	}

	function SendPacketToAll(packet)
	{
		foreach(player in system.players)
		{
			sendPacket(1, player.id, packet);
		}
	}
	//C A L L B A C K S
	function onDie(pid, kid)
	{
		if(system.bezimienny == pid)
		{
			if(kid > 0)
			{
				AddPoints(kid, system.points.killBezi);
			}
			else
			{
				AddPoints(pid, system.points.beziSuicide);
				//Losowo wybierz Bezimiennego
			}
		}
		else if(system.bezimienny == kid)
		{
			AddPoints(kid, system.points.killSoldier);
		}
		else if(kid == -1)
		{
			AddPoints(pid, system.points.suicide);
		}
		else
		{
			AddPoints(kid, system.points.teamKill);
		}
	}
	
	function onHit(pid, tid)
	{
		if(tid == system.bezimienny && pid > 0)
		{
			AddPoints(pid, system.points.hitBezi);
		}
	}
	
	function onJoin(id)
	{
		switch(system.state)
		{
		case GameState.WAIT:
			
			break;
		case GameState.STARTED: 
		
			break;
		}
	}
	
	function onDisconnect(id, reason)
	{
	
	}
	
	function JoinBeforeStart(id)
	{
		GameStartSendParameters(id);
		system.soldiers.push(id);
		sendPacket(2, id, format("%d %d", GameBeziPackets.IDOFBEZI, system.bezimienny));
	}
	
	function JoinAfterStart(id)
	{
	
	}
}
