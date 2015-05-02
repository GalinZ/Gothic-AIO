dofile("Multiplayer\\Script\\AIO\\Scripts\\AdditionalFunc.nut");
dofile("Multiplayer\\Script\\AIO\\Scripts\\StandardProperties.nut");
dofile("Multiplayer\\Script\\AIO\\Scripts\\EventHandler.nut");
dofile("Multiplayer\\Script\\AIO\\Scripts\\Timer.nut");
dofile("Multiplayer\\Script\\AIO\\GameSystem.nut");
dofile("Multiplayer\\Script\\AIO\\ListOfGames.nut");

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

gameSystem <- GameSystem();
allTimers <-[];

function onRender()
{
	eventsRender.Call();
}
function onPacket(data)
{
	local packet = sscanf("ds", data);
	if (packet)
	{
		eventsPacket.Call(packet[0], packet[1]);
	}
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
	eventsUpdate.Call();
}
function onTimerEnd(object)
{
	eventsTimersEnd.Call(object);
}

function onInit()
{
	gameSystem.Init();
	setTimer(onUpdate, 100, true);
}


if(DEBUG)
{
	dofile("Multiplayer\\Script\\AIO\\Debug.nut");
}