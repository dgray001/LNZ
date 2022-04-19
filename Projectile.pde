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
  protected float range_left = 0;
  protected boolean friendly_fire = false;
  protected boolean waiting_to_explode = false;

  Projectile(int ID) {
    super(ID);
    this.setID();
  }
  Projectile(int ID, int source_key, Unit u) {
    this(ID, source_key, u, 0);
  }
  Projectile(int ID, int source_key, Unit u, float inaccuracy) {
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
      switch(ID) {
        case 3372: // Ray Gun
        case 3392: // Porter's X2 Ray Gun
          this.power = u.attack() + u.magic();
          this.damageType = DamageType.MIXED;
          break;
        default:
          this.power = u.attack();
          break;
      }
      this.piercing = u.piercing();
      this.penetration = u.penetration();
      this.turn(inaccuracy - 2 * random(inaccuracy));
    }
    this.setID();
  }

  void setID() {
    switch(ID) {
      case 3301: // Slingshot
        this.speed = 8;
        this.decay = 0.5;
        this.range_left = 10;
        break;
      case 3311: // Bow
        this.speed = 12;
        this.decay = 0.5;
        this.range_left = 10;
        break;
      case 3312: // M1911
        this.speed = 90;
        this.decay = 1.11317;
        this.range_left = 10;
        break;
      case 3321: // War Machine
        this.speed = 18;
        this.decay = 0.84961;
        this.range_left = 10;
        break;
      case 3322: // Five-Seven
        this.speed = 90;
        //this.decay = 0.0;
        this.range_left = 10;
        break;
      case 3323: // Type25
        this.speed = 90;
        this.decay = 5.55011;
        this.range_left = 10;
        break;
      case 3331: // Mustang and Sally
        this.speed = 60;
        this.decay = 0.82305;
        this.range_left = 10;
        break;
      case 3332: // FAL
        this.speed = 100;
        this.decay = 3.25;
        this.range_left = 10;
        break;
      case 3333: // Python
        this.speed = 100;
        this.decay = 0.82397;
        this.range_left = 10;
        break;
      case 3341: // RPG
        this.speed = 30;
        //this.decay = 0;
        this.range_left = 10;
        break;
      case 3342: // Dystopic Demolisher
        this.speed = 30;
        this.decay = 0.99432;
        this.range_left = 10;
        break;
      case 3343: // Ultra
        this.speed = 90;
        //this.decay = 1.11317;
        this.range_left = 10;
        break;
      case 3344: // Strain25
        this.speed = 90;
        this.decay = 4.91735;
        this.range_left = 10;
        break;
      case 3345: // Executioner
        this.speed = 90;
        this.decay = 1.00186;
        this.range_left = 10;
        break;
      case 3351: // Galil
        this.speed = 90;
        //this.decay = 1.11317;
        this.range_left = 10;
        break;
      case 3352: // WN
        this.speed = 100;
        this.decay = 2.28571;
        this.range_left = 10;
        break;
      case 3353: // Ballistic Knife
        this.speed = 40;
        this.decay = 1.4876;
        this.range_left = 10;
        break;
      case 3354: // Cobra
        this.speed = 100;
        //this.decay = 1.11317;
        this.range_left = 10;
        break;
      case 3355: // MTAR
        this.speed = 90;
        this.decay = 1.11317;
        this.range_left = 10;
        break;
      case 3361: // RPD
        this.speed = 90;
        this.decay = 1.11317;
        this.range_left = 10;
        break;
      case 3362: // Rocket-Propelled Grievance
        this.speed = 90;
        this.decay = 1.11317;
        this.range_left = 10;
        break;
      case 3363: // DSR-50
        this.speed = 90;
        this.decay = 1.11317;
        this.range_left = 10;
        break;
      case 3364: // Voice of Justice
        this.speed = 90;
        this.decay = 1.11317;
        this.range_left = 10;
        break;
      case 3371: // HAMR
        this.speed = 90;
        this.decay = 1.11317;
        this.range_left = 10;
        break;
      case 3372: // Ray Gun
        this.speed = 90;
        this.decay = 1.11317;
        this.range_left = 10;
        break;
      case 3373: // Lamentation
        this.speed = 90;
        this.decay = 1.11317;
        this.range_left = 10;
        break;
      case 3374: // The Krauss Refibrillator
        this.speed = 90;
        this.decay = 1.11317;
        this.range_left = 10;
        break;
      case 3375: // Malevolent Taxonomic Anodized Redeemer
        this.speed = 90;
        this.decay = 1.11317;
        this.range_left = 10;
        break;
      case 3381: // Relativistic Punishment Device
        this.speed = 90;
        this.decay = 1.11317;
        this.range_left = 10;
        break;
      case 3382: // Dead Specimen Reactor 5000
        this.speed = 90;
        this.decay = 1.11317;
        this.range_left = 10;
        break;
      case 3391: // SLDG HAMR
        this.speed = 90;
        this.decay = 1.11317;
        this.range_left = 10;
        break;
      case 3392: // Porter's X2 Ray Gun
        this.speed = 90;
        this.decay = 1.11317;
        this.range_left = 10;
        break;
      case 3924: // glass bottle (thrown)
        this.speed = 4;
        this.decay = 0.5;
        this.range_left = 10;
        break;
      case 3931: // rock (thrown)
        this.speed = 5;
        this.decay = 0.5;
        this.range_left = 10;
        break;
      case 3932: // arrow (thrown)
        this.speed = 4;
        this.decay = 0.5;
        this.range_left = 10;
        break;
      case 3933: // pebble (thrown)
        this.speed = 5;
        this.decay = 0.5;
        this.range_left = 10;
        break;
      case 3944: // grenade (thrown)
        this.speed = 6;
        this.decay = 0.5;
        this.range_left = 10;
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

  void turn(float angle_change) {
    this.turnTo(this.facingA + angle_change);
  }
  void turnTo(float facingA) {
    this.facingA = facingA;
    this.facingX = cos(this.facingA);
    this.facingY = sin(this.facingA);
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
      case 3301:
        path += "rock.png";
        break;
      case 3311:
        path += "arrow.png";
        break;
      case 3312:
        path += "45_acp.png";
        break;
      case 3321:
        path += "grenade.png";
        break;
      case 3322:
        path += "fn_57_28mm.png";
        break;
      case 3323:
        path += "556_45mm.png";
        break;
      case 3331:
        path += "grenade.png";
        break;
      case 3332:
        path += "762_39mm.png";
        break;
      case 3333:
        path += "357_magnum.png";
        break;
      case 3341:
        path += "grenade.png";
        break;
      case 3342:
        path += "grenade.png";
        break;
      case 3343:
        path += "fn_57_28mm.png";
        break;
      case 3344:
        path += "556_45mm.png";
        break;
      case 3345:
        path += "28_gauge.png";
        break;
      case 3351:
        path += "556_45mm.png";
        break;
      case 3352:
        path += "762_39mm.png";
        break;
      case 3353:
        path += "ballistic_knife.png";
        break;
      case 3354:
        path += "357_magnum.png";
        break;
      case 3355:
        path += "556_45mm.png";
        break;
      case 3361:
        path += "762_39mm.png";
        break;
      case 3362:
        path += "grenade.png";
        break;
      case 3363:
        path += "50_bmg.png";
        break;
      case 3364:
        path += "28_gauge.png";
        break;
      case 3371:
        path += "762_39mm.png";
        break;
      case 3372:
        path += "ray.png";
        break;
      case 3373:
        path += "762_39mm.png";
        break;
      case 3374:
        path += "ballistic_knife.png";
        break;
      case 3375:
        path += "762_39mm.png";
        break;
      case 3381:
        path += "762_39mm.png";
        break;
      case 3382:
        path += "50_bmg.png";
        break;
      case 3391:
        path += "762_39mm.png";
        break;
      case 3392:
        path += "ray.png";
        break;
      case 3924:
        path += "glass_bottle.png";
        break;
      case 3931:
        path += "rock.png";
        break;
      case 3932:
        path += "arrow.png";
        break;
      case 3933:
        path += "pebble.png";
        break;
      case 3944:
        path += "grenade.png";
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
    if (this.waiting_to_explode) {
      this.range_left -= timeElapsed;
      if (this.range_left < 0) {
        this.explode(map);
      }
      return;
    }
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
    this.range_left -= distance_moved;
    if (this.range_left < 0) {
      this.dropOnGround(map);
    }
  }


  void update(int timeElapsed) {}


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
      case 3924: // glass bottle
        droppedItems.add(new Item(2805));
        break;
      case 3931: // rock
        droppedItems.add(new Item(2931));
        break;
      case 3932: // arrow
        droppedItems.add(new Item(2932));
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
    if (this.waitsToExplode()) {
      this.startExplodeTimer();
    }
    else if (this.explodesOnImpact()) {
      this.explode(map);
    }
    else {
      this.remove = true;
    }
  }

  void collideWithUnit(GameMap map, Unit u) {
    for (Item i : this.droppedItems(true)) {
      map.addItem(i, this.x, this.y);
    }
    u.damage(map.units.get(this.source_key), u.calculateDamageFrom(this.collidePower(),
      this.damageType, this.element, this.piercing, this.penetration));
    if (this.waitsToExplode()) {
      this.startExplodeTimer();
    }
    else if (this.explodesOnImpact()) {
      this.explode(map);
    }
    else {
      this.remove = true;
    }
  }


  float collidePower() {
    switch(this.ID) {
      // explosion ones won't do 1000 damage on collision
      default:
        return this.power;
    }
  }


  boolean waitsToExplode() {
    switch(this.ID) {
      case 3321: // War Machine
      case 3944: // Grenade
        return true;
      default:
        return false;
    }
  }

  void startExplodeTimer() {
    this.waiting_to_explode = true;
    switch(this.ID) {
      case 3321: // War Machine
        this.range_left = 2000;
        break;
      case 3944: // Grenade
        this.range_left = 2000;
        break;
      default:
        global.errorMessage("ERROR: Projectile ID " + this.ID + " doesn't wait to explode.");
        this.waiting_to_explode = false;
        return;
    }
  }

  boolean explodesOnImpact() {
    switch(this.ID) {
      case 3331: // Mustang and Sally
      case 3341: // RPG
      case 3342: // Dystopic Demolisher
      case 3362: // Rocket-Propelled Grievance
      case 3372: // Ray Gun
      case 3392: // Porter's X2 Ray Gun
        return true;
      default:
        return false;
    }
  }

  void explode(GameMap map) {
    float explode_x = this.x;
    float explode_y = this.y;
    float explode_range = 0;
    float explode_maxPower = 0;
    float explode_minPower = 0;
    switch(this.ID) { // set values and add visual effects
      case 3321: // War Machine
        break;
      case 3331: // Mustang and Sally
        break;
      case 3341: // RPG
        break;
      case 3342: // Dystopic Demolisher
        break;
      case 3362: // Rocket-Propelled Grievance
        break;
      case 3372: // Ray Gun
        break;
      case 3392: // Porter's X2 Ray Gun
        break;
      case 3944: // Grenade
        explode_range = 3;
        explode_minPower = 100;
        explode_maxPower = 400;
        break;
      default:
        global.errorMessage("ERROR: Projectile ID " + this.ID + " doesn't explode.");
        break;
    }
    map.splashDamage(explode_x, explode_y, explode_range, explode_maxPower,
      explode_minPower, this.source_key, this.damageType, this.element,
      this.piercing, this.penetration);
    this.remove = true;
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
    fileString += "\nrangeLeft: " + this.range_left;
    fileString += "\nwaitingToExplode: " + this.waiting_to_explode;
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
      case "rangeLeft":
        this.range_left = toFloat(data);
        break;
      case "waitingToExplode":
        this.waiting_to_explode = toBoolean(data);
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not found for projectile data.");
        break;
    }
  }
}
