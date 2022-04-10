enum UnitAction {
  NONE, MOVING, TARGETING_FEATURE, TARGETING_UNIT, TARGETING_ITEM, ATTACKING,
  SHOOTING, AIMING, USING_ITEM, FEATURE_INTERACTION, HERO_INTERACTING_WITH_FEATURE;
}


enum MoveModifier {
  NONE, SNEAK, RECOIL;
}


enum DamageType {
  PHYSICAL, MAGICAL, MIXED, TRUE;
}


enum GearSlot {
  ERROR("Error"), WEAPON("Weapon"), HEAD("Head"), CHEST("Chest"), LEGS("Legs"),
    FEET("Feet"), OFFHAND("Offhand"), BELT_LEFT("Belt (left)"), BELT_RIGHT(
    "Belt (right)"), HAND_THIRD("Third Hand"), HAND_FOURTH("Fourth Hand"),
    FEET_SECOND("Feet (second pair)"), FEET_THIRD("Feet (third pair)");

  private static final List<GearSlot> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  private String slot_name;
  private GearSlot(String slot_name) {
    this.slot_name = slot_name;
  }
  public String slot_name() {
    return this.slot_name;
  }
  public static String slot_name(GearSlot slot) {
    return slot.slot_name();
  }

  public static GearSlot gearSlot(String slot_name) {
    for (GearSlot slot : GearSlot.VALUES) {
      if (slot == GearSlot.ERROR) {
        continue;
      }
      if (slot.slot_name().equals(slot_name)) {
        return slot;
      }
    }
    return GearSlot.ERROR;
  }
}


enum Element {
  GRAY("Gray"), BLUE("Blue"), RED("Red"), CYAN("Cyan"), ORANGE("Orange"),
    BROWN("Brown"), PURPLE("Purple"), YELLOW("Yellow"), MAGENTA("Magenta");

  private static final List<Element> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  private String element_name;
  private Element(String element_name) {
    this.element_name = element_name;
  }
  public String element_name() {
    return this.element_name;
  }
  public static String element_name(Element element) {
    return element.element_name();
  }

  public static Element element(String element_name) {
    for (Element element : Element.VALUES) {
      if (element.element_name().equals(element_name)) {
        return element;
      }
    }
    return Element.GRAY;
  }

  public float resistanceFactorTo(Element element) {
    return Element.resistanceFactorTo(this, element);
  }
  public static float resistanceFactorTo(Element target, Element source) {
    switch(target) {
      case BLUE:
        switch(source) {
          case BLUE:
            return Constants.resistance_blue_blue;
          case RED:
            return Constants.resistance_blue_red;
          case BROWN:
            return Constants.resistance_blue_brown;
          default:
            return Constants.resistance_default;
        }
      case RED:
        switch(source) {
          case RED:
            return Constants.resistance_red_red;
          case CYAN:
            return Constants.resistance_red_cyan;
          case BLUE:
            return Constants.resistance_red_blue;
          default:
            return Constants.resistance_default;
        }
      case CYAN:
        switch(source) {
          case CYAN:
            return Constants.resistance_cyan_cyan;
          case ORANGE:
            return Constants.resistance_cyan_orange;
          case RED:
            return Constants.resistance_cyan_red;
          default:
            return Constants.resistance_default;
        }
      case ORANGE:
        switch(source) {
          case ORANGE:
            return Constants.resistance_orange_orange;
          case BROWN:
            return Constants.resistance_orange_brown;
          case CYAN:
            return Constants.resistance_orange_cyan;
          default:
            return Constants.resistance_default;
        }
      case BROWN:
        switch(source) {
          case BROWN:
            return Constants.resistance_brown_brown;
          case BLUE:
            return Constants.resistance_brown_blue;
          case ORANGE:
            return Constants.resistance_brown_orange;
          default:
            return Constants.resistance_default;
        }
      case PURPLE:
        switch(source) {
          case PURPLE:
            return Constants.resistance_purple_purple;
          case YELLOW:
            return Constants.resistance_purple_yellow;
          case MAGENTA:
            return Constants.resistance_purple_magenta;
          default:
            return Constants.resistance_default;
        }
      case YELLOW:
        switch(source) {
          case YELLOW:
            return Constants.resistance_yellow_yellow;
          case MAGENTA:
            return Constants.resistance_yellow_magenta;
          case PURPLE:
            return Constants.resistance_yellow_purple;
          default:
            return Constants.resistance_default;
        }
      case MAGENTA:
        switch(source) {
          case MAGENTA:
            return Constants.resistance_magenta_magenta;
          case PURPLE:
            return Constants.resistance_magenta_purple;
          case YELLOW:
            return Constants.resistance_magenta_yellow;
          default:
            return Constants.resistance_default;
        }
      default:
        return Constants.resistance_default;
    }
  }
}


enum Alliance {
  NONE("None"), BEN("Ben"), ZOMBIE("Zombie");

  private static final List<Alliance> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  private String alliance_name;
  private Alliance(String alliance_name) {
    this.alliance_name = alliance_name;
  }
  public String alliance_name() {
    return this.alliance_name;
  }
  public static String alliance_name(Alliance alliance) {
    return alliance.alliance_name();
  }

  public static Alliance alliance(String alliance_name) {
    for (Alliance alliance : Alliance.VALUES) {
      if (alliance.alliance_name().equals(alliance_name)) {
        return alliance;
      }
    }
    return Alliance.NONE;
  }
}



class EditUnitForm extends EditMapObjectForm {
  protected Unit unit;

  EditUnitForm(Unit unit) {
    super(unit);
    this.unit = unit;
    this.addField(new FloatFormField("  ", "base health", 0, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("  ", "base attack", 0, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("  ", "base magic", 0, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("  ", "base defense", 0, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("  ", "base resistance", 0, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("  ", "base piercing", 0, 1));
    this.addField(new FloatFormField("  ", "base penetration", 0, 1));
    this.addField(new FloatFormField("  ", "base attack range", 0, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("  ", "base sight", 0, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("  ", "base speed", 0, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("  ", "base tenacity", 0, 1));
    this.addField(new IntegerFormField("  ", "base agility", 0, 10));
    this.updateForm();
  }

  void updateObject() {
    this.unit.base_health = toFloat(this.fields.get(1).getValue());
    this.unit.base_attack = toFloat(this.fields.get(2).getValue());
    this.unit.base_magic = toFloat(this.fields.get(3).getValue());
    this.unit.base_defense = toFloat(this.fields.get(4).getValue());
    this.unit.base_resistance = toFloat(this.fields.get(5).getValue());
    this.unit.base_piercing = toFloat(this.fields.get(6).getValue());
    this.unit.base_penetration = toFloat(this.fields.get(7).getValue());
    this.unit.base_attackRange = toFloat(this.fields.get(8).getValue());
    this.unit.base_sight = toFloat(this.fields.get(9).getValue());
    this.unit.base_speed = toFloat(this.fields.get(10).getValue());
    this.unit.base_tenacity = toFloat(this.fields.get(11).getValue());
    this.unit.base_agility = toInt(this.fields.get(12).getValue());
  }

  void updateForm() {
    this.fields.get(1).setValueIfNotFocused(Float.toString(this.unit.base_health));
    this.fields.get(2).setValueIfNotFocused(Float.toString(this.unit.base_attack));
    this.fields.get(3).setValueIfNotFocused(Float.toString(this.unit.base_magic));
    this.fields.get(4).setValueIfNotFocused(Float.toString(this.unit.base_defense));
    this.fields.get(5).setValueIfNotFocused(Float.toString(this.unit.base_resistance));
    this.fields.get(6).setValueIfNotFocused(Float.toString(this.unit.base_piercing));
    this.fields.get(7).setValueIfNotFocused(Float.toString(this.unit.base_penetration));
    this.fields.get(8).setValueIfNotFocused(Float.toString(this.unit.base_attackRange));
    this.fields.get(9).setValueIfNotFocused(Float.toString(this.unit.base_sight));
    this.fields.get(10).setValueIfNotFocused(Float.toString(this.unit.base_speed));
    this.fields.get(11).setValueIfNotFocused(Float.toString(this.unit.base_tenacity));
    this.fields.get(12).setValueIfNotFocused(Integer.toString(this.unit.base_agility));
  }
}



class Unit extends MapObject {
  protected float size = Constants.unit_defaultSize; // radius
  protected int sizeZ = Constants.unit_defaultHeight;

  protected int level = 0;
  protected Alliance alliance = Alliance.NONE;
  protected Element element = Element.GRAY;

  protected float facingX = 1;
  protected float facingY = 0;
  protected float facingA = 0; // angle in radians

  protected HashMap<GearSlot, Item> gear = new HashMap<GearSlot, Item>();
  protected ArrayList<Ability> abilities = new ArrayList<Ability>();
  protected ConcurrentHashMap<StatusEffectCode, StatusEffect> statuses = new ConcurrentHashMap<StatusEffectCode, StatusEffect>();

  protected float base_health = 1;
  protected float base_attack = 0;
  protected float base_magic = 0;
  protected float base_defense = 0;
  protected float base_resistance = 0;
  protected float base_piercing = 0; // percentage from 0 - 1
  protected float base_penetration = 0; // percentage from 0 - 1
  protected float base_attackRange = Constants.unit_defaultBaseAttackRange;
  protected float base_attackCooldown = Constants.unit_defaultBaseAttackCooldown;
  protected float base_attackTime = Constants.unit_defaultBaseAttackTime;
  protected float base_sight = Constants.unit_defaultSight;
  protected float base_speed = 0;
  protected float base_tenacity = 0; // percentage from 0 - 1
  protected int base_agility = 1;

  protected float curr_health = 1;
  protected float timer_attackCooldown = 0;
  protected float timer_actionTime = 0;
  protected float timer_last_damage = 0;

  protected UnitAction curr_action = UnitAction.NONE;
  protected MapObject object_targeting = null;
  protected MapObject last_damage_from = null;
  protected float last_damage_amount = 0;
  protected float curr_action_x = 0;
  protected float curr_action_y = 0;
  protected float last_move_distance = 0;
  protected boolean last_move_collision = false;

  protected ArrayList<IntegerCoordinate> curr_squares_on = new ArrayList<IntegerCoordinate>(); // squares unit is on
  protected int curr_height = 0; // highest height from the squares_on

  protected int timer_ai_action = 0;

  Unit(int ID) {
    super(ID);
    switch(ID) {
      // Other
      case 1001:
        this.setStrings("Test Dummy", "", "");
        this.addStatusEffect(StatusEffectCode.UNKILLABLE);
        break;
      case 1002:
        this.setStrings("Chicken", "Gaia", "");
        this.baseStats(2, 0, 0, 0, 1.4);
        this.level = 1;
        this.sizeZ = 2;
        break;

      // Heroes
      case 1101:
        this.setStrings("Ben Nelson", "Hero", "");
        this.baseStats(4, 1, 0, 0, 2);
        this.gearSlots("Weapon", "Head", "Chest", "Legs", "Feet");
        this.alliance = Alliance.BEN;
        break;
      case 1102:
        this.setStrings("Daniel Gray", "Hero", "");
        break;
      case 1103:
        this.setStrings("John-Francis", "Hero", "");
        break;
      case 1104:
        this.setStrings("Mark Spinny", "Hero", "");
        break;
      case 1105:
        this.setStrings("Mad Dog Mattus", "Hero", "");
        break;
      case 1106:
        this.setStrings("Jeremiah", "Hero", "");
        break;

      // Zombies
      case 1201:
        this.setStrings("Broken Sick Zombie", "Zombie", "");
        this.level = 1;
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1202:
        this.setStrings("Broken Zombie", "Zombie", "");
        this.level = 2;
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1203:
        this.setStrings("Sick Zombie", "Zombie", "");
        this.level = 3;
        this.gearSlots("Weapon");
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1204:
        this.setStrings("Lazy Hungry Zombie", "Zombie", "");
        this.level = 4;
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1205:
        this.setStrings("Lazy Zombie", "Zombie", "");
        this.level = 5;
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1206:
        this.setStrings("Hungry Zombie", "Zombie", "");
        this.level = 6;
        this.gearSlots("Weapon");
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1207:
        this.setStrings("Confused Franny Zombie", "Zombie", "");
        this.level = 7;
        this.gearSlots("Weapon");
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1208:
        this.setStrings("Confused Zombie", "Zombie", "");
        this.level = 8;
        this.gearSlots("Weapon");
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1209:
        this.setStrings("Franny Zombie", "Zombie", "");
        this.level = 9;
        this.gearSlots("Weapon");
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1210:
        this.setStrings("Intellectual Zombie", "Zombie", "");
        this.level = 10;
        this.gearSlots("Weapon");
        this.alliance = Alliance.ZOMBIE;
        break;

      default:
        global.errorMessage("ERROR: Unit ID " + ID + " not found.");
        break;
    }
  }

  String display_name() {
    return this.display_name;
  }
  String type() {
    return this.type;
  }
  String description() {
    return this.description;
  }
  String selectedObjectTextboxText() {
    String text = "-- " + this.type() + " --";
    if (this.statuses.size() > 0) {
      text += "\n";
    }
    for (Map.Entry<StatusEffectCode, StatusEffect> entry : this.statuses.entrySet()) {
      text += "\n-- " + entry.getKey().code_name() + " --";
    }
    text += "\n\nHealth: " + int(ceil(this.curr_health)) + "/" + int(ceil(this.health()));
    float attack = this.attack();
    if (attack > 0) {
      text += "\nAttack: " + int(attack * 10.0) / 10.0;
    }
    float magic = this.magic();
    if (magic > 0) {
      text += "\nMagic: " + int(magic * 10.0) / 10.0;
    }
    float defense = this.defense();
    if (defense > 0) {
      text += "\nDefense: " + int(defense * 10.0) / 10.0;
    }
    float resistance = this.resistance();
    if (resistance > 0) {
      text += "\nResistance: " + int(resistance * 10.0) / 10.0;
    }
    float piercing = this.piercing();
    if (piercing > 0) {
      text += "\nPiercing: " + int(round(piercing * 100)) + "%";
    }
    float penetration = this.penetration();
    if (penetration > 0) {
      text += "\nPenetration: " + int(round(penetration * 100)) + "%";
    }
    text += "\nSpeed: " + int(this.speed() * 10.0) / 10.0;
    float tenacity = this.tenacity();
    if (tenacity > 0) {
      text += "\nTenacity: " + int(round(tenacity * 100)) + "%";
    }
    int agility = this.agility();
    if (attack > 0) {
      text += "\nAgility: " + agility;
    }
    return text + "\n\n" + this.description();
  }

  void baseStats(float health, float attack, float defense, float piercing, float speed) {
    this.base_health = health;
    this.curr_health = health;
    this.base_attack = attack;
    this.base_defense = defense;
    this.base_piercing = piercing;
    this.base_speed = speed;
  }

  void gearSlots(String ... strings) {
    for (String string : strings) {
      this.gear.put(GearSlot.gearSlot(string), null);
    }
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
    String path = "units/";
    switch(this.ID) {
      case 1001:
        path += "default.png";
        break;
      case 1002:
        path += "chicken.png";
        break;
      case 1101:
        path += "ben.png";
        break;
      case 1102:
        path += "dan.png";
        break;
      case 1103:
        path += "jf.png";
        break;
      case 1104:
        path += "spinny.png";
        break;
      case 1105:
        path += "mattus.png";
        break;
      case 1106:
        path += "patrick.png";
        break;
      case 1201:
      case 1202:
      case 1203:
      case 1204:
      case 1205:
      case 1206:
      case 1207:
      case 1208:
      case 1209:
      case 1210:
        path += "zombie1.png";
        break;
      default:
        global.errorMessage("ERROR: Unit ID " + ID + " not found.");
        path += "default.png";
        break;
    }
    return global.images.getImage(path);
  }


  boolean targetable(Unit u) {
    if (this.alliance == u.alliance) {
      return false;
    }
    return true;
  }


  Item weapon() {
    if (this.gear.containsKey(GearSlot.WEAPON)) {
      return this.gear.get(GearSlot.WEAPON);
    }
    return null;
  }

  boolean canPickup() {
    if (this.gear.containsKey(GearSlot.WEAPON) && this.weapon() == null) {
      return true;
    }
    return false;
  }

  void pickup(Item i) {
    this.gear.put(GearSlot.WEAPON, i);
  }

  boolean holding(int ... item_ids) {
    if (this.weapon() == null) {
      return false;
    }
    for (int item_id : item_ids) {
      if (this.weapon().ID == item_id) {
        return true;
      }
    }
    return false;
  }

  Item headgear() {
    if (this.gear.containsKey(GearSlot.HEAD)) {
      return this.gear.get(GearSlot.HEAD);
    }
    return null;
  }

  Item chestgear() {
    if (this.gear.containsKey(GearSlot.CHEST)) {
      return this.gear.get(GearSlot.CHEST);
    }
    return null;
  }

  Item leggear() {
    if (this.gear.containsKey(GearSlot.LEGS)) {
      return this.gear.get(GearSlot.LEGS);
    }
    return null;
  }

  Item footgear() {
    if (this.gear.containsKey(GearSlot.FEET)) {
      return this.gear.get(GearSlot.FEET);
    }
    return null;
  }


  float health() {
    float health = this.base_health;
    if (this.weapon() != null && this.weapon().weapon()) {
      health += this.weapon().health;
    }
    return health;
  }

  float attack() {
    float attack = this.base_attack;
    if (this.weapon() != null) {
      if (this.weapon().shootable()) {
        attack += this.weapon().shootAttack();
      }
      else {
        attack += this.weapon().attack;
      }
    }
    if (this.weak()) {
      attack *= Constants.status_weak_multiplier;
    }
    if (this.wilted()) {
      attack *= Constants.status_wilted_multiplier;
    }
    if (this.withered()) {
      attack *= Constants.status_withered_multiplier;
    }
    return attack;
  }

  float magic() {
    float magic = this.base_magic;
    if (this.weapon() != null) {
      if (this.weapon().shootable()) {
        magic += this.weapon().shootMagic();
      }
      else {
        magic += this.weapon().magic;
      }
    }
    if (this.weak()) {
      magic *= Constants.status_weak_multiplier;
    }
    if (this.wilted()) {
      magic *= Constants.status_wilted_multiplier;
    }
    if (this.withered()) {
      magic *= Constants.status_withered_multiplier;
    }
    return magic;
  }

  float defense() {
    float defense = this.base_defense;
    if (this.weapon() != null && this.weapon().weapon()) {
      defense += this.weapon().defense;
    }
    if (this.weak()) {
      defense *= Constants.status_weak_multiplier;
    }
    if (this.wilted()) {
      defense *= Constants.status_wilted_multiplier;
    }
    if (this.withered()) {
      defense *= Constants.status_withered_multiplier;
    }
    if (this.sick()) {
      defense *= Constants.status_sick_defenseMultiplier;
    }
    if (this.diseased()) {
      defense *= Constants.status_diseased_defenseMultiplier;
    }
    return defense;
  }

  float resistance() {
    float resistance = this.base_resistance;
    if (this.weapon() != null && this.weapon().weapon()) {
      resistance += this.weapon().resistance;
    }
    if (this.weak()) {
      resistance *= Constants.status_weak_multiplier;
    }
    if (this.wilted()) {
      resistance *= Constants.status_wilted_multiplier;
    }
    if (this.withered()) {
      resistance *= Constants.status_withered_multiplier;
    }
    if (this.sick()) {
      resistance *= Constants.status_sick_defenseMultiplier;
    }
    if (this.diseased()) {
      resistance *= Constants.status_diseased_defenseMultiplier;
    }
    return resistance;
  }

  float piercing() {
    float piercing = this.base_piercing;
    if (this.weapon() != null) {
      if (this.weapon().shootable()) {
        piercing += this.weapon().shootPiercing();
      }
      else {
        piercing += this.weapon().piercing;
      }
    }
    if (this.weak()) {
      piercing *= Constants.status_weak_multiplier;
    }
    if (this.wilted()) {
      piercing *= Constants.status_wilted_multiplier;
    }
    if (this.withered()) {
      piercing *= Constants.status_withered_multiplier;
    }
    if (piercing > 1) {
      piercing = 1;
    }
    return piercing;
  }

  float penetration() {
    float penetration = this.base_penetration;
    if (this.weapon() != null) {
      if (this.weapon().shootable()) {
        penetration += this.weapon().shootPenetration();
      }
      else {
        penetration += this.weapon().penetration;
      }
    }
    if (this.weak()) {
      penetration *= Constants.status_weak_multiplier;
    }
    if (this.wilted()) {
      penetration *= Constants.status_wilted_multiplier;
    }
    if (this.withered()) {
      penetration *= Constants.status_withered_multiplier;
    }
    if (penetration > 1) {
      penetration = 1;
    }
    return penetration;
  }

  float attackRange() {
    return this.attackRange(false);
  }
  float attackRange(boolean forceMelee) {
    float attackRange = this.base_attackRange;
    if (this.weapon() != null && this.weapon().weapon()) {
      if (!forceMelee && this.weapon().shootable()) {
        return this.weapon().shootRange();
      }
      attackRange += this.weapon().attackRange;
    }
    return attackRange;
  }

  float attackCooldown() {
    return this.attackCooldown(false);
  }
  float attackCooldown(boolean forceMelee) {
    float attackCooldown = this.base_attackCooldown;
    if (this.weapon() != null && this.weapon().weapon()) {
      if (!forceMelee && this.weapon().shootable()) {
        return this.weapon().shootCooldown();
      }
      attackCooldown += this.weapon().attackCooldown;
    }
    return attackCooldown;
  }

  float attackTime() {
    return this.attackTime(false);
  }
  float attackTime(boolean forceMelee) {
    float attackTime = this.base_attackTime;
    if (this.weapon() != null && this.weapon().weapon()) {
      if (!forceMelee && this.weapon().shootable()) {
        return this.weapon().shootTime();
      }
      attackTime += this.weapon().attackTime;
    }
    return attackTime;
  }

  float sight() {
    float sight = this.base_sight;
    if (this.weapon() != null) {
      sight += this.weapon().sight;
    }
    return sight;
  }

  float speed() {
    float speed = this.base_speed;
    if (this.weapon() != null && this.weapon().weapon()) {
      speed += this.weapon().speed;
    }
    if (this.chilled()) {
      if (this.element == Element.CYAN) {
        speed *= Constants.status_chilled_speedMultiplierCyan;
      }
      else {
        speed *= Constants.status_chilled_speedMultiplier;
      }
    }
    if (this.frozen()) {
      return 0;
    }
    return speed;
  }

  float tenacity() {
    float tenacity = this.base_tenacity;
    if (this.weapon() != null && this.weapon().weapon()) {
      tenacity += this.weapon().tenacity;
    }
    if (this.weak()) {
      tenacity *= Constants.status_weak_multiplier;
    }
    if (this.wilted()) {
      tenacity *= Constants.status_wilted_multiplier;
    }
    if (this.withered()) {
      tenacity *= Constants.status_withered_multiplier;
    }
    if (this.sick()) {
      tenacity *= Constants.status_sick_defenseMultiplier;
    }
    if (this.diseased()) {
      tenacity *= Constants.status_diseased_defenseMultiplier;
    }
    if (tenacity > 1) {
      tenacity = 1;
    }
    return tenacity;
  }

  int agility() {
    int agility = this.base_agility;
    if (this.weapon() != null && this.weapon().weapon()) {
      agility += this.weapon().agility;
    }
    return agility;
  }


  void removeStatusEffect(StatusEffectCode code) {
    this.statuses.remove(code);
  }

  void addStatusEffect(StatusEffectCode code) {
    if (this.statuses.containsKey(code)) {
      this.statuses.get(code).permanent = true;
    }
    else {
      this.statuses.put(code, new StatusEffect(code, true));
    }
  }
  void addStatusEffect(StatusEffectCode code, float timer) {
    timer *= this.element.resistanceFactorTo(code.element());
    if (this.statuses.containsKey(code)) {
      if (!this.statuses.get(code).permanent) {
        this.statuses.get(code).addTime(timer);
      }
    }
    else {
      this.statuses.put(code, new StatusEffect(code, timer));
    }
  }
  void refreshStatusEffect(StatusEffectCode code, float timer) {
    timer *= this.element.resistanceFactorTo(code.element());
    if (this.statuses.containsKey(code)) {
      if (!this.statuses.get(code).permanent) {
        this.statuses.get(code).refreshTime(timer);
      }
    }
    else {
      this.statuses.put(code, new StatusEffect(code, timer));
    }
  }

  boolean hasStatusEffect(StatusEffectCode code) {
    return this.statuses.containsKey(code);
  }
  boolean invulnerable() {
    return this.hasStatusEffect(StatusEffectCode.INVULNERABLE);
  }
  boolean unkillable() {
    return this.hasStatusEffect(StatusEffectCode.UNKILLABLE);
  }
  boolean hungry() {
    return this.hasStatusEffect(StatusEffectCode.HUNGRY);
  }
  boolean weak() {
    return this.hasStatusEffect(StatusEffectCode.WEAK);
  }
  boolean thirsty() {
    return this.hasStatusEffect(StatusEffectCode.THIRSTY);
  }
  boolean woozy() {
    return this.hasStatusEffect(StatusEffectCode.WOOZY);
  }
  boolean confused() {
    return this.hasStatusEffect(StatusEffectCode.CONFUSED);
  }
  boolean bleeding() {
    return this.hasStatusEffect(StatusEffectCode.BLEEDING);
  }
  boolean hemorrhaging() {
    return this.hasStatusEffect(StatusEffectCode.HEMORRHAGING);
  }
  boolean wilted() {
    return this.hasStatusEffect(StatusEffectCode.WILTED);
  }
  boolean withered() {
    return this.hasStatusEffect(StatusEffectCode.WITHERED);
  }
  boolean drenched() {
    return this.hasStatusEffect(StatusEffectCode.DRENCHED);
  }
  boolean drowning() {
    return this.hasStatusEffect(StatusEffectCode.DROWNING);
  }
  boolean burnt() {
    return this.hasStatusEffect(StatusEffectCode.BURNT);
  }
  boolean charred() {
    return this.hasStatusEffect(StatusEffectCode.CHARRED);
  }
  boolean chilled() {
    return this.hasStatusEffect(StatusEffectCode.CHILLED);
  }
  boolean frozen() {
    return this.hasStatusEffect(StatusEffectCode.FROZEN);
  }
  boolean sick() {
    return this.hasStatusEffect(StatusEffectCode.SICK);
  }
  boolean diseased() {
    return this.hasStatusEffect(StatusEffectCode.DISEASED);
  }
  boolean rotting() {
    return this.hasStatusEffect(StatusEffectCode.ROTTING);
  }
  boolean decayed() {
    return this.hasStatusEffect(StatusEffectCode.DECAYED);
  }
  boolean shaken() {
    return this.hasStatusEffect(StatusEffectCode.SHAKEN);
  }
  boolean fallen() {
    return this.hasStatusEffect(StatusEffectCode.FALLEN);
  }
  boolean shocked() {
    return this.hasStatusEffect(StatusEffectCode.SHOCKED);
  }
  boolean paralyzed() {
    return this.hasStatusEffect(StatusEffectCode.PARALYZED);
  }
  boolean unstable() {
    return this.hasStatusEffect(StatusEffectCode.UNSTABLE);
  }
  boolean radioactive() {
    return this.hasStatusEffect(StatusEffectCode.RADIOACTIVE);
  }
  boolean nelsonGlare() {
    return this.hasStatusEffect(StatusEffectCode.NELSON_GLARE);
  }
  boolean senselessGrit() {
    return this.hasStatusEffect(StatusEffectCode.SENSELESS_GRIT);
  }

  StatusEffectCode priorityStatusEffect() {
    return null;
  }


  void update(int timeElapsed, int myKey, GameMap map) {
    // timers
    this.update(timeElapsed);
    // fog logic for player units
    if (myKey == 0) {
      float unit_sight = this.sight();
      float inner_square_distance = Constants.inverse_root_two * unit_sight;
      for (int i = int(floor(this.x - unit_sight)) - 1; i <= int(ceil(this.x + unit_sight)); i++) {
        for (int j = int(floor(this.y - unit_sight)) - 1; j <= int(ceil(this.y + unit_sight)); j++) {
          float distanceX = abs(i + 0.5 - this.x);
          float distanceY = abs(j + 0.5 - this.y);
          if ( (distanceX < inner_square_distance && distanceY < inner_square_distance) ||
            (sqrt(distanceX * distanceX + distanceY * distanceY) < unit_sight) ) {
            try {
              if (!map.squares[i][j].explored) {
                map.exploreTerrainAndVisible(i, j);
              }
              else if (!map.squares[i][j].visible) {
                map.setTerrainVisible(true, i, j);
              }
            } catch(IndexOutOfBoundsException e) {}
          }
          else if (map.fogHandling.show_fog()) {
            try {
              map.setTerrainVisible(false, i, j);
            } catch(IndexOutOfBoundsException e) {}
          }
        }
      }
    }
    // ai logic for ai units
    else {
      this.aiLogic(timeElapsed, myKey, map);
    }
    // unit action
    switch(this.curr_action) {
      case MOVING:
        boolean collision_last_move = this.last_move_collision;
        this.face(this.curr_action_x, this.curr_action_y); // pathfinding
        this.move(timeElapsed, myKey, map, MoveModifier.NONE);
        if (this.distanceFromPoint(this.curr_action_x, this.curr_action_y)
          < this.last_move_distance) {
          this.curr_action = UnitAction.NONE;
        }
        if (this.last_move_collision) {
          if (collision_last_move) {
            this.timer_actionTime -= timeElapsed;
          }
          else {
            this.timer_actionTime = Constants.unit_moveCollisionStopActionTime;
          }
          if (this.timer_actionTime < 0) { // colliding over and over
            this.curr_action = UnitAction.NONE;
          }
        }
        break;
      case TARGETING_FEATURE:
        if (this.object_targeting == null || this.object_targeting.remove) {
          this.curr_action = UnitAction.NONE;
          break;
        }
        Feature f = (Feature)this.object_targeting;
        if (!f.targetable(this)) {
          this.curr_action = UnitAction.NONE;
          break;
        }
        this.face(f);
        if (this.distance(f) > f.interactionDistance()) {
          this.move(timeElapsed, myKey, map, MoveModifier.NONE);
          break;
        }
        if (f.onInteractionCooldown()) {
          break;
        }
        this.curr_action = UnitAction.FEATURE_INTERACTION;
        this.timer_actionTime = f.interactionTime();
        f.beginInteractionSoundEffect(map.viewX, map.viewY);
        break;
      case FEATURE_INTERACTION:
        if (this.object_targeting == null || this.object_targeting.remove) {
          this.curr_action = UnitAction.NONE;
          break;
        }
        this.timer_actionTime -= timeElapsed;
        if (this.timer_actionTime < 0) {
          this.curr_action = UnitAction.NONE; // must be before since interact() can set HERO_INTERACTING_WITH_FEATURE
          ((Feature)this.object_targeting).interact(this, map);
        }
        break;
      case HERO_INTERACTING_WITH_FEATURE:
        if (this.object_targeting == null || this.object_targeting.remove) {
          this.curr_action = UnitAction.NONE;
          break;
        }
        break;
      case TARGETING_UNIT:
        if (this.object_targeting == null || this.object_targeting.remove) {
          this.curr_action = UnitAction.NONE;
          break;
        }
        Unit u = (Unit)this.object_targeting;
        if (!u.targetable(this)) {
          this.curr_action = UnitAction.NONE;
          break;
        }
        this.face(u);
        float distance = this.distance(u);
        if (distance > this.attackRange()) {
          this.move(timeElapsed, myKey, map, MoveModifier.NONE);
        }
        else if (this.timer_attackCooldown <= 0) {
          if (this.gear.get(GearSlot.WEAPON) != null && this.gear.get(GearSlot.WEAPON).shootable()) {
            if (this.gear.get(GearSlot.WEAPON).throwable() && distance < this.attackRange(true)) {
              this.curr_action = UnitAction.ATTACKING;
              this.timer_actionTime = this.attackTime(true);
            }
            else {
              this.curr_action = UnitAction.SHOOTING;
              this.timer_actionTime = this.attackTime();
            }
          }
          else {
            this.curr_action = UnitAction.ATTACKING;
            this.timer_actionTime = this.attackTime();
          }
        }
        break;
      case AIMING:
        if (this.weapon() == null || !this.weapon().shootable()) {
          this.curr_action = UnitAction.NONE;
          break;
        }
        this.face(this.curr_action_x, this.curr_action_y);
        if (this.timer_attackCooldown <= 0) {
          this.curr_action = UnitAction.SHOOTING;
          this.timer_actionTime = this.attackTime();
        }
        break;
      case TARGETING_ITEM:
        if (this.object_targeting == null || this.object_targeting.remove) {
          this.curr_action = UnitAction.NONE;
          break;
        }
        Item i = (Item)this.object_targeting;
        if (!i.targetable(this)) {
          this.curr_action = UnitAction.NONE;
          break;
        }
        this.face(i);
        if (this.distance(i) > i.interactionDistance()) {
          this.move(timeElapsed, myKey, map, MoveModifier.NONE);
        }
        else {
          if (this.gear.containsKey(GearSlot.WEAPON)) {
            if (this.weapon() == null) {
              this.gear.put(GearSlot.WEAPON, new Item(i));
              i.remove = true;
            }
          }
          this.curr_action = UnitAction.NONE;
        }
        break;
      case ATTACKING:
        if (this.object_targeting == null || this.object_targeting.remove) {
          this.curr_action = UnitAction.NONE;
          break;
        }
        Unit unit_attacking = (Unit)this.object_targeting;
        if (this.frozen()) {
          this.curr_action = UnitAction.NONE;
          break;
        }
        else if (this.chilled()) {
          if (this.element == Element.CYAN) {
            this.timer_actionTime -= timeElapsed * Constants.status_chilled_cooldownMultiplierCyan;
          }
          else {
            this.timer_actionTime -= timeElapsed * Constants.status_chilled_cooldownMultiplier;
          }
        }
        else {
          this.timer_actionTime -= timeElapsed;
        }
        if (this.timer_actionTime < 0) {
          this.curr_action = UnitAction.TARGETING_UNIT;
          this.attack(unit_attacking);
        }
        break;
      case SHOOTING:
        if (this.weapon() == null || !this.weapon().shootable()) {
          this.curr_action = UnitAction.NONE;
          break;
        }
        if (this.object_targeting != null) {
          this.face(this.object_targeting);
        }
        this.timer_actionTime -= timeElapsed;
        if (this.timer_actionTime < 0) {
          this.shoot(myKey, map);
          if (this.weapon().shootable()) {
            if (myKey == 0 && global.holding_ctrl) {
              this.curr_action = UnitAction.AIMING;
            }
            else {
              this.curr_action = UnitAction.TARGETING_UNIT;
            }
          }
          else {
            this.curr_action = UnitAction.NONE;
          }
        }
        break;
      case USING_ITEM:
        if (this.weapon() == null || !this.weapon().usable()) {
          this.curr_action = UnitAction.NONE;
          break;
        }
        this.timer_actionTime -= timeElapsed;
        if (this.timer_actionTime < 0) {
          this.useItem(map);
          this.curr_action = UnitAction.NONE;
        }
        break;
      case NONE:
        break;
    }
    // update gear items
    for (Map.Entry<GearSlot, Item> slot : this.gear.entrySet()) {
      if (slot.getValue() != null && slot.getValue().remove) {
        this.gear.put(slot.getKey(), null);
      }
    }
    // update status timers
    Iterator status_iterator = this.statuses.entrySet().iterator();
    while(status_iterator.hasNext()) {
      Map.Entry<StatusEffectCode, StatusEffect> entry =
        (Map.Entry<StatusEffectCode, StatusEffect>)status_iterator.next();
      StatusEffect se = entry.getValue();
      if (!se.permanent) {
        se.timer_gone -= timeElapsed;
        if (se.timer_gone < 0) {
          status_iterator.remove();
          continue;
        }
      }
      switch(entry.getKey()) {
        case HUNGRY:
          se.number -= timeElapsed;
          if (se.number < 0) {
            se.number += Constants.status_hunger_tickTimer;
            this.calculateDotDamage(Constants.status_hunger_dot, false, Constants.status_hunger_damageLimit);
            if (randomChance(Constants.status_hunger_weakPercentage)) {
              this.refreshStatusEffect(StatusEffectCode.WEAK, 8000);
            }
          }
          break;
        case THIRSTY:
          se.number -= timeElapsed;
          if (se.number < 0) {
            se.number += Constants.status_thirst_tickTimer;
            this.calculateDotDamage(Constants.status_thirst_dot, false, Constants.status_thirst_damageLimit);
            if (randomChance(Constants.status_thirst_woozyPercentage)) {
              this.refreshStatusEffect(StatusEffectCode.WOOZY, 10000);
            }
            if (randomChance(Constants.status_thirst_confusedPercentage)) {
              this.refreshStatusEffect(StatusEffectCode.CONFUSED, 10000);
            }
          }
          break;
        case WOOZY:
          se.number -= timeElapsed;
          if (se.number < 0) {
            se.number += random(Constants.status_woozy_tickMaxTimer);
            this.turn(Constants.status_woozy_maxAmount - 2 * random(Constants.status_woozy_maxAmount));
            this.curr_action = UnitAction.NONE;
          }
          break;
        case CONFUSED:
          se.number -= timeElapsed;
          if (se.number < 0) {
            se.number += random(Constants.status_confused_tickMaxTimer);
            this.moveTo(this.x + Constants.status_confused_maxAmount -
              2 * random(Constants.status_confused_maxAmount), this.y +
              Constants.status_confused_maxAmount - 2 * random(Constants.status_confused_maxAmount));
          }
          break;
        case BLEEDING:
          se.number -= timeElapsed;
          if (se.number < 0) {
            se.number += Constants.status_bleed_tickTimer;
            this.calculateDotDamage(Constants.status_bleed_dot, true, Constants.status_bleed_damageLimit);
            if (randomChance(Constants.status_bleed_hemorrhagePercentage)) {
              this.refreshStatusEffect(StatusEffectCode.HEMORRHAGING, 5000);
            }
          }
          break;
        case HEMORRHAGING:
          se.number -= timeElapsed;
          if (se.number < 0) {
            se.number += Constants.status_hemorrhage_tickTimer;
            this.calculateDotDamage(Constants.status_hemorrhage_dot, true, Constants.status_hemorrhage_damageLimit);
            if (randomChance(Constants.status_hemorrhage_bleedPercentage)) {
              this.refreshStatusEffect(StatusEffectCode.BLEEDING, 5000);
            }
          }
          break;
        case DRENCHED:
          se.number -= timeElapsed;
          if (se.number < 0) {
            se.number += Constants.status_drenched_tickTimer;
            if (this.element == Element.RED) {
              this.calculateDotDamage(Constants.status_drenched_dot, true, Constants.status_drenched_damageLimit);
            }
          }
          break;
        case DROWNING:
          se.number -= timeElapsed;
          if (se.number < 0) {
            se.number += Constants.status_drowning_tickTimer;
            if (this.element == Element.BLUE) {
              this.calculateDotDamage(Constants.status_drowning_dot, true, Constants.status_drowning_damageLimitBlue);
            }
            else {
              this.calculateDotDamage(Constants.status_drowning_dot, true, Constants.status_drowning_damageLimit);
            }
            if (randomChance(Constants.status_drowning_drenchedPercentage)) {
              this.refreshStatusEffect(StatusEffectCode.DRENCHED, 5000);
            }
          }
          break;
        case BURNT:
          se.number -= timeElapsed;
          if (se.number < 0) {
            se.number += Constants.status_burnt_tickTimer;
            if (this.element == Element.RED) {
              this.calculateDotDamage(Constants.status_burnt_dot, true, Constants.status_burnt_damageLimitRed);
            }
            else {
              this.calculateDotDamage(Constants.status_burnt_dot, true, Constants.status_burnt_damageLimit);
            }
            if (randomChance(Constants.status_burnt_charredPercentage)) {
              this.refreshStatusEffect(StatusEffectCode.CHARRED, 5000);
            }
          }
          break;
        case CHARRED:
          se.number -= timeElapsed;
          if (se.number < 0) {
            se.number += Constants.status_charred_tickTimer;
            if (this.element == Element.RED) {
              this.calculateDotDamage(Constants.status_charred_dot, true, Constants.status_charred_damageLimitRed);
            }
            else {
              this.calculateDotDamage(Constants.status_charred_dot, true, Constants.status_charred_damageLimit);
            }
          }
          break;
        case FROZEN:
          se.number -= timeElapsed;
          if (se.number < 0) {
            se.number += Constants.status_frozen_tickTimer;
            if (this.element == Element.ORANGE) {
              this.calculateDotDamage(Constants.status_frozen_dot, true, Constants.status_frozen_damageLimit);
            }
          }
          break;
        case ROTTING:
          se.number -= timeElapsed;
          if (se.number < 0) {
            se.number += Constants.status_rotting_tickTimer;
            if (this.element == Element.BROWN) {
              this.calculateDotDamage(Constants.status_rotting_dot, true, Constants.status_rotting_damageLimitBrown);
            }
            else if (this.element == Element.BLUE) {
              this.calculateDotDamage(Constants.status_rotting_dot, true, Constants.status_rotting_damageLimitBlue);
            }
            else {
              this.calculateDotDamage(Constants.status_rotting_dot, true, Constants.status_rotting_damageLimit);
            }
            if (randomChance(Constants.status_rotting_decayedPercentage)) {
              this.refreshStatusEffect(StatusEffectCode.DECAYED, 5000);
            }
          }
          break;
        case DECAYED:
          se.number -= timeElapsed;
          if (se.number < 0) {
            se.number += Constants.status_decayed_tickTimer;
            if (this.element == Element.BROWN) {
              this.calculateDotDamage(Constants.status_decayed_dot, true, Constants.status_decayed_damageLimitBrown);
            }
            else {
              this.calculateDotDamage(Constants.status_decayed_dot, true, Constants.status_decayed_damageLimit);
            }
          }
          break;
        default:
          break;
      }
    }
  }

  // timers independent of curr action
  void update(int timeElapsed) {
    if (this.timer_last_damage > 0) {
      this.timer_last_damage -= timeElapsed;
    }
    if (this.timer_attackCooldown > 0) {
      if (this.frozen()) {
        this.timer_attackCooldown = this.attackCooldown();
      }
      else if (this.chilled()) {
        if (this.element == Element.CYAN) {
          this.timer_attackCooldown -= timeElapsed * Constants.status_chilled_cooldownMultiplierCyan;
        }
        else {
          this.timer_attackCooldown -= timeElapsed * Constants.status_chilled_cooldownMultiplier;
        }
      }
      else {
        this.timer_attackCooldown -= timeElapsed;
      }
    }
  }


  void useItem(GameMap map) {
    global.errorMessage("ERROR: Units cannot use Items, only Heroes can.");
  }


  void dropWeapon(GameMap map) {
    if (this.weapon() == null) {
      return;
    }
    map.addItem(new Item(this.weapon(), this.frontX(), this.frontY()));
    this.gear.put(GearSlot.WEAPON, null);
  }

  float frontX() {
    return this.x + this.facingX * this.xRadius() - 0.5 * this.facingY * this.xRadius();
  }

  float frontY() {
    return this.y + 0.5 * this.facingX * this.yRadius() + this.facingY * this.yRadius();
  }


  void target(MapObject object) {
    this.object_targeting = object;
    if (Feature.class.isInstance(this.object_targeting)) {
      this.curr_action = UnitAction.TARGETING_FEATURE;
    }
    else if (Unit.class.isInstance(this.object_targeting)) {
      this.curr_action = UnitAction.TARGETING_UNIT;
    }
    else if (Item.class.isInstance(this.object_targeting)) {
      this.curr_action = UnitAction.TARGETING_ITEM;
    }
    else {
      this.curr_action = UnitAction.NONE;
    }
  }


  // Aim at mouse
  void aim(float targetX, float targetY) {
    this.curr_action = UnitAction.AIMING;
    this.object_targeting = null;
    this.curr_action_x = targetX;
    this.curr_action_y = targetY;
  }


  // Shoot projectile
  void shoot(int myKey, GameMap map) {
    if (this.weapon() == null || !this.weapon().shootable()) {
      return;
    }
    map.addProjectile(new Projectile(this.weapon().ID + 1000, myKey, this));
    this.weapon().shot();
    this.timer_attackCooldown = this.attackCooldown();
  }


  // Auto attack
  void attack(Unit u) {
    u.damage(this, u.calculateDamageFrom(this, this.attack(), DamageType.PHYSICAL, this.element));
    this.timer_attackCooldown = this.attackCooldown(true);
  }


  float calculateDamageFrom(Unit source, float power, DamageType damageType, Element element) {
    return this.calculateDamageFrom(power, damageType, element, source.piercing(), source.penetration());
  }
  float calculateDamageFrom(float power, DamageType damageType, Element element, float piercing, float penetration) {
    float effectiveDefense = 0;
    switch(damageType) {
      case PHYSICAL:
        effectiveDefense = this.defense() * (1 - piercing);
        break;
      case MAGICAL:
        effectiveDefense = this.resistance() * (1 - penetration);
        break;
      case MIXED:
        effectiveDefense = this.defense() * (1 - piercing) + this.resistance() * (1 - penetration);
        break;
      case TRUE:
        effectiveDefense = 0;
        break;
    }
    float subtotal = max(0, power - effectiveDefense) * this.element.resistanceFactorTo(element);
    if (element == Element.BLUE && this.drenched()) {
      subtotal *= Constants.status_drenched_multiplier;
    }
    if (this.sick()) {
      subtotal *= Constants.status_sick_damageMultiplier;
    }
    if (this.diseased()) {
      subtotal *= Constants.status_diseased_damageMultiplier;
    }
    return subtotal;
  }


  void calculateDotDamage(float percent, boolean max_health) {
    this.calculateDotDamage(percent, max_health, 0);
  }
  void calculateDotDamage(float percent, boolean max_health, float damage_limit) {
    float damage = 0;
    if (max_health) {
      damage = percent * this.health();
    }
    else {
      damage = percent * this.curr_health;
    }
    if (damage < 0) {
      return;
    }
    float min_health = this.health() * damage_limit;
    if (this.curr_health - damage < min_health) {
      damage = this.curr_health - min_health;
    }
    this.damage(null, damage);
  }


  void damage(Unit source, float amount) {
    float last_health = this.curr_health;
    if (this.remove || amount <= 0) {
      return;
    }
    if (this.invulnerable()) {
      return;
    }
    this.curr_health -= amount;
    if (this.unkillable()) {
      if (this.curr_health < this.statuses.get(StatusEffectCode.UNKILLABLE).number) {
        this.curr_health = this.statuses.get(StatusEffectCode.UNKILLABLE).number;
      }
    }
    if (this.curr_health <= 0) {
      this.curr_health = 0;
      this.remove = true;
    }
    this.last_damage_from = source;
    if (source != null) {
      source.damaged(this, amount);
      if (this.remove) {
        source.killed(this);
      }
    }
    if (this.ID == 1001) {
      if (source == null) {
        this.description += "\n" + amount + " damage.";
      }
      else {
        this.description += "\n" + amount + " damage from " + source.display_name() + ".";
      }
    }
    this.timer_last_damage = Constants.unit_healthbarDamageAnimationTime;
    this.last_damage_amount = last_health - this.curr_health;
  }


  void damaged(Unit u, float damage) {
  }


  void killed(Unit u) {
  }


  void heal(float amount) {
    this.heal(amount, false);
  }
  void heal(float amount, boolean overheal) {
    this.curr_health += amount;
    if (this.curr_health <= 0) {
      this.curr_health = 0;
    }
    if (!overheal && this.curr_health > this.health()) {
      this.curr_health = this.health();
    }
  }


  void stopAction() {
    this.curr_action = UnitAction.NONE;
  }


  void turnDirection(int direction) {
    switch(direction) {
      case LEFT:
        this.turn(-HALF_PI);
        break;
      case RIGHT:
        this.turn(HALF_PI);
        break;
      default:
        global.errorMessage("ERROR: turn direction " + direction + " not recognized.");
        break;
    }
  }
  void turn(float angle_change) {
    this.turnTo(this.facingA + angle_change);
  }
  void turnTo(float facingA) {
    this.facingA = facingA;
    this.facingX = cos(this.facingA);
    this.facingY = sin(this.facingA);
  }

  void face(MapObject object) {
    this.face(object.xCenter(), object.yCenter());
  }
  void face(float faceX, float faceY) {
    this.setFacing(faceX - this.x, faceY - this.y);
  }
  void face(int direction) {
    switch(direction) {
      case UP:
        this.setFacing(0, -1);
        break;
      case DOWN:
        this.setFacing(0, 1);
        break;
      case LEFT:
        this.setFacing(-1, 0);
        break;
      case RIGHT:
        this.setFacing(1, 0);
        break;
      default:
        global.errorMessage("ERROR: face direction " + direction + " not recognized.");
        break;
    }
  }
  void setFacing(float facingX, float facingY) {
    float normConstant = sqrt(facingX * facingX + facingY * facingY);
    if (normConstant == 0) {
      global.errorMessage("ERROR: cannot set facing to 0.");
    }
    this.facingX = facingX / normConstant;
    this.facingY = facingY / normConstant;
    this.facingA = (float)Math.atan2(this.facingY, this.facingX);
  }

  float facingAngleModifier() {
    if (this.curr_action == UnitAction.ATTACKING) {
      return Constants.unit_attackAnimationAngle(1 - this.timer_actionTime / this.attackTime(true));
    }
    return 0;
  }


  void moveTo(float targetX, float targetY) {
    this.curr_action = UnitAction.MOVING;
    this.curr_action_x = targetX;
    this.curr_action_y = targetY;
  }


  void move(int timeElapsed, int myKey, GameMap map, MoveModifier modifier) {
    // calculate attempted move distances
    float seconds = timeElapsed / 1000.0;
    float effectiveDistance = 0;
    switch(modifier) {
      case NONE:
        effectiveDistance = this.speed() * seconds;
        break;
      case SNEAK:
        effectiveDistance = Constants.unit_sneakSpeed * seconds;
        break;
      case RECOIL:
        break;
    }
    float tryMoveX = effectiveDistance * this.facingX;
    float tryMoveY = effectiveDistance * this.facingY;
    float startX = this.x;
    float startY = this.y;
    this.last_move_collision = false;
    // move in x direction
    this.moveX(tryMoveX, myKey, map);
    // move in y direction
    this.moveY(tryMoveY, myKey, map);
    // calculates squares_on and height
    this.curr_squares_on = this.getSquaresOn();
    int new_height = map.maxHeightOfSquares(this.curr_squares_on, false);
    if (new_height < this.curr_height) {
      // calculate fall damage
    }
    this.curr_height = new_height;
    // move stat
    float moveX = this.x - startX;
    float moveY = this.y - startY;
    this.last_move_distance = sqrt(moveX * moveX + moveY * moveY);
    //this.stat_distance_traveled = this.last_move_distance;
  }

  void moveX(float tryMoveX, int myKey, GameMap map) {
    while(abs(tryMoveX) > Constants.map_moveLogicCap) {
      if (tryMoveX > 0) {
        if (this.collisionLogicX(Constants.map_moveLogicCap, myKey, map)) {
          this.last_move_collision = true;
          return;
        }
        tryMoveX -= Constants.map_moveLogicCap;
      }
      else {
        if (this.collisionLogicX(-Constants.map_moveLogicCap, myKey, map)) {
          this.last_move_collision = true;
          return;
        }
        tryMoveX += Constants.map_moveLogicCap;
      }
    }
    if (this.collisionLogicX(tryMoveX, myKey, map)) {
      this.last_move_collision = true;
      return;
    }
    if (abs(this.facingX) < Constants.unit_small_facing_threshhold) {
      this.last_move_collision = true;
    }
  }

  void moveY(float tryMoveY, int myKey, GameMap map) {
    while(abs(tryMoveY) > Constants.map_moveLogicCap) {
      if (tryMoveY > 0) {
        if (this.collisionLogicY(Constants.map_moveLogicCap, myKey, map)) {
          return;
        }
        tryMoveY -= Constants.map_moveLogicCap;
      }
      else {
        if (this.collisionLogicY(-Constants.map_moveLogicCap, myKey, map)) {
          return;
        }
        tryMoveY += Constants.map_moveLogicCap;
      }
    }
    if (this.collisionLogicY(tryMoveY, myKey, map)) {
      return;
    }
    if (abs(this.facingY) > Constants.unit_small_facing_threshhold) {
      this.last_move_collision = false;
    }
  }

  // returns true if collision occurs
  boolean collisionLogicX(float tryMoveX, int myKey, GameMap map) {
    float startX = this.x;
    this.x += tryMoveX;
    // map collisions
    if (!this.inMapX(map.mapWidth)) {
      this.x = startX;
      return true;
    }
    // terrain collisions
    int new_height = map.maxHeightOfSquares(this.getSquaresOn(), true);
    if (!this.canMoveUp(new_height - this.curr_height)) {
      this.x = startX;
      return true;
    }
    // unit collisions
    for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
      if (entry.getKey() == myKey) {
        continue;
      }
      Unit u = entry.getValue();
      if (u.alliance == this.alliance && this.alliance != Alliance.NONE) {
        continue;
      }
      if (this.zf() <= u.zi() || u.zf() <= this.zi()) {
        continue;
      }
      float distance_to = this.distance(u);
      if (distance_to > 0) {
        continue;
      }
      if ( (this.x > u.x && this.facingX > 0) || (this.x < u.x && this.facingX < 0) ) {
        continue;
      }
      this.x = startX;
      return true;
    }
    return false;
  }

  // returns true if collision occurs
  boolean collisionLogicY(float tryMoveY, int myKey, GameMap map) {
    float startY = this.y;
    this.y += tryMoveY;
    if (!this.inMapY(map.mapHeight)) {
      this.y = startY;
      return true;
    }
    // terrain collisions
    int new_height = map.maxHeightOfSquares(this.getSquaresOn(), true);
    if (!this.canMoveUp(new_height - this.curr_height)) {
      this.y = startY;
      return true;
    }
    // unit collisions
    for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
      if (entry.getKey() == myKey) {
        continue;
      }
      Unit u = entry.getValue();
      if (u.alliance == this.alliance && this.alliance != Alliance.NONE) {
        continue;
      }
      if (this.zf() <= u.zi() || u.zf() <= this.zi()) {
        continue;
      }
      float distance_to = this.distance(u);
      if (distance_to > 0) {
        continue;
      }
      if ( (this.y > u.y && this.facingY > 0) || (this.y < u.y && this.facingY < 0) ) {
        continue;
      }
      this.y = startY;
      return true;
    }
    return false;
  }


  int zi() {
    return this.curr_height;
  }
  int zf() {
    return this.curr_height + this.sizeZ;
  }
  int zHalf() {
    return this.curr_height + int(ceil(this.sizeZ));
  }


  boolean canMoveUp(int height_difference) {
    if (height_difference > this.agility()) {
      return false;
    }
    return true;
  }


  void aiLogic(int timeElapsed, int myKey, GameMap map) {
    switch(this.ID) {
      // chicken
      case 1002:
        if (this.curr_action == UnitAction.NONE || this.last_move_collision) {
          this.timer_ai_action -= timeElapsed;
          if (this.timer_ai_action < 0) {
            this.timer_ai_action = int(Constants.ai_chickenTimer + random(Constants.ai_chickenTimer));
            this.moveTo(this.x + Constants.ai_chickenMoveDistance - 2 * random(Constants.ai_chickenMoveDistance),
              this.curr_action_y = this.y + Constants.ai_chickenMoveDistance - 2 * random(Constants.ai_chickenMoveDistance));
          }
        }
        break;
      default:
        break;
    }
  }


  String fileString() {
    String fileString = "\nnew: Unit: " + this.ID;
    fileString += this.objectFileString();
    fileString += "\nsize: " + this.size;
    fileString += "\nlevel: " + this.level;
    fileString += "\nalliance: " + this.alliance.alliance_name();
    fileString += "\nelement: " + this.element.element_name();
    for (Map.Entry<GearSlot, Item> slot : this.gear.entrySet()) {
      fileString += "\ngearSlot: " + slot.getKey();
      if (slot.getValue() != null) {
        fileString += slot.getValue().fileString(slot.getKey());
      }
    }
    fileString += "\nfacingX: " + this.facingX;
    fileString += "\nfacingY: " + this.facingY;
    fileString += "\nbase_health: " + this.base_health;
    fileString += "\nbase_attack: " + this.base_attack;
    fileString += "\nbase_magic: " + this.base_magic;
    fileString += "\nbase_defense: " + this.base_defense;
    fileString += "\nbase_resistance: " + this.base_resistance;
    fileString += "\nbase_piercing: " + this.base_piercing;
    fileString += "\nbase_penetration: " + this.base_penetration;
    fileString += "\nbase_attackRange: " + this.base_attackRange;
    fileString += "\nbase_attackCooldown: " + this.base_attackCooldown;
    fileString += "\nbase_attackTime: " + this.base_attackTime;
    fileString += "\nbase_sight: " + this.base_sight;
    fileString += "\nbase_speed: " + this.base_speed;
    fileString += "\nbase_tenacity: " + this.base_tenacity;
    fileString += "\nbase_agility: " + this.base_agility;
    fileString += "\ncurr_health: " + this.curr_health;
    fileString += "\ntimer_attackCooldown: " + this.timer_attackCooldown;
    fileString += "\ntimer_actionTime: " + this.timer_actionTime;
    for (Map.Entry<StatusEffectCode, StatusEffect> entry : this.statuses.entrySet()) {
      fileString += "\nnext_status_code: " + entry.getKey().code_name();
      fileString += entry.getValue().fileString();
    }
    fileString += "\nend: Unit\n";
    return fileString;
  }

  void addData(String datakey, String data) {
    if (this.addObjectData(datakey, data)) {
      return;
    }
    switch(datakey) {
      case "size":
        this.size = toFloat(data);
        break;
      case "level":
        this.level = toInt(data);
        break;
      case "alliance":
        this.alliance = Alliance.alliance(data);
        break;
      case "element":
        this.element = Element.element(data);
        break;
      case "gearSlot":
        this.gear.put(GearSlot.gearSlot(data), null);
        break;
      case "facingX":
        this.facingX = toFloat(data);
        break;
      case "facingY":
        this.facingY = toFloat(data);
        break;
      case "base_health":
        this.base_health = toFloat(data);
        break;
      case "base_attack":
        this.base_attack = toFloat(data);
        break;
      case "base_magic":
        this.base_magic = toFloat(data);
        break;
      case "base_defense":
        this.base_defense = toFloat(data);
        break;
      case "base_resistance":
        this.base_resistance = toFloat(data);
        break;
      case "base_piercing":
        this.base_piercing = toFloat(data);
        break;
      case "base_penetration":
        this.base_penetration = toFloat(data);
        break;
      case "base_attackRange":
        this.base_attackRange = toFloat(data);
        break;
      case "base_attackCooldown":
        this.base_attackCooldown = toFloat(data);
        break;
      case "base_attackTime":
        this.base_attackTime = toFloat(data);
        break;
      case "base_sight":
        this.base_sight = toFloat(data);
        break;
      case "base_speed":
        this.base_speed = toFloat(data);
        break;
      case "base_tenacity":
        this.base_tenacity = toFloat(data);
        break;
      case "base_agility":
        this.base_agility = toInt(data);
        break;
      case "curr_health":
        this.curr_health = toFloat(data);
        break;
      case "timer_attackCooldown":
        this.timer_attackCooldown = toFloat(data);
        break;
      case "timer_actionTime":
        this.timer_actionTime = toFloat(data);
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not found for unit data.");
        break;
    }
  }


  int tier() {
    return 1 + int(floor(this.level / 10));
  }
}
