print("LOAD: GAME SYSTEM");
dofile("server-scripts\\AIO\\ListOfGames.nut");

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
	
	function Init()
	{
		LoadAllGames();
	}
	
	function LoadAllGames()
	{
		local text = readFromFile("server-scripts\\AIO\\GamesQueue.txt");
		local newGames = sscanfMulti("sssds",text);
		
		print("X X X")
		if(newGames)
		{
			print("X X")
			foreach(item in newGames)
			{
				print("XXX")
				Game.CheckCorrect(item[1],item[2],item[4]);
			}
		}
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

	function CreateGame(name)
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

class Game
{
	ownName 	= null;
	gameName	= null;
	params 		= null;
	minPlayers 	= null;
	addons 		= null;
	
	constructor(_ownName, _gameName, _params, _minPlayers, _addons)
	{
		ownName = _ownName;
		gameName= _gameName;
		params 	= _params;
		minPlayers 	= _minPlayers;
		addons 	= _addons;
	}
	
	function CheckCorrect(_name, _params, _addons)
	{
		//Test nazwy
		if(!(_name in listOfGame))
		{
			print("ListOfGame nie posiada gry : " + _name);
		}
		// Test czy plik parametrów jest
		local myfile;
		try
		{
			myfile = file("server-scripts\\AIO\\Games\\Parameters\\"+_params, "r");
			myfile.close();
		}
		catch(error)
		{
			print("Nie ma pliku parametrów o naziwe: " + _params);
		}
		// Test czy s¹ dodatki
		if(_addons != "NULL")
		{
			myfile = null;
			try
			{
				myfile = file("server-scripts\\AIO\\ListOfAddons\\" + _addons, "r");
				myfile.close();
			}
			catch(error)
			{
				print("Nie ma pliku z dodatkami o naziwe: " + _addons);
			}
		}
	}
}
