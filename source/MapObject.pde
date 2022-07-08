abstract class EditMapObjectForm extends FormLNZ {
  EditMapObjectForm(MapObject mapObject) {
    super(0.5 * (width - Constants.mapEditor_formWidth), 0.5 * (height - Constants.mapEditor_formHeight),
      0.5 * (width + Constants.mapEditor_formWidth), 0.5 * (height + Constants.mapEditor_formHeight));
    this.setTitleText(mapObject.display_name_editor());
    this.setTitleSize(18);
    this.addField(new SpacerFormField(1));
    this.color_background = color(160, 220, 220);
    this.color_header = color(30, 150, 150);
  }

  @Override
  void update(int millis) {
    super.update(millis);
    this.submitForm();
  }

  void submit() {
    this.updateObject();
    this.updateForm();
  }

  abstract void updateObject();
  abstract void updateForm();
}


abstract class MapObject {
  protected int ID = 0;
  protected String display_name = "-- Error --";
  protected String type = "-- Error --";
  protected String description = "";

  protected float x = 0;
  protected float y = 0;

  protected int curr_height = 0; // bottom of object

  protected boolean hovered = false;
  protected boolean in_view = false;
  protected boolean remove = false; // GameMap will remove object

  MapObject() {}
  MapObject(int ID) {
    this.ID = ID;
  }

  void setStrings(String display_name, String type, String description) {
    this.display_name = display_name;
    this.type = type;
    this.description = description;
  }

  abstract String display_name();
  String display_name_editor() {
    return this.display_name();
  }
  abstract String type();
  abstract String description();
  void setDescription(String description) {
    this.description = description;
  }
  abstract String selectedObjectTextboxText();

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

  boolean inMap(int mapXI, int mapYI, int mapXF, int mapYF) {
    if (this.xi() >= mapXI && this.yi() >= mapYI && this.xf() <= mapXF && this.yf() <= mapYF) {
      return true;
    }
    return false;
  }
  boolean inMapX(int mapXI, int mapXF) {
    if (this.xi() >= mapXI && this.xf() <= mapXF) {
      return true;
    }
    return false;
  }
  boolean inMapY(int mapYI, int mapYF) {
    if (this.yi() >= mapYI && this.yf() <= mapYF) {
      return true;
    }
    return false;
  }

  boolean inView(float xStart, float yStart, float xEnd, float yEnd) {
    if (this.xi() >= xStart - Constants.small_number && this.yi() >= yStart - Constants.small_number &&
      this.xf() <= xEnd + Constants.small_number && this.yf() <= yEnd + Constants.small_number) {
      this.in_view = true;
      return true;
    }
    this.in_view = false;
    return false;
  }

  float distance(MapObject object) {
    float xDistance = max(0, abs(this.xCenter() - object.xCenter()) - this.xRadius() - object.xRadius());
    float yDistance = max(0, abs(this.yCenter() - object.yCenter()) - this.yRadius() - object.yRadius());
    return sqrt(xDistance * xDistance + yDistance * yDistance);
  }
  float centerDistance(MapObject object) {
    float xDistance = abs(this.xCenter() - object.xCenter());
    float yDistance = abs(this.yCenter() - object.yCenter());
    return sqrt(xDistance * xDistance + yDistance * yDistance);
  }
  float distance(float pointX, float pointY) {
    float xDistance = max(0, abs(this.xCenter() - pointX) - this.xRadius());
    float yDistance = max(0, abs(this.yCenter() - pointY) - this.yRadius());
    return sqrt(xDistance * xDistance + yDistance * yDistance);
  }
  float distanceFromPoint(float pointX, float pointY) {
    float xDistance = this.xCenter() - pointX;
    float yDistance = this.yCenter() - pointY;
    return sqrt(xDistance * xDistance + yDistance * yDistance);
  }

  boolean touching(MapObject object) {
    if ( ((abs(this.xCenter() - object.xCenter()) - this.xRadius() - object.xRadius()) <= 0) ||
      ((abs(this.yCenter() - object.yCenter()) - this.yRadius() - object.yRadius()) <= 0) ) {
        return true;
    }
    return false;
  }

  // returns arraylist of squares the unit is on
  ArrayList<IntegerCoordinate> getSquaresOn() {
    ArrayList<IntegerCoordinate> squares_on = new ArrayList<IntegerCoordinate>();
    for (int i = round(floor(this.xi())); i < round(ceil(this.xf())); i++) {
      for (int j = round(floor(this.yi())); j < round(ceil(this.yf())); j++) {
        squares_on.add(new IntegerCoordinate(i, j));
      }
    }
    return squares_on;
  }

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

  abstract boolean targetable(Unit u);

  abstract String fileString();
  String objectFileString() {
    return "\nlocation: " + this.x + ", " + this.y + ", " + this.curr_height +
      "\ncurr_height: " + this.curr_height + "\nremove: " + this.remove;
  }

  abstract void addData(String datakey, String data);
  boolean addObjectData(String datakey, String data) {
    switch(datakey) {
      case "location":
        String[] locationdata = split(data, ',');
        if (locationdata.length < 3) {
          global.errorMessage("ERROR: Location data for object too short: " + data + ".");
          return false;
        }
        this.x = toFloat(trim(locationdata[0]));
        this.y = toFloat(trim(locationdata[1]));
        this.curr_height = toInt(trim(locationdata[2]));
        return true;
      case "curr_height":
        this.curr_height = toInt(data);
        return true;
      case "remove":
        this.remove = toBoolean(data);
        return true;
      case "description":
        this.setDescription(data);
        return true;
    }
    return false;
  }
}