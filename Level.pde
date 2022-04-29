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

  protected LevelForm level_form = null;
  protected LevelQuestBox level_questbox = null;
  protected LevelChatBox level_chatbox = null;
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
  protected boolean restart_timers = false;

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


  void addTestPlayer() {
    this.player = new Hero(HeroCode.DAN);
    this.player.setLocation(0.5, 0.5);
    this.currMap.addPlayer(this.player);
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
    if (this.player != null) {
      this.player.heroTree.setLocation(xi, yi, xf, yf);
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
    if (this.level_questbox == null) {
      this.level_questbox = new LevelQuestBox();
    }
    this.level_questbox.setXLocation(this.xf + Constants.mapEditor_listBoxGap, width - Constants.mapEditor_listBoxGap);
    this.level_questbox.update(millis);
    if (this.level_chatbox == null) {
      this.level_chatbox = new LevelChatBox();
    }
    this.level_chatbox.setXLocation(this.xf + Constants.mapEditor_listBoxGap, width - Constants.mapEditor_listBoxGap);
    this.level_chatbox.update(millis);
  }


  void heroFeatureInteraction(Hero h, boolean use_item) {
    if (this.currMap == null || h == null || h.object_targeting == null || h.object_targeting.remove) {
      return;
    }
    if (h.weapon() == null) {
      use_item = false;
    }
    if (!Feature.class.isInstance(h.object_targeting)) {
      global.errorMessage("ERROR: Hero " + h.display_name() + " trying to " +
        "interact with feature " + h.display_name() + " but it's not a feature.");
      return;
    }
    Feature f = (Feature)h.object_targeting;
    Feature new_f;
    int item_id = 0;
    Item new_i;
    float random_number = random(1);
    switch(f.ID) {
      case 11: // khalil
        if (f.toggle) {
          this.level_form = new KhalilForm(f, h);
          global.defaultCursor();
          f.toggle = false;
        }
        else {
          f.toggle = true;
          if (randomChance(0.5)) {
            this.chat("Traveling Buddy: I am a caterpillar. Well, that's not " +
              "entirely true. My mother was a caterpillar, my father was a worm, " +
              "but I'm okay with that now.");
          }
          else {
            this.chat("Traveling Buddy: I am a small business operator; a " +
              "traveling salesman. I sell Persian rugs door-to-door!");
          }
          this.currMap.addVisualEffect(4009, f.x + 0.6, f.y - 0.4);
        }
        break;
      case 12: // chuck quizmo
        if (f.toggle) {
          this.level_form = new QuizmoForm(f, h);
          global.defaultCursor();
          f.toggle = false;
        }
        else {
          f.toggle = true;
          this.chat("Chuck Quizmo: Chuck Quizmo's the name, and quizzes are my " +
            "game! You want quizzes, I got 'em! If you can manage to answer my " +
            "brain-busting questions correctly, then... Y... Yaa... Yaaaaaahooo! " +
            "I'll give you a Star Piece!");
          this.currMap.addVisualEffect(4009, f.x + 0.7, f.y - 0.4);
        }
        break;
      case 22: // ender chest
        global.viewingEnderChest();
        if (global.state == ProgramState.MAPEDITOR_INTERFACE) {
          f.inventory = new EnderChestInventory();
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        break;
      case 101: // wooden table
      case 111: // wooden chair
      case 112:
      case 113:
      case 114:
      case 125: // wooden bench
      case 126:
      case 127:
      case 128:
        if (!h.holding(2977, 2979, 2980, 2983)) {
          break;
        }
        switch(h.weapon().ID) {
          case 2977: // ax
            f.number -= 3;
            break;
          case 2979: // saw
            f.number -= 1;
            break;
          case 2980: // drill
            f.number -= 1;
            break;
          case 2983: // chainsaw
            f.number -= 2;
            break;
        }
        if (f.number < 1) {
          f.destroy(this.currMap);
        }
        break;
      case 102: // wooden desk
      case 103:
        if (use_item && h.holding(2977, 2979, 2980, 2983)) {
          switch(h.weapon().ID) {
            case 2977: // ax
              f.number -= 3;
              break;
            case 2979: // saw
              f.number -= 1;
              break;
            case 2980: // drill
              f.number -= 1;
              break;
            case 2983: // chainsaw
              f.number -= 2;
              break;
          }
          if (f.number < 1) {
            f.destroy(this.currMap);
          }
          break;
        }
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        ((DeskInventory)f.inventory).closeDrawers();
        break;
      case 115: // coordinator chair
      case 121: // couch
      case 122:
      case 123:
      case 124:
        if (use_item && h.holding(2977, 2979, 2980, 2983)) {
          switch(h.weapon().ID) {
            case 2977: // ax
              f.number -= 3;
              break;
            case 2979: // saw
              f.number -= 1;
              break;
            case 2980: // drill
              f.number -= 1;
              break;
            case 2983: // chainsaw
              f.number -= 2;
              break;
          }
          if (f.number < 1) {
            f.destroy(this.currMap);
          }
          break;
        }
        if (!f.toggle) {
          this.currMap.addHeaderMessage("This " + f.display_name() + " has nothing in it.");
          break;
        }
        if (random_number > 0.99) {
          item_id = 2154;
        }
        else if (random_number > 0.96) {
          item_id = 2153;
        }
        else if (random_number > 0.9) {
          item_id = 2152;
        }
        else if (random_number > 0.75) {
          item_id = 2151;
        }
        else if (random_number > 0.72) {
          item_id = 2101;
        }
        else if (random_number > 0.69) {
          item_id = 2102;
        }
        else if (random_number > 0.66) {
          item_id = 2103;
        }
        else if (random_number > 0.63) {
          item_id = 2104;
        }
        else if (random_number > 0.6) {
          item_id = 2105;
        }
        else if (random_number > 0.58) {
          item_id = 2107;
        }
        else if (random_number > 0.57) {
          item_id = 2110;
        }
        else if (random_number > 0.56) {
          item_id = 2112;
        }
        else if (random_number > 0.55) {
          item_id = 2113;
        }
        else if (random_number > 0.54) {
          item_id = 2132;
        }
        else if (random_number > 0.53) {
          item_id = 2134;
        }
        else if (random_number > 0.52) {
          item_id = 2402;
        }
        else if (random_number > 0.51) {
          item_id = 2502;
        }
        else if (random_number > 0.5) {
          item_id = 2602;
        }
        else if (random_number > 0.49) {
          item_id = 2603;
        }
        else if (random_number > 0.48) {
          item_id = 2604;
        }
        else if (random_number > 0.45) {
          item_id = 2702;
        }
        else if (random_number > 0.44) {
          item_id = 2703;
        }
        else if (random_number > 0.43) {
          item_id = 2911;
        }
        else if (random_number > 0.42) {
          item_id = 2912;
        }
        else if (random_number > 0.41) {
          item_id = 2913;
        }
        else if (random_number > 0.39) {
          item_id = 2916;
        }
        else if (random_number > 0.38) {
          item_id = 2917;
        }
        else if (random_number > 0.35) {
          item_id = 2924;
        }
        else if (random_number > 0.33) {
          item_id = 2931;
        }
        else if (random_number > 0.31) {
          item_id = 2933;
        }
        else {
          f.toggle = false;
          this.currMap.addHeaderMessage("This " + f.display_name() + " has nothing left in it.");
          break;
        }
        new_i = new Item(item_id, h.frontX(), h.frontY());
        if (h.canPickup()) {
          h.pickup(new_i);
        }
        else {
          this.currMap.addItem(new_i);
        }
        this.currMap.addHeaderMessage("You found a " + new_i.display_name() + ".");
        // sound effect
        break;
      case 131: // bed
      case 132:
      case 133:
      case 134:
        if (use_item && h.holding(2977, 2979, 2980, 2983)) {
          switch(h.weapon().ID) {
            case 2977: // ax
              f.number -= 3;
              break;
            case 2979: // saw
              f.number -= 1;
              break;
            case 2980: // drill
              f.number -= 1;
              break;
            case 2983: // chainsaw
              f.number -= 2;
              break;
          }
          if (f.number < 1) {
            f.destroy(this.currMap);
          }
          break;
        }
        if (!f.toggle) {
          this.currMap.addHeaderMessage("This " + f.display_name() + " has nothing in it.");
          break;
        }
        if (random_number > 0.99) {
          item_id = 2154;
        }
        else if (random_number > 0.96) {
          item_id = 2153;
        }
        else if (random_number > 0.91) {
          item_id = 2152;
        }
        else if (random_number > 0.73) {
          item_id = 2151;
        }
        else if (random_number > 0.7) {
          item_id = 2101;
        }
        else if (random_number > 0.69) {
          item_id = 2102;
        }
        else if (random_number > 0.68) {
          item_id = 2103;
        }
        else if (random_number > 0.67) {
          item_id = 2104;
        }
        else if (random_number > 0.66) {
          item_id = 2105;
        }
        else if (random_number > 0.65) {
          item_id = 2134;
        }
        else if (random_number > 0.63) {
          item_id = 2402;
        }
        else if (random_number > 0.6) {
          item_id = 2502;
        }
        else if (random_number > 0.57) {
          item_id = 2602;
        }
        else if (random_number > 0.55) {
          item_id = 2603;
        }
        else if (random_number > 0.54) {
          item_id = 2604;
        }
        else if (random_number > 0.52) {
          item_id = 2916;
        }
        else if (random_number > 0.51) {
          item_id = 2925;
        }
        else if (random_number > 0.5) {
          item_id = 2933;
        }
        else {
          f.toggle = false;
          this.currMap.addHeaderMessage("This " + f.display_name() + " has nothing left in it.");
          break;
        }
        new_i = new Item(item_id, h.frontX(), h.frontY());
        if (h.canPickup()) {
          h.pickup(new_i);
        }
        else {
          this.currMap.addItem(new_i);
        }
        this.currMap.addHeaderMessage("You found a " + new_i.display_name() + ".");
        // sound effect
        break;
      case 141: // wardrobe
      case 142:
        if (use_item && h.holding(2977, 2979, 2980, 2983)) {
          switch(h.weapon().ID) {
            case 2977: // ax
              f.number -= 3;
              break;
            case 2979: // saw
              f.number -= 1;
              break;
            case 2980: // drill
              f.number -= 1;
              break;
            case 2983: // chainsaw
              f.number -= 2;
              break;
          }
          if (f.number < 1) {
            f.destroy(this.currMap);
          }
          break;
        }
        if (!f.toggle) {
          this.currMap.addHeaderMessage("This " + f.display_name() + " has nothing in it.");
          break;
        }
        if (random_number > 0.99) {
          item_id = 2154;
        }
        else if (random_number > 0.98) {
          item_id = 2153;
        }
        else if (random_number > 0.95) {
          item_id = 2152;
        }
        else if (random_number > 0.9) {
          item_id = 2151;
        }
        else if (random_number > 0.88) {
          item_id = 2101;
        }
        else if (random_number > 0.87) {
          item_id = 2102;
        }
        else if (random_number > 0.86) {
          item_id = 2103;
        }
        else if (random_number > 0.85) {
          item_id = 2104;
        }
        else if (random_number > 0.84) {
          item_id = 2105;
        }
        else if (random_number > 0.83) {
          item_id = 2107;
        }
        else if (random_number > 0.82) {
          item_id = 2110;
        }
        else if (random_number > 0.81) {
          item_id = 2111;
        }
        else if (random_number > 0.8) {
          item_id = 2112;
        }
        else if (random_number > 0.785) {
          item_id = 2113;
        }
        else if (random_number > 0.77) {
          item_id = 2132;
        }
        else if (random_number > 0.755) {
          item_id = 2133;
        }
        else if (random_number > 0.74) {
          item_id = 2134;
        }
        else if (random_number > 0.73) {
          item_id = 2141;
        }
        else if (random_number > 0.71) {
          item_id = 2203;
        }
        else if (random_number > 0.68) {
          item_id = 2402;
        }
        else if (random_number > 0.65) {
          item_id = 2502;
        }
        else if (random_number > 0.63) {
          item_id = 2504;
        }
        else if (random_number > 0.62) {
          item_id = 2513;
        }
        else if (random_number > 0.6) {
          item_id = 2602;
        }
        else if (random_number > 0.58) {
          item_id = 2603;
        }
        else if (random_number > 0.56) {
          item_id = 2604;
        }
        else if (random_number > 0.53) {
          item_id = 2702;
        }
        else if (random_number > 0.51) {
          item_id = 2703;
        }
        else if (random_number > 0.5) {
          item_id = 2704;
        }
        else if (random_number > 0.49) {
          item_id = 2705;
        }
        else if (random_number > 0.48) {
          item_id = 2712;
        }
        else if (random_number > 0.47) {
          item_id = 2713;
        }
        else if (random_number > 0.46) {
          item_id = 2714;
        }
        else if (random_number > 0.45) {
          item_id = 2911;
        }
        else if (random_number > 0.44) {
          item_id = 2912;
        }
        else if (random_number > 0.43) {
          item_id = 2913;
        }
        else if (random_number > 0.42) {
          item_id = 2914;
        }
        else if (random_number > 0.41) {
          item_id = 2916;
        }
        else if (random_number > 0.4) {
          item_id = 2917;
        }
        else if (random_number > 0.38) {
          item_id = 2918;
        }
        else if (random_number > 0.37) {
          item_id = 2924;
        }
        else if (random_number > 0.36) {
          item_id = 2925;
        }
        else {
          f.toggle = false;
          this.currMap.addHeaderMessage("This " + f.display_name() + " has nothing left in it.");
          break;
        }
        new_i = new Item(item_id, h.frontX(), h.frontY());
        if (h.canPickup()) {
          h.pickup(new_i);
        }
        else {
          this.currMap.addItem(new_i);
        }
        this.currMap.addHeaderMessage("You found a " + new_i.display_name() + ".");
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
        global.sounds.trigger_environment("features/water_fountain",
          f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        if (use_item && h.holding(2924, 2925, 2926, 2927)) {
          h.weapon().changeAmmo(3);
        }
        // if holding a dirty item clean it (?)
        else {
          h.increaseThirst(3);
          global.sounds.trigger_environment("features/water_fountain_drink",
            f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        }
        break;
      case 162: // sink
        if (use_item && h.holding(2924, 2925, 2926, 2927)) {
          h.weapon().changeAmmo(4);
        }
        // if holding a dirty item clean it (?)
        else {
          h.increaseThirst(2);
          global.sounds.trigger_environment("features/water_fountain_drink",
            f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        }
        global.sounds.trigger_environment("features/sink",
          f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        break;
      case 163: // shower stall
        f.number = Constants.feature_showerStallCooldown;
        // if holding a dirty item clean it (?)
        // if you are dirty clean yourself
        h.increaseThirst(1);
        global.sounds.trigger_environment("features/shower_stall",
          f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        break;
      case 164: // urinal
        f.number = Constants.feature_urinalCooldown;
        if (h.thirst < Constants.hero_thirstThreshhold) {
          h.increaseThirst(3);
        }
        global.sounds.trigger_environment("features/urinal",
          f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        break;
      case 165: // toilet
        f.number = Constants.feature_toiletCooldown;
        if (h.thirst < Constants.hero_thirstThreshhold) {
          h.increaseThirst(3);
        }
        global.sounds.trigger_environment("features/toilet",
          f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        break;
      case 171: // stove
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        global.sounds.trigger_environment("features/stove_open",
          f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        break;
      case 172: // vending machine
      case 173:
        this.level_form = new VendingForm(f, h);
        global.defaultCursor();
        break;
      case 174: // minifridge
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        global.sounds.trigger_environment("features/fridge",
          f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        break;
      case 175: // refridgerator
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        global.sounds.trigger_environment("features/fridge",
          f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        break;
      case 176: // washer
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        global.sounds.trigger_environment("features/washer",
          f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        break;
      case 177: // dryer
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        global.sounds.trigger_environment("features/dryer",
          f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        break;
      case 181: // garbage can
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        global.sounds.trigger_environment("features/trash_can",
          f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        break;
      case 182: // recycle can
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        global.sounds.trigger_environment("features/trash_can",
          f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        break;
      case 183: // crate
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        global.sounds.trigger_environment("features/crate",
          f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        // sound effect
        break;
      case 184: // cardboard box
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        global.sounds.trigger_environment("features/cardboard_box",
          f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        break;
      case 185: // pickle jar
        if (use_item && h.holding(2975)) {
          f.destroy(this.currMap);
          break;
        }
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
        // climb over (?)
        if (h.holding(2978)) {
          f.destroy(this.currMap);
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
      case 321: // window (open)
        if (use_item && h.holding(2976)) {
          f.destroy(this.currMap);
          break;
        }
        f.remove = true;
        new_f = new Feature(322, f.x, f.y, false);
        this.currMap.addFeature(new_f);
        new_f.hovered = true;
        this.currMap.hovered_object = new_f;
        // sound effect
        break;
      case 322: // window (closed)
        if (use_item && h.holding(2976)) {
          f.destroy(this.currMap);
          break;
        }
        f.remove = true;
        new_f = new Feature(321, f.x, f.y, false);
        this.currMap.addFeature(new_f);
        new_f.hovered = true;
        this.currMap.hovered_object = new_f;
        // sound effect
        break;
      case 323: // window (locked)
        if (!h.holding(2976)) {
          this.currMap.addHeaderMessage("The window is locked");
          break;
        }
        f.destroy(this.currMap);
        break;
      case 331: // wooden door (open)
      case 332:
      case 333:
      case 334:
      case 335:
      case 336:
      case 337:
      case 338:
      case 339: // wooden door (closed)
      case 340:
      case 341:
      case 342:
      case 343: // wooden door (locked)
      case 344:
      case 345:
      case 346:
        if (use_item && h.holding(2977, 2979, 2983)) {
          f.destroy(this.currMap);
          break;
        }
        switch(f.ID) {
          case 331: // door open (up)
            f.remove = true;
            new_f = new Feature(339, f.x, f.y, false);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/wooden_door_close",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 332:
            f.remove = true;
            new_f = new Feature(339, f.x, f.y, true);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/wooden_door_close",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 333: // door open (left)
            f.remove = true;
            new_f = new Feature(340, f.x, f.y, false);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/wooden_door_close",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 334:
            f.remove = true;
            new_f = new Feature(340, f.x, f.y, true);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/wooden_door_close",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 335: // door open (diagonal left)
            f.remove = true;
            new_f = new Feature(341, f.x, f.y, false);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/wooden_door_close",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 336:
            f.remove = true;
            new_f = new Feature(341, f.x, f.y, true);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/wooden_door_close",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 337: // door open (diagonal right)
            f.remove = true;
            new_f = new Feature(342, f.x, f.y, false);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/wooden_door_close",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 338:
            f.remove = true;
            new_f = new Feature(342, f.x, f.y, true);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/wooden_door_close",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
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
            global.sounds.trigger_environment("features/wooden_door_open",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
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
            global.sounds.trigger_environment("features/wooden_door_open",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
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
            global.sounds.trigger_environment("features/wooden_door_open",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
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
            global.sounds.trigger_environment("features/wooden_door_open",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 343: // door locked (up)
            if (h.weapon() == null || !h.weapon().unlocks(f.number)) {
              this.currMap.addHeaderMessage("The door is locked");
              break;
            }
            f.remove = true;
            new_f = new Feature(339, f.x, f.y, f.toggle);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/wooden_door_unlock",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 344: // door locked (left)
            if (h.weapon() == null || !h.weapon().unlocks(f.number)) {
              this.currMap.addHeaderMessage("The door is locked");
              break;
            }
            f.remove = true;
            new_f = new Feature(340, f.x, f.y, f.toggle);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/wooden_door_unlock",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 345: // door locked (diagonal left)
            if (h.weapon() == null || !h.weapon().unlocks(f.number)) {
              this.currMap.addHeaderMessage("The door is locked");
              break;
            }
            f.remove = true;
            new_f = new Feature(341, f.x, f.y, f.toggle);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/wooden_door_unlock",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 346: // door locked (diagonal right)
            if (h.weapon() == null || !h.weapon().unlocks(f.number)) {
              this.currMap.addHeaderMessage("The door is locked");
              break;
            }
            f.remove = true;
            new_f = new Feature(342, f.x, f.y, f.toggle);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/wooden_door_unlock",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
        }
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
      case 421: // tree (maple)
      case 422: // tree (unknown)
      case 423: // tree (cedar)
      case 424: // tree (dead)
      case 425: // tree (large)
      case 426: // tree (pine)
        int branch_id = 0;
        switch(f.ID) {
          case 421:
            branch_id = 2965;
            break;
          case 422:
            branch_id = 2966;
            break;
          case 423:
            branch_id = 2967;
            break;
          case 424:
            branch_id = 2963;
            break;
          case 425:
            branch_id = 2965;
            break;
          case 426:
            branch_id = 2968;
            break;
        }
        if (!use_item || !h.holding(2977, 2979, 2983)) {
          if (f.toggle) {
            this.currMap.addItem(new Item(branch_id, h.frontX(), h.frontY()));
            if (randomChance(Constants.feature_treeChanceEndBranches)) {
              f.toggle = false;
            }
          }
        }
        else {
          switch(h.weapon().ID) {
            case 2977: // ax
              f.number -= 2;
              break;
            case 2979: // saw
              f.number -= 1;
              break;
            case 2983: // chainsaw
              f.number -= 4;
              break;
          }
          if (randomChance(Constants.feature_treeDropChance)) {
            this.currMap.addItem(new Item(branch_id, h.frontX(), h.frontY()));
          }
          if (f.number < 1) {
            f.destroy(this.currMap);
          }
          // sound effect (based on item)
        }
        break;
      case 441: // bush
      case 442:
      case 443:
        if (use_item && h.holding(2204, 2211)) {
          f.number--;
          if (randomChance(Constants.feature_bushDropChance)) {
            this.currMap.addItem(new Item(2964, f.x + 0.2 + random(0.6), f.y + 0.2 + random(0.6)));
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


  void restartTimers() {
    this.restart_timers = true;
  }
  void restartTimers(int millis) {
    this.last_update_time = millis;
    if (this.currMap != null) {
      this.currMap.lastUpdateTime = millis;
    }
    // triggers
  }


  void update(int millis) {
    if (this.restart_timers) {
      this.restart_timers = false;
      this.restartTimers(millis);
    }
    int timeElapsed = millis - this.last_update_time;
    if (this.player != null && this.player.heroTree.curr_viewing) {
      this.player.heroTree.update(timeElapsed);
      this.last_update_time = millis;
      return;
    }
    if (this.level_form != null) {
      this.level_form.update(millis);
      if (this.level_form.canceled) {
        this.level_form = null;
        this.restartTimers(millis);
      }
      this.last_update_time = millis;
      return;
    }
    if (this.currMap != null) {
      this.currMap.update(millis);
      for (Map.Entry<Integer, Trigger> entry : this.triggers.entrySet()) {
        entry.getValue().update(timeElapsed, this);
      }
      if (this.player != null) {
        if (this.player.curr_action == UnitAction.HERO_INTERACTING_WITH_FEATURE) {
          this.heroFeatureInteraction(this.player, false);
          this.player.stopAction();
        }
        else if (this.player.curr_action == UnitAction.HERO_INTERACTING_WITH_FEATURE_WITH_ITEM) {
          this.heroFeatureInteraction(this.player, true);
          this.player.stopAction();
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
        if (this.player.inventory.viewing) {
          if (this.player.inventory.item_holding != null) {
            this.currMap.selected_object = this.player.inventory.item_holding;
          }
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
    if (this.level_questbox != null) {
      this.level_questbox.mouseMove(mX, mY);
    }
    if (this.level_chatbox != null) {
      this.level_chatbox.mouseMove(mX, mY);
    }
    if (this.player != null) {
      if (this.player.heroTree.curr_viewing) {
        this.player.heroTree.mouseMove(mX, mY);
        if (this.player.left_panel_menu != null) {
          this.player.left_panel_menu.mouseMove(mX, mY);
        }
        return;
      }
      else {
        this.player.mouseMove_hero(mX, mY);
      }
    }
    if (this.level_form != null) {
      this.level_form.mouseMove(mX, mY);
      return;
    }
    if (this.currMap != null) {
      this.currMap.mouseMove(mX, mY);
    }
  }

  void mousePress() {
    if (this.level_questbox != null) {
      this.level_questbox.mousePress();
    }
    if (this.level_chatbox != null) {
      this.level_chatbox.mousePress();
    }
    if (this.player != null) {
      if (this.player.heroTree.curr_viewing) {
        this.player.heroTree.mousePress();
        if (this.player.left_panel_menu != null) {
          this.player.left_panel_menu.mousePress();
        }
        return;
      }
      else {
        this.player.mousePress_hero();
      }
    }
    if (this.level_form != null) {
      this.level_form.mousePress();
      return;
    }
    if (this.currMap != null) {
      this.currMap.mousePress();
    }
  }

  void mouseRelease(float mX, float mY) {
    if (this.level_questbox != null) {
      this.level_questbox.mouseRelease(mX, mY);
    }
    if (this.level_chatbox != null) {
      this.level_chatbox.mouseRelease(mX, mY);
    }
    if (this.player != null) {
      if (this.player.heroTree.curr_viewing) {
        this.player.heroTree.mouseRelease(mX, mY);
        if (this.player.left_panel_menu != null) {
          this.player.left_panel_menu.mouseRelease(mX, mY);
        }
        return;
      }
      else {
        this.player.mouseRelease_hero(mX, mY);
      }
    }
    if (this.level_form != null) {
      this.level_form.mouseRelease(mX, mY);
      return;
    }
    if (this.currMap != null) {
      this.currMap.mouseRelease(mX, mY);
    }
  }

  void scroll(int amount) {
    if (this.level_questbox != null) {
      this.level_questbox.scroll(amount);
    }
    if (this.level_chatbox != null) {
      this.level_chatbox.scroll(amount);
    }
    if (this.player != null) {
      if (this.player.heroTree.curr_viewing) {
        this.player.heroTree.scroll(amount);
        return;
      }
      else {
        this.player.scroll_hero(amount);
      }
    }
    if (this.level_form != null) {
      this.level_form.scroll(amount);
      return;
    }
    if (this.currMap != null) {
      this.currMap.scroll(amount);
    }
  }

  void keyPress() {
    if (this.player != null) {
      if (this.player.heroTree.curr_viewing) {
        this.player.heroTree.keyPress();
        if (key == CODED) {
          switch(keyCode) {
          }
        }
        else {
          switch(key) {
            case ESC:
              this.player.heroTree.curr_viewing = false;
              this.restartTimers();
              break;
            case 't':
            case 'T':
              if (global.holding_ctrl) {
                this.player.heroTree.curr_viewing = false;
                this.restartTimers();
                global.defaultCursor();
              }
              break;
          }
        }
        return;
      }
      else {
        this.player.keyPress_hero();
      }
    }
    if (this.level_form != null) {
      this.level_form.keyPress();
      return;
    }
    if (this.currMap != null) {
      this.currMap.keyPress();
    }
    if (key == CODED) {
      switch(keyCode) {
      }
    }
    else {
      switch(key) {
        case 't':
        case 'T':
          if (global.holding_ctrl && this.player != null) {
            this.player.heroTree.curr_viewing = true;
          }
          break;
      }
    }
  }

  void keyRelease() {
    if (this.player != null) {
      if (this.player.heroTree.curr_viewing) {
        this.player.heroTree.keyRelease();
        return;
      }
      else {
        this.player.keyRelease_hero();
      }
    }
    if (this.level_form != null) {
      this.level_form.keyRelease();
      return;
    }
    if (this.currMap != null) {
      this.currMap.keyRelease();
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
    global.profile.save(); // needed for ender chest to work properly
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



  class LevelQuestBox extends ListTextBox {
    LevelQuestBox() {
      super(width, Constants.mapEditor_listBoxGap, width, Constants.
        level_questBoxHeightRatio * height - Constants.mapEditor_listBoxGap);
      this.color_background = color(250, 190, 140);
      this.color_header = color(220, 180, 130);
      this.setTitleText("Quests");
    }

    void click() {
    }

    void doubleclick() {
    }
  }


  void chat(String message) {
    this.level_chatbox.chat(message);
  }

  class LevelChatBox extends TextBox {
    boolean first_message = true;

    LevelChatBox() {
      super(width, Constants.level_questBoxHeightRatio * height, width,
        0.9 * height - Constants.mapEditor_listBoxGap);
      this.color_background = color(250, 190, 140);
      this.color_header = color(220, 180, 130);
      this.setTitleText("Chat Log");
    }

    void chat(String message) {
      global.sounds.trigger_player("player/chat");
      if (this.first_message) {
        this.addText(message);
        this.first_message = false;
      }
      else {
        this.addText("\n\n" + message);
      }
      this.scrollbar.scrollMax();
    }
  }



  abstract class LevelForm extends FormLNZ {
    LevelForm(float xi, float yi, float xf, float yf) {
      super(xi, yi, xf, yf);
      this.setTitleSize(18);
      this.color_background = color(211, 188, 141);
      this.color_header = color(220, 200, 150);
      global.defaultCursor();
      this.min_x = Level.this.xi;
      this.min_y = Level.this.yi;
      this.max_x = Level.this.xf;
      this.max_y = Level.this.yf;
    }
  }



  class VendingForm extends LevelForm {
    protected Feature vending_machine;
    protected Hero hero_looking;

    VendingForm(Feature f, Hero h) {
      super(0.5 * (width - Constants.level_vendingFormWidth), 0.5 * (height - Constants.level_vendingFormHeight),
        0.5 * (width + Constants.level_vendingFormWidth), 0.5 * (height + Constants.level_vendingFormHeight));
      this.vending_machine = f;
      this.hero_looking = h;
      this.setTitleText(this.vending_machine.display_name());

      this.addField(new SpacerFormField(20));
      this.addField(new ButtonsFormField("Insert $1", "Insert $5"));
      this.addField(new MessageFormField("$" + this.vending_machine.number));
      this.addField(new MessageFormField(""));
      RadiosFormField choices = new RadiosFormField("Choices");
      switch(this.vending_machine.ID) {
        case 172: // food
          choices.addRadio("Chips, $1");
          choices.addRadio("Pretzels, $1");
          choices.addRadio("Chocolate, $2");
          choices.addRadio("Donut, $2");
          choices.addRadio("Poptart, $2");
          choices.addRadio("Peanuts, $1");
          break;
        case 173: // drink
          choices.addRadio("Water, $1");
          choices.addRadio("Coke, $1");
          choices.addRadio("Diet Coke, $1");
          choices.addRadio("Juice, $1");
          choices.addRadio("Energy Drink, $2");
          break;
        default:
          global.errorMessage("ERROR: Can't create VendingForm with feature of " +
            "ID " + this.vending_machine.ID + ".");
          break;
      }
      this.addField(choices);
      this.addField(new SubmitFormField(" Vend "));
    }

    @Override
    void buttonPress(int i) {
      if (i != 1) {
        global.errorMessage("ERROR: Pressed button other than insert on VendingForm.");
        return;
      }
      int money_inserted = 1 + 4 * toInt(this.fields.get(1).getValue());
      if (this.hero_looking.money < money_inserted) {
        this.fields.get(3).setValue("You don't have $" + money_inserted + " to insert.");
        return;
      }
      this.hero_looking.money -= money_inserted;
      global.sounds.trigger_environment("features/vending_machine_coin",
        this.vending_machine.xCenter() - Level.this.currMap.viewX,
        this.vending_machine.yCenter() - Level.this.currMap.viewY);
      if (randomChance(Constants.feature_vendingEatMoneyChance)) {
        this.fields.get(3).setValue("The vending machine ate your money.");
        return;
      }
      this.vending_machine.number += money_inserted;
      this.fields.get(2).setValue("$" + this.vending_machine.number);
      this.fields.get(3).setValue("Please make your selection.");
    }

    void submit() {
      int selection = toInt(this.fields.get(4).getValue());
      if (selection < 0) {
        this.fields.get(3).setValue("Please make a selection.");
        return;
      }
      int cost = 0;
      int item_id = 0;
      switch(this.vending_machine.ID) {
        case 172: // food
          switch(selection) {
            case 0:
              cost = 1;
              item_id = 2113;
              break;
            case 1:
              this.fields.get(3).setValue("Out of stock.");
              return;
            case 2:
              cost = 2;
              item_id = 2112;
              break;
            case 3:
              cost = 2;
              item_id = 2111;
              break;
            case 4:
              cost = 2;
              item_id = 2110;
              break;
            case 5:
              cost = 1;
              item_id = 2115;
              break;
          }
          break;
        case 173: // drink
          switch(selection) {
            case 0:
              cost = 1;
              item_id = 2924;
              break;
            case 1:
              cost = 1;
              item_id = 2132;
              break;
            case 2:
              this.fields.get(3).setValue("Out of stock.");
              return;
            case 3:
              cost = 1;
              item_id = 2133;
              break;
            case 4:
              this.fields.get(3).setValue("Out of stock.");
              return;
          }
          break;
      }
      if (this.vending_machine.number < cost) {
        this.fields.get(3).setValue("Please insert more money to purchase.");
        return;
      }
      this.vending_machine.number -= cost;
      Item new_item = new Item(item_id, this.vending_machine.x +
        0.2 + random(0.4), this.vending_machine.y + 0.85);
      if (item_id == 2924) {
        new_item.ammo = new_item.maximumAmmo();
      }
      Level.this.currMap.addItem(new_item);
      global.sounds.trigger_environment("features/vending_machine_vend",
        this.vending_machine.xCenter() - Level.this.currMap.viewX,
        this.vending_machine.yCenter() - Level.this.currMap.viewY);
      this.fields.get(2).setValue("$" + this.vending_machine.number);
      this.fields.get(3).setValue("Thank you for your purchase.");
    }
  }



  class QuizmoForm extends LevelForm {
    protected Feature chuck_quizmo;
    protected Hero hero;
    protected float last_update_time = 0;
    protected float time_before_cancel = Constants.level_quizmoTimeDelay;
    protected boolean canceling = false;
    protected boolean correct_guess = false;

    QuizmoForm(Feature f, Hero h) {
      super(0.5 * (width - Constants.level_quizmoFormWidth), 0.5 * (height - Constants.level_quizmoFormHeight),
        0.5 * (width + Constants.level_quizmoFormWidth), 0.5 * (height + Constants.level_quizmoFormHeight));
      this.chuck_quizmo = f;
      this.hero = h;
      this.setTitleText(this.chuck_quizmo.display_name());

      RadiosFormField question = new RadiosFormField("");
      switch(this.chuck_quizmo.number) {
        case 0:
          question.setMessage("Test Question.");
          question.addRadio("Answer 1");
          question.addRadio("Answer 2");
          question.addRadio("Answer 3");
          question.addRadio("Answer 4");
          break;
        default:
          global.errorMessage("ERROR: Chuck Quizmo ID " + this.chuck_quizmo.number +
            " not found.");
          break;
      }

      this.addField(new SpacerFormField(20));
      this.addField(question);
      this.addField(new SpacerFormField(20));
      this.addField(new SubmitCancelFormField("Guess!", "Leave"));
    }

    @Override
    void update(int millis) {
      super.update(millis);
      imageMode(CORNER);
      image(global.images.getImage("features/chuck_quizmo.png"), this.xi + 210, this.yi + 100, 80, 80);
      int frame = constrain(int(floor(Constants.gif_quizmoQuestion_frames * (millis() %
        Constants.gif_quizmoQuestion_time) / Constants.gif_quizmoQuestion_time)),
        0, Constants.gif_quizmoQuestion_frames);
      if (this.canceling) {
        this.time_before_cancel -= millis - this.last_update_time;
        if (this.time_before_cancel < 0) {
          this.canceled = true;
        }
        if (this.correct_guess) {
          image(global.images.getImage("features/vanna_t_smiling.png"), this.xi + 300, this.yi + 120, 60, 60);
          image(global.images.getImage("gifs/quizmo_correct/" + frame + ".png"),
            this.xi + 230, this.yi + 50, 40, 40);
        }
        else {
          image(global.images.getImage("features/vanna_t.png"), this.xi + 300, this.yi + 120, 60, 60);
          image(global.images.getImage("gifs/quizmo_wrong/" + frame + ".png"),
            this.xi + 230, this.yi + 50, 40, 40);
        }
      }
      else {
        image(global.images.getImage("features/vanna_t.png"), this.xi + 300, this.yi + 120, 60, 60);
        image(global.images.getImage("gifs/quizmo_question/" + frame + ".png"),
          this.xi + 230, this.yi + 50, 40, 40);
      }
      this.last_update_time = millis;
    }

    @Override
    void cancel() {
      this.canceling = true;
      Level.this.chat("Chuck Quizmo: Well, well... so long, farewell. 'Til we meet again!");
      Level.this.currMap.addVisualEffect(4009, this.chuck_quizmo.x + 0.7, this.chuck_quizmo.y - 0.4);
    }

    void submit() {
      int guess = toInt(this.fields.get(1).getValue());
      if (guess < 0) {
        Level.this.chat("Chuck Quizmo: You haven't made a guess!");
        Level.this.currMap.addVisualEffect(4009, this.chuck_quizmo.x + 0.7, this.chuck_quizmo.y - 0.4);
        return;
      }
      int correct_answer = -1;
      switch(this.chuck_quizmo.number) {
        case 0:
          correct_answer = 1;
          break;
        default:
          global.errorMessage("ERROR: Chuck Quizmo ID " + this.chuck_quizmo.number +
            " not found.");
          break;
      }
      if (guess == correct_answer) {
        if (hero.canPickup()) {
          hero.pickup(new Item(2825));
        }
        else {
          Level.this.currMap.addItem(new Item(2825, this.hero.frontX(), this.hero.frontY()));
        }
        Level.this.chat("Chuck Quizmo: Congratulations! Here's your Star Piece!");
        Level.this.currMap.addVisualEffect(4009, this.chuck_quizmo.x + 0.7, this.chuck_quizmo.y - 0.4);
        this.correct_guess = true;
      }
      else {
        Level.this.chat("Chuck Quizmo: Too bad!");
        Level.this.currMap.addVisualEffect(4009, this.chuck_quizmo.x + 0.7, this.chuck_quizmo.y - 0.4);
        this.correct_guess = false;
      }
      this.chuck_quizmo.destroy(Level.this.currMap);
      this.canceling = true;
    }
  }



  class KhalilForm extends LevelForm {
    protected Inventory original_stock;
    protected Feature khalil;
    protected Hero hero;
    protected ArrayList<Float> costs;

    KhalilForm(Feature f, Hero h) {
      super(0.5 * (width - Constants.level_khalilFormWidth), 0.5 * (height - Constants.level_khalilFormHeight),
        0.5 * (width + Constants.level_khalilFormWidth), 0.5 * (height + Constants.level_khalilFormHeight));
      this.color_background = color(102, 153, 204);
      this.color_header = color(72, 120, 170);
      this.original_stock = getKhalilInventory(f.number);
      this.costs = getKhalilInventoryCosts(f.number);
      this.khalil = f;
      this.hero = h;
      this.setTitleText(this.khalil.display_name());
      if (this.khalil.inventory == null) {
        this.khalil.createKhalilInventory();
      }

      MessageFormField khalilMessageField = new MessageFormField("Please take a look at my inventory of goods.");
      khalilMessageField.setTextSize(20, true);
      RadiosFormField radiosField = new RadiosFormField("Inventory");
      for (int i = 0; i < this.original_stock.slots.size(); i++) {
        String item_name = this.original_stock.slots.get(i).item.display_name();
        Item stock_item = this.khalil.inventory.slots.get(i).item;
        int stock_amount = 0;
        if (stock_item != null && !stock_item.remove) {
          stock_amount = stock_item.stack;
        }
        if (stock_amount > 0) {
          radiosField.addRadio(item_name + " (" + stock_amount + " left): $" + this.costs.get(i));
        }
        else {
          radiosField.addDisabledRadio(item_name + " (out of stock): $" + this.costs.get(i));
        }
      }
      SubmitCancelFormField buttons = new SubmitCancelFormField("Purchase", "Leave");
      buttons.button1.setColors(color(170), color(127, 178, 229), color(102,
        153, 204), color(80, 128, 179), color(0));
      buttons.button2.setColors(color(170), color(127, 178, 229), color(102,
        153, 204), color(80, 128, 179), color(0));

      this.addField(new SpacerFormField(110));
      this.addField(khalilMessageField);
      this.addField(new SpacerFormField(5));
      this.addField(radiosField);
      this.addField(new SpacerFormField(20));
      this.addField(buttons);
    }


    @Override
    void update(int millis) {
      super.update(millis);
      imageMode(CENTER);
      image(this.khalil.getImage(), this.xCenter(), this.yStart + 65, 240, 120);
    }


    @Override
    void cancel() {
      this.canceled = true;
      Level.this.chat("Traveling Buddy: Sooo loooong traveling buddyyyy");
      Level.this.currMap.addVisualEffect(4009, this.khalil.x + 0.6, this.khalil.y - 0.4);
    }

    void submit() {
      int selection = toInt(this.fields.get(3).getValue());
      if (selection < 0) {
        this.fields.get(1).setValue("Please make a selection.");
        return;
      }
      float cost = this.costs.get(selection);
      if (this.hero.money < cost) {
        this.fields.get(1).setValue("It seems you don't have enough money to afford that.");
        return;
      }
      Item i = this.khalil.inventory.slots.get(selection).item;
      if (i == null || i.remove) {
        this.fields.get(1).setValue("That item is out of stock.");
        return;
      }
      this.fields.get(1).setValue("Thank you for your purchase.");
      Item bought_item = new Item(i);
      i.removeStack();
      bought_item.stack = 1;
      this.hero.money -= cost;
      if (this.hero.canPickup()) {
        this.hero.pickup(bought_item);
      }
      else {
        Item leftover = this.hero.inventory.stash(bought_item);
        if (leftover != null && !leftover.remove) {
          Level.this.currMap.addItem(leftover, this.khalil.x + 1, this.khalil.y + 1);
        }
      }
      RadioButton button = ((RadiosFormField)this.fields.get(3)).radios.get(selection);
      if (i.remove) {
        button.message = i.display_name() + " (out of stock): $" + this.costs.get(selection);
        button.disabled = true;
        button.color_text = color(80);
      }
      else {
        button.message = i.display_name() + " (" + i.stack + " left): $" + this.costs.get(selection);
      }
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
