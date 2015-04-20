dofile("server-scripts\\AIOScripts\\EventHandler.nut");

local eventsInit = ::EventHandler();
local eventsTick = ::EventHandler();
local eventsJoin = ::EventHandler();
local eventsDisconect = ::EventHandler();
local eventsHit = ::EventHandler();
local eventsDie = ::EventHandler();
local eventsRespawn = ::EventHandler();
local eventsCommand = ::EventHandler();
local eventsAdminCmd = ::EventHandler();
local eventsMessage = ::EventHandler();
local eventsPacket = ::EventHandler();


function onPacket(pid, data)
{
	local table ={pid = pid, data = data};
	eventsPacket.Call(table);
}
function onTick()
{
	eventsTick.Call();
}
//PLAYER
function onInit()
{

}
function onJoin(id)
{
	eventsJoin.Call(id);
}
function onDisconnect(pid, reason)
{
	local table ={pid = pid, reason = reason};
	eventsDisconect.Call(table);
}
function onHit(pid, tid)
{
	local table ={pid = pid, tid = tid};
	eventsHit.Call(table);
}
function onDie(pid, kid)
{
	local table ={pid = pid, kid = kid};
	eventsDie.Call(table);
}
function onRespawn(pid)
{
	eventsRespawn.Call(pid);
}
//CHAT
function onCommand(pid, command, params)
{
	local table ={pid = pid, command = command, params = params};
	eventsCommand.Call(table);
}
function onAdminCommand(pid, command)
{
	local table ={pid = pid, data = data};
	eventsAdminCmd.Call(table);
}
function onMessage(pid, message)
{
	local table ={pid = pid, message = message};
	eventsMessage.Call(table);
}