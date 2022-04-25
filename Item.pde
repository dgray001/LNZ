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
  }
}



class Item extends MapObject {
  protected boolean disappearing = false;
  protected int disappear_timer = 0;

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

  protected int ammo = 0; // also used for other things (like key code)

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
        break;
      case 2156:
        this.setStrings("Wad of 5s", "Money", "");
        this.tier = 2;
        this.money = 500;
        break;
      case 2157:
        this.setStrings("Wad of 10s", "Money", "");
        this.tier = 2;
        this.money = 1000;
        break;
      case 2158:
        this.setStrings("Wad of 50s", "Money", "");
        this.tier = 2;
        this.money = 5000;
        break;
      case 2159:
        this.setStrings("Wad of Zuccs", "Money", "");
        this.tier = 3;
        this.money = 10100;
        break;

      // Melee Weapons
      case 2201:
        this.setStrings("Foam Sword", "Melee Weapon", "");
        this.attack = 1;
        this.attackRange = 0.15;
        break;
      case 2202:
        this.setStrings("Pan", "Melee Weapon", "");
        this.attack = 1;
        this.attackRange = 0.02;
        break;
      case 2203:
        this.setStrings("Knife", "Melee Weapon", "");
        this.attack = 2;
        this.attackRange = 0.01;
        this.piercing = 4;
        break;
      case 2204:
        this.setStrings("Decoy", "Melee Weapon", "");
        this.attack = 3;
        this.attackRange = 0.08;
        this.piercing = 6;
        break;
      case 2211:
        this.setStrings("The Thing", "Melee Weapon", "");
        this.tier = 7;
        this.attack = 1;
        this.attackRange = 0.15;
        this.piercing = 8;
        break;
      case 2212:
        this.setStrings("Machete", "Melee Weapon", "");
        this.tier = 4;
        this.attack = 1;
        this.attackRange = 0.05;
        this.piercing = 8;
        break;
      case 2213:
        this.setStrings("Spear", "Melee Weapon", "");
        this.tier = 5;
        this.attack = 1;
        this.attackRange = 0.3;
        this.piercing = 18;
        this.speed = -0.8;
        break;

      // Ranged Weapons
      case 2301:
        this.setStrings("Slingshot", "Ranged Weapon", "");
        this.attack = 5;
        this.attackRange = 3;
        break;
      case 2311:
        this.setStrings("Bow", "Ranged Weapon", "");
        this.tier = 2;
        this.attack = 8;
        this.attackRange = 5;
        this.piercing = 15;
        break;
      case 2312:
        this.setStrings("M1911", "Ranged Weapon", "Semi-automatic with medium capacity and power. Effective at close range.");
        this.tier = 2;
        this.attack = 2;
        break;
      case 2321:
        this.setStrings("War Machine", "Ranged Weapon", "6 round semi-automatic grenade launcher.");
        this.tier = 3;
        this.attack = 3;
        this.attackRange = 0.04;
        break;
      case 2322:
        this.setStrings("Five-Seven", "Ranged Weapon", "Semi-automatic pistol. Versatile and strong overall with a large magazine.");
        this.tier = 3;
        this.attack = 2;
        break;
      case 2323:
        this.setStrings("Type25", "Ranged Weapon", "Fully automatic assault rifle. High rate of fire with moderate recoil.");
        this.tier = 3;
        this.attack = 3;
        this.attackRange = 0.04;
        break;
      case 2331:
        this.setStrings("Mustang and Sally", "Ranged Weapon", "");
        this.tier = 4;
        this.attack = 3;
        break;
      case 2332:
        this.setStrings("FAL", "Ranged Weapon", "Fully automatic assault rifle with high damage. Effective at medium to long range.");
        this.tier = 4;
        this.attack = 3;
        this.attackRange = 0.04;
        break;
      case 2333:
        this.setStrings("Python", "Ranged Weapon", "The Python .357 magnum revolver. No thank you, I have reproductive organs of my own.");
        this.tier = 4;
        this.attack = 3;
        break;
      case 2341:
        this.setStrings("RPG", "Ranged Weapon", "Free-fire shoulder mounted rocket launcher.");
        this.tier = 5;
        this.attack = 3;
        this.attackRange = 0.04;
        this.speed = -1;
        break;
      case 2342:
        this.setStrings("Dystopic Demolisher", "Ranged Weapon", "");
        this.tier = 5;
        this.attack = 3;
        this.attackRange = 0.04;
        break;
      case 2343:
        this.setStrings("Ultra", "Ranged Weapon", "");
        this.tier = 5;
        this.attack = 3;
        break;
      case 2344:
        this.setStrings("Strain25", "Ranged Weapon", "");
        this.tier = 5;
        this.attack = 3;
        this.attackRange = 0.04;
        break;
      case 2345:
        this.setStrings("Executioner", "Ranged Weapon", "Double-action revolver pistol. Fires 28 gauge shotgun shells.");
        this.tier = 5;
        this.attack = 3;
        break;
      case 2351:
        this.setStrings("Galil", "Ranged Weapon", "Fully automatic assault rifle. Effective at medium to long range.");
        this.tier = 6;
        this.attack = 3;
        this.attackRange = 0.04;
        break;
      case 2352:
        this.setStrings("WN", "Ranged Weapon", "");
        this.tier = 6;
        this.attack = 3;
        this.attackRange = 0.04;
        break;
      case 2353:
        this.setStrings("Ballistic Knife", "Ranged Weapon", "Spring-action knife launcher. Increases melee speed and can fire the blade as a projectile.");
        this.tier = 6;
        this.attack = 3;
        this.attackRange = 0.04;
        this.speed = 1;
        this.lifesteal = 0.1;
        break;
      case 2354:
        this.setStrings("Cobra", "Ranged Weapon", "");
        this.tier = 6;
        this.attack = 3;
        this.attackRange = 0.04;
        break;
      case 2355:
        this.setStrings("MTAR", "Ranged Weapon", "Fully automatic assault rifle. Versatile and strong overall.");
        this.tier = 6;
        this.attack = 3;
        this.attackRange = 0.04;
        break;
      case 2361:
        this.setStrings("RPD", "Ranged Weapon", "Fully automatic with good power and quick fire rate. Effective at medium to long range.");
        this.tier = 7;
        this.attack = 3;
        this.attackRange = 0.04;
        break;
      case 2362:
        this.setStrings("Rocket-Propelled Grievance", "Ranged Weapon", "");
        this.tier = 7;
        this.attack = 3;
        this.attackRange = 0.04;
        break;
      case 2363:
        this.setStrings("DSR-50", "Ranged Weapon", "");
        this.tier = 7;
        this.attack = 3;
        this.attackRange = 0.04;
        this.speed = -1;
        break;
      case 2364:
        this.setStrings("Voice of Justice", "Ranged Weapon", "");
        this.tier = 7;
        this.attack = 3;
        break;
      case 2371:
        this.setStrings("HAMR", "Ranged Weapon", "Fully automatic LMG. Reduces recoil during sustained fire.");
        this.tier = 8;
        this.attack = 3;
        this.attackRange = 0.04;
        break;
      case 2372:
        this.setStrings("Ray Gun", "Ranged Weapon", "It's weird, but it works.");
        this.tier = 8;
        this.attack = 3;
        this.attackRange = 0.04;
        break;
      case 2373:
        this.setStrings("Lamentation", "Ranged Weapon", "");
        this.tier = 8;
        this.attack = 3;
        this.attackRange = 0.04;
        break;
      case 2374:
        this.setStrings("The Krauss Refibrillator", "Ranged Weapon", "");
        this.tier = 8;
        this.attack = 3;
        this.attackRange = 0.04;
        this.speed = 1.5;
        this.lifesteal = 0.15;
        break;
      case 2375:
        this.setStrings("Malevolent Taxonomic Anodized Redeemer", "Ranged Weapon", "");
        this.tier = 8;
        this.attack = 3;
        this.attackRange = 0.04;
        break;
      case 2381:
        this.setStrings("Relativistic Punishment Device", "Ranged Weapon", "");
        this.tier = 9;
        this.attack = 3;
        this.attackRange = 0.04;
        break;
      case 2382:
        this.setStrings("Dead Specimen Reactor 5000", "Ranged Weapon", "");
        this.tier = 9;
        this.attack = 3;
        this.attackRange = 0.04;
        break;
      case 2391:
        this.setStrings("SLDG HAMR", "Ranged Weapon", "");
        this.tier = 10;
        this.attack = 3;
        this.attackRange = 0.04;
        break;
      case 2392:
        this.setStrings("Porter's X2 Ray Gun", "Ranged Weapon", "");
        this.tier = 10;
        this.attack = 3;
        this.attackRange = 0.04;
        break;

      // Headgear
      case 2401:
        this.setStrings("Talc Helmet", "Headgear", "");
        this.defense = 1;
        break;
      case 2402:
        this.setStrings("Cap", "Headgear", "");
        break;
      case 2403:
        this.setStrings("Bowl", "Headgear", "");
        this.defense = 1;
        break;
      case 2404:
        this.setStrings("Pot", "Headgear", "");
        this.defense = 2;
        this.speed = -0.5;
        break;
      case 2411:
        this.setStrings("Gypsum Helmet", "Headgear", "");
        this.tier = 2;
        this.defense = 2;
        break;
      case 2421:
        this.setStrings("Calcite Helmet", "Headgear", "");
        this.tier = 3;
        this.defense = 14;
        break;
      case 2431:
        this.setStrings("Fluorite Helmet", "Headgear", "");
        this.tier = 4;
        this.defense = 21;
        break;
      case 2441:
        this.setStrings("Apatite Helmet", "Headgear", "");
        this.tier = 5;
        this.defense = 48;
        break;
      case 2451:
        this.setStrings("Orthoclase Helmet", "Headgear", "");
        this.tier = 6;
        this.defense = 72;
        break;
      case 2461:
        this.setStrings("Quartz Helmet", "Headgear", "");
        this.tier = 7;
        this.defense = 100;
        break;
      case 2471:
        this.setStrings("Topaz Helmet", "Headgear", "");
        this.tier = 8;
        this.defense = 200;
        break;
      case 2481:
        this.setStrings("Corundum Helmet", "Headgear", "");
        this.tier = 9;
        this.defense = 400;
        break;
      case 2491:
        this.setStrings("Diamond Helmet", "Headgear", "");
        this.tier = 10;
        this.defense = 1500;
        break;

      // Chestgear
      case 2501:
        this.setStrings("Talc Chestplate", "Chestgear", "");
        this.defense = 1;
        break;
      case 2502:
        this.setStrings("T-Shirt", "Chestgear", "");
        this.attackRange = 0.04;
        break;
      case 2503:
        this.setStrings("Bra", "Chestgear", "");
        this.attackRange = 0.02;
        break;
      case 2504:
        this.setStrings("Coat", "Chestgear", "");
        this.attackRange = 0.04;
        this.defense = 1;
        break;
      case 2511:
        this.setStrings("Gypsum Chestplate", "Chestgear", "");
        this.tier = 2;
        this.defense = 2;
        break;
      case 2512:
        this.setStrings("Ben's Coat", "Chestgear", "");
        this.tier = 2;
        this.health = 3;
        this.attackRange = 0.05;
        this.defense = 2;
        break;
      case 2513:
        this.setStrings("Suit Jacket", "Chestgear", "");
        this.tier = 2;
        this.attackRange = 0.04;
        break;
      case 2521:
        this.setStrings("Calcite Chestplate", "Chestgear", "");
        this.tier = 3;
        this.defense = 14;
        break;
      case 2531:
        this.setStrings("Fluorite Chestplate", "Chestgear", "");
        this.tier = 4;
        this.defense = 21;
        break;
      case 2541:
        this.setStrings("Apatite Chestplate", "Chestgear", "");
        this.tier = 5;
        this.defense = 48;
        break;
      case 2551:
        this.setStrings("Orthoclase Chestplate", "Chestgear", "");
        this.tier = 6;
        this.defense = 72;
        break;
      case 2561:
        this.setStrings("Quartz Chestplate", "Chestgear", "");
        this.tier = 7;
        this.defense = 100;
        break;
      case 2571:
        this.setStrings("Topaz Chestplate", "Chestgear", "");
        this.tier = 8;
        this.defense = 200;
        break;
      case 2581:
        this.setStrings("Corundum Chestplate", "Chestgear", "");
        this.tier = 9;
        this.defense = 400;
        break;
      case 2591:
        this.setStrings("Diamond Chestplate", "Chestgear", "");
        this.tier = 10;
        this.defense = 1500;
        break;

      // Leggear
      case 2601:
        this.setStrings("Talc Greaves", "Leggear", "");
        this.defense = 1;
        break;
      case 2602:
        this.setStrings("Boxers", "Leggear", "");
        this.attackRange = 0.02;
        break;
      case 2603:
        this.setStrings("Towel", "Leggear", "");
        this.attackRange = 0.06;
        break;
      case 2604:
        this.setStrings("Pants", "Leggear", "");
        this.attackRange = 0.08;
        this.defense = 1;
        break;
      case 2611:
        this.setStrings("Gypsum Greaves", "Leggear", "");
        this.tier = 2;
        this.defense = 2;
        break;
      case 2622:
        this.setStrings("Calcite Greaves", "Leggear", "");
        this.tier = 3;
        this.defense = 14;
        break;
      case 2631:
        this.setStrings("Fluorite Greaves", "Leggear", "");
        this.tier = 4;
        this.defense = 21;
        break;
      case 2641:
        this.setStrings("Apatite Greaves", "Leggear", "");
        this.tier = 5;
        this.defense = 48;
        break;
      case 2651:
        this.setStrings("Orthoclase Greaves", "Leggear", "");
        this.tier = 6;
        this.defense = 72;
        break;
      case 2661:
        this.setStrings("Quartz Greaves", "Leggear", "");
        this.tier = 7;
        this.defense = 100;
        break;
      case 2671:
        this.setStrings("Topaz Greaves", "Leggear", "");
        this.tier = 8;
        this.defense = 200;
        break;
      case 2681:
        this.setStrings("Corundum Greaves", "Leggear", "");
        this.tier = 9;
        this.defense = 400;
        break;
      case 2691:
        this.setStrings("Diamond Greaves", "Leggear", "");
        this.tier = 10;
        this.defense = 1500;
        break;

      // Footgear
      case 2701:
        this.setStrings("Talc Boots", "Footgear", "");
        this.defense = 1;
        break;
      case 2702:
        this.setStrings("Socks", "Footgear", "");
        break;
      case 2703:
        this.setStrings("Sandals", "Footgear", "");
        this.speed = 1;
        break;
      case 2704:
        this.setStrings("Shoes", "Footgear", "");
        this.defense = 1;
        this.speed = 2;
        break;
      case 2705:
        this.setStrings("Boots", "Footgear", "");
        this.defense = 2;
        this.speed = 2;
        break;
      case 2711:
        this.setStrings("Gypsum Boots", "Footgear", "");
        this.tier = 2;
        this.defense = 2;
        break;
      case 2712:
        this.setStrings("Sneakers", "Footgear", "");
        this.tier = 2;
        this.defense = 1;
        this.speed = 3;
        break;
      case 2713:
        this.setStrings("Steel-Toed Boots", "Footgear", "");
        this.tier = 2;
        this.attack = 1;
        this.defense = 3;
        this.speed = 2;
        break;
      case 2714:
        this.setStrings("Cowboy Boots", "Footgear", "");
        this.tier = 2;
        this.defense = 2;
        this.speed = 3;
        break;
      case 2721:
        this.setStrings("Calcite Boots", "Footgear", "");
        this.tier = 3;
        this.defense = 14;
        break;
      case 2731:
        this.setStrings("Fluorite Boots", "Footgear", "");
        this.tier = 4;
        this.defense = 21;
        break;
      case 2741:
        this.setStrings("Apatite Boots", "Footgear", "");
        this.tier = 5;
        this.defense = 48;
        break;
      case 2751:
        this.setStrings("Orthoclase Boots", "Footgear", "");
        this.tier = 6;
        this.defense = 72;
        break;
      case 2761:
        this.setStrings("Quartz Boots", "Footgear", "");
        this.tier = 7;
        this.defense = 100;
        break;
      case 2771:
        this.setStrings("Topaz Boots", "Footgear", "");
        this.tier = 8;
        this.defense = 200;
        break;
      case 2781:
        this.setStrings("Corundum Boots", "Footgear", "");
        this.tier = 9;
        this.defense = 400;
        break;
      case 2791:
        this.setStrings("Diamond Boots", "Footgear", "");
        this.tier = 10;
        this.defense = 1500;
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
      case 2841:
        this.setStrings("Apatite Ore", "Material", "");
        this.tier = 5;
        break;
      case 2842:
        this.setStrings("Apatite Crystal", "Material", "");
        this.tier = 5;
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
      case 2921:
        this.setStrings("Backpack", "Utility", "");
        this.attackRange = 0.04;
        break;
      case 2922:
        this.setStrings("Ben's Backpack", "Utility", "");
        this.tier = 2;
        this.attackRange = 0.04;
        break;
      case 2923:
        this.setStrings("Purse", "Utility", "");
        this.attackRange = 0.04;
        break;
      case 2924:
        this.setStrings("Glass Bottle", "Utility", "");
        this.attack = 1;
        this.piercing = 6;
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
      case 2931:
        this.setStrings("Rock", "Ammo", "");
        this.attack = 1;
        break;
      case 2932:
        this.setStrings("Arrow", "Ammo", "");
        this.attack = 1;
        this.piercing = 5;
        break;
      case 2933:
        this.setStrings("Pebble", "Ammo", "");
        break;
      case 2941:
        this.setStrings(".45 ACP", "Ammo", "");
        break;
      case 2942:
        this.setStrings("7.62x39mm", "Ammo", "");
        this.tier = 2;
        break;
      case 2943:
        this.setStrings("5.56x45mm", "Ammo", "");
        this.tier = 2;
        break;
      case 2944:
        this.setStrings("Grenade", "Ammo", "");
        this.tier = 2;
        this.attack = 2;
        break;
      case 2945:
        this.setStrings(".357 Magnum", "Ammo", "");
        this.tier = 2;
        break;
      case 2946:
        this.setStrings(".50 BMG", "Ammo", "");
        this.tier = 2;
        break;
      case 2947:
        this.setStrings("FN 5.7x28mm", "Ammo", "");
        this.tier = 2;
        break;
      case 2948:
        this.setStrings("28 Gauge", "Ammo", "");
        this.tier = 2;
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
        break;
      case 2978:
        this.setStrings("Wire Clippers", "Tool", "");
        this.tier = 3;
        this.attack = 2;
        this.attackRange = 0.1;
        break;
      case 2979:
        this.setStrings("Saw", "Tool", "");
        this.tier = 3;
        this.attack = 2;
        this.attackRange = 0.05;
        this.piercing = 0.05;
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
        break;
      case 2982:
        this.setStrings("Beltsander", "Tool", "");
        this.tier = 4;
        this.attack = 1;
        break;
      case 2983:
        this.setStrings("Chainsaw", "Tool", "");
        this.tier = 5;
        this.attack = 5;
        this.attackRange = 0.07;
        this.piercing = 0.2;
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
      case 2901: // key
        return this.display_name + " (" + this.ammo + ")";
      case 2902: // master key
        return this.display_name + " (" + this.ammo * 10 + " - " + int(this.ammo * 10 + 9) + ")";
      case 2903: // skeleton key
        return this.display_name + " (" + this.ammo * 100 + " - " + int(this.ammo * 100 + 99) + ")";
      default:
        return this.display_name;
    }
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
      case 2211:
        path += "the_thing.png";
        break;
      case 2212:
        path += "machete.png";
        break;
      case 2213:
        path += "spear.png";
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
      case 2841:
        path += "apatite_ore.png";
        break;
      case 2842:
        path += "apatite_crystal.png";
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
      default:
        global.errorMessage("ERROR: Item ID " + ID + " not found.");
        path += "default.png";
        break;
    }
    return global.images.getImage(path);
  }


  boolean targetable(Unit u) {
    if (this.tier > u.tier()) {
      return false;
    }
    return true;
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

  boolean stackable() {
    switch(this.ID) {
      default:
        return false;
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
    return this.consumable() || this.reloadable() || this.money() || this.utility();
  }

  boolean utility() {
    return this.type.equals("Utility");
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
      case 2301:
        possible_ammo.add(2931);
        possible_ammo.add(2933);
        break;
      case 2311:
        possible_ammo.add(2932);
        break;
      case 2312:
        possible_ammo.add(2941);
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

  void shot() {
    if (this.throwable()) {
      this.removeStack();
    }
    else {
      this.ammo--;
    }
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
        return 96;
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
        return 96;
      case 2392: // Porter's X2 Ray Gun
        return 331;
      default:
        return 300;
    }
  }

  float shootTime() {
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
        return 10;
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
        return 10;
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
        return 0.1;
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
        return 0.08;
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
      case 2101:
        return 900;
      case 2301:
        return 1000;
      case 2311:
        return 1500;
      case 2312:
        return 1700;
      default:
        return 0;
    }
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
    fileString += "\nammo: " + this.ammo;
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
        this.size = toInt(data);
        break;
      case "size":
        this.size = toFloat(data);
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
      case "ammo":
        this.ammo = toInt(data);
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not found for Item data.");
        break;
    }
  }
}
