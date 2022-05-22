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
      Hero h = PlayingInterface.this.getCurrentHeroIfExists();
      if (h != null) {
        PlayingInterface.this.form = new AbandonLevelForm(h);
      }
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


  abstract class PlayingForm extends FormLNZ {
    PlayingForm(String title, float formWidth, float formHeight) {
      super(0.5 * (width - formWidth), 0.5 * (height - formHeight),
        0.5 * (width + formWidth), 0.5 * (height + formHeight));
      this.setTitleText(title);
      this.setTitleSize(18);
      this.color_background = color(180, 250, 180);
      this.color_header = color(30, 170, 30);
    }
  }


  class ConfirmStartLevelForm extends PlayingForm {
    ConfirmStartLevelForm(Hero hero) {
      super("Start Level: " + hero.location.display_name(), 550, 350);

      MessageFormField message1 = new MessageFormField("Begin the following level?");
      MessageFormField message2 = new MessageFormField("Hero: " + hero.display_name());
      message2.text_color = color(120, 30, 120);
      MessageFormField message3 = new MessageFormField("Location: " + hero.location.display_name());
      message3.text_color = color(120, 30, 120);
      SubmitCancelFormField submit = new SubmitCancelFormField("Begin Level", "Abandon Level");
      submit.button1.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      submit.button2.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      ButtonFormField switch_hero = new ButtonFormField("Switch Hero");
      switch_hero.button.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));

      this.addField(new SpacerFormField(10));
      this.addField(message1);
      this.addField(message2);
      this.addField(message3);
      this.addField(new SpacerFormField(10));
      this.addField(submit);
      this.addField(switch_hero);
    }

    @Override
    void cancel() {
      // attempt to return to homebase (if exists, if not hero selector)
    }

    void submit() {
      PlayingInterface.this.startOrRestartLevel();
      this.canceled = true;
    }

    @Override
    void buttonPress(int i) {
      switch(i) {
        case 6: // switch hero
          println("Switch Hero Form");
          break;
        default:
          break;
      }
    }
  }


  class ConfirmContinueLevelForm extends PlayingForm {
    ConfirmContinueLevelForm(Hero hero) {
      super("Continue Level: " + hero.location.display_name(), 550, 600);

      MessageFormField message1 = new MessageFormField("Continue the following level?");
      MessageFormField message2 = new MessageFormField("Hero: " + hero.display_name());
      message2.text_color = color(120, 30, 120);
      MessageFormField message3 = new MessageFormField("Location: " + hero.location.display_name());
      message3.text_color = color(120, 30, 120);
      SubmitCancelFormField submit = new SubmitCancelFormField("Continue Level", "Abandon Level");
      submit.button1.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      submit.button2.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      ButtonFormField switch_hero = new ButtonFormField("Switch Hero");
      switch_hero.button.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));

      this.addField(new SpacerFormField(10));
      this.addField(message1);
      this.addField(message2);
      this.addField(message3);
      this.addField(new SpacerFormField(10));
      this.addField(submit);
      this.addField(switch_hero);
    }

    @Override
    void cancel() {
      // attempt to return to homebase (if exists, if not restart level)
    }

    void submit() {
      PlayingInterface.this.continueLevel();
      this.canceled = true;
    }

    @Override
    void buttonPress(int i) {
      switch(i) {
        case 6: // switch hero
          println("Switch Hero Form");
          break;
        default:
          break;
      }
    }
  }


  class AbandonLevelForm extends PlayingForm {
    AbandonLevelForm(Hero hero) {
      super("Abandon Level: " + hero.location.display_name(), 550, 600);
    }
    void submit() {
      this.canceled = true;
      // need option to restart or actually abandon level, where actual abandon is not possible if you don't have a home base
    }
  }


  class OpenNewLevelThread extends Thread {
    private Level level = null;
    private Hero hero = null;
    private String curr_status = "";

    OpenNewLevelThread(Hero hero) {
      super("OpenNewLevelThread");
      this.hero = hero;
    }

    @Override
    void run() {
      this.curr_status += "Gathering Level Data";
      if (this.hero == null) {
        this.curr_status += " -> No hero found.";
        delay(2500);
        return;
      }
      if (this.hero.location == null || this.hero.location == Location.ERROR) {
        this.curr_status += " -> No hero location found.";
        delay(2500);
        return;
      }
      this.level = new Level("data/locations", this.hero.location);
      if (this.level.nullify) {
        this.curr_status += " -> " + global.lastErrorMessage();
        delay(2500);
        return;
      }
      this.curr_status += "\nCopying Data";
      mkdir(PlayingInterface.this.savePath);
      String destination_folder = PlayingInterface.this.savePath + this.hero.location.file_name();
      deleteFolder(destination_folder);
      copyFolder("data/locations/" + this.hero.location.file_name(), destination_folder);
      this.level.folderPath = PlayingInterface.this.savePath;
      this.level.save();
      if (this.level.nullify) {
        this.curr_status += " -> " + global.lastErrorMessage();
        delay(2500);
        return;
      }
      this.curr_status += "\nOpening Map";
      this.level.setPlayer(this.hero);
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
    private Level level = null;
    private Hero hero = null;
    private String curr_status = "";

    OpenSavedLevelThread(Hero hero) {
      super("OpenSavedLevelThread");
      this.hero = hero;
    }

    @Override
    void run() {
      this.curr_status += "Opening Saved Level";
      if (this.hero == null) {
        this.curr_status += " -> No hero found.";
        delay(2500);
        return;
      }
      if (this.hero.location == null || this.hero.location == Location.ERROR) {
        this.curr_status += " -> No hero location found.";
        delay(2500);
        return;
      }
      String destination_folder = "data/profiles/" + global.profile.display_name.toLowerCase() + "/locations/";
      this.level = new Level(destination_folder, this.hero.location);
      if (this.level.nullify) {
        this.curr_status += " -> " + global.lastErrorMessage();
        delay(2500);
        return;
      }
      curr_status += "\nOpening Map";
      this.level.openCurrMap();
      this.level.addPlayer(this.hero);
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

  private String savePath = "data/profiles/" + global.profile.display_name.toLowerCase() + "/locations/";
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
    if (global.profile.curr_hero == null || global.profile.curr_hero == HeroCode.ERROR) {
      global.errorMessage("ERROR: Profile has no current hero.");
      return;
    }
    Hero curr_hero = global.profile.heroes.get(global.profile.curr_hero);
    if (curr_hero == null) {
      global.errorMessage("ERROR: Profile missing curr hero " + global.profile.curr_hero + ".");
      return;
    }
    if (curr_hero.location == null || curr_hero.location == Location.ERROR) {
      global.errorMessage("ERROR: Hero " + curr_hero.display_name() + " missing location data.");
      return;
    }
    if (folderExists(this.savePath + curr_hero.location.file_name())) {
      this.form = new ConfirmContinueLevelForm(curr_hero);
    }
    else {
      this.form = new ConfirmStartLevelForm(curr_hero);
    }
  }

  void startOrRestartLevel() {
    if (this.level != null) {
      global.errorMessage("ERROR: Trying to open level save when current level not null.");
      return;
    }
    if (this.status != PlayingStatus.INITIAL) {
      global.errorMessage("ERROR: Trying to open level save when current status is " + this.status + ".");
      return;
    }
    if (global.profile.curr_hero == null || global.profile.curr_hero == HeroCode.ERROR) {
      global.errorMessage("ERROR: Profile has no current hero.");
      return;
    }
    Hero curr_hero = global.profile.heroes.get(global.profile.curr_hero);
    if (curr_hero == null) {
      global.errorMessage("ERROR: Profile missing curr hero " + global.profile.curr_hero + ".");
      return;
    }
    if (curr_hero.location == null || curr_hero.location == Location.ERROR) {
      global.errorMessage("ERROR: Hero " + curr_hero.display_name() + " missing location data.");
      return;
    }
    status = PlayingStatus.STARTING_NEW;
    this.newLevelThread = new OpenNewLevelThread(curr_hero);
    this.newLevelThread.start();
  }

  void continueLevel() {
    if (this.level != null) {
      global.errorMessage("ERROR: Trying to open level save when current level not null.");
      return;
    }
    if (this.status != PlayingStatus.INITIAL) {
      global.errorMessage("ERROR: Trying to open level save when current status is " + this.status + ".");
      return;
    }
    if (global.profile.curr_hero == null || global.profile.curr_hero == HeroCode.ERROR) {
      global.errorMessage("ERROR: Profile has no current hero.");
      return;
    }
    Hero curr_hero = global.profile.heroes.get(global.profile.curr_hero);
    if (curr_hero == null) {
      global.errorMessage("ERROR: Profile missing curr hero " + global.profile.curr_hero + ".");
      return;
    }
    if (curr_hero.location == null || curr_hero.location == Location.ERROR) {
      global.errorMessage("ERROR: Hero " + curr_hero.display_name() + " missing location data.");
      return;
    }
    if (!folderExists(this.savePath + curr_hero.location.file_name())) {
      global.errorMessage("ERROR: No save folder at " + (this.savePath + curr_hero.location.file_name()) + ".");
      return;
    }
    status = PlayingStatus.LOADING_SAVED;
    this.savedLevelThread = new OpenSavedLevelThread(curr_hero);
    this.savedLevelThread.start();
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
    global.profile.saveHeroesFile();
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
          if (this.savedLevelThread.level == null || this.savedLevelThread.level.nullify ||
            this.savedLevelThread.level.currMap == null || this.savedLevelThread.level.currMap.nullify) {
            this.level = null;
            this.status = PlayingStatus.INITIAL;
          }
          else {
            this.level = this.savedLevelThread.level;
            this.level.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
            this.level.restartTimers();
            this.level.currMap.addHeaderMessage(GameMapCode.display_name(this.level.currMap.code));
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
        else {
          global.errorMessage("ERROR: In playing status but no level to update.");
          this.status = PlayingStatus.INITIAL;
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
    if (this.status == PlayingStatus.INITIAL) {
      this.checkLevelSave();
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
      global.defaultCursor("icons/cursor_resizeh.png", "icons/cursor_resizeh_white.png");
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
