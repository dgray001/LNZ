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



enum DayCycle {
  DAWN, DAY, DUSK, NIGHT;

  public static DayCycle dayTime(float time) {
    if (time > 21) {
      return DayCycle.NIGHT;
    }
    else if (time > 20.5) {
      return DayCycle.DUSK;
    }
    else if (time > 6.5) {
      return DayCycle.DAY;
    }
    else if (time > 6) {
      return DayCycle.DAWN;
    }
    else {
      return DayCycle.NIGHT;
    }
  }

  public static float lightFraction(float time) {
    if (time > 21) {
      return Constants.level_nightLightLevel;
    }
    else if (time > 20.5) {
      return Constants.level_nightLightLevel + 2.0 * (21 - time) *
        (Constants.level_dayLightLevel - Constants.level_nightLightLevel);
    }
    else if (time > 6.5) {
      return Constants.level_dayLightLevel;
    }
    else if (time > 6) {
      return Constants.level_nightLightLevel + 2.0 * (time - 6) *
        (Constants.level_dayLightLevel - Constants.level_nightLightLevel);
    }
    else {
      return Constants.level_nightLightLevel;
    }
  }
}



class Level {
  protected String folderPath; // to level folder
  protected String levelName = "error";
  protected Location location = Location.ERROR;
  protected boolean nullify = false;
  protected boolean completed = false;
  protected boolean completing = false;
  protected int completing_timer = 5000;
  protected int completion_code = 0;

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
  protected HashMap<Integer, Quest> quests = new HashMap<Integer, Quest>();
  protected ClockFloat time = new ClockFloat(24, 6.5); // day cycle

  protected Rectangle player_start_location = null;
  protected Rectangle player_spawn_location = null;
  protected Hero player;
  protected boolean was_viewing_hero_tree = false;
  protected boolean respawning = false;
  protected int respawn_timer = 0;
  protected boolean sleeping = false;
  protected int sleep_timer = 0;
  protected boolean in_control = true;

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


  String timeString() {
    return this.timeString(false, false);
  }
  String timeString(boolean military_time, boolean show_seconds) {
    float minutes = 60.0 * (this.time.value - floor(this.time.value));
    float seconds = 60.0 * (minutes - floor(minutes));
    String hrs = Integer.toString(int(floor(this.time.value)));
    String mins = Integer.toString(int(floor(minutes)));
    while(mins.length() < 2) {
      mins = "0" + mins;
    }
    String secs = Integer.toString(int(floor(seconds)));
    while(secs.length() < 2) {
      secs = "0" + secs;
    }
    if (military_time) {
      if (show_seconds) {
        return hrs + ":" + mins + ":" + secs;
      }
      else {
        return hrs + ":" + mins;
      }
    }
    else {
      String suffix = " am";
      if (this.time.value > 12) {
        suffix = " pm";
        hrs = Integer.toString(int(floor(this.time.value - 12)));
      }
      if (show_seconds) {
        return hrs + ":" + mins + ":" + secs + suffix;
      }
      else {
        return hrs + ":" + mins + suffix;
      }
    }
  }


  void decisionForm(int i) {
    if (this.level_form != null) {
      global.log("WARNING: Decision form being created while level form " +
        this.level_form.getClass().toString() + " exists.");
    }
    this.level_form = new DecisionForm(i);
  }


  void gainControl() {
    this.in_control = true;
    global.player_blinks_left = 6;
    global.player_blinking = true;
    global.player_blink_time = Constants.level_questBlinkTime;
    if (this.currMap != null) {
      this.currMap.in_control = true;
    }
    if (this.player != null) {
      this.player.in_control = true;
    }
  }

  void loseControl() {
    this.in_control = false;
    global.player_blinks_left = 6;
    global.player_blinking = false;
    global.player_blink_time = Constants.level_questBlinkTime;
    if (this.currMap != null) {
      this.currMap.in_control = false;
    }
    if (this.player != null) {
      this.player.in_control = false;
    }
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

  String getPlayerSpawnLocationDisplay() {
    if (this.player_spawn_location == null) {
      return "No player spawn location";
    }
    else {
      return "Player respawns at " + this.player_spawn_location.mapName + " at (" +
        this.player_spawn_location.centerX() + ", " + this.player_spawn_location.centerY() + ")";
    }
  }


  void addTestPlayer() {
    Hero h = new Hero(HeroCode.BEN);
    this.addPlayer(h);
  }

  void addPlayer(Hero h) {
    if (this.player != null) {
      global.errorMessage("ERROR: Trying to add player when player already exists.");
      return;
    }
    this.player = h;
    this.player.location = this.location;
    this.player.in_control = this.in_control;
    if (this.currMap != null) {
      this.currMap.addPlayer(this.player);
    }
  }

  void setPlayer(Hero player) {
    if (this.player != null) {
      global.errorMessage("ERROR: Trying to add player when player already exists.");
      return;
    }
    if (this.player_start_location == null || !this.hasMap(this.player_start_location.mapName)) {
      if (this.mapNames.size() > 0) {
        this.openMap(this.mapNames.get(0));
        player.setLocation(0, 0);
      }
      else {
        player.setLocation(0, 0);
      }
    }
    else {
      this.openMap(this.player_start_location.mapName);
      player.setLocation(this.player_start_location.centerX(), this.player_start_location.centerY());
    }
    if (this.currMap == null || this.currMap.nullify) {
      this.nullify = true;
      global.errorMessage("ERROR: Can't open default map.");
    }
    else {
      this.currMap.addPlayer(player);
    }
    this.player = player;
    this.player.location = this.location;
    this.player.in_control = this.in_control;
  }

  void respawnPlayer() {
    if (this.player == null) {
      global.errorMessage("ERROR: Trying to respawn player when player doesn't exists.");
      return;
    }
    this.player.remove = false;
    this.player.curr_health = this.player.health();
    this.player.curr_mana = 0;
    this.player.hunger = Constants.hero_maxHunger;
    this.player.thirst = Constants.hero_maxThirst;
    this.player.experience *= int(floor(Constants.hero_experienceRespawnMultiplier));
    if (this.player_spawn_location != null && this.hasMap(this.player_spawn_location.mapName)) {
      this.openMap(this.player_spawn_location.mapName);
      player.setLocation(this.player_spawn_location.centerX(), this.player_spawn_location.centerY());
    }
    else if (this.player_start_location != null && this.hasMap(this.player_start_location.mapName)) {
      this.openMap(this.player_start_location.mapName);
      player.setLocation(this.player_start_location.centerX(), this.player_start_location.centerY());
    }
    else {
      if (this.mapNames.size() > 0) {
        this.openMap(this.mapNames.get(0));
        player.setLocation(0, 0);
      }
      else {
        player.setLocation(0, 0);
      }
    }
    if (this.currMap == null || this.currMap.nullify) {
      this.nullify = true;
      global.errorMessage("ERROR: Can't open map with name " + this.currMapName + ".");
    }
    else {
      this.currMap.addPlayer(player);
      this.currMap.setViewLocation(player.x, player.y);
    }
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
    this.currMap.addHeaderMessage(GameMapCode.display_name(this.currMap.code));
  }

  void openCurrMap() {
    this.openMap(this.currMapName);
    if (this.currMap == null || this.currMap.nullify) {
      this.nullify = true;
      global.errorMessage("ERROR: Can't open curr map.");
    }
  }

  void openMap(String mapName) {
    if (mapName == null) {
      return;
    }
    if (!fileExists(this.finalFolderPath() + "/" + mapName + ".map.lnz")) {
      global.errorMessage("ERROR: Level " + this.levelName + " has no map " +
        "with name " + mapName + " at location " + this.finalFolderPath() + ".");
      this.nullify = true;
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
    this.currMap.in_control = this.in_control;
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
    trigger.triggerID = triggerCode;
    this.triggers.put(triggerCode, trigger);
  }
  void removeTrigger(int triggerKey) {
    if (!this.triggers.containsKey(triggerKey)) {
      global.errorMessage("ERROR: No trigger with key " + triggerKey + ".");
      return;
    }
    this.triggers.remove(triggerKey);
  }

  void addQuest(int quest_id) {
    this.addQuest(new Quest(quest_id));
  }
  void addQuest(Quest quest) {
    if (this.quests.containsKey(quest.ID)) {
      return;
    }
    this.quests.put(quest.ID, quest);
    global.sounds.trigger_player("player/quest");
  }
  void removeQuest(int quest_id) {
    if (this.quests.containsKey(quest_id)) {
      this.quests.remove(quest_id);
    }
  }


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
      case 21: // workbench
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        break;
      case 22: // ender chest
        global.viewingEnderChest();
        if (global.state == ProgramState.MAPEDITOR_INTERFACE) {
          f.inventory = new EnderChestInventory();
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        global.sounds.trigger_units("features/chest", f.xCenter() -
          this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        break;
      case 101: // wooden table
      case 106: // small wooden table
      case 107:
      case 108: // ping pong table
      case 111: // wooden chair
      case 112:
      case 113:
      case 114:
      case 125: // wooden bench
      case 126:
      case 127:
      case 128:
      case 129:
      case 130:
        if (!h.holding(2977, 2979, 2980, 2981, 2983)) {
          break;
        }
        switch(h.weapon().ID) {
          case 2977: // ax
            f.number -= 3;
            global.sounds.trigger_units("items/melee/ax", f.xCenter() -
              this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 2979: // saw
            f.number -= 1;
            global.sounds.trigger_units("items/saw_cut_wood", f.xCenter() -
              this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 2980: // drill
            f.number -= 1;
            global.sounds.trigger_units("items/melee/drill" + randomInt(1, 3),
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 2981: // roundsaw
            f.number -= 2;
            global.sounds.trigger_units("items/roundsaw_cut_wood", f.xCenter() -
              this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 2983: // chainsaw
            f.number -= 2;
            global.sounds.trigger_units("items/chainsaw_long", f.xCenter() -
              this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
        }
        h.weapon().lowerDurability();
        if (f.number < 1) {
          f.destroy(this.currMap);
        }
        break;
      case 102: // wooden desk
      case 103:
      case 104:
      case 105:
        if (use_item && h.holding(2977, 2979, 2980, 2981, 2983)) {
          switch(h.weapon().ID) {
            case 2977: // ax
              f.number -= 3;
              global.sounds.trigger_units("items/melee/ax", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2979: // saw
              f.number -= 1;
              global.sounds.trigger_units("items/saw_cut_wood", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2980: // drill
              f.number -= 1;
              global.sounds.trigger_units("items/melee/drill" + randomInt(1, 3),
                f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2981: // roundsaw
              f.number -= 2;
              global.sounds.trigger_units("items/roundsaw_cut_wood", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2983: // chainsaw
              f.number -= 2;
              global.sounds.trigger_units("items/chainsaw_long", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
          }
          h.weapon().lowerDurability();
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
        break;
      case 115: // coordinator chair
      case 121: // couch
      case 122:
      case 123:
      case 124:
        if (use_item && h.holding(2977, 2979, 2980, 2981, 2983)) {
          switch(h.weapon().ID) {
            case 2977: // ax
              f.number -= 3;
              global.sounds.trigger_units("items/melee/ax", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2979: // saw
              f.number -= 1;
              global.sounds.trigger_units("items/saw_cut_wood", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2980: // drill
              f.number -= 1;
              global.sounds.trigger_units("items/melee/drill" + randomInt(1, 3),
                f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2981: // roundsaw
              f.number -= 2;
              global.sounds.trigger_units("items/roundsaw_cut_wood", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2983: // chainsaw
              f.number -= 2;
              global.sounds.trigger_units("items/chainsaw_long", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
          }
          h.weapon().lowerDurability();
          if (f.number < 1) {
            f.destroy(this.currMap);
          }
          break;
        }
        global.sounds.trigger_environment("features/couch_shuffle", f.xCenter() -
          this.currMap.viewX, f.yCenter() - this.currMap.viewY);
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
          new_i.pickupSound();
        }
        else {
          this.currMap.addItem(new_i);
        }
        this.currMap.addHeaderMessage("You found a " + new_i.display_name() + ".");
        break;
      case 131: // bed
      case 132:
      case 133:
      case 134:
        if (use_item && h.holding(2977, 2979, 2980, 2981, 2983)) {
          switch(h.weapon().ID) {
            case 2977: // ax
              f.number -= 3;
              global.sounds.trigger_units("items/melee/ax", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2979: // saw
              f.number -= 1;
              global.sounds.trigger_units("items/saw_cut_wood", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2980: // drill
              f.number -= 1;
              global.sounds.trigger_units("items/melee/drill" + randomInt(1, 3),
                f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2981: // roundsaw
              f.number -= 2;
              global.sounds.trigger_units("items/roundsaw_cut_wood", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2983: // chainsaw
              f.number -= 2;
              global.sounds.trigger_units("items/chainsaw_long", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
          }
          h.weapon().lowerDurability();
          if (f.number < 1) {
            f.destroy(this.currMap);
          }
          break;
        }
        if (DayCycle.dayTime(this.time.value) == DayCycle.NIGHT) {
          this.sleeping = true;
          this.sleep_timer = Constants.feature_bedSleepTimer;
          this.loseControl();
          h.stopAction();
        }
        else {
          this.currMap.addHeaderMessage("You can only sleep at night.");
        }
        break;
      case 141: // wardrobe
      case 142:
        if (use_item && h.holding(2977, 2979, 2980, 2981, 2983)) {
          switch(h.weapon().ID) {
            case 2977: // ax
              f.number -= 3;
              global.sounds.trigger_units("items/melee/ax", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2979: // saw
              f.number -= 1;
              global.sounds.trigger_units("items/saw_cut_wood", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2980: // drill
              f.number -= 1;
              global.sounds.trigger_units("items/melee/drill" + randomInt(1, 3),
                f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2981: // roundsaw
              f.number -= 2;
              global.sounds.trigger_units("items/roundsaw_cut_wood", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2983: // chainsaw
              f.number -= 2;
              global.sounds.trigger_units("items/chainsaw_long", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
          }
          h.weapon().lowerDurability();
          if (f.number < 1) {
            f.destroy(this.currMap);
          }
          break;
        }
        global.sounds.trigger_environment("features/wardrobe_shuffle", f.xCenter() -
          this.currMap.viewX, f.yCenter() - this.currMap.viewY);
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
          new_i.pickupSound();
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
        break;
      case 175: // refridgerator
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        break;
      case 176: // washer
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        break;
      case 177: // dryer
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        break;
      case 178: // microwave
        if (h.inventory.viewing) {
          break;
        }
        h.inventory.featureInventory(f.inventory);
        h.inventory.viewing = true;
        break;
      case 180: // lamp
        f.toggle = !f.toggle;
        f.refresh_map_image = true;
        if (f.toggle) {
          global.sounds.trigger_environment("features/switch_on",
            f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
          this.currMap.timer_refresh_fog = 0;
        }
        else {
          global.sounds.trigger_environment("features/switch_off",
            f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
          this.currMap.timer_refresh_fog = 0;
        }
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
          global.sounds.trigger_environment("items/glass_bottle_hit",
            f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
          break;
        }
        if (h.canPickup()) {
          f.number = Constants.feature_pickleJarCooldown;
          new_i = new Item(2106);
          h.pickup(new_i);
          new_i.pickupSound();
        }
        break;
      case 195: // light switch
      case 196:
      case 197:
      case 198:
        f.toggle = !f.toggle;
        f.refresh_map_image = true;
        if (f.toggle) {
          global.sounds.trigger_environment("features/switch_on",
            f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
          this.currMap.timer_refresh_fog = 0;
        }
        else {
          global.sounds.trigger_environment("features/switch_off",
            f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
          this.currMap.timer_refresh_fog = 0;
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
        if (use_item && h.holding(2978)) {
          f.destroy(this.currMap);
          h.weapon().lowerDurability();
          global.sounds.trigger_environment("items/wire_clipper",
            f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
          break;
        }
        else if (h.agility() >= 2) {
          h.setLocation(f.xCenter(), f.yCenter());
          global.sounds.trigger_units("features/climb_fence",
            f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
          if (randomChance(0.3)) {
            h.addStatusEffect(StatusEffectCode.BLEEDING, 2000);
          }
        }
        break;
      case 231: // barbed wire fence
      case 232:
      case 233:
      case 234:
      case 235:
      case 236:
      case 237:
      case 238:
      case 239:
      case 240:
      case 241:
      case 242:
      case 243:
      case 244:
      case 245:
      case 246:
        if (h.agility() >= 3) {
          h.setLocation(f.xCenter(), f.yCenter());
          global.sounds.trigger_units("features/climb_fence",
            f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
          if (randomChance(0.8)) {
            h.addStatusEffect(StatusEffectCode.BLEEDING, 2500);
          }
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
        global.sounds.trigger_units("features/movable_wall",
          f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        this.currMap.addHeaderMessage("The wall easily slid over");
        break;
      case 321: // window (open)
        if (use_item && h.holding(2976)) {
          f.destroy(this.currMap);
          h.weapon().lowerDurability();
          global.sounds.trigger_environment("items/window_break",
            f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
          break;
        }
        f.remove = true;
        new_f = new Feature(322, f.x, f.y, false);
        this.currMap.addFeature(new_f);
        new_f.hovered = true;
        this.currMap.hovered_object = new_f;
        global.sounds.trigger_environment("features/window_close",
          f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        break;
      case 322: // window (closed)
        if (use_item && h.holding(2976)) {
          f.destroy(this.currMap);
          h.weapon().lowerDurability();
          global.sounds.trigger_environment("items/window_break",
            f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
          break;
        }
        f.remove = true;
        new_f = new Feature(321, f.x, f.y, false);
        this.currMap.addFeature(new_f);
        new_f.hovered = true;
        this.currMap.hovered_object = new_f;
        global.sounds.trigger_environment("features/window_open",
          f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        break;
      case 323: // window (locked)
        if (!h.holding(2976)) {
          this.currMap.addHeaderMessage("The window is locked");
          break;
        }
        f.destroy(this.currMap);
        h.weapon().lowerDurability();
        global.sounds.trigger_environment("items/window_break",
          f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
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
          h.weapon().lowerDurability();
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
              if (h.weapon() != null && h.weapon().type.equals("Key")) {
                this.currMap.addHeaderMessage("The key doesn't unlock this door");
              }
              else if (h.holding(2904, 2905)) {
                this.currMap.addHeaderMessage("No key on this ring unlocks the door");
              }
              else {
                this.currMap.addHeaderMessage("The door is locked");
              }
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
              if (h.weapon() != null && h.weapon().type.equals("Key")) {
                this.currMap.addHeaderMessage("The key doesn't unlock this door");
              }
              else if (h.holding(2904, 2905)) {
                this.currMap.addHeaderMessage("No key on this ring unlocks the door");
              }
              else {
                this.currMap.addHeaderMessage("The door is locked");
              }
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
              if (h.weapon() != null && h.weapon().type.equals("Key")) {
                this.currMap.addHeaderMessage("The key doesn't unlock this door");
              }
              else if (h.holding(2904, 2905)) {
                this.currMap.addHeaderMessage("No key on this ring unlocks the door");
              }
              else {
                this.currMap.addHeaderMessage("The door is locked");
              }
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
              if (h.weapon() != null && h.weapon().type.equals("Key")) {
                this.currMap.addHeaderMessage("The key doesn't unlock this door");
              }
              else if (h.holding(2904, 2905)) {
                this.currMap.addHeaderMessage("No key on this ring unlocks the door");
              }
              else {
                this.currMap.addHeaderMessage("The door is locked");
              }
              break;
            }
            f.remove = true;
            new_f = new Feature(342, f.x, f.y, f.toggle);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/stee_door_unlock",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
        }
        break;
      case 351: // steel door (open)
      case 352:
      case 353:
      case 354:
      case 355:
      case 356:
      case 357:
      case 358:
      case 359: // steel door (closed)
      case 360:
      case 361:
      case 362:
      case 363: // steel door (locked)
      case 364:
      case 365:
      case 366:
        switch(f.ID) {
          case 351: // door open (up)
            f.remove = true;
            new_f = new Feature(359, f.x, f.y, false);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/steel_door_close",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 352:
            f.remove = true;
            new_f = new Feature(359, f.x, f.y, true);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/steel_door_close",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 353: // door open (left)
            f.remove = true;
            new_f = new Feature(360, f.x, f.y, false);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/steel_door_close",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 354:
            f.remove = true;
            new_f = new Feature(360, f.x, f.y, true);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/steel_door_close",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 355: // door open (diagonal left)
            f.remove = true;
            new_f = new Feature(361, f.x, f.y, false);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/steel_door_close",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 356:
            f.remove = true;
            new_f = new Feature(361, f.x, f.y, true);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/steel_door_close",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 357: // door open (diagonal right)
            f.remove = true;
            new_f = new Feature(362, f.x, f.y, false);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/steel_door_close",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 358:
            f.remove = true;
            new_f = new Feature(362, f.x, f.y, true);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/steel_door_close",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 359: // door closed (up)
            f.remove = true;
            if (f.toggle) {
              new_f = new Feature(352, f.x, f.y);
            }
            else {
              new_f = new Feature(351, f.x, f.y);
            }
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/steel_door_open",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 360: // door closed (left)
            f.remove = true;
            if (f.toggle) {
              new_f = new Feature(354, f.x, f.y);
            }
            else {
              new_f = new Feature(353, f.x, f.y);
            }
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/steel_door_open",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 361: // door closed (diagonal left)
            f.remove = true;
            if (f.toggle) {
              new_f = new Feature(356, f.x, f.y);
            }
            else {
              new_f = new Feature(355, f.x, f.y);
            }
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/steel_door_open",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 362: // door closed (diagonal right)
            f.remove = true;
            if (f.toggle) {
              new_f = new Feature(358, f.x, f.y);
            }
            else {
              new_f = new Feature(357, f.x, f.y);
            }
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/steel_door_open",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 363: // door locked (up)
            if (h.weapon() == null || !h.weapon().unlocks(f.number)) {
              if (h.weapon() != null && h.weapon().type.equals("Key")) {
                this.currMap.addHeaderMessage("The key doesn't unlock this door");
              }
              else {
                this.currMap.addHeaderMessage("The door is locked");
              }
              break;
            }
            f.remove = true;
            new_f = new Feature(359, f.x, f.y, f.toggle);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/steel_door_unlock",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 364: // door locked (left)
            if (h.weapon() == null || !h.weapon().unlocks(f.number)) {
              if (h.weapon() != null && h.weapon().type.equals("Key")) {
                this.currMap.addHeaderMessage("The key doesn't unlock this door");
              }
              else {
                this.currMap.addHeaderMessage("The door is locked");
              }
              break;
            }
            f.remove = true;
            new_f = new Feature(360, f.x, f.y, f.toggle);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/steel_door_unlock",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 365: // door locked (diagonal left)
            if (h.weapon() == null || !h.weapon().unlocks(f.number)) {
              if (h.weapon() != null && h.weapon().type.equals("Key")) {
                this.currMap.addHeaderMessage("The key doesn't unlock this door");
              }
              else {
                this.currMap.addHeaderMessage("The door is locked");
              }
              break;
            }
            f.remove = true;
            new_f = new Feature(361, f.x, f.y, f.toggle);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/steel_door_unlock",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
          case 366: // door locked (diagonal right)
            if (h.weapon() == null || !h.weapon().unlocks(f.number)) {
              if (h.weapon() != null && h.weapon().type.equals("Key")) {
                this.currMap.addHeaderMessage("The key doesn't unlock this door");
              }
              else {
                this.currMap.addHeaderMessage("The door is locked");
              }
              break;
            }
            f.remove = true;
            new_f = new Feature(362, f.x, f.y, f.toggle);
            this.currMap.addFeature(new_f);
            new_f.hovered = true;
            this.currMap.hovered_object = new_f;
            global.sounds.trigger_environment("features/steel_door_unlock",
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            break;
        }
        break;
      case 401: // dandelion
        if (h.canPickup()) {
          f.remove = true;
          new_i = new Item(2961);
          h.pickup(new_i);
          new_i.pickupSound();
        }
        break;
      case 411: // gravel (pebbles)
        if (h.canPickup()) {
          new_i = new Item(2933);
          h.pickup(new_i);
          new_i.pickupSound();
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
      case 412: // Gravel (rocks)
        if (h.canPickup()) {
          new_i = new Item(2931);
          h.pickup(new_i);
          new_i.pickupSound();
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
      case 421: // Tree (maple)
      case 422: // Tree (unknown)
      case 423: // Tree (cedar)
      case 424: // Tree (dead)
      case 425: // Tree (large)
      case 426: // Tree (pine)
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
        if (!use_item || !h.holding(2977, 2979, 2981, 2983)) {
          if (f.toggle) {
            this.currMap.addItem(new Item(branch_id, h.frontX(), h.frontY()));
            global.sounds.trigger_units("features/break_branch" + randomInt(1, 6),
              f.xCenter() - this.currMap.viewX, f.yCenter() - this.currMap.viewY);
            if (randomChance(Constants.feature_treeChanceEndBranches)) {
              f.toggle = false;
            }
          }
        }
        else {
          switch(h.weapon().ID) {
            case 2977: // ax
              f.number -= 2;
              global.sounds.trigger_units("items/melee/ax", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2979: // saw
              f.number -= 1;
              global.sounds.trigger_units("items/saw_cut_wood", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2981: // roundsaw
              f.number -= 1;
              global.sounds.trigger_units("items/roundsaw_cut_wood", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
            case 2983: // chainsaw
              f.number -= 4;
              global.sounds.trigger_units("items/chainsaw_long", f.xCenter() -
                this.currMap.viewX, f.yCenter() - this.currMap.viewY);
              break;
          }
          h.weapon().lowerDurability();
          if (randomChance(Constants.feature_treeDropChance)) {
            this.currMap.addItem(new Item(branch_id, h.frontX(), h.frontY()));
          }
          if (f.number < 1) {
            f.destroy(this.currMap);
          }
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
          h.weapon().lowerDurability();
          if (f.number < 1) {
            f.remove = true;
          }
          global.sounds.trigger_units("features/sword_bush", f.xCenter() -
            this.currMap.viewX, f.yCenter() - this.currMap.viewY);
        }
        break;
      default:
        global.errorMessage("ERROR: Hero " + h.display_name() + " trying to " +
          "interact with feature " + f.display_name() + " but no interaction logic found.");
        break;
    }
  }


  void complete() {
    this.complete(0);
  }
  void complete(int completion_code) {
    if (this.completing || this.completed) {
      return;
    }
    this.completion_code = completion_code;
    this.completing = true;
    this.save();
    global.sounds.play_background("victory");
  }


  void restartTimers() {
    this.restart_timers = true;
  }
  void restartTimers(int millis) {
    this.last_update_time = millis;
    if (this.currMap != null) {
      this.currMap.lastUpdateTime = millis;
    }
  }


  void update(int millis) {
    if (this.restart_timers) {
      this.restart_timers = false;
      this.restartTimers(millis);
    }
    int timeElapsed = millis - this.last_update_time;
    if (this.completing || this.completed) {
      if (this.currMap != null) {
        this.currMap.drawMap();
      }
      else {
        rectMode(CORNERS);
        noStroke();
        fill(color(60));
        rect(this.xi, this.yi, this.xf, this.yf);
      }
      this.completing_timer -= timeElapsed;
      if (this.completing_timer < 0) {
        this.completed = true;
      }
      rectMode(CORNERS);
      fill(100, 100);
      noStroke();
      rect(this.xi, this.yi, this.xf, this.yf);
      fill(255);
      textSize(90);
      textAlign(CENTER, CENTER);
      text("You are Victorious!", 0.5 * width, 0.5 * height);
      this.last_update_time = millis;
      return;
    }
    if (this.player != null) {
      if (this.player.heroTree.curr_viewing) {
        this.was_viewing_hero_tree = true;
        if (this.player.heroTree.set_screen_location) {
          this.player.heroTree.set_screen_location = false;
          global.defaultCursor();
          this.player.heroTree.setLocation(this.xi, this.yi, this.xf, this.yf);
        }
        this.player.heroTree.update(timeElapsed);
        this.last_update_time = millis;
        return;
      }
      else if (this.was_viewing_hero_tree) {
        this.was_viewing_hero_tree = false;
        this.restartTimers();
        global.defaultCursor();
      }
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
    this.time.add(timeElapsed * Constants.level_timeConstants);
    if (this.currMap != null) {
      this.currMap.base_light_level = DayCycle.lightFraction(this.time.value);
      if (this.respawning) {
        this.currMap.terrain_display.filter(GRAY);
      }
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
        for (Item i : this.player.inventory.more_items_dropping) {
          this.currMap.addItem(new Item(i, this.player.frontX(), this.player.frontY()));
        }
        this.player.inventory.more_items_dropping.clear();
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
      if (this.respawning) {
        this.respawn_timer -= timeElapsed;
        if (this.respawn_timer < 0) {
          this.respawnPlayer();
          this.respawning = false;
        }
      }
      else if (this.sleeping) {
        this.sleep_timer -= timeElapsed;
        if (this.sleep_timer < 0) {
          this.gainControl();
          this.sleeping = false;
          this.player_spawn_location = new Rectangle(this.currMapName, this.player);
          this.time.set(6);
          if (this.currMap != null) {
            this.currMap.addHeaderMessage("Spawn Point Reset");
          }
        }
      }
      else {
        this.player.update_hero(timeElapsed);
        for (Map.Entry<Integer, Quest> entry : this.quests.entrySet()) {
          entry.getValue().update(this, timeElapsed);
        }
        if (this.player.seesTime()) {
          fill(255);
          textSize(14);
          textAlign(LEFT, TOP);
          float line_height = textAscent() + textDescent() + 2;
          String time_line = this.timeString();
          text(time_line, this.xf - 40 - textWidth(time_line), 1);
        }
        if (this.player.remove && !this.respawning) {
          this.respawning = true;
          this.respawn_timer = Constants.level_defaultRespawnTimer;
        }
      }
    }
    if (this.respawning) {
      fill(255);
      textSize(90);
      textAlign(CENTER, BOTTOM);
      text("You Died", 0.5 * width, 0.5 * height);
      textSize(45);
      textAlign(CENTER, TOP);
      text("Respawning in " + int(ceil(this.respawn_timer * 0.001)) + " s", 0.5 * width, 0.5 * height + 5);
    }
    if (this.sleeping) {
      rectMode(CORNERS);
      noStroke();
      float alpha_amount = int(255 * (1 - this.sleep_timer / float(Constants.feature_bedSleepTimer)));
      fill(color(0, alpha_amount));
      rect(this.xi, this.yi, this.xf, this.yf);
    }
    this.last_update_time = millis;
  }

  void displayNerdStats() {
    if (this.currMap != null) {
      this.currMap.displayNerdStats();
    }
    else {
      fill(255);
      textSize(14);
      textAlign(LEFT, TOP);
      float y_stats = 1;
      float line_height = textAscent() + textDescent() + 2;
      text("FPS: " + int(global.lastFPS), this.xi + 1, y_stats);
    }
  }

  void mouseMove(float mX, float mY) {
    if (this.completing || this.completed) {
      return;
    }
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
      if (this.player != null && this.player.inventory_bar.hovered) {
        this.currMap.hovered_object = null;
        global.defaultCursor("icons/cursor_interact.png", "icons/cursor_attack.png", "icons/cursor_pickup.png");
      }
    }
  }

  void mousePress() {
    if (this.level_questbox != null) {
      this.level_questbox.mousePress();
    }
    if (this.level_chatbox != null) {
      this.level_chatbox.mousePress();
    }
    if (this.completing || this.completed) {
      return;
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
    if (this.completing || this.completed) {
      return;
    }
    if (this.player != null) {
      if (this.player.heroTree.curr_viewing) {
        this.player.heroTree.mouseRelease(mX, mY);
        if (this.player.left_panel_menu != null) {
          this.player.left_panel_menu.mouseRelease(mX, mY);
        }
        if (!this.player.heroTree.curr_viewing) {
          this.was_viewing_hero_tree = false;
          this.restartTimers();
          global.defaultCursor();
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
    if (this.completing || this.completed) {
      return;
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
              global.defaultCursor();
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
        if (!this.player.heroTree.curr_viewing) {
          this.was_viewing_hero_tree = false;
          this.restartTimers();
          global.defaultCursor();
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
            global.defaultCursor();
            this.player.heroTree.setLocation(this.xi, this.yi, this.xf, this.yf);
          }
          break;
        case 'c':
        case 'C':
          if (global.holding_ctrl && this.player != null) {
            this.complete();
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
    file.println("completed: " + this.completed);
    file.println("completing: " + this.completing);
    file.println("completion_code: " + this.completion_code);
    file.println("time: " + this.time.value);
    file.println("respawning: " + this.respawning);
    file.println("respawn_timer: " + this.respawn_timer);
    file.println("sleeping: " + this.sleeping);
    file.println("sleep_timer: " + this.sleep_timer);
    file.println("in_control: " + this.in_control);
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
    if (this.player_spawn_location != null) {
      file.println("player_spawn_location: " + this.player_spawn_location.fileString());
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
    if (lines == null) {
      this.nullify = true;
      global.errorMessage("ERROR: Null file data for level; possibly missing " +
        "file at " + this.finalFolderPath() + ".");
      return;
    }
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
              curr_effect.setName();
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
    }

    this.nextTriggerKey = max_trigger_key + 1;
  }


  void addData(String datakey, String data) {
    switch(datakey) {
      case "levelName":
        this.levelName = data;
        break;
      case "location":
        this.location = Location.location(data);
        break;
      case "completed":
        this.completed = toBoolean(data);
        break;
      case "completing":
        this.completing = toBoolean(data);
        break;
      case "completion_code":
        this.completion_code = toInt(data);
        break;
      case "time":
        this.time.set(toFloat(data));
        break;
      case "respawning":
        this.respawning = toBoolean(data);
        break;
      case "respawn_timer":
        this.respawn_timer = toInt(data);
        break;
      case "sleeping":
        this.sleeping = toBoolean(data);
        break;
      case "sleep_timer":
        this.sleep_timer = toInt(data);
        break;
      case "in_control":
        if (toBoolean(data)) {
          this.gainControl();
        }
        else {
          this.loseControl();
        }
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
      case "player_spawn_location":
        this.player_spawn_location = new Rectangle();
        this.player_spawn_location.addData(data);
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
      this.scrollbar.setButtonColors(color(220), color(220, 160, 110), color(
        240, 180, 130), color(200, 140, 90), color(0));
      this.scrollbar.button_upspace.setColors(color(170), color(255, 200, 150),
        color(255, 200, 150), color(60, 30, 0), color(0));
      this.scrollbar.button_downspace.setColors(color(170), color(255, 200, 150),
        color(255, 200, 150), color(60, 30, 0), color(0));
      this.setTitleText("Quests");
    }

    @Override
    void update(int millis) {
      this.clearText();
      boolean first = true;
      ArrayList<Quest> quests = new ArrayList<Quest>();
      for (Map.Entry<Integer, Quest> entry : Level.this.quests.entrySet()) {
        quests.add(entry.getValue());
        if (first) {
          this.setText(entry.getValue().name());
          first = false;
        }
        else {
          this.addLine(entry.getValue().name());
        }
      }
      if (this.line_hovered >= this.text_lines_ref.size()) {
        this.line_hovered = -1;
      }
      if (this.line_clicked >= this.text_lines_ref.size()) {
        this.line_clicked = this.text_lines_ref.size() - 1;
      }
      int timeElapsed = millis - this.lastUpdateTime;
      rectMode(CORNERS);
      fill(this.color_background);
      stroke(this.color_stroke);
      strokeWeight(1);
      rect(this.xi, this.yi, this.xf, this.yf);
      float currY = this.yi + 1;
      if (this.text_title_ref != null) {
        fill(this.color_header);
        textSize(this.title_size);
        rect(this.xi, this.yi, this.xf, this.yi + textAscent() + textDescent() + 1);
        fill(this.color_title);
        textAlign(CENTER, TOP);
        text(this.text_title, this.xi + 0.5 * (this.xf - this.xi), currY);
        currY += textAscent() + textDescent() + 2;
      }
      textAlign(LEFT, TOP);
      textSize(this.text_size);
      float text_height = textAscent() + textDescent();
      for (int i = int(floor(this.scrollbar.value)); i < this.text_lines.size(); i++, currY += text_height + this.text_leading) {
        if (currY + text_height + 1 > this.yf) {
          break;
        }
        if (i < 0 || i >= quests.size()) {
          continue;
        }
        fill(this.color_text);
        if (quests.get(i).blinking) {
          fill(color(170));
        }
        if (this.wordWrap) {
          text(this.text_lines.get(i), this.xi + 2, currY);
        }
        else {
          text(this.truncateLine(this.text_lines.get(i)), this.xi + 2, currY);
        }
        if (quests.get(i).met) {
          fill(0);
          line(this.xi + 1, currY + 0.5 * text_height, this.xf - 1, currY + 0.5 * text_height);
        }
      }
      if (this.scrollbar.maxValue != this.scrollbar.minValue) {
        this.scrollbar.update(millis);
      }
      if (!this.wordWrap) {
        if (this.scrollbar_horizontal.maxValue != this.scrollbar_horizontal.minValue) {
          this.scrollbar_horizontal.update(millis);
        }
      }
      this.lastUpdateTime = millis;
      if (this.doubleclickTimer > 0) {
        this.doubleclickTimer -= timeElapsed;
      }
      currY = this.yi + 1;
      if (this.text_title_ref != null) {
        textSize(this.title_size);
        currY += textAscent() + textDescent() + 2;
      }
      textSize(this.text_size);
      text_height = textAscent() + textDescent();
      if (this.line_hovered >= floor(this.scrollbar.value)) {
        float hovered_yi = currY + (this.line_hovered - floor(this.scrollbar.value)) * (text_height + this.text_leading);
        if (hovered_yi + text_height + 1 < this.yf) {
          rectMode(CORNERS);
          fill(this.hover_color);
          strokeWeight(0.001);
          stroke(this.hover_color);
          rect(this.xi + 1, hovered_yi, this.xf - 2 - this.scrollbar.bar_size, hovered_yi + text_height);
        }
      }
      if (this.line_clicked >= floor(this.scrollbar.value)) {
        float clicked_yi = currY + (this.line_clicked - floor(this.scrollbar.value)) * (text_height + this.text_leading);
        if (clicked_yi + text_height + 1 < this.yf) {
          rectMode(CORNERS);
          fill(this.highlight_color);
          strokeWeight(0.001);
          stroke(this.highlight_color);
          rect(this.xi + 1, clicked_yi, this.xf - 2 - this.scrollbar.bar_size, clicked_yi + text_height);
          if (this.line_hovered == this.line_clicked) {
            try {
              String tooltip = quests.get(this.line_clicked).shortDescription();
              float tooltip_width = textWidth(tooltip) + 2;
              noStroke();
              fill(global.color_nameDisplayed_background);
              rect(mouseX - tooltip_width - 2, mouseY + 2, mouseX - 2, mouseY + 2 + text_height + 2);
              fill(global.color_nameDisplayed_text);
              textAlign(LEFT, TOP);
              text(tooltip, mouseX - tooltip_width - 1, mouseY + 1);
            } catch(Exception e) {}
          }
        }
      }
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
      this.scrollbar.setButtonColors(color(220), color(220, 160, 110), color(
        240, 180, 130), color(200, 140, 90), color(0));
      this.scrollbar.button_upspace.setColors(color(170), color(255, 200, 150),
        color(255, 200, 150), color(60, 30, 0), color(0));
      this.scrollbar.button_downspace.setColors(color(170), color(255, 200, 150),
        color(255, 200, 150), color(60, 30, 0), color(0));
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
      this.scrollbar_max_width = 35;
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



  class DecisionForm extends LevelForm {
    protected int ID = 0;

    DecisionForm(int ID) {
      super(0.5 * (width - Constants.level_decisionFormWidth), 0.5 * (height - Constants.level_decisionFormHeight),
        0.5 * (width + Constants.level_decisionFormWidth), 0.5 * (height + Constants.level_decisionFormHeight));
      this.ID = ID;
      this.cancel = null;
      this.setFieldCushion(0);
      this.addField(new SpacerFormField(20));

      switch(ID) {
        case 1: // francis hall initial cut scene
          this.addField(new MessageFormField("Ben puts in earbuds to drown out the stupid conversation."));
          this.addField(new SpacerFormField(20));
          RadiosFormField radios = new RadiosFormField("What music does he play?");
          radios.addRadio("Thompson Twins");
          radios.addRadio("Now 2");
          this.addField(radios);
          this.addField(new SpacerFormField(20));
          this.addField(new SubmitFormField("Listen"));
          break;
        default:
          global.errorMessage("ERROR: Decision form ID " + ID + " not recognized.");
          break;
      }
    }

    void cancel() {}

    void submit() {
      switch(ID) {
        case 1: // francis hall initial cut scene
          switch(this.fields.get(3).getValue()) {
            case "0":
              global.sounds.play_background("thompson");
              break;
            case "1":
              global.sounds.play_background("now2");
              break;
            default:
              global.sounds.play_background("starset");
              break;
          }
          try {
            global.profile.options.volume_music = 100;
            global.profile.options.volume_music_muted = false;
            global.profile.options.change();
          } catch(Exception e) {}
          break;
        default:
          global.errorMessage("ERROR: Decision form ID " + ID + " not recognized.");
          break;
      }
      this.canceled = true;
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
      ButtonsFormField insert_money = new ButtonsFormField("Insert $1", "Insert $5");
      insert_money.button1.setColors(color(170), color(236, 213, 166), color(211,
        188, 141), color(190, 165, 120), color(0));
      insert_money.button2.setColors(color(170), color(236, 213, 166), color(211,
        188, 141), color(190, 165, 120), color(0));
      this.addField(insert_money);
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
      SubmitFormField vend = new SubmitFormField(" Vend ");
      vend.button.setColors(color(170), color(236, 213, 166), color(211,
        188, 141), color(190, 165, 120), color(0));
      this.addField(vend);
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
    protected boolean guessed = false;

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
        case 1: // Tutorial
          question.setMessage("Which of these is not part of Ben's penance?");
          question.addRadio("The Golden Rule");
          question.addRadio("Praying to Mary");
          question.addRadio("Telling everyone how much he hates them");
          question.addRadio("Being kinder to those around him");
          break;
        case 2: // Francis Hall
          question.setMessage("Which of these were options for Ben to listen to?");
          question.addRadio("Kalin Twins");
          question.addRadio("Now3");
          question.addRadio("Thompson Twins");
          question.addRadio("Joe Fagin");
          break;
        default:
          global.errorMessage("ERROR: Chuck Quizmo ID " + this.chuck_quizmo.number +
            " not found.");
          break;
      }

      this.addField(new SpacerFormField(120));
      this.addField(question);
      this.addField(new SpacerFormField(20));
      this.addField(new SubmitCancelFormField("Guess!", "Leave"));
    }

    @Override
    void update(int millis) {
      super.update(millis);
      imageMode(CORNER);
      image(this.hero.getImage(), this.xi + 20, this.yi + 40, 100, 100);
      image(global.images.getImage("features/chuck_quizmo.png"), this.xi + 210, this.yi + 40, 100, 100);
      int frame = constrain(int(floor(Constants.gif_quizmoQuestion_frames * (millis() %
        Constants.gif_quizmoQuestion_time) / Constants.gif_quizmoQuestion_time)),
        0, Constants.gif_quizmoQuestion_frames);
      if (this.canceling) {
        this.time_before_cancel -= millis - this.last_update_time;
        if (this.time_before_cancel < 0) {
          this.canceled = true;
        }
        if (this.correct_guess) {
          image(global.images.getImage("features/vanna_t_smiling.png"), this.xi + 300, this.yi + 60, 80, 80);
          image(global.images.getImage("gifs/quizmo_correct/" + frame + ".png"),
            this.xi + 140, this.yi + 80, 60, 60);
        }
        else if (this.guessed) {
          image(global.images.getImage("features/vanna_t.png"), this.xi + 300, this.yi + 60, 80, 80);
          image(global.images.getImage("gifs/quizmo_wrong/" + frame + ".png"),
            this.xi + 140, this.yi + 80, 60, 60);
        }
        else {
          image(global.images.getImage("features/vanna_t.png"), this.xi + 300, this.yi + 60, 80, 80);
          image(global.images.getImage("gifs/quizmo_question/" + frame + ".png"),
            this.xi + 140, this.yi + 80, 60, 60);
        }
      }
      else {
        image(global.images.getImage("features/vanna_t.png"), this.xi + 300, this.yi + 60, 80, 80);
        image(global.images.getImage("gifs/quizmo_question/" + frame + ".png"),
          this.xi + 140, this.yi + 80, 60, 60);
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
      if (this.guessed) {
        return;
      }
      this.guessed = true;
      this.fields.get(3).disable();
      int correct_answer = -1;
      switch(this.chuck_quizmo.number) {
        case 0:
          correct_answer = 1;
          break;
        case 1: // Tutorial
          correct_answer = 3;
          break;
        case 2: // Francis Hall
          correct_answer = 2;
          break;
        default:
          global.errorMessage("ERROR: Chuck Quizmo ID " + this.chuck_quizmo.number +
            " not found.");
          break;
      }
      if (guess == correct_answer) {
        if (global.profile.answeredChuckQuizmo(this.chuck_quizmo.number)) {
          if (hero.canPickup()) {
            hero.pickup(new Item(2825));
          }
          else {
            Level.this.currMap.addItem(new Item(2825, this.hero.frontX(), this.hero.frontY()));
          }
          Level.this.chat("Chuck Quizmo: Congratulations! Here's your Star Piece!");
        }
        else {
          Level.this.chat("Chuck Quizmo: You've already won this Star Piece!");
        }
        hero.addExperience(5 + pow(min(this.chuck_quizmo.number, 10), 8));
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
      khalilMessageField.setTextSize(18, true);
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
        "with name " + mapName + " at location " + this.finalFolderPath() + ".");
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


  Rectangle getCurrentRectangle() {
    if (this.currMap == null) {
      return null;
    }
    if (!GameMapLevelEditor.class.isInstance(this.currMap)) {
      return null;
    }
    return ((GameMapLevelEditor)this.currMap).rectangle_dropping;
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
            this.currMap.addHeaderMessage("Rectangle saved");
          }
          break;
        case 'S':
          if (this.currMap != null && GameMapLevelEditor.class.isInstance(this.currMap)) {
            this.last_rectangle = ((GameMapLevelEditor)this.currMap).rectangle_dropping;
            ((GameMapLevelEditor)this.currMap).rectangle_dropping = null;
            this.currMap.addHeaderMessage("Rectangle saved");
            if (this.last_rectangle != null) {
              if (global.holding_ctrl) {
                this.player_spawn_location = this.last_rectangle;
                this.currMap.addHeaderMessage("Player respawn location set");
              }
              else {
                this.player_start_location = this.last_rectangle;
                this.currMap.addHeaderMessage("Player start location set");
              }
              this.last_rectangle = null;
            }
          }
          break;
      }
    }
  }

  @Override
  String finalFolderPath() {
    return this.folderPath + "/" + this.levelName;
  }
}
