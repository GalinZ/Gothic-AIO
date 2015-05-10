class StandardProperties
{
	timers = null;
	draws = null;
	textures = null;
	vobs = null;
	
	constructor()
	{
		timers ={};
		draws ={};
		textures ={};
		vobs ={};
	}
	
	function destroyProperties()
	{
		destroyTimers(timers)
		destroyDraws(draws)
		destroyTextures(textures)
		destroyVobs(vobs)

		
		timers = null;
		draws = null;
		textures = null;
		vobs = null;
	}
	
	function destroyTimers(table)
	{
		foreach(timerID in table)
		{
			if(typeof(timerID) == "table" || typeof(timerID) == "array")
			{
				destroyTimers(timerID);
			}			
			else
			{
				killTimer(timerID);
				timerID = null;
			}
		}
	}
	
	function destroyDraws(table)
	{
		foreach(drawID in table)
		{	
			if(typeof(drawID) == "table" || typeof(drawID) == "array")
			{
				destroyDraws(drawID);
			}			
			else
			{
				destroyDraw(drawID);
			}
		}
	}
	
	function destroyTextures(table)
	{		
		foreach(textureID in table)
		{	
			if(typeof(textureID) == "table" || typeof(textureID) == "array")
			{
				destroyTextures(textureID);
			}			
			else
			{
				destroyTexture(textureID);
			}
		}
	}
	
	function destroyVobs(table)
	{
		foreach(vobID in table)
		{	
			if(typeof(vobID) == "table" || typeof(vobID) == "array")
			{
				destroyVobs(vobID);
			}			
			else
			{
				destroyVob(vobID);
			}
		}
	}
}