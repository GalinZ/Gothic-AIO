dofile("Multiplayer\\Script\\AIOGames\\ListOfGames.nut");

class GameSystem
{
	globalEvents = null;
	constructor()
	{
		globalEvents = 
		[eventsStart, eventsEnd, eventsRender, eventsPacket,
		eventsHit, eventsDie, eventsRespawn, eventsStandUp,
		eventsUnconscious, eventsCommand, eventsClick, eventsKey];
	}
	
	function ClearEvents()
	{
		foreach(event in globalEvents)
		{
			event.Clear();
		}
	}
}

enum GameState
{
	OFF,
	INITALIZE,
	WAIT,
	STARTED,
	ENDED,
}
