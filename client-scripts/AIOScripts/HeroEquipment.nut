class HeroEquipment
{
	items = null;
	constructor()
	{
		items = [];
	}	
	
	function Add(name, ammount = 1, isEquipped = 0)
	{
		local newItem = Item(name, ammount, isEquipped);
		items.push(newItem);
	}
	
	function Clear()
	{
		items.clear();
	}
}

class Item
{
	name = null;
	ammount = null;
	isEquipped = null;
	
	constructor(_name, _ammount = 1, _isEquipped = 0)
	{
		name = _name;
		ammount = _ammount
		isEquipped = _isEquipped
	}
}

