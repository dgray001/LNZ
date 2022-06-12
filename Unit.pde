enum UnitAction {
  NONE, MOVING, TARGETING_FEATURE, TARGETING_UNIT, TARGETING_ITEM, ATTACKING,
  SHOOTING, AIMING, USING_ITEM, FEATURE_INTERACTION, FEATURE_INTERACTION_WITH_ITEM,
  HERO_INTERACTING_WITH_FEATURE, TARGETING_FEATURE_WITH_ITEM,
  HERO_INTERACTING_WITH_FEATURE_WITH_ITEM, MOVING_AND_USING_ITEM, CASTING,
  CAST_WHEN_IN_RANGE,
  ;
}


enum MoveModifier {
  NONE, SNEAK, RECOIL,
  AMPHIBIOUS_LEAP, ANURAN_APPETITE;
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
    this.addField(new FloatFormField("Base Health: ", "base health", 0, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Base Attack: ", "base attack", 0, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Base Magic: ", "base magic", 0, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Base Defense: ", "base defense", 0, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Base Resistance: ", "base resistance", 0, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Base Piercing: ", "base piercing", 0, 1));
    this.addField(new FloatFormField("Base Penetration: ", "base penetration", 0, 1));
    this.addField(new FloatFormField("Base Attack Range: ", "base attack range", 0, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Base Sight: ", "base sight", 0, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Base Speed: ", "base speed", 0, Float.MAX_VALUE - 1));
    this.addField(new FloatFormField("Base Tenacity: ", "base tenacity", 0, 1));
    this.addField(new IntegerFormField("Base Agility: ", "base agility", 0, 10));
    this.addField(new SubmitFormField("Finished", false));
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
  class PathFindingThread extends Thread {
    class CoordinateValues {
      private int source_height = 0;
      private boolean corner_square = false;
      private int source_x = 0;
      private int source_y = 0;
      private float distance = 0;
      CoordinateValues(int source_height, boolean corner_square, IntegerCoordinate coordinate, float distance) {
        this.source_height = source_height;
        this.corner_square = corner_square;
        this.source_x = coordinate.x;
        this.source_y = coordinate.y;
        this.distance = distance;
      }
      CoordinateValues(CoordinateValues coordinate_values) {
        this.source_height = coordinate_values.source_height;
        this.corner_square = coordinate_values.corner_square;
        this.source_x = coordinate_values.source_x;
        this.source_y = coordinate_values.source_y;
        this.distance = coordinate_values.distance;
      }
    }

    private float goal_x = 0;
    private float goal_y = 0;
    private GameMap map = null;
    private Stack<FloatCoordinate> move_stack = new Stack<FloatCoordinate>();
    private boolean stop_thread = false;

    PathFindingThread(float goal_x, float goal_y, GameMap map) {
      super("PathFindingThread");
      this.goal_x = goal_x;
      this.goal_y = goal_y;
      this.map = map;
    }

    HashMap<IntegerCoordinate, CoordinateValues> next_coordinates(HashMap<IntegerCoordinate, Float> last_coordinates, GameMap map) {
      HashMap<IntegerCoordinate, CoordinateValues> next_coordinates = new HashMap<IntegerCoordinate, CoordinateValues>();
      for (Map.Entry<IntegerCoordinate, Float> entry : last_coordinates.entrySet()) {
        int source_height = map.heightOfSquare(entry.getKey(), true);
        for (IntegerCoordinate adjacent : entry.getKey().adjacentCoordinates()) {
          if (next_coordinates.containsKey(adjacent) && next_coordinates.get(
            adjacent).distance <= entry.getValue() + 1) {
            continue;
          }
          next_coordinates.put(adjacent, new CoordinateValues(source_height, false,
            entry.getKey(), entry.getValue() + 1));
        }
        for (IntegerCoordinate corner : entry.getKey().cornerCoordinates()) {
          if (next_coordinates.containsKey(corner) && next_coordinates.get(
            corner).distance <= entry.getValue() + Constants.root_two) {
            continue;
          }
          next_coordinates.put(corner, new CoordinateValues(source_height, true,
            entry.getKey(), entry.getValue() + Constants.root_two));
        }
      }
      return next_coordinates;
    }

    @Override
    void run() {
      if (this.map == null) {
        return;
      }
      int unit_max_height = Unit.this.curr_height + Unit.this.walkHeight();
      ArrayList<IntegerCoordinate> unit_squares_on = Unit.this.getSquaresOn();
      float unit_current_x = Unit.this.x;
      float unit_current_y = Unit.this.y;
      HashMap<IntegerCoordinate, CoordinateValues> coordinates = new HashMap<IntegerCoordinate, CoordinateValues>(); // value is distance
      IntegerCoordinate goal = new IntegerCoordinate(int(this.goal_x), int(this.goal_y));
      IntegerCoordinate current = new IntegerCoordinate(int(Unit.this.x), int(Unit.this.y));
      if (current.equals(goal)) {
        return;
      }
      coordinates.put(current, new CoordinateValues(Unit.this.curr_height, true, current, 0));
      HashMap<IntegerCoordinate, Float> last_coordinates = new HashMap<IntegerCoordinate, Float>();
      last_coordinates.put(current, 0.0);
      float last_distance = 0;
      maploop:
      while(true) {
        if (this.stop_thread) {
          return;
        }
        boolean break_map_loop = false;
        HashMap<IntegerCoordinate, CoordinateValues> current_coordinates = this.next_coordinates(last_coordinates, map);
        last_coordinates.clear();
        boolean all_dead_ends = true;
        ArrayList<IntegerCoordinate> current_coordinates_keys = new ArrayList<IntegerCoordinate>(current_coordinates.keySet());
        Collections.shuffle(current_coordinates_keys);
        for (IntegerCoordinate coordinate : current_coordinates_keys) {
          if (!map.containsMapSquare(coordinate)) {
            continue;
          }
          int max_height = current_coordinates.get(coordinate).source_height + Unit.this.walkHeight();
          int coordinate_height = map.heightOfSquare(coordinate, true);
          if (coordinate_height > max_height) {
            continue;
          }
          if (current_coordinates.get(coordinate).corner_square) {
            coordinate_height = map.heightOfSquare(new IntegerCoordinate(
              current_coordinates.get(coordinate).source_x, coordinate.y), true);
            if (coordinate_height > max_height) {
              continue;
            }
            coordinate_height = map.heightOfSquare(new IntegerCoordinate(
              coordinate.x, current_coordinates.get(coordinate).source_y), true);
            if (coordinate_height > max_height) {
              continue;
            }
          }
          if (coordinates.containsKey(coordinate) && coordinates.get(
            coordinate).distance <= current_coordinates.get(coordinate).distance) {
            continue;
          }
          coordinates.put(coordinate, new CoordinateValues(current_coordinates.get(coordinate)));
          if (coordinate.equals(goal)) {
            last_distance = current_coordinates.get(coordinate).distance + 1;
            break_map_loop = true;
          }
          last_coordinates.put(coordinate, current_coordinates.get(coordinate).distance);
          all_dead_ends = false;
        }
        if (all_dead_ends) {
          return;
        }
        if (break_map_loop) {
          break maploop;
        }
      }
      boolean x_changed = false;
      boolean y_changed = false;
      boolean x_changed_last_turn = false;
      boolean y_changed_last_turn = false;
      boolean x_not_changed = false;
      boolean y_not_changed = false;
      boolean push_next_goal = false;
      boolean check_next_goal = false;
      int check_next_goal_x = 0;
      int check_next_goal_y = 0;
      if (!coordinates.containsKey(goal)) {
        global.errorMessage("ERROR: Coordinates missing original goal.");
        return;
      }
      pathloop:
      while(true) {
        if (this.stop_thread) {
          return;
        }
        x_not_changed = false;
        y_not_changed = false;
        if (!x_changed) {
          x_not_changed = true;
        }
        if (!y_changed) {
          y_not_changed = true;
        }
        IntegerCoordinate next_goal = null;
        List<IntegerCoordinate> adjacents;
        if (coordinates.get(goal).corner_square) {
          adjacents = Arrays.asList(goal.adjacentAndCornerCoordinates());
        }
        else {
          adjacents = Arrays.asList(goal.adjacentCoordinates());
        }
        Collections.shuffle(adjacents); // to allow random choosing of equivalent paths
        for (IntegerCoordinate adjacent : adjacents) {
          if (!coordinates.containsKey(adjacent)) {
            continue;
          }
          if (coordinates.get(adjacent).distance >= last_distance) {
            continue;
          }
          next_goal = adjacent;
          last_distance = coordinates.get(adjacent).distance;
        }
        if (next_goal == null) {
          global.errorMessage("ERROR: Found path but can't map it.");
          return;
        }
        if (check_next_goal) {
          check_next_goal = false;
          int max_height = coordinates.get(next_goal).source_height + Unit.this.walkHeight();
          if (next_goal.x != goal.x) {
            if (goal.y > check_next_goal_y) {
              int coordinate_height = map.heightOfSquare(next_goal.x, next_goal.y - 1, true);
              if (coordinate_height > max_height) {
                y_changed = true;
              }
            }
            else {
              int coordinate_height = map.heightOfSquare(next_goal.x, next_goal.y + 1, true);
              if (coordinate_height > max_height) {
                y_changed = true;
              }
            }
          }
          if (next_goal.y != goal.y) {
            if (goal.x > check_next_goal_x) {
              int coordinate_height = map.heightOfSquare(next_goal.x - 1, next_goal.y, true);
              if (coordinate_height > max_height) {
                x_changed = true;
              }
            }
            else {
              int coordinate_height = map.heightOfSquare(next_goal.x + 1, next_goal.y, true);
              if (coordinate_height > max_height) {
                x_changed = true;
              }
            }
          }
        }
        if (coordinates.get(goal).corner_square) {
          if (!coordinates.get(next_goal).corner_square) {
            check_next_goal = true;
            check_next_goal_x = goal.x;
            check_next_goal_y = goal.y;
          }
        }
        else {
          boolean keep_x_changed = false;
          boolean keep_y_changed = false;
          if (next_goal.x != goal.x) {
            x_changed = true;
            if (coordinates.get(next_goal).corner_square) {
              int max_height = coordinates.get(goal).source_height + Unit.this.walkHeight();
              if (next_goal.y > coordinates.get(next_goal).source_y) {
                int coordinate_height = map.heightOfSquare(goal.x, goal.y - 1, true);
                if (coordinate_height > max_height) {
                  push_next_goal = true;
                }
              }
              else {
                int coordinate_height = map.heightOfSquare(goal.x, goal.y + 1, true);
                if (coordinate_height > max_height) {
                  push_next_goal = true;
                }
              }
            }
            else if (y_changed_last_turn) {
              keep_x_changed = true; // zig zag
            }
          }
          if (next_goal.y != goal.y) {
            y_changed = true;
            if (coordinates.get(next_goal).corner_square) {
              int max_height = coordinates.get(goal).source_height + Unit.this.walkHeight();
              if (next_goal.x > coordinates.get(next_goal).source_x) {
                int coordinate_height = map.heightOfSquare(goal.x - 1, goal.y, true);
                if (coordinate_height > max_height) {
                  push_next_goal = true;
                }
              }
              else {
                int coordinate_height = map.heightOfSquare(goal.x + 1, goal.y, true);
                if (coordinate_height > max_height) {
                  push_next_goal = true;
                }
              }
            }
            else if (x_changed_last_turn) {
              keep_y_changed = true; // zig zag
            }
          }
          if (x_changed && x_not_changed) {
            x_changed_last_turn = true;
          }
          else {
            x_changed_last_turn = false;
          }
          if (y_changed && y_not_changed) {
            y_changed_last_turn = true;
          }
          else {
            y_changed_last_turn = false;
          }
          if (x_changed && y_changed) {
            if (!keep_x_changed) {
              x_changed = false;
            }
            if (!keep_y_changed) {
              y_changed = false;
            }
            this.move_stack.push(new FloatCoordinate(goal.x + 0.5, goal.y + 0.5));
          }
        }
        if (next_goal.equals(current)) {
          break pathloop;
        }
        goal = next_goal;
        if (push_next_goal) {
          push_next_goal = false;
          this.move_stack.push(new FloatCoordinate(goal.x + 0.5, goal.y + 0.5));
        }
      }
      float initial_goal_x = this.goal_x;
      float initial_goal_y = this.goal_y;
      if (!this.move_stack.empty()) {
        initial_goal_x = this.move_stack.peek().x;
        initial_goal_y = this.move_stack.peek().y;
      }
      float x_dif = initial_goal_x - unit_current_x;
      float y_dif = initial_goal_y - unit_current_y;
      float dif_distance = sqrt(x_dif * x_dif + y_dif * y_dif);
      if (abs(dif_distance) < 1 || Unit.this.size == 0) {
        return;
      }
      float x_multiplier = x_dif / dif_distance;
      float y_multiplier = y_dif / dif_distance;
      HashSet<IntegerCoordinate> new_squares_on = new HashSet<IntegerCoordinate>();
      int number_sets_to_check = 2;
      for (int n = 0; n < number_sets_to_check; n++) {
        unit_current_x += x_multiplier * Unit.this.size * 0.4;
        unit_current_y += y_multiplier * Unit.this.size * 0.4;
        for (int i = round(floor(unit_current_x - Unit.this.size)); i < round(ceil(unit_current_x + Unit.this.size)); i++) {
          for (int j = round(floor(unit_current_y - Unit.this.size)); j < round(ceil(unit_current_y + Unit.this.size)); j++) {
            IntegerCoordinate coordinate = new IntegerCoordinate(i, j);
            if (unit_squares_on.contains(coordinate)) {
              continue;
            }
            new_squares_on.add(coordinate);
          }
        }
      }
      for (IntegerCoordinate coordinate : new_squares_on) {
        int coordinate_height = map.heightOfSquare(coordinate.x, coordinate.y, true);
        if (coordinate_height > unit_max_height) {
          this.move_stack.push(new FloatCoordinate(current.x + 0.5, current.y + 0.5));
          break;
        }
      }
    }
  }


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
  protected float base_lifesteal = 0; // percentage
  protected boolean save_base_stats = false; // toggle on if base stats manually changed

  protected float curr_health = 1;
  protected float timer_attackCooldown = 0;
  protected float timer_actionTime = 0;
  protected float timer_last_damage = 0;

  protected UnitAction curr_action = UnitAction.NONE;
  protected int curr_action_id = 0;
  protected boolean curr_action_unhaltable = false;
  protected boolean curr_action_unstoppable = false;
  protected float curr_action_x = 0;
  protected float curr_action_y = 0;
  protected Stack<FloatCoordinate> move_stack = new Stack<FloatCoordinate>();
  protected boolean using_current_move_stack = false;
  protected boolean waiting_for_pathfinding_thread = false;
  protected PathFindingThread pathfinding_thread = null;
  protected int timer_update_pathfinding = Constants.unit_update_pathfinding_timer;

  protected int map_key = -10;
  protected MapObject object_targeting = null;
  protected MapObject last_damage_from = null;
  protected float last_damage_amount = 0;
  protected float last_move_distance = 0;
  protected int buffer_cast = -1;
  protected boolean last_move_collision = false;
  protected boolean last_move_any_collision = false;
  protected float footgear_durability_distance = Constants.unit_footgearDurabilityDistance;

  protected ArrayList<IntegerCoordinate> curr_squares_on = new ArrayList<IntegerCoordinate>(); // squares unit is on
  protected ArrayList<IntegerCoordinate> curr_squares_sight = new ArrayList<IntegerCoordinate>(); // squares unit can see
  protected int unit_height = 0; // height of unit you are standing on
  protected int floor_height = 0; // height of ground
  protected boolean falling = false;
  protected int fall_amount = 0;
  protected float timer_falling = 0;
  protected int timer_resolve_floor_height = Constants.unit_timer_resolve_floor_height_cooldown;

  protected boolean ai_controlled = true;
  protected int timer_ai_action1 = 0;
  protected int timer_ai_action2 = 0;
  protected int timer_ai_action3 = 0;
  protected boolean ai_toggle = false;

  // graphics
  protected float random_number = random(100);
  protected int timer_talk = Constants.unit_timer_talk + int(random(Constants.unit_timer_talk));
  protected int timer_target_sound = 0;
  protected int timer_walk = Constants.unit_timer_walk;

  Unit(int ID) {
    this(ID, 0, 0);
  }
  Unit(int ID, float x, float y) {
    super(ID);
    this.setLocation(x, y);
    this.setUnitID(ID);
  }

  void setUnitID(int ID) {
    this.ID = ID;
    switch(ID) {
      // Other
      case 1001:
        this.setStrings("Test Dummy", "", "");
        this.addStatusEffect(StatusEffectCode.UNKILLABLE);
        break;
      case 1002:
        this.setStrings("Chicken", "Gaia", "");
        this.baseStats(2.5, 0, 0, 0, 1.4);
        this.base_agility = 1;
        this.timer_ai_action1 = int(Constants.ai_chickenTimer1 + random(Constants.ai_chickenTimer1));
        this.timer_ai_action2 = int(Constants.ai_chickenTimer2 + random(Constants.ai_chickenTimer2));
        this.setLevel(1);
        this.sizeZ = 2;
        break;
      case 1003:
        this.setStrings("Chick", "Gaia", "");
        this.baseStats(1.5, 0, 0, 0, 1.1);
        this.timer_ai_action1 = int(Constants.ai_chickenTimer1 + random(Constants.ai_chickenTimer1));
        this.timer_ai_action2 = int(2 * Constants.ai_chickenTimer2 + 2 * random(Constants.ai_chickenTimer2));
        this.setLevel(0);
        this.size = 0.8 * Constants.unit_defaultSize;
        this.sizeZ = 1;
        break;
      case 1004:
        this.setStrings("Rankin", "Human", "");
        this.baseStats(8, 3, 2, 0, 3);
        this.setLevel(5);
        this.size = 0.45;
        this.sizeZ = 6;
        break;
      case 1005:
        this.setStrings("Rooster", "Gaia", "");
        this.baseStats(2.8, 1.2, 0, 0, 1.4);
        this.base_agility = 1;
        this.timer_ai_action1 = int(Constants.ai_chickenTimer1 + random(Constants.ai_chickenTimer1));
        this.timer_ai_action2 = int(Constants.ai_chickenTimer2 + random(Constants.ai_chickenTimer2));
        this.setLevel(2);
        this.sizeZ = 2;
        break;
      case 1006:
        this.setStrings("Father Dom", "Human", "");
        this.baseStats(3.5, 2, 0, 0, 2);
        this.magicStats(2, 4, 0.05);
        this.alliance = Alliance.BEN;
        this.setLevel(3);
        this.sizeZ = 4;
        this.gearSlots("Weapon");
        this.pickup(new Item(2928));
        break;
      case 1007:
        this.setStrings("Michael Schmiesing", "Human", "The fat man himself!");
        this.baseStats(15, 4, 3, 0, 1.5);
        this.alliance = Alliance.BEN;
        this.setLevel(7);
        this.gearSlots("Weapon");
        this.size = 0.55;
        break;
      case 1008:
        this.setStrings("Molly Schmiesing", "Human", "");
        this.baseStats(9, 4, 1, 0, 1.7);
        this.alliance = Alliance.BEN;
        this.setLevel(6);
        break;

      // Heroes
      case 1101:
        this.setStrings("Ben Nelson", "Hero", "");
        this.baseStats(4, 1, 0, 0, 1.7);
        this.setLevel(0);
        this.base_agility = 1;
        this.gearSlots("Weapon", "Head", "Chest", "Legs", "Feet");
        this.alliance = Alliance.BEN;
        this.element = Element.GRAY;
        break;
      case 1102:
        this.setStrings("Dan Gray", "Hero", "");
        this.baseStats(4, 1, 0, 0, 1.8);
        this.setLevel(0);
        this.base_agility = 2;
        this.gearSlots("Weapon", "Head", "Chest", "Legs", "Feet");
        this.alliance = Alliance.BEN;
        this.element = Element.BROWN;
        break;
      case 1103:
        this.setStrings("JIF", "Hero", "");
        this.baseStats(4, 1, 0, 0, 2);
        this.setLevel(0);
        this.gearSlots("Weapon", "Head", "Chest", "Legs", "Feet");
        this.alliance = Alliance.BEN;
        break;
      case 1104:
        this.setStrings("Mark Spinny", "Hero", "");
        this.baseStats(4, 1, 0, 0, 2);
        this.setLevel(0);
        this.gearSlots("Weapon", "Head", "Chest", "Legs", "Feet");
        this.alliance = Alliance.BEN;
        break;
      case 1105:
        this.setStrings("Mad Dog Mattus", "Hero", "");
        this.baseStats(4, 1, 0, 0, 2);
        this.setLevel(0);
        this.gearSlots("Weapon", "Head", "Chest", "Legs", "Feet");
        this.alliance = Alliance.BEN;
        break;
      case 1106:
        this.setStrings("Jeremiah", "Hero", "");
        this.baseStats(4, 1, 0, 0, 2);
        this.setLevel(0);
        this.gearSlots("Weapon", "Head", "Chest", "Legs", "Feet");
        this.alliance = Alliance.BEN;
        break;
      case 1131:
        this.setStrings("Michael Fischer", "Hero", "");
        this.baseStats(4, 1, 0, 0, 2);
        this.setLevel(0);
        this.gearSlots("Weapon", "Head", "Chest", "Legs", "Feet");
        this.alliance = Alliance.BEN;
        break;

      // Zombies
      case 1201:
        this.setStrings("Broken Sick Zombie", "Zombie", "");
        this.baseStats(1, 1, 0, 0, 0.3);
        this.setLevel(1);
        this.alliance = Alliance.ZOMBIE;
        this.addStatusEffect(StatusEffectCode.SICK);
        break;
      case 1202:
        this.setStrings("Broken Zombie", "Zombie", "");
        this.baseStats(2.2, 1.3, 0, 0, 0.3);
        this.setLevel(2);
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1203:
        this.setStrings("Sick Zombie", "Zombie", "");
        this.baseStats(3.5, 2, 0, 0, 0.4);
        this.setLevel(3);
        this.gearSlots("Weapon");
        this.alliance = Alliance.ZOMBIE;
        this.addStatusEffect(StatusEffectCode.SICK);
        break;
      case 1204:
        this.setStrings("Lazy Hungry Zombie", "Zombie", "");
        this.baseStats(5, 3, 0.3, 0, 0.5);
        this.setLevel(4);
        this.alliance = Alliance.ZOMBIE;
        this.addStatusEffect(StatusEffectCode.HUNGRY);
        break;
      case 1205:
        this.setStrings("Hungry Zombie", "Zombie", "");
        this.baseStats(7, 3.2, 0.3, 0, 0.8);
        this.setLevel(5);
        this.alliance = Alliance.ZOMBIE;
        this.addStatusEffect(StatusEffectCode.HUNGRY);
        break;
      case 1206:
        this.setStrings("Lazy Zombie", "Zombie", "");
        this.baseStats(9, 3.5, 0.3, 0, 0.6);
        this.setLevel(6);
        this.gearSlots("Weapon");
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1207:
        this.setStrings("Confused Franny Zombie", "Zombie", "");
        this.baseStats(11, 4, 0.6, 0, 0.9);
        this.setLevel(7);
        this.gearSlots("Weapon");
        this.alliance = Alliance.ZOMBIE;
        this.addStatusEffect(StatusEffectCode.CONFUSED);
        break;
      case 1208:
        this.setStrings("Confused Zombie", "Zombie", "");
        this.baseStats(14, 4.3, 0.6, 0, 1);
        this.setLevel(8);
        this.gearSlots("Weapon");
        this.alliance = Alliance.ZOMBIE;
        this.addStatusEffect(StatusEffectCode.CONFUSED);
        break;
      case 1209:
        this.setStrings("Franny Zombie", "Zombie", "");
        this.baseStats(17, 4.7, 0.6, 0, 1.1);
        this.setLevel(9);
        this.gearSlots("Weapon");
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1210:
        this.setStrings("Intellectual Zombie", "Zombie", "");
        this.baseStats(20, 5, 1, 0, 1.2);
        this.setLevel(10);
        this.gearSlots("Weapon");
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1291:
        this.setStrings("Zombie", "Zombie", "");
        this.baseStats(3, 1, 0, 0, 0.8);
        this.gearSlots("Weapon");
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1292:
        this.setStrings("Running Zombie", "Zombie", "");
        this.baseStats(3, 1, 0, 0, 1);
        this.gearSlots("Weapon");
        this.addStatusEffect(StatusEffectCode.RUNNING);
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1293:
        this.setStrings("Armored Zombie", "Zombie", "");
        this.baseStats(3, 1, 2, 0, 0.8);
        this.gearSlots("Weapon");
        this.alliance = Alliance.ZOMBIE;
        break;

      // Named Zombies
      case 1301:
        this.setStrings("Duggy", "Zombie", "");
        this.baseStats(6, 2.5, 0.2, 0, 1);
        this.setLevel(1);
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1302:
        this.setStrings("Jacob Sanchez", "Zombie", "");
        this.baseStats(8, 5, 0, 0, 1.5);
        this.setLevel(2);
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1303:
        this.setStrings("Mike Olenchuk", "Zombie", "");
        this.baseStats(15, 4, 1, 0, 0.9);
        this.setLevel(3);
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1304:
        this.setStrings("Grady Stuckman", "Zombie", "");
        this.baseStats(12, 5.5, 0.4, 0.05, 1.7);
        this.setLevel(4);
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1305:
        this.setStrings("Ethan Pitney", "Zombie", "");
        this.baseStats(15, 7, 0.4, 0, 1.3);
        this.setLevel(5);
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1306:
        this.setStrings("James Sarlo", "Zombie", "");
        this.baseStats(20, 8, 0.4, 0.12, 1.4);
        this.setLevel(6);
        this.alliance = Alliance.ZOMBIE;
        break;
      case 1307:
        this.setStrings("Matt Hair", "Zombie", "");
        this.baseStats(25, 6.5, 2.2, 0.03, 1.1);
        this.setLevel(7);
        this.alliance = Alliance.ZOMBIE;
        this.gearSlots("Weapon");
        break;
      case 1308:
        this.setStrings("Nick Belt", "Zombie", "");
        this.baseStats(22, 10, 0.8, 0.15, 1.4);
        this.setLevel(8);
        this.alliance = Alliance.ZOMBIE;
        this.base_attackRange = 1.2 * Constants.unit_defaultBaseAttackRange;
        break;
      case 1311:
        this.setStrings("Cathy Heck", "Zombie", "");
        this.baseStats(50, 7.5, 1.6, 0.1, 0.6);
        this.magicStats(10, 1.2, 0.05);
        this.base_lifesteal = 0.08;
        this.abilities.add(new Ability(1001));
        this.abilities.add(new Ability(1002));
        this.abilities.add(new Ability(1003));
        this.setLevel(11);
        this.alliance = Alliance.ZOMBIE;
        this.timer_ai_action1 = round(5000 + random(5000));
        this.timer_ai_action2 = round(9000 + random(9000));
        this.timer_ai_action3 = round(21000 + random(21000));
        break;

      default:
        global.errorMessage("ERROR: Unit ID " + ID + " not found.");
        break;
    }
  }

  String display_name() {
    return this.display_name;
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
    String text = "-- " + this.type() + " (level " + this.level + ") --";
    if (this.statuses.size() > 0) {
      text += "\n";
    }
    text += "\n\nHealth: " + round(ceil(this.curr_health)) + "/" + round(ceil(this.health()));
    float attack = this.attack();
    if (attack > 0) {
      text += "\nAttack: " + round(attack * 10.0) / 10.0;
    }
    float magic = this.magic();
    if (magic > 0) {
      text += "\nMagic: " + round(magic * 10.0) / 10.0;
    }
    float defense = this.defense();
    if (defense > 0) {
      text += "\nDefense: " + round(defense * 10.0) / 10.0;
    }
    float resistance = this.resistance();
    if (resistance > 0) {
      text += "\nResistance: " + round(resistance * 10.0) / 10.0;
    }
    float piercing = this.piercing();
    if (piercing > 0) {
      text += "\nPiercing: " + round(piercing * 100) + "%";
    }
    float penetration = this.penetration();
    if (penetration > 0) {
      text += "\nPenetration: " + round(penetration * 100) + "%";
    }
    text += "\nSpeed: " + round(this.speed() * 10.0) / 10.0;
    float tenacity = this.tenacity();
    if (tenacity > 0) {
      text += "\nTenacity: " + round(tenacity * 100) + "%";
    }
    int agility = this.agility();
    if (attack > 0) {
      text += "\nAgility: " + agility;
    }
    float lifesteal = this.lifesteal();
    if (lifesteal > 0) {
      text += "\nLifesteal: " + round(lifesteal * 100) + "%";
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

  void magicStats(float magic, float resistance, float penetration) {
    this.base_magic = magic;
    this.base_resistance = resistance;
    this.base_penetration = penetration;
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
      case 1003:
        path += "chick.png";
        break;
      case 1004:
        path += "john_rankin.png";
        break;
      case 1005:
        path += "rooster.png";
        break;
      case 1006:
        path += "father_dom.png";
        break;
      case 1007:
        path += "mike_schmiesing.png";
        break;
      case 1008:
        path += "molly_schmiesing.png";
        break;
      case 1101:
        if (global.profile.ben_has_eyes) {
          path += "ben.png";
        }
        else {
          path += "ben_noeyes.png";
        }
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
      case 1131:
        path += "michael_fischer.png";
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
      case 1291:
        path += "zombie1.png";
        break;
      case 1292:
        path += "zombie2.png";
        break;
      case 1293:
        path += "zombie3.png";
        break;
      case 1301:
        path += "duggy_zombie.png";
        break;
      case 1302:
        path += "jacob_sanchez_zombie.png";
        break;
      case 1303:
        path += "mike_olenchuk_zombie.png";
        break;
      case 1304:
        path += "grady_stuckman_zombie.png";
        break;
      case 1305:
        path += "ethan_pitney_zombie.png";
        break;
      case 1306:
        path += "james_sarlo_zombie.png";
        break;
      case 1307:
        path += "matt_hair_zombie.png";
        break;
      case 1308:
        path += "nick_belt_zombie.png";
        break;
      case 1311:
        path += "cathy_heck_zombie.png";
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


  void setLevel(int level) {
    this.level = level;
    float level_constant = 0.5 * level * (level + 1);
    switch(this.ID) {
      case 1291: // Zombie
      case 1292: // Running Zombie
        this.base_health = 3 + 0.4 * level_constant;
        this.curr_health = this.health();
        this.base_attack = 1 + 0.1 * level_constant;
        this.base_defense = 0.012 * level_constant;
        break;
      case 1293: // Armored Zombie
        this.base_health = 3 + 0.4 * level_constant;
        this.curr_health = this.health();
        this.base_attack = 1 + 0.1 * level_constant;
        this.base_defense = 2 + 0.022 * level_constant;
        break;
      default:
        break;
    }
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

  Item offhand() {
    if (this.gear.containsKey(GearSlot.OFFHAND)) {
      return this.gear.get(GearSlot.OFFHAND);
    }
    return null;
  }


  boolean canEquip(GearSlot slot) {
    if (this.gear.containsKey(slot) && this.gear.get(slot) == null) {
      return true;
    }
    return false;
  }

  boolean canPickup() {
    return this.canEquip(GearSlot.WEAPON);
  }

  void pickup(Item i) {
    this.gear.put(GearSlot.WEAPON, i);
  }

  // True if holding one of these items
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


  float health() {
    float health = this.base_health;
    for (Map.Entry<GearSlot, Item> gear_entry : this.gear.entrySet()) {
      if (gear_entry.getKey() == GearSlot.WEAPON) {
        continue;
      }
      if (gear_entry.getValue() == null) {
        continue;
      }
      health += gear_entry.getValue().health;
    }
    if (this.weapon() != null && this.weapon().weapon()) {
      health += this.weapon().health;
    }
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        default:
          break;
      }
    }
    return health;
  }

  // To make abilities array in Unit instead of Hero
  float currMana() {
    return 0;
  }
  float mana() {
    return 0;
  }
  void increaseMana(int amount) {}
  void decreaseMana(int amount) {}

  float attack() {
    float attack = this.base_attack;
    for (Map.Entry<GearSlot, Item> gear_entry : this.gear.entrySet()) {
      if (gear_entry.getKey() == GearSlot.WEAPON) {
        continue;
      }
      if (gear_entry.getValue() == null) {
        continue;
      }
      attack += gear_entry.getValue().attack;
    }
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
    if (this.relaxed()) {
      attack *= Constants.status_relaxed_multiplier;
    }
    if (this.nelsonGlare()) {
      attack *= Constants.ability_103_debuff;
    }
    if (this.nelsonGlareII()) {
      attack *= Constants.ability_108_debuff;
    }
    if (this.rageOfTheBen()) {
      attack *= Constants.ability_105_buffAmount;
    }
    if (this.rageOfTheBenII()) {
      attack *= Constants.ability_110_buffAmount;
    }
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        default:
          break;
      }
    }
    return attack;
  }

  float magic() {
    float magic = this.base_magic;
    for (Map.Entry<GearSlot, Item> gear_entry : this.gear.entrySet()) {
      if (gear_entry.getKey() == GearSlot.WEAPON) {
        continue;
      }
      if (gear_entry.getValue() == null) {
        continue;
      }
      magic += gear_entry.getValue().magic;
    }
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
    if (this.relaxed()) {
      magic *= Constants.status_relaxed_multiplier;
    }
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        default:
          break;
      }
    }
    return magic;
  }

  float power(float attack_ratio, float magic_ratio) {
    return this.attack() * attack_ratio + this.magic() * magic_ratio;
  }

  float defense() {
    float defense = this.base_defense;
    for (Map.Entry<GearSlot, Item> gear_entry : this.gear.entrySet()) {
      if (gear_entry.getKey() == GearSlot.WEAPON) {
        continue;
      }
      if (gear_entry.getValue() == null) {
        continue;
      }
      defense += gear_entry.getValue().defense;
    }
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
    if (this.relaxed()) {
      defense *= Constants.status_relaxed_multiplier;
    }
    if (this.sick()) {
      defense *= Constants.status_sick_defenseMultiplier;
    }
    if (this.diseased()) {
      defense *= Constants.status_diseased_defenseMultiplier;
    }
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        default:
          break;
      }
    }
    return defense;
  }

  float resistance() {
    float resistance = this.base_resistance;
    for (Map.Entry<GearSlot, Item> gear_entry : this.gear.entrySet()) {
      if (gear_entry.getKey() == GearSlot.WEAPON) {
        continue;
      }
      if (gear_entry.getValue() == null) {
        continue;
      }
      resistance += gear_entry.getValue().resistance;
    }
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
    if (this.relaxed()) {
      resistance *= Constants.status_relaxed_multiplier;
    }
    if (this.sick()) {
      resistance *= Constants.status_sick_defenseMultiplier;
    }
    if (this.diseased()) {
      resistance *= Constants.status_diseased_defenseMultiplier;
    }
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        default:
          break;
      }
    }
    return resistance;
  }

  float piercing() {
    float piercing = this.base_piercing;
    for (Map.Entry<GearSlot, Item> gear_entry : this.gear.entrySet()) {
      if (gear_entry.getKey() == GearSlot.WEAPON) {
        continue;
      }
      if (gear_entry.getValue() == null) {
        continue;
      }
      piercing += gear_entry.getValue().piercing;
    }
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
    if (this.relaxed()) {
      piercing *= Constants.status_relaxed_multiplier;
    }
    if (piercing > 1) {
      piercing = 1;
    }
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        default:
          break;
      }
    }
    return piercing;
  }

  float penetration() {
    float penetration = this.base_penetration;
    for (Map.Entry<GearSlot, Item> gear_entry : this.gear.entrySet()) {
      if (gear_entry.getKey() == GearSlot.WEAPON) {
        continue;
      }
      if (gear_entry.getValue() == null) {
        continue;
      }
      penetration += gear_entry.getValue().penetration;
    }
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
    if (this.relaxed()) {
      penetration *= Constants.status_relaxed_multiplier;
    }
    if (penetration > 1) {
      penetration = 1;
    }
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        default:
          break;
      }
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
        attackRange = this.weapon().shootRange();
      }
      else {
        attackRange += this.weapon().attackRange;
      }
    }
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        default:
          break;
      }
    }
    return attackRange;
  }

  float attackCooldown() {
    return this.attackCooldown(false);
  }
  float attackCooldown(boolean forceMelee) {
    float attackCooldown = this.base_attackCooldown;
    for (Map.Entry<GearSlot, Item> gear_entry : this.gear.entrySet()) {
      if (gear_entry.getKey() == GearSlot.WEAPON) {
        continue;
      }
      if (gear_entry.getValue() == null) {
        continue;
      }
      attackCooldown += gear_entry.getValue().attackCooldown;
    }
    if (this.weapon() != null && this.weapon().weapon()) {
      if (!forceMelee && this.weapon().shootable()) {
        attackCooldown = this.weapon().shootCooldown();
      }
      else {
        attackCooldown += this.weapon().attackCooldown;
      }
    }
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        case 101: // Fearless Leader I
          if (this.rageOfTheBen() && this.currMana() == this.mana()) {
            attackCooldown *= (1 - Constants.ability_101_bonusAmount * this.currMana() * Constants.ability_105_fullRageBonus);
          }
          if (this.rageOfTheBenII() && this.currMana() == this.mana()) {
            attackCooldown *= (1 - Constants.ability_101_bonusAmount * this.currMana() * Constants.ability_110_fullRageBonus);
          }
          else {
            attackCooldown *= (1 - Constants.ability_101_bonusAmount * this.currMana());
          }
          break;
        case 106: // Fearless Leader II
          if (this.rageOfTheBen() && this.currMana() == this.mana()) {
            attackCooldown *= (1 - Constants.ability_106_bonusAmount * this.currMana() * Constants.ability_105_fullRageBonus);
          }
          if (this.rageOfTheBenII() && this.currMana() == this.mana()) {
            attackCooldown *= (1 - Constants.ability_106_bonusAmount * this.currMana() * Constants.ability_110_fullRageBonus);
          }
          else {
            attackCooldown *= (1 - Constants.ability_106_bonusAmount * this.currMana());
          }
          break;
        default:
          break;
      }
    }
    return attackCooldown;
  }

  float attackTime() {
    return this.attackTime(false);
  }
  float attackTime(boolean forceMelee) {
    float attackTime = this.base_attackTime;
    for (Map.Entry<GearSlot, Item> gear_entry : this.gear.entrySet()) {
      if (gear_entry.getKey() == GearSlot.WEAPON) {
        continue;
      }
      if (gear_entry.getValue() == null) {
        continue;
      }
      attackTime += gear_entry.getValue().attackTime;
    }
    if (this.weapon() != null && this.weapon().weapon()) {
      if (!forceMelee && this.weapon().shootable()) {
        attackTime = this.weapon().shootTime();
      }
      else {
        attackTime += this.weapon().attackTime;
      }
    }
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        case 101: // Fearless Leader I
          if (this.rageOfTheBen() && this.currMana() == this.mana()) {
            attackTime *= (1 - Constants.ability_101_bonusAmount * this.currMana() * Constants.ability_105_fullRageBonus);
          }
          if (this.rageOfTheBenII() && this.currMana() == this.mana()) {
            attackTime *= (1 - Constants.ability_101_bonusAmount * this.currMana() * Constants.ability_110_fullRageBonus);
          }
          else {
            attackTime *= (1 - Constants.ability_101_bonusAmount * this.currMana());
          }
          break;
        case 106: // Fearless Leader II
          if (this.rageOfTheBen() && this.currMana() == this.mana()) {
            attackTime *= (1 - Constants.ability_106_bonusAmount * this.currMana() * Constants.ability_105_fullRageBonus);
          }
          if (this.rageOfTheBenII() && this.currMana() == this.mana()) {
            attackTime *= (1 - Constants.ability_106_bonusAmount * this.currMana() * Constants.ability_110_fullRageBonus);
          }
          else {
            attackTime *= (1 - Constants.ability_106_bonusAmount * this.currMana());
          }
          break;
        default:
          break;
      }
    }
    return attackTime;
  }

  float sight() {
    float sight = this.base_sight;
    for (Map.Entry<GearSlot, Item> gear_entry : this.gear.entrySet()) {
      if (gear_entry.getKey() == GearSlot.WEAPON) {
        continue;
      }
      if (gear_entry.getValue() == null) {
        continue;
      }
      sight += gear_entry.getValue().sight;
    }
    if (this.weapon() != null) {
      sight += this.weapon().sight;
    }
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        default:
          break;
      }
    }
    return sight;
  }

  float speed() {
    float speed = this.base_speed;
    for (Map.Entry<GearSlot, Item> gear_entry : this.gear.entrySet()) {
      if (gear_entry.getKey() == GearSlot.WEAPON) {
        continue;
      }
      if (gear_entry.getValue() == null) {
        continue;
      }
      speed += gear_entry.getValue().speed;
    }
    if (this.weapon() != null) {
      speed += this.weapon().speedWhenHolding();
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
    if (this.nelsonGlare()) {
      speed *= Constants.ability_103_debuff;
    }
    if (this.nelsonGlareII()) {
      speed *= Constants.ability_108_debuff;
    }
    if (this.senselessGrit()) {
      if (this.curr_action == UnitAction.TARGETING_UNIT) {
        speed *= Constants.ability_104_speedBuff;
      }
    }
    if (this.senselessGritII()) {
      if (this.curr_action == UnitAction.TARGETING_UNIT) {
        speed *= Constants.ability_109_speedBuff;
      }
    }
    if (this.tongueLash()) {
      speed *= Constants.ability_112_slowAmount;
    }
    if (this.running()) {
      speed *= Constants.status_running_multiplier;
    }
    if (this.relaxed()) {
      speed *= Constants.status_relaxed_multiplier;
    }
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        default:
          break;
      }
    }
    return speed;
  }

  float tenacity() {
    float tenacity = this.base_tenacity;
    for (Map.Entry<GearSlot, Item> gear_entry : this.gear.entrySet()) {
      if (gear_entry.getKey() == GearSlot.WEAPON) {
        continue;
      }
      if (gear_entry.getValue() == null) {
        continue;
      }
      tenacity += gear_entry.getValue().tenacity;
    }
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
    if (this.relaxed()) {
      tenacity *= Constants.status_relaxed_multiplier;
    }
    if (this.sick()) {
      tenacity *= Constants.status_sick_defenseMultiplier;
    }
    if (this.diseased()) {
      tenacity *= Constants.status_diseased_defenseMultiplier;
    }
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        case 101: // Fearless Leader I
          if (this.rageOfTheBen() && this.currMana() == this.mana()) {
            tenacity += Constants.ability_101_bonusAmount * this.currMana() * Constants.ability_105_fullRageBonus;
          }
          if (this.rageOfTheBenII() && this.currMana() == this.mana()) {
            tenacity += Constants.ability_101_bonusAmount * this.currMana() * Constants.ability_110_fullRageBonus;
          }
          else {
            tenacity += Constants.ability_101_bonusAmount * this.currMana();
          }
          break;
        case 106: // Fearless Leader II
          if (this.rageOfTheBen() && this.currMana() == this.mana()) {
            tenacity += Constants.ability_106_bonusAmount * this.currMana() * Constants.ability_105_fullRageBonus;
          }
          if (this.rageOfTheBenII() && this.currMana() == this.mana()) {
            tenacity += Constants.ability_106_bonusAmount * this.currMana() * Constants.ability_110_fullRageBonus;
          }
          else {
            tenacity += Constants.ability_106_bonusAmount * this.currMana();
          }
          break;
        default:
          break;
      }
    }
    if (tenacity > 1) {
      tenacity = 1;
    }
    return tenacity;
  }

  int agility() {
    int agility = this.base_agility;
    for (Map.Entry<GearSlot, Item> gear_entry : this.gear.entrySet()) {
      if (gear_entry.getKey() == GearSlot.WEAPON) {
        continue;
      }
      if (gear_entry.getValue() == null) {
        continue;
      }
      agility += gear_entry.getValue().agility;
    }
    if (this.weapon() != null && this.weapon().weapon()) {
      agility += this.weapon().agility;
    }
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        default:
          break;
      }
    }
    if (agility < 0) {
      agility = 0;
    }
    if (agility > Constants.unit_maxAgility) {
      agility = Constants.unit_maxAgility;
    }
    return agility;
  }

  float lifesteal() {
    float lifesteal = this.base_lifesteal;
    for (Map.Entry<GearSlot, Item> gear_entry : this.gear.entrySet()) {
      if (gear_entry.getKey() == GearSlot.WEAPON) {
        continue;
      }
      if (gear_entry.getValue() == null) {
        continue;
      }
      lifesteal += gear_entry.getValue().lifesteal;
    }
    if (this.weapon() != null && this.weapon().weapon()) {
      lifesteal += this.weapon().lifesteal;
    }
    if (this.weak()) {
      lifesteal *= Constants.status_weak_multiplier;
    }
    if (this.wilted()) {
      lifesteal *= Constants.status_wilted_multiplier;
    }
    if (this.withered()) {
      lifesteal *= Constants.status_withered_multiplier;
    }
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        default:
          break;
      }
    }
    return lifesteal;
  }

  int swimNumber() {
    int swimNumber = 0;
    if (this.element == Element.BLUE) {
      swimNumber += 2;
    }
    return swimNumber;
  }

  float passiveHeal() {
    float passive_heal = 0;
    if (Hero.class.isInstance(this)) {
      passive_heal += Constants.hero_passiveHealPercent;
    }
    if (this.relaxed()) {
      passive_heal += Constants.status_relaxed_healMultiplier;
    }
    return passive_heal;
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
  float calculateTimerFrom(StatusEffectCode code, float timer) {
    if (code == StatusEffectCode.SUPPRESSED) {
      return timer;
    }
    if (code.negative()) {
      timer *= this.element.resistanceFactorTo(code.element());
      timer *= 1 - this.tenacity();
    }
    return timer;
  }
  void addStatusEffect(StatusEffectCode code, float timer) {
    timer = this.calculateTimerFrom(code, timer);
    if (this.statuses.containsKey(code)) {
      if (!this.statuses.get(code).permanent) {
        this.statuses.get(code).addTime(timer);
      }
    }
    else {
      this.statuses.put(code, new StatusEffect(code, timer));
      this.effectFromNewNegativeStatusEffect();
    }
  }
  void refreshStatusEffect(StatusEffectCode code, float timer) {
    timer = this.calculateTimerFrom(code, timer);
    if (this.statuses.containsKey(code)) {
      if (!this.statuses.get(code).permanent) {
        this.statuses.get(code).refreshTime(timer);
      }
    }
    else {
      this.statuses.put(code, new StatusEffect(code, timer));
      this.effectFromNewNegativeStatusEffect();
    }
  }
  void effectFromNewNegativeStatusEffect() {
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        case 101: // Fearless Leader I
          if (this.rageOfTheBenII()) {
            this.increaseMana(int(Constants.ability_101_rageGain * Constants.ability_110_rageGainBonus));
          }
          else if (this.rageOfTheBen()) {
            this.increaseMana(int(Constants.ability_101_rageGain * Constants.ability_105_rageGainBonus));
          }
          else {
            this.increaseMana(Constants.ability_101_rageGain);
          }
          a.timer_other = Constants.ability_101_cooldownTimer;
          break;
        case 106: // Fearless Leader II
          if (this.rageOfTheBenII()) {
            this.increaseMana(int(Constants.ability_106_rageGain * Constants.ability_110_rageGainBonus));
          }
          else if (this.rageOfTheBen()) {
            this.increaseMana(int(Constants.ability_106_rageGain * Constants.ability_105_rageGainBonus));
          }
          else {
            this.increaseMana(Constants.ability_106_rageGain);
          }
          a.timer_other = Constants.ability_106_cooldownTimer;
          break;
        default:
          break;
      }
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
  boolean visible() {
    return this.hasStatusEffect(StatusEffectCode.VISIBLE);
  }
  boolean suppressed() {
    return this.hasStatusEffect(StatusEffectCode.SUPPRESSED);
  }
  boolean untargetable() {
    return this.hasStatusEffect(StatusEffectCode.UNTARGETABLE);
  }
  boolean stunned() {
    return this.hasStatusEffect(StatusEffectCode.STUNNED);
  }
  boolean invisible() {
    return this.hasStatusEffect(StatusEffectCode.INVISIBLE);
  }
  boolean uncollidable() {
    return this.hasStatusEffect(StatusEffectCode.UNCOLLIDABLE);
  }
  boolean running() {
    return this.hasStatusEffect(StatusEffectCode.RUNNING);
  }
  boolean fertilized() {
    return this.hasStatusEffect(StatusEffectCode.FERTILIZED);
  }
  boolean sneaking() {
    return this.hasStatusEffect(StatusEffectCode.SNEAKING);
  }
  boolean relaxed() {
    return this.hasStatusEffect(StatusEffectCode.RELAXED);
  }
  boolean ghosting() {
    return this.hasStatusEffect(StatusEffectCode.GHOSTING);
  }
  boolean silenced() {
    return this.hasStatusEffect(StatusEffectCode.SILENCED);
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
  boolean nelsonGlareII() {
    return this.hasStatusEffect(StatusEffectCode.NELSON_GLAREII);
  }
  boolean senselessGrit() {
    return this.hasStatusEffect(StatusEffectCode.SENSELESS_GRIT);
  }
  boolean senselessGritII() {
    return this.hasStatusEffect(StatusEffectCode.SENSELESS_GRITII);
  }
  boolean rageOfTheBen() {
    return this.hasStatusEffect(StatusEffectCode.RAGE_OF_THE_BEN);
  }
  boolean rageOfTheBenII() {
    return this.hasStatusEffect(StatusEffectCode.RAGE_OF_THE_BENII);
  }
  boolean aposematicCamouflage() {
    return this.hasStatusEffect(StatusEffectCode.APOSEMATIC_CAMOUFLAGE);
  }
  boolean aposematicCamouflageII() {
    return this.hasStatusEffect(StatusEffectCode.APOSEMATIC_CAMOUFLAGEII);
  }
  boolean tongueLash() {
    return this.hasStatusEffect(StatusEffectCode.TONGUE_LASH);
  }
  boolean alkaloidSecretion() {
    return this.hasStatusEffect(StatusEffectCode.ALKALOID_SECRETION);
  }
  boolean alkaloidSecretionII() {
    return this.hasStatusEffect(StatusEffectCode.ALKALOID_SECRETIONII);
  }

  StatusEffectCode priorityStatusEffect() {
    return null;
  }


  void refreshPlayerSight(GameMap map) {
    for (IntegerCoordinate coordinate : this.curr_squares_sight) {
      map.setTerrainVisible(false, coordinate.x, coordinate.y);
    }
    this.curr_squares_sight = this.getSquaresSight(map);
    for (IntegerCoordinate coordinate : this.curr_squares_sight) {
      map.exploreTerrainAndVisible(coordinate.x, coordinate.y);
    }
  }


  void startPathfindingThread(GameMap map) {
    switch(this.curr_action) {
      case MOVING:
      case MOVING_AND_USING_ITEM:
        this.startPathfindingThread(this.curr_action_x, this.curr_action_y, map);
        break;
      case TARGETING_FEATURE:
      case TARGETING_FEATURE_WITH_ITEM:
      case TARGETING_UNIT:
      case TARGETING_ITEM:
        if (this.object_targeting == null) {
          break;
        }
        this.startPathfindingThread(this.object_targeting.xCenter(), this.object_targeting.yCenter(), map);
        break;
      default:
        break;
    }
  }
  void startPathfindingThread(float targetX, float targetY, GameMap map) {
    this.waiting_for_pathfinding_thread = true;
    if (this.pathfinding_thread != null && this.pathfinding_thread.isAlive()) {
      this.pathfinding_thread.stop_thread = true;
    }
    this.pathfinding_thread = new PathFindingThread(targetX, targetY, map);
    this.pathfinding_thread.start();
  }

  // If unit choosing to move somewhere
  void moveLogic(int time_elapsed, GameMap map) {
    if (this.waiting_for_pathfinding_thread) {
      if (this.pathfinding_thread == null) {
        this.waiting_for_pathfinding_thread = false;
      }
      else if (this.pathfinding_thread.isAlive()) {
        if (this.last_move_any_collision) { // only wait for thead when you actually collide
          return;
        }
      }
      else {
        this.move_stack = this.pathfinding_thread.move_stack;
        if (!this.move_stack.empty()) {
          this.using_current_move_stack = true;
        }
        this.pathfinding_thread = null;
        this.waiting_for_pathfinding_thread = false;
        return; // have to return so next loop the unit faces properly
      }
    }
    boolean collision_last_move = this.last_move_collision;
    if (this.sneaking()) {
      this.move(time_elapsed, map, MoveModifier.SNEAK);
    }
    else {
      this.move(time_elapsed, map, MoveModifier.NONE);
    }
    if (this.using_current_move_stack) {
      if (this.move_stack.empty()) {
        this.using_current_move_stack = false;
      }
      else if (this.distanceFromPoint(this.move_stack.peek().x, this.move_stack.peek().y) < this.last_move_distance) {
        this.move_stack.pop();
      }
      if (this.curr_action == UnitAction.TARGETING_UNIT) {
        this.timer_update_pathfinding -= time_elapsed;
        if (this.timer_update_pathfinding < 0) {
          this.timer_update_pathfinding += Constants.unit_update_pathfinding_timer;
          this.startPathfindingThread(map);
        }
      }
    }
    if (this.last_move_collision) {
      if (collision_last_move) {
        this.timer_actionTime -= time_elapsed;
      }
      else {
        this.timer_actionTime = Constants.unit_moveCollisionStopActionTime;
      }
      switch(this.ID) {
        case 1002: // Chicken
        case 1003: // Chick
        case 1005: // Rooster
          if (!this.falling) {
            this.jump(map);
          }
          break;
        default:
          break;
      }
      if (this.timer_actionTime < 0) { // colliding over and over
        this.stopAction(true);
      }
    }
    this.timer_walk -= time_elapsed;
    if (this.timer_walk < 0) {
      this.timer_walk += Constants.unit_timer_walk;
      this.walkSound(map.squares[int(floor(this.x))][int(floor(this.y))].terrain_id);
    }
  }


  void update(int timeElapsed, GameMap map) {
    // timers
    this.update(timeElapsed);
    // ai logic for ai units
    if (this.ai_controlled) {
      this.aiLogic(timeElapsed, map);
    }
    if ((this.suppressed() || this.stunned()) && !this.curr_action_unstoppable) {
      this.stopAction();
    }
    // unit action
    switch(this.curr_action) {
      case MOVING:
        switch(this.curr_action_id) {
          case 1: // Anuran Appetite regurgitate
            this.move(timeElapsed, map, MoveModifier.ANURAN_APPETITE);
            if (this.last_move_any_collision) {
              this.stopAction(true);
            }
            break;
          default:
            if (this.using_current_move_stack) {
              if (this.move_stack.empty()) {
                this.using_current_move_stack = false;
                this.face(this.curr_action_x, this.curr_action_y);
              }
              else {
                this.face(this.move_stack.peek().x, this.move_stack.peek().y);
              }
            }
            else {
              this.face(this.curr_action_x, this.curr_action_y);
            }
            this.moveLogic(timeElapsed, map);
            break;
        }
        if (this.distanceFromPoint(this.curr_action_x, this.curr_action_y)
          < this.last_move_distance + Constants.small_number) {
          this.stopAction(true);
        }
        break;
      case CAST_WHEN_IN_RANGE:
        if (this.curr_action_id < 0 || this.curr_action_id >= this.abilities.size()) {
          this.stopAction();
          break;
        }
        Ability a = this.abilities.get(this.curr_action_id);
        if (a == null) {
          this.stopAction();
          break;
        }
        if (this.object_targeting == null || this.object_targeting.remove) {
          this.stopAction();
          break;
        }
        Unit target_unit = (Unit)this.object_targeting;
        if (target_unit.untargetable()) {
          this.stopAction();
        }
        if (!target_unit.targetable(this)) {
          this.stopAction();
          break;
        }
        if (this.distance(target_unit) > a.castsOnTargetRange()) {
          this.face(target_unit);
          this.moveLogic(timeElapsed, map);
        }
        else {
          a.activate(this, map, target_unit);
        }
        break;
      case CASTING:
        if (this.curr_action_id < 0 || this.curr_action_id >= this.abilities.size()) {
          this.stopAction();
          break;
        }
        Ability a_casting = this.abilities.get(this.curr_action_id);
        if (a_casting == null) {
          this.stopAction();
          break;
        }
        switch(a_casting.ID) {
          case 113: // Amphibious Leap
          case 118: // Amphibious Leap II
            this.move(timeElapsed, map, MoveModifier.AMPHIBIOUS_LEAP);
            if (this.last_move_any_collision) {
              a_casting.timer_other = 0;
            }
            break;
          default:
            break;
        }
        break;
      case TARGETING_FEATURE:
      case TARGETING_FEATURE_WITH_ITEM:
        if (this.object_targeting == null || this.object_targeting.remove) {
          this.stopAction();
          break;
        }
        Feature f = (Feature)this.object_targeting;
        if (!f.targetable(this)) {
          this.stopAction();
          break;
        }
        if (this.distance(f) > f.interactionDistance()) {
          if (this.using_current_move_stack) {
            if (this.move_stack.empty()) {
              this.using_current_move_stack = false;
              this.face(f);
            }
            else {
              this.face(this.move_stack.peek().x, this.move_stack.peek().y);
            }
          }
          else {
            this.face(f);
          }
          this.moveLogic(timeElapsed, map);
          break;
        }
        this.face(f);
        if (f.onInteractionCooldown()) {
          break;
        }
        if (this.curr_action == UnitAction.TARGETING_FEATURE_WITH_ITEM) {
          this.curr_action = UnitAction.FEATURE_INTERACTION_WITH_ITEM;
        }
        else {
          this.curr_action = UnitAction.FEATURE_INTERACTION;
        }
        this.timer_actionTime = f.interactionTime();
        break;
      case FEATURE_INTERACTION:
      case FEATURE_INTERACTION_WITH_ITEM:
        if (this.object_targeting == null || this.object_targeting.remove) {
          this.stopAction();
          break;
        }
        this.timer_actionTime -= timeElapsed;
        if (this.timer_actionTime < 0) {
          boolean use_item = this.curr_action == UnitAction.FEATURE_INTERACTION_WITH_ITEM;
          this.curr_action = UnitAction.NONE; // must be before since interact() can set HERO_INTERACTING_WITH_FEATURE
          ((Feature)this.object_targeting).interact(this, map, use_item);
          if (this.curr_action == UnitAction.NONE) {
            this.stopAction();
          }
        }
        break;
      case HERO_INTERACTING_WITH_FEATURE:
      case HERO_INTERACTING_WITH_FEATURE_WITH_ITEM:
        if (this.object_targeting == null || this.object_targeting.remove) {
          this.stopAction();
          break;
        }
        break;
      case TARGETING_UNIT:
        if (this.object_targeting == null || this.object_targeting.remove) {
          this.stopAction();
          break;
        }
        Unit u = (Unit)this.object_targeting;
        if (u.untargetable()) {
          this.stopAction();
        }
        if (!u.targetable(this)) {
          this.stopAction();
          break;
        }
        float distance = this.distance(u);
        if (distance > this.attackRange()) {
          if (this.using_current_move_stack) {
            if (this.move_stack.empty()) {
              this.using_current_move_stack = false;
              this.face(u);
            }
            else {
              this.face(this.move_stack.peek().x, this.move_stack.peek().y);
            }
          }
          else {
            this.face(u);
          }
          this.moveLogic(timeElapsed, map);
        }
        else if (this.timer_attackCooldown <= 0) {
          this.face(u);
          if (this.weapon() != null && this.weapon().shootable()) {
            if (this.weapon().meleeAttackable() && distance < this.attackRange(true)) {
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
          this.stopAction();
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
          this.stopAction();
          break;
        }
        Item i = (Item)this.object_targeting;
        if (!i.targetable(this)) {
          this.stopAction();
          break;
        }
        if (this.distance(i) > i.interactionDistance()) {
          if (this.using_current_move_stack) {
            if (this.move_stack.empty()) {
              this.using_current_move_stack = false;
              this.face(i);
            }
            else {
              this.face(this.move_stack.peek().x, this.move_stack.peek().y);
            }
          }
          else {
            this.face(i);
          }
          this.moveLogic(timeElapsed, map);
        }
        else {
          this.face(i);
          if (this.gear.containsKey(GearSlot.WEAPON)) {
            if (this.weapon() == null) {
              this.gear.put(GearSlot.WEAPON, new Item(i));
              i.remove = true;
              if (!this.ai_controlled) {
                i.pickupSound();
              }
              if (this.map_key == 0) {
                map.selected_object = this.weapon();
              }
            }
            else if (this.weapon().ID == i.ID && this.weapon().maxStack() > this.weapon().stack) {
              int stack_to_pickup = min(this.weapon().maxStack() - this.weapon().stack, i.stack);
              i.removeStack(stack_to_pickup);
              this.weapon().addStack(stack_to_pickup);
              if (!this.ai_controlled) {
                i.pickupSound();
              }
              if (this.map_key == 0) {
                map.selected_object = this.weapon();
              }
            }
          }
          this.stopAction();
        }
        break;
      case ATTACKING:
        if (this.object_targeting == null || this.object_targeting.remove) {
          this.stopAction();
          break;
        }
        Unit unit_attacking = (Unit)this.object_targeting;
        if (unit_attacking.untargetable()) {
          this.stopAction();
        }
        if (this.frozen()) {
          this.stopAction();
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
          this.stopAction();
          break;
        }
        if (this.object_targeting != null) {
          this.face(this.object_targeting);
        }
        this.timer_actionTime -= timeElapsed;
        if (this.timer_actionTime < 0) {
          this.shoot(map);
          if (this.weapon().shootable() && this.weapon().automatic() && global.holding_rightclick) {
            if (this.map_key == 0 && global.holding_ctrl) {
              this.curr_action = UnitAction.AIMING;
            }
            else {
              this.curr_action = UnitAction.TARGETING_UNIT;
            }
          }
          else {
            this.stopAction();
          }
        }
        break;
      case USING_ITEM:
        if (this.weapon() == null || !this.weapon().usable()) {
          this.stopAction();
          break;
        }
        this.timer_actionTime -= timeElapsed;
        if (this.timer_actionTime < 0) {
          this.useItem(map);
          this.stopAction();
        }
        break;
      case MOVING_AND_USING_ITEM:
        if (this.weapon() == null || !this.weapon().usable()) {
          this.curr_action = UnitAction.MOVING;
          break;
        }
        this.timer_actionTime -= timeElapsed;
        if (this.timer_actionTime < 0) {
          this.useItem(map);
          this.curr_action = UnitAction.MOVING;
        }
        if (this.using_current_move_stack) {
          if (this.move_stack.empty()) {
            this.using_current_move_stack = false;
            this.face(this.curr_action_x, this.curr_action_y);
          }
          else {
            this.face(this.move_stack.peek().x, this.move_stack.peek().y);
          }
        }
        else {
          this.face(this.curr_action_x, this.curr_action_y);
        }
        this.moveLogic(timeElapsed, map);
        if (this.distanceFromPoint(this.curr_action_x, this.curr_action_y)
          < this.last_move_distance + Constants.small_number) {
            this.curr_action = UnitAction.USING_ITEM;
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
    // Update status effects
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
            this.stopAction();
          }
          break;
        case CONFUSED:
          se.number -= timeElapsed;
          if (se.number < 0) {
            se.number += random(Constants.status_confused_tickMaxTimer);
            this.moveTo(this.x + Constants.status_confused_maxAmount -
              2 * random(Constants.status_confused_maxAmount), this.y +
              Constants.status_confused_maxAmount - 2 * random(Constants.status_confused_maxAmount), null);
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
        case APOSEMATIC_CAMOUFLAGE:
          if (this.visible()) {
            status_iterator.remove();
            continue;
          }
          for (Map.Entry<Integer, Unit> entryI : map.units.entrySet()) {
            if (entryI.getValue().alliance == this.alliance) {
              continue;
            }
            float distance = this.distance(entryI.getValue());
            if (distance < Constants.ability_111_distance) {
              status_iterator.remove();
              this.addStatusEffect(StatusEffectCode.VISIBLE, 1000);
              continue;
            }
          }
          break;
        case APOSEMATIC_CAMOUFLAGEII:
          if (this.visible()) {
            status_iterator.remove();
            continue;
          }
          for (Map.Entry<Integer, Unit> entryII : map.units.entrySet()) {
            if (entryII.getValue().alliance == this.alliance) {
              continue;
            }
            float distance = this.distance(entryII.getValue());
            if (distance < Constants.ability_116_distance) {
              status_iterator.remove();
              this.addStatusEffect(StatusEffectCode.VISIBLE, 1000);
              continue;
            }
          }
          break;
        default:
          break;
      }
    }
    // Update abilities
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      a.update(timeElapsed, this, map);
    }
    // Cast ability
    if (this.buffer_cast > -1) {
      this.cast(this.buffer_cast, map);
      this.buffer_cast = -1;
    }
    // Resolve location logic
    if (this.floor_height < this.curr_height) {
      if (this.falling) {
        this.timer_falling -= timeElapsed;
        if (this.timer_falling < 0) {
          this.timer_falling += Constants.unit_fallTimer;
          this.fall_amount++;
          this.curr_height--;
          this.resolveFloorHeight(map);
        }
      }
      else {
        this.falling = true;
        this.fall_amount = 0;
        this.timer_falling = Constants.unit_fallTimer;
      }
    }
    else if (this.falling) {
      this.falling = false;
      int no_damage_fall_amount = Constants.unit_noDamageFallHeight + 2 * this.agility();
      if (this.fall_amount > no_damage_fall_amount) { // removed until 3rd dimension visible
        //this.calculateDotDamage(Constants.unit_fallDamageMultiplier * (this.fall_amount - no_damage_fall_amount), true);
        //global.sounds.trigger_units("player/fall", this.x - map.viewX, this.y - map.viewY);
      }
      this.fall_amount = 0;
    }
    else {
      for (IntegerCoordinate coordinate : this.curr_squares_on) {
        try {
          switch(map.squares[coordinate.x][coordinate.y].terrain_id) {
            case 181: // Very Shallow Water
            case 182:
              break;
            case 183: // Shallow Water
              this.refreshStatusEffect(StatusEffectCode.DRENCHED, 1000);
              break;
            case 184: // Medium Water
              this.refreshStatusEffect(StatusEffectCode.DRENCHED, 2000);
              if (this.swimNumber() < 1) {
                this.refreshStatusEffect(StatusEffectCode.DROWNING, 100);
              }
              break;
            case 185: // Deep Water
              this.refreshStatusEffect(StatusEffectCode.DRENCHED, 3000);
              if (this.swimNumber() < 2) {
                this.refreshStatusEffect(StatusEffectCode.DROWNING, 100);
              }
              break;
            case 191: // Lava
              this.refreshStatusEffect(StatusEffectCode.BURNT, 4000);
              this.refreshStatusEffect(StatusEffectCode.CHARRED, 1000);
              this.calculateDotDamage(timeElapsed * 0.00015, true);
              this.damage(null, timeElapsed * 0.01);
              break;
            default:
              break;
          }
        } catch(ArrayIndexOutOfBoundsException e) {}
      }
      if (this.timer_resolve_floor_height < 0) {
        this.timer_resolve_floor_height += Constants.unit_timer_resolve_floor_height_cooldown;
        this.resolveFloorHeight(map);
      }
    }
  }

  // timers independent of curr action
  void update(int time_elapsed) {
    if (this.timer_last_damage > 0) {
      this.timer_last_damage -= time_elapsed;
    }
    if (this.timer_attackCooldown > 0) {
      if (this.frozen()) {
        this.timer_attackCooldown = this.attackCooldown();
      }
      else if (this.chilled()) {
        if (this.element == Element.CYAN) {
          this.timer_attackCooldown -= time_elapsed * Constants.status_chilled_cooldownMultiplierCyan;
        }
        else {
          this.timer_attackCooldown -= time_elapsed * Constants.status_chilled_cooldownMultiplier;
        }
      }
      else {
        this.timer_attackCooldown -= time_elapsed;
      }
    }
    this.timer_resolve_floor_height -= time_elapsed;
    this.timer_target_sound -= time_elapsed;
    this.timer_talk -= time_elapsed;
    if (this.timer_talk < 0) {
      this.timer_talk += Constants.unit_timer_talk + int(random(Constants.unit_timer_talk));
      this.talkSound();
    }
    this.healPercent(this.passiveHeal() * time_elapsed * 0.001, true);
    this.updateItems();
  }

  void updateItems() {
    for (Map.Entry<GearSlot, Item> entry : this.gear.entrySet()) {
      if (entry.getValue() == null) {
        continue;
      }
      switch(entry.getKey()) {
        case WEAPON:
          switch(entry.getValue().ID) {
            case 2928: // cigar
              if (entry.getValue().toggled) {
                this.refreshStatusEffect(StatusEffectCode.RELAXED, 2500);
              }
              break;
            default:
              break;
          }
          break;
        default:
          break;
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
    if (!this.ai_controlled) {
      global.sounds.trigger_player("player/drop", this.x - map.viewX, this.y - map.viewY);
    }
  }

  float frontX() {
    return this.x + this.facingX * this.xRadius() - 0.5 * this.facingY * this.xRadius();
  }

  float frontY() {
    return this.y + 0.5 * this.facingX * this.yRadius() + this.facingY * this.yRadius();
  }


  void target(MapObject object, GameMap map) {
    this.target(object, map, false);
  }
  void target(MapObject object, GameMap map, boolean use_item) {
    if (object == null) {
      return;
    }
    if (this.object_targeting == object) {
      return;
    }
    this.object_targeting = object;
    if (Feature.class.isInstance(this.object_targeting)) {
      if (this.weapon() != null && use_item) {
        this.curr_action = UnitAction.TARGETING_FEATURE_WITH_ITEM;
      }
      else {
        this.curr_action = UnitAction.TARGETING_FEATURE;
      }
    }
    else if (Unit.class.isInstance(this.object_targeting)) {
      this.curr_action = UnitAction.TARGETING_UNIT;
      this.targetSound();
    }
    else if (Item.class.isInstance(this.object_targeting)) {
      this.curr_action = UnitAction.TARGETING_ITEM;
    }
    else {
      this.curr_action = UnitAction.NONE;
      return;
    }
    if (map != null) {
      this.startPathfindingThread(object.xCenter(), object.yCenter(), map);
    }
  }


  // Aim at mouse
  void aim(float targetX, float targetY) {
    this.curr_action = UnitAction.AIMING;
    this.object_targeting = null;
    this.curr_action_x = targetX;
    this.curr_action_y = targetY;
  }


  void restartAbilityTimers() {
    for (Ability a : this.abilities) {
      if (a != null) {
        a.timer_cooldown = 0;
      }
    }
  }

  // Cast ability
  void bufferCast(int index) {
    if (index < 0 || index >= this.abilities.size()) {
      return;
    }
    Ability a = this.abilities.get(index);
    if (a == null) {
      return;
    }
    this.buffer_cast = index;
  }

  void cast(int index, GameMap map) {
    this.cast(index, map, null);
  }
  void cast(int index , GameMap map, MapObject secondary_target) {
    this.cast(index, map, secondary_target, false);
  }
  void cast(int index , GameMap map, MapObject secondary_target, boolean player_casting) {
    if (this.suppressed() || this.stunned() || this.silenced()) {
      return;
    }
    if (index < 0 || index >= this.abilities.size()) {
      return;
    }
    Ability a = this.abilities.get(index);
    if (a == null) {
      return;
    }
    if (a.timer_cooldown > 0) {
      return;
    }
    if (a.checkMana()) {
      if (a.manaCost() > this.currMana()) {
        if (player_casting) {
          map.addHeaderMessage("Not enough mana");
        }
        return;
      }
    }
    if (a.castsOnTarget()) {
      if (this.object_targeting == null) {
        if (secondary_target == null) {
          return;
        }
        else {
          this.object_targeting = secondary_target;
        }
      }
      if (!Unit.class.isInstance(this.object_targeting)) {
        return;
      }
      Unit u = (Unit)this.object_targeting;
      if (this.distance(u) > a.castsOnTargetRange()) {
        this.curr_action = UnitAction.CAST_WHEN_IN_RANGE;
        this.curr_action_id = index;
        return;
      }
      this.curr_action_id = index;
      if (this.map_key == 0) {
        this.curr_action_x = map.mX;
        this.curr_action_y = map.mY;
      }
      if (a.turnsCaster()) {
        this.face(u);
      }
      a.activate(this, map, u);
    }
    else {
      this.curr_action_id = index;
      if (this.map_key == 0) {
        this.curr_action_x = map.mX;
        this.curr_action_y = map.mY;
      }
      if (a.turnsCaster()) {
        if (this.object_targeting != null && this.ai_controlled) {
          this.face(this.object_targeting);
        }
        else if (!this.ai_controlled && this.map_key == 0) {
          this.face(map.mX, map.mY);
        }
      }
      a.activate(this, map);
    }
  }


  // Shoot projectile
  void shoot(GameMap map) {
    if (this.weapon() == null || !this.weapon().shootable()) {
      return;
    }
    map.addProjectile(new Projectile(this.weapon().ID + 1000, this, this.weapon().shootInaccuracy()));
    switch(this.weapon().ID) {
      case 2118: // Chicken Egg
        global.sounds.trigger_units("items/throw", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2301: // Slingshot
        global.sounds.trigger_units("items/slingshot", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2311: // Recurve Bow
        global.sounds.trigger_units("items/recurve_bow", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2312: // M1911
        global.sounds.trigger_units("items/m1911", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2321: // War Machine
      case 2342:
      case 2331:
        global.sounds.trigger_units("items/war_machine", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2322: // Five-Seven
      case 2343:
        global.sounds.trigger_units("items/five_seven", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2323: // Type25
      case 2344:
        global.sounds.trigger_units("items/type25", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2332: // FAL
        global.sounds.trigger_units("items/FAL", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2333: // Python
      case 2354:
        global.sounds.trigger_units("items/python", this.x - map.viewX, this.y - map.viewY);
      case 2341: // RPG
      case 2362:
        global.sounds.trigger_units("items/RPG", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2345: // Executioner
      case 2364:
        global.sounds.trigger_units("items/executioner", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2351: // Galil
      case 2373:
        global.sounds.trigger_units("items/galil", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2353: // Ballistic Knife
      case 2374:
        global.sounds.trigger_units("items/ballistic_knife", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2352: // WN
        Projectile burst1 = new Projectile(this.weapon().ID + 1000, this, this.weapon().shootInaccuracy());
        Projectile burst2 = new Projectile(this.weapon().ID + 1000, this, this.weapon().shootInaccuracy());
        burst1.x -= 0.05 * this.facingX;
        burst1.y -= 0.05 * this.facingY;
        burst2.x -= 0.1 * this.facingX;
        burst2.y -= 0.1 * this.facingY;
        map.addProjectile(burst1);
        map.addProjectile(burst2);
        global.sounds.trigger_units("items/FAL", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2355: // MTAR
      case 2375:
        global.sounds.trigger_units("items/MTAR", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2361: // RPD
      case 2381: // Relativistic Punishment Device
        global.sounds.trigger_units("items/RPD", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2363: // DSR-50
      case 2382:
        global.sounds.trigger_units("items/DSR50", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2371: // HAMR
      case 2391:
        global.sounds.trigger_units("items/HAMR", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2372: // Ray Gun
        global.sounds.trigger_units("items/ray_gun", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2392: // Porter's X2 Ray Gun
        global.sounds.trigger_units("items/porters_x2_ray_gun", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2924: // Glass Bottle
      case 2931: // Rock
      case 2932: // Arrow
      case 2933: // Pebble
        global.sounds.trigger_units("items/throw", this.x - map.viewX, this.y - map.viewY);
        break;
      case 2944: // Grenade
        global.sounds.trigger_units("items/grenade_throw", this.x - map.viewX, this.y - map.viewY);
        break;
      default:
        break;
    }
    this.weapon().shot();
    this.move(this.weapon().shootRecoil(), map, MoveModifier.RECOIL);
    this.timer_attackCooldown = this.attackCooldown();
  }


  // Auto attack
  void attack(Unit u) {
    float power = attack();
    if (this.aposematicCamouflage()) {
      power *= Constants.ability_111_powerBuff;
      this.removeStatusEffect(StatusEffectCode.APOSEMATIC_CAMOUFLAGE);
    }
    if (this.aposematicCamouflageII()) {
      power *= Constants.ability_116_powerBuff;
      this.removeStatusEffect(StatusEffectCode.APOSEMATIC_CAMOUFLAGEII);
    }
    u.damage(this, u.calculateDamageFrom(this, power, DamageType.PHYSICAL, this.element));
    this.timer_attackCooldown = this.attackCooldown(true);
    this.attackSound();
    if (this.weapon() != null) {
      this.weapon().attacked();
    }
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
      this.deathSound();
    }
    else if (source != null) {
      this.damagedSound();
    }
    this.last_damage_from = source;
    if (source != null) {
      source.damaged(this, amount);
      if (this.remove) {
        source.killed(this);
      }
    }
    if (this.headgear() != null) {
      this.headgear().lowerDurability();
    }
    if (this.chestgear() != null) {
      this.chestgear().lowerDurability();
    }
    if (this.leggear() != null) {
      this.leggear().lowerDurability();
    }
    if (this.footgear() != null) {
      this.footgear().lowerDurability();
    }
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        case 101: // Fearless Leader I
          if (this.rageOfTheBenII()) {
            this.increaseMana(int(Constants.ability_101_rageGain * Constants.ability_110_rageGainBonus));
          }
          else if (this.rageOfTheBen()) {
            this.increaseMana(int(Constants.ability_101_rageGain * Constants.ability_105_rageGainBonus));
          }
          else {
            this.increaseMana(Constants.ability_101_rageGain);
          }
          a.timer_other = Constants.ability_101_cooldownTimer;
          break;
        case 106: // Fearless Leader II
          if (this.rageOfTheBenII()) {
            this.increaseMana(int(Constants.ability_106_rageGain * Constants.ability_110_rageGainBonus));
          }
          else if (this.rageOfTheBen()) {
            this.increaseMana(int(Constants.ability_106_rageGain * Constants.ability_105_rageGainBonus));
          }
          else {
            this.increaseMana(Constants.ability_106_rageGain);
          }
          a.timer_other = Constants.ability_106_cooldownTimer;
          break;
        default:
          break;
      }
    }
    if (this.ai_controlled) {
      switch(this.ID) {
        case 1001: // Target Dummy
          if (source == null) {
            this.description += "\n" + amount + " damage.";
          }
          else {
            this.description += "\n" + amount + " damage from " + source.display_name() + ".";
          }
          break;
        case 1002: // Chicken
        case 1003: // Chick
          if (source == null) {
            this.faceRandom();
          }
          else {
            this.faceAway(source);
          }
          this.addStatusEffect(StatusEffectCode.RUNNING, 3000);
          this.moveForward(4, null);
          this.ai_toggle = true;
          this.timer_ai_action3 = 300;
          break;
        case 1005: // Rooster
          if (source != null) {
            this.target(source, null);
            this.addStatusEffect(StatusEffectCode.RUNNING, 3000);
          }
          break;
        case 1201: // Tier I Zombie
        case 1202:
        case 1203:
        case 1204:
        case 1205:
        case 1206:
        case 1207:
        case 1208:
        case 1209:
        case 1210:
        case 1291: // Auto-spawned Zombies
        case 1292:
        case 1293:
        case 1301: // Tier I named zombies
        case 1302:
        case 1303:
        case 1304:
        case 1305:
        case 1306:
        case 1307:
          if (source != null && (this.curr_action == UnitAction.NONE || this.last_move_collision)) {
            this.target(source, null);
          }
          break;
        default:
          break;
      }
    }
    this.timer_last_damage = Constants.unit_healthbarDamageAnimationTime;
    this.last_damage_amount = last_health - this.curr_health;
  }


  void damaged(Unit u, float damage) {
    this.heal(max(0, this.lifesteal() * damage), false);
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        case 101: // Fearless Leader I
          if (this.rageOfTheBenII()) {
            this.increaseMana(int(Constants.ability_101_rageGain * Constants.ability_110_rageGainBonus));
          }
          else if (this.rageOfTheBen()) {
            this.increaseMana(int(Constants.ability_101_rageGain * Constants.ability_105_rageGainBonus));
          }
          else {
            this.increaseMana(Constants.ability_101_rageGain);
          }
          a.timer_other = Constants.ability_101_cooldownTimer;
          break;
        case 106: // Fearless Leader II
          if (this.rageOfTheBenII()) {
            this.increaseMana(int(Constants.ability_106_rageGain * Constants.ability_110_rageGainBonus));
          }
          else if (this.rageOfTheBen()) {
            this.increaseMana(int(Constants.ability_106_rageGain * Constants.ability_105_rageGainBonus));
          }
          else {
            this.increaseMana(Constants.ability_106_rageGain);
          }
          a.timer_other = Constants.ability_106_cooldownTimer;
          break;
        default:
          break;
      }
    }
  }


  void killed(Unit u) {
    for (Ability a : this.abilities) {
      if (a == null) {
        continue;
      }
      switch(a.ID) {
        case 101: // Fearless Leader I
          if (this.rageOfTheBenII()) {
            this.increaseMana(int(Constants.ability_101_rageGainKill * Constants.ability_110_rageGainBonus));
          }
          else if (this.rageOfTheBen()) {
            this.increaseMana(int(Constants.ability_101_rageGainKill * Constants.ability_105_rageGainBonus));
          }
          else {
            this.increaseMana(Constants.ability_101_rageGainKill);
          }
          a.timer_other = Constants.ability_101_cooldownTimer;
          break;
        case 106: // Fearless Leader II
          if (this.rageOfTheBenII()) {
            this.increaseMana(int(Constants.ability_106_rageGainKill * Constants.ability_110_rageGainBonus));
          }
          else if (this.rageOfTheBen()) {
            this.increaseMana(int(Constants.ability_106_rageGainKill * Constants.ability_105_rageGainBonus));
          }
          else {
            this.increaseMana(Constants.ability_106_rageGainKill);
          }
          a.timer_other = Constants.ability_106_cooldownTimer;
          break;
        case 113: // Amphibious Leap I
          a.timer_cooldown *= Constants.ability_113_killCooldownReduction;
          break;
        case 118: // Amphibious Leap II
          a.timer_cooldown *= Constants.ability_118_killCooldownReduction;
          break;
        default:
          break;
      }
    }
    this.killSound();
  }


  void destroy(GameMap map) {
    for (Item i : this.drops()) {
      map.addItem(i, this.x + this.size - random(this.size), this.y + this.size - random(this.size));
    }
    for (Map.Entry<GearSlot, Item> entry : this.gear.entrySet()) {
      this.gear.put(entry.getKey(), null);
    }
    this.statuses.clear();
    this.stopAction();
    this.restartAbilityTimers();
  }


  ArrayList<Item> drops() {
    ArrayList<Item> drops = new ArrayList<Item>();
    switch(this.ID) {
      case 1002: // Chicken
        if (randomChance(0.5)) {
          drops.add(new Item(2116));
        }
        if (randomChance(0.5)) {
          drops.add(new Item(2807));
        }
        break;
      case 1005: // Rooster
        if (randomChance(0.7)) {
          drops.add(new Item(2116));
        }
        if (randomChance(0.7)) {
          drops.add(new Item(2807));
        }
        if (randomChance(0.25)) {
          drops.add(new Item(2807));
        }
        break;
      case 1004: // John Rankin
        drops.add(new Item(2991));
        break;
      case 1006: // Father Dom
        drops.add(new Item(2988));
        drops.add(new Item(2928));
        break;
      case 1201: // Tier I zombies
      case 1202:
      case 1203:
      case 1204:
      case 1205:
      case 1206:
      case 1207:
      case 1208:
      case 1209:
      case 1291: // Auto-spawned Zombies
        if (randomChance(0.2)) {
          drops.add(new Item(2119));
        }
        break;
      case 1292:
        if (randomChance(0.2)) {
          drops.add(new Item(2119));
        }
        break;
      case 1293:
        if (randomChance(0.2)) {
          drops.add(new Item(2119));
        }
        break;
      case 1210:
        if (randomChance(0.2)) {
          drops.add(new Item(2119));
        }
        if (randomChance(0.15)) {
          drops.add(new Item(2912));
        }
        if (randomChance(0.15)) {
          drops.add(new Item(2913));
        }
        break;
      default:
        break;
    }
    for (Map.Entry<GearSlot, Item> entry : this.gear.entrySet()) {
      if (entry.getValue() != null) {
        drops.add(entry.getValue());
      }
    }
    return drops;
  }


  void healPercent(float amount, boolean max_heath) {
    if (max_heath) {
      this.heal(amount * this.health());
    }
    else {
      this.heal(amount * (this.health() - this.curr_health));
    }
  }
  void heal(float amount) {
    this.heal(amount, false);
  }
  void heal(float amount, boolean overheal) {
    this.curr_health += amount;
    if (this.curr_health < 0) {
      this.curr_health = 0;
    }
    if (!overheal && this.curr_health > this.health()) {
      this.curr_health = this.health();
    }
  }

  void changeHealth(float amount) {
    this.setHealth(this.curr_health + amount);
  }
  void setHealth(float amount) {
    this.curr_health = amount;
    if (this.curr_health <= 0) {
      this.curr_health = 0;
      this.remove = true;
    }
    if (this.curr_health > this.health()) {
      this.curr_health = this.health();
    }
  }


  void stopAction() {
    this.stopAction(false);
  }
  void stopAction(boolean forceStop) {
    if (!forceStop && this.curr_action_unstoppable && this.curr_action != UnitAction.NONE) {
      return;
    }
    this.curr_action = UnitAction.NONE;
    this.curr_action_x = this.x;
    this.curr_action_y = this.y;
    this.object_targeting = null;
    this.last_move_collision = false;
    this.last_move_any_collision = false;
    this.curr_action_unhaltable = false;
    this.curr_action_unstoppable = false;
    this.curr_action_id = 0;
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

  void faceRandom() {
    this.setFacing(random(1), random(1));
  }
  void face(MapObject object) {
    this.face(object.xCenter(), object.yCenter());
  }
  void faceAway(MapObject object) {
    this.faceAway(object.xCenter(), object.yCenter());
  }
  void face(float faceX, float faceY) {
    this.setFacing(faceX - this.x, faceY - this.y);
  }
  void faceAway(float faceX, float faceY) {
    this.setFacing(this.x - faceX, this.y - faceY);
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
    if (normConstant == 0.0) {
      return; // happens when exactly on target location
    }
    this.facingX = facingX / normConstant;
    this.facingY = facingY / normConstant;
    this.facingA = (float)Math.atan2(this.facingY, this.facingX);
  }

  float facingAngleModifier() {
    switch(this.curr_action) {
      case ATTACKING:
        return Constants.unit_attackAnimationAngle(1 - this.timer_actionTime / this.attackTime(true));
      case CASTING:
        if (this.curr_action_id < 0 || this.curr_action_id >= this.abilities.size()) {
          break;
        }
        Ability a_casting = this.abilities.get(this.curr_action_id);
        if (a_casting == null) {
          break;
        }
        switch(a_casting.ID) {
          case 1002: // Condom Throw
            return 2 * PI * (1.0 - a_casting.timer_other / Constants.ability_1002_castTime);
          default:
            break;
        }
        break;
      default:
        return 0;
    }
    return 0;
  }


  void jump(GameMap map) {
    this.resolveFloorHeight(map);
    if (!this.falling && this.curr_height == this.floor_height) {
      this.curr_height += this.jumpHeight();
      this.falling = true;
    }
    this.resolveFloorHeight(map);
  }

  int jumpHeight() {
    switch(this.agility()) {
      case 0:
        return 0;
      case 1:
        return 2;
      case 2:
        return 3;
      case 3:
        return 4;
      case 4:
        return 5;
      case 5:
        return 6;
    }
    return 0;
  }

  int walkHeight() {
    if (this.falling) {
      return 0;
    }
    switch(this.agility()) {
      case 0:
        return 0;
      case 1:
        return 1;
      case 2:
        return 1;
      case 3:
        return 2;
      case 4:
        return 2;
      case 5:
        return 2;
    }
    return 0;
  }


  void walkSound(int terrain_id) {
    if (!this.in_view || this.last_move_collision) {
      return;
    }
    // custom walk sounds
    switch(this.ID) {
      case 1001: // Target Dummy
        return;
      case 1002: // Chicken
      case 1003: // Chick
      case 1005: // Rooster
        global.sounds.trigger_units("units/walk/chicken");
        return;
      default:
        break;
    }
    // default walk sounds
    switch(terrain_id) {
      case 111:
      case 112:
      case 113:
        global.sounds.trigger_units("player/walk_wood");
        break;
      case 121:
      case 122:
      case 123:
      case 131:
      case 132:
      case 133:
      case 171:
      case 172:
      case 173:
      case 174:
      case 175:
      case 176:
      case 177:
      case 178:
      case 179:
        global.sounds.trigger_units("player/walk_hard");
        break;
      case 134:
        global.sounds.trigger_units("player/walk_gravel");
        break;
      case 141:
      case 142:
      case 143:
      case 144:
      case 145:
        global.sounds.trigger_units("player/walk_sand");
        break;
      case 151:
      case 152:
      case 153:
      case 154:
      case 155:
      case 156:
        global.sounds.trigger_units("player/walk_grass");
        break;
      case 161:
      case 162:
      case 163:
        global.sounds.trigger_units("player/walk_dirt");
        break;
      case 181:
      case 182:
        global.sounds.trigger_units("player/walk_water_very_shallow");
        break;
      case 183:
        global.sounds.trigger_units("player/walk_water_shallow");
        break;
      case 184:
        global.sounds.trigger_units("player/walk_water_medium");
        break;
      case 185:
        global.sounds.trigger_units("player/walk_water_deep");
        break;
      default:
        global.sounds.trigger_units("player/walk_stone");
        break;
    }
  }

  void talkSound() {
    if (!this.in_view) {
      return;
    }
    String sound_name = "units/talk/";
    switch(this.ID) {
      case 1002: // Chicken
      case 1003: // Chick
      case 1005: // Rooster
        sound_name += "chicken" + randomInt(1, 3);
        break;
      case 1201: // Zombies
      case 1202:
      case 1203:
      case 1204:
      case 1205:
      case 1206:
      case 1207:
      case 1208:
      case 1209:
      case 1210:
      case 1291: // Auto-spawned Zombies
      case 1292:
      case 1293:
      case 1301: // Named Zombies
      case 1302:
      case 1303:
      case 1304:
      case 1305:
      case 1306:
      case 1307:
      case 1308:
        sound_name += "zombie" + randomInt(0, 5);
        break;
      default:
        return;
    }
    global.sounds.trigger_units(sound_name);
  }

  void targetSound() {
    if (!this.in_view) {
      return;
    }
    if (this.timer_target_sound > 0) {
      return;
    }
    if (this.ai_controlled) {
      this.timer_target_sound = 2 * Constants.unit_timer_target_sound + 2 * round(random(Constants.unit_timer_target_sound));
    }
    else {
      this.timer_target_sound = Constants.unit_timer_target_sound + round(random(Constants.unit_timer_target_sound));
    }
    String sound_name = "units/target/";
    switch(this.ID) {
      case 1201: // Zombies
      case 1202:
      case 1203:
      case 1204:
      case 1205:
      case 1206:
      case 1207:
      case 1208:
      case 1209:
      case 1210:
      case 1291: // Auto-spawned Zombies
      case 1292:
      case 1293:
      case 1301: // Named Zombies
      case 1302:
      case 1303:
      case 1304:
      case 1305:
      case 1306:
      case 1307:
      case 1308:
        sound_name += "zombie" + randomInt(0, 8);
        break;
      default:
        return;
    }
    global.sounds.trigger_units(sound_name);
  }

  void attackSound() {
    if (!this.in_view) {
      return;
    }
    if (this.weapon() != null) {
      this.weapon().attackSound();
      return;
    }
    String sound_name = "units/attack/";
    switch(this.ID) {
      case 1201: // Zombies
      case 1202:
      case 1203:
      case 1204:
      case 1205:
      case 1206:
      case 1207:
      case 1208:
      case 1209:
      case 1210:
      case 1291: // Auto-spawned Zombies
      case 1292:
      case 1293:
      case 1301: // Named Zombies
      case 1302:
      case 1303:
      case 1304:
      case 1305:
      case 1306:
      case 1307:
      case 1308:
        sound_name += "zombie" + randomInt(0, 15);
        break;
      case 1311:
        sound_name += "heck" + randomInt(1, 5);
        break;
      default:
        sound_name += "default";
        break;
    }
    global.sounds.trigger_units(sound_name);
  }

  void damagedSound() {
    if (!this.in_view) {
      return;
    }
    String sound_name = "units/damaged/";
    switch(this.ID) {
      case 1002: // Chicken
      case 1003: // Chick
      case 1005: // Rooster
        sound_name += "chicken" + randomInt(1, 2);
        break;
      case 1201: // Zombies
      case 1202:
      case 1203:
      case 1204:
      case 1205:
      case 1206:
      case 1207:
      case 1208:
      case 1209:
      case 1210:
      case 1291: // Auto-spawned Zombies
      case 1292:
      case 1293:
      case 1301: // Named Zombies
      case 1302:
      case 1303:
      case 1304:
      case 1305:
      case 1306:
      case 1307:
      case 1308:
        sound_name += "zombie" + randomInt(0, 11);
        break;
      default:
        return;
    }
    global.sounds.trigger_units(sound_name);
  }

  void deathSound() {
    if (!this.in_view) {
      return;
    }
    String sound_name = "units/death/";
    switch(this.ID) {
      case 1002: // Chicken
      case 1003: // Chick
      case 1005: // Rooster
        sound_name += "chicken" + randomInt(1, 2);
        break;
      case 1201: // Zombies
      case 1202:
      case 1203:
      case 1204:
      case 1205:
      case 1206:
      case 1207:
      case 1208:
      case 1209:
      case 1210:
      case 1291: // Auto-spawned Zombies
      case 1292:
      case 1293:
      case 1301: // Named Zombies
      case 1302:
      case 1303:
      case 1304:
      case 1305:
      case 1306:
      case 1307:
      case 1308:
        sound_name += "zombie" + randomInt(0, 10);
        break;
      default:
        return;
    }
    global.sounds.trigger_units(sound_name);
  }

  void killSound() {
    if (!this.in_view) {
      return;
    }
    String sound_name = "units/kill/";
    switch(this.ID) {
      case 1201: // Zombies
      case 1202:
      case 1203:
      case 1204:
      case 1205:
      case 1206:
      case 1207:
      case 1208:
      case 1209:
      case 1210:
      case 1291: // Auto-spawned Zombies
      case 1292:
      case 1293:
      case 1301: // Named Zombies
      case 1302:
      case 1303:
      case 1304:
      case 1305:
      case 1306:
      case 1307:
      case 1308:
        sound_name += "zombie" + randomInt(0, 6);
        break;
      default:
        return;
    }
    global.sounds.trigger_units(sound_name);
  }

  void tauntSound() {
    if (!this.in_view) {
      return;
    }
    String sound_name = "units/taunt/";
    switch(this.ID) {
      case 1101: // Ben Nelson
        break;
      case 1102: // Dan Gray
        break;
      default:
        return;
    }
    global.sounds.trigger_units(sound_name);
  }


  void moveForward(float distance, GameMap map) {
    this.moveTo(this.x + this.facingX * distance, this.y + this.facingY * distance, map);
  }

  void moveTo(float targetX, float targetY, GameMap map) {
    if (this.curr_action == UnitAction.USING_ITEM || this.curr_action == UnitAction.MOVING_AND_USING_ITEM) {
      this.curr_action = UnitAction.MOVING_AND_USING_ITEM;
    }
    else {
      this.curr_action = UnitAction.MOVING;
    }
    if (map != null) {
      this.startPathfindingThread(targetX, targetY, map);
    }
    this.object_targeting = null;
    this.last_move_collision = false;
    this.last_move_any_collision = false;
    this.curr_action_x = targetX;
    this.curr_action_y = targetY;
    this.curr_action_id = 0;
  }

  void move(float timeElapsed, GameMap map, MoveModifier modifier) {
    // remove camouflage
    if (this.aposematicCamouflage()) {
      this.removeStatusEffect(StatusEffectCode.APOSEMATIC_CAMOUFLAGE);
    }
    if (this.aposematicCamouflageII()) {
      this.removeStatusEffect(StatusEffectCode.APOSEMATIC_CAMOUFLAGEII);
    }
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
        effectiveDistance = -timeElapsed; // just use timeElapsed as the distance
        break;
      case AMPHIBIOUS_LEAP:
        effectiveDistance = Constants.ability_113_jumpSpeed * seconds;
        this.curr_height += Constants.ability_113_jumpHeight;
        break;
      case ANURAN_APPETITE:
        effectiveDistance = Constants.ability_115_regurgitateSpeed * seconds;
        break;
    }
    float tryMoveX = effectiveDistance * this.facingX;
    float tryMoveY = effectiveDistance * this.facingY;
    float startX = this.x;
    float startY = this.y;
    this.last_move_collision = false;
    this.last_move_any_collision = false;
    // move in x direction
    this.moveX(tryMoveX, tryMoveY, map);
    // move in y direction
    this.moveY(tryMoveX, tryMoveY, map);
    // calculates squares_on and height
    this.curr_squares_on = this.getSquaresOn();
    this.resolveFloorHeight(map);
    this.timer_resolve_floor_height = Constants.unit_timer_resolve_floor_height_cooldown;
    // move stat
    float moveX = this.x - startX;
    float moveY = this.y - startY;
    this.last_move_distance = sqrt(moveX * moveX + moveY * moveY);
    this.footgear_durability_distance -= this.last_move_distance;
    if (this.footgear_durability_distance < 0) {
      this.footgear_durability_distance += Constants.unit_footgearDurabilityDistance;
      if (this.footgear() != null) {
        this.footgear().lowerDurability();
      }
    }
  }

  void moveX(float tryMoveX, float tryMoveY, GameMap map) {
    if (tryMoveX == 0) {
      return;
    }
    float originalTryMoveX = tryMoveX;
    float moveCapRatio = Constants.map_moveLogicCap / tryMoveX;
    float equivalentMoveY = moveCapRatio * tryMoveY;
    while(abs(tryMoveX) > Constants.map_moveLogicCap) {
      if (tryMoveX > 0) {
        if (this.collisionLogicX(Constants.map_moveLogicCap, equivalentMoveY, map)) {
          this.last_move_collision = true;
          this.last_move_any_collision = true;
          return;
        }
        tryMoveX -= Constants.map_moveLogicCap;
      }
      else {
        if (this.collisionLogicX(-Constants.map_moveLogicCap, -equivalentMoveY, map)) {
          this.last_move_collision = true;
          this.last_move_any_collision = true;
          return;
        }
        tryMoveX += Constants.map_moveLogicCap;
      }
    }
    moveCapRatio = tryMoveX / originalTryMoveX;
    equivalentMoveY = moveCapRatio * tryMoveY;
    if (this.collisionLogicX(tryMoveX, equivalentMoveY, map)) {
      this.last_move_collision = true;
      this.last_move_any_collision = true;
      return;
    }
    if (abs(this.facingX) < Constants.unit_small_facing_threshhold) {
      this.last_move_collision = true;
      this.last_move_any_collision = true;
    }
  }

  void moveY(float tryMoveX, float tryMoveY, GameMap map) {
    if (tryMoveY == 0) {
      return;
    }
    float originalTryMoveY = tryMoveY;
    float moveCapRatio = Constants.map_moveLogicCap / tryMoveY;
    float equivalentMoveX = moveCapRatio * tryMoveX;
    while(abs(tryMoveY) > Constants.map_moveLogicCap) {
      if (tryMoveY > 0) {
        if (this.collisionLogicY(Constants.map_moveLogicCap, equivalentMoveX, map)) {
          this.last_move_any_collision = true;
          return;
        }
        tryMoveY -= Constants.map_moveLogicCap;
      }
      else {
        if (this.collisionLogicY(-Constants.map_moveLogicCap, equivalentMoveX, map)) {
          this.last_move_any_collision = true;
          return;
        }
        tryMoveY += Constants.map_moveLogicCap;
      }
    }
    moveCapRatio = tryMoveY / originalTryMoveY;
    equivalentMoveX = moveCapRatio * tryMoveX;
    if (this.collisionLogicY(tryMoveY, equivalentMoveX, map)) {
      this.last_move_any_collision = true;
      return;
    }
    if (abs(this.facingY) > Constants.unit_small_facing_threshhold) {
      this.last_move_collision = false;
    }
  }

  // returns true if collision occurs
  boolean collisionLogicX(float tryMoveX, float equivalentMoveY, GameMap map) {
    float startX = this.x;
    this.x += tryMoveX;
    // map collisions
    if (!this.inMapX(map.mapWidth)) {
      this.x = startX;
      return true;
    }
    if (this.ghosting()) {
      return false;
    }
    // terrain collisions
    ArrayList<IntegerCoordinate> squares_moving_on = this.getSquaresOn();
    int max_height = this.curr_height + this.walkHeight();
    for (IntegerCoordinate coordinate : squares_moving_on) {
      int coordinate_height = map.heightOfSquare(coordinate, true);
      if (coordinate_height <= max_height) {
        continue;
      }
      if (!this.currentlyOn(coordinate)) {
        this.x = startX;
        return true;
      }
      float s_x = coordinate.x + 0.5;
      if ( (this.x > s_x && this.facingX > 0) || (this.x < s_x && this.facingX < 0) ) {
        continue;
      }
      float s_y = coordinate.y + 0.5;
      float original_xDif = s_x - startX;
      float original_yDif = s_y - this.y;
      float original_distance = sqrt(original_xDif * original_xDif + original_yDif * original_yDif);
      float new_xDif = s_x - this.x;
      float new_yDif = s_y - this.y - equivalentMoveY;
      float new_distance = sqrt(new_xDif * new_xDif + new_yDif * new_yDif);
      if (new_distance > original_distance) {
        continue;
      }
      this.x = startX;
      return true;
    }
    // unit collisions
    for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
      if (entry.getKey() == this.map_key) {
        continue;
      }
      Unit u = entry.getValue();
      if (u.uncollidable()) {
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
  boolean collisionLogicY(float tryMoveY, float equivalentMoveX, GameMap map) {
    float startY = this.y;
    this.y += tryMoveY;
    // map collisions
    if (!this.inMapY(map.mapHeight)) {
      this.y = startY;
      return true;
    }
    if (this.ghosting()) {
      return false;
    }
    // terrain collisions
    ArrayList<IntegerCoordinate> squares_moving_on = this.getSquaresOn();
    int max_height = this.curr_height + this.walkHeight();
    for (IntegerCoordinate coordinate : squares_moving_on) {
      int coordinate_height = map.heightOfSquare(coordinate, true);
      if (coordinate_height <= max_height) {
        continue;
      }
      if (!this.currentlyOn(coordinate)) {
        this.y = startY;
        return true;
      }
      float s_y = coordinate.y + 0.5;
      if ( (this.y > s_y && this.facingY > 0) || (this.y < s_y && this.facingY < 0) ) {
        continue;
      }
      float s_x = coordinate.x + 0.5;
      float original_xDif = s_x - this.x;
      float original_yDif = s_y - startY;
      float original_distance = sqrt(original_xDif * original_xDif + original_yDif * original_yDif);
      float new_xDif = s_x - this.x - equivalentMoveX;
      float new_yDif = s_y - this.y;
      float new_distance = sqrt(new_xDif * new_xDif + new_yDif * new_yDif);
      if (new_distance > original_distance) {
        continue;
      }
      this.y = startY;
      return true;
    }
    for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
      if (entry.getKey() == this.map_key) {
        continue;
      }
      Unit u = entry.getValue();
      if (u.uncollidable()) {
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


  void resolveFloorHeight(GameMap map) {
    this.floor_height = map.maxHeightOfSquares(this.curr_squares_on, false);
    this.unit_height = -100;
    for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
      if (entry.getKey() == this.map_key) {
        continue;
      }
      Unit u = entry.getValue();
      float distance_to = this.distance(u);
      if (distance_to > Constants.small_number) {
        continue;
      }
      if (u.zf() > this.zi()) {
        continue;
      }
      if (u.zf() > this.unit_height) {
        this.unit_height = u.zf();
      }
    }
    if (this.unit_height > this.floor_height) {
      this.floor_height = this.unit_height;
    }
    if (this.floor_height > this.curr_height) {
      this.curr_height = this.floor_height;
    }
    if (this.unit_height > map.maxHeight) {
      this.unit_height = map.maxHeight;
    }
    if (this.floor_height > map.maxHeight) {
      this.floor_height = map.maxHeight;
    }
    if (this.curr_height > map.maxHeight) {
      this.curr_height = map.maxHeight;
    }
  }


  ArrayList<IntegerCoordinate> getSquaresSight(GameMap map) {
    ArrayList<IntegerCoordinate> squares_sight = new ArrayList<IntegerCoordinate>();
    float unit_sight = this.sight();
    float inner_square_distance = Constants.inverse_root_two * unit_sight;
    boolean walls_dont_block = false; // feature flag to make walls not block
    float see_around_cutoff = Constants.inverse_root_two + Constants.small_number;
    float see_around_blocked_cutoff = 2 * see_around_cutoff;
    float see_around_distance = see_around_cutoff - this.size;
    for (int i = int(floor(this.x - unit_sight)) - 1; i <= int(ceil(this.x + unit_sight)); i++) {
      for (int j = int(floor(this.y - unit_sight)) - 1; j <= int(ceil(this.y + unit_sight)); j++) {
        float distanceX = abs(i + 0.5 - this.x);
        float distanceY = abs(j + 0.5 - this.y);
        if ( (distanceX < inner_square_distance && distanceY < inner_square_distance) ||
          (sqrt(distanceX * distanceX + distanceY * distanceY) < unit_sight) ) {
          if (walls_dont_block) {
            squares_sight.add(new IntegerCoordinate(i, j));
            continue;
          }
          boolean add_square = true;
          int xi = round(min(floor(this.xi() + Constants.small_number), i));
          int yi = round(min(floor(this.yi() + Constants.small_number), j));
          int xf = round(max(floor(this.xf() - Constants.small_number), i));
          int yf = round(max(floor(this.yf() - Constants.small_number), j));
          int my_x = int(floor(this.x));
          int my_y = int(floor(this.y));
          float left_blocked = 2 * Constants.inverse_root_two;
          float right_blocked = 2 * Constants.inverse_root_two;
          for (int a = xi; a <= xf; a++) {
            for (int b = yi; b <= yf; b++) {
              if (a == i && b == j) {
                continue;
              }
              if (a == my_x && b == my_y) {
                continue;
              }
              try {
                if (map.squares[a][b].passesLight()) {
                  continue;
                }
                float p_x = a + 0.5;
                float p_y = b + 0.5;
                float x_dif = i + 0.5 - this.x;
                float y_dif = j + 0.5 - this.y;
                float area_parrallelogram = x_dif * (p_y - this.y) - y_dif * (p_x - this.x);
                boolean left_side = true;
                if (area_parrallelogram < 0) {
                  left_side = false;
                  area_parrallelogram = abs(area_parrallelogram);
                }
                float line_segment_distance = sqrt(x_dif * x_dif + y_dif * y_dif);
                float distance_from_line = area_parrallelogram / line_segment_distance;
                if (distance_from_line < see_around_distance) {
                  add_square = false;
                  break;
                }
                else if (distance_from_line < see_around_blocked_cutoff) {
                  if (left_side) {
                    if (distance_from_line < left_blocked) {
                      left_blocked = distance_from_line;
                    }
                  }
                  else {
                    if (distance_from_line < right_blocked) {
                      right_blocked = distance_from_line;
                    }
                  }
                  if (left_blocked + right_blocked < see_around_blocked_cutoff) {
                    add_square = false;
                    break;
                  }
                }
              } catch(Exception e) {}
            }
            if (!add_square) {
              break;
            }
          }
          if (add_square) {
            squares_sight.add(new IntegerCoordinate(i, j));
          }
        }
      }
    }
    return squares_sight;
  }

  // Only checks terrain collisions, used in pathfinding at end to patch initial collision artifact
  boolean willCollideMovingTo(float target_x, float target_y, GameMap map) {
    int xi = round(min(floor(this.xi() + Constants.small_number), target_x));
    int yi = round(min(floor(this.yi() + Constants.small_number), target_y));
    int xf = round(max(floor(this.xf() - Constants.small_number), target_x));
    int yf = round(max(floor(this.yf() - Constants.small_number), target_y));
    for (int a = xi; a <= xf; a++) {
      for (int b = yi; b <= yf; b++) {
      }
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
    if (height_difference > this.walkHeight()) {
      return false;
    }
    return true;
  }

  boolean currentlyOn(IntegerCoordinate coordinate) {
    for (IntegerCoordinate coordinate_on : this.curr_squares_on) {
      if (coordinate_on.equals(coordinate)) {
        return true;
      }
    }
    return false;
  }


  void aiLogic(int timeElapsed, GameMap map) {
    switch(this.ID) {
      case 1002: // Chicken
        if (this.curr_action == UnitAction.NONE || this.last_move_collision) {
          this.curr_action = UnitAction.NONE;
          this.timer_ai_action1 -= timeElapsed;
          this.timer_ai_action2 -= timeElapsed;
          if (this.timer_ai_action3 > 0) {
            this.timer_ai_action3 -= timeElapsed;
            if (this.timer_ai_action3 <= 0) {
              this.ai_toggle = false;
            }
          }
          if (this.timer_ai_action1 < 0) {
            float other_chicken_face_x = 0;
            float other_chicken_face_y = 0;
            int other_chickens_moved_from = 0;
            if (!this.ai_toggle) {
              this.timer_ai_action3 = 0;
              for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
                if (entry.getKey() == this.map_key) {
                  continue;
                }
                Unit u = entry.getValue();
                if (u.ID != 1002 && u.ID != 1003) {
                  continue;
                }
                if (!u.ai_toggle) {
                  continue;
                }
                if (randomChance(0.3)) {
                  continue;
                }
                if (this.distance(u) > this.sight()) {
                  continue;
                }
                this.ai_toggle = true;
                this.timer_ai_action3 = int(0.5 * (this.timer_ai_action3 + u.timer_ai_action3));
                other_chickens_moved_from++;
                other_chicken_face_x += u.facingX;
                other_chicken_face_y += u.facingY;
              }
            }
            this.timer_ai_action1 = int(Constants.ai_chickenTimer1 + random(Constants.ai_chickenTimer1));
            if (other_chickens_moved_from > 0) {
              other_chicken_face_x /= other_chickens_moved_from;
              other_chicken_face_y /= other_chickens_moved_from;
              this.refreshStatusEffect(StatusEffectCode.RUNNING, 0.8 * Constants.ai_chickenTimer1);
              this.moveTo(this.x + other_chicken_face_x * Constants.ai_chickenMoveDistance +
                randomFloat(-1, 1), other_chicken_face_y * Constants.ai_chickenMoveDistance +
                randomFloat(-1, 1), map);
            }
            else {
              this.moveTo(this.x + Constants.ai_chickenMoveDistance - 2 * random(Constants.ai_chickenMoveDistance),
                this.y + Constants.ai_chickenMoveDistance - 2 * random(Constants.ai_chickenMoveDistance), map);
            }
          }
          if (this.timer_ai_action2 < 0) {
            this.timer_ai_action2 = int(Constants.ai_chickenTimer2 + random(Constants.ai_chickenTimer2));
            Item egg_item = new Item(2118, this.x, this.y);
            if (this.fertilized() || randomChance(0.2)) {
              egg_item.toggled = true;
            }
            map.addItem(egg_item);
            if (this.in_view) {
              global.sounds.trigger_units("units/other/chicken_lay_egg");
            }
          }
        }
        break;
      case 1003: // Chick
        if (this.curr_action == UnitAction.NONE || this.last_move_collision) {
          this.timer_ai_action1 -= timeElapsed;
          this.timer_ai_action2 -= timeElapsed;
          if (this.timer_ai_action3 > 0) {
            this.timer_ai_action3 -= timeElapsed;
            if (this.timer_ai_action3 <= 0) {
              this.ai_toggle = false;
            }
          }
          if (this.timer_ai_action1 < 0) {
            float other_chicken_face_x = 0;
            float other_chicken_face_y = 0;
            int other_chickens_moved_from = 0;
            if (!this.ai_toggle) {
              this.timer_ai_action3 = 0;
              for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
                if (entry.getKey() == this.map_key) {
                  continue;
                }
                Unit u = entry.getValue();
                if (u.ID != 1002 && u.ID != 1003) {
                  continue;
                }
                if (!u.ai_toggle) {
                  continue;
                }
                if (randomChance(0.1)) {
                  continue;
                }
                if (this.distance(u) > this.sight()) {
                  continue;
                }
                this.ai_toggle = true;
                this.timer_ai_action3 = int(0.5 * (this.timer_ai_action3 + u.timer_ai_action3));
                other_chickens_moved_from++;
                other_chicken_face_x += u.facingX;
                other_chicken_face_y += u.facingY;
              }
            }
            this.timer_ai_action1 = int(Constants.ai_chickenTimer1 + random(Constants.ai_chickenTimer1));
            if (other_chickens_moved_from > 0) {
              other_chicken_face_x /= other_chickens_moved_from;
              other_chicken_face_y /= other_chickens_moved_from;
              this.refreshStatusEffect(StatusEffectCode.RUNNING, 0.8 * Constants.ai_chickenTimer1);
              this.moveTo(this.x + other_chicken_face_x * Constants.ai_chickenMoveDistance +
                randomFloat(-1, 1), other_chicken_face_y * Constants.ai_chickenMoveDistance +
                randomFloat(-1, 1), map);
            }
            else {
              this.moveTo(this.x + Constants.ai_chickenMoveDistance - 2 * random(Constants.ai_chickenMoveDistance),
                this.y + Constants.ai_chickenMoveDistance - 2 * random(Constants.ai_chickenMoveDistance), map);
            }
          }
          if (this.timer_ai_action2 < 0) {
            this.timer_ai_action2 = int(Constants.ai_chickenTimer2 + random(Constants.ai_chickenTimer2));
            if (randomChance(0.5)) {
              this.setUnitID(1002);
            }
            else {
              this.setUnitID(1005);
            }
            this.size = Constants.unit_defaultSize;
          }
        }
        break;
      case 1005: // Rooster
        if (this.curr_action == UnitAction.NONE || this.last_move_collision) {
          this.timer_ai_action1 -= timeElapsed;
          this.timer_ai_action2 -= timeElapsed;
          if (this.timer_ai_action1 < 0) {
            boolean random_walk = true;
            for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
              if (entry.getKey() == this.map_key) {
                continue;
              }
              Unit u = entry.getValue();
              if (u.ID != 1002 && u.ID != 1003) {
                continue;
              }
              if (!u.ai_toggle) {
                continue;
              }
              if (u.timer_ai_action3 <= 0) {
                continue;
              }
              if (this.distance(u) > this.sight()) {
                continue;
              }
              if (u.last_damage_from == null || u.last_damage_from.remove) {
                continue;
              }
              if (this.distance(u.last_damage_from) > this.sight()) {
                continue;
              }
              try {
                this.target(u.last_damage_from, map);
                random_walk = false;
              } catch(Exception e) {}
              break;
            }
            if (random_walk) {
              this.timer_ai_action1 = int(Constants.ai_chickenTimer1 + random(Constants.ai_chickenTimer1));
              this.moveTo(this.x + Constants.ai_chickenMoveDistance - 2 * random(Constants.ai_chickenMoveDistance),
                this.y + Constants.ai_chickenMoveDistance - 2 * random(Constants.ai_chickenMoveDistance), map);
            }
          }
          if (this.timer_ai_action2 < 0) {
            this.timer_ai_action2 = int(0.4 * Constants.ai_chickenTimer2 + 0.4 * random(Constants.ai_chickenTimer2));
            if (this.in_view) {
              global.sounds.trigger_units("units/other/rooster_crow" + randomInt(1, 3));
            }
          }
        }
        break;
      case 1201: // Tier I Zombies
      case 1202:
      case 1203:
      case 1204:
      case 1205:
      case 1206:
      case 1207:
      case 1208:
      case 1209:
      case 1210:
      case 1291: // Auto-spawned Zombies
      case 1292:
      case 1293:
      case 1302: // Tier I Named Zombies
      case 1303:
      case 1304:
      case 1305:
      case 1306:
      case 1307:
      case 1308:
        if (this.curr_action == UnitAction.NONE || this.last_move_collision) {
          this.timer_ai_action1 -= timeElapsed;
          if (this.timer_ai_action1 < 0) {
            this.timer_ai_action1 = 400;
            boolean no_target = true;
            for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
              if (entry.getKey() == this.map_key) {
                continue;
              }
              Unit u = entry.getValue();
              if (u.alliance == this.alliance) {
                continue;
              }
              float distance = this.distance(u);
              if (distance > this.sight()) {
                continue;
              }
              if (no_target) {
                no_target = false;
                this.target(u, map);
              }
              else if (!u.ai_controlled) {
                this.target(u, map);
              }
            }
            if (no_target && randomChance(0.1)) {
              this.moveTo(this.x + 3 - random(6), this.y + 3 - random(6), map);
            }
          }
        }
        break;
      case 1311: // Cathy Heck
        if (!this.ai_toggle) {
          break;
        }
        this.timer_ai_action1 -= timeElapsed;
        this.timer_ai_action2 -= timeElapsed;
        this.timer_ai_action3 -= timeElapsed;
        switch(this.curr_action) {
          case NONE:
            if (map.units.containsKey(0)) {
              this.target(map.units.get(0), map);
            }
            break;
          case TARGETING_UNIT:
            if (this.timer_ai_action3 < 0) {
              this.timer_ai_action3 = 3500;
              this.cast(2, map);
            }
            else if (this.timer_ai_action2 < 0) {
              this.timer_ai_action2 = round(9000 + random(9000));
              this.cast(1, map);
            }
            else if (this.timer_ai_action1 < 0) {
              this.timer_ai_action1 = round(6000 + random(6000));
              this.cast(0, map);
            }
            break;
          case CAST_WHEN_IN_RANGE:
            if (this.timer_ai_action3 < 0) {
              this.timer_ai_action3 = round(21000 + random(21000));
              this.curr_action = UnitAction.NONE;
            }
            break;
        }
        break;
      default:
        break;
    }
  }


  String fileString() {
    return this.fileString(true);
  }
  String fileString(boolean include_headers) {
    String fileString = "";
    if (include_headers) {
      fileString += "\nnew: Unit: " + this.ID;
    }
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
    for (Map.Entry<StatusEffectCode, StatusEffect> entry : this.statuses.entrySet()) {
      fileString += "\nnext_status_code: " + entry.getKey().code_name();
      fileString += entry.getValue().fileString();
    }
    fileString += "\nfacingX: " + this.facingX;
    fileString += "\nfacingY: " + this.facingY;
    fileString += "\nfacingA: " + this.facingA;
    if (this.save_base_stats) {
      fileString += "\nsave_base_stats: " + this.save_base_stats;
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
      fileString += "\nbase_lifesteal: " + this.base_lifesteal;
    }
    if (this.save_base_stats || abs(this.curr_health - this.health()) > Constants.small_number) {
      fileString += "\ncurr_health: " + this.curr_health;
    }
    fileString += "\nfootgear_durability_distance: " + this.footgear_durability_distance;
    fileString += "\ntimer_attackCooldown: " + this.timer_attackCooldown;
    fileString += "\ntimer_actionTime: " + this.timer_actionTime;
    if (include_headers) {
      fileString += "\nend: Unit\n";
    }
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
        this.setLevel(toInt(data));
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
      case "facingA":
        this.facingA = toFloat(data);
        break;
      case "addNullAbility":
        this.abilities.add(null);
        break;
      case "save_base_stats":
        this.save_base_stats = toBoolean(data);
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
      case "base_lifesteal":
        this.base_lifesteal = toFloat(data);
        break;
      case "curr_health":
        this.curr_health = toFloat(data);
        break;
      case "footgear_durability_distance":
        this.footgear_durability_distance = toFloat(data);
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
