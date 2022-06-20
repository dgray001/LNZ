enum MinigameStatus {
  INITIAL, LAUNCHING, PLAYING;
}

class MinigameInterface extends InterfaceLNZ {

  abstract class MinigameButton extends RectangleButton {
    MinigameButton() {
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

  class MinigameButton1 extends MinigameButton {
    MinigameButton1() {
      super();
      this.message = "";
    }
    void release() {
      if (!this.hovered) {
        return;
      }
      this.stayDehovered();
    }
  }

  class MinigameButton2 extends MinigameButton {
    MinigameButton2() {
      super();
      this.message = "";
    }
    void release() {
      if (!this.hovered) {
        return;
      }
      this.stayDehovered();
    }
  }

  class MinigameButton3 extends MinigameButton {
    MinigameButton3() {
      super();
      this.message = "";
    }
    void release() {
      if (!this.hovered) {
        return;
      }
      this.stayDehovered();
    }
  }

  class MinigameButton4 extends MinigameButton {
    MinigameButton4() {
      super();
      this.message = "Main\nMenu";
    }
    void release() {
      if (!this.hovered) {
        return;
      }
      this.stayDehovered();
      MinigameInterface.this.form = new GoToMainMenuForm();
    }
  }


  class GoToMainMenuForm extends ConfirmForm {
    GoToMainMenuForm() {
      super("Main Menu", "Are you sure you want to exit to the main menu?");
    }
    void submit() {
      this.canceled = true;
      MinigameInterface.this.saveAndExitToMainMenu();
    }
  }


  private MinigameButton[] buttons = new MinigameButton[4];
  private Panel leftPanel = new Panel(LEFT, Constants.mapEditor_panelMinWidth,
    Constants.mapEditor_panelMaxWidth, Constants.mapEditor_panelStartWidth);
  private Panel rightPanel = new Panel(RIGHT, Constants.mapEditor_panelMinWidth,
    Constants.mapEditor_panelMaxWidth, Constants.mapEditor_panelStartWidth);

  private Minigame minigame = null;
  private MinigameStatus status = MinigameStatus.INITIAL;
  private boolean return_to_playing = false;
  private int last_update_time = millis();


  MinigameInterface() {
    this.buttons[0] = new MinigameButton1();
    this.buttons[1] = new MinigameButton2();
    this.buttons[2] = new MinigameButton3();
    this.buttons[3] = new MinigameButton4();
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


  void completedMinigame() {
    if (this.minigame == null || this.status != MinigameStatus.PLAYING) {
      global.errorMessage("ERROR: Can't complete minigame when not playing one.");
      return;
    }
    global.log("Completed minigame " + this.minigame.displayName() + ".");
    if (this.return_to_playing) {
      global.state = ProgramState.ENTERING_PLAYING;
    }
    this.status = MinigameStatus.INITIAL;
    this.minigame = null;
  }


  Hero getCurrentHeroIfExists() {
    return null;
  }

  void saveAndExitToMainMenu() {
    this.minigame = null;
    this.status = MinigameStatus.INITIAL;
    global.state = ProgramState.ENTERING_MAINMENU;
  }

  void loseFocus() {
    if (this.minigame != null) {
      this.minigame.loseFocus();
    }
  }

  void gainFocus() {
    if (this.minigame != null) {
      this.minigame.gainFocus();
    }
  }

  void restartTimers() {
    if (this.minigame != null) {
      this.minigame.restartTimers();
    }
  }

  void update(int millis) {
    int time_elapsed = millis - this.last_update_time;
    boolean refreshLevelLocation = false;
    switch(this.status) {
      case INITIAL:
        rectMode(CORNERS);
        noStroke();
        fill(60);
        rect(this.leftPanel.size, 0, width - this.rightPanel.size, height);
        break;
      case LAUNCHING:
        break;
      case PLAYING:
        if (this.minigame != null) {
          this.minigame.update(time_elapsed);
          if (this.leftPanel.collapsing || this.rightPanel.collapsing) {
            refreshLevelLocation = true;
          }
          if (this.minigame.completed) {
            this.completedMinigame();
          }
        }
        else {
          global.errorMessage("ERROR: In playing status but no level to update.");
          this.status = MinigameStatus.INITIAL;
        }
        break;
      default:
        global.errorMessage("ERROR: Minigame status " + this.status + " not recognized.");
        break;
    }
    this.leftPanel.update(millis);
    this.rightPanel.update(millis);
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (MinigameButton button : this.buttons) {
        button.update(millis);
      }
      if (this.minigame != null) {
        this.minigame.drawRightPanel(time_elapsed);
      }
    }
    if (this.leftPanel.open && !this.leftPanel.collapsing) {
      if (this.minigame != null) {
        this.minigame.drawLeftPanel(time_elapsed);
      }
    }
    if (refreshLevelLocation) {
      if (this.minigame != null) {
        this.minigame.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
      }
    }
    this.last_update_time = millis;
  }

  void showNerdStats() {
    if (this.minigame != null) {
      this.minigame.displayNerdStats();
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
    if (this.minigame != null) {
      this.minigame.mouseMove(mX, mY);
      if (this.leftPanel.clicked || this.rightPanel.clicked) {
        refreshMapLocation = true;
      }
    }
    // left panel mouse move
    this.leftPanel.mouseMove(mX, mY);
    if (this.leftPanel.open && !this.leftPanel.collapsing) {
      if (this.minigame != null) {
        if (this.minigame.leftPanelElementsHovered()) {
          this.leftPanel.hovered = false;
        }
      }
    }
    // right panel mouse move
    this.rightPanel.mouseMove(mX, mY);
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (MinigameButton button : this.buttons) {
        button.mouseMove(mX, mY);
      }
    }
    // refresh map location
    if (refreshMapLocation) {
      if (this.minigame != null) {
        this.minigame.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
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
    if (this.minigame != null) {
      this.minigame.mousePress();
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
      for (MinigameButton button : this.buttons) {
        button.mousePress();
      }
    }
  }

  void mouseRelease(float mX, float mY) {
    if (this.minigame != null) {
      this.minigame.mouseRelease(mX, mY);
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
      for (MinigameButton button : this.buttons) {
        button.mouseRelease(mX, mY);
      }
    }
  }

  void scroll(int amount) {
    if (this.minigame != null) {
      this.minigame.scroll(amount);
    }
  }

  void keyPress() {
    if (this.minigame != null) {
      this.minigame.keyPress();
    }
  }

  void openEscForm() {
    if (this.minigame != null) {
      this.form = this.minigame.getEscForm();
    }
  }

  void keyRelease() {
    if (this.minigame != null) {
      this.minigame.keyRelease();
    }
  }
}
