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
  protected String filePath; // to profile folder (or saved levels folder)
  protected Location location = Location.ERROR;

  protected GameMap currMap;
  protected GameMapCode currMapCode = GameMapCode.ERROR;

  protected ArrayList<Linker> linkers = new ArrayList<Linker>();
  protected ArrayList<Trigger> triggers = new ArrayList<Trigger>();

  protected Hero player;

  Level(String filePath, Location location) {
    this.filePath = filePath;
    this.location = location;
    // open file
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


  void save() {
    PrintWriter file = createWriter(this.filePath + "/" + this.location.file_name() + "/level.lnz");
    file.println("filePath: " + this.filePath);
    file.println("location: " + this.location.file_name());
    file.println("currMapCode: " + this.currMapCode);
    file.flush();
    file.close();
    if (this.currMap != null) {
      this.currMap.save(this.filePath + "/" + this.location.file_name());
    }
  }
}



class LevelEditor extends Level {
  LevelEditor(String filePath, Location location) {
    super(filePath, location);
  }
}
