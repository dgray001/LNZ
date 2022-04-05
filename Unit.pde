enum UnitAction {
  NONE, MOVING, TARGETING_FEATURE, TARGETING_UNIT, TARGETING_ITEM, ATTACKING,
  SHOOTING, CONSUMING;
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
          default:
            return Constants.resistance_default;
        }
      case RED:
        switch(source) {
          case RED:
            return Constants.resistance_blue_blue;
          default:
            return Constants.resistance_default;
        }
      case CYAN:
        switch(source) {
          case CYAN:
            return Constants.resistance_blue_blue;
          default:
            return Constants.resistance_default;
        }
      case ORANGE:
        switch(source) {
          case ORANGE:
            return Constants.resistance_blue_blue;
          default:
            return Constants.resistance_default;
        }
      case BROWN:
        switch(source) {
          case BROWN:
            return Constants.resistance_blue_blue;
          default:
            return Constants.resistance_default;
        }
      case PURPLE:
        switch(source) {
          case PURPLE:
            return Constants.resistance_blue_blue;
          default:
            return Constants.resistance_default;
        }
      case YELLOW:
        switch(source) {
          case YELLOW:
            return Constants.resistance_blue_blue;
          default:
            return Constants.resistance_default;
        }
      case MAGENTA:
        switch(source) {
          case MAGENTA:
            return Constants.resistance_blue_blue;
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


enum StatusEffectCode {
  ERROR("Error");

  private static final List<StatusEffectCode> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  private String code_name;
  private StatusEffectCode(String code_name) {
    this.code_name = code_name;
  }
  public String code_name() {
    return this.code_name;
  }
  public static String code_name(StatusEffectCode code) {
    return code.code_name();
  }

  public static StatusEffectCode code(String code_name) {
    for (StatusEffectCode code : StatusEffectCode.VALUES) {
      if (code == StatusEffectCode.ERROR) {
        continue;
      }
      if (code.code_name().equals(code_name)) {
        return code;
      }
    }
    return StatusEffectCode.ERROR;
  }
}


class StatusEffect {
  private StatusEffectCode code = StatusEffectCode.ERROR;
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
  protected float timer_attackTime = 0;

  protected UnitAction curr_action = UnitAction.NONE;
  protected MapObject object_targeting = null;
  protected MapObject last_damage_from = null;
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
    text += "\n\nHealth: " + this.curr_health + "/" + this.health();
    float attack = this.attack();
    if (attack > 0) {
      text += "\nAttack: " + attack;
    }
    float magic = this.magic();
    if (magic > 0) {
      text += "\nMagic: " + magic;
    }
    float defense = this.defense();
    if (defense > 0) {
      text += "\nDefense: " + defense;
    }
    float resistance = this.resistance();
    if (resistance > 0) {
      text += "\nResistance: " + resistance;
    }
    float piercing = this.piercing();
    if (piercing > 0) {
      text += "\nPiercing: " + int(round(piercing * 100)) + "%";
    }
    float penetration = this.penetration();
    if (penetration > 0) {
      text += "\nPenetration: " + int(round(penetration * 100)) + "%";
    }
    text += "\nSpeed: " + this.speed();
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
      attack += this.weapon().attack;
    }
    return attack;
  }

  float magic() {
    float magic = this.base_magic;
    if (this.weapon() != null) {
      magic += this.weapon().magic;
    }
    return magic;
  }

  float defense() {
    float defense = this.base_defense;
    if (this.weapon() != null && this.weapon().weapon()) {
      defense += this.weapon().defense;
    }
    return defense;
  }

  float resistance() {
    float resistance = this.base_resistance;
    if (this.weapon() != null && this.weapon().weapon()) {
      resistance += this.weapon().resistance;
    }
    return resistance;
  }

  float piercing() {
    float piercing = this.base_piercing;
    if (this.weapon() != null) {
      piercing += this.weapon().piercing;
    }
    if (piercing > 1) {
      piercing = 1;
    }
    return piercing;
  }

  float penetration() {
    float penetration = this.base_penetration;
    if (this.weapon() != null) {
      penetration += this.weapon().penetration;
    }
    if (penetration > 1) {
      penetration = 1;
    }
    return penetration;
  }

  float attackRange() {
    float attackRange = this.base_attackRange;
    if (this.weapon() != null && this.weapon().weapon()) {
      attackRange += this.weapon().attackRange;
    }
    return attackRange;
  }

  float attackCooldown() {
    float attackCooldown = this.base_attackCooldown;
    if (this.weapon() != null && this.weapon().weapon()) {
      attackCooldown += this.weapon().attackCooldown;
    }
    return attackCooldown;
  }

  float attackTime() {
    float attackTime = this.base_attackTime;
    if (this.weapon() != null && this.weapon().weapon()) {
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
    return speed;
  }

  float tenacity() {
    float tenacity = this.base_tenacity;
    if (this.weapon() != null && this.weapon().weapon()) {
      tenacity += this.weapon().tenacity;
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
        this.face(this.curr_action_x, this.curr_action_y);
        this.move(timeElapsed, myKey, map, MoveModifier.NONE);
        if (this.distanceFromPoint(this.curr_action_x, this.curr_action_y)
          < this.last_move_distance) {
          this.curr_action = UnitAction.NONE;
        }
        break;
      case TARGETING_FEATURE:
        if (this.object_targeting == null || this.object_targeting.remove) {
          this.curr_action = UnitAction.NONE;
          break;
        }
        Feature f = (Feature)this.object_targeting;
        this.face(f);
        if (this.distance(f) > f.interactionDistance()) {
          this.move(timeElapsed, myKey, map, MoveModifier.NONE);
        }
        else {
          // unit interact with feature
          this.curr_action = UnitAction.NONE;
        }
        break;
      case TARGETING_UNIT:
        if (this.object_targeting == null || this.object_targeting.remove) {
          this.curr_action = UnitAction.NONE;
          break;
        }
        Unit u = (Unit)this.object_targeting;
        this.face(u);
        if (this.distance(u) > this.attackRange()) {
          this.move(timeElapsed, myKey, map, MoveModifier.NONE);
        }
        else if (this.timer_attackCooldown <= 0) {
          if (this.gear.get(GearSlot.WEAPON) != null && this.gear.get(GearSlot.WEAPON).shootable())
          this.curr_action = UnitAction.ATTACKING;
          this.timer_attackTime = this.attackTime();
        }
        break;
      case TARGETING_ITEM:
        if (this.object_targeting == null || this.object_targeting.remove) {
          this.curr_action = UnitAction.NONE;
          break;
        }
        Item i = (Item)this.object_targeting;
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
        this.timer_attackTime -= timeElapsed;
        if (this.timer_attackTime < 0) {
          this.curr_action = UnitAction.TARGETING_UNIT;
          this.attack(unit_attacking);
        }
        break;
      case NONE:
        break;
    }
  }

  // timers independent of curr action
  void update(int timeElapsed) {
    if (this.timer_attackCooldown > 0) {
      this.timer_attackCooldown -= timeElapsed;
    }
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


  // Auto attack
  void attack(Unit u) {
    u.damage(this, u.calculateDamageFrom(this, this.attack(), DamageType.PHYSICAL, this.element));
    this.timer_attackCooldown = this.attackCooldown();
  }


  float calculateDamageFrom(Unit source, float power, DamageType damageType, Element element) {
    float effectiveDefense = 0;
    switch(damageType) {
      case PHYSICAL:
        effectiveDefense = this.defense() * (1 - source.piercing());
        break;
      case MAGICAL:
        effectiveDefense = this.resistance() * (1 - source.penetration());
        break;
      case MIXED:
        effectiveDefense = this.defense() * (1 - source.piercing()) +
          this.resistance() * (1 - source.penetration());
        break;
      case TRUE:
        effectiveDefense = 0;
        break;
    }
    return max(0, power - effectiveDefense) * this.element.resistanceFactorTo(element);
  }


  void damage(Unit source, float amount) {
    if (this.remove || amount <= 0) {
      return;
    }
    this.curr_health -= amount;
    if (this.curr_health <= 0) {
      this.curr_health = 0;
      this.remove = true;
    }
    this.last_damage_from = source;
    source.damaged(this, amount);
    if (this.remove) {
      source.killed(this);
    }
  }


  void damaged(Unit u, float damage) {
  }


  void killed(Unit u) {
  }


  void stopAction() {
    this.curr_action = UnitAction.NONE;
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
      Unit u = entry.getValue();
      if (u.alliance == this.alliance) {
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
      Unit u = entry.getValue();
      if (u.alliance == this.alliance) {
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
    fileString += "\ntimer_attackTime: " + this.timer_attackTime;
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
        this.base_tenacity = toFloat(data);
        break;
      case "timer_attackCooldown":
        this.base_tenacity = toFloat(data);
        break;
      case "timer_attackTime":
        this.base_tenacity = toFloat(data);
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
