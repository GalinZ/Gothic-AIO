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
	eventsClick.Call(0)
}
function onKey (key)
{
	eventsKey.Call(0)
}

class GameSystem
{
	
}

function test1(params){	addMessage(255, 255, 255, "test 1");}
function test2(params){	addMessage(255, 255, 255, "test 2");}
function test3(params){	addMessage(255, 255, 255, "test 3");}

function onInit ()
{
	eventsInit.Add(test1);
	eventsInit.Add(test2);
	eventsInit.Add(test3);
	eventsInit.Remove(test2);
	eventsInit.Add(test1);
//	eventsInit.Call("XX");s
};
