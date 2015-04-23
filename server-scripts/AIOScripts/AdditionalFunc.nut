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
