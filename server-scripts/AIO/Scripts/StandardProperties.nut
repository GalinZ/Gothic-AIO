class StandardProperties
{
	timers = null;
	
	constructor()
	{
		timers ={};
	}
	
	function destroyProperties()
	{
		foreach(timerID in timers)
		{
			killTimer(timerID);
		}
	}
}