class Unit extends MapObject {
  protected float size = 0; // radius
  protected int sizeZ = 0;

  Unit(int ID) {
    super(ID);
    switch(ID) {
      default:
        println("ERROR: Unit ID " + ID + " not found.");
        break;
    }
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

  PImage getImage() {
    String path = "units/";
    switch(this.ID) {
      default:
        println("ERROR: Unit ID " + ID + " not found.");
        break;
    }
    return global.images.getImage(path);
  }

  void update(int timeElapsed) {
    // moving
    // other action timers
    // timers for status effects
    // timers for AI actions if controlled by AI
  }

  String fileString() {
    String fileString = "\n\nnew: Unit, " + this.ID;
    fileString += this.objectFileString();
    fileString += "\nsize: " + this.size;
    fileString += "\nend: Unit";
    return fileString;
  }

  void addData(String datakey, String data) {
    switch(datakey) {
      case "size":
        this.size = toFloat(data);
        break;
      default:
        println("ERROR: Datakey " + datakey + " not found for unit data.");
        break;
    }
  }
}
