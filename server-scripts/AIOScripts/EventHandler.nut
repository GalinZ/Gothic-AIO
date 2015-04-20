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
		
	function Call(p1 = null, p2 = null, p3 = null, p4 = null, p5 = null,
				  p6 = null, p7 = null, p8 = null, p9 = null, p10 = null)
	{
		foreach(func in listOfFunc)
		{	
			if(p1 == null){	func();}
			else if(p2 == null){ func(p1);}
			else if(p3 == null){ func(p1,p2);}
			else if(p4 == null){ func(p1,p2,p3);}
			else if(p5 == null){ func(p1,p2,p3,p4);}
			else if(p6 == null){ func(p1,p2,p3,p4,p5);}
			else if(p7 == null){ func(p1,p2,p3,p4,p5,p6);}
			else if(p8 == null){ func(p1,p2,p3,p4,p5,p6,p7);}
			else if(p9 == null){ func(p1,p2,p3,p4,p5,p6,p7,p8);}
			else if(p10 == null){func(p1,p2,p3,p4,p5,p6,p7,p8,p9);}
			else { func(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)}
		}
	}
	
	function Clear()
	{
		listOfFunc.clear();
	}
	
	function _add(func)
	{
		Add(func);
	}
	
	function _sub(func)
	{
		Remove(func);
	}
}

