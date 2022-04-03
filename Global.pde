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
  private boolean holding_shift = false;
  private Deque<String> error_messages = new ArrayDeque<String>();
  private PrintWriter log;
  // FPS
  private int lastFrameTime = millis();
  private float lastFPS = Constants.maxFPS;
  private int frameCounter = frameCount;
  private int timer_FPS = Constants.frameUpdateTime;
  // Colors
  private color color_background = color(180);
  private color color_nameDisplayed_background = color(100, 180);
  private color color_nameDisplayed_text = color(255);
  private color color_panelBackground = color(160, 82, 45);
  private color color_loadingScreenBackground = color(222, 185, 140);
  private color color_mapBorder = color(20);
  private color color_mapBackground = color(20);
  // Profile
  private Profile profile;

  Global(LNZ thisInstance) {
    this.images = new Images();
    this.sounds = new Sounds(thisInstance);
    this.cursor = this.images.getImage("icons/cursor_default.png");
    if (!folderExists("data/logs")) {
      mkdir("data/logs");
    }
    this.log = createWriter(sketchPath("data/logs/curr_log.lnz"));
  }

  int frame() {
    int elapsed = millis() - this.lastFrameTime;
    this.lastFrameTime = millis();
    return elapsed;
  }

  void log(String message) {
    this.log.println(message);
    println(message);
  }

  String lastErrorMessage() {
    if (this.error_messages.peek() == null) {
      return "None";
    }
    return this.error_messages.peek();
  }

  void errorMessage(String message) {
    this.error_messages.push(message);
    this.log(message);
    if (this.menu != null) {
      this.menu.throwError(message);
    }
  }

  void keyPressFX2D() {
    if (key == CODED) {
      switch(keyCode) {
        case SHIFT:
          this.holding_shift = true;
          break;
      }
    }
    else {
      this.fixKeyFX2D();
    }
  }
  void keyReleaseFX2D() {
    if (key == CODED) {
      switch(keyCode) {
        case SHIFT:
          this.holding_shift = false;
          break;
      }
    }
    else {
      this.fixKeyFX2D();
    }
  }
  void fixKeyFX2D() {
    if (!this.holding_shift) {
      if (key >= 'A' && key <= 'Z') {
        key += 32;
      }
      else {
        switch(key) {
          case 192:
            key = '`';
            break;
          case 222:
            key = '\'';
            break;
        }
      }
    }
    else {
      switch(key) {
        case '1':
          key = '!';
          break;
        case '2':
          key = '@';
          break;
        case '3':
          key = '#';
          break;
        case '4':
          key = '$';
          break;
        case '5':
          key = '%';
          break;
        case '6':
          key = '^';
          break;
        case '7':
          key = '&';
          break;
        case '8':
          key = '*';
          break;
        case '9':
          key = '(';
          break;
        case '0':
          key = ')';
          break;
        case '-':
          key = '_';
          break;
        case '=':
          key = '+';
          break;
        case '[':
          key = '{';
          break;
        case ']':
          key = '}';
          break;
        case '\\':
          key = '|';
          break;
        case ';':
          key = ':';
          break;
        case '\'':
          key = '\"';
          break;
        case ',':
          key = '<';
          break;
        case '.':
          key = '>';
          break;
        case '/':
          key = '?';
          break;
        case 192:
          key = '~';
          break;
        case 222:
          key = '\"';
          break;
      }
    }
  }

  void exitDelay() {
    this.sounds.stop_background();
    this.log("Exiting normally.");
    this.log.flush();
    this.log.close();
    this.state = ProgramState.EXITING;
  }

  void exitImmediately() {
    this.exitDelay();
    exit();
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
