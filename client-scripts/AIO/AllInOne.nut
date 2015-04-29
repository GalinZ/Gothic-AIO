dofile("Multiplayer\\Script\\AIOScripts\\AdditionalFunc.nut");
dofile("Multiplayer\\Script\\AIOScripts\\EventHandler.nut");
dofile("Multiplayer\\Script\\AIOGames\\GameSystem.nut");

local DEBUG = true;

eventsStart <- EventHandler();
eventsEnd <- EventHandler();

eventsRender <- EventHandler();
eventsPacket <- EventHandler();
eventsHit <- EventHandler();
eventsDie <- EventHandler();
eventsRespawn <- EventHandler();
eventsStandUp <- EventHandler();
eventsUnconscious <- EventHandler();
eventsCommand <- EventHandler();
eventsClick <- EventHandler();
eventsKey <- EventHandler();

eventsTimersEnd <- EventHandler();
eventsUpdate <- EventHandler();

game <- GameSystem();
allTimers <-[];

function onRender()
{
	eventsRender.Call();
}
function onPacket(data)
{
	game.onPacket(data);
	eventsPacket.Call(data);
}
//PLAYER
function onHit()
{
	eventsHit.Call();
}
function onDie()
{
	eventsDie.Call();
}
function onRespawn()
{
	eventsRespawn.Call();
}
function onStandUp()
{
	eventsStandUp.Call();
}
function onUnconscious()
{
	eventsUnconscious.Call();
}
//CZAT
function onCommand(command, params)
{
	eventsCommand.Call(command, params);
}
//INTERFACE
function onClick()	
{
	eventsClick.Call(key, x, y, wheel)
}
function onKey(key)
{
	eventsKey.Call(key)
}

//Timer
function onUpdate() // 100ms
{
	rand();
	eventsUpdate.Call();
}
function onTimerEnd(object)
{
	eventsTimersEnd.Call(object);
}


function onInit()
{
	setTimer(onUpdate, 100, true);
};


if(DEBUG)
{
	dofile("Multiplayer\\Script\\Debug.nut");
}