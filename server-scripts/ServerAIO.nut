print("");
print("##################");
print("# LOADING  START #");
print("##################");
print("");

dofile("server-scripts\\AIOScripts\\EventHandler.nut");
dofile("server-scripts\\AIOScripts\\GameSystem.nut");

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

game <- GameSystem();1

function onPacket(pid, data)
{
	eventsPacket.Call(pid, data);
}
function onTick()
{
	eventsTick.Call();
}
//PLAYER
function onJoin(id)
{
	game.AddPlayer(id);
	eventsJoin.Call(id);
}
function onDisconnect(id, reason)
{
	game.RemovePlayer(id);
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

function onInit()
{
	game.LoadGame("Bezimienny");
}

print("");
print("##################");
print("#LOADING COMPLETE#");
print("##################");
print("");