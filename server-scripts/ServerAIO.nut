dofile("server-scripts\\AIOScripts\\EventHandler.nut");
dofile("server-scripts\\AIOScripts\\GameSystem.nut");
dofile("server-scripts\\AIOGames\\Bezimienny.nut");

local game = ::GameSystem();

local eventsInit = ::EventHandler();
local eventsTick = ::EventHandler();
local eventsPacket = ::EventHandler();

local eventsJoin = ::EventHandler();
local eventsDisconect = ::EventHandler();
local eventsHit = ::EventHandler();
local eventsDie = ::EventHandler();
local eventsRespawn = ::EventHandler();
local eventsUnconscious = ::EventHandler();
local eventsStandUp = ::EventHandler();
local eventsTake = ::EventHandler();
local eventsDrop = ::EventHandler();

local eventsCommand = ::EventHandler();
local eventsAdminCmd = ::EventHandler();
local eventsMessage = ::EventHandler();

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

}

