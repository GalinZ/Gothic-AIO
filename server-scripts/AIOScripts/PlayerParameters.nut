class PlayerParameters
{
	id = null;
	name = null;
	points = null;
	team = null;
	
	constructor(id)
	{
		id = id;
		name = getPlayerName(id);
		points = 0;
		team = -1;
	}
	
	function SetPoints(value, param)
	{
		if(param == "+")
		{
			points += value;
		}
		else if(param == "-")
		{
			points -= value;
		}
		else 
		{
			points = value;
		}
	}
	
	function GetPoints()
	{
		return points;
	}
	
	function SetTeam(value)
	{
		team = value;
	}
	
	function GetTeam()
	{
		return team;
	}
}