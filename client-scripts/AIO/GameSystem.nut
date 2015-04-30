

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
	myId = null;
	maxSlots = null;
	globalEvents = null;
	currGame = null;
	
	constructor()
	{
		globalEvents = [eventsStart, eventsEnd, eventsRender, eventsPacket,
		eventsHit, eventsDie, eventsRespawn, eventsStandUp,
		eventsUnconscious, eventsCommand, eventsClick, eventsKey];
		currGame = "NONE"
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
	
	function ConvertMyData(params)
	{
		local data = sscanf("dd", params);
		if(data)
		{
			myId = data[0];
			maxSlots = data[1];
		}
	}
//	C A L L B A C K S
	function hookCallbacks()
	{
		eventsPacket.Add("onPacket", this);
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
}

enum VOTEMODES
{
	KICK,
	SELECTMAP,
	ENDGAME,
}

class Vote
{
	myVote = null;
	drawQuestion = null;
	drawResults = null;
	
	constructor(_text)
	{
		textQuestion = CreateDraw(_text)
		drawResults = CreateDraw(format("F3:Yes F4:No %d/%d", 0, 0));
	}
	
	function hookCallbacks()
	{
		eventsKey.Add("onKey", this);
	}
	
	function updateResults(votesYes, votesNo)
	{
		drawResults = TextDraw(format("F3:Yes F4:No %d/%d", votesYes, votesNo));
	}
	
	function onKey(key)
	{
		if(myVote == null)
		{
			if (key == KEY_F3)
			{
				myVote = true;
				sendPacket(format("%d %d", SENDVOTE, myVote));
			}
			else if (key == KEY_F4)
			{
				myVote = false;
				sendPacket(format("%d %d", SENDVOTE, myVote));
			}
		}
	}
}