dofile("Multiplayer\\Script\\AIOScripts\\HeroAttributes.nut");
dofile("Multiplayer\\Script\\AIOScripts\\HeroEquipment.nut");

enum GameBeziTeams
{
	GBT_SOLDIERS,
	GBT_BEZI
}

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
	GBF_BEZI_KILL_SOLDIER,
	GBF_SOLDIER_KILL_BEZI,
	GBF_SOLDER_HIT_BEZI
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
		system ={};
		events ={};
	}

	function OnGameStart(tableOfParams)
	{
		system ={
			state = GameState.OFF,
			areYouBezi = false,
			gameTime = -1,
			
			soldierEq = HeroEquipment(),						
			beziEq = HeroEquipment(),

		}
		system.state = GameState.WAIT;
		system.gameTime = delayTime;
	} 
	
	function onPacket(data)
	{
		local packet = sscanf("ds", data);
		if (packet)
		{
			if (packet[0] == GameBeziPackets.GBP_EQFORSOLDIER)
			{
				GetStandardEquipment(GameBeziTeams.GBT_SOLDIERS, data);
			}
			else if(packet[0] == GameBeziPackets.GBP_EQFORBEZI)
			{
				GetStandardEquipment(GameBeziTeams.GBT_BEZI, data);
			}
		
        }
	}
	
	function GetStandardEquipment(forWho, params)
	{
		do
		{
			local item = sscanf("sdds", params);
			if(item)
			{
				if(forWho == GameBeziTeams.GBT_SOLDIERS)
				{
					soldierEq.Add(item[0], item[1], item[2]);
				}
				else if(forWho == GameBeziTeams.GBT_BEZI)
				{
					beziEq.Add(item[0], item[1], item[2]);
				}
				params = item[3];
			}
			else
			{
				local item = sscanf("sdd", params);
				if(item)
				{
					if(forWho == GameBeziTeams.GBT_SOLDIERS)
					{
						system.soldierEq.Add(item[0], item[1], item[2]);
					}
					else if(forWho == GameBeziTeams.GBT_BEZI)
					{
						system.beziEq.Add(item[0], item[1], item[2]);
					}
				}
				break;
			}
		}while(true)
	}
	
	function GetStandarHeroAttributes(forWho, params)
	{
		//Hp, mp, str, dex,
		//1h, 2h, bow, cbow, mlvl,
		//protS, protO, protA, prot M
		local atr = sscanf("ddddddddddddd", params);
		if(atr)
		{
			if(forWho == GameBeziTeams.GBT_SOLDIERS)
			{
				soldierAtr = HeroAttributes(atr[0], atr[1], atr[2], atr[3],
								atr[4], atr[5], atr[6], atr[7], atr[8], 
								atr[9], atr[10], atr[11], atr[12]);
			}
			else if(forWho == GameBeziTeams.GBT_BEZI)
			{
				beziAtr = HeroAttributes(atr[0], atr[1], atr[2], atr[3],
							atr[4], atr[5], atr[6], atr[7], atr[8], 
							atr[9], atr[10], atr[11], atr[12]);
			}
		}
	}

	function onRespawn()
	{
		LoadHero();
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
	
	function GameStart()
	{
		eventsPacket + onPacket;
		eventsRespawn + onRespawn;
	}
	
	function GameEnd()
	{
	
	}
	
}


