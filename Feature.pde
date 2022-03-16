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
      // fog
      case 1:
        this.setStrings("Fog", "", "");
        this.setSize(1, 1, 0);
        break;
      case 2:
        this.setStrings("Fog", "", "");
        this.setSize(1, 1, 0);
        break;
      case 3:
        this.setStrings("Fog", "", "");
        this.setSize(1, 1, 0);
        break;
      case 4:
        this.setStrings("Fog", "", "");
        this.setSize(1, 1, 0);
        break;
      case 5:
        this.setStrings("Fog", "", "");
        this.setSize(1, 1, 0);
        break;
      case 6:
        this.setStrings("Fog", "", "");
        this.setSize(1, 1, 0);
        break;
      case 7:
        this.setStrings("Fog", "", "");
        this.setSize(1, 1, 0);
        break;
      case 8:
        this.setStrings("Fog", "", "");
        this.setSize(1, 1, 0);
        break;
      case 9:
        this.setStrings("Fog", "", "");
        this.setSize(1, 1, 0);
        break;
      case 10:
        this.setStrings("Fog", "", "");
        this.setSize(1, 1, 0);
        break;

      // Furniture
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
      case 1:
        path += "fog0.png";
        break;
      case 2:
        path += "fog1.png";
        break;
      case 3:
        path += "fog2.png";
        break;
      case 4:
        path += "fog3.png";
        break;
      case 5:
        path += "fog4.png";
        break;
      case 6:
        path += "fog5.png";
        break;
      case 7:
        path += "fog6.png";
        break;
      case 8:
        path += "fog7.png";
        break;
      case 9:
        path += "fog8.png";
        break;
      case 10:
        path += "fog9.png";
        break;
      case 101:
        path += "table.png";
        break;
      default:
        println("ERROR: Feature ID " + ID + " not found.");
        path += "default.png";
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
    String fileString = "\nnew: Feature: " + this.ID;
    fileString += this.objectFileString();
    fileString += "\nnumber: " + this.number;
    fileString += "\ntoggle: " + this.toggle;
    fileString += "\nend: Feature\n";
    return fileString;
  }

  void addData(String datakey, String data) {
    if (this.addObjectData(datakey, data)) {
      return;
    }
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


  boolean isFog() {
    switch(this.ID) {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
      case 10:
        return true;
      default:
        return false;
    }
  }
}
