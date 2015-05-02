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
		foreach(timerID in timers)
		{
			killTimer(timerID);
		}

		foreach(drawID in draws)
		{
            destroyDraw(drawID);
		}
		
		foreach(textureID in textures)
		{
			destroyTexture(textureID);
		}
		
		foreach(vobID in vobs)
		{
			destroyVob(vobID);
		}
	}
}