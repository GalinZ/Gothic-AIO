print("");
print("##################");
print("# LOADING  START #");
print("##################");
print("");

dofile("server-scripts\\AIOScripts\\AdditionalFunc.nut");
dofile("server-scripts\\AIOScripts\\EventHandler.nut");
dofile("server-scripts\\AIOGames\\GameSystem.nut");


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

game <- GameSystem();

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
	sendPacket(id, 1, format("105 %d %d", id, getMaxSlots()));
	//sendPacket(id, format("%d %d %d", GameSystemPacket.MY_DATA, id, getMaxSlots()));
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
	game.onCommand(pid, command, params);
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
	game.LoadGame("Bezimienny");
}

function ConvertName(text, fromChar, toChar)
{
	local i = 0;
	local last = 0;
	local newText = "";
	do
	{
		i = text.find(fromChar, i + 1);
		if(i)
		{
			if(newText == "")
			{
				newText += text.slice(last, i);
			}
			else
			{
				newText += toChar + text.slice(last, i);
			}
			last = i + 1;
		}
		else
		{
			if(newText == "")
			{
				newText += text.slice(last);
			}
			else
			{
				newText += toChar + text.slice(last);
			}
		}
	}while(i)

	return newText;
}

print("");
print("##################");
print("#LOADING COMPLETE#");
print("##################");
print("");


