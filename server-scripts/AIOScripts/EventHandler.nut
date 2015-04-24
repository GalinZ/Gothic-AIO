//print("LOAD: EVENT HANDLER");

class EventClass
{
	caller = null;
	func = null;
	constructor(_func , _caller= null)
	{
		func = _func
		caller = _caller;
	}
}

class EventHandler
{
	listOfFunc = null;
	constructor()
	{
		listOfFunc = [];
	}
	
	function Add(_func , _caller = null)
	{
		foreach(item in listOfFunc)
		{
			if(_func == item.func && _caller == item.caller)
			{
				return 0;
			}
		}
		
		listOfFunc.push(EventClass(_func, _caller));
	}
	
	function Remove(_func, _caller = null)
	{
		for(local i = 0; i<listOfFunc.len(); i++)
		{
			if(_func == listOfFunc[i].func && _caller == listOfFunc[i].caller )
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
		foreach(item in listOfFunc)
		{	
			if(item.caller == null)
			{
			if(p1 == null){	item.func();}
				else if(p2 == null){ item.func(p1);}
				else if(p3 == null){ item.func(p1,p2);}
				else if(p4 == null){ item.func(p1,p2,p3);}
				else if(p5 == null){ item.func(p1,p2,p3,p4);}
				else if(p6 == null){ item.func(p1,p2,p3,p4,p5);}
				else if(p7 == null){ item.func(p1,p2,p3,p4,p5,p6);}
				else if(p8 == null){ item.func(p1,p2,p3,p4,p5,p6,p7);}
				else if(p9 == null){ item.func(p1,p2,p3,p4,p5,p6,p7,p8);}
				else if(p10 == null){item.func(p1,p2,p3,p4,p5,p6,p7,p8,p9);}
				else { item.func(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)}
			}
			else
			{
				if(p1 == null){	item.caller[item.func]();}
				else if(p2 == null){ item.caller[item.func](p1);}
				else if(p3 == null){ item.caller[item.func](p1,p2);}
				else if(p4 == null){ item.caller[item.func](p1,p2,p3);}
				else if(p5 == null){ item.caller[item.func](p1,p2,p3,p4);}
				else if(p6 == null){ item.caller[item.func](p1,p2,p3,p4,p5);}
				else if(p7 == null){ item.caller[item.func](p1,p2,p3,p4,p5,p6);}
				else if(p8 == null){ item.caller[item.func](p1,p2,p3,p4,p5,p6,p7);}
				else if(p9 == null){ item.caller[item.func](p1,p2,p3,p4,p5,p6,p7,p8);}
				else if(p10 == null){item.caller[item.func](p1,p2,p3,p4,p5,p6,p7,p8,p9);}
				else { item.caller[item.func](p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)}
			}
		}
	}
	
	function Clear()
	{
		listOfFunc.clear();
	}
}

