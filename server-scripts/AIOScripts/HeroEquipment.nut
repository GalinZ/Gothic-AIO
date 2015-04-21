print("LOAD: HERO EQUIPMENT");

enum ItemType
{
	IT_OTHER,
	IT_MELLE,
	IT_DISTANCE,
	IT_ARMOR
}

class HeroEquipment
{
	items = null;
	constructor()
	{
		items = [];
	}	
	
	function Add(name, amount = 1, isEquipped = 0, type = 0)
	{
		local newItem = Item(name, amount, isEquipped, type);
		items.push(newItem);
	}
	
	function Clear()
	{
		items.clear();
	}
	
	function _tostring()
	{
		local text = "";
		foreach(item in items)
		{
			text = format("%s %s %d %d", text, item.name,
							item.amount, item.isEquipped);
		}
		return text;
	}
}

class Item
{
	name = null;
	amount = null;
	isEquipped = null;
	type = null;
	
	constructor(_name, _amount = 1, _isEquipped = 0, _type = 0)
	{
		name = _name;
		amount = _amount
		isEquipped = _isEquipped
		type = _type;
	}
}
