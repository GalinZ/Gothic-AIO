class Spawns
{
	allSpawns = null;
	
	constructor()
	{
		allSpawns = [];
	}
	
	function add(_x, _y, _z, _angle, _world = "WORLD.ZEN", _prior = 0, _flag = 0)
	{
		allSpawns.push(Spawn(_x, _y, _z, _angle, _world, _prior, _flag ));
	}
	
	function _tostring()
	{
		local text = ""
		foreach(spawn in allSpawns)
		{
			text += spawn.tostring() + " ";
		}
		return text;
	}
	
	function getFromFile(path)
	{
		local text = readFromFile("server-scripts\\AIO\\Parameters\\Spawns\\" + path);
		local newSpawns = sscanfMulti("fffd", text);
		foreach(spawn in newSpawns)
		{
			local varText = "add(";
			for(local i=0; i<spawn.len(); i++)
			{
				if(typeof(spawn[i]) == "string")
				{
					varText += format("\"%s\"", spawn[i]);
				}
				else
				{
					varText += spawn[i];
				}
				
				if(i+1<spawn.len())
				{
					varText += ", ";
				}
			}
			varText += ");";
			local addSpawnText = compilestring(varText);
			addSpawnText();
		}
	}

	function convert(text)
	{
		local newSpawns = sscanfMulti("ffffsdd", text)
		foreach(spawn in newSpawns)
		{
			add(spawn[0], spawn[1], spawn[2], spawn[3], spawn[4], spawn[5], spawn[6]);
		}
	}
	
	function respawn()
	{
		local r = random(allSpawns.len());
		setPosition(allSpawns[r].x, allSpawns[r].y, allSpawns[r].z);
		setAngle(allSpawns[r].angle)
	}
	
	function respawnPriority()
	{
		local highestPrior = 0;
		foreach(spawn in allSpawns)
		{
			if(spawn.priority > highestPrior)
			{
				highestPrior = spawn.priority;
			}
		}
		
		local r = 0;
		do
		{
			r = random(allSpawns.len());
		}while(allSpawns[r].priority < highestPrior);
		
		setPosition(allSpawns[r].x, allSpawns[r].y, allSpawns[r].z);
	}
	
	function respawnFlag(flag)
	{
		local r = 0;
		do
		{
			r = random(allSpawns.len());
		}while(allSpawns[r].flag != flag)
		
		setPosition(allSpawns[r].x, allSpawns[r].y, allSpawns[r].z);
	}
}

class Spawn
{
	x = null;
	y = null;
	z = null;
	angle = null;
	world = null;
	priority = null;
	flag = null;
	
	constructor(_x, _y, _z, _angle, _world = "WORLD.ZEN", _prior = 0, _flag = 0)
	{
		x = _x.tofloat();
		y = _y.tofloat();
		z = _z.tofloat();
		angle = _angle.tofloat();
		world = _world;
		priority = _prior;
		flag = _flag;
	}
	
	function _tostring()
	{
		return format("%f %f %f %f %s %d %d", x, y, z, angle, world, priority, flag);
	}
}