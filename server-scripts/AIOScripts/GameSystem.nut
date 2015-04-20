class GameSystem
{
	players = null;
	
	constructor()
	{
		players = [];
	}
	
	function AddPlayer(pid)
	{
		players.push(pid);
	}
	
	function RemovePlayer(pid)
	{
		for(local i = 0; i < players.len(); i++)
		{
			if(players[i] == pid)
			{
				players.remove(i);
				return;
			}
		}
	}
}

enum GameState
{
	OFF,
	WAIT,
	STARTED,
	ENDED,
}
