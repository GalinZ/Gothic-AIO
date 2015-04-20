dofile("Multiplayer\\Script\\AIOScripts\\EventHandler.nut");

local eventsInit = ::EventHandler();
local eventsRender = ::EventHandler();
local eventsPacket = ::EventHandler();
local eventsHit = ::EventHandler();
local eventsDie = ::EventHandler();
local eventsRespawn = ::EventHandler();
local eventsStandUp = ::EventHandler();
local eventsUnconscious = ::EventHandler();
local eventsCommand = ::EventHandler();
local eventsClick = ::EventHandler();
local eventsKey = ::EventHandler();


function onRender ()
{
	eventsRender.Call();
}
function onPacket (data)
{
	eventsPacket.Call(data);
}
//PLAYER
function onHit ()
{
	eventsHit.Call();
}
function onDie ()
{
	eventsDie.Call();
}
function onRespawn ()
{
	eventsRespawn.Call();
}
function onStandUp ()
{
	eventsStandUp.Call();
}
function onUnconscious ()
{
	eventsUnconscious.Call();
}
//CZAT
function onCommand (command, params)
{
	local parameters ={ command = command, params = params};
	eventsCommand.Call(parameters); 
}
//INTERFACE
function onClick (key, x, y, wheel)	
{
	local parameters ={ key = key, x = x, y = y, wheel = wheel};
	eventsClick.Call(parameters)
}
function onKey (key)
{
	eventsKey.Call(key)
}

class GameSystem
{
	
}

function onInit ()
{

};
