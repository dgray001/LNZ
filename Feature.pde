class Feature extends MapObject {
  protected int xSize = 0;
  protected int ySize = 0;

  //protected int number = 0; // timer, id, etc
  //protected boolean toggle = false;
  //protected Inventory inventory; // for items with inventory

  Feature(int ID) {
    super(ID);
    switch(ID) {
      case 101:
        this.setStrings("Table", "Furniture", "");
        this.setSize(2, 2);
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

  void setSize(int xSize, int ySize) {
    this.xSize = xSize;
    this.ySize = ySize;
  }

  float xi() {
    return this.x;
  }
  float yi() {
    return this.y;
  }
  float xf() {
    return this.x + this.xSize;
  }
  float yf() {
    return this.y + this.ySize;
  }
  float xCenter() {
    return this.x + 0.5 * this.xSize;
  }
  float yCenter() {
    return this.y + 0.5 * this.ySize;
  }
  float width() {
    return this.xSize;
  }
  float height() {
    return this.ySize;
  }
  float xRadius() {
    return 0.5 * this.xSize;
  }
  float yRadius() {
    return 0.5 * this.ySize;
  }

  int height(float x, float y) {
    return 0;
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
  }
}
