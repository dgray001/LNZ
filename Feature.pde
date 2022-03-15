class Feature extends MapObject {
  protected int sizeX = 0;
  protected int sizeY = 0;
  protected int sizeZ = 0;

  protected int number = 0;
  protected boolean toggle = false;
  //protected Inventory inventory; // for items with inventory

  Feature(int ID) {
    super(ID);
    switch(ID) {
      case 101:
        this.setStrings("Table", "Furniture", "");
        this.setSize(2, 2, 3);
        break;
      default:
        println("ERROR: Feature ID " + ID + " not found.");
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
    this.x = floor(x);
    this.y = floor(y);
  }

  void setSize(int sizeX, int sizeY, int sizeZ) {
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.sizeZ = sizeZ;
  }

  float xi() {
    return this.x;
  }
  float yi() {
    return this.y;
  }
  float xf() {
    return this.x + this.sizeX;
  }
  float yf() {
    return this.y + this.sizeY;
  }
  float xCenter() {
    return this.x + 0.5 * this.sizeX;
  }
  float yCenter() {
    return this.y + 0.5 * this.sizeY;
  }
  float width() {
    return this.sizeX;
  }
  float height() {
    return this.sizeY;
  }
  float xRadius() {
    return 0.5 * this.sizeX;
  }
  float yRadius() {
    return 0.5 * this.sizeY;
  }

  PImage getImage() {
    String path = "features/";
    switch(this.ID) {
      case 101:
        path += "table.png";
        break;
      default:
        println("ERROR: Feature ID " + ID + " not found.");
        break;
    }
    return global.images.getImage(path);
  }

  void update(int timeElapsed) {
    switch(this.ID) {
      default:
        break;
    }
  }

  String fileString() {
    String fileString = "\n\nnew: Feature, " + this.ID;
    fileString += this.objectFileString();
    fileString += "\nnumber: " + this.number;
    fileString += "\ntoggle: " + this.toggle;
    fileString += "\nend: Feature";
    return fileString;
  }

  void addData(String datakey, String data) {
    switch(datakey) {
      case "number":
        this.number = toInt(data);
        break;
      case "toggle":
        this.toggle = toBoolean(data);
        break;
      default:
        println("ERROR: Datakey " + datakey + " not found for feature data.");
        break;
    }
  }
}
