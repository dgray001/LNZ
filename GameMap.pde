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

  GameMap(GameMapCode code, String folderPath) {
    this.code = code;
    // open file(folderPath)
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
    PrintWriter file = createWriter(folderPath + "/" + this.code.file_name() + ".map.lnz");
    file.flush();
    file.close();
  }
}



class GameMapEditor extends GameMap {
  GameMapEditor(GameMapCode code, String folderPath) {
    super(code, folderPath);
  }
}
