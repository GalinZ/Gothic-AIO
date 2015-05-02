
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
	myId = null;
	maxSlots = null;
	globalEvents = null;
	currGame = null;
	voting = null;
	
	constructor()
	{
		globalEvents = [eventsStart, eventsEnd, eventsRender, eventsPacket,
		eventsHit, eventsDie, eventsRespawn, eventsStandUp,
		eventsUnconscious, eventsCommand, eventsClick, eventsKey];
		currGame = "NONE"
	}
	
	function Init()
	{
		hookCallbacks();
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
			listOfGame[currGame].Init();
			eventsPacket.Add("onPacket", listOfGame[currGame]);
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

	function EndVote()
	{
		if(voting)
		{
			voting = voting.destructor();
		}
	}

	function clearGame()
	{
		listOfGame[name].deinit();
		currGame = "NONE"
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
	
	function onPacket(packetID, data)
	{
		if(packetID < 100 || packetID >= 200){ return;}
		switch(packetID)
		{
		case GameSystemPacket.SWITCH_GAME:
			break;
		case GameSystemPacket.INIT_GAME:
			LoadGame(data);
			break;
		case GameSystemPacket.START_GAME:
			break;
		case GameSystemPacket.END_GAME:
			break;
		case GameSystemPacket.MY_DATA:
			ConvertMyData(data)
			break;
		case GameSystemPacket.VOTE_NEW:
			if(voting == null)
			{
				voting = Vote(data)
			}
			break;
		}
	}
}

class Vote extends StandardProperties
{
	myVote = null;
	
	constructor(_text)
	{
		base.constructor();
		draws.question <- createDraw(_text, "FONT_OLD_10_WHITE_HI.TGA", 500, 5000, 0xff, 0x66, 0x00);
		draws.results  <- createDraw(format("F3:Yes F4:No %d/%d", 0, 0), "FONT_OLD_10_WHITE_HI.TGA", 700, 5300, 0xff, 0x66, 0x00);
		setDrawVisible(draws.question, true);
		setDrawVisible(draws.results, true);
		hookCallbacks();
	}
		
	function destructor()
	{
		destroyProperties();
		unhookCallbacks();
		return null;
	}
	
	function updateResults(votesYes, votesNo)
	{
		 setDrawText(draws.results ,(format("F3:Yes F4:No %d/%d", votesYes, votesNo)));
	}
//	C A L L B A C K S
	function hookCallbacks()
	{
		eventsKey.Add("onKey", this);
		eventsPacket.Add("onPacket", this);
	}
	
	function unhookCallbacks()
	{
		eventsKey.Remove("onKey", this);
		eventsPacket.Remove("onPacket", this);
	}
		
	function onKey(key)
	{
		if(myVote == null)
		{
			if (key == KEY_F3)
			{
				myVote = 1;
				sendPacket(1, format("%d %d", GameSystemPacket.VOTE_PLAYER, myVote));
			}
			else if (key == KEY_F4)
			{
				myVote = 0;
				sendPacket(1, format("%d %d", GameSystemPacket.VOTE_PLAYER, myVote));
			}
		}
	}
	
	function onPacket(packetID, data)
	{
		switch(packetID)
		{
		case GameSystemPacket.VOTE_UPDATE:
			local results = sscanf("dd", data);
			if(results)
			{
				updateResults(results[0], results[1]);
			}
			break;
		case GameSystemPacket.VOTE_END:
			gameSystem.EndVote();
			break;
		}
	}
}