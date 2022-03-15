abstract class MapObject {
  protected int ID = 0;
  protected String display_name = "-- Error --";
  protected String type = "-- Error --";
  protected String description = "";

  protected float x = 0;
  protected float y = 0;

  protected int height = 0;

  protected boolean hovered = false;
  protected boolean remove = false; // GameMap will remove object

  MapObject(int ID) {
    this.ID = ID;
  }

  void setStrings(String display_name, String type, String description) {
    this.display_name = display_name;
    this.type = type;
    this.description = description;
  }

  abstract String display_name();
  abstract String type();
  abstract String description();

  abstract void setLocation(float x, float y);
  abstract float xi();
  abstract float yi();
  abstract float xf();
  abstract float yf();
  abstract float xCenter();
  abstract float yCenter();
  abstract float width();
  abstract float height();
  abstract float xRadius();
  abstract float yRadius();

  boolean inMap(int mapWidth, int mapHeight) {
    if (this.xi() >= 0 && this.yi() >= 0 && this.xf() <= mapWidth && this.yf() <= mapHeight) {
      return true;
    }
    return false;
  }

  boolean inView(float xStart, float yStart, float xEnd, float yEnd) {
    if (this.xi() >= xStart && this.yi() >= yStart && this.xf() <= xEnd && this.yf() <= yEnd) {
      return true;
    }
    return false;
  }

  float distance(MapObject object) {
    float xDistance = max(0, abs(this.xCenter() - object.xCenter()) - this.xRadius() - object.xRadius());
    float yDistance = max(0, abs(this.yCenter() - object.yCenter()) - this.yRadius() - object.yRadius());
    return sqrt(xDistance * xDistance + yDistance * yDistance);
  }

  boolean touching(MapObject object) {
    if ( ((abs(this.xCenter() - object.xCenter()) - this.xRadius() - object.xRadius()) <= 0) ||
      ((abs(this.yCenter() - object.yCenter()) - this.yRadius() - object.yRadius()) <= 0) ) {
        return true;
    }
    return false;
  }

  abstract int height(float x, float y); // height dependent on parts of object

  abstract PImage getImage();

  abstract void update(int timeElapsed);

  void mouseMove(float mX, float mY) {
    if (mX >= this.xi() && mY >= this.yi() && mX <= this.xf() && mY <= this.yf()) {
      this.hovered = true;
    }
    else {
      this.hovered = false;
    }
  }
}
