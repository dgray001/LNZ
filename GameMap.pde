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



class GameMap {
  protected GameMapCode code = GameMapCode.ERROR;
  protected String mapName = "";

  protected int mapWidth = 0;
  protected int mapHeight = 0;

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
  }


  void update(int millis) {
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
