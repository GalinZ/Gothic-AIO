
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
