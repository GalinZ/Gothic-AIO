print("LOAD: HERO ATTRIBUTES");

class HeroAttributes
{
	hp = null;
	mp = null;
	str = null;
	dex = null;
	h1 = null;
	h2 = null;
	bow = null;
	cbow = null;
	mlvl = null;
	
	constructor(_hp = 100, _mp = 0, _str = 0, _dex = 0,
				_h1 = 0, _h2 = 0, _bow = 0, _cbow = 0, _mlvl = 0)
	{
		hp = _hp;
		mp = _mp;
		str = _str;
		dex = _dex;
		h1 = _h1;
		h2 = _h2;
		bow = _bow;
		cbow = _cbow;
		mlvl = _mlvl;
	}	
	
	function _tostring()
	{
		return format("%d %d %d %d %d %d %d %d %d",
						hp, mp, str, dex, 
						h1, h2,	bow, cbow, mlvl);
	}

/* C L I E N T    O N L Y
	function UpdateHero()
	{
		setMaxHealth(hp);
		setHealth(hp);
		setMaxMana(mp);
		setMana(mp);
		setDexterity(dex);
		setStrength(str);
		setWeaponSkill(1, h1);
		setWeaponSkill(2, h2);
		setWeaponSkill(3, bow);
		setWeaponSkill(4, cbow);
	}
*/

	function getFromFile(path)
	{
		local newParams = readParameterFile("server-scripts\\AIO\\Parameters\\HeroAttributes\\" + path);
		foreach(key, var in newParams)
		{
			switch(key)
			{
			case "hp":	hp = var; break;
			case "mp":	mp = var; break;
			case "str":	str = var; break;
			case "dex":	dex = var; break;
			case "h1":	h1 = var; break;
			case "h2":	h2 = var; break;
			case "bow":	bow = var; break;
			case "cbow":cbow = var; break;
			case "mlvl":mlvl = var; break;
			}
		}
	}
}

