print("DEBUG MODE");

function onRenderDebug()
{
}
function onPacketDebug(packetID, data)
{
}
//PLAYER
function onHitDebug()
{
}
function onDieDebug()
{
}
function onRespawnDebug()
{
}
function onStandUpDebug()
{
}
function onUnconsciousDebug()
{
}
//CZAT
function onCommandDebug(command, params)
{
}
//INTERFACE
function onClickDebug()	
{
}
function onKeyDebug(key)
{
	if(key == KEY_U)
	{
		SavePosition("Multiplayer\\Script\\Pozycje.txt");
	}
}
//Timer
function onUpdateDebug() // 100ms
{
}
function onTimerEndDebug(object)
{
}

eventsRender.Add(onRenderDebug);
eventsPacket.Add(onPacketDebug);
eventsHit.Add(onHitDebug);
eventsDie.Add(onDieDebug);
eventsRespawn.Add(onRespawnDebug);
eventsStandUp.Add(onStandUpDebug);
eventsUnconscious.Add(onUnconsciousDebug);
eventsCommand.Add(onCommandDebug);
eventsClick.Add(onClickDebug);
eventsKey.Add(onKeyDebug);
eventsTimersEnd.Add(onTimerEndDebug);
eventsUpdate.Add(onUpdateDebug);
