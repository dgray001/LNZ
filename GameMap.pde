enum GameMapCode {
  ERROR, HOMEBASE, FRANCIS_FLOOR2, FRANCIS_FLOOR1, FRANCIS_GROUND;

  private static final List<GameMapCode> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  public String display_name() {
    return GameMapCode.display_name(this);
  }
  static public String display_name(GameMapCode a) {
    switch(a) {
      case HOMEBASE:
        return "Home Base";
      case FRANCIS_FLOOR2:
        return "Francis Hall, 2nd floor";
      case FRANCIS_FLOOR1:
        return "Francis Hall, 1st floor";
      case FRANCIS_GROUND:
        return "Francis Hall, ground floor";
      default:
        return "-- Error --";
    }
  }

  public String file_name() {
    return GameMapCode.file_name(this);
  }
  static public String file_name(GameMapCode a) {
    switch(a) {
      case HOMEBASE:
        return "HOMEBASE";
      case FRANCIS_FLOOR2:
        return "FRANCIS_FLOOR2";
      case FRANCIS_FLOOR1:
        return "FRANCIS_FLOOR1";
      case FRANCIS_GROUND:
        return "FRANCIS_GROUND";
      default:
        return "ERROR";
    }
  }

  static public GameMapCode gameMapCode(String display_name) {
    for (GameMapCode code : GameMapCode.VALUES) {
      if (code == GameMapCode.ERROR) {
        continue;
      }
      if (GameMapCode.display_name(code).equals(display_name) ||
        GameMapCode.file_name(code).equals(display_name)) {
        return code;
      }
    }
    return GameMapCode.ERROR;
  }
}



enum ReadFileObject {
  NONE("None"), MAP("Map");

  private static final List<ReadFileObject> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  private String name;

  private ReadFileObject(String name) {
    this.name = name;
  }

  static public ReadFileObject objectType(String name) {
    for (ReadFileObject type : ReadFileObject.VALUES) {
      if (type == ReadFileObject.NONE) {
        continue;
      }
      if (type.name.equals(name)) {
        return type;
      }
    }
    return ReadFileObject.NONE;
  }
}



class GameMapSquare {
  private int squareHeight = 0;
  private int terrain_id = 0;

  GameMapSquare() {}
}



class GameMap {
  protected GameMapCode code = GameMapCode.ERROR;
  protected String mapName = "";
  protected boolean nullify = false;

  protected int mapWidth = 0;
  protected int mapHeight = 0;
  protected GameMapSquare[][] squares;

  protected DImg terrain;
  //protected DImg fog;
  protected DImg terrain_display = new DImg(0, 0);

  protected float viewX = 0;
  protected float viewY = 0;
  protected float zoom = Constants.map_defaultZoom;

  protected float xi = 0;
  protected float yi = 0;
  protected float xf = 0;
  protected float yf = 0;
  protected color color_border = color(60);
  protected color color_background = color(20);

  protected float xi_map = 0;
  protected float yi_map = 0;
  protected float xf_map = 0;
  protected float yf_map = 0;

  protected float startSquareX = 0;
  protected float startSquareY = 0;
  protected float visSquareX = 0;
  protected float visSquareY = 0;

  GameMap(GameMapCode code, String folderPath) {
    this.code = code;
    this.mapName = GameMapCode.display_name(code);
    this.open(folderPath);
  }
  GameMap(String mapName, String folderPath) {
    this.mapName = mapName;
    this.open(folderPath);
  }
  GameMap(String mapName, int mapWidth, int mapHeight) {
    this.mapName = mapName;
    this.mapWidth = mapWidth;
    this.mapHeight = mapHeight;
    this.initializeSquares();
  }


  void initializeSquares() {
    this.squares = new GameMapSquare[this.mapWidth][this.mapHeight];
    for (int i = 0; i < this.mapWidth; i++) {
      for (int j = 0; j < this.mapHeight; j++) {
        this.squares[i][j] = new GameMapSquare();
      }
    }
    this.terrain = new DImg(this.mapWidth * Constants.map_terrainResolution, this.mapHeight * Constants.map_terrainResolution);
    this.terrain.makeTransparent();
  }


  void setLocation(float xi, float yi, float xf, float yf) {
    this.xi = xi;
    this.yi = yi;
    this.xf = xf;
    this.yf = yf;
    this.refreshDisplayMap();
  }


  void refreshDisplayMap() { // in another thread ?
    this.startSquareX = max(0, this.viewX - (0.5 * width - this.xi - Constants.map_borderSize) / this.zoom);
    this.startSquareY = max(0, this.viewY - (0.5 * height - this.yi - Constants.map_borderSize) / this.zoom);
    this.xi_map = 0.5 * width - (this.viewX - this.startSquareX) * this.zoom;
    this.yi_map = 0.5 * height - (this.viewY - this.startSquareY) * this.zoom;
    this.visSquareX = min(this.mapWidth - this.startSquareX, (this.xf - this.xi_map - Constants.map_borderSize) / this.zoom);
    this.visSquareY = min(this.mapHeight - this.startSquareY, (this.yf - this.yi_map - Constants.map_borderSize) / this.zoom);
    this.xf_map = this.xi_map + this.visSquareX * this.zoom;
    this.yf_map = this.yi_map + this.visSquareY * this.zoom;

    this.terrain_display = new DImg(int(this.visSquareX * this.zoom), int(this.visSquareY * this.zoom));
    this.terrain_display.colorPixels(color(255, 0, 0));
  }


  void drawMap() {
    rectMode(CORNERS);
    noStroke();
    fill(this.color_border);
    rect(this.xi, this.yi, this.xf, this.yf);
    fill(this.color_background);
    rect(this.xi + Constants.map_borderSize, this.yi + Constants.map_borderSize,
      this.xf - Constants.map_borderSize, this.yf - Constants.map_borderSize);
    // display terrain
    this.terrain_display.display(this.xi_map, this.yi_map, this.xf_map, this.yf_map);
  }


  void update(int millis) {
    this.drawMap();
  }

  void mouseMove(float mX, float mY) {
  }

  void mousePress() {
  }

  void mouseRelease() {
  }

  void scroll(int amount) {
  }

  void keyPress() {
  }

  void keyRelease() {
  }


  void save(String folderPath) {
    PrintWriter file;
    if (this.code == GameMapCode.ERROR) {
      file = createWriter(folderPath + "/" + this.mapName + ".map.lnz");
    }
    else {
      file = createWriter(folderPath + "/" + this.code.file_name() + ".map.lnz");
    }
    file.println("new: Map");
    file.println("code: " + this.code.file_name());
    file.println("mapName: " + this.mapName);
    file.println("mapWidth: " + this.mapWidth);
    file.println("mapHeight: " + this.mapHeight);
    file.println("end: Map");
    file.flush();
    file.close();
  }


  void open(String folderPath) {
    String[] lines;
    String path;
    if (this.code == GameMapCode.ERROR) {
      path = folderPath + "/" + this.mapName + ".map.lnz";
    }
    else {
      path = folderPath + "/" + this.code.file_name() + ".map.lnz";
    }
    lines = loadStrings(path);
    if (lines == null) {
      println("ERROR: Reading map at path " + path + " but no file exists.");
      this.nullify = true;
      return;
    }

    Stack<ReadFileObject> object_queue = new Stack<ReadFileObject>();

    for (String line : lines) {
      String[] parameters = split(line, ':');
      if (parameters.length < 2) {
        continue;
      }

      String dataname = trim(parameters[0]);
      String data = trim(parameters[1]);
      if (dataname.equals("new")) {
        ReadFileObject type = ReadFileObject.objectType(data);
        switch(type) {
          case MAP:
            object_queue.push(type);
            break;
          default:
            break;
        }
      }
      else if (dataname.equals("end")) {
        ReadFileObject type = ReadFileObject.objectType(data);
        if (object_queue.empty()) {
          println("ERROR: Tring to end a " + type.name + " object but not inside any object.");
        }
        else if (type.name.equals(object_queue.peek().name)) {
          switch(object_queue.pop()) {
            case MAP:
              return;
            default:
              break;
          }
        }
        else {
          println("ERROR: Tring to end a " + type.name + " object while inside a " + object_queue.peek().name + " object.");
        }
      }
      else {
        switch(object_queue.peek()) {
          case MAP:
            this.addData(dataname, data);
            break;
          default:
            break;
        }
      }
    }
  }


  void addData(String dataname, String data) {
    switch(dataname) {
      case "code":
        this.code = GameMapCode.gameMapCode(data);
        break;
      case "mapName":
        this.mapName = data;
        break;
      case "mapWidth":
        this.mapWidth = toInt(data);
        break;
      case "mapHeight":
        this.mapHeight = toInt(data);
        break;
      default:
        println("ERROR: Dataname " + dataname + " not recognized for GameMap object.");
        break;
    }
  }
}



class GameMapEditor extends GameMap {

  GameMapEditor(GameMapCode code, String folderPath) {
    super(code, folderPath);
  }
  GameMapEditor(String mapName, String folderPath) {
    super(mapName, folderPath);
  }
  GameMapEditor(String mapName, int mapWidth, int mapHeight) {
    super(mapName, mapWidth, mapHeight);
  }
}
