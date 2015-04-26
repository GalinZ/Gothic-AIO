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
	protS = null;
	protO = null;
	protA = null;
	protM = null;
	
	constructor(_hp = 100, _mp = 0, _str = 0, _dex = 0,
				_h1 = 0, _h2 = 0, _bow = 0, _cbow = 0, _mlvl = 0, 
				_protS = 0, _protO = 0, _protA = 0, _protM = 0)
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
		protS = _protS;
		protO = _protO;
		protA = _protA;
		protM = _protM;
	}	
	
	function _tostring()
	{
		return format("%d %d %d %d %d %d %d %d %d %d %d %d %d",
						hp, mp, str, dex, 
						h1, h2,	bow, cbow, mlvl,
						protS, protO, protA, protM);
	}

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
		//protS
		//protO
		//protA
		//protM
	}
}

