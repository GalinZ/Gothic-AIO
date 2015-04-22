print("LOAD: LIST OF GAMES");

//Dodać tu wszystkie pliki gier z folderu AIOGames Serwer

dofile("server-scripts\\AIOGames\\Includes\\Bezimienny.nut");
dofile("server-scripts\\AIOGames\\Bezimienny.nut");

listOfGame  <-
{
	Bezimienny = GameBezimienny(),
}

