class EventHandler
{
	listOfFunc = null;
	constructor()
	{
		listOfFunc = [];
	}
	
	function Add(func)
	{
		foreach(item in listOfFunc)
		{
			if(func == item)
			{
				return 0;
			}
		}
		
		listOfFunc.push(func);
	}
	
	function Remove(func)
	{
		for(local i = 0; i<listOfFunc.len(); i++)
		{
			if(func == listOfFunc[i])
			{
				listOfFunc.remove(i);
				return 1;
			}
		}
		return 0;
	}
		
	function Call(params = null)
	{
		foreach(func in listOfFunc)
		{	
			if(params != null)
			{
				func(params);
			}
			else
			{
				func();
			}
		}
	}
	
	function Clear()
	{
		listOfFunc.clear();
	}
}

