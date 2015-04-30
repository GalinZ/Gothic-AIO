print("LOAD: GAME SYSTEM");

enum GameState
{
	OFF,
	INIT,
	STARTED,
	ENDED,
}

enum GameSystemPacket
{
	SWITCH_GAME = 101,	//C->S
	INIT_GAME = 102,	//S->C
	START_GAME = 103,	//S->C
	END_GAME = 104, 	//S->C
	MY_DATA = 105,		//S->C
	NEW_VOTE = 106,		//S->C
	PLAYER_VOTE = 107,	//C->S
}

class GameSystem
{
	players = null;
	globalEvents = null;
	currGame = null;
	gamesQueue = null;
	gameTimer = null;
	isGameInit = null;
	static waitForInitGame = 20000;
	static waitForStartGame = 10000;
	
	constructor()
	{
		players = [];
		globalEvents = [eventsStart, eventsEnd, eventsTick,
		eventsPacket, eventsJoin, eventsDisconect, eventsHit, 
		eventsDie, eventsRespawn, eventsStandUp, eventsUnconscious,
		eventsTake, eventsDrop, eventsCommand, eventsAdminCmd,
		eventsMessage, eventsUpdate, eventsTimersEnd];
		
		hookCallbacks();
		
		currGame = "NONE"
		gamesQueue =[];
		gameTimer = Timer(TimerModes.TOZERO, waitForInitGame);
		isGameInit = false;
	}
	
	function Init()
	{
		LoadAllGames();
		hookCallbacks();
	}
		
	function LoadAllGames()
	{
		local text = readFromFile("server-scripts\\AIO\\GamesQueue.txt");
		local newGames = sscanfMulti("sssds", text);
			
		if(newGames)
		{
			foreach(item in newGames)
			{
				if(Game.CheckCorrect(item[1],item[2],item[4]))
				{
					gamesQueue.push(Game(item[0], item[1], item[2], item[3], item[4]));
				}
			}
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
	
	function AddPlayer(pid)
	{
		players.push(pid);
		if(players.len() == 1)
		{
			gameTimer.Start();
		}
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
		
		if(players.len() == 1)
		{
			gameTimer.Stop();
			gameTimer.SetTime(waitForInitGame);
		}
	}

	function ClearGlobalEvents()
	{
		foreach(event in globalEvents)
		{
			event.Clear();
		}
	}
	
	function SendPacketToAll(packet, prior = 1)
	{
		foreach(player in players)
		{
			sendPacket(player, prior, packet);
		}
	}

//	C A L L B A C K S
	function hookCallbacks()
	{
		eventsCommand.Add("onCommand", this);
		eventsTimersEnd.Add("onTimerEnd", this);
		eventsAdminCmd.Add("onAdminCommand", this);
		eventsPacket.Add("onPacket", this);
	}	

	function onCommand(pid, command, params)
	{
		switch(command)
		{
		case "start":
			listOfGame[currGame].Init();
			break;
		case "end":
			listOfGame[currGame].DeInit();
			break;
		default: break;
		}
	}	

	function onAdminCommand(pid, command)
	{
	
	}
	
	function onTimerEnd(object)
	{
		if(object == gameTimer)
		{
			if(isGameInit)
			{
				listOfGame[currGame].Init();
				gameTimer.SetTime(waitForStartGame);
				gameTimer.Start();
				isGameInit = true;
			}
			else
			{
				listOfGame[currGame].GameStart();
			}
		}
	}	

	function onPacket(pid, data)
	{

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
			return false;
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
			return false;
		}
		// Test czy są dodatki
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
				return false;
			}
		}
		return true;
	}
}

enum VOTEMODES
{
	KICK,
	SELECTMAP,
	ENDGAME,
}

class Vote
{
	votes = null;
	playersVoting = null;
	mode = null;
	params = null;
	
	constructor (_id, _mode, _params)
	{
		mode = _mode;
		params = _params;
		votes = [];
		playersVoting = gameSystem.players.len();
		
		local message = format("%d %s", GameSystemPacket.NEW_VOTE, convertText(_id, _mode, _params));
		gameSystem.SendPacketToAll(message);
	}
	
	function convertText(_id, _mode, _params)
	{
		switch(mode)
		{
		case VOTEMODES.KICK:
			return format("%s(%d) wants kick from game %s(%d)", getpalyername(id), id, getpalyername(params), params);
		case VOTEMODES.SELECTMAP:
			return format("%s(%d) wants to change mode on %s", getpalyername(id), id, params);
		}
	}
	
	function getVote(_id, _value)
	{
		local newVote ={id = id, value = value}
		votes.push(newVote);
		if(votes.len() >= gameSystem.players.len()) 
		{
			vote
		}
	}

	function endVote()
	{
		local positiveVotes = 0;
		foreach(item in votes)
		{
			if(item.value)
			{
				positiveVotes++;
			}
			else
			{
				positiveVotes--;
			}
		}
		
		if(positiveVotes >= 0)
		{
			doCommand();
		}
	}
	
	function doCommand()
	{
		switch(mode)
		{
		case VOTEMODES.KICK:
			sendMessageToAll(0x66, 0x33, 0x66, format("GameSystem: Player %s(%d) was kicked.", getpalyername(params), params));
			kick(params)
		case VOTEMODES.SELECTMAP:
			sendMessageToAll(0x66, 0x33, 0x66, format("The mode has been changed to: %s", params));
			gameSystem.CreateGame(params);
		}
	}
}
