// level location
enum Location {
  ERROR, HOMEBASE, FRANCISCAN_FRANCIS, FRANCISCAN_OUTSIDE;

  private static final List<Location> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  public String display_name() {
    return Location.display_name(this);
  }
  static public String display_name(Location a) {
    switch(a) {
      case FRANCISCAN_FRANCIS:
        return "Francis Hall";
      case FRANCISCAN_OUTSIDE:
        return "Franciscan Campus";
      case HOMEBASE:
        return "Home Base";
      default:
        return "-- Error --";
    }
  }

  public String file_name() {
    return Location.file_name(this);
  }
  static public String file_name(Location a) {
    switch(a) {
      case FRANCISCAN_FRANCIS:
        return "FRANCISCAN_FRANCIS";
      case FRANCISCAN_OUTSIDE:
        return "FRANCISCAN_OUTSIDE";
      case HOMEBASE:
        return "HOMEBASE";
      default:
        return "ERROR";
    }
  }

  static public Location location(String display_name) {
    for (Location location : Location.VALUES) {
      if (location == Location.ERROR) {
        continue;
      }
      if (Location.display_name(location).equals(display_name) ||
        Location.file_name(location).equals(display_name)) {
        return location;
      }
    }
    return Location.ERROR;
  }
}




class Linker {
  private Rectangle rect1 = new Rectangle();
  private Rectangle rect2 = new Rectangle();

  Linker() {}
  Linker(Rectangle rect1, Rectangle rect2) {
    this.rect1 = rect1;
    this.rect2 = rect2;
  }

  boolean port(Unit u, String map_name) {
    if (this.rect1.contains(u, map_name)) {
      return true;
    }
    return false;
  }

  String fileString() {
    String fileString = "\nnew: Linker";
    fileString += "\nrect1: " + this.rect1.fileString();
    fileString += "\nrect2: " + this.rect2.fileString();
    fileString += "\nend: Linker\n";
    return fileString;
  }

  void addData(String datakey, String data) {
    switch(datakey) {
      case "rect1":
        this.rect1.addData(data);
        break;
      case "rect2":
        this.rect2.addData(data);
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not found for linker data.");
        break;
    }
  }
}




class Level {
  protected String folderPath; // to level folder
  protected String levelName = "error";
  protected Location location = Location.ERROR;
  protected boolean nullify = false;

  protected GameMap currMap;
  protected String currMapName = null;
  protected ArrayList<String> mapNames = new ArrayList<String>();

  protected float xi = 0;
  protected float yi = 0;
  protected float xf = 0;
  protected float yf = 0;

  protected ArrayList<Linker> linkers = new ArrayList<Linker>();
  protected int nextTriggerKey = 1;
  protected HashMap<Integer, Trigger> triggers = new HashMap<Integer, Trigger>();
  //protected HashMap<Integer, Quest> quests = new HashMap<Integer, Quest>();

  protected Rectangle player_start_location = null;
  protected Hero player;

  protected int last_update_time = millis();

  Level() {}
  Level(String folderPath, String levelName) {
    this.folderPath = folderPath;
    this.levelName = levelName;
    this.open();
  }
  Level(String folderPath, Location location) {
    this.folderPath = folderPath;
    this.location = location;
    this.levelName = location.display_name();
    this.open();
  }
  // test map
  Level(GameMap testMap) {
    this.folderPath = "";
    this.levelName = testMap.mapName;
    this.currMap = testMap;
    this.currMapName = testMap.mapName;
    this.player = new Hero(HeroCode.BEN);
    this.player.setLocation(0.5, 0.5);
    this.currMap.addPlayer(this.player);
  }


  String getCurrMapNameDisplay() {
    if (this.currMapName == null) {
      return "No current map (see default)";
    }
    else {
      return "Current map: " + this.currMapName;
    }
  }

  String getPlayerStartLocationDisplay() {
    if (this.player_start_location == null) {
      return "No player start location";
    }
    else {
      return "Player starts on " + this.player_start_location.mapName + " at (" +
        this.player_start_location.centerX() + ", " + this.player_start_location.centerY() + ")";
    }
  }


  void setPlayer(Hero player) {
    if (this.player == null) {
      if (this.player_start_location == null || !this.hasMap(this.player_start_location.mapName)) {
        if (this.mapNames.size() > 0) {
          this.openMap(this.mapNames.get(0));
        }
      }
      else {
        this.openMap(this.player_start_location.mapName);
        player.setLocation(this.player_start_location.centerX(), this.player_start_location.centerY());
        if (this.currMap == null) {
          this.nullify = true;
          global.errorMessage("ERROR: Can't open default map.");
        }
        else {
          this.currMap.addPlayer(player);
        }
      }
    }
    else {
      // save previous player
    }
    this.player = player;
  }


  boolean hasMap(String queryMapName) {
    for (String mapName : this.mapNames) {
      if (queryMapName.equals(mapName)) {
        return true;
      }
    }
    return false;
  }

  void removeMap(String mapName) {
    for (int i = 0; i < this.mapNames.size(); i++) {
      if (mapName.equals(this.mapNames.get(i))) {
        this.mapNames.remove(i);
        return;
      }
    }
  }


  void movePlayerTo(Rectangle rect) {
    if (this.player == null || rect == null) {
      return;
    }
    if (!this.hasMap(rect.mapName)) {
      return;
    }
    this.openMap(rect.mapName);
    this.player.setLocation(rect.centerX(), rect.centerY());
    this.player.stopAction();
    this.currMap.addPlayer(player);
  }

  void openMap(String mapName) {
    if (mapName == null) {
      return;
    }
    if (!fileExists(this.finalFolderPath() + "/" + mapName + ".map.lnz")) {
      global.errorMessage("ERROR: Level " + this.levelName + " has no map " +
        "with name " + mapName + ".");
      return;
    }
    if (mapName.equals(this.currMapName) && this.currMap != null) {
      return;
    }
    this.currMapName = mapName;
    if (this.currMap != null) {
      this.currMap.save(this.finalFolderPath());
    }
    this.currMap = new GameMap(mapName, this.finalFolderPath());
    this.currMap.setLocation(this.xi, this.yi, this.xf, this.yf);
  }

  void closeMap() {
    if (this.currMap != null) {
      this.currMap.save(this.finalFolderPath());
    }
    this.currMap = null;
    this.currMapName = null;
  }


  void addLinker(Linker linker) {
    if (linker == null) {
      global.errorMessage("ERROR: Can't add null linker to linkers.");
      return;
    }
    this.linkers.add(linker);
  }
  void removeLinker(int index) {
    if (index < 0 || index >= this.linkers.size()) {
      global.errorMessage("ERROR: Linker index " + index + " out of range.");
      return;
    }
    this.linkers.remove(index);
  }

  void addTrigger(Trigger trigger) {
    if (trigger == null) {
      global.errorMessage("ERROR: Can't add null trigger to triggers.");
      return;
    }
    this.addTrigger(this.nextTriggerKey, trigger);
    this.nextTriggerKey++;
  }
  void addTrigger(int triggerCode, Trigger trigger) {
    if (trigger == null) {
      global.errorMessage("ERROR: Can't add null trigger to triggers.");
      return;
    }
    this.triggers.put(triggerCode, trigger);
  }
  void removeTrigger(int triggerKey) {
    if (!this.triggers.containsKey(triggerKey)) {
      global.errorMessage("ERROR: No trigger with key " + triggerKey + ".");
      return;
    }
    this.triggers.remove(triggerKey);
  }

  //void addQuest(Quest quest) {}
  //void removeQuest(int index) {}


  void setLocation(float xi, float yi, float xf, float yf) {
    this.xi = xi;
    this.yi = yi;
    this.xf = xf;
    this.yf = yf;
    if (this.currMap != null) {
      this.currMap.setLocation(xi, yi, xf, yf);
    }
  }


  void drawLeftPanel(int millis) {
    if (this.currMap != null) {
      this.currMap.drawLeftPanel(millis);
    }
    if (this.player != null) {
      this.player.drawLeftPanel(millis, this.xi);
    }
  }

  boolean leftPanelElementsHovered() {
    if (this.currMap != null) {
      return this.currMap.leftPanelElementsHovered();
    }
    return false;
  }

  void drawRightPanel(int millis) {
    // quest and chat box
  }


  void heroFeatureInteraction(Hero h) {
    if (this.currMap == null || h == null || h.object_targeting == null || h.object_targeting.remove) {
      return;
    }
    if (!Feature.class.isInstance(h.object_targeting)) {
      global.errorMessage("ERROR: Hero " + h.display_name() + " trying to " +
        "interact with feature " + h.display_name() + " but it's not a feature.");
      return;
    }
    Feature f = (Feature)h.object_targeting;
    Feature new_f;
    switch(f.ID) {
      case 102: // desk
      case 103:
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        // sound effect
        break;
      case 151: // sign
      case 152:
      case 153:
      case 154:
      case 155:
      case 156:
      case 157:
      case 158:
        try {
          this.currMap.addHeaderMessage(trim(split(f.description,
            Constants.feature_signDescriptionDelimiter)[1]));
        } catch(ArrayIndexOutOfBoundsException e) {
          this.currMap.addHeaderMessage("-- the sign has nothing written on it --");
        }
        f.number = Constants.feature_signCooldown;
        break;
      case 161: // water fountain
        // if holding water bottle that isn't full fill it
        // if holding a dirty item clean it (?)
        h.increaseThirst(3);
        // sound effect
        break;
      case 162: // sink
        // if holding water bottle that isn't full fill it
        // if holding a dirty item clean it (?)
        h.increaseThirst(2);
        // sound effect
        break;
      case 163: // shower stall
        f.number = Constants.feature_showerStallCooldown;
        // if holding a dirty item clean it (?)
        // if you are dirty clean yourself
        h.increaseThirst(1);
        // sound effect
        break;
      case 164: // urinal
        f.number = Constants.feature_urinalCooldown;
        // if parched drink from urinal
        // sound effect
        break;
      case 165: // toilet
        f.number = Constants.feature_toiletCooldown;
        // if parched drink from toilet
        // sound effect
        break;
      case 171: // stove
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        // StoveInventory which has 4 spots to cook items
        // sound effect
        break;
      case 174: // minifridge
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        // sound effect
        break;
      case 175: // refridgerator
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        // sound effect
        break;
      case 176: // washer
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        // sound effect
        break;
      case 177: // dryer
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        // sound effect
        break;
      case 181: // garbage can
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        // sound effect
        break;
      case 182: // recycle can
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        // sound effect
        break;
      case 183: // crate
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        // sound effect
        break;
      case 184: // cardboard box
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        // sound effect
        break;
      case 185: // pickle jar
        if (h.canPickup()) {
          f.number = Constants.feature_pickleJarCooldown;
          h.pickup(new Item(2106));
          // sound effect
        }
        break;
      case 211: // wire fence
      case 212:
      case 213:
      case 214:
      case 215:
      case 216:
      case 217:
      case 218:
      case 219:
      case 220:
      case 221:
      case 222:
      case 223:
      case 224:
      case 225:
      case 226:
        // climb over
        if (h.holding(2978)) {
          f.remove = true;
          this.currMap.addItem(new Item(2806, f.x + 0.2 + random(0.6), f.y + 0.2 + random(0.6)));
          // sonud effect
        }
        break;
      case 301: // movable brick wall
      case 302:
      case 303:
      case 304:
      case 305:
      case 306:
      case 307:
        f.remove = true;
        // sound effect (?)
        break;
      case 331: // door open (up)
        f.remove = true;
        new_f = new Feature(339, f.x, f.y, false);
        this.currMap.addFeature(new_f);
        new_f.hovered = true;
        this.currMap.hovered_object = new_f;
        // sound effect
        break;
      case 332:
        f.remove = true;
        new_f = new Feature(339, f.x, f.y, true);
        this.currMap.addFeature(new_f);
        new_f.hovered = true;
        this.currMap.hovered_object = new_f;
        // sound effect
        break;
      case 333: // door open (left)
        f.remove = true;
        new_f = new Feature(340, f.x, f.y, false);
        this.currMap.addFeature(new_f);
        new_f.hovered = true;
        this.currMap.hovered_object = new_f;
        // sound effect
        break;
      case 334:
        f.remove = true;
        new_f = new Feature(340, f.x, f.y, true);
        this.currMap.addFeature(new_f);
        new_f.hovered = true;
        this.currMap.hovered_object = new_f;
        // sound effect
        break;
      case 335: // door open (diagonal left)
        f.remove = true;
        new_f = new Feature(341, f.x, f.y, false);
        this.currMap.addFeature(new_f);
        new_f.hovered = true;
        this.currMap.hovered_object = new_f;
        // sound effect
        break;
      case 336:
        f.remove = true;
        new_f = new Feature(341, f.x, f.y, true);
        this.currMap.addFeature(new_f);
        new_f.hovered = true;
        this.currMap.hovered_object = new_f;
        // sound effect
        break;
      case 337: // door open (diagonal right)
        f.remove = true;
        new_f = new Feature(342, f.x, f.y, false);
        this.currMap.addFeature(new_f);
        new_f.hovered = true;
        this.currMap.hovered_object = new_f;
        // sound effect
        break;
      case 338:
        f.remove = true;
        new_f = new Feature(342, f.x, f.y, true);
        this.currMap.addFeature(new_f);
        new_f.hovered = true;
        this.currMap.hovered_object = new_f;
        // sound effect
        break;
      case 339: // door closed (up)
        f.remove = true;
        if (f.toggle) {
          new_f = new Feature(332, f.x, f.y);
        }
        else {
          new_f = new Feature(331, f.x, f.y);
        }
        this.currMap.addFeature(new_f);
        new_f.hovered = true;
        this.currMap.hovered_object = new_f;
        // sound effect
        break;
      case 340: // door closed (left)
        f.remove = true;
        if (f.toggle) {
          new_f = new Feature(334, f.x, f.y);
        }
        else {
          new_f = new Feature(333, f.x, f.y);
        }
        this.currMap.addFeature(new_f);
        new_f.hovered = true;
        this.currMap.hovered_object = new_f;
        // sound effect
        break;
      case 341: // door closed (diagonal left)
        f.remove = true;
        if (f.toggle) {
          new_f = new Feature(336, f.x, f.y);
        }
        else {
          new_f = new Feature(335, f.x, f.y);
        }
        this.currMap.addFeature(new_f);
        new_f.hovered = true;
        this.currMap.hovered_object = new_f;
        // sound effect
        break;
      case 342: // door closed (diagonal right)
        f.remove = true;
        if (f.toggle) {
          new_f = new Feature(338, f.x, f.y);
        }
        else {
          new_f = new Feature(337, f.x, f.y);
        }
        this.currMap.addFeature(new_f);
        new_f.hovered = true;
        this.currMap.hovered_object = new_f;
        // sound effect
        break;
      case 343: // door locked (up)
        if (h.weapon() == null) {
          break;
        }
        boolean unlock = false;
        switch(h.weapon().ID) {
          case 2901: // key
            break;
          case 2902: // master key
            break;
          case 2903: // skeleton key
            break;
        }
        if (unlock) {
          // sound effect
        }
        break;
      case 344: // door locked (left)
        break;
      case 345: // door locked (diagonal left)
        break;
      case 346: // door locked (diagonal right)
        break;
      case 401: // dandelion
        if (h.canPickup()) {
          f.remove = true;
          h.pickup(new Item(2961));
          // sound effect
        }
        break;
      case 411: // gravel (pebbles)
        if (h.canPickup()) {
          h.pickup(new Item(2933));
          f.number--;
          if (f.number < 1) {
            f.remove = true;
            new_f = new Feature(134, f.x, f.y);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
          }
        }
        break;
      case 412: // gravel (rocks)
        if (h.canPickup()) {
          h.pickup(new Item(2931));
          f.number--;
          if (f.number < 1) {
            f.remove = true;
            new_f = new Feature(411, f.x, f.y);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
          }
        }
        break;
      case 441: // bush
      case 442:
      case 443:
        if (h.holding(2204, 2211)) {
          f.number--;
          if (randomChance(Constants.feature_bushDropChance)) {
            this.currMap.addItem(2964, f.x + 0.2 + random(0.6), f.y + 0.2 + random(0.6));
          }
          if (f.number < 1) {
            f.remove = true;
          }
          // sound effect
        }
        break;
      default:
        global.errorMessage("ERROR: Hero " + h.display_name() + " trying to " +
          "interact with feature " + f.display_name() + " but no interaction logic found.");
        break;
    }
  }


  void update(int millis) {
    int timeElapsed = millis - this.last_update_time;
    if (this.currMap != null) {
      this.currMap.update(millis);
      for (Map.Entry<Integer, Trigger> entry : this.triggers.entrySet()) {
        entry.getValue().update(timeElapsed, this);
      }
      if (this.player != null) {
        if (this.player.curr_action == UnitAction.HERO_INTERACTING_WITH_FEATURE) {
          this.player.curr_action = UnitAction.NONE;
          this.heroFeatureInteraction(this.player);
        }
        for (Linker linker : this.linkers) {
          if (linker.rect1.contains(this.player, this.currMapName)) {
            this.movePlayerTo(linker.rect2);
          }
        }
        if (this.player.inventory.item_dropping != null) {
          this.currMap.addItem(new Item(this.player.inventory.item_dropping,
            this.player.frontX(), this.player.frontY()));
          this.player.inventory.item_dropping = null;
        }
        if (this.player.messages.peek() != null) {
          this.currMap.addHeaderMessage(this.player.messages.poll());
        }
      }
    }
    else {
      rectMode(CORNERS);
      noStroke();
      fill(color(60));
      rect(this.xi, this.yi, this.xf, this.yf);
    }
    if (this.player != null) {
      this.player.update_hero(timeElapsed);
    }
    this.last_update_time = millis;
  }

  void mouseMove(float mX, float mY) {
    if (this.currMap != null) {
      this.currMap.mouseMove(mX, mY);
    }
    if (this.player != null) {
      this.player.mouseMove_hero(mX, mY);
    }
  }

  void mousePress() {
    if (this.currMap != null) {
      this.currMap.mousePress();
    }
    if (this.player != null) {
      this.player.mousePress_hero();
    }
  }

  void mouseRelease(float mX, float mY) {
    if (this.currMap != null) {
      this.currMap.mouseRelease(mX, mY);
    }
    if (this.player != null) {
      this.player.mouseRelease_hero(mX, mY);
    }
  }

  void scroll(int amount) {
    if (this.currMap != null) {
      this.currMap.scroll(amount);
    }
    if (this.player != null) {
      this.player.scroll_hero(amount);
    }
  }

  void keyPress() {
    if (this.currMap != null) {
      this.currMap.keyPress();
    }
    if (this.player != null) {
      this.player.keyPress_hero();
    }
  }

  void keyRelease() {
    if (this.currMap != null) {
      this.currMap.keyRelease();
    }
    if (this.player != null) {
      this.player.keyRelease_hero();
    }
  }


  void loseFocus() {
    if (this.currMap != null) {
      this.currMap.loseFocus();
    }
  }

  void gainFocus() {
    if (this.currMap != null) {
      this.currMap.gainFocus();
    }
  }


  String finalFolderPath() {
    String finalFolderPath = this.folderPath;
    if (this.location == Location.ERROR) {
      finalFolderPath += "/" + this.levelName;
    }
    else {
      finalFolderPath += "/" + this.location.file_name();
    }
    return finalFolderPath;
  }


  void save() {
    this.save(true);
  }
  void save(boolean saveMap) {
    String finalFolderPath = this.finalFolderPath();
    if (!folderExists(finalFolderPath)) {
      mkdir(finalFolderPath);
    }
    PrintWriter file = createWriter(finalFolderPath + "/level.lnz");
    file.println("new: Level");
    file.println("levelName: " + this.levelName);
    file.println("location: " + this.location.file_name());
    if (this.currMapName != null) {
      file.println("currMapName: " + this.currMapName);
    }
    String mapNameList = "";
    for (int i = 0; i < this.mapNames.size(); i++) {
      if (i > 0) {
        mapNameList += ", ";
      }
      mapNameList += this.mapNames.get(i);
    }
    file.println("mapNames: " + mapNameList);
    for (Linker linker : this.linkers) {
      file.println(linker.fileString());
    }
    for (Map.Entry<Integer, Trigger> entry : this.triggers.entrySet()) {
      file.println("nextTriggerKey: " + entry.getKey());
      file.println(entry.getValue().fileString());
    }
    if (this.player_start_location != null) {
      file.println("player_start_location: " + this.player_start_location.fileString());
    }
    file.println("end: Level");
    file.flush();
    file.close();
    if (saveMap && this.currMap != null) {
      this.currMap.save(finalFolderPath);
    }
  }


  void open() {
    this.open2Data(this.open1File());
  }


  String[] open1File() {
    String finalFolderPath = this.finalFolderPath();
    String[] lines;
    lines = loadStrings(finalFolderPath + "/level.lnz");
    if (lines == null) {
      global.errorMessage("ERROR: Reading level at path " + finalFolderPath + " but no level file exists.");
      this.nullify = true;
    }
    return lines;
  }


  void open2Data(String[] lines) {
    Stack<ReadFileObject> object_queue = new Stack<ReadFileObject>();

    Linker curr_linker = null;
    int max_trigger_key = 0;
    Trigger curr_trigger = null;
    Condition curr_condition = null;
    Effect curr_effect = null;

    for (String line : lines) {
      String[] parameters = split(line, ':');
      if (parameters.length < 2) {
        continue;
      }

      String datakey = trim(parameters[0]);
      String data = trim(parameters[1]);
      for (int i = 2; i < parameters.length; i++) {
        data += ":" + parameters[i];
      }
      if (datakey.equals("new")) {
        ReadFileObject type = ReadFileObject.objectType(trim(parameters[1]));
        switch(type) {
          case LEVEL:
            object_queue.push(type);
            break;
          case LINKER:
            object_queue.push(type);
            curr_linker = new Linker();
            break;
          case TRIGGER:
            object_queue.push(type);
            curr_trigger = new Trigger();
            break;
          case CONDITION:
            object_queue.push(type);
            curr_condition = new Condition();
            break;
          case EFFECT:
            object_queue.push(type);
            curr_effect = new Effect();
            break;
          default:
            global.errorMessage("ERROR: Can't add a " + type + " type to Level data.");
            break;
        }
      }
      else if (datakey.equals("end")) {
        ReadFileObject type = ReadFileObject.objectType(data);
        if (object_queue.empty()) {
          global.errorMessage("ERROR: Tring to end a " + type.name + " object but not inside any object.");
        }
        else if (type.name.equals(object_queue.peek().name)) {
          switch(object_queue.pop()) {
            case LEVEL:
              return;
            case LINKER:
              if (curr_linker == null) {
                global.errorMessage("ERROR: Trying to end a null linker.");
              }
              this.addLinker(curr_linker);
              curr_linker = null;
              break;
            case TRIGGER:
              if (curr_trigger == null) {
                global.errorMessage("ERROR: Trying to end a null trigger.");
              }
              if (this.nextTriggerKey > max_trigger_key) {
                max_trigger_key = this.nextTriggerKey;
              }
              this.addTrigger(curr_trigger);
              curr_trigger = null;
              break;
            case CONDITION:
              if (curr_condition == null) {
                global.errorMessage("ERROR: Trying to end a null condition.");
              }
              if (object_queue.peek() != ReadFileObject.TRIGGER) {
                global.errorMessage("ERROR: Trying to end a condition while not in a TRIGGER.");
              }
              if (curr_trigger == null) {
                global.errorMessage("ERROR: Trying to end an condition but curr_trigger is null.");
              }
              curr_condition.setName();
              curr_trigger.conditions.add(curr_condition);
              curr_condition = null;
              break;
            case EFFECT:
              if (curr_effect == null) {
                global.errorMessage("ERROR: Trying to end a null effect.");
              }
              if (object_queue.peek() != ReadFileObject.TRIGGER) {
                global.errorMessage("ERROR: Trying to end a effect while not in a TRIGGER.");
              }
              if (curr_trigger == null) {
                global.errorMessage("ERROR: Trying to end an effect but curr_trigger is null.");
              }
              curr_trigger.effects.add(curr_effect);
              curr_effect = null;
              break;
            default:
              break;
          }
        }
        else {
          global.errorMessage("ERROR: Tring to end a " + type.name + " object while inside a " + object_queue.peek().name + " object.");
        }
      }
      else {
        switch(object_queue.peek()) {
          case LEVEL:
            this.addData(datakey, data);
            break;
          case LINKER:
            if (curr_linker == null) {
              global.errorMessage("ERROR: Trying to add linker data to null linker.");
            }
            curr_linker.addData(datakey, data);
            break;
          case TRIGGER:
            if (curr_trigger == null) {
              global.errorMessage("ERROR: Trying to add trigger data to null trigger.");
            }
            curr_trigger.addData(datakey, data);
            break;
          case CONDITION:
            if (curr_condition == null) {
              global.errorMessage("ERROR: Trying to add condition data to null trigger.");
            }
            curr_condition.addData(datakey, data);
            break;
          case EFFECT:
            if (curr_effect == null) {
              global.errorMessage("ERROR: Trying to add effect data to null trigger.");
            }
            curr_effect.addData(datakey, data);
            break;
          default:
            // before or after actual file data
            break;
        }
      }

      this.nextTriggerKey = max_trigger_key + 1;
    }
  }


  void addData(String datakey, String data) {
    switch(datakey) {
      case "levelName":
        this.levelName = data;
        break;
      case "location":
        this.location = Location.location(data);
        break;
      case "currMapName":
        this.currMapName = data;
        break;
      case "mapNames":
        String[] map_names = split(data, ',');
        for (String map_name : map_names) {
          if (!map_name.equals("")) {
            this.mapNames.add(trim(map_name));
          }
        }
        break;
      case "nextTriggerKey":
        this.nextTriggerKey = toInt(data);
        break;
      case "player_start_location":
        this.player_start_location = new Rectangle();
        this.player_start_location.addData(data);
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not recognized for Level object.");
        break;
    }
  }
}



class LevelEditor extends Level {
  protected Rectangle last_rectangle = null;

  LevelEditor() {
  }
  LevelEditor(String folderPath, String levelName) {
    this.folderPath = folderPath;
    this.levelName = levelName;
    this.open();
  }

  @Override
  void openMap(String mapName) {
    if (mapName == null) {
      return;
    }
    if (!fileExists(this.finalFolderPath() + "/" + mapName + ".map.lnz")) {
      global.errorMessage("ERROR: Level " + this.levelName + " has no map " +
        "with name " + mapName + ".");
      return;
    }
    if (mapName.equals(this.currMapName)) {
      return;
    }
    this.currMapName = mapName;
    this.currMap = new GameMapLevelEditor(mapName, this.finalFolderPath());
    this.currMap.setLocation(this.xi, this.yi, this.xf, this.yf);
  }


  void newLinker() {
    if (this.last_rectangle == null) {
      return;
    }
    if (this.currMap == null) {
      return;
    }
    if (!GameMapLevelEditor.class.isInstance(this.currMap)) {
      return;
    }
    if (((GameMapLevelEditor)this.currMap).rectangle_dropping == null) {
      return;
    }
    Linker linker = new Linker(this.last_rectangle, ((GameMapLevelEditor)this.currMap).rectangle_dropping);
    this.addLinker(linker);
  }


  void newTrigger() {
    this.addTrigger(new Trigger("Trigger " + this.nextTriggerKey));
  }


  @Override
  void update(int millis) {
    if (this.currMap != null) {
      this.currMap.update(millis);
    }
    else {
      rectMode(CORNERS);
      noStroke();
      fill(color(60));
      rect(this.xi, this.yi, this.xf, this.yf);
    }
    if (this.currMap != null && this.last_rectangle != null && this.last_rectangle.mapName.equals(this.currMapName)) {
      fill(170, 100);
      rectMode(CORNERS);
      noStroke();
      float rect_xi = max(this.currMap.startSquareX, this.last_rectangle.xi);
      float rect_yi = max(this.currMap.startSquareY, this.last_rectangle.yi);
      float rect_xf = min(this.currMap.startSquareX + this.currMap.visSquareX, this.last_rectangle.xf);
      float rect_yf = min(this.currMap.startSquareY + this.currMap.visSquareY, this.last_rectangle.yf);
      rect(this.currMap.xi_map + (rect_xi - this.currMap.startSquareX) * this.currMap.zoom,
        this.currMap.yi_map + (rect_yi - this.currMap.startSquareY) * this.currMap.zoom,
        this.currMap.xi_map + (rect_xf - this.currMap.startSquareX) * this.currMap.zoom,
        this.currMap.yi_map + (rect_yf - this.currMap.startSquareY) * this.currMap.zoom);
    }
  }

  @Override
  void keyPress() {
    super.keyPress();
    if (key == CODED) {
      switch(keyCode) {}
    }
    else {
      switch(key) {
        case 's':
          if (this.currMap != null && GameMapLevelEditor.class.isInstance(this.currMap)) {
            this.last_rectangle = ((GameMapLevelEditor)this.currMap).rectangle_dropping;
            ((GameMapLevelEditor)this.currMap).rectangle_dropping = null;
          }
          break;
        case 'S':
          if (this.currMap != null && GameMapLevelEditor.class.isInstance(this.currMap)) {
            this.last_rectangle = ((GameMapLevelEditor)this.currMap).rectangle_dropping;
            ((GameMapLevelEditor)this.currMap).rectangle_dropping = null;
            if (this.last_rectangle != null) {
              this.player_start_location = this.last_rectangle;
              this.currMap.headerMessages.clear();
              this.currMap.addHeaderMessage("Player start location set");
            }
          }
          break;
      }
    }
  }
}
