enum ProgramState {
  INITIAL_INTERFACE, EXITING, ENTERING_MAINMENU, MAINMENU_INTERFACE, ENTERING_MAPEDITOR, MAPEDITOR_INTERFACE;
}


class Global {
  // Program
  private InterfaceLNZ menu;
  private ProgramState state = ProgramState.INITIAL_INTERFACE;
  private int timer_exiting = Constants.exit_delay;
  private Images images;
  private Sounds sounds;
  private Configuration configuration = new Configuration();
  private PImage cursor;
  // FPS
  private int lastFrameTime = millis();
  private float lastFPS = Constants.maxFPS;
  private int frameCounter = frameCount;
  private int timer_FPS = Constants.frameUpdateTime;
  // Colors
  private color color_background = color(180);
  // Profile
  private Profile profile;

  Global(LNZ thisInstance) {
    this.images = new Images();
    this.sounds = new Sounds(thisInstance);
    this.cursor = this.images.getImage("icons/cursor_default.png");
  }

  int frame() {
    int elapsed = millis() - this.lastFrameTime;
    this.lastFrameTime = millis();
    return elapsed;
  }

  void exit() {
    this.state = ProgramState.EXITING;
  }
}


// global options (profile independent)
class Configuration {
  private String default_profile_name = "";
  private float cursor_size = Constants.default_cursor_size;

  Configuration() {
    this.loadConfiguration();
  }

  void loadConfiguration() {
    String[] lines = loadStrings(sketchPath("data/configuration.lnz"));
    if (lines == null) {
      this.save(); // save defaults if no configuration exists
      return;
    }
    for (String line : lines) {
      String[] data = split(line, ':');
      if (data.length < 2) {
        continue;
      }
      switch(data[0]) {
        case "default_profile_name":
          this.default_profile_name = trim(data[1]);
          break;
        case "cursor_size":
          if (isFloat(trim(data[1]))) {
            this.cursor_size = toFloat(trim(data[1]));
          }
          break;
        default:
          break;
      }
    }
  }

  void defaultConfiguration() {
    this.cursor_size = Constants.default_cursor_size;
  }

  void save() {
    this.saveConfiguration();
  }
  void saveConfiguration() {
    PrintWriter file = createWriter(sketchPath("data/configuration.lnz"));
    file.println("default_profile_name: " + this.default_profile_name);
    file.println("cursor_size: " + this.cursor_size);
    file.flush();
    file.close();
  }
}
