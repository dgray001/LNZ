class VisualEffect extends MapObject {
  protected float size_width = 0;
  protected float size_height = 0;
  protected float timer = 0;
  protected boolean scale_size = true;

  VisualEffect(int ID) {
    super(ID);
    switch(ID) {
      // gifs
      case 4001: // move gif
        this.setValues(1.3 * global.configuration.cursor_size,
          1.3 * global.configuration.cursor_size, Constants.gif_move_time);
        this.scale_size = false;
        break;
      case 4002: // chuck quizmo poof
        this.setValues(1, 1, 1000 + Constants.gif_poof_time);
        break;
      // abilities
      case 4103: // nelson glare
      case 4108: // nelson glare II
        break;
      default:
        global.errorMessage("ERROR: VisualEffect ID " + ID + " not found.");
        break;
    }
  }

  void setValues(float size_width, float size_height, float timer) {
    this.size_width = size_width;
    this.size_height = size_height;
    this.timer = timer;
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
    return this.x - 0.5 * this.size_width;
  }
  float yi() {
    return this.y - 0.5 * this.size_height;
  }
  float xf() {
    return this.x + 0.5 * this.size_width;
  }
  float yf() {
    return this.y + 0.5 * this.size_height;
  }
  float xCenter() {
    return this.x;
  }
  float yCenter() {
    return this.y;
  }
  float width() {
    return this.size_width;
  }
  float height() {
    return this.size_height;
  }
  float xRadius() {
    return 0.5 * this.size_width;
  }
  float yRadius() {
    return 0.5 * this.size_height;
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
    String path = "gifs/";
    int frame = 0;
    switch(this.ID) {
      case 4001:
        path += "move/";
        frame = int(floor(Constants.gif_move_frames *
          (1.0 - this.timer / (1 + Constants.gif_move_time))));
        path += frame + ".png";
        break;
      case 4002:
        if (this.timer > Constants.gif_poof_time) {
          path = "features/chuck_quizmo.png";
        }
        else {
          this.size_width = 1.6;
          path += "poof/";
          frame = int(floor(Constants.gif_poof_frames *
            (1.0 - this.timer / (1 + Constants.gif_poof_time))));
          path += frame + ".png";
        }
        break;
      default:
        global.errorMessage("ERROR: Visual Effect ID " + ID + " not found.");
        path = "default.png";
        break;
    }
    return global.images.getImage(path);
  }


  boolean targetable(Unit u) {
    return false;
  }


  void update(int timeElapsed) {
    this.timer -= timeElapsed;
    if (this.timer < 0) {
      this.remove = true;
    }
  }


  void display(float zoom) {
    float range = 0;
    switch(this.ID) {
      case 4103: // nelson glare
        ellipseMode(RADIUS);
        fill(170, 160);
        noStroke();
        range = Constants.ability_103_range * (1 - this.timer / Constants.ability_103_castTime);
        arc(0, 0, range * zoom, range * zoom, this.size_width, this.size_height, PIE);
        break;
      case 4108: // nelson glare II
        ellipseMode(RADIUS);
        fill(170, 200);
        noStroke();
        range = Constants.ability_108_range * (1 - this.timer / Constants.ability_108_castTime);
        arc(0, 0, range * zoom, range * zoom, this.size_width, this.size_height, PIE);
        break;
      default:
        if (this.scale_size) {
          image(this.getImage(), 0, 0, this.size_width * zoom, this.size_height * zoom);
        }
        else {
          image(this.getImage(), 0, 0, this.size_width, this.size_height);
        }
        break;
    }
  }


  String fileString() {
    String fileString = "\nnew: VisualEffect: " + this.ID;
    fileString += this.objectFileString();
    fileString += "\nsize_width: " + this.size_width;
    fileString += "\nsize_height: " + this.size_height;
    fileString += "\ntimer: " + this.timer;
    fileString += "\nend: VisualEffect\n";
    return fileString;
  }

  void addData(String datakey, String data) {
    if (this.addObjectData(datakey, data)) {
      return;
    }
    switch(datakey) {
      case "size_width":
        this.size_width = toFloat(data);
        break;
      case "size_height":
        this.size_height = toFloat(data);
        break;
      case "timer":
        this.timer = toFloat(data);
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not found for visual effect data.");
        break;
    }
  }
}
