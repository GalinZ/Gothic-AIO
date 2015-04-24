enum TimerModes
{
	TOZERO,
	LENGHT	
}

class Timer
{
	mode = null;
	time = null;
	lastTick = null;
	isStarted = null;
	
	constructor(_mode, _time = 0)
	{
		mode = _mode;
		time = _time;
		isStarted = false;
	}
	
	function SetTime(ms, mode = "")
	{
		if(mode = "+")
		{
			time += ms;
		}
		else if(mode = "-")
		{
			time -= ms;
		}
		else
		{
			time = ms;
		}
	}
	
	function GetTime()
	{
		return time;
	}
	
	function isEnded()
	{
		return time <= 0 ? true : false;
	}
	
	function Start()
	{
		if(isStarted == false)
		{
			eventsUpdate.Add("Update", this);
			isStarted = true;
			lastTick = getTickCount();
		}
	}
	
	function Stop()
	{
		if(isStarted == true)
		{
			eventsUpdate.Remove("Update", this);
			isStarted = false;
		}
	}
	
	function Update()
	{
		if(isStarted)
		{
			local tick = getTickCount()
			if(TimerModes.TOZERO == mode)
			{
				time -= tick - lastTick;
				if(time < 0)
				{
					time = 0;
					Stop();
					End();
				}
			}
			else if(TimerModes.LENGHT == mode)
			{
				time += tick - lastTick;
			}
			lastTick = tick;
			
		}
	}
	
	function End()
	{
		onTimerEnd(this);
	}	
}

