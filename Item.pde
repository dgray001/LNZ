class EditItemForm extends EditMapObjectForm {
  protected Item item;

  EditItemForm(Item item) {
    super(item);
    this.item = item;
    this.addField(new FloatFormField("Heals: ", "curr health", -Float.MAX_VALUE + 1, Float.MAX_VALUE - 1));
    this.addField(new IntegerFormField("Hunger: ", "hunger", -100, 100));
    this.addField(new IntegerFormField("Thirst: ", "thirst", -100, 100));
    this.addField(new FloatFormField("Money: ", "money", 0, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Health: ", "health", -Float.MAX_VALUE + 1, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Attack: ", "attack", -Float.MAX_VALUE + 1, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Magic: ", "magic", -Float.MAX_VALUE + 1, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Defense: ", "defense", -Float.MAX_VALUE + 1, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Resistance: ", "resistance", -Float.MAX_VALUE + 1, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Piercing: ", "piercing", -1, 1));
    this.addField(new FloatFormField("Penetration: ", "penetration", -1, 1));
    this.addField(new FloatFormField("Attack Range: ", "attack range", -Float.MAX_VALUE + 1, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Attack Cooldown: ", "attack cooldown", -Float.MAX_VALUE + 1, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Attack Time: ", "attack time", -Float.MAX_VALUE + 1, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Sight: ", "sight", -Float.MAX_VALUE + 1, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Speed: ", "speed", -Float.MAX_VALUE + 1, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Tenacity: ", "tenacity", -1, 1));
    this.addField(new IntegerFormField("Agility: ", "agility", -10, 10));
    this.addField(new IntegerFormField("Ammo: ", "ammo", 0, Integer.MAX_VALUE - 1));
    this.addField(new IntegerFormField("Stack: ", "stack", 0, Integer.MAX_VALUE - 1));
    this.addField(new IntegerFormField("Durability: ", "durability", 0, Integer.MAX_VALUE - 1));
    this.addField(new SubmitFormField("Finished", false));
    this.updateForm();
  }

  void updateObject() {
    this.item.curr_health = toFloat(this.fields.get(1).getValue());
    this.item.hunger = toInt(this.fields.get(2).getValue());
    this.item.thirst = toInt(this.fields.get(3).getValue());
    this.item.money = toFloat(this.fields.get(4).getValue());
    this.item.health = toFloat(this.fields.get(5).getValue());
    this.item.attack = toFloat(this.fields.get(6).getValue());
    this.item.magic = toFloat(this.fields.get(7).getValue());
    this.item.defense = toFloat(this.fields.get(8).getValue());
    this.item.resistance = toFloat(this.fields.get(9).getValue());
    this.item.piercing = toFloat(this.fields.get(10).getValue());
    this.item.penetration = toFloat(this.fields.get(11).getValue());
    this.item.attackRange = toFloat(this.fields.get(12).getValue());
    this.item.attackCooldown = toFloat(this.fields.get(13).getValue());
    this.item.attackTime = toFloat(this.fields.get(14).getValue());
    this.item.sight = toFloat(this.fields.get(15).getValue());
    this.item.speed = toFloat(this.fields.get(16).getValue());
    this.item.tenacity = toFloat(this.fields.get(17).getValue());
    this.item.agility = toInt(this.fields.get(18).getValue());
    this.item.ammo = toInt(this.fields.get(19).getValue());
    this.item.stack = toInt(this.fields.get(20).getValue());
    this.item.durability = toInt(this.fields.get(21).getValue());
  }

  void updateForm() {
    this.fields.get(1).setValueIfNotFocused(Float.toString(this.item.curr_health));
    this.fields.get(2).setValueIfNotFocused(Integer.toString(this.item.hunger));
    this.fields.get(3).setValueIfNotFocused(Integer.toString(this.item.thirst));
    this.fields.get(4).setValueIfNotFocused(Float.toString(this.item.money));
    this.fields.get(5).setValueIfNotFocused(Float.toString(this.item.health));
    this.fields.get(6).setValueIfNotFocused(Float.toString(this.item.attack));
    this.fields.get(7).setValueIfNotFocused(Float.toString(this.item.magic));
    this.fields.get(8).setValueIfNotFocused(Float.toString(this.item.defense));
    this.fields.get(9).setValueIfNotFocused(Float.toString(this.item.resistance));
    this.fields.get(10).setValueIfNotFocused(Float.toString(this.item.piercing));
    this.fields.get(11).setValueIfNotFocused(Float.toString(this.item.penetration));
    this.fields.get(12).setValueIfNotFocused(Float.toString(this.item.attackRange));
    this.fields.get(13).setValueIfNotFocused(Float.toString(this.item.attackCooldown));
    this.fields.get(14).setValueIfNotFocused(Float.toString(this.item.attackTime));
    this.fields.get(15).setValueIfNotFocused(Float.toString(this.item.sight));
    this.fields.get(16).setValueIfNotFocused(Float.toString(this.item.speed));
    this.fields.get(17).setValueIfNotFocused(Float.toString(this.item.tenacity));
    this.fields.get(18).setValueIfNotFocused(Integer.toString(this.item.agility));
    this.fields.get(19).setValueIfNotFocused(Integer.toString(this.item.ammo));
    this.fields.get(20).setValueIfNotFocused(Integer.toString(this.item.stack));
    this.fields.get(21).setValueIfNotFocused(Integer.toString(this.item.durability));
  }
}



class Item extends MapObject {
  protected boolean disappearing = false;
  protected int disappear_timer = 0;
  protected int map_key = -10;

  protected int stack = 1;

  protected float size = Constants.item_defaultSize; // radius
  protected int tier = 1;

  protected float curr_health = 0;
  protected int hunger = 0;
  protected int thirst = 0;
  protected float money = 0;

  protected float health = 0;
  protected float attack = 0;
  protected float magic = 0;
  protected float defense = 0;
  protected float resistance = 0;
  protected float piercing = 0; // percentage from 0 - 1
  protected float penetration = 0; // percentage from 0 - 1
  protected float attackRange = 0;
  protected float attackCooldown = 0;
  protected float attackTime = 0;
  protected float sight = 0;
  protected float speed = 0;
  protected float tenacity = 0; // percentage from 0 - 1
  protected int agility = 0;
  protected float lifesteal = 0; // percentage
  protected boolean save_base_stats = false; // toggle true if manually changing stats

  protected int durability = 1; // when hits 0 item breaks
  protected int ammo = 0; // also used for other things (like key code)
  protected boolean toggled = false; // various uses
  protected Inventory inventory = null; // keyrings, item attachments, etc

  // graphics
  protected BounceInt bounce = new BounceInt(Constants.item_bounceConstant);

  Item(Item i) {
    this(i, 0, 0);
  }
  Item(Item i, float x, float y) {
    super();
    if (i == null) {
      this.remove = true;
      return;
    }
    this.ID = i.ID;
    this.display_name = i.display_name;
    this.type = i.type;
    this.description = i.description;
    this.x = x;
    this.y = y;
    this.curr_height = i.curr_height;
    this.remove = i.remove;
    this.stack = i.stack;
    this.size = i.size;
    this.tier = i.tier;
    this.curr_health = i.curr_health;
    this.hunger = i.hunger;
    this.thirst = i.thirst;
    this.money = i.money;
    this.health = i.health;
    this.attack = i.attack;
    this.magic = i.magic;
    this.defense = i.defense;
    this.resistance = i.resistance;
    this.piercing = i.piercing;
    this.penetration = i.penetration;
    this.attackRange = i.attackRange;
    this.attackCooldown = i.attackCooldown;
    this.attackTime = i.attackTime;
    this.sight = i.sight;
    this.speed = i.speed;
    this.tenacity = i.tenacity;
    this.agility = i.agility;
    this.lifesteal = i.lifesteal;
    this.ammo = i.ammo;
    this.toggled = i.toggled;
    this.inventory = i.inventory; // not a deep copy just a reference copy
  }
  Item(int ID) {
    super(ID);
    switch(ID) {
      // Consumables
      case 2101:
        this.setStrings("Crumb", "Food", "");
        this.hunger = 1;
        break;
      case 2102:
        this.setStrings("Unknown Food", "Food", "");
        this.hunger = 3;
        this.thirst = 1;
        break;
      case 2103:
        this.setStrings("Unknown Food", "Food", "");
        this.hunger = 3;
        this.thirst = 1;
        break;
      case 2104:
        this.setStrings("Unknown Food", "Food", "");
        this.hunger = 3;
        this.thirst = 1;
        break;
      case 2105:
        this.setStrings("Unknown Food", "Food", "");
        this.hunger = 4;
        break;
      case 2106:
        this.setStrings("Pickle", "Food", "");
        this.hunger = 10;
        this.thirst = 5;
        break;
      case 2107:
        this.setStrings("Ketchup", "Food", "");
        this.hunger = 6;
        this.thirst = 3;
        break;
      case 2108:
        this.setStrings("Chicken Wing", "Food", "");
        this.hunger = 25;
        this.thirst = 5;
        break;
      case 2109:
        this.setStrings("Steak", "Food", "");
        this.hunger = 40;
        this.thirst = 10;
        break;
      case 2110:
        this.setStrings("Poptart", "Food", "");
        this.hunger = 20;
        this.thirst = -5;
        break;
      case 2111:
        this.setStrings("Donut", "Food", "");
        this.hunger = 20;
        break;
      case 2112:
        this.setStrings("Chocolate", "Food", "");
        this.hunger = 18;
        break;
      case 2113:
        this.setStrings("Chips", "Food", "");
        this.hunger = 15;
        this.thirst = -5;
        break;
      case 2114:
        this.setStrings("Cheese", "Food", "");
        this.hunger = 12;
        this.thirst = 6;
        break;
      case 2115:
        this.setStrings("Peanuts", "Food", "");
        this.hunger = 15;
        this.thirst = -5;
        break;
      case 2116:
        this.setStrings("Raw Chicken", "Food", "");
        this.hunger = 20;
        this.thirst = 10;
        break;
      case 2117:
        this.setStrings("Cooked Chicken", "Food", "");
        this.hunger = 40;
        this.thirst = 10;
        break;
      case 2118:
        this.setStrings("Chicken Egg", "Food", "");
        this.hunger = 25;
        this.thirst = 10;
        break;
      case 2119:
        this.setStrings("Rotten Flesh", "Food", "");
        this.hunger = 10;
        this.thirst = 10;
        break;
      case 2120:
        this.setStrings("Apple", "Food", "");
        this.hunger = 18;
        this.thirst = 10;
        break;
      case 2121:
        this.setStrings("Banana", "Food", "");
        this.hunger = 16;
        this.thirst = 6;
        break;
      case 2122:
        this.setStrings("Pear", "Food", "");
        this.hunger = 18;
        this.thirst = 8;
        break;
      case 2123:
        this.setStrings("Bread", "Food", "");
        this.hunger = 25;
        break;
      case 2124:
        this.setStrings("Hot Pocket Box", "Package", "");
        break;
      case 2125:
        this.setStrings("Hot Pocket", "Food", "");
        this.hunger = 25;
        this.thirst = 5;
        break;
      case 2131:
        this.setStrings("Water Cup", "Drink", "");
        this.thirst = 12;
        break;
      case 2132:
        this.setStrings("Coke", "Drink", "");
        this.hunger = 6;
        this.thirst = 15;
        break;
      case 2133:
        this.setStrings("Wine", "Drink", "");
        this.hunger = 6;
        this.thirst = 20;
        break;
      case 2134:
        this.setStrings("Beer", "Drink", "");
        this.hunger = 8;
        this.thirst = 20;
        break;
      case 2141:
        this.setStrings("Holy Water", "Drink", "");
        this.tier = 2;
        this.curr_health = 10;
        this.thirst = 50;
        break;
      case 2142:
        this.setStrings("Golden Apple", "Food", "");
        this.tier = 3;
        this.curr_health = 30;
        this.hunger = 35;
        this.thirst = 10;
        break;
      case 2151:
        this.setStrings("One Dollar", "Money", "");
        this.money = 1;
        break;
      case 2152:
        this.setStrings("Five Dollars", "Money", "");
        this.money = 5;
        break;
      case 2153:
        this.setStrings("Ten Dollars", "Money", "");
        this.money = 10;
        break;
      case 2154:
        this.setStrings("Fifty Dollars", "Money", "");
        this.money = 50;
        break;
      case 2155:
        this.setStrings("Zucc Bucc", "Money", "");
        this.tier = 2;
        this.money = 101;
        this.size = 0.3;
        break;
      case 2156:
        this.setStrings("Wad of 5s", "Money", "");
        this.tier = 2;
        this.money = 500;
        this.size = 0.3;
        break;
      case 2157:
        this.setStrings("Wad of 10s", "Money", "");
        this.tier = 2;
        this.money = 1000;
        this.size = 0.3;
        break;
      case 2158:
        this.setStrings("Wad of 50s", "Money", "");
        this.tier = 2;
        this.money = 5000;
        this.size = 0.3;
        break;
      case 2159:
        this.setStrings("Wad of Zuccs", "Money", "");
        this.tier = 3;
        this.money = 10100;
        this.size = 0.3;
        break;
      case 2161:
        this.setStrings("Broken Candlestick", "Household Item", "");
        this.size = 0.4;
        break;
      case 2162:
        this.setStrings("Candlestick", "Household Item", "");
        this.size = 0.4;
        break;
      case 2163:
        this.setStrings("Candle", "Household Item", "");
        this.size = 0.21;
        this.ammo = 1200000;
        break;
      case 2164:
        this.setStrings("Lord's Day Candle", "Household Item", "");
        this.size = 0.55;
        this.tier = 2;
        this.ammo = 1200000;
        break;
      case 2165:
        this.setStrings("Lord's Day Papers", "Household Item", "");
        this.tier = 2;
        break;
      case 2166:
        this.setStrings("Wooden Horse", "Household Item", "");
        this.tier = 3;
        break;

      // Melee Weapons
      case 2201:
        this.setStrings("Foam Sword", "Melee Weapon", "");
        this.attack = 1;
        this.attackRange = 0.12;
        this.size = 0.3;
        this.durability = 10;
        break;
      case 2202:
        this.setStrings("Pan", "Melee Weapon", "");
        this.attack = 1.5;
        this.attackRange = 0.02;
        this.durability = 30;
        break;
      case 2203:
        this.setStrings("Knife", "Melee Weapon", "");
        this.attack = 3;
        this.attackRange = 0.01;
        this.piercing = 0.04;
        this.size = 0.3;
        this.durability = 45;
        break;
      case 2204:
        this.setStrings("Decoy", "Melee Weapon", "");
        this.attack = 5;
        this.attackRange = 0.1;
        this.piercing = 0.06;
        this.size = 0.3;
        this.durability = 70;
        break;
      case 2205:
        this.setStrings("Wooden Sword", "Melee Weapon", "");
        this.attack = 2.5;
        this.attackRange = 0.15;
        this.piercing = 0.01;
        this.size = 0.3;
        this.durability = 30;
        break;
      case 2206:
        this.setStrings("Talc Sword", "Melee Weapon", "");
        this.attack = 2;
        this.attackRange = 0.15;
        this.size = 0.3;
        this.durability = 10;
        break;
      case 2207:
        this.setStrings("Wooden Spear", "Melee Weapon", "");
        this.attack = 2;
        this.attackRange = 0.35;
        this.piercing = 0.04;
        this.size = 0.4;
        this.durability = 20;
        break;
      case 2208:
        this.setStrings("Talc Spear", "Melee Weapon", "");
        this.attack = 1.7;
        this.attackRange = 0.35;
        this.piercing = 0.03;
        this.size = 0.4;
        this.durability = 6;
        break;
      case 2211:
        this.setStrings("The Thing", "Melee Weapon", "");
        this.attack = 2;
        this.tier = 7;
        this.attackRange = 0.15;
        this.piercing = 0.08;
        this.size = 0.32;
        this.durability = 100;
        break;
      case 2212:
        this.setStrings("Gypsum Sword", "Melee Weapon", "");
        this.tier = 2;
        this.attack = 6;
        this.attackRange = 0.15;
        this.piercing = 0.02;
        this.size = 0.3;
        this.durability = 20;
        break;
      case 2213:
        this.setStrings("Gypsum Spear", "Melee Weapon", "");
        this.tier = 2;
        this.attack = 5.5;
        this.attackRange = 0.35;
        this.piercing = 0.05;
        this.size = 0.4;
        this.durability = 14;
        break;
      case 2214:
        this.setStrings("Board with Nails", "Melee Weapon", "");
        this.tier = 2;
        this.attack = 6;
        this.attackRange = 0.2;
        this.piercing = 0.02;
        this.size = 0.4;
        this.speed = -0.2;
        this.durability = 15;
        break;
      case 2221:
        this.setStrings("Calcite Sword", "Melee Weapon", "");
        this.tier = 3;
        this.attack = 50;
        this.attackRange = 0.15;
        this.piercing = 0.03;
        this.size = 0.3;
        this.durability = 30;
        break;
      case 2222:
        this.setStrings("Calcite Spear", "Melee Weapon", "");
        this.tier = 3;
        this.attack = 45;
        this.attackRange = 0.35;
        this.piercing = 0.08;
        this.size = 0.4;
        this.durability = 21;
        break;
      case 2223:
        this.setStrings("Metal Pipe", "Melee Weapon", "");
        this.tier = 3;
        this.attack = 13;
        this.attackRange = 0.25;
        this.size = 0.4;
        this.durability = 60;
        break;
      case 2231:
        this.setStrings("Fluorite Sword", "Melee Weapon", "");
        this.tier = 4;
        this.attack = 120;
        this.attackRange = 0.15;
        this.piercing = 0.05;
        this.size = 0.3;
        this.durability = 50;
        break;
      case 2232:
        this.setStrings("Fluorite Spear", "Melee Weapon", "");
        this.tier = 4;
        this.attack = 108;
        this.attackRange = 0.35;
        this.piercing = 0.12;
        this.size = 0.4;
        this.durability = 35;
        break;
      case 2241:
        this.setStrings("Apatite Sword", "Melee Weapon", "");
        this.tier = 5;
        this.attack = 260;
        this.attackRange = 0.15;
        this.piercing = 0.06;
        this.size = 0.3;
        this.durability = 70;
        break;
      case 2242:
        this.setStrings("Apatite Spear", "Melee Weapon", "");
        this.tier = 5;
        this.attack = 235;
        this.attackRange = 0.35;
        this.piercing = 0.14;
        this.size = 0.4;
        this.durability = 50;
        break;
      case 2251:
        this.setStrings("Orthoclase Sword", "Melee Weapon", "");
        this.tier = 6;
        this.attack = 350;
        this.attackRange = 0.15;
        this.piercing = 0.07;
        this.size = 0.3;
        this.durability = 100;
        break;
      case 2252:
        this.setStrings("Orthoclase Spear", "Melee Weapon", "");
        this.tier = 6;
        this.attack = 315;
        this.attackRange = 0.35;
        this.piercing = 0.16;
        this.size = 0.4;
        this.durability = 70;
        break;
      case 2261:
        this.setStrings("Quartz Sword", "Melee Weapon", "");
        this.tier = 7;
        this.attack = 460;
        this.attackRange = 0.15;
        this.piercing = 0.08;
        this.size = 0.3;
        this.durability = 150;
        break;
      case 2262:
        this.setStrings("Quartz Spear", "Melee Weapon", "");
        this.tier = 7;
        this.attack = 415;
        this.attackRange = 0.35;
        this.piercing = 0.18;
        this.size = 0.4;
        this.durability = 105;
        break;
      case 2271:
        this.setStrings("Topaz Sword", "Melee Weapon", "");
        this.tier = 8;
        this.attack = 980;
        this.attackRange = 0.15;
        this.piercing = 0.09;
        this.size = 0.3;
        this.durability = 250;
        break;
      case 2272:
        this.setStrings("Topaz Spear", "Melee Weapon", "");
        this.tier = 8;
        this.attack = 890;
        this.attackRange = 0.35;
        this.piercing = 0.2;
        this.size = 0.4;
        this.durability = 175;
        break;
      case 2281:
        this.setStrings("Corundum Sword", "Melee Weapon", "");
        this.tier = 9;
        this.attack = 2000;
        this.attackRange = 0.15;
        this.piercing = 0.1;
        this.size = 0.3;
        this.durability = 400;
        break;
      case 2282:
        this.setStrings("Corundum Spear", "Melee Weapon", "");
        this.tier = 9;
        this.attack = 1750;
        this.attackRange = 0.35;
        this.piercing = 0.22;
        this.size = 0.4;
        this.durability = 280;
        break;
      case 2291:
        this.setStrings("Diamond Sword", "Melee Weapon", "");
        this.tier = 10;
        this.attack = 9100;
        this.attackRange = 0.15;
        this.piercing = 0.11;
        this.size = 0.3;
        this.durability = 1000;
        break;
      case 2292:
        this.setStrings("Diamond Spear", "Melee Weapon", "");
        this.tier = 10;
        this.attack = 7400;
        this.attackRange = 0.35;
        this.piercing = 0.24;
        this.size = 0.4;
        this.durability = 700;
        break;

      // Ranged Weapons
      case 2301:
        this.setStrings("Slingshot", "Ranged Weapon", "");
        this.attack = 5;
        this.attackRange = 3;
        this.size = 0.3;
        this.durability = 30;
        break;
      case 2311:
        this.setStrings("Recurve Bow", "Ranged Weapon", "");
        this.tier = 2;
        this.attack = 8;
        this.attackRange = 5;
        this.piercing = 0.15;
        this.size = 0.3;
        this.durability = 50;
        break;
      case 2312:
        this.setStrings("M1911", "Ranged Weapon", "Semi-automatic with medium capacity and power. Effective at close range.");
        this.tier = 2;
        this.attack = 2;
        this.size = 0.3;
        this.durability = 120;
        break;
      case 2321:
        this.setStrings("War Machine", "Ranged Weapon", "6 round semi-automatic grenade launcher.");
        this.tier = 3;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2322:
        this.setStrings("Five-Seven", "Ranged Weapon", "Semi-automatic pistol. Versatile and strong overall with a large magazine.");
        this.tier = 3;
        this.attack = 2;
        this.size = 0.3;
        this.durability = 120;
        break;
      case 2323:
        this.setStrings("Type25", "Ranged Weapon", "Fully automatic assault rifle. High rate of fire with moderate recoil.");
        this.tier = 3;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2331:
        this.setStrings("Mustang and Sally", "Ranged Weapon", "");
        this.tier = 4;
        this.attack = 3;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2332:
        this.setStrings("FAL", "Ranged Weapon", "Fully automatic assault rifle with high damage. Effective at medium to long range.");
        this.tier = 4;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2333:
        this.setStrings("Python", "Ranged Weapon", "The Python .357 magnum revolver. No thank you, I have reproductive organs of my own.");
        this.tier = 4;
        this.attack = 3;
        this.size = 0.3;
        this.durability = 120;
        break;
      case 2341:
        this.setStrings("RPG", "Ranged Weapon", "Free-fire shoulder mounted rocket launcher.");
        this.tier = 5;
        this.attack = 3;
        this.attackRange = 0.04;
        this.speed = -1;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2342:
        this.setStrings("Dystopic Demolisher", "Ranged Weapon", "");
        this.tier = 5;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2343:
        this.setStrings("Ultra", "Ranged Weapon", "");
        this.tier = 5;
        this.attack = 3;
        this.size = 0.3;
        this.durability = 120;
        break;
      case 2344:
        this.setStrings("Strain25", "Ranged Weapon", "");
        this.tier = 5;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2345:
        this.setStrings("Executioner", "Ranged Weapon", "Double-action revolver pistol. Fires 28 gauge shotgun shells.");
        this.tier = 5;
        this.attack = 3;
        this.size = 0.3;
        this.size = 0.3;
        this.durability = 120;
        break;
      case 2351:
        this.setStrings("Galil", "Ranged Weapon", "Fully automatic assault rifle. Effective at medium to long range.");
        this.tier = 6;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2352:
        this.setStrings("WN", "Ranged Weapon", "");
        this.tier = 6;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2353:
        this.setStrings("Ballistic Knife", "Ranged Weapon", "Spring-action knife launcher. Increases melee speed and can fire the blade as a projectile.");
        this.tier = 6;
        this.attack = 3;
        this.attackRange = 0.04;
        this.speed = 1;
        this.lifesteal = 0.1;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2354:
        this.setStrings("Cobra", "Ranged Weapon", "");
        this.tier = 6;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2355:
        this.setStrings("MTAR", "Ranged Weapon", "Fully automatic assault rifle. Versatile and strong overall.");
        this.tier = 6;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2361:
        this.setStrings("RPD", "Ranged Weapon", "Fully automatic with good power and quick fire rate. Effective at medium to long range.");
        this.tier = 7;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2362:
        this.setStrings("Rocket-Propelled Grievance", "Ranged Weapon", "");
        this.tier = 7;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2363:
        this.setStrings("DSR-50", "Ranged Weapon", "");
        this.tier = 7;
        this.attack = 3;
        this.attackRange = 0.04;
        this.speed = -1;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2364:
        this.setStrings("Voice of Justice", "Ranged Weapon", "");
        this.tier = 7;
        this.attack = 3;
        this.size = 0.3;
        this.durability = 120;
        break;
      case 2371:
        this.setStrings("HAMR", "Ranged Weapon", "Fully automatic LMG. Reduces fire rate with less ammo, becoming more accurate.");
        this.tier = 8;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2372:
        this.setStrings("Ray Gun", "Ranged Weapon", "It's weird, but it works.");
        this.tier = 8;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2373:
        this.setStrings("Lamentation", "Ranged Weapon", "");
        this.tier = 8;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2374:
        this.setStrings("The Krauss Refibrillator", "Ranged Weapon", "");
        this.tier = 8;
        this.attack = 3;
        this.attackRange = 0.04;
        this.speed = 1.5;
        this.lifesteal = 0.15;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2375:
        this.setStrings("Malevolent Taxonomic Anodized Redeemer", "Ranged Weapon", "");
        this.tier = 8;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2381:
        this.setStrings("Relativistic Punishment Device", "Ranged Weapon", "");
        this.tier = 9;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2382:
        this.setStrings("Dead Specimen Reactor 5000", "Ranged Weapon", "");
        this.tier = 9;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2391:
        this.setStrings("SLDG HAMR", "Ranged Weapon", "");
        this.tier = 10;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;
      case 2392:
        this.setStrings("Porter's X2 Ray Gun", "Ranged Weapon", "");
        this.tier = 10;
        this.attack = 3;
        this.attackRange = 0.04;
        this.size = 0.35;
        this.durability = 120;
        break;

      // Headgear
      case 2401:
        this.setStrings("Talc Helmet", "Headgear", "");
        this.defense = 1;
        this.durability = 10;
        break;
      case 2402:
        this.setStrings("Cap", "Headgear", "");
        this.durability = 10;
        break;
      case 2403:
        this.setStrings("Bowl", "Headgear", "");
        this.defense = 1;
        this.durability = 25;
        break;
      case 2404:
        this.setStrings("Pot", "Headgear", "");
        this.defense = 2;
        this.speed = -0.5;
        this.durability = 60;
        break;
      case 2411:
        this.setStrings("Gypsum Helmet", "Headgear", "");
        this.tier = 2;
        this.defense = 2;
        this.durability = 20;
        break;
      case 2421:
        this.setStrings("Calcite Helmet", "Headgear", "");
        this.tier = 3;
        this.defense = 14;
        this.durability = 30;
        break;
      case 2431:
        this.setStrings("Fluorite Helmet", "Headgear", "");
        this.tier = 4;
        this.defense = 21;
        this.durability = 50;
        break;
      case 2441:
        this.setStrings("Apatite Helmet", "Headgear", "");
        this.tier = 5;
        this.defense = 48;
        this.durability = 70;
        break;
      case 2451:
        this.setStrings("Orthoclase Helmet", "Headgear", "");
        this.tier = 6;
        this.defense = 72;
        this.durability = 100;
        break;
      case 2461:
        this.setStrings("Quartz Helmet", "Headgear", "");
        this.tier = 7;
        this.defense = 100;
        this.durability = 150;
        break;
      case 2471:
        this.setStrings("Topaz Helmet", "Headgear", "");
        this.tier = 8;
        this.defense = 200;
        this.durability = 250;
        break;
      case 2481:
        this.setStrings("Corundum Helmet", "Headgear", "");
        this.tier = 9;
        this.defense = 400;
        this.durability = 450;
        break;
      case 2491:
        this.setStrings("Diamond Helmet", "Headgear", "");
        this.tier = 10;
        this.defense = 1500;
        this.durability = 1000;
        break;

      // Chestgear
      case 2501:
        this.setStrings("Talc Chestplate", "Chestgear", "");
        this.defense = 1;
        this.durability = 10;
        break;
      case 2502:
        this.setStrings("T-Shirt", "Chestgear", "");
        this.attackRange = 0.04;
        this.durability = 10;
        break;
      case 2503:
        this.setStrings("Bra", "Chestgear", "");
        this.attackRange = 0.02;
        this.durability = 10;
        break;
      case 2504:
        this.setStrings("Coat", "Chestgear", "");
        this.attackRange = 0.04;
        this.defense = 1;
        this.durability = 15;
        break;
      case 2511:
        this.setStrings("Gypsum Chestplate", "Chestgear", "");
        this.tier = 2;
        this.defense = 2;
        this.durability = 20;
        break;
      case 2512:
        this.setStrings("Ben's Coat", "Chestgear", "");
        this.tier = 2;
        this.health = 3;
        this.attackRange = 0.05;
        this.defense = 2;
        this.durability = 35;
        break;
      case 2513:
        this.setStrings("Suit Jacket", "Chestgear", "");
        this.tier = 2;
        this.attackRange = 0.04;
        this.durability = 15;
        break;
      case 2521:
        this.setStrings("Calcite Chestplate", "Chestgear", "");
        this.tier = 3;
        this.defense = 14;
        this.durability = 30;
        break;
      case 2531:
        this.setStrings("Fluorite Chestplate", "Chestgear", "");
        this.tier = 4;
        this.defense = 21;
        this.durability = 50;
        break;
      case 2541:
        this.setStrings("Apatite Chestplate", "Chestgear", "");
        this.tier = 5;
        this.defense = 48;
        this.durability = 70;
        break;
      case 2551:
        this.setStrings("Orthoclase Chestplate", "Chestgear", "");
        this.tier = 6;
        this.defense = 72;
        this.durability = 100;
        break;
      case 2561:
        this.setStrings("Quartz Chestplate", "Chestgear", "");
        this.tier = 7;
        this.defense = 100;
        this.durability = 150;
        break;
      case 2571:
        this.setStrings("Topaz Chestplate", "Chestgear", "");
        this.tier = 8;
        this.defense = 200;
        this.durability = 250;
        break;
      case 2581:
        this.setStrings("Corundum Chestplate", "Chestgear", "");
        this.tier = 9;
        this.defense = 400;
        this.durability = 450;
        break;
      case 2591:
        this.setStrings("Diamond Chestplate", "Chestgear", "");
        this.tier = 10;
        this.defense = 1500;
        this.durability = 1000;
        break;

      // Leggear
      case 2601:
        this.setStrings("Talc Greaves", "Leggear", "");
        this.defense = 1;
        this.durability = 10;
        break;
      case 2602:
        this.setStrings("Boxers", "Leggear", "");
        this.attackRange = 0.02;
        this.durability = 10;
        break;
      case 2603:
        this.setStrings("Towel", "Leggear", "");
        this.attackRange = 0.06;
        this.durability = 8;
        break;
      case 2604:
        this.setStrings("Pants", "Leggear", "");
        this.attackRange = 0.08;
        this.defense = 1;
        this.durability = 15;
        break;
      case 2611:
        this.setStrings("Gypsum Greaves", "Leggear", "");
        this.tier = 2;
        this.defense = 2;
        this.durability = 20;
        break;
      case 2622:
        this.setStrings("Calcite Greaves", "Leggear", "");
        this.tier = 3;
        this.defense = 14;
        this.durability = 30;
        break;
      case 2631:
        this.setStrings("Fluorite Greaves", "Leggear", "");
        this.tier = 4;
        this.defense = 21;
        this.durability = 50;
        break;
      case 2641:
        this.setStrings("Apatite Greaves", "Leggear", "");
        this.tier = 5;
        this.defense = 48;
        this.durability = 70;
        break;
      case 2651:
        this.setStrings("Orthoclase Greaves", "Leggear", "");
        this.tier = 6;
        this.defense = 72;
        this.durability = 100;
        break;
      case 2661:
        this.setStrings("Quartz Greaves", "Leggear", "");
        this.tier = 7;
        this.defense = 100;
        this.durability = 150;
        break;
      case 2671:
        this.setStrings("Topaz Greaves", "Leggear", "");
        this.tier = 8;
        this.defense = 200;
        this.durability = 250;
        break;
      case 2681:
        this.setStrings("Corundum Greaves", "Leggear", "");
        this.tier = 9;
        this.defense = 400;
        this.durability = 450;
        break;
      case 2691:
        this.setStrings("Diamond Greaves", "Leggear", "");
        this.tier = 10;
        this.defense = 1500;
        this.durability = 1000;
        break;

      // Footgear
      case 2701:
        this.setStrings("Talc Boots", "Footgear", "");
        this.defense = 1;
        this.durability = 10;
        break;
      case 2702:
        this.setStrings("Socks", "Footgear", "");
        this.durability = 8;
        break;
      case 2703:
        this.setStrings("Sandals", "Footgear", "");
        this.speed = 0.2;
        this.durability = 12;
        break;
      case 2704:
        this.setStrings("Shoes", "Footgear", "");
        this.defense = 1;
        this.speed = 0.4;
        this.durability = 18;
        break;
      case 2705:
        this.setStrings("Boots", "Footgear", "");
        this.defense = 2;
        this.speed = 0.4;
        this.durability = 25;
        break;
      case 2711:
        this.setStrings("Gypsum Boots", "Footgear", "");
        this.tier = 2;
        this.defense = 2;
        this.durability = 20;
        break;
      case 2712:
        this.setStrings("Sneakers", "Footgear", "");
        this.tier = 2;
        this.defense = 1;
        this.speed = 0.6;
        this.durability = 40;
        break;
      case 2713:
        this.setStrings("Steel-Toed Boots", "Footgear", "");
        this.tier = 2;
        this.attack = 1;
        this.defense = 3;
        this.speed = 0.4;
        this.durability = 60;
        break;
      case 2714:
        this.setStrings("Cowboy Boots", "Footgear", "");
        this.tier = 2;
        this.defense = 2;
        this.speed = 0.6;
        this.durability = 60;
        break;
      case 2721:
        this.setStrings("Calcite Boots", "Footgear", "");
        this.tier = 3;
        this.defense = 14;
        this.durability = 30;
        break;
      case 2731:
        this.setStrings("Fluorite Boots", "Footgear", "");
        this.tier = 4;
        this.defense = 21;
        this.durability = 50;
        break;
      case 2741:
        this.setStrings("Apatite Boots", "Footgear", "");
        this.tier = 5;
        this.defense = 48;
        this.durability = 70;
        break;
      case 2751:
        this.setStrings("Orthoclase Boots", "Footgear", "");
        this.tier = 6;
        this.defense = 72;
        this.durability = 100;
        break;
      case 2761:
        this.setStrings("Quartz Boots", "Footgear", "");
        this.tier = 7;
        this.defense = 100;
        this.durability = 150;
        break;
      case 2771:
        this.setStrings("Topaz Boots", "Footgear", "");
        this.tier = 8;
        this.defense = 200;
        this.durability = 250;
        break;
      case 2781:
        this.setStrings("Corundum Boots", "Footgear", "");
        this.tier = 9;
        this.defense = 400;
        this.durability = 450;
        break;
      case 2791:
        this.setStrings("Diamond Boots", "Footgear", "");
        this.tier = 10;
        this.defense = 1500;
        this.durability = 1000;
        break;

      // Material
      case 2801:
        this.setStrings("Talc Ore", "Material", "");
        break;
      case 2802:
        this.setStrings("Talc Crystal", "Material", "");
        break;
      case 2803:
        this.setStrings("Talc Powder", "Material", "");
        break;
      case 2804:
        this.setStrings("Soapstone", "Material", "");
        break;
      case 2805:
        this.setStrings("Broken Glass", "Material", "");
        break;
      case 2806:
        this.setStrings("Wire", "Material", "");
        break;
      case 2807:
        this.setStrings("Feather", "Material", "");
        break;
      case 2808:
        this.setStrings("Ashes", "Material", "");
        break;
      case 2809:
        this.setStrings("String", "Material", "");
        break;
      case 2810:
        this.setStrings("Wax", "Material", "");
        break;
      case 2811:
        this.setStrings("Gypsum Ore", "Material", "");
        this.tier = 2;
        break;
      case 2812:
        this.setStrings("Gypsum Crystal", "Material", "");
        this.tier = 2;
        break;
      case 2813:
        this.setStrings("Gypsum Powder", "Material", "");
        this.tier = 2;
        break;
      case 2814:
        this.setStrings("Selenite Crystal", "Material", "");
        this.tier = 2;
        break;
      case 2815:
        this.setStrings("Barbed Wire", "Material", "");
        this.tier = 2;
        break;
      case 2816:
        this.setStrings("Wooden Plank", "Material", "");
        this.tier = 2;
        this.attack = 2.4;
        this.attackRange = 0.6;
        this.speed = -0.8;
        this.size = 0.48;
        break;
      case 2817:
        this.setStrings("Wooden Handle", "Material", "");
        this.tier = 2;
        this.attack = 2.8;
        this.attackRange = 0.4;
        this.size = 0.3;
        break;
      case 2818:
        this.setStrings("Wooden Piece", "Material", "");
        this.tier = 2;
        this.attack = 0.5;
        this.attackRange = 0.02;
        this.size = 0.3;
        break;
      case 2821:
        this.setStrings("Calcite Ore", "Material", "");
        this.tier = 3;
        break;
      case 2822:
        this.setStrings("Calcite Crystal", "Material", "");
        this.tier = 3;
        break;
      case 2823:
        this.setStrings("Chalk", "Material", "");
        this.tier = 3;
        break;
      case 2824:
        this.setStrings("Iceland Spar", "Material", "");
        this.tier = 3;
        break;
      case 2825:
        this.setStrings("Star Piece", "Material", "");
        this.tier = 3;
        break;
      case 2831:
        this.setStrings("Fluorite Ore", "Material", "");
        this.tier = 4;
        break;
      case 2832:
        this.setStrings("Fluorite Crystal", "Material", "");
        this.tier = 4;
        break;
      case 2833:
        this.setStrings("Iron Crystal", "Material", "");
        this.tier = 4;
        break;
      case 2834:
        this.setStrings("Iron Crystal", "Material", "");
        this.tier = 4;
        break;
      case 2841:
        this.setStrings("Apatite Ore", "Material", "");
        this.tier = 5;
        break;
      case 2842:
        this.setStrings("Apatite Crystal", "Material", "");
        this.tier = 5;
        break;
      case 2843:
        this.setStrings("Iron Handle", "Material", "");
        this.tier = 5;
        this.attack = 12;
        this.attackRange = 0.4;
        this.size = 0.3;
        break;
      case 2851:
        this.setStrings("Orthoclase Ore", "Material", "");
        this.tier = 6;
        break;
      case 2852:
        this.setStrings("Orthoclase Chunk", "Material", "");
        this.tier = 6;
        break;
      case 2861:
        this.setStrings("Quartz Ore", "Material", "");
        this.tier = 7;
        break;
      case 2862:
        this.setStrings("Quartz Crystal", "Material", "");
        this.tier = 7;
        break;
      case 2863:
        this.setStrings("Amethyst", "Material", "");
        this.tier = 7;
        break;
      case 2864:
        this.setStrings("Glass", "Material", "");
        this.tier = 7;
        break;
      case 2871:
        this.setStrings("Topaz Ore", "Material", "");
        this.tier = 8;
        break;
      case 2872:
        this.setStrings("Topaz Chunk", "Material", "");
        this.tier = 8;
        break;
      case 2873:
        this.setStrings("Topaz Gem", "Material", "");
        this.tier = 8;
        break;
      case 2881:
        this.setStrings("Corundum Ore", "Material", "");
        this.tier = 9;
        break;
      case 2882:
        this.setStrings("Corundum Chunk", "Material", "");
        this.tier = 9;
        break;
      case 2883:
        this.setStrings("Sapphire", "Material", "");
        this.tier = 9;
        break;
      case 2891:
        this.setStrings("Diamond Ore", "Material", "");
        this.tier = 10;
        break;
      case 2892:
        this.setStrings("Diamond", "Material", "");
        this.tier = 10;
        break;

      // Other
      case 2901:
        this.setStrings("Key", "Key", "");
        break;
      case 2902:
        this.setStrings("Master Key", "Key", "");
        this.tier = 2;
        break;
      case 2903:
        this.setStrings("Skeleton Key", "Key", "");
        this.tier = 3;
        break;
      case 2904:
        this.setStrings("Small Key Ring", "Utility", "A small ring used to " +
          "hold keys. Holds up to 8 keys which can be used directly from the " +
          "keyring.");
        this.tier = 2;
        this.inventory = new SmallKeyringInventory();
        break;
      case 2905:
        this.setStrings("Large Key Ring", "Utility", "A large ring used to " +
          "hold keys. Holds up to 24 keys which can be used directly from the " +
          "keyring.");
        this.tier = 3;
        this.inventory = new LargeKeyringInventory();
        break;
      case 2911:
        this.setStrings("Pen", "Office", "");
        this.attack = 1;
        break;
      case 2912:
        this.setStrings("Pencil", "Office", "");
        this.attack = 1;
        break;
      case 2913:
        this.setStrings("Paper", "Office", "");
        break;
      case 2914:
        this.setStrings("Document", "Office", "");
        break;
      case 2915:
        this.setStrings("Stapler", "Office", "");
        this.attack = 1;
        break;
      case 2916:
        this.setStrings("Crumpled Paper", "Office", "");
        break;
      case 2917:
        this.setStrings("Eraser", "Office", "");
        break;
      case 2918:
        this.setStrings("Scissors", "Office", "");
        this.attack = 1.5;
        break;
      case 2921:
        this.setStrings("Backpack", "Utility", "");
        this.attackRange = 0.04;
        break;
      case 2922:
        this.setStrings("Ben's Backpack", "Utility", "");
        this.attackRange = 0.04;
        break;
      case 2923:
        this.setStrings("Purse", "Utility", "");
        this.attackRange = 0.04;
        break;
      case 2924:
        this.setStrings("Glass Bottle", "Utility", "");
        this.attack = 1;
        this.piercing = 0.06;
        break;
      case 2925:
        this.setStrings("Water Bottle", "Utility", "");
        break;
      case 2926:
        this.setStrings("Canteen", "Utility", "");
        this.tier = 2;
        this.attack = 1;
        this.attackRange = 0.02;
        break;
      case 2927:
        this.setStrings("Water Jug", "Utility", "");
        this.tier = 3;
        this.attack = 1;
        this.attackRange = 0.02;
        break;
      case 2928:
        this.setStrings("Cigar", "Utility", "");
        this.ammo = Constants.item_cigarLitTime;
        break;
      case 2931:
        this.setStrings("Rock", "Ammo", "");
        this.attack = 1;
        break;
      case 2932:
        this.setStrings("Arrow", "Ammo", "");
        this.attack = 1;
        this.piercing = 0.05;
        break;
      case 2933:
        this.setStrings("Pebble", "Ammo", "");
        this.size = 0.22;
        break;
      case 2941:
        this.setStrings(".45 ACP", "Ammo", "");
        this.size = 0.22;
        break;
      case 2942:
        this.setStrings("7.62x39mm", "Ammo", "");
        this.tier = 2;
        this.size = 0.22;
        break;
      case 2943:
        this.setStrings("5.56x45mm", "Ammo", "");
        this.tier = 2;
        this.size = 0.22;
        break;
      case 2944:
        this.setStrings("Grenade", "Ammo", "");
        this.tier = 2;
        this.attack = 2;
        break;
      case 2945:
        this.setStrings(".357 Magnum", "Ammo", "");
        this.tier = 2;
        this.size = 0.22;
        break;
      case 2946:
        this.setStrings(".50 BMG", "Ammo", "");
        this.tier = 2;
        this.size = 0.22;
        break;
      case 2947:
        this.setStrings("FN 5.7x28mm", "Ammo", "");
        this.tier = 2;
        this.size = 0.22;
        break;
      case 2948:
        this.setStrings("28 Gauge", "Ammo", "");
        this.tier = 2;
        this.size = 0.22;
        break;
      case 2961:
        this.setStrings("Dandelion", "Nature", "");
        break;
      case 2962:
        this.setStrings("Rose", "Nature", "");
        break;
      case 2963:
        this.setStrings("Stick", "Nature", "");
        this.attack = 1;
        this.attackRange = 0.05;
        break;
      case 2964:
        this.setStrings("Kindling", "Nature", "");
        this.attackRange = 0.04;
        break;
      case 2965:
      case 2966:
      case 2967:
      case 2968:
        this.setStrings("Branch", "Nature", "");
        this.attack = 1;
        this.attackRange = 0.05;
        break;
      case 2969:
        this.setStrings("Wooden Log", "Nature", "");
        this.size = 0.6;
        this.attack = 1.8;
        this.speed = -1.4;
        this.tier = 2;
        break;
      case 2971:
        this.setStrings("Paintbrush", "Tool", "");
        break;
      case 2972:
        this.setStrings("Clamp", "Tool", "");
        this.attack = 1;
        this.attackRange = 0.02;
        break;
      case 2973:
        this.setStrings("Wrench", "Tool", "");
        this.attack = 1;
        this.attackRange = 0.02;
        break;
      case 2974:
        this.setStrings("Rope", "Tool", "");
        this.tier = 2;
        break;
      case 2975:
        this.setStrings("Hammer", "Tool", "");
        this.tier = 2;
        this.attack = 2;
        this.attackRange = 0.02;
        break;
      case 2976:
        this.setStrings("Window Breaker", "Tool", "");
        this.tier = 2;
        this.attack = 1;
        break;
      case 2977:
        this.setStrings("Ax", "Tool", "");
        this.tier = 3;
        this.attack = 3;
        this.attackRange = 0.08;
        this.piercing = 0.15;
        this.size = 0.32;
        break;
      case 2978:
        this.setStrings("Wire Clippers", "Tool", "");
        this.tier = 3;
        this.attack = 2;
        this.attackRange = 0.1;
        this.size = 0.32;
        break;
      case 2979:
        this.setStrings("Saw", "Tool", "");
        this.tier = 3;
        this.attack = 2;
        this.attackRange = 0.05;
        this.piercing = 0.05;
        this.size = 0.32;
        break;
      case 2980:
        this.setStrings("Drill", "Tool", "");
        this.tier = 4;
        this.attack = 1;
        break;
      case 2981:
        this.setStrings("Roundsaw", "Tool", "");
        this.tier = 4;
        this.attack = 1;
        this.piercing = 0.05;
        this.size = 0.35;
        break;
      case 2982:
        this.setStrings("Beltsander", "Tool", "");
        this.tier = 4;
        this.attack = 1;
        this.size = 0.35;
        break;
      case 2983:
        this.setStrings("Chainsaw", "Tool", "");
        this.tier = 5;
        this.attack = 5;
        this.attackRange = 0.07;
        this.piercing = 0.2;
        this.size = 0.38;
        break;
      case 2984:
        this.setStrings("Woodglue", "Tool", "");
        this.tier = 2;
        break;
      case 2985:
        this.setStrings("Nails", "Tool", "");
        break;
      case 2986:
        this.setStrings("Screws", "Tool", "");
        break;
      case 2987:
        this.setStrings("Flint and Steel", "Tool", "");
        this.attack = 0.5;
        this.tier = 3;
        break;
      case 2988:
        this.setStrings("Lighter", "Tool", "");
        this.tier = 3;
        break;
      case 2991:
        this.setStrings("Rankin's Third Ball", "Rare Object", "");
        this.tier = 1;
        this.size = 0.22;
        break;
      case 2992:
        this.setStrings("Soldier's Covenant", "Rare Object", "");
        this.tier = 2;
        break;
      case 2993:
        this.setStrings("Jonah Plush Toy", "Rare Object", "");
        this.tier = 3;
        break;

      default:
        global.errorMessage("ERROR: Item ID " + ID + " not found.");
        break;
    }
  }
  Item(int ID, float x, float y) {
    this(ID);
    this.x = x;
    this.y = y;
  }

  String display_name() {
    switch(this.ID) {
      case 2118: // chicken egg
        if (this.toggled) {
          return "Fertilized " + this.display_name;
        }
        return this.display_name;
      case 2901: // key
        return this.display_name + " (" + this.ammo + ")";
      case 2902: // master key
        return this.display_name + " (" + this.ammo * 10 + " - " + int(this.ammo * 10 + 9) + ")";
      case 2903: // skeleton key
        return this.display_name + " (" + this.ammo * 100 + " - " + int(this.ammo * 100 + 99) + ")";
      case 2928: // cigar
        if (this.toggled) {
          return "Lit " + this.display_name;
        }
        return this.display_name;
      default:
        return this.display_name;
    }
  }
  String display_name_editor() {
    return this.display_name() + " (" + this.map_key + ")";
  }
  String type() {
    return this.type;
  }
  String description() {
    return this.description;
  }
  String selectedObjectTextboxText() {
    String text = "-- " + this.type() + " --\n";
    if (this.curr_health != 0) {
      text += "\nHealth Regeneration: " + this.curr_health;
    }
    if (this.hunger != 0) {
      text += "\nFood: " + this.hunger;
    }
    if (this.thirst != 0) {
      text += "\nThirst: " + this.thirst;
    }
    if (this.money != 0) {
      text += "\nMoney: " + this.money;
    }
    if (this.health != 0) {
      text += "\nHealth: " + this.health;
    }
    if (this.breakable()) {
      text += "\nDurability: " + this.durability;
    }
    if (this.type.equals("Ranged Weapon")) {
      text += "\nAmmo: " + this.ammo + "/" + this.maximumAmmo();
      if (this.shootAttack() != 0) {
        text += "\nAttack: " + this.shootAttack();
      }
      if (this.shootMagic() != 0) {
        text += "\nMagic: " + this.shootMagic();
      }
      if (this.shootPiercing() != 0) {
        text += "\nPiercing: " + this.shootPiercing();
      }
      if (this.shootPenetration() != 0) {
        text += "\nPenetration: " + this.shootPenetration();
      }
      if (this.shootRange() != 0) {
        text += "\nRange: " + this.shootRange();
      }
      text += "\nInaccuracy: " + this.shootInaccuracy();
    }
    else {
      if (this.attack != 0) {
        text += "\nAttack: " + this.attack;
      }
      if (this.magic != 0) {
        text += "\nMagic: " + this.magic;
      }
      if (this.piercing != 0) {
        text += "\nPiercing: " + this.piercing;
      }
      if (this.penetration != 0) {
        text += "\nPenetration: " + this.penetration;
      }
      if (this.attackRange != 0) {
        text += "\nRange: " + this.attackRange;
      }
    }
    if (this.defense != 0) {
      text += "\nDefense: " + this.defense;
    }
    if (this.resistance != 0) {
      text += "\nResistance: " + this.resistance;
    }
    if (this.attackCooldown != 0) {
      text += "\nAttack Cooldown: " + this.attackCooldown;
    }
    if (this.attackTime != 0) {
      text += "\nAttack Time: " + this.attackTime;
    }
    if (this.sight != 0) {
      text += "\nSight: " + this.sight;
    }
    if (this.speed != 0) {
      text += "\nSpeed: " + this.speed;
    }
    if (this.tenacity != 0) {
      text += "\nTenacity: " + this.tenacity;
    }
    if (this.agility != 0) {
      text += "\nAgility: " + this.agility;
    }
    if (this.lifesteal != 0) {
      text += "\nLifesteal: " + this.lifesteal;
    }
    return text + "\n\n" + this.description();
  }

  void setLocation(float x, float y) {
    this.x = x;
    this.y = y;
  }

  float xi() {
    return this.x - this.size;
  }
  float yi() {
    return this.y - this.size;
  }
  float xf() {
    return this.x + this.size;
  }
  float yf() {
    return this.y + this.size;
  }
  float xCenter() {
    return this.x;
  }
  float yCenter() {
    return this.y;
  }
  float width() {
    return 2 * this.size;
  }
  float height() {
    return 2 * this.size;
  }
  float xRadius() {
    return this.size;
  }
  float yRadius() {
    return this.size;
  }

  PImage getImage() {
    String path = "items/";
    switch(this.ID) {
      // Consumables
      case 2101:
        path += "crumb.png";
        break;
      case 2102:
        path += "wasabi.png";
        break;
      case 2103:
        path += "stuffing.jpg";
        break;
      case 2104:
        path += "catbarf.jpg";
        break;
      case 2105:
        path += "ramen.png";
        break;
      case 2106:
        path += "pickle.png";
        break;
      case 2107:
        path += "ketchup.png";
        break;
      case 2108:
        path += "chicken_wing.png";
        break;
      case 2109:
        path += "steak.png";
        break;
      case 2110:
        path += "poptart.png";
        break;
      case 2111:
        path += "donut.png";
        break;
      case 2112:
        path += "chocolate.png";
        break;
      case 2113:
        path += "chips.png";
        break;
      case 2114:
        path += "cheese.png";
        break;
      case 2115:
        path += "peanuts.png";
        break;
      case 2116:
        path += "raw_chicken.png";
        break;
      case 2117:
        path += "cooked_chicken.png";
        break;
      case 2118:
        path += "chicken_egg.png";
        break;
      case 2119:
        path += "rotten_flesh.png";
        break;
      case 2120:
        path += "apple.png";
        break;
      case 2121:
        path += "banana.png";
        break;
      case 2122:
        path += "pear.png";
        break;
      case 2123:
        path += "bread.png";
        break;
      case 2124:
        path += "hotpocket_box.png";
        break;
      case 2125:
        path += "hotpocket.png";
        break;
      case 2131:
        path += "water_cup.png";
        break;
      case 2132:
        path += "coke.png";
        break;
      case 2133:
        path += "wine.png";
        break;
      case 2134:
        path += "beer.png";
        break;
      case 2141:
        path += "holy_water.png";
        break;
      case 2142:
        path += "golden_apple.png";
        break;
      case 2151:
        path += "one_dollar.png";
        break;
      case 2152:
        path += "five_dollars.png";
        break;
      case 2153:
        path += "ten_dollars.png";
        break;
      case 2154:
        path += "fifty_dollars.png";
        break;
      case 2155:
        path += "zucc_bucc.png";
        break;
      case 2156:
        path += "wad_of_fives.png";
        break;
      case 2157:
        path += "wad_of_tens.png";
        break;
      case 2158:
        path += "wad_of_fifties.png";
        break;
      case 2159:
        path += "wad_of_zuccs.png";
        break;
      case 2161:
        path += "broken_candlestick.png";
        break;
      case 2162:
        path += "candlestick.png";
        break;
      case 2163:
        path += "candle.png";
        break;
      case 2164:
        path += "lords_day_candle.png";
        break;
      case 2165:
        path += "lords_day_papers.png";
        break;
      case 2166:
        path += "wooden_horse.png";
        break;
      // Melee Weapons
      case 2201:
        path += "foam_sword.png";
        break;
      case 2202:
        path += "pan.png";
        break;
      case 2203:
        path += "knife.png";
        break;
      case 2204:
        path += "decoy.png";
        break;
      case 2205:
        path += "wooden_sword.png";
        break;
      case 2206:
        path += "talc_sword.png";
        break;
      case 2207:
        path += "wooden_spear.png";
        break;
      case 2208:
        path += "talc_spear.png";
        break;
      case 2211:
        path += "the_thing.png";
        break;
      case 2212:
        path += "gypsum_sword.png";
        break;
      case 2213:
        path += "gypsum_spear.png";
        break;
      case 2214:
        path += "board_with_nails.png";
        break;
      case 2221:
        path += "calcite_sword.png";
        break;
      case 2222:
        path += "calcite_spear.png";
        break;
      case 2223:
        path += "metal_pipe.png";
        break;
      case 2231:
        path += "fluorite_sword.png";
        break;
      case 2232:
        path += "fluorite_spear.png";
        break;
      case 2241:
        path += "apatite_sword.png";
        break;
      case 2242:
        path += "apatite_spear.png";
        break;
      case 2251:
        path += "orthoclase_sword.png";
        break;
      case 2252:
        path += "orthoclase_spear.png";
        break;
      case 2261:
        path += "quartz_sword.png";
        break;
      case 2262:
        path += "quartz_spear.png";
        break;
      case 2271:
        path += "topaz_sword.png";
        break;
      case 2272:
        path += "topaz_spear.png";
        break;
      case 2281:
        path += "corundum_sword.png";
        break;
      case 2282:
        path += "corundum_spear.png";
        break;
      case 2291:
        path += "diamond_sword.png";
        break;
      case 2292:
        path += "diamond_spear.png";
        break;
      // Ranged Weapons
      case 2301:
        if (this.ammo > 0) {
          path += "slingshot_loaded.png";
        }
        else {
          path += "slingshot_unloaded.png";
        }
        break;
      case 2311:
        if (this.ammo > 0) {
          path += "recurve_bow_loaded.png";
        }
        else {
          path += "recurve_bow_unloaded.png";
        }
        break;
      case 2312:
        path += "m1911.png";
        break;
      case 2321:
        path += "war_machine.png";
        break;
      case 2322:
        path += "five_seven.png";
        break;
      case 2323:
        path += "type25.png";
        break;
      case 2331:
        path += "mustang_and_sally.png";
        break;
      case 2332:
        path += "fal.png";
        break;
      case 2333:
        path += "python.png";
        break;
      case 2341:
        path += "rpg.png";
        break;
      case 2342:
        path += "dystopic_demolisher.png";
        break;
      case 2343:
        path += "ultra.png";
        break;
      case 2344:
        path += "strain25.png";
        break;
      case 2345:
        path += "executioner.png";
        break;
      case 2351:
        path += "galil.png";
        break;
      case 2352:
        path += "wn.png";
        break;
      case 2353:
        if (this.ammo > 0) {
          path += "ballistic_knife_loaded.png";
        }
        else {
          path += "ballistic_knife.png";
        }
        break;
      case 2354:
        path += "cobra.png";
        break;
      case 2355:
        path += "mtar.png";
        break;
      case 2361:
        path += "rpd.png";
        break;
      case 2362:
        path += "rocket_propelled_grievance.png";
        break;
      case 2363:
        path += "dsr-50.png";
        break;
      case 2364:
        path += "voice_of_justice.png";
        break;
      case 2371:
        path += "hamr.png";
        break;
      case 2372:
        path += "ray_gun.png";
        break;
      case 2373:
        path += "lamentation.png";
        break;
      case 2374:
        path += "the_krauss_refibrillator.png";
        break;
      case 2375:
        path += "malevolent_taxonomic_anodized_redeemer.png";
        break;
      case 2381:
        path += "relativistic_punishment_device.png";
        break;
      case 2382:
        path += "dead_specimen_reactor_5000.png";
        break;
      case 2391:
        path += "sldg_hamr.png";
        break;
      case 2392:
        path += "porters_x2_ray_gun.png";
        break;
      // Headgear
      case 2401:
        path += "talc_helmet.png";
        break;
      case 2402:
        path += "cap.png";
        break;
      case 2403:
        path += "bowl.png";
        break;
      case 2404:
        path += "pot.png";
        break;
      case 2411:
        path += "gypsum_helmet.png";
        break;
      case 2421:
        path += "calcite_helmet.png";
        break;
      case 2431:
        path += "fluorite_helmet.png";
        break;
      case 2441:
        path += "apatite_helmet.png";
        break;
      case 2451:
        path += "orthoclase_helmet.png";
        break;
      case 2461:
        path += "quartz_helmet.png";
        break;
      case 2471:
        path += "topaz_helmet.png";
        break;
      case 2481:
        path += "corundum_helmet.png";
        break;
      case 2491:
        path += "diamond_helmet.png";
        break;
      // Chestgear
      case 2501:
        path += "talc_chestplate.png";
        break;
      case 2502:
        path += "tshirt.png";
        break;
      case 2503:
        path += "bra.png";
        break;
      case 2504:
        path += "coat.png";
        break;
      case 2511:
        path += "gypsum_chestplate.png";
        break;
      case 2512:
        path += "bens_coat.png";
        break;
      case 2513:
        path += "suit_jacket.png";
        break;
      case 2521:
        path += "calcite_chestplate.png";
        break;
      case 2531:
        path += "fluorite_chestplate.png";
        break;
      case 2541:
        path += "apatite_chestplate.png";
        break;
      case 2551:
        path += "orthoclase_chestplate.png";
        break;
      case 2561:
        path += "quartz_chestplate.png";
        break;
      case 2571:
        path += "topaz_chestplate.png";
        break;
      case 2581:
        path += "corundum_chestplate.png";
        break;
      case 2591:
        path += "diamond_chestplate.png";
        break;
      // Leggear
      case 2601:
        path += "talc_greaves.png";
        break;
      case 2602:
        path += "boxers.png";
        break;
      case 2603:
        path += "towel.png";
        break;
      case 2604:
        path += "pants.png";
        break;
      case 2611:
        path += "gypsum_greaves.png";
        break;
      case 2621:
        path += "calcite_greaves.png";
        break;
      case 2631:
        path += "fluorite_greaves.png";
        break;
      case 2641:
        path += "apatite_greaves.png";
        break;
      case 2651:
        path += "orthoclase_greaves.png";
        break;
      case 2661:
        path += "quartz_greaves.png";
        break;
      case 2671:
        path += "topaz_greaves.png";
        break;
      case 2681:
        path += "corundum_greaves.png";
        break;
      case 2691:
        path += "diamond_greaves.png";
        break;
      // Footgear
      case 2701:
        path += "talc_boots.png";
        break;
      case 2702:
        path += "socks.png";
        break;
      case 2703:
        path += "sandals.png";
        break;
      case 2704:
        path += "shoes.png";
        break;
      case 2705:
        path += "boots.png";
        break;
      case 2711:
        path += "gypsum_boots.png";
        break;
      case 2712:
        path += "sneakers.png";
        break;
      case 2713:
        path += "steel-toed_boots.png";
        break;
      case 2714:
        path += "cowboy_boots.png";
        break;
      case 2721:
        path += "calcite_boots.png";
        break;
      case 2731:
        path += "fluorite_boots.png";
        break;
      case 2741:
        path += "apatite_boots.png";
        break;
      case 2751:
        path += "orthoclase_boots.png";
        break;
      case 2761:
        path += "quartz_boots.png";
        break;
      case 2771:
        path += "topaz_boots.png";
        break;
      case 2781:
        path += "corundum_boots.png";
        break;
      case 2791:
        path += "diamond_boots.png";
        break;
      // Materials
      case 2801:
        path += "talc_ore.png";
        break;
      case 2802:
        path += "talc_crystal.png";
        break;
      case 2803:
        path += "talc_powder.png";
        break;
      case 2804:
        path += "soapstone.png";
        break;
      case 2805:
        path += "broken_glass.png";
        break;
      case 2806:
        path += "wire.png";
        break;
      case 2807:
        path += "feather.png";
        break;
      case 2808:
        path += "ashes.png";
        break;
      case 2809:
        path += "string.png";
        break;
      case 2810:
        path += "wax.png";
        break;
      case 2811:
        path += "gypsum_ore.png";
        break;
      case 2812:
        path += "gypsum_crystal.png";
        break;
      case 2813:
        path += "gypsum_powder.png";
        break;
      case 2814:
        path += "selenite_crystal.png";
        break;
      case 2815:
        path += "barbed_wire.png";
        break;
      case 2816:
        path += "wooden_plank.png";
        break;
      case 2817:
        path += "wooden_handle.png";
        break;
      case 2818:
        path += "wooden_piece.png";
        break;
      case 2821:
        path += "calcite_ore.png";
        break;
      case 2822:
        path += "calcite_crystal.png";
        break;
      case 2823:
        path += "chalk.png";
        break;
      case 2824:
        path += "iceland_spar.png";
        break;
      case 2825:
        int frame = constrain(int(floor(Constants.item_starPieceFrames * (millis() %
          Constants.item_starPieceAnimationTime) / Constants.item_starPieceAnimationTime)),
          0, Constants.item_starPieceFrames - 1);
        path += "star_piece_" + frame + ".png";
        break;
      case 2831:
        path += "fluorite_ore.png";
        break;
      case 2832:
        path += "fluorite_crystal.png";
        break;
      case 2833:
        path += "iron_ore.png";
        break;
      case 2834:
        path += "iron_chunk.png";
        break;
      case 2841:
        path += "apatite_ore.png";
        break;
      case 2842:
        path += "apatite_crystal.png";
        break;
      case 2843:
        path += "iron_handle.png";
        break;
      case 2851:
        path += "orthoclase_ore.png";
        break;
      case 2852:
        path += "orthoclase_chunk.png";
        break;
      case 2861:
        path += "quartz_ore.png";
        break;
      case 2862:
        path += "quartz_crystal.png";
        break;
      case 2863:
        path += "amethyst.png";
        break;
      case 2864:
        path += "glass.png";
        break;
      case 2871:
        path += "topaz_ore.png";
        break;
      case 2872:
        path += "topaz_chunk.png";
        break;
      case 2873:
        path += "topaz_gem.png";
        break;
      case 2881:
        path += "corundum_ore.png";
        break;
      case 2882:
        path += "corundum_chunk.png";
        break;
      case 2883:
        path += "sapphire.png";
        break;
      case 2891:
        path += "diamond_ore.png";
        break;
      case 2892:
        path += "diamond.png";
        break;
      // Other
      case 2901:
        path += "key.png";
        break;
      case 2902:
        path += "master_key.png";
        break;
      case 2903:
        path += "skeleton_key.png";
        break;
      case 2904:
        path += "small_keyring.png";
        break;
      case 2905:
        path += "large_keyring.png";
        break;
      case 2911:
        path += "pen.png";
        break;
      case 2912:
        path += "pencil.png";
        break;
      case 2913:
        path += "paper.png";
        break;
      case 2914:
        path += "document.png";
        break;
      case 2915:
        path += "stapler.png";
        break;
      case 2916:
        path += "crumpled_paper.png";
        break;
      case 2917:
        path += "eraser.png";
        break;
      case 2918:
        path += "scissors.png";
        break;
      case 2921:
        path += "backpack.png";
        break;
      case 2922:
        path += "bens_backpack.png";
        break;
      case 2923:
        path += "purse.png";
        break;
      case 2924:
        float water_percent = float(this.ammo) / this.maximumAmmo();
        if (water_percent > 0.95) {
          path += "glass_bottle_water_full.png";
        }
        else if (water_percent > 0.8) {
          path += "glass_bottle_water_85.png";
        }
        else if (water_percent > 0.65) {
          path += "glass_bottle_water_70.png";
        }
        else if (water_percent > 0.5) {
          path += "glass_bottle_water_55.png";
        }
        else if (water_percent > 0.35) {
          path += "glass_bottle_water_40.png";
        }
        else if (water_percent > 0.2) {
          path += "glass_bottle_water_25.png";
        }
        else if (water_percent > 0) {
          path += "glass_bottle_water_10.png";
        }
        else {
          path += "glass_bottle.png";
        }
        break;
      case 2925:
        path += "water_bottle.png";
        break;
      case 2926:
        path += "canteen.png";
        break;
      case 2927:
        path += "water_jug.png";
        break;
      case 2928:
        if (this.toggled) {
          path += "cigar_lit.png";
        }
        else {
          path += "cigar.png";
        }
        break;
      case 2931:
        path += "rock.png";
        break;
      case 2932:
        path += "arrow.png";
        break;
      case 2933:
        path += "pebble.png";
        break;
      case 2941:
        path += "45_acp.png";
        break;
      case 2942:
        path += "762_39mm.png";
        break;
      case 2943:
        path += "556_45mm.png";
        break;
      case 2944:
        path += "grenade.png";
        break;
      case 2945:
        path += "357_magnum.png";
        break;
      case 2946:
        path += "50_bmg.png";
        break;
      case 2947:
        path += "fn_57_28mm.png";
        break;
      case 2948:
        path += "28_gauge.png";
        break;
      case 2961:
        path += "dandelion.png";
        break;
      case 2962:
        path += "rose.png";
        break;
      case 2963:
        path += "stick.png";
        break;
      case 2964:
        path += "kindling.png";
        break;
      case 2965:
        path += "branch_maple.png";
        break;
      case 2966:
        path += "branch_unknown.png";
        break;
      case 2967:
        path += "branch_cedar.png";
        break;
      case 2968:
        path += "branch_pine.png";
        break;
      case 2969:
        path += "wooden_log.png";
        break;
      case 2971:
        path += "paintbrush.png";
        break;
      case 2972:
        path += "clamp.png";
        break;
      case 2973:
        path += "wrench.png";
        break;
      case 2974:
        path += "rope.png";
        break;
      case 2975:
        path += "hammer.png";
        break;
      case 2976:
        path += "window_breaker.png";
        break;
      case 2977:
        path += "ax.png";
        break;
      case 2978:
        path += "wire_clippers.png";
        break;
      case 2979:
        path += "saw.png";
        break;
      case 2980:
        path += "drill.png";
        break;
      case 2981:
        path += "roundsaw.png";
        break;
      case 2982:
        path += "beltsander.png";
        break;
      case 2983:
        path += "chainsaw.png";
        break;
      case 2984:
        path += "woodglue.png";
        break;
      case 2985:
        path += "nails.png";
        break;
      case 2986:
        path += "screws.png";
        break;
      case 2987:
        path += "flint_and_steel.png";
        break;
      case 2988:
        path += "lighter.png";
        break;
      case 2991:
        path += "rankins_third_ball.png";
        break;
      case 2992:
        path += "soldiers_covenant.png";
        break;
      case 2993:
        path += "jonah_plush_toy.png";
        break;
      default:
        global.errorMessage("ERROR: Item ID " + ID + " not found.");
        path += "default.png";
        break;
    }
    return global.images.getImage(path);
  }


  boolean targetable(Unit u) {
    return true;
  }


  boolean equippable(GearSlot slot) {
    switch(slot) {
      case WEAPON:
        return true;
      case HEAD:
        if (this.type.equals("Headgear")) {
          return true;
        }
        return false;
      case CHEST:
        if (this.type.equals("Chestgear")) {
          return true;
        }
        return false;
      case LEGS:
        if (this.type.equals("Leggear")) {
          return true;
        }
        return false;
      case FEET:
        if (this.type.equals("Footgear")) {
          return true;
        }
        return false;
      case OFFHAND:
        if (this.type.equals("Offhand")) {
          return true;
        }
        return false;
      case BELT_LEFT:
        if (this.type.equals("Belt")) {
          return true;
        }
        return false;
      case BELT_RIGHT:
        if (this.type.equals("Belt")) {
          return true;
        }
        return false;
      default:
        return false;
    }
  }

  float speedWhenHolding() {
    if (this.weapon()) {
      return this.speed;
    }
    switch(this.ID) {
      case 2816: // woden plank
      case 2969: // wooden log
        return this.speed;
      default:
        return 0;
    }
  }

  boolean weapon() {
    if (this.type.contains("Weapon") || this.throwable()) {
      return true;
    }
    return false;
  }

  boolean armor() {
    switch(this.type) {
      case "Headgear":
      case "Chestgear":
      case "Leggear":
      case "Footgear":
        return true;
      default:
        return false;
    }
  }

  int maxStack() {
    if (this.toggled) {
      return 1;
    }
    switch(this.ID) {
      case 2101: // crumb
      case 2102: // unknown food
      case 2103: // unknown food
      case 2104: // unknown food
      case 2105: // unknown food
      case 2106: // pickle
      case 2107: // ketchup
      case 2108: // chicken wing
      case 2109: // steak
      case 2110: // poptart
      case 2111: // donut
      case 2112: // chocolate
      case 2113: // chips
      case 2114: // cheese
      case 2115: // peanuts
      case 2116: // raw chicken
      case 2117: // cooked chicken
      case 2118: // chicken egg
      case 2119: // rotten flesh
      case 2120: // apple
      case 2121: // banana
      case 2122: // pear
      case 2123: // bread
      case 2125: // hot pocket
        return 8;
      case 2131: // water cup
      case 2132: // coke
      case 2133: // wine
      case 2134: // beer
      case 2141: // holy water
      case 2142: // golden apple
        return 4;
      case 2151: // one dollar
      case 2152: // five dollars
      case 2153: // ten dollars
      case 2154: // fifty dollars
      case 2155: // zucc bucc
      case 2156: // wad of 5s
      case 2157: // wad of 10s
      case 2158: // wad of 50s
      case 2159: // wad of zuccs
        return 100;
      case 2801: // talc ore
      case 2802: // talc crystal
      case 2803: // talc powder
      case 2804: // soapstone
      case 2805: // broken glass
      case 2806: // wire
      case 2807: // feather
      case 2811: // gypsum ore
      case 2812: // gypsum crystal
      case 2813: // gypsum powder
      case 2814: // selenite crystal
      case 2815: // barbed wire
      case 2821: // calcite ore
      case 2822: // calcite crystal
      case 2823: // chalk
      case 2824: // iceland spar
      case 2825: // star piece
      case 2831: // fluorite ore
      case 2832: // fluorite crystal
      case 2833: // iron ore
      case 2834: // iron chunk
      case 2841: // apatite ore
      case 2842: // apatite crystal
      case 2851: // orthoclase ore
      case 2852: // orthoclase chunk
      case 2853: // moonstone
      case 2861: // quartz ore
      case 2862: // quartz crystal
      case 2863: // amethyst
      case 2864: // glass
      case 2871: // topaz ore
      case 2872: // topaz chunk
      case 2873: // topaz gem
      case 2881: // corundum ore
      case 2882: // corundum chunk
      case 2883: // sapphire
      case 2891: // diamond ore
      case 2892: // diamond
        return 60;
      case 2816: // wooden plank
        return 4;
      case 2817: // wooden handle
      case 2818: // wooden piece
      case 2843: // iron handle
        return 16;
      case 2911: // pen
      case 2912: // pencil
      case 2913: // paper
      case 2914: // document
      case 2916: // crumpled paper
      case 2917: // eraser
        return 12;
      case 2931: // rock
      case 2932: // arrow
      case 2933: // pebble
        return 20;
      case 2941: // .45 ACP
      case 2942: // 7.62
      case 2943: // 5.56
      case 2945: // .357 magnum
      case 2946: // .50 BMG
      case 2947: // FN 4.7
      case 2948: // 28 gauge
        return 100;
      case 2944: // grenade
        return 4;
      case 2961: // dandelion
      case 2962: // rose
      case 2963: // stick
      case 2964: // kindling
      case 2965: // branch (maple)
      case 2966: // branch (unknown)
      case 2967: // branch (cedar)
      case 2968: // branch (pine)
        return 12;
      default:
        return 1;
    }
  }

  void addStack() {
    this.addStack(1);
  }
  void addStack(int amount) {
    this.stack += amount;
    if (this.stack <= 0) {
      this.remove = true;
    }
    if (this.stack > this.maxStack()) {
      global.errorMessage("ERROR: Stack of " + this.display_name() + " too big.");
    }
  }

  void removeStack() {
    this.removeStack(1);
  }
  void removeStack(int amount) {
    this.stack -= amount;
    if (this.stack <= 0) {
      this.remove = true;
    }
  }

  boolean usable() {
    return this.consumable() || this.reloadable() || this.money() || this.utility() || this.openable();
  }

  boolean openable() {
    return this.type.equals("Package");
  }

  boolean utility() {
    return this.type.equals("Utility");
  }

  boolean key() {
    return this.type.equals("Key");
  }

  boolean money() {
    return this.type.equals("Money");
  }

  boolean consumable() {
    return this.type.equals("Food") || this.type.equals("Drink");
  }

  void consumed() {
    this.removeStack();
  }

  boolean unlocks(int lock_code) {
    switch(this.ID) {
      case 2901: // key
        return this.ammo == lock_code;
      case 2902: // master key
        return this.ammo == lock_code / 10;
      case 2903: // skeleton key
        return this.ammo == lock_code / 100;
      case 2904: // small keyring
      case 2905: // large keyring
        for (Item i : this.inventory.items()) {
          if (i == null || i.remove) {
            continue;
          }
          if (i.unlocks(lock_code)) {
            return true;
          }
        }
        return false;
      default:
        return false;
    }
  }

  boolean reloadable() {
    if (this.type.equals("Ranged Weapon") && this.availableAmmo() < this.maximumAmmo()) {
      return true;
    }
    return false;
  }

  ArrayList<Integer> possibleAmmo() {
    ArrayList<Integer> possible_ammo = new ArrayList<Integer>();
    switch(this.ID) {
      case 2301: // Slingshot
        possible_ammo.add(2931);
        possible_ammo.add(2933);
        break;
      case 2311: // Recurve Bow
        possible_ammo.add(2932);
        break;
      case 2312: // M1911
        possible_ammo.add(2941);
        break;
      case 2321: // War Machine
        possible_ammo.add(2944);
        break;
      case 2322: // Five-Seven
        possible_ammo.add(2947);
        break;
      case 2323: // Type25
        possible_ammo.add(2943);
        break;
      case 2331: // Mustang and Sally
        possible_ammo.add(2944);
        break;
      case 2332: // FAL
        possible_ammo.add(2942);
        break;
      case 2333: // Python
        possible_ammo.add(2945);
        break;
      case 2341: // RPG
        possible_ammo.add(2944);
        break;
      case 2342: // Dystopic Demolisher
        possible_ammo.add(2944);
        break;
      case 2343: // Ultra
        possible_ammo.add(2947);
        break;
      case 2344: // Strain25
        possible_ammo.add(2943);
        break;
      case 2345: // Executioner
        possible_ammo.add(2948);
        break;
      case 2351: // Galil
        possible_ammo.add(2943);
        break;
      case 2352: // WN
        possible_ammo.add(2942);
        break;
      case 2353: // Ballistic Knife
        possible_ammo.add(2203);
        break;
      case 2354: // Cobra
        possible_ammo.add(2945);
        break;
      case 2355: // MTAR
        possible_ammo.add(2943);
        break;
      case 2361: // RPD
        possible_ammo.add(2942);
        break;
      case 2362: // Rocket-Propelled Grievance
        possible_ammo.add(2944);
        break;
      case 2363: // DSR-50
        possible_ammo.add(2946);
        break;
      case 2364: // Voice of Justice
        possible_ammo.add(2948);
        break;
      case 2371: // HAMR
        possible_ammo.add(2942);
        break;
      case 2372: // Ray Gun
        break;
      case 2373: // Lamentation
        possible_ammo.add(2942);
        break;
      case 2374: // The Krauss Refibrillator
        possible_ammo.add(2203);
        break;
      case 2375: // Malevolent Taxonomic Anodized Redeemer
        possible_ammo.add(2943);
        break;
      case 2381: // Relativistic Punishment Device
        possible_ammo.add(2942);
        break;
      case 2382: // Dead Specimen Reactor 5000
        possible_ammo.add(2946);
        break;
      case 2391: // SLDG HAMR
        possible_ammo.add(2942);
        break;
      case 2392: // Porter's X2 Ray Gun
        break;
      default:
        break;
    }
    return possible_ammo;
  }

  boolean shootable() {
    if (this.remove) {
      return false;
    }
    if (this.throwable()) {
      return true;
    }
    else if (this.type.equals("Ranged Weapon") && this.availableAmmo() > 0) {
      return true;
    }
    return false;
  }

  boolean throwable() {
    if (this.remove) {
      return false;
    }
    switch(this.ID) {
      case 2118:
      case 2924:
      case 2931:
      case 2932:
      case 2933:
      case 2944:
        return true;
      default:
        return false;
    }
  }

  boolean meleeAttackable() {
    if (!this.shootable()) {
      return true;
    }
    if (this.throwable()) {
      return true;
    }
    switch(this.ID) {
      case 2353: // Ballistic Knife
      case 2374: // The Krauss Refibrillator
        return true;
      default:
        return false;
    }
  }

  void shot() {
    this.lowerDurability();
    if (this.throwable()) {
      this.removeStack();
    }
    else {
      this.ammo--;
    }
  }

  void attacked() {
    this.lowerDurability();
  }


  boolean automatic() {
    switch(this.ID) {
      case 2323: // Type25
      case 2344: // Strain25
      case 2351: // Galil
      case 2355: // MTAR
      case 2361: // RPD
      case 2362: // Rocket-Propelled Grievance
      case 2371: // HAMR
      case 2372: // Ray Gun
      case 2373: // Lamentation
      case 2375: // MAlevolent Taxonomic Anodized Redeemer
      case 2381: // Relativistic Punishment Device
      case 2391: // SLDG HAMR
      case 2392: // Porter's X2 Ray Gun
        return true;
      default:
        return false;
    }
  }


  float shootAttack() {
    switch(this.ID) {
      case 2118: // Chicken Egg (thrown)
        return 2;
      case 2301: // Slingshot
        return 5;
      case 2311: // Recurve Bow
        return 8;
      case 2312: // M1911
        return 20;
      case 2321: // War Machine
        return 8;
      case 2322: // Five-Seven
        return 160;
      case 2323: // Type25
        return 110;
      case 2331: // Mustang and Sally
        return 1000;
      case 2332: // FAL
        return 160;
      case 2333: // Python
        return 1000;
      case 2341: // RPG
        return 600;
      case 2342: // Dystopic Demolisher
        return 600;
      case 2343: // Ultra
        return 300;
      case 2344: // Strain25
        return 160;
      case 2345: // Executioner
        return 1040;
      case 2351: // Galil
        return 150;
      case 2352: // WN
        return 240;
      case 2353: // Ballistic Knife
        return 500;
      case 2354: // Cobra
        return 1000;
      case 2355: // MTAR
        return 140;
      case 2361: // RPD
        return 140;
      case 2362: // Rocket-Propelled Grievance
        return 1200;
      case 2363: // DSR-50
        return 800;
      case 2364: // Voice of Justice
        return 4200;
      case 2371: // HAMR
        return 190;
      case 2372: // Ray Gun
        return 500;
      case 2373: // Lamentation
        return 220;
      case 2374: // The Krauss Refibrillator
        return 1000;
      case 2375: // Malevolent Taxonomic Anodized Redeemer
        return 210;
      case 2381: // Relativistic Punishment Device
        return 180;
      case 2382: // Dead Specimen Reactor 5000
        return 1000;
      case 2391: // SLDG HAMR
        return 250;
      case 2392: // Porter's X2 Ray Gun
        return 600;
      case 2924: // Glass Bottle (thrown)
        return 1;
      case 2931: // Rock (thrown)
        return 2;
      case 2932: // Arrow (thrown)
        return 2;
      case 2933: // Pebble (thrown)
        return 1;
      case 2944: // Grenade (thrown)
        return 3;
      default:
        return 0;
    }
  }

  float shootMagic() {
    switch(this.ID) {
      case 2372: // Ray Gun
        return 500;
      case 2392: // Porter's X2 Ray Gun
        return 600;
      default:
        return 0;
    }
  }

  float shootPiercing() {
    switch(this.ID) {
      case 2311: // Recurve Bow
        return 0.15;
      case 2312: // M1911
        return 0.12;
      case 2321: // War Machine
        return 0.05;
      case 2322: // Five-Seven
        return 0.1;
      case 2323: // Type25
        return 0.18;
      case 2331: // Mustang and Sally
        return 0.05;
      case 2332: // FAL
        return 0.15;
      case 2333: // Python
        return 0.15;
      case 2341: // RPG
        return 0.06;
      case 2342: // Dystopic Demolisher
        return 0.15;
      case 2343: // Ultra
        return 0.15;
      case 2344: // Strain25
        return 0.24;
      case 2345: // Executioner
        return 0.1;
      case 2351: // Galil
        return 0.16;
      case 2352: // WN
        return 0.2;
      case 2353: // Ballistic Knife
        return 0.25;
      case 2354: // Cobra
        return 0.15;
      case 2355: // MTAR
        return 0.16;
      case 2361: // RPD
        return 0.15;
      case 2362: // Rocket-Propelled Grievance
        return 0.08;
      case 2363: // DSR-50
        return 0.3;
      case 2364: // Voice of Justice
        return 0.12;
      case 2371: // HAMR
        return 0.2;
      case 2372: // Ray Gun
        return 0;
      case 2373: // Lamentation
        return 0.22;
      case 2374: // The Krauss Refibrillator
        return 0.35;
      case 2375: // Malevolent Taxonomic Anodized Redeemer
        return 0.2;
      case 2381: // Relativistic Punishment Device
        return 0.2;
      case 2382: // Dead Specimen Reactor 5000
        return 0.45;
      case 2391: // SLDG HAMR
        return 0.25;
      case 2392: // Porter's X2 Ray Gun
        return 0;
      case 2924: // Glass Bottle (thrown)
        return 0.06;
      case 2932: // Arrow (thrown)
        return 0.06;
      default:
        return 0;
    }
  }

  float shootPenetration() {
    switch(this.ID) {
      case 2372: // Ray Gun
        return 0.08;
      case 2392: // Porter's X2 Ray Gun
        return 0.12;
      default:
        return 0;
    }
  }

  float shootRange() {
    switch(this.ID) {
      case 2118: // Chicken Egg (thrown)
        return 2.5;
      case 2301: // Slingshot
        return 3.5;
      case 2311: // Recurve Bow
        return 5;
      case 2312: // M1911
        return 6;
      case 2321: // War Machine
        return 10;
      case 2322: // Five-Seven
        return 7;
      case 2323: // Type25
        return 9;
      case 2331: // Mustang and Sally
        return 12;
      case 2332: // FAL
        return 10;
      case 2333: // Python
        return 7;
      case 2341: // RPG
        return 10;
      case 2342: // Dystopic Demolisher
        return 12;
      case 2343: // Ultra
        return 8;
      case 2344: // Strain25
        return 10;
      case 2345: // Executioner
        return 4;
      case 2351: // Galil
        return 10;
      case 2352: // WN
        return 11;
      case 2353: // Ballistic Knife
        return 7;
      case 2354: // Cobra
        return 7;
      case 2355: // MTAR
        return 11;
      case 2361: // RPD
        return 11;
      case 2362: // Rocket-Propelled Grievance
        return 12;
      case 2363: // DSR-50
        return 16;
      case 2364: // Voice of Justice
        return 5;
      case 2371: // HAMR
        return 10;
      case 2372: // Ray Gun
        return 9;
      case 2373: // Lamentation
        return 11;
      case 2374: // The Krauss Refibrillator
        return 8;
      case 2375: // Malevolent Taxonomic Anodized Redeemer
        return 12;
      case 2381: // Relativistic Punishment Device
        return 12;
      case 2382: // Dead Specimen Reactor 5000
        return 18;
      case 2391: // SLDG HAMR
        return 11;
      case 2392: // Porter's X2 Ray Gun
        return 9;
      case 2924: // Glass Bottle (thrown)
        return 3;
      case 2931: // Rock (thrown)
        return 3;
      case 2932: // Arrow (thrown)
        return 2.5;
      case 2933: // Pebble (thrown)
        return 2.5;
      case 2944: // Grenade (thrown)
        return 3.5;
      default:
        return 0;
    }
  }

  float shootCooldown() {
    float ammo_ratio = 0;
    switch(this.ID) {
      case 2301: // Slingshot
        return 1300;
      case 2311: // Recurve Bow
        return 1500;
      case 2312: // M1911
        return 96;
      case 2321: // War Machine
        return 250;
      case 2322: // Five-Seven
        return 80;
      case 2323: // Type25
        return 64;
      case 2331: // Mustang and Sally
        return 200;
      case 2332: // FAL
        return 112;
      case 2333: // Python
        return 96;
      case 2341: // RPG
        return 320;
      case 2342: // Dystopic Demolisher
        return 250;
      case 2343: // Ultra
        return 80;
      case 2344: // Strain25
        return 64;
      case 2345: // Executioner
        return 128;
      case 2351: // Galil
        return 80;
      case 2352: // WN
        return 112;
      case 2353: // Ballistic Knife
        return 200;
      case 2354: // Cobra
        return 96;
      case 2355: // MTAR
        return 80;
      case 2361: // RPD
        return 80;
      case 2362: // Rocket-Propelled Grievance
        return 320;
      case 2363: // DSR-50
        return 1200;
      case 2364: // Voice of Justice
        return 128;
      case 2371: // HAMR
        ammo_ratio = float(this.ammo) / this.maximumAmmo();
        return 200 - 120 * ammo_ratio;
      case 2372: // Ray Gun
        return 331;
      case 2373: // Lamentation
        return 80;
      case 2374: // The Krauss Refibrillator
        return 200;
      case 2375: // Malevolent Taxonomic Anodized Redeemer
        return 80;
      case 2381: // Relativistic Punishment Device
        return 80;
      case 2382: // Dead Specimen Reactor 5000
        return 1200;
      case 2391: // SLDG HAMR
        ammo_ratio = float(this.ammo) / this.maximumAmmo();
        return 200 - 120 * ammo_ratio;
      case 2392: // Porter's X2 Ray Gun
        return 331;
      default:
        return 300;
    }
  }

  float shootTime() {
    float ammo_ratio = 0;
    switch(this.ID) {
      case 2301: // Slingshot
        return 350;
      case 2311: // Recurve Bow
        return 300;
      case 2312: // M1911
        return 10;
      case 2321: // War Machine
        return 25;
      case 2322: // Five-Seven
        return 8;
      case 2323: // Type25
        return 6;
      case 2331: // Mustang and Sally
        return 20;
      case 2332: // FAL
        return 11;
      case 2333: // Python
        return 10;
      case 2341: // RPG
        return 32;
      case 2342: // Dystopic Demolisher
        return 25;
      case 2343: // Ultra
        return 8;
      case 2344: // Strain25
        return 6;
      case 2345: // Executioner
        return 13;
      case 2351: // Galil
        return 8;
      case 2352: // WN
        return 11;
      case 2353: // Ballistic Knife
        return 5;
      case 2354: // Cobra
        return 10;
      case 2355: // MTAR
        return 8;
      case 2361: // RPD
        return 8;
      case 2362: // Rocket-Propelled Grievance
        return 32;
      case 2363: // DSR-50
        return 120;
      case 2364: // Voice of Justice
        return 13;
      case 2371: // HAMR
        ammo_ratio = float(this.ammo) / this.maximumAmmo();
        return 20 - 12 * ammo_ratio;
      case 2372: // Ray Gun
        return 33;
      case 2373: // Lamentation
        return 8;
      case 2374: // The Krauss Refibrillator
        return 5;
      case 2375: // Malevolent Taxonomic Anodized Redeemer
        return 8;
      case 2381: // Relativistic Punishment Device
        return 8;
      case 2382: // Dead Specimen Reactor 5000
        return 120;
      case 2391: // SLDG HAMR
        ammo_ratio = float(this.ammo) / this.maximumAmmo();
        return 20 - 12 * ammo_ratio;
      case 2392: // Porter's X2 Ray Gun
        return 33;
      default:
        return 60;
    }
  }

  float shootRecoil() {
    switch(this.ID) {
      case 2312: // M1911
        return 0.005;
      case 2321: // War Machine
        return 0.1;
      case 2322: // Five-Seven
        return 0.002;
      case 2323: // Type25
        return 0.02;
      case 2331: // Mustang and Sally
        return 0.08;
      case 2332: // FAL
        return 0.02;
      case 2333: // Python
        return 0.015;
      case 2341: // RPG
        return 0.12;
      case 2342: // Dystopic Demolisher
        return 0.1;
      case 2343: // Ultra
        return 0.002;
      case 2344: // Strain25
        return 0.015;
      case 2345: // Executioner
        return 0.02;
      case 2351: // Galil
        return 0.01;
      case 2352: // WN
        return 0.02;
      case 2353: // Ballistic Knife
        return 0;
      case 2354: // Cobra
        return 0.015;
      case 2355: // MTAR
        return 0.015;
      case 2361: // RPD
        return 0.02;
      case 2362: // Rocket-Propelled Grievance
        return 0.12;
      case 2363: // DSR-50
        return 0.25;
      case 2364: // Voice of Justice
        return 0.02;
      case 2371: // HAMR
        return 0.02;
      case 2372: // Ray Gun
        return 0;
      case 2373: // Lamentation
        return 0.01;
      case 2374: // The Krauss Refibrillator
        return 0;
      case 2375: // Malevolent Taxonomic Anodized Redeemer
        return 0.015;
      case 2381: // Relativistic Punishment Device
        return 0.02;
      case 2382: // Dead Specimen Reactor 5000
        return 0.2;
      case 2391: // SLDG HAMR
        return 0.02;
      case 2392: // Porter's X2 Ray Gun
        return 0;
      default:
        return 0;
    }
  }

  float shootInaccuracy() {
    float ammo_ratio = 0;
    switch(this.ID) {
      case 2118: // Chicken Egg (thrown)
        return 0.1;
      case 2301: // Slingshot
        return 0.12;
      case 2311: // Recurve Bow
        return 0.12;
      case 2312: // M1911
        return 0.12;
      case 2321: // War Machine
        return 0.05;
      case 2322: // Five-Seven
        return 0.08;
      case 2323: // Type25
        return 0.15;
      case 2331: // Mustang and Sally
        return 0.08;
      case 2332: // FAL
        return 0.1;
      case 2333: // Python
        return 0.08;
      case 2341: // RPG
        return 0.08;
      case 2342: // Dystopic Demolisher
        return 0.05;
      case 2343: // Ultra
        return 0.06;
      case 2344: // Strain25
        return 0.1;
      case 2345: // Executioner
        return 0.05;
      case 2351: // Galil
        return 0.06;
      case 2352: // WN
        return 0.08;
      case 2353: // Ballistic Knife
        return 0.05;
      case 2354: // Cobra
        return 0.07;
      case 2355: // MTAR
        return 0.08;
      case 2361: // RPD
        return 0.1;
      case 2362: // Rocket-Propelled Grievance
        return 0.08;
      case 2363: // DSR-50
        return 0.04;
      case 2364: // Voice of Justice
        return 0.05;
      case 2371: // HAMR
        ammo_ratio = float(this.ammo) / this.maximumAmmo();
        return 0.05 + 0.1 * ammo_ratio;
      case 2372: // Ray Gun
        return 0.05;
      case 2373: // Lamentation
        return 0.06;
      case 2374: // The Krauss Refibrillator
        return 0.03;
      case 2375: // Malevolent Taxonomic Anodized Redeemer
        return 0.08;
      case 2381: // Relativistic Punishment Device
        return 0.08;
      case 2382: // Dead Specimen Reactor 5000
        return 0.02;
      case 2391: // SLDG HAMR
        ammo_ratio = float(this.ammo) / this.maximumAmmo();
        return 0.05 + 0.1 * ammo_ratio;
      case 2392: // Porter's X2 Ray Gun
        return 0.05;
      case 2924: // Glass Bottle
        return 0.15;
      case 2931: // Rock (throw)
        return 0.1;
      case 2932: // Arrow (throw)
        return 0.15;
      case 2933: // Pebble (throw)
        return 0.1;
      case 2944: // Grenade (throw)
        return 0.1;
      default:
        return 0;
    }
  }


  void lowerDurability() {
    this.lowerDurability(1);
  }
  void lowerDurability(int amount) {
    this.durability -= amount;
    if (this.durability < 1) {
      this.remove = true;
    }
  }
  boolean breakable() { // if item uses durability
    if (this.ID > 2200 && this.ID < 2801) {
      return true;
    }
    return false;
  }


  void changeAmmo(int amount) {
    this.ammo += amount;
    if (this.ammo < 0) {
      this.ammo = 0;
    }
    if (this.ammo > this.maximumAmmo()) {
      this.ammo = this.maximumAmmo();
    }
  }
  int availableAmmo() {
    return this.ammo;
  }
  int maximumAmmo() {
    switch(this.ID) {
      case 2301: // Slingshot
        return 1;
      case 2311: // Recurve Bow
        return 1;
      case 2312: // M1911
        return 8;
      case 2321: // War Machine
        return 6;
      case 2322: // Five-Seven
        return 20;
      case 2323: // Type25
        return 30;
      case 2331: // Mustang and Sally
        return 6;
      case 2332: // FAL
        return 20;
      case 2333: // Python
        return 6;
      case 2341: // RPG
        return 1;
      case 2342: // Dystopic Demolisher
        return 6;
      case 2343: // Ultra
        return 20;
      case 2344: // Strain25
        return 30;
      case 2345: // Executioner
        return 5;
      case 2351: // Galil
        return 35;
      case 2352: // WN
        return 30;
      case 2353: // Ballistic Knife
        return 1;
      case 2354: // Cobra
        return 12;
      case 2355: // MTAR
        return 30;
      case 2361: // RPD
        return 100;
      case 2362: // Rocket-Propelled Grievance
        return 8;
      case 2363: // DSR-50
        return 4;
      case 2364: // Voice of Justice
        return 5;
      case 2371: // HAMR
        return 125;
      case 2372: // Ray Gun
        return 20;
      case 2373: // Lamentation
        return 35;
      case 2374: // The Krauss Refibrillator
        return 1;
      case 2375: // Malevolent Taxonomic Anodized Redeemer
        return 30;
      case 2381: // Relativistic Punishment Device
        return 125;
      case 2382: // Dead Specimen Reactor 5000
        return 8;
      case 2391: // SLDG HAMR
        return 125;
      case 2392: // Porter's X2 Ray Gun
        return 40;
      case 2924: // Glass Bottle
        return 30;
      case 2925: // Water Bottle
        return 100;
      case 2926: // Canteen
        return 400;
      case 2927: // Water Jug
        return 2500;
      default:
        return 0;
    }
  }

  float useTime() {
    switch(this.ID) {
      case 2101: // crumb
      case 2102: // unknown food
      case 2103: // unknown food
      case 2104: // unknown food
      case 2105: // unknown food
      case 2106: // pickle
      case 2107: // ketchup
      case 2108: // chicken wing
      case 2109: // steak
      case 2110: // poptart
      case 2111: // donut
      case 2112: // chocolate
      case 2113: // chips
      case 2114: // cheese
      case 2115: // peanuts
      case 2116: // raw chicken
      case 2117: // cooked chicken
      case 2118: // chicken egg
      case 2119: // rotten flesh
      case 2120: // apple
      case 2121: // banana
      case 2122: // pear
      case 2123: // bread
      case 2125: // hot pocket
      case 2142: // golden apple
        return 1450;
      case 2131: // water cup
      case 2132: // coke
      case 2133: // wine
      case 2134: // beer
      case 2141: // holy water
      case 2924: // Glass Bottle
      case 2925: // Water Bottle
      case 2926: // Canteen
      case 2927: // Water Jug
        return 1800;
      case 2124: // hot pocket package
        return 1400;
      case 2301: // Slingshot
        return 800;
      case 2311: // Recurve Bow
        return 1100;
      case 2312: // M1911
        return 1000;
      case 2321: // War Machine
        return 6400;
      case 2322: // Five-Seven
      case 2343: // Ultra
        return 1100;
      case 2323: // Type25
      case 2344: // Strain25
        return 860;
      case 2331: // Mustang and Sally
        return 1850;
      case 2332: // FAL
      case 2352: // WN
        return 1300;
      case 2333: // Python
      case 2354: // Cobra
        return 2650;
      case 2341: // RPG
      case 2362: // Rocket-Propelled Grievance
        return 550;
      case 2342: // Dystopic Demolisher
        return 1950;
      case 2345: // Executioner
      case 2364: // Voice of Justice
        return 3770;
      case 2351: // Galil
      case 2373: // Lamentation
        return 1600;
      case 2353: // Ballistic Knife
      case 2374: // The Krauss Refibrillator
        return 180;
      case 2355: // MTAR
      case 2375: // Malevolent Taxonomic Anodized Redeemer
        return 1000;
      case 2361: // RPD
      case 2381: // Relativistic Punishment Device
        return 6300;
      case 2363: // DSR-50
      case 2382: // Dead Specimen Reactor 5000
        return 1950;
      case 2371: // HAMR
      case 2391: // SLDG HAMR
        return 2200;
      case 2372: // Ray Gun
      case 2392: // Porter's X2 Ray Gun
        return 2600;
      default:
        return 0;
    }
  }


  // pickup
  void pickupSound() {
    String sound_name = "items/pickup/";
    switch(this.ID) {
      case 2204: // Decoy
      case 2211: // The Thing
        sound_name += "sword";
        break;
      case 2980: // Drill
        sound_name += "drill" + randomInt(1, 3);
        break;
      case 2981: // Roundsaw
        sound_name += "roundsaw";
        break;
      case 2983: // Chainsaw
        sound_name += "chainsaw";
        break;
      default:
        sound_name += "default";
        break;
    }
    global.sounds.trigger_units(sound_name);
  }

  // equip
  void equipSound() {
    String sound_name = "player/";
    switch(this.ID) {
      case 2402: // Cap
      case 2502: // T-shirt
      case 2503: // Bra
      case 2504: // Coat
      case 2512: // Ben's Coat
      case 2513: // Suit Jacket
      case 2602: // Boxers
      case 2603: // Towel
      case 2604: // Pants
      case 2702: // Socks
      case 2703: // Sandals
      case 2704: // Shoes
      case 2705: // Boots
      case 2712: // Sneakers
        sound_name += "armor_cloth";
        break;
      default:
        sound_name += "armor_metal";
        break;
    }
    global.sounds.trigger_player(sound_name);
  }

  // melee attack
  void attackSound() {
    String sound_name = "items/melee/";
    switch(this.ID) {
      case 2203: // knife
      case 2353: // ballistic knife
      case 2374: // the krauss refibrillator
        sound_name += "knife";
        break;
      case 2204: // decoy
      case 2211: // the thing
        sound_name += "sword_swing";
        break;
      case 2206: // talc sword
      case 2212: // gypsum sword
      case 2221: // calcite sword
      case 2231: // fluorite sword
      case 2241: // apatite sword
      case 2251: // orthoclase sword
      case 2261: // quartz sword
      case 2271: // topaz sword
      case 2281: // corundum sword
      case 2291: // diamond sword
        sound_name += "sword";
        break;
      case 2208: // talc spear
      case 2213: // gypsum spear
      case 2222: // calcite spear
      case 2232: // fluorite spear
      case 2242: // apatite spear
      case 2252: // orthoclase spear
      case 2262: // quartz spear
      case 2272: // topaz spear
      case 2282: // corundum spear
      case 2292: // diamond spear
        sound_name += "spear";
        break;
      case 2977: // ax
        sound_name += "ax";
        break;
      case 2979: // saw
        sound_name += "saw";
        break;
      case 2980: // drill
        sound_name += "drill" + randomInt(1, 3);
        break;
      case 2983: // chainsaw
        sound_name += "chainsaw";
        break;
      default:
        sound_name += "default";
        break;
    }
    global.sounds.trigger_units(sound_name);
  }


  float interactionDistance() {
    switch(this.ID) {
      default:
        return Constants.item_defaultInteractionDistance;
    }
  }


  void update(int timeElapsed) {
    this.bounce.add(timeElapsed);
    if (this.disappearing) {
      this.disappear_timer -= timeElapsed;
      if (disappear_timer < 0) {
        this.remove = true;
      }
    }
    switch(this.ID) {
      case 2163: // candle
        if (this.toggled) { // lit
          this.ammo -= timeElapsed;
          if (this.ammo < 0) {
            this.toggled = false;
            //this.remove = true;
          }
        }
        break;
      case 2164: // lords day candle
        if (this.toggled) { // lit
          this.ammo -= timeElapsed;
          if (this.ammo < 0) {
            this.toggled = false;
            //this.remove = true;
          }
        }
        break;
      case 2928: // cigar
        if (this.toggled) { // lit
          this.ammo -= timeElapsed;
          if (this.ammo < 0) {
            this.remove = true;
          }
        }
        break;
      default:
        break;
    }
  }

  String fileString() {
    return this.fileString(null);
  }
  String fileString(GearSlot slot) {
    String fileString = "\nnew: Item: " + this.ID;
    fileString += this.objectFileString();
    fileString += "\ndisappearing: " + this.disappearing;
    fileString += "\ndisappear_timer: " + this.disappear_timer;
    fileString += "\nstack: " + this.stack;
    if (this.save_base_stats) {
      fileString += "\nsave_base_stats: " + this.save_base_stats;
      fileString += "\nsize: " + this.size;
      fileString += "\ncurr_health: " + this.curr_health;
      fileString += "\nhunger: " + this.hunger;
      fileString += "\nthirst: " + this.thirst;
      fileString += "\nmoney: " + this.money;
      fileString += "\nhealth: " + this.health;
      fileString += "\nattack: " + this.attack;
      fileString += "\nmagic: " + this.magic;
      fileString += "\ndefense: " + this.defense;
      fileString += "\nresistance: " + this.resistance;
      fileString += "\npiercing: " + this.piercing;
      fileString += "\npenetration: " + this.penetration;
      fileString += "\nattackRange: " + this.attackRange;
      fileString += "\nattackCooldown: " + this.attackCooldown;
      fileString += "\nattackTime: " + this.attackTime;
      fileString += "\nsight: " + this.sight;
      fileString += "\nspeed: " + this.speed;
      fileString += "\ntenacity: " + this.tenacity;
      fileString += "\nagility: " + this.agility;
      fileString += "\nlifesteal: " + this.lifesteal;
    }
    fileString += "\ndurability: " + this.durability;
    fileString += "\nammo: " + this.ammo;
    fileString += "\ntoggled: " + this.toggled;
    if (this.inventory != null) {
      fileString += this.inventory.internalFileString();
    }
    fileString += "\nend: Item";
    if (slot != null) {
      fileString += ": " + slot.slot_name();
    }
    return fileString;
  }

  void addData(String datakey, String data) {
    if (this.addObjectData(datakey, data)) {
      return;
    }
    switch(datakey) {
      case "disappearing":
        this.disappearing = toBoolean(data);
        break;
      case "disappear_timer":
        this.disappear_timer = toInt(data);
        break;
      case "stack":
        this.stack = toInt(data);
        break;
      case "size":
        this.size = toFloat(data);
        break;
      case "save_base_stats":
        this.save_base_stats = toBoolean(data);
        break;
      case "curr_health":
        this.curr_health = toFloat(data);
        break;
      case "hunger":
        this.hunger = toInt(data);
        break;
      case "thirst":
        this.thirst = toInt(data);
        break;
      case "money":
        this.money = toFloat(data);
        break;
      case "health":
        this.health = toFloat(data);
        break;
      case "attack":
        this.attack = toFloat(data);
        break;
      case "magic":
        this.magic = toFloat(data);
        break;
      case "defense":
        this.defense = toFloat(data);
        break;
      case "resistance":
        this.resistance = toFloat(data);
        break;
      case "piercing":
        this.piercing = toFloat(data);
        break;
      case "penetration":
        this.penetration = toFloat(data);
        break;
      case "attackRange":
        this.attackRange = toFloat(data);
        break;
      case "attackCooldown":
        this.attackCooldown = toFloat(data);
        break;
      case "attackTime":
        this.attackTime = toFloat(data);
        break;
      case "sight":
        this.sight = toFloat(data);
        break;
      case "speed":
        this.speed = toFloat(data);
        break;
      case "tenacity":
        this.tenacity = toFloat(data);
        break;
      case "agility":
        this.agility = toInt(data);
        break;
      case "lifesteal":
        this.lifesteal = toFloat(data);
        break;
      case "durability":
        this.durability = toInt(data);
        break;
      case "ammo":
        this.ammo = toInt(data);
        break;
      case "toggled":
        this.toggled = toBoolean(data);
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not found for Item data.");
        break;
    }
  }
}
