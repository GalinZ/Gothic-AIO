print("LOAD: TIMER");

enum TimerModes
{
	TOZERO,
	LENGHT	
}

class Timer extends StandardProperties
{
	mode = null;
	//draw = null; Client only
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
			
			//UpdateDraw(); Client only
		}
	}
	
	function End()
	{
		onTimerEnd(this);
	}	

/* C L I E N T ___ O N L Y
	function ConnectDraw(x, y, font, r, g, b, visible = true)
	{
		local ms = time % 1000 / 100;
		local s  = time / 1000 % 60;
		local m  = time / 1000 / 60;
		local text = format("%02d:%02d:%d", m, s, ms);
		draw = createDraw(text, font, x, y, r, g, b);
		setDrawVisible(draw, visible);
	}
	
	function UpdateDraw()
	{
		if(draw != null)
		{
			local ms = time % 1000 / 100;
			local s  = time / 1000 % 60;
			local m  = time / 1000 / 60;
			local text = format("%02d:%02d:%d", m, s, ms);
			setDrawText(draw, text);
		}
	}
	
	function GetDraw()
	{
		return draw;
	}
*/
}

