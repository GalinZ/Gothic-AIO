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

	function EquipHero()
	{
		clearInventory();
		foreach(item in items)
		{
			if(item.isEquipped == 1)
			{
				switch(item.type)
				{
				case IT_MELLE:
					equipMeleeWeapon(item.name);
					break;
				case IT_DISTANCE:
					equipRangedWeapon(item.name);
					break;
				case IT_ARMOR:
					equipArmor(item.name);
					break;
				default:
					giveItem(item.name, 1);
					break;
				}
				
				if(item.amount > 1)
				{
					giveItem(item.name, item.amount - 1);
				}
			}
			else
			{
				giveItem(item.name, item.amount);
			}
		}
	}
}

enum ItemType
{
	IT_OTHER,
	IT_MELLE,
	IT_DISTANCE,
	IT_ARMOR
}

class Item
{
	name = null;
	amount = null;
	isEquipped = null;
	type = null;
	
	constructor(_name, _amount = 1, _isEquipped = 0, _type = ItemType.IT_OTHER)
	{
		name = _name;
		amount = _amount
		isEquipped = _isEquipped
		type = _type;
	}
}


