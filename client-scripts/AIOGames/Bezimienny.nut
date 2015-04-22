
enum GameBeziTeams
{
	SOLDIERS,
	BEZI
}

enum GameBeziPackets
{
	EQFORSOLDIER = 1001,
	EQFORBEZI = 1002,
	ATRFORSOLDIER = 1003,
	ATRFORBEZI = 1004,
	IDOFBEZI = 1005,
	UPDATESCORE = 1006,
	STARTGAME = 1007,
	SENDTIME = 1008,
}

enum GameBeziFuncs
{
	BEZI_KILL_SOLDIER,
	SOLDIER_KILL_BEZI,
	SOLDIER_HIT_BEZI
}

class GameBezimienny
{
	draws = null;
	textures = null;
	timers = null;
	vobs = null;
	system = null;
	events = null;
	
	constructor()
	{
		draws ={};
		textures ={};
		timers ={};
		vobs ={};
		system ={	state = GameState.OFF};
		events ={};
	}
	
	//I N I T 
	function onInit()
	{
		system ={
			state = GameState.WAIT,
			bezimiennyID = -1,
			gameTime = -1,
			
			soldierEq = HeroEquipment(),						
			beziEq = HeroEquipment(),
			soldierAtr = null,
			beziAtr = null,
		}
		
		CreateScoreBoard();
	} 
	//W A I T ___ F O R  ___ P A R A M S
	function GetStandardEquipment(forWho, params)
	{
		if(forWho == GameBeziTeams.SOLDIERS)
		{
			system.soldierEq.covertString(params);
		}
		else if(forWho == GameBeziTeams.BEZI)
		{
			system.beziEq.covertString(params);
		}	
	}
	
	function GetStandarHeroAttributes(forWho, params)
	{
		//Hp, mp, str, dex,
		//1h, 2h, bow, cbow, mlvl,
		//protS, protO, protA, prot M
		local atr = sscanf("ddddddddddddd", params);
		if(atr)
		{
			if(forWho == GameBeziTeams.SOLDIERS)
			{
				system.soldierAtr = HeroAttributes(atr[0], atr[1], atr[2], atr[3],
								atr[4], atr[5], atr[6], atr[7], atr[8], 
								atr[9], atr[10], atr[11], atr[12]);
			}
			else if(forWho == GameBeziTeams.BEZI)
			{
				system.beziAtr = HeroAttributes(atr[0], atr[1], atr[2], atr[3],
							atr[4], atr[5], atr[6], atr[7], atr[8], 
							atr[9], atr[10], atr[11], atr[12]);				
			}
		}
	}

	function LoadHero()
	{
		if(system.areYouBezi)
		{
			beziEq.EquipHero();
			beziAtr.UpdateHero();
		}
		else
		{
			soldierEq.EquipHero();
			soldierAtr.UpdateHero();
		}
	}

	function CreateScoreBoard()
	{
		addMessage(255,255,255, "CreateBOard");
		draws.scoreBoard <- [];
		for(local i=0; i<20 ; i++)
		{
			local newDraw = createDraw("", "FONT_OLD_10_WHITE_HI.TGA",
					5500, 100 + i * PxToPoint(20,"y"), 255, 255, 255);
			draws.scoreBoard.push(newDraw);
			setDrawVisible(newDraw, true);
		}
	}
	//G A M E ___ S T A R T
	function GameStart()
	{
		system.state = GameState.STARTED;
		addMessage(255, 255, 255, "Start");
		eventsPacket.Add("onPacket", this);
		eventsRespawn.Add("onRespawn", this);
	}
	
	function GameEnd()
	{
	
	}
	
	function BecomeTheBezimienny()
	{
		system.beziEq.EquipHero();
		system.beziAtr.UpdateHero();
	}
	
	function UpdateScore(scores)
	{	
		addMessage(255,255,255, "UpdateScore");
		local index = 0;
		do
		{
			local params = sscanf("dsds", scores)
			if(params)
			{
				if(packet[0] == system.bezimiennyID)
				{
					setDrawColor(draws.scoreBoard[index], 255, 0, 0);
				}
				else
				{
					setDrawColor(draws.scoreBoard[index], 255, 255, 255);
				}
				setDrawText(draws.scoreBoard[index], format("%40d : %s (%d)"),params[2], ConvertName(params[1], "_", " ", params[0]));
				index++;
			}
			else
			{
				local params = sscanf("dsd", scores)
				if(params)
				{
					if(packet[0] == system.bezimiennyID)
					{
						setDrawColor(draws.scoreBoard[index], 255, 0, 0);
					}
					else
					{
						setDrawColor(draws.scoreBoard[index], 255, 255, 255);
					}
					setDrawText(draws.scoreBoard[index], format("%40d : %s (%d)"),params[2], ConvertName(params[1], "_", " ", params[0]));
					index++;
				}
				break;
			}
		}while(true);
		
		for(index; index<20; index++)
		{
			setDrawText(draws.scoreBoard[index], "");
		}
	}
	// CALLBACKS
	function onPacket(data)
	{
		
		local packet = sscanf("ds", data);
		if (packet)
		{
			switch(packet[0])
			{
			case GameBeziPackets.EQFORSOLDIER:
				GetStandardEquipment(GameBeziTeams.SOLDIERS, packet[1]);
				break;
			case GameBeziPackets.EQFORBEZI:
				GetStandardEquipment(GameBeziTeams.BEZI, packet[1]);
				break;
			case GameBeziPackets.ATRFORSOLDIER:
				GetStandarHeroAttributes(GameBeziTeams.SOLDIERS, packet[1]);
				break;
			case GameBeziPackets.ATRFORBEZI:
				GetStandarHeroAttributes(GameBeziTeams.BEZI, packet[1]);
				break;
			case GameBeziPackets.IDOFBEZI:
				system.bezimiennyID = packet[1].tointeger();
				if(system.bezimiennyID == GameSystem.myId)
				{
					BecomeTheBezimienny();
				}
				break;
			case GameBeziPackets.UPDATESCORE:
				UpdateScore(packet[1]);
				break;
			case GameBeziPackets.STARTGAME:
				GameStart();
				break;
			
			}
        }
	}
	
	function onRespawn()
	{
		LoadHero();
	}

	
}
