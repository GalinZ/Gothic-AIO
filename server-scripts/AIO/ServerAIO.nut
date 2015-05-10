print("");
print("##################");
print("# LOADING  START #");
print("##################");
print("");

local DEBUG = true;

dofile("server-scripts\\AIO\\Scripts\\AdditionalFunc.nut");
dofile("server-scripts\\AIO\\Scripts\\StandardProperties.nut");
dofile("server-scripts\\AIO\\Scripts\\EventHandler.nut");
dofile("server-scripts\\AIO\\Scripts\\Timer.nut");
dofile("server-scripts\\AIO\\GameSystem.nut");
dofile("server-scripts\\AIO\\ListOfGames.nut");

eventsStart <- EventHandler();
eventsEnd <- EventHandler();
eventsTick <- EventHandler();
eventsPacket <- EventHandler();

eventsJoin <- EventHandler();
eventsDisconect <- EventHandler();
eventsHit <- EventHandler();
eventsDie <- EventHandler();
eventsRespawn <- EventHandler();
eventsStandUp <- EventHandler();
eventsUnconscious <- EventHandler();
eventsTake <- EventHandler();
eventsDrop <- EventHandler();

eventsCommand <- EventHandler();
eventsAdminCmd <- EventHandler();
eventsMessage <- EventHandler();

eventsUpdate <- EventHandler();
eventsTimersEnd <- EventHandler();

gameSystem <- GameSystem();

function onPacket(pid, data)
{
	local packet = sscanf("ds", data);
	if (packet)
	{
		eventsPacket.Call(pid, packet[0], packet[1]);
	}
}
function onTick()
{
	eventsTick.Call();
}
//PLAYER
function onJoin(id)
{
	sendPacket(id, 1, format("105 %d %d", id, getMaxSlots()));
	gameSystem.AddPlayer(id);
	eventsJoin.Call(id);
}
function onDisconnect(id, reason)
{
	gameSystem.RemovePlayer(id);
	eventsDisconect.Call(id, reason);
}
function onHit(pid, tid)
{
	eventsHit.Call(pid, tid);
}
function onDie(pid, kid)
{
	eventsDie.Call(pid, kid);
}
function onRespawn(pid)
{
	eventsRespawn.Call(pid);
}

function onUnconscious(pid)
{

}
function onStandUp (pid)
{

}
function onTake(jakies_zmienne)
{

}
function onDrop(jakies_zmienne)
{

}

//CHAT
function onCommand(pid, command, params)
{
	eventsCommand.Call(pid, command, params);
}
function onAdminCommand(pid, command)
{
	eventsAdminCmd.Call(pid, command);
}
function onMessage(pid, message)
{
	eventsMessage.Call(pid, message);
}
//Timers
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
	gameSystem.init();
	//gameSystem.LoadGame("Bezimienny");
	if(DEBUG)
	{
		onInitDebug();
	}
}

print("");
print("##################");
print("#LOADING COMPLETE#");
print("##################");
print("");

if(DEBUG)
{
	dofile("server-scripts\\AIO\\Debug.nut");
}