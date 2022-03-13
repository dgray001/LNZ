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
}



class GameMapSquare {
  private int squareHeight = 0;
  //private ArrayList<Feature> features = new ArrayList<Feature>();

  GameMapSquare() {}
}



class GameMap {
  protected GameMapCode code = GameMapCode.ERROR;
  protected String mapName = "";

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
  protected float color_border = color(60);
  protected float color_background = color(20);

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
    // open file(folderPath)
  }
  GameMap(String mapName, String folderPath) {
    this.mapName = mapName;
    // open file(folderPath)
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
    this.terrain_display = new DImg(100, 100);
    this.terrain_display.colorPixels(color(255, 0, 0));
    this.xi_map = xi + 2 * Constants.map_borderSize;
    this.yi_map = yi + Constants.map_borderSize;
    this.xf_map = xf - 2 * Constants.map_borderSize;
    this.yf_map = yf - Constants.map_borderSize;
  }


  void drawMap() {
    rectMode(CORNERS);
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
    file.println("code: " + this.code.file_name());
    file.println("mapName: " + this.mapName);
    file.println("mapWidth: " + this.mapWidth);
    file.println("mapHeight: " + this.mapHeight);
    file.flush();
    file.close();
  }
}



class GameMapEditor extends GameMap {
  GameMapEditor(GameMapCode code, String folderPath) {
    super(code, folderPath);
  }
}
