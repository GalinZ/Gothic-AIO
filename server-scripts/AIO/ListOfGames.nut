print("LOAD: LIST OF GAMES");

//Dodaæ tu wszystkie pliki gier z folderu 'Games' Serwer oraz Includy z folderu 'Games\Includes'

dofile("server-scripts\\AIO\\Games\\Includes\\Bezimienny.nut");
dofile("server-scripts\\AIO\\Games\\Bezimienny.nut");

listOfGame  <-
{
	Bezimienny = GameBezimienny(),
}

