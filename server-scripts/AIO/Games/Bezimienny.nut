print("LOAD: GAME BEZIMIENNY");

enum GameBeziPackets
{
	EQFORSOLDIER = 1001,
	EQFORBEZI = 1002,
	ATRFORSOLDIER = 1003,
	ATRFORBEZI = 1004,
	IDOFBEZI = 1005,
	UPDATESCORE = 1006,
	STARTGAME = 1007,
	SENDTIME = 1008
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
	parameters = null;
	
	// I N I T
	function Init()
	{
		timers ={};
		events ={};
	
		system ={
			players	= [],
			bezimienny = -1,
			
			state = GameState.INIT,
			gameTime = Timer(TimerModes.TOZERO),
			
			points ={
				beziSuicide = -500,
				teamKill = -150,
				suicide = -100,
				hitBezi = 10,
				killSoldier = 50,
				killBezi = 100,
			},
		};
		
		parameters ={
			minPlayers = 3,
			roundTime = 5*60, 
			delayTime = 1*60,
			mapSpawns = "spawns_castle",
			mapVobs = "NULL",
				
			soldierAtr = HeroAttributes(360, 0, 54, 35,
									100, 100, 0, 100, 0,
									0, 0, 0, 0),
			soldierEq = HeroEquipment(),
									
			beziAtr = HeroAttributes(1000, 0, 55, 0,
									0, 100, 0, 0, 0,
									0, 0, 0, 0),
			beziEq = HeroEquipment(),
		};
		
		StandardEquipment();
		StandardFunctions();
		GameInitPlayers();
	}
		
	function DeInit()
	{
		timers = null;
		system = null;
		events = null;
		parameters = null;
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
		parameters.soldierEq.Add("GRD_ARMOR_M", 1, 1, ItemType.ARMOR);
		parameters.soldierEq.Add("ITMW_1H_SWORD_LONG_05", 1, 1, ItemType.MELLE);
		parameters.soldierEq.Add("ITRW_CROSSBOW_01", 1, 1, ItemType.DISTANCE);
		parameters.soldierEq.Add("ITAMBOLT", 10, 1, ItemType.OTHER);
		
		//Bezimienny equipment
		parameters.beziEq.Add("ORE_ARMOR_H", 1, 1, ItemType.ARMOR);
		parameters.beziEq.Add("MYTHRILKLINGE03", 1, 1, ItemType.MELLE);
	}
	
	function SendPacketToAll(packet, prior = 1)
	{
		foreach(player in system.players)
		{
			sendPacket(player.id, prior, packet);
		}
	}
	
	function GameInitPlayers()
	{
		LoadPlayers();
		system.gameTime.SetTime(parameters.roundTime * 100);
		SendPacketToAll(format("%d Bezimienny" ,GameSystemPacket.INIT_GAME), 2);
		SendPacketToAll(format("%d %d", GameBeziPackets.SENDTIME, system.gameTime.GetTime()), 2);
		GameStartSendParameters();
		timers.startGame <- setTimerClass(this, "GameStart", 3000, false);
	}
	
	function LoadPlayers()
	{
		foreach(id in gameSystem.players)
		{
			system.players.push(PlayerParameters(id));
		}
	}

	function GetIndexPlayer(id)
	{
		for(local i=0; i<system.players.len(); i++)
		{
			if(system.players[i].id == id)
			{
				return i;
			}
		}
		//Wykluczone!!!
		return -1;
	}	
	
	function GameStartSendParameters(player = -1)
	{
		local paramsAtrB = GameBeziPackets.ATRFORBEZI + " " + parameters.beziAtr.tostring();
		local paramsEqB = GameBeziPackets.EQFORBEZI + " " + parameters.beziEq.tostring();
		
		local paramsAtrS = GameBeziPackets.ATRFORSOLDIER + " " + parameters.soldierAtr.tostring();
		local paramsEqS = GameBeziPackets.EQFORSOLDIER + " " + parameters.soldierEq.tostring();
		
		if(player == -1)
		{
			foreach(pid in gameSystem.players)
			{
				sendPacket(pid, 1, paramsAtrB);
				sendPacket(pid, 1, paramsEqB);
				sendPacket(pid, 1, paramsAtrS);
				sendPacket(pid, 1, paramsEqS);
			}
		}
		else
		{
			sendPacket(player, 1, paramsAtrB);
			sendPacket(player, 1, paramsEqB);
			sendPacket(player, 1, paramsAtrS);
			sendPacket(player, 1, paramsEqS);
		}
	}
	
	function ChooseBezimienny()
	{
		local newBezi = -1;
		do
		{
			if(system.players.len() == 0){	break;}
			newBezi = system.players[random(system.players.len())].id;
		}while(newBezi == system.bezimienny && system.players.len() > 1)
		SetNewBezimienny(newBezi);
	}
	
	function SetNewBezimienny(id)
	{
		system.bezimienny = id;
		SendPacketToAll(format("%d %d", GameBeziPackets.IDOFBEZI, system.bezimienny));
	}
	
	//G A M E ___ S T A R T 
	function GameStart()
	{
		HookCallbacks();
		system.gameTime.Start();
		SendPacketToAll(format("%d XXX", GameBeziPackets.STARTGAME), 2);
		timers.scoreboard <- setTimerClass(this, "SendScroreBoard", 3000, true);
		ChooseBezimienny();
		SendScroreBoard();
	}
	
	//G A M E ___ L O G I C
	function BeziKillSoldier(bezi, soldier)
	{
		AddPoints(bezi, system.points.killSoldier);
	}
	
	function SoldierKillBezi(soldier, bezi)
	{
		AddPoints(soldier, system.points.killBezi);
		SetNewBezimienny(soldier);
	}
	
	function SoldierHitBezi(soldier, bezi)
	{
		AddPoints(pid, system.points.hitBezi);
	}
	
	function Suicide(victim)
	{
		if(victim == system.bezimienny)
		{
			AddPoints(victim, system.points.beziSuicide);
			ChooseBezimienny();
		}
		else
		{
			AddPoints(victim, system.points.suicide);
		}
	}
	
	function TeamKill(killer, victim)
	{
		AddPoints(killer, system.points.teamKill);
	}
	
	function AddPoints(id, value)
	{
		system.players[GetIndexPlayer(id)].SetPoints(value, "+");
	}
	
	function SendScroreBoard()
	{
		local packet = GameBeziPackets.UPDATESCORE.tostring();
		foreach(player in system.players)
		{
			packet += format(" %d %s %d", player.id, ConvertName(player.name, " ", "_"), player.points);
		}
		
		SendPacketToAll(packet)
	}

	//C A L L B A C K S
	function HookCallbacks()
	{
		eventsJoin.Add("onJoin", this);
		eventsDisconect.Add("onDisconnect", this);
		eventsHit.Add("onHit", this);
		eventsDie.Add("onDie", this);
		eventsTimersEnd.Add("onTimerEnd", this);
	}
	
	function onDie(victim, killer)
	{
		if(killer == -1)
		{
			Suicide(victim);
		}
		else if(system.bezimienny == victim)
		{
			SoldierKillBezi(killer, victim);
		}
		else if(system.bezimienny == killer)
		{
			BeziKillSoldier(killer, victim);
		}
		else
		{
			TeamKill(killer, victim)
		}
		SendScroreBoard();
	}
	
	function onHit(killer, target)
	{
		if(target == system.bezimienny && killer > 0)
		{
			SoldierHitBezi(killer, target)
		}
	}
	
	function onJoin(id)
	{
		switch(system.state)
		{
		case GameState.INIT:
			
			break;
		case GameState.STARTED: 
		
			break;
		}
	}
	
	function onDisconnect(id, reason)
	{
		system.players.remove(GetIndexPlayer(id))
		if(id == system.bezimienny)
		{
			ChooseBezimienny();
		}
	}
	
	function JoinBeforeStart(id)
	{
		GameStartSendParameters(id);
	}
	
	function JoinAfterStart(id)
	{
		GameStartSendParameters(id);
		sendPacket(id, 2, format("%d %d", GameBeziPackets.IDOFBEZI, system.bezimienny));
		sendPacket(id, 1, format("%d %d", GameBeziPackets.SENDTIME, system.gameTime.GetTime()))
		SendScroreBoard();
	}

	function onTimerEnd(object)
	{
		if(object == system.gameTime)
		{
			sendMessageToAll(0, 255, 0, "Gra skończona");
		}
	}	
}
