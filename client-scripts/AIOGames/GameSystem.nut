dofile("Multiplayer\\Script\\AIOGames\\ListOfGames.nut");

enum GameState
{
	OFF,
	INIT,
	WAIT,
	STARTED,
	ENDED,
}

enum GameSystemPacket
{
	SWITCH_GAME = 101,
	INIT_GAME = 102,
	START_GAME = 103,
	END_GAME = 104, 
	MY_DATA = 105,
}

class GameSystem
{
	myId = null;
	maxSlots = null;
	globalEvents = null;
	currGame = null;
	
	constructor()
	{
		globalEvents = 
		[eventsStart, eventsEnd, eventsRender, eventsPacket,
		eventsHit, eventsDie, eventsRespawn, eventsStandUp,
		eventsUnconscious, eventsCommand, eventsClick, eventsKey];
		currGame = "NONE"
	}
	
	function ClearGlobalEvents()
	{
		foreach(event in globalEvents)
		{
			event.Clear();
		}
	}

	function LoadGame(name)
	{
		if(name in listOfGame)
		{
			currGame = name;
			listOfGame[name].onInit();
			eventsPacket.Add("onPacket", listOfGame[name]);
		}
		else
		{
		
		}
	}
	
	function onPacket(data)
	{
		local packet = sscanf("ds", data);
		if (packet)
		{			
			if(packet[0] < 100 || packet[0] >= 200){ return;}
			switch(packet[0])
			{
			case GameSystemPacket.SWITCH_GAME:
				break;
			case GameSystemPacket.INIT_GAME:
				LoadGame(packet[1]);
				break;
			case GameSystemPacket.START_GAME:
				break;
			case GameSystemPacket.END_GAME:
				break;
			case GameSystemPacket.MY_DATA:
				ConvertMyData(packet[1])
				break;
			}
		}
	}
	
	function ConvertMyData(params)
	{
		local data = sscanf("dd", params);
		if(data)
		{
			myId = data[0];
			maxSlots = data[1];
		}
	}
}

