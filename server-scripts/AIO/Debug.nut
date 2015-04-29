print("");
print("##################");
print("#  DEBUG   MODE  #");
print("##################");
print("");

function onPacketDebug(pid, data)
{
}
function onTickDebug()
{
}

//PLAYER
function onJoinDebug(id)
{
}
function onDisconnectDebug(id, reason)
{
}
function onHitDebug(pid, tid)
{
}
function onDieDebug(pid, kid)
{
}
function onRespawnDebug(pid)
{
}

function onUnconsciousDebug(pid)
{
}
function onStandUpDebug(pid)
{
}
function onTakeDebug(jakies_zmienne)
{
}
function onDropDebug(jakies_zmienne)
{
}

//CHAT
function onCommandDebug(pid, command, params)
{
}
function onAdminCommandDebug(pid, command)
{
}
function onMessageDebug(pid, message)
{
}
//Timers
function onUpdateDebug() // 100ms
{
}
function onTimerEndDebug(object)
{
}

eventsPacket.Add(onPacketDebug);
eventsTick.Add(onTickDebug);
eventsJoin.Add(onJoinDebug);
eventsDisconect.Add(onDisconnectDebug);
eventsHit.Add(onHitDebug);
eventsDie.Add(onDieDebug);
eventsRespawn.Add(onRespawnDebug);
eventsUnconscious.Add(onUnconsciousDebug);
eventsStandUp.Add(onStandUpDebug);
eventsTake.Add(onTakeDebug);
eventsDrop.Add(onDropDebug);
eventsCommand.Add(onCommandDebug);
eventsAdminCmd.Add(onAdminCommandDebug);
eventsMessage.Add(onMessageDebug);
eventsUpdate.Add(onUpdateDebug);
eventsTimersEnd.Add(onTimerEndDebug);