class Projectile extends MapObject {
  protected float size = Constants.projectile_defaultSize; // radius

  protected int source_key;
  protected float facingX = 1;
  protected float facingY = 0;
  protected float facingA = 0;
  protected Alliance alliance = Alliance.NONE;

  protected float power = 0;
  protected float piercing = 0;
  protected float penetration = 0;
  protected Element element = Element.GRAY;
  protected DamageType damageType = DamageType.PHYSICAL;

  protected float speed = 0;
  protected float decay = 0;
  protected boolean friendly_fire = false;

  Projectile(int ID) {
    super(ID);
    this.setID();
  }
  Projectile(int ID, int source_key, Unit u) {
    super(ID);
    this.source_key = source_key;
    // assume autoattack unless stated otherwise
    if (u != null) {
      this.x = u.frontX();
      this.y = u.frontY();
      this.curr_height = u.zHalf();
      this.facingX = u.facingX;
      this.facingY = u.facingY;
      this.facingA = u.facingA;
      this.alliance = u.alliance;
      this.power = u.attack();
      this.piercing = u.piercing();
      this.penetration = u.penetration();
    }
    this.setID();
  }

  void setID() {
    switch(ID) {
      case 3312: // M1911
        this.speed = 90;
        this.decay = 1.11317;
        break;
      case 3931: // rock
        this.speed = 5;
        this.decay = 0.5;
        break;
      case 3933: // pebble
        this.speed = 5;
        this.decay = 0.5;
        break;
      default:
        global.errorMessage("ERROR: Projectile ID " + ID + " not found.");
        break;
    }
  }

  void setPower(int source_key, float power, float piercing, float penetration) {
    this.power = power;
    this.piercing = piercing;
    this.penetration = penetration;
  }

  void setFacing(float facingX, float facingY) {
    this.facingX = facingX;
    this.facingY = facingY;
    this.facingA = (float)Math.atan2(this.facingY, this.facingX);
  }

  void refreshFacing() {
    this.facingA = (float)Math.atan2(this.facingY, this.facingX);
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

  @Override
  float distance(MapObject object) {
    float xDistance = max(0, abs(this.xCenter() - object.xCenter()) - object.xRadius());
    float yDistance = max(0, abs(this.yCenter() - object.yCenter()) - object.yRadius());
    return sqrt(xDistance * xDistance + yDistance * yDistance);
  }

  @Override
  boolean touching(MapObject object) {
    if ( ((abs(this.xCenter() - object.xCenter()) - object.xRadius()) <= 0) ||
      ((abs(this.yCenter() - object.yCenter()) - object.yRadius()) <= 0) ) {
        return true;
    }
    return false;
  }

  PImage getImage() {
    String path = "projectiles/";
    switch(this.ID) {
      case 3312:
        path += "45_acp.png";
        break;
      case 3931:
        path += "rock.png";
        break;
      case 3933:
        path += "pebble.png";
        break;
      default:
        global.errorMessage("ERROR: Projectile ID " + ID + " not found.");
        path += "default.png";
        break;
    }
    return global.images.getImage(path);
  }


  boolean targetable(Unit u) {
    return false;
  }


  void update(int timeElapsed, GameMap map) {
    if (this.remove) {
      return;
    }
    this.update(timeElapsed);
    float distance_moved = this.speed * timeElapsed / 1000.0;
    float tryMoveX = distance_moved * this.facingX;
    float tryMoveY = distance_moved * this.facingY;
    // move in x direction
    this.moveX(tryMoveX, map);
    // move in y direction
    this.moveY(tryMoveY, map);
    // decay
    float decay_percentage = 1 - this.decay * timeElapsed / 1000.0;
    if (decay_percentage < 0) {
      this.speed = 0;
      this.power = 0;
      this.piercing = 0;
      this.penetration = 0;
    }
    else {
      this.speed *= decay_percentage;
      this.power *= decay_percentage;
      this.piercing *= decay_percentage;
      this.penetration *= decay_percentage;
    }
    if (speed < Constants.projectile_threshholdSpeed) {
      this.dropOnGround(map);
    }
  }


  void update(int timeElapsed) {
    // any needed timers (like grenade exploding
  }


  void moveX(float tryMoveX, GameMap map) {
    while(abs(tryMoveX) > Constants.map_moveLogicCap) {
      if (tryMoveX > 0) {
        if (this.collisionLogicX(Constants.map_moveLogicCap, map)) {
          return;
        }
        tryMoveX -= Constants.map_moveLogicCap;
      }
      else {
        if (this.collisionLogicX(-Constants.map_moveLogicCap, map)) {
          return;
        }
        tryMoveX += Constants.map_moveLogicCap;
      }
    }
    if (this.collisionLogicX(tryMoveX, map)) {
      return;
    }
  }

  void moveY(float tryMoveY, GameMap map) {
    while(abs(tryMoveY) > Constants.map_moveLogicCap) {
      if (tryMoveY > 0) {
        if (this.collisionLogicY(Constants.map_moveLogicCap, map)) {
          return;
        }
        tryMoveY -= Constants.map_moveLogicCap;
      }
      else {
        if (this.collisionLogicY(-Constants.map_moveLogicCap, map)) {
          return;
        }
        tryMoveY += Constants.map_moveLogicCap;
      }
    }
    if (this.collisionLogicY(tryMoveY, map)) {
      return;
    }
  }

  // returns true if collision occurs
  boolean collisionLogicX(float tryMoveX, GameMap map) {
    float startX = this.x;
    this.x += tryMoveX;
    // map collisions
    if (!this.inMapX(map.mapWidth)) {
      this.remove = true;
      return true;
    }
    // terrain collisions
    try {
      if (map.squares[int(floor(this.x))][int(floor(this.y))].elevation(true) > this.curr_height) {
        this.x = startX;
        this.dropOnGround(map);
        return true;
      }
    } catch(Exception e) {}
    // unit collisions
    for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
      if (entry.getKey() == this.source_key) {
        continue;
      }
      Unit u = entry.getValue();
      if (u.alliance == this.alliance && this.alliance != Alliance.NONE && !this.friendly_fire) {
        continue;
      }
      if (this.curr_height < u.zi() && this.curr_height > u.zi()) {
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
      this.collideWithUnit(map, u);
      return true;
    }
    return false;
  }

  // returns true if collision occurs
  boolean collisionLogicY(float tryMoveY, GameMap map) {
    float startY = this.y;
    this.y += tryMoveY;
    // map collisions
    if (!this.inMapY(map.mapHeight)) {
      this.remove = true;
      return true;
    }
    // terrain collisions
    try {
      if (map.squares[int(floor(this.x))][int(floor(this.y))].elevation(true) > this.curr_height) {
        this.y = startY;
        this.dropOnGround(map);
        return true;
      }
    } catch(Exception e) {}
    // unit collisions
    for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
      if (entry.getKey() == this.source_key) {
        continue;
      }
      Unit u = entry.getValue();
      if (u.alliance == this.alliance && this.alliance != Alliance.NONE && !this.friendly_fire) {
        continue;
      }
      if (this.curr_height < u.zi() && this.curr_height > u.zi()) {
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
      this.collideWithUnit(map, u);
      return true;
    }
    return false;
  }

  ArrayList<Item> droppedItems(boolean hitUnit) {
    ArrayList<Item> droppedItems = new ArrayList<Item>();
    switch(this.ID) {
      case 3931: // rock
        droppedItems.add(new Item(2931));
        break;
      case 3933: // pebble
        droppedItems.add(new Item(2933));
        break;
      default:
        break;
    }
    return droppedItems;
  }

  void dropOnGround(GameMap map) {
    for (Item i : this.droppedItems(false)) {
      map.addItem(i, this.x, this.y);
    }
    // explode on impact (splash damage)
    // if (doesn't explode on impact) {
    //     start timer } else {
    this.remove = true;
    // potentially interact with terrain / features
  }

  void collideWithUnit(GameMap map, Unit u) {
    for (Item i : this.droppedItems(true)) {
      map.addItem(i, this.x, this.y);
    }
    // explode on impact (splash damage)
    // if (doesn't explode on impact) {
    //     start timer } else {
    this.remove = true;
    u.damage(map.units.get(this.source_key), u.calculateDamageFrom(this.power,
      this.damageType, this.element, this.piercing, this.penetration));
  }


  String fileString() {
    String fileString = "\nnew: Projectile: " + this.ID;
    fileString += this.objectFileString();
    fileString += "\nsize: " + this.size;
    fileString += "\nsource_key: " + this.source_key;
    fileString += "\nfacingX: " + this.facingX;
    fileString += "\nfacingY: " + this.facingY;
    fileString += "\nalliance: " + this.alliance.alliance_name();
    fileString += "\nelement: " + this.element.element_name();
    fileString += "\npower: " + this.power;
    fileString += "\npiercing: " + this.piercing;
    fileString += "\npenetration: " + this.penetration;
    fileString += "\nend: Projectile\n";
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
      case "source_key":
        this.source_key = toInt(data);
        break;
      case "facingX":
        this.facingX = toFloat(data);
        break;
      case "facingY":
        this.facingY = toFloat(data);
        break;
      case "alliance":
        this.alliance = Alliance.alliance(data);
        break;
      case "element":
        this.element = Element.element(data);
        break;
      case "power":
        this.power = toFloat(data);
        break;
      case "piercing":
        this.piercing = toFloat(data);
        break;
      case "penetration":
        this.penetration = toFloat(data);
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not found for projectile data.");
        break;
    }
  }
}
