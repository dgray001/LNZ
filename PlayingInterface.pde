enum PlayingStatus {
  INITIAL, STARTING_NEW, LOADING_SAVED, PLAYING;
}


class PlayingInterface extends InterfaceLNZ {

  abstract class PlayingButton extends RectangleButton {
    PlayingButton() {
      super(0, 0.94 * height, 0, height - Constants.mapEditor_buttonGapSize);
      this.raised_border = true;
      this.roundness = 0;
      this.setColors(color(170), color(222, 184, 135), color(244, 164, 96), color(205, 133, 63), color(0));
      this.show_message = true;
    }
    void hover() {
      global.sounds.trigger_interface("interfaces/buttonOn2");
    }
    void dehover() {}
    void click() {
      global.sounds.trigger_interface("interfaces/buttonClick1");
    }
  }

  class PlayingButton1 extends PlayingButton {
    PlayingButton1() {
      super();
      this.message = "Abandon\nLevel";
    }
    void release() {
      if (!this.hovered) {
        return;
      }
      this.stayDehovered();
      PlayingInterface.this.form = new AbandonLevelForm();
    }
  }

  class PlayingButton2 extends PlayingButton {
    PlayingButton2() {
      super();
      this.message = "Options";
    }
    void release() {
      if (!this.hovered) {
        return;
      }
      this.stayDehovered();
      PlayingInterface.this.form = new OptionsForm();
    }
  }

  class PlayingButton3 extends PlayingButton {
    PlayingButton3() {
      super();
      this.message = "Heroes";
    }
    void release() {
      if (!this.hovered) {
        return;
      }
      this.stayDehovered();
      PlayingInterface.this.form = new HeroesForm();
    }
  }

  class PlayingButton4 extends PlayingButton {
    PlayingButton4() {
      super();
      this.message = "Main\nMenu";
    }
    void release() {
      if (!this.hovered) {
        return;
      }
      this.stayDehovered();
      PlayingInterface.this.form = new GoToMainMenuForm();
    }
  }


  class GoToMainMenuForm extends ConfirmForm {
    GoToMainMenuForm() {
      super("Main Menu", "Are you sure you want to save and exit to the main menu?");
    }
    void submit() {
      this.canceled = true;
      PlayingInterface.this.saveAndExitToMainMenu();
    }
  }

  class AbandonLevelForm extends ConfirmForm {
    AbandonLevelForm() {
      super("Abandon Level", "Are you sure you want to restart the tutorial? " +
        "Any current progress will be lost.");
    }
    void submit() {
      this.canceled = true;
      // need option to restart or actually abandon level, where actual abandon is not possible if you don't have a home base
    }
  }


  class OpenNewLevelThread extends Thread {
    private Level level;
    private Location location;
    private String curr_status = "";

    OpenNewLevelThread(Location location) {
      super("OpenNewLevelThread");
      this.location = location;
    }

    @Override
    void run() {
      this.curr_status += "Creating New Level";
      this.level = new Level("data/locations", Location.TUTORIAL);
      if (this.level.nullify) {
        this.curr_status += " -> " + global.lastErrorMessage();
        delay(2500);
        return;
      }
      this.curr_status += "\nCopying Data";
      String destination_folder = "data/profiles/" + global.profile.display_name.toLowerCase() + "/locations/";
      if (!folderExists(destination_folder)) {
        mkdir(destination_folder);
      }
      deleteFolder(destination_folder + Location.TUTORIAL.file_name());
      copyFolder("data/locations/" + Location.TUTORIAL.file_name(),
        destination_folder + Location.TUTORIAL.file_name());
      this.level.folderPath = destination_folder;
      this.level.save();
      if (this.level.nullify) {
        this.curr_status += " -> " + global.lastErrorMessage();
        delay(2500);
        return;
      }
      this.curr_status += "\nOpening Map";
      this.level.setPlayer(new Hero(HeroCode.BEN));
      if (this.level.nullify) {
        this.curr_status += " -> " + global.lastErrorMessage();
        delay(2500);
        return;
      }
      if (!global.images.loaded_map_gifs) {
        this.curr_status += "\nLoading Animations";
        global.images.loadMapGifs();
      }
    }
  }


  class OpenSavedLevelThread extends Thread {
    private Level level;
    private String curr_status = "";

    OpenSavedLevelThread() {
      super("OpenSavedLevelThread");
    }

    @Override
    void run() {
      this.curr_status += "Opening Saved Tutorial";
      String destination_folder = "data/profiles/" + global.profile.display_name.toLowerCase() + "/locations/";
      this.level = new Level(destination_folder, Location.TUTORIAL);
      if (this.level.nullify) {
        this.curr_status += " -> " + global.lastErrorMessage();
        delay(2500);
        return;
      }
      this.curr_status += "\nOpening Map";
      this.level.openCurrMap();
      if (this.level.nullify) {
        this.curr_status += " -> " + global.lastErrorMessage();
        delay(2500);
        return;
      }
      if (!global.images.loaded_map_gifs) {
        this.curr_status += "\nLoading Animations";
        global.images.loadMapGifs();
      }
    }
  }


  private PlayingButton[] buttons = new PlayingButton[4];
  private Panel leftPanel = new Panel(LEFT, Constants.mapEditor_panelMinWidth,
    Constants.mapEditor_panelMaxWidth, Constants.mapEditor_panelStartWidth);
  private Panel rightPanel = new Panel(RIGHT, Constants.mapEditor_panelMinWidth,
    Constants.mapEditor_panelMaxWidth, Constants.mapEditor_panelStartWidth);

  private Level level = null;
  private PlayingStatus status = PlayingStatus.INITIAL;

  private OpenNewLevelThread newLevelThread = null;
  private OpenSavedLevelThread savedLevelThread = null;


  PlayingInterface() {
    this.buttons[0] = new PlayingButton1();
    this.buttons[1] = new PlayingButton2();
    this.buttons[2] = new PlayingButton3();
    this.buttons[3] = new PlayingButton4();
    this.leftPanel.addIcon(global.images.getImage("icons/triangle_gray.png"));
    this.rightPanel.addIcon(global.images.getImage("icons/triangle_gray.png"));
    this.leftPanel.color_background = global.color_panelBackground;
    this.rightPanel.color_background = global.color_panelBackground;
    this.resizeButtons();
  }


  void resizeButtons() {
    float buttonSize = (this.rightPanel.size_curr - 5 * Constants.mapEditor_buttonGapSize) / 4.0;
    float xi = width - this.rightPanel.size_curr + Constants.mapEditor_buttonGapSize;
    this.buttons[0].setXLocation(xi, xi + buttonSize);
    xi += buttonSize + Constants.mapEditor_buttonGapSize;
    this.buttons[1].setXLocation(xi, xi + buttonSize);
    xi += buttonSize + Constants.mapEditor_buttonGapSize;
    this.buttons[2].setXLocation(xi, xi + buttonSize);
    xi += buttonSize + Constants.mapEditor_buttonGapSize;
    this.buttons[3].setXLocation(xi, xi + buttonSize);
  }


  void checkLevelSave() {
    // check location of currHero from profile
  }

  void startNewLevel() {
    // from location of currHero from profile
  }

  void completedLevel(int completion_code) {
    global.log("Completed level with code " + completion_code + ".");
    switch(completion_code) {
      case 0: // default
        this.level = null;
        // delete saved folder deleteFolder(this.destination_folder() + Location.TUTORIAL.file_name());
        // transition into next level
        break;
      default:
        global.errorMessage("ERROR: Completion code " + completion_code + " not recognized for level.");
        break;
    }
  }


  Hero getCurrentHeroIfExists() {
    if (this.level != null) {
      return this.level.player;
    }
    return null;
  }

  void saveLevel() {
    if (this.level == null) {
      return;
    }
    this.level.save();
    // save profile heroes
  }

  void saveAndExitToMainMenu() {
    this.saveLevel();
    this.level = null;
    global.state = ProgramState.ENTERING_MAINMENU;
  }

  void loseFocus() {
    if (this.level != null) {
      this.level.loseFocus();
    }
  }

  void gainFocus() {
    if (this.level != null) {
      this.level.gainFocus();
    }
  }

  void restartTimers() {
    if (this.level != null) {
      this.level.restartTimers();
    }
  }

  void update(int millis) {
    boolean refreshLevelLocation = false;
    switch(this.status) {
      case INITIAL:
        rectMode(CORNERS);
        noStroke();
        fill(60);
        rect(this.leftPanel.size, 0, width - this.rightPanel.size, height);
        break;
      case STARTING_NEW:
        if (this.newLevelThread.isAlive()) {
          fill(global.color_mapBorder);
          noStroke();
          rectMode(CORNERS);
          rect(this.leftPanel.size, 0, width - this.rightPanel.size, height);
          fill(global.color_loadingScreenBackground);
          rect(this.leftPanel.size + Constants.map_borderSize, Constants.map_borderSize,
              width - this.rightPanel.size - Constants.map_borderSize, height - Constants.map_borderSize);
          fill(0);
          textSize(24);
          textAlign(LEFT, TOP);
          text(this.newLevelThread.curr_status + " ...", this.leftPanel.size +
            Constants.map_borderSize + 30, Constants.map_borderSize + 30);
          imageMode(CENTER);
          int frame = int(floor(Constants.gif_loading_frames * (float(millis %
            Constants.gif_loading_time) / (1 + Constants.gif_loading_time))));
          image(global.images.getImage("gifs/loading/" + frame + ".png"), 0.5 * width, 0.5 * height, 250, 250);
        }
        else {
          if (this.newLevelThread.level == null || this.newLevelThread.level.nullify) {
            this.level = null;
            this.status = PlayingStatus.INITIAL;
          }
          else {
            this.level = this.newLevelThread.level;
            this.level.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
            this.level.restartTimers();
            this.status = PlayingStatus.PLAYING;
            //this.saveTutorial();
          }
          this.newLevelThread = null;
          return;
        }
        break;
      case LOADING_SAVED:
        if (this.savedLevelThread.isAlive()) {
          fill(global.color_mapBorder);
          noStroke();
          rectMode(CORNERS);
          rect(this.leftPanel.size, 0, width - this.rightPanel.size, height);
          fill(global.color_loadingScreenBackground);
          rect(this.leftPanel.size + Constants.map_borderSize, Constants.map_borderSize,
              width - this.rightPanel.size - Constants.map_borderSize, height - Constants.map_borderSize);
          fill(0);
          textSize(24);
          textAlign(LEFT, TOP);
          text(this.savedLevelThread.curr_status + " ...", this.leftPanel.size +
            Constants.map_borderSize + 30, Constants.map_borderSize + 30);
          imageMode(CENTER);
          int frame = int(floor(Constants.gif_loading_frames * (float(millis %
            Constants.gif_loading_time) / (1 + Constants.gif_loading_time))));
          image(global.images.getImage("gifs/loading/" + frame + ".png"), 0.5 * width, 0.5 * height, 250, 250);
        }
        else {
          if (this.savedLevelThread.level == null || this.savedLevelThread.level.nullify) {
            this.level = null;
            this.status = PlayingStatus.INITIAL;
          }
          else {
            this.level = this.savedLevelThread.level;
            this.level.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
            this.status = PlayingStatus.PLAYING;
          }
          this.savedLevelThread = null;
          return;
        }
        break;
      case PLAYING:
        if (this.level != null) {
          this.level.update(millis);
          if (this.leftPanel.collapsing || this.rightPanel.collapsing) {
            refreshLevelLocation = true;
          }
          if (this.level.completed) {
            this.completedLevel(this.level.completion_code);
          }
        }
        break;
      default:
        global.errorMessage("Tutorial status " + this.status + " not recognized.");
        break;
    }
    this.leftPanel.update(millis);
    this.rightPanel.update(millis);
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (PlayingButton button : this.buttons) {
        button.update(millis);
      }
      if (this.level != null) {
        this.level.drawRightPanel(millis);
      }
    }
    if (this.leftPanel.open && !this.leftPanel.collapsing) {
      if (this.level != null) {
        this.level.drawLeftPanel(millis);
      }
    }
    if (refreshLevelLocation) {
      if (this.level != null) {
        this.level.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
      }
    }
  }

  void showNerdStats() {
    if (this.level != null) {
      this.level.displayNerdStats();
    }
    else {
      fill(255);
      textSize(14);
      textAlign(LEFT, TOP);
      float y_stats = 1;
      float line_height = textAscent() + textDescent() + 2;
      text("FPS: " + int(global.lastFPS), 1, y_stats);
    }
  }

  void mouseMove(float mX, float mY) {
    boolean refreshMapLocation = false;
    // level mouse move
    if (this.level != null) {
      this.level.mouseMove(mX, mY);
      if (this.leftPanel.clicked || this.rightPanel.clicked) {
        refreshMapLocation = true;
      }
    }
    // left panel mouse move
    this.leftPanel.mouseMove(mX, mY);
    if (this.leftPanel.open && !this.leftPanel.collapsing) {
      if (this.level != null) {
        if (this.level.leftPanelElementsHovered()) {
          this.leftPanel.hovered = false;
        }
      }
      else if (this.level != null) {
        if (this.level.leftPanelElementsHovered()) {
          this.leftPanel.hovered = false;
        }
      }
    }
    // right panel mouse move
    this.rightPanel.mouseMove(mX, mY);
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (PlayingButton button : this.buttons) {
        button.mouseMove(mX, mY);
      }
    }
    // refresh map location
    if (refreshMapLocation) {
      if (this.level != null) {
        this.level.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
      }
    }
    // cursor icon resolution
    if (this.leftPanel.clicked || this.rightPanel.clicked) {
      this.resizeButtons();
      global.setCursor("icons/cursor_resizeh_white.png");
    }
    else if (this.leftPanel.hovered || this.rightPanel.hovered) {
      global.setCursor("icons/cursor_resizeh.png");
    }
    else {
      global.defaultCursor("icons/cursor_resizeh_white.png", "icons/cursor_resizeh.png");
    }
  }

  void mousePress() {
    if (this.level != null) {
      this.level.mousePress();
    }
    this.leftPanel.mousePress();
    this.rightPanel.mousePress();
    if (this.leftPanel.clicked || this.rightPanel.clicked) {
      global.setCursor("icons/cursor_resizeh_white.png");
    }
    else {
      global.defaultCursor("icons/cursor_resizeh_white.png");
    }
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (PlayingButton button : this.buttons) {
        button.mousePress();
      }
    }
  }

  void mouseRelease(float mX, float mY) {
    if (this.level != null) {
      this.level.mouseRelease(mX, mY);
    }
    this.leftPanel.mouseRelease(mX, mY);
    this.rightPanel.mouseRelease(mX, mY);
    if (this.leftPanel.hovered || this.rightPanel.hovered) {
      global.setCursor("icons/cursor_resizeh.png");
    }
    else {
      global.defaultCursor("icons/cursor_resizeh.png");
    }
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (PlayingButton button : this.buttons) {
        button.mouseRelease(mX, mY);
      }
    }
  }

  void scroll(int amount) {
    if (this.level != null) {
      this.level.scroll(amount);
    }
  }

  void keyPress() {
    if (this.level != null) {
      this.level.keyPress();
    }
  }

  void openEscForm() {
    this.form = new EscForm();
  }

  void keyRelease() {
    if (this.level != null) {
      this.level.keyRelease();
    }
  }
}
