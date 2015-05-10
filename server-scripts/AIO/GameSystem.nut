print("LOAD: GAME SYSTEM");

enum VoteModes
{
	KICK,
	SELECTMAP,
	ENDGAME,
}

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
	VOTE_NEW = 106,		//S->C
	VOTE_PLAYER = 107,	//C->S
	VOTE_UPDATE = 108,	//S->C
	VOTE_END = 109,		//S->C
}

class GameSystem extends StandardProperties
{
	players = null;
	globalEvents = null;
	currGame = null;
	gamesQueue = null;
	gameTimer = null;
	isGameInit = null;
	voting = null;
	
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
	
	function init()
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
		local gameToCreate;
		foreach(game in gamesQueue)
		{
			if(game.ownName == name)
			{
				gameToCreate = game;
			}
		}
		
		if(gameToCreate)
		{
			print(format("Zaladowano gre %s", name));
			currGame = gameToCreate.gameName;
			listOfGame[gameToCreate.gameName].init(gameToCreate.params);
		}
		else
		{
			print(format("Nie poprawna nazwa %s", name));
		}
	}
	
	function endGame()
	{
		listOfGame[currGame].deinit();
		currGame = "NONE"
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

	function EndVote()
	{
		if(voting)
		{
			voting = voting.destructor();
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
	
	function unhookCallbacks()
	{
		eventsCommand.Remove("onCommand", this);
		eventsTimersEnd.Remove("onTimerEnd", this);
		eventsAdminCmd.Remove("onAdminCommand", this);
		eventsPacket.Remove("onPacket", this);
	}
	
	function onCommand(pid, command, params)
	{
		switch(command)
		{
		case "kick":
			if(voting == null)
			{
				local idToKick = params.tointeger();
				if((idToKick > 0 || (idToKick == 0 && params == "0")) && isConnected(idToKick))
				{
					voting = Vote(pid, VoteModes.KICK, idToKick);
				}
			}
			break;
		case "switch":
			if(voting == null)
			{
				local isGame = false;
				foreach(game in gamesQueue)
				{
					if(game.ownName == params)
					{
						isGame = true;
					}
				}
				
				if(isGame)
				{
					voting = Vote(pid, VoteModes.SELECTMAP, params);
				}
			}
			break
		}
	}	

	function onAdminCommand(pid, command)
	{
		switch(command)
		{
		case "start":
			listOfGame[currGame].init();
			break;
		case "end":
			listOfGame[currGame].DeInit();
			break;
		}
	}
	
	function onTimerEnd(object)
	{
		if(object == gameTimer)
		{
			if(isGameInit)
			{
/*
				listOfGame[currGame].init();
				gameTimer.SetTime(waitForStartGame);
				gameTimer.Start();
				isGameInit = true;
*/
			}
			else
			{
//				listOfGame[currGame].GameStart();
			}
		}
	}	

	function onPacket(pid, packetID, data)
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
		ownName = convertName(_ownName, "_", " ");
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
				return false;
			}
		}
		return true;
	}
}

class Vote extends StandardProperties
{
	initiator = null
	votes = null;
	playersVoting = null;
	mode = null;
	params = null;
	
	constructor (_id, _mode, _params)
	{
		base.constructor();
		initiator = _id;
		mode = _mode;
		params = _params;
		votes ={
			positive= [],
			negative= [],
			};
		playersVoting = gameSystem.players.len();
		
		hookCallbacks();
		
		local message = format("%d %s", GameSystemPacket.VOTE_NEW, convertText());
		gameSystem.SendPacketToAll(message);
	}
	
	function destructor()
	{
		base.destroyProperties();
		unhookCallbacks();
		return null;
	}
	
	function convertText()
	{
		switch(mode)
		{
		case VoteModes.KICK:
			return format("%s(%d) wants to kick %s(%d) from the game ", getPlayerName(initiator), initiator, getPlayerName(params), params);
		case VoteModes.SELECTMAP:
			return format("%s(%d) wants to change mode on %s", getPlayerName(initiator), initiator, params);
		}
	}
	
	function getVote(_id, _value)
	{
		if(_value){	votes.positive.push(_id);}
		else {		votes.negative.push(_id);}

		local message = format("%d %d %d", GameSystemPacket.VOTE_UPDATE, votes.positive.len(), votes.negative.len() );
		gameSystem.SendPacketToAll(message);
		
		if(votes.positive.len() + votes.negative.len() >= gameSystem.players.len()) 
		{
			endVote();
		}
	}

	function endVote(result = null)
	{
		if(result == null)
		{
			//if(votes.positive.len() > votes.negative.len())
			if(votes.positive.len() == gameSystem.players.len())
			{
				doCommand();
			}
		}
		else if(result)
		{
			doCommand();
		}
		
		local message = format("%d X", GameSystemPacket.VOTE_END);
		gameSystem.SendPacketToAll(message);
		gameSystem.EndVote();
	}
	
	function doCommand()
	{
		switch(mode)
		{
		case VoteModes.KICK:
			sendMessageToAll(0x66, 0x33, 0x66, format("GameSystem: Player %s(%d) was kicked.", getPlayerName(params), params));
			kick(params)
		case VoteModes.SELECTMAP:
			sendMessageToAll(0x66, 0x33, 0x66, format("The mode has been changed to: %s", params));
			gameSystem.CreateGame(params);
		}
	}
//	C A L L B A C K S
	function hookCallbacks()
	{
		eventsPacket.Add("onPacket", this);
	}
	
	function unhookCallbacks()
	{
		eventsPacket.Remove("onPacket", this);
	}
	
	function onPacket(pid, packetID, data)
	{
		switch(packetID)
		{
		case GameSystemPacket.VOTE_PLAYER:
			if(data.tointeger() == 1)
			{
				getVote(pid, true);
			}
			else
			{
				getVote(pid, false);
			}
			break;
		}
	}
}