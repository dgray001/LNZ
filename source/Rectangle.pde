class Rectangle {
  private String mapName = "";
  private float xi = 0;
  private float yi = 0;
  private float xf = 0;
  private float yf = 0;

  Rectangle() {}
  Rectangle(String mapName, float xi, float yi, float xf, float yf) {
    this.mapName = mapName;
    if (xf < xi) {
      this.xi = xf;
      this.xf = xi;
    }
    else {
      this.xi = xi;
      this.xf = xf;
    }
    if (yf < yi) {
      this.yi = yf;
      this.yf = yi;
    }
    else {
      this.yi = yi;
      this.yf = yf;
    }
  }
  Rectangle(String mapName, MapObject object) {
    this.mapName = mapName;
    this.setLocation(object);
  }

  float centerX() {
    return this.xi + 0.5 * (this.xf - this.xi);
  }
  float centerY() {
    return this.yi + 0.5 * (this.yf - this.yi);
  }

  boolean touching(MapObject object, String object_map_name) {
    if (!this.mapName.equals(object_map_name)) {
      return false;
    }
    if (object.xf() >= this.xi && object.yf() >= this.yi &&
      object.xi() <= this.xf && object.yi() <= this.yf) {
      return true;
    }
    return false;
  }
  boolean touching(MapObject object) {
    if (object.xf() >= this.xi && object.yf() >= this.yi &&
      object.xi() <= this.xf && object.yi() <= this.yf) {
      return true;
    }
    return false;
  }

  boolean contains(MapObject object, String object_map_name) {
    if (!this.mapName.equals(object_map_name)) {
      return false;
    }
    if (object.xi() >= this.xi && object.yi() >= this.yi &&
      object.xf() <= this.xf && object.yf() <= this.yf) {
      return true;
    }
    return false;
  }
  boolean contains(MapObject object) {
    if (object.xi() >= this.xi && object.yi() >= this.yi &&
      object.xf() <= this.xf && object.yf() <= this.yf) {
      return true;
    }
    return false;
  }

  void setLocation(MapObject object) {
    this.xi = object.xi();
    this.yi = object.yi();
    this.xf = object.xf();
    this.yf = object.yf();
  }

  String fileString() {
    return this.mapName + ", " + this.xi + ", " + this.yi + ", " + this.xf + ", " + this.yf;
  }

  void addData(String fileString) {
    String[] data = split(fileString, ',');
    if (data.length < 5) {
      global.errorMessage("ERROR: Data dimensions not sufficient for Rectangle data.");
      return;
    }
    this.mapName = trim(data[0]);
    this.xi = toFloat(trim(data[1]));
    this.yi = toFloat(trim(data[2]));
    this.xf = toFloat(trim(data[3]));
    this.yf = toFloat(trim(data[4]));
  }
}
