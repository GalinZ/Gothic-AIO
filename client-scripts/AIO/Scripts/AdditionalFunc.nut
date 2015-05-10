//Ustawienie drawów i textur
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

function GetLinePos(startPos, spacePx, line)
{
	return startPos + (PxToPoint(spacePx, "y") * (line));
}

//Przesy³anie Nazwy gracza przez pakiety
function convertName(text, fromChar, toChar)
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

//System tworzenia timerów w klasach
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

//Funkcja losuj¹ca
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

//System plików
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
    while ( !handle.eos())
    {
        local char = handle.readn('b');
        line += char.tochar();
        if (char == '\n')
		{
			return line
		};
    }
    
    return line;
}

//Pomocne - Zapis pozycji do pliku
function SavePosition(path, additionalMessage = "")
{
    local pos = getPosition();
	local angle = getAngle();
	local text = format("%d %d %d %d", pos.x, pos.y, pos.z, angle, additionalMessage)
	print("Dodano pozycjê " + text)
	writeToFile(path, text, "a");
}

function sscanfMulti(params, text)
{
	text = convertName(text, "\n", " ");
	text += " protectionWord";
	params += "s";
	local table = [];
	local result;
	while ( result = sscanf(params, text))
	{
		text = result.pop();
		table.push(result);
	}
	return table.len() ? table : null;
}


function readParameterFile(path)
{
	local params ={};
	local paramFile = file(path, "r");
	do
	{
		local line = readLine(paramFile)
		if(line != "" )
		{	
			local parts;
			try
			{
				parts = sscanf("ss", line)
				if(parts[0] == "//")
				{
					continue;
				}			
			}
			catch(error)
			{
				continue;
			}
			
			local headers = parts[0];
			if(parts[0].find("_"))
			{
				headers = split(parts[0], "_");
			}
			
			local data = convertName(parts[1], "\n", "");
			if(parts[1].find(" "))
			{
				data = split(parts[1], " ");
			}
			
			if(typeof(headers) == "string" && typeof(data) == "string")
			{
				params[headers] <- convertToNumber(data);
			}
			else
			{	
				local max = 0;
				local title = "";
				if(typeof(headers) == "string")
				{
					max = data.len();
					title = headers;
				}
				else
				{
					title = headers[0];
					if(typeof(data) == "string")
					{
						max = headers.len() - 1;
					}
					else
					{
						max = headers.len() - 1 >= data.len() ? headers.len() - 1 : data.len();
					}
				}				
				params[title] <-{};
				
				local index = 0;
				for(local i=0; i<max; i++)
				{
					local newSlot;
					if(typeof(headers) == "array" && headers.len() > i + 1)
					{
						newSlot = headers[i + 1]; 
					}
					else 
					{
						newSlot = index++; 
					}
					
					local newData;
					if(typeof(data) == "array" && data.len() > i)
					{
						newData = data[i]; 
					}
					else
					{
						newData = null; 
						if(typeof(data) == "string" && i == 0)
						{
							newData = data; 
						}
					}
					params[title][newSlot] <- convertToNumber(newData); 
				}
			}
		}
		else
		{
			break;
		}
	}while(true)
	
	return params;
}

function convertToNumber(value)
{
	try
	{
		local newValue = value.tointeger();
		return newValue;
	}
	catch(error)
	{
		return value;
	}
}