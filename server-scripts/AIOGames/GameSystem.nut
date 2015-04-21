print("LOAD: GAME SYSTEM");

dofile("server-scripts\\AIOGames\\ListOfGames.nut");

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
			break;
		case "end":
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

enum GameState
{
	GS_OFF,
	GS_INIT,
	GS_WAIT,
	GS_STARTED,
	GS_ENDED,
}
