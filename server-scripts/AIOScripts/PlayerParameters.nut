print("LOAD: PLAYER PARAMETERS");

class PlayerParameters
{	
	id = null;
	name = null;
	points = null;
	team = null;
	
	constructor(_id)
	{
		id = _id;
		name = getPlayerName(_id);
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
