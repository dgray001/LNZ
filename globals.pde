enum ProgramState {
  INITIAL_INTERFACE, EXITING, ENTERING_MAINMENU, MAINMENU_INTERFACE;
}


class Global {
  // Program
  private InterfaceLNZ menu;
  private ProgramState state = ProgramState.INITIAL_INTERFACE;
  private int timer_exiting = Constants.exit_delay;
  private Images images;
  private Sounds sounds;
  private Options options = new Options();
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


class Options { // global options (profile independent)
  private String default_profile_name = "";

  Options() {
    this.loadOptions();
  }

  void loadOptions() {
    String[] lines = loadStrings(sketchPath("data/options.lnz"));
    if (lines == null) {
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
        default:
          break;
      }
    }
  }

  void save() {
    this.saveOptions();
  }
  void saveOptions() {
    PrintWriter file = createWriter(sketchPath("data/options.lnz"));
    file.println("default_profile_name: " + this.default_profile_name);
    file.flush();
    file.close();
  }
}
