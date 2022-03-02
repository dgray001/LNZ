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
  // FPS
  private int lastFrameTime = millis();
  private float lastFPS = Constants.maxFPS;
  private int frameCounter = frameCount;
  private int timer_FPS = Constants.frameUpdateTime;
  // Colors
  private color color_background = color(180);

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
