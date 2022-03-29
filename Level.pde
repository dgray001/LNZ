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

  protected Hero player;

  Level() {
  }
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
  }

  void mouseMove(float mX, float mY) {
    if (this.currMap != null) {
      this.currMap.mouseMove(mX, mY);
    }
  }

  void mousePress() {
    if (this.currMap != null) {
      this.currMap.mousePress();
    }
  }

  void mouseRelease(float mX, float mY) {
    if (this.currMap != null) {
      this.currMap.mouseRelease(mX, mY);
    }
  }

  void scroll(int amount) {
    if (this.currMap != null) {
      this.currMap.scroll(amount);
    }
  }

  void keyPress() {
    if (this.currMap != null) {
      this.currMap.keyPress();
    }
  }

  void keyRelease() {
    if (this.currMap != null) {
      this.currMap.keyRelease();
    }
  }


  void save() {
    String finalFolderPath = this.folderPath;
    if (this.location == Location.ERROR) {
      finalFolderPath += "/" + this.levelName;
    }
    else {
      finalFolderPath += "/" + this.location.file_name();
    }
    if (!folderExists(finalFolderPath)) {
      mkdir(finalFolderPath);
    };
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
    /*for (Linker linker : this.linkers) {
      file.println(linker.fileString());
    }*/
    /*for (Map.Entry<Integer, Trigger> entry : this.triggers.entrySet()) {
      file.println("nextTriggerKey: " + entry.getKey());
      file.println(entry.getValue().fileString());
    }*/
    file.println("end: Level");
    file.flush();
    file.close();
    if (this.currMap != null) {
      this.currMap.save(finalFolderPath);
    }
  }


  void open() {
    this.open2Data(this.open1File());
    //this.openCurrMap(); (maybe not have this here and put in separate function called in interface) => check renameLEvel function
  }


  String[] open1File() {
    String finalFolderPath = this.folderPath;
    if (this.location == Location.ERROR) {
      finalFolderPath += "/" + this.levelName;
    }
    else {
      finalFolderPath += "/" + this.location.file_name();
    }
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

    //Linker curr_linker = null;
    int max_trigger_key = 0;
    //Trigger curr_trigger = null;

    for (String line : lines) {
      String[] parameters = split(line, ':');
      if (parameters.length < 2) {
        continue;
      }

      String dataname = trim(parameters[0]);
      String data = trim(parameters[1]);
      for (int i = 2; i < parameters.length; i++) {
        data += ":" + parameters[i];
      }
      if (dataname.equals("new")) {
        ReadFileObject type = ReadFileObject.objectType(trim(parameters[1]));
        switch(type) {
          case LEVEL:
            object_queue.push(type);
            break;
          case LINKER:
          case TRIGGER:
            /*if (parameters.length < 3) {
              global.errorMessage("ERROR: Feature ID missing in Feature constructor.");
              break;
            }
            object_queue.push(type);
            curr_feature = new Feature(toInt(trim(parameters[2])));*/
            break;
          default:
            println("ERROR: Can't add a " + type + " type to Level data.");
            break;
        }
      }
      else if (dataname.equals("end")) {
        ReadFileObject type = ReadFileObject.objectType(data);
        if (object_queue.empty()) {
          global.errorMessage("ERROR: Tring to end a " + type.name + " object but not inside any object.");
        }
        else if (type.name.equals(object_queue.peek().name)) {
          switch(object_queue.pop()) {
            case LEVEL:
              return;
            case LINKER:
              /*if (curr_linker == null) {
                global.errorMessage("ERROR: Trying to end a null linker.");
              }
              this.addLinker(curr_linker);
              curr_linker = null;*/
              break;
            case TRIGGER:
              /*if (curr_trigger == null) {
                global.errorMessage("ERROR: Trying to end a null trigger.");
              }
              if (this.nextTriggerKey > max_trigger_key) {
                max_trigger_key = this.nextTriggerKey;
              }
              this.addTrigger(curr_trigger);
              curr_trigger = null;*/
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
            this.addData(dataname, data);
            break;
          case LINKER:
            /*if (curr_linker == null) {
              global.errorMessage("ERROR: Trying to add linker data to null linker.");
            }
            curr_linker.addData(dataname, data);*/
            break;
          case TRIGGER:
            /*if (curr_trigger == null) {
              global.errorMessage("ERROR: Trying to add trigger data to null trigger.");
            }
            curr_trigger.addData(dataname, data);*/
            break;
          default:
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
          this.mapNames.add(map_name);
        }
        break;
      case "nextTriggerKey":
        this.nextTriggerKey = toInt(data);
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not recognized for GameMap object.");
        break;
    }
  }
}



class LevelEditor extends Level {
  LevelEditor() {
  }
  LevelEditor(String folderPath, String levelName) {
    this.folderPath = folderPath;
    this.levelName = levelName;
    this.open();
  }
}
