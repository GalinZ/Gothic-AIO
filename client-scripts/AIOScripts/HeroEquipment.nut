

enum ItemType
{
	OTHER,
	MELLE,
	DISTANCE,
	ARMOR
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
			text = format("%s%s %d %d %d ", text, item.name, item.amount,
											item.isEquipped, item.type);
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
				case ItemType.MELLE:
					equipMeleeWeapon(item.name);
					break;
				case ItemType.DISTANCE:
					equipRangedWeapon(item.name);
					break;
				case ItemType.ARMOR:
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

	function covertString(params)
	{	
		do
		{
			local item = sscanf("sddds", params);
			if(item)
			{
				Add(item[0], item[1], item[2], item[3]);
				params = item[4];
			}
			else
			{
				local item = sscanf("sddd", params);
				if(item)
				{
					system.beziEq.Add(item[0], item[1], item[2], item[3]);
				}
				break;
			}
		}while(true)
	}
}

class Item
{
	name = null;
	amount = null;
	isEquipped = null;
	type = null;
	
	constructor(_name, _amount = 1, _isEquipped = 0, _type = ItemType.OTHER)
	{
		name = _name;
		amount = _amount
		isEquipped = _isEquipped
		type = _type;
	}
}
