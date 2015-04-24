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
			minPlayers = 3,
			
			gameTime = Timer(TimerModes.TOZERO),
			//roundTime = 5*60*10, 
			roundTime = 30*10, 
			delayTime = 1*60*10, 
			points ={
				beziSuicide = -500,
				teamKill = -150,
				suicide = -100,
				hitBezi = 10,
				killSoldier = 50,
				killBezi = 100,
			},
			
			soldierAtr = HeroAttributes(360, 0, 54, 35,
									100, 100, 0, 100, 0,
									0, 0, 0, 0),
			soldierEq = HeroEquipment(),
									
			beziAtr = HeroAttributes(1000, 0, 55, 0,
									0, 100, 0, 0, 0,
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
		system.soldierEq.Add("ITRW_CROSSBOW_01", 1, 1, ItemType.DISTANCE);
		system.soldierEq.Add("ITAMBOLT", 10, 1, ItemType.OTHER);
		
		//Bezimienny equipment
		system.beziEq.Add("ORE_ARMOR_H", 1, 1, ItemType.ARMOR);
		system.beziEq.Add("MYTHRILKLINGE03", 1, 1, ItemType.MELLE);
	}
	
	function SendPacketToAll(packet, prior = 1)
	{
		foreach(player in system.players)
		{
			sendPacket(player.id, prior, packet);
		}
	}
	
	//W A I T ___ F O R ___ P L A Y E R S
	function GameInitPlayers()
	{
		LoadPlayers();
		system.gameTime.SetTime(system.roundTime * 100);
		SendPacketToAll(format("%d Bezimienny" ,GameSystemPacket.INIT_GAME), 2);
		SendPacketToAll(format("%d %d", GameBeziPackets.SENDTIME, system.gameTime.GetTime()), 2);
		GameStartSendParameters();
		timers.startGame <- setTimerClass(this, "GameStart", 3000, false);
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
			if(system.players.len() > 0){	break;}
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
			if(system.players[i].id == id)
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
	
	function onDie(pid, kid)
	{
		if(system.bezimienny == pid)
		{
			if(kid > 0)
			{
				AddPoints(kid, system.points.killBezi);
				SetNewBezimienny(kid);
			}
			else
			{
				print("BEZI SUICIDE " + pid + " Killed by " + kid)
				AddPoints(pid, system.points.beziSuicide);
				ChooseBezimienny();
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
		SendScroreBoard();
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
