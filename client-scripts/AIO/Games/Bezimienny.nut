
enum GameBeziTeams
{
	SOLDIERS,
	BEZI,
}

enum GameBeziPackets
{
	BEZICALLFUNC = 1000,	//S<->C
	EQFORSOLDIER = 1001,	//S->C
	EQFORBEZI = 1002,		//S->C
	ATRFORSOLDIER = 1003,	//S->C
	ATRFORBEZI = 1004,		//S->C
	UPDATESCORE = 1005,		//S->C
	GAMESTART = 1006,		//S->C
	GAMEEND = 1007,			//S->C
	SENDTIME = 1008,		//S->C
}

enum GameBeziFuncs
{
	BEZI_KILL_SOLDIER,
	SOLDIER_KILL_BEZI,
	SOLDIER_HIT_BEZI
}

class GameBezimienny extends StandardProperties
{
	system = null;
	events = null;
	
	//I N I T 
	function init()
	{
		base.constructor();
		events ={};
		system ={
			state = GameState.INIT,
			bezimiennyID = -1,
			gameTime = -1,
			
			soldierEq = HeroEquipment(),						
			beziEq = HeroEquipment(),
			soldierAtr = null,
			beziAtr = null,
			gameTimer = Timer(TimerModes.TOZERO),
			spawns = Spawns(),
		}
		
		draws.gameTimer <- system.gameTimer.ConnectDraw(6000, 200, "FONT_OLD_20_WHITE_HI.TGA", 255, 255, 255);
		CreateScoreBoard();

		hookCallbacksInit()
	} 
	
	function deinit()
	{
		base.destroyProperties();
		system = null;
		events = null;
	}
	//W A I T ___ F O R  ___ P A R A M S
	function getStandardEquipment(forWho, params)
	{
		if(forWho == GameBeziTeams.SOLDIERS)
		{
			system.soldierEq.convert(params);
		}
		else if(forWho == GameBeziTeams.BEZI)
		{
			system.beziEq.convert(params);
		}	
	}
	
	function getStandarHeroAttributes(forWho, params)
	{
		
		//Hp, mp, str, dex,
		//1h, 2h, bow, cbow, mlvl,
		local atr = sscanf("ddddddddd", params);
		if(atr)
		{
			if(forWho == GameBeziTeams.SOLDIERS)
			{
				system.soldierAtr = HeroAttributes(atr[0], atr[1], atr[2], atr[3],
										atr[4], atr[5], atr[6], atr[7], atr[8]);
			}
			else if(forWho == GameBeziTeams.BEZI)
			{
				system.beziAtr = HeroAttributes(atr[0], atr[1], atr[2], atr[3],
										atr[4], atr[5], atr[6], atr[7], atr[8]);				
			}
		}
	}

	function importSpawns(data)
	{
		system.spawns.convert(data);
	}
	
	function LoadHero()
	{
		if(IAmBezimienny())
		{
			system.beziAtr.UpdateHero();
			system.beziEq.EquipHero();
		}
		else
		{
			system.soldierAtr.UpdateHero();
			system.soldierEq.EquipHero();
		}
		
		system.spawns.respawn();
	}

	function CreateScoreBoard()
	{
		draws.scoreBoard <- [];
		for(local i=0; i<20 ; i++)
		{
			local newDraw = createDraw("", "FONT_OLD_10_WHITE_HI.TGA",
					6500, 100 + i * PxToPoint(20,"y"), 255, 255, 255);
			draws.scoreBoard.push(newDraw);
			setDrawVisible(newDraw, true);
		}
	}
	
	function GetRespawnPositions(data)
	{
			scores += " protectionWord";
	}
	//G A M E ___ S T A R T
	function GameStart()
	{
		system.state = GameState.STARTED;
		hookCallbacks();
		
		LoadHero();
		system.gameTimer.Start();
	}
	
	function GameEnd(data)
	{
		local scores = sscanfMulti("ds", data);
		for(local i=0; i<scores.len(); i++)
		{
			local text = format("%d - %s", scores[i][0], scores[i][1]);
			local index = format("endScores%d",i);
			draws[index] <- createDraw(text, "FONT_OLD_20_WHITE_HI.TGA",
					3000, GetLinePos(2500, 25, i), 255, 255, 255);
			setDrawVisible(draws[index], true);
		}		
		unhookCallbacks();
		timers.sameEnd <- setTimerClass(gameSystem, "endGame", 5000, false)
	}
	
	function UpdateScore(scores)
	{	
		scores += " protectionWord"
		local index = 0;
		do
		{
			local params = sscanf("dsds", scores)
			if(params)
			{
				if(params[0] == system.bezimiennyID)
				{
					setDrawColor(draws.scoreBoard[index], 255, 0, 0);
				}
				else
				{
					setDrawColor(draws.scoreBoard[index], 255, 255, 255);
				}
				setDrawText(draws.scoreBoard[index], format("%04d : %s (%d)", params[2], convertName(params[1], "_", " "), params[0]));
				index++;
				scores = params[3];
			}
			else
			{
				break;
			}
		}while(true && index < 20);
		
		for(index; index<20; index++)
		{
			setDrawText(draws.scoreBoard[index], "");
		}
	}

	function BecomeTheBezimienny()
	{
		completeHeal();
		system.beziAtr.UpdateHero();
		system.beziEq.EquipHero();
	}
	
	function IAmBezimienny()
	{
		return system.bezimiennyID == gameSystem.myId;
	}
	
	function newBezimienny(beziid)
	{
		if(IAmBezimienny() && system.bezimiennyID != beziid)
		{
			system.bezimiennyID = beziid;
			LoadHero();
		}
		else
		{
			system.bezimiennyID = beziid;
			if(IAmBezimienny())
			{
				BecomeTheBezimienny();
			}
		}
	}
	// CALLBACKS
	function hookCallbacksInit()
	{
		eventsPacket.Add("onPacket", this);
	}
	
	function hookCallbacks()
	{
		eventsRespawn.Add("onRespawn", this);
		eventsDie.Add("onDie", this);
	}
	
	function unhookCallbacks()
	{
		eventsPacket.Add("onPacket", this);
		eventsRespawn.Remove("onRespawn", this);
		eventsDie.Remove("onDie", this);
	}

	function onPacket(packetID, data)
	{
		switch(packetID)
		{
		case GameBeziPackets.BEZICALLFUNC:
			compilestring(data)();
            break;
		case GameBeziPackets.EQFORSOLDIER:
			getStandardEquipment(GameBeziTeams.SOLDIERS, data);
			break;
		case GameBeziPackets.EQFORBEZI:
			getStandardEquipment(GameBeziTeams.BEZI, data);
			break;
		case GameBeziPackets.ATRFORSOLDIER:
			getStandarHeroAttributes(GameBeziTeams.SOLDIERS, data);
			break;
		case GameBeziPackets.ATRFORBEZI:
			getStandarHeroAttributes(GameBeziTeams.BEZI, data);
			break;
		case GameBeziPackets.SENDTIME:
			system.gameTimer.SetTime(data.tointeger());
			break;
		case GameBeziPackets.UPDATESCORE:
			UpdateScore(data);
			break;
		case GameBeziPackets.GAMESTART:
			GameStart();
			break;
		case GameBeziPackets.GAMEEND:
			GameEnd(data);
			
		}
	}
	
	function onRespawn()
	{
		completeHeal();
		LoadHero();
	}	

	function onDie()
	{
		if(IAmBezimienny())
		{
			system.bezimiennyID = -1;
		}
	}
}
