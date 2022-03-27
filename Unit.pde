enum UnitAction {
  NONE, MOVING;
}


enum MoveModifier {
  NONE, SNEAK, RECOIL;
}



class Unit extends MapObject {
  protected float size = Constants.unit_defaultSize; // radius
  protected int sizeZ = Constants.unit_defaultHeight;

  protected int level = 0;

  protected float facingX = 1;
  protected float facingY = 0;
  protected float facingA = 0; // angle in radians

  protected float base_sight = Constants.unit_defaultSight;
  protected float base_speed = 0;
  // base other stats: health, attack, magic, defense, resistance, piercing, penetration, agility, tenacity

  protected UnitAction curr_action = UnitAction.NONE;
  protected int curr_action_id = 0;
  protected float curr_action_x = 0;
  protected float curr_action_y = 0;
  protected float last_move_distance = 0;
  protected boolean last_move_collision = false;

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
        this.baseStats(1);
        this.level = 1;
        break;

      // Heroes
      case 1101:
        this.setStrings("Ben Nelson", "Hero", "");
        this.baseStats(2);
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
        break;
      case 1202:
        this.setStrings("Broken Zombie", "Zombie", "");
        this.level = 2;
        break;
      case 1203:
        this.setStrings("Sick Zombie", "Zombie", "");
        this.level = 3;
        break;
      case 1204:
        this.setStrings("Lazy Hungry Zombie", "Zombie", "");
        this.level = 4;
        break;
      case 1205:
        this.setStrings("Lazy Zombie", "Zombie", "");
        this.level = 5;
        break;
      case 1206:
        this.setStrings("Hungry Zombie", "Zombie", "");
        this.level = 6;
        break;
      case 1207:
        this.setStrings("Confused Franny Zombie", "Zombie", "");
        this.level = 7;
        break;
      case 1208:
        this.setStrings("Confused Zombie", "Zombie", "");
        this.level = 8;
        break;
      case 1209:
        this.setStrings("Franny Zombie", "Zombie", "");
        this.level = 9;
        break;
      case 1210:
        this.setStrings("Intellectual Zombie", "Zombie", "");
        this.level = 10;
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
    return text + "\n\n" + this.description();
  }

  void baseStats(float speed) {
    this.base_speed = speed;
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


  float sight() {
    return this.base_sight;
  }

  float speed() {
    return this.base_speed;
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
      case NONE:
        break;
    }
  }

  void update(int timeElapsed) {
    // timers
    // other action timers
    // timers for status effects
    // timers for AI actions if controlled by AI
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

  float facingAngle() {
    return this.facingA;
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
    if (!this.inMapX(map.mapWidth)) {
      this.x = startX;
      return true;
    }
    // terrain collisions
    // unit collisions
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
    // unit collisions
    return false;
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
    fileString += "\nfacingX: " + this.facingX;
    fileString += "\nfacingY: " + this.facingY;
    fileString += "\nbase_sight: " + this.base_sight;
    fileString += "\nbase_speed: " + this.base_speed;
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
      case "facingX":
        this.facingX = toFloat(data);
        break;
      case "facingY":
        this.facingY = toFloat(data);
        break;
      case "base_sight":
        this.base_sight = toFloat(data);
        break;
      case "base_speed":
        this.base_speed = toFloat(data);
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not found for unit data.");
        break;
    }
  }


  int tier() {
    return this.level / 10;
  }
}
