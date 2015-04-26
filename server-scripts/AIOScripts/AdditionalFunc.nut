/* Only Client
function PointToPx(value, mode)
{
	local res = getResolution();
	local result = 0;
	if(mode == "y")
	{
		result = value * (res.height / 8192.0);
	}
	else
	{
		result = value * (res.width / 8192.0);
	}
	
	return result.tointeger();	
};

function PxToPoint(value, mode)
{
	local res = getResolution();
	
	local result = 0;
	if(mode == "y")
	{
		result = value * (8192.0 / res.height);
	}
	else
	{
		result = value * (8192.0 / res.width);
	}
	
	return result.tointeger();
};

function PerPoint(percent)
{
	local result = 81.92 * percent;
	return result.tointeger();
};
*/

function ConvertName(text, fromChar, toChar)
{
	local i = 0;
	local last = 0;
	local newText = "";
	do
	{
		i = text.find(fromChar, i + 1);
		if(i)
		{
			if(newText == "")
			{
				newText += text.slice(last, i);
			}
			else
			{
				newText += toChar + text.slice(last, i);
			}
			last = i + 1;
		}
		else
		{
			if(newText == "")
			{
				newText += text.slice(last);
			}
			else
			{
				newText += toChar + text.slice(last);
			}
		}
	}while(i)

	return newText;
}

function setTimerClass(_inst, _func, _time, _repeat, _params = null)
{
	local object ={inst = _inst, func = _func , params = _params}
	return setTimer(classTimer, _time, _repeat, object);
}

function classTimer(object)
{
	if(object.params == null)
	{
		object.inst[object.func]();
	}
	else
	{
		object.inst[object.func](object.params);
	}
}

function random(value1, value2 = null)
{
	if(value2 == null)
	{
		if(value1 == 0)
		{
			return 0;
		}
		else
		{
			return(rand()%value1);
		}
	}
	else
	{
		return value1 + (rand()%(value2-value1 + 1));
	}
}

function writeToFile(path, text, mode)
{
	local myfile = file(path, mode);
	if(!myfile.eos())
	{
		write(myfile, "\n");
	}
	write(myfile, text);
	myfile.close();
}

function readFromFile(path)
{
	local myfile = file(path, "r");
	local text = "";
	do
	{
		text += readLine(myfile);
	}while(!myfile.eos())
	myfile.close();
	return text;
}

function write(handle, text)
{
    foreach (char in text)
	{
        handle.writen(char, 'b');
	}
}

function readLine(handle)
{
    local line = "";
    while (!handle.eos())
    {
        local char = handle.readn('b');
        line += char.tochar();
        
        if (char == '\n') return line;
    }
    
    return line;
}

function SavePosition(id, path)
{
    local pos = getPosition(id);
	local angle = 0;
	writeToFile(path, format("%d %d %d %d", pos.x, pos.y, pos.z, angle), "a");
}