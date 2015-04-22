print("LOAD: GAME SYSTEM");
dofile("server-scripts\\AIOGames\\ListOfGames.nut");

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
	players = null;
	globalEvents = null;
	currGame = null;
	
	constructor()
	{
		players = [];
		globalEvents = [eventsStart, eventsEnd, eventsTick,
		eventsPacket, eventsJoin, eventsDisconect, eventsHit, 
		eventsDie, eventsRespawn, eventsStandUp, eventsUnconscious,
		eventsTake, eventsDrop, eventsCommand, eventsAdminCmd,
		eventsMessage];
		currGame = "NONE"
	}
	
	function AddPlayer(pid)
	{
		players.push(pid);
	}
	
	function RemovePlayer(pid)
	{
		for(local i = 0; i < players.len(); i++)
		{
			if(players[i] == pid)
			{
				players.remove(i);
				return;
			}
		}
	}

	function ClearGlobalEvents()
	{
		foreach(event in globalEvents)
		{
			event.Clear();
		}
	}
	
	function onCommand(pid, command, params)
	{
		switch(command)
		{
		case "start":
			listOfGame[currGame].GameInitPlayers();
			break;
		case "end":
			listOfGame[currGame].OnEnd();
			break;
		default: break;
		}
	}

	function LoadGame(name)
	{
		if(name in listOfGame)
		{
			print(format("Zaladowano gre %s", name));
			currGame = name;
			listOfGame[name].OnInit();
		}
		else
		{
			print(format("Nie poprawna nazwa %s", name));
		}
	}
}

