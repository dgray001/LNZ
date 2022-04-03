class Projectile extends MapObject {
  protected float size = Constants.projectile_defaultSize; // radius

  Projectile(int ID) {
    super(ID);
    switch(ID) {
      default:
        global.errorMessage("ERROR: Projectile ID " + ID + " not found.");
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
  String selectedObjectTextboxText() {
    String text = "-- " + this.type() + " --";
    return text + "\n\n" + this.description();
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

  @Override
  float distance(MapObject object) {
    float xDistance = max(0, abs(this.xCenter() - object.xCenter()) - object.xRadius());
    float yDistance = max(0, abs(this.yCenter() - object.yCenter()) - object.yRadius());
    return sqrt(xDistance * xDistance + yDistance * yDistance);
  }

  @Override
  boolean touching(MapObject object) {
    if ( ((abs(this.xCenter() - object.xCenter()) - object.xRadius()) <= 0) ||
      ((abs(this.yCenter() - object.yCenter()) - object.yRadius()) <= 0) ) {
        return true;
    }
    return false;
  }

  PImage getImage() {
    String path = "projectiles/";
    switch(this.ID) {
      default:
        global.errorMessage("ERROR: Projectile ID " + ID + " not found.");
        path += "default.png";
        break;
    }
    return global.images.getImage(path);
  }


  boolean targetable(Unit u) {
    return false;
  }


  void update(int timeElapsed) {
  }


  String fileString() {
    String fileString = "\nnew: Projectile: " + this.ID;
    fileString += this.objectFileString();
    fileString += "\nsize: " + this.size;
    fileString += "\nend: Projectile\n";
    return fileString;
  }

  void addData(String datakey, String data) {
    if (this.addObjectData(datakey, data)) {
      return;
    }
    switch(datakey) {
      case "size":
        this.size = toFloat(data);
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not found for projectile data.");
        break;
    }
  }
}
