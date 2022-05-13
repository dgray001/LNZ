enum TutorialStatus {
  INITIAL, STARTING_NEW, LOADING_SAVED, PLAYING;
}


class TutorialInterface extends InterfaceLNZ {

  abstract class TutorialButton extends RectangleButton {
    TutorialButton() {
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

  class TutorialButton1 extends TutorialButton {
    TutorialButton1() {
      super();
      this.message = "Restart\nTutorial";
    }
    void release() {
      this.stayDehovered();
      // restart tutorial
    }
  }

  class TutorialButton2 extends TutorialButton {
    TutorialButton2() {
      super();
      this.message = "Options";
    }
    void release() {
      this.stayDehovered();
      TutorialInterface.this.form = new OptionsForm();
    }
  }

  class TutorialButton3 extends TutorialButton {
    TutorialButton3() {
      super();
      this.message = "Achievements";
      this.text_size = 12;
    }
    void release() {
      this.stayDehovered();
      TutorialInterface.this.form = new AchievementsForm();
    }
  }

  class TutorialButton4 extends TutorialButton {
    TutorialButton4() {
      super();
      this.message = "Main\nMenu";
    }
    void release() {
      this.stayDehovered();
      TutorialInterface.this.form = new GoToMainMenuForm();
    }
  }

  class TutorialButton5 extends TutorialButton {
    TutorialButton5() {
      super();
      this.setLocation(0, 0.9 * height + Constants.mapEditor_buttonGapSize,
        0, 0.94 * height - Constants.mapEditor_buttonGapSize);
      this.message = "Help";
    }
    void release() {
      this.stayDehovered();
      // help form (help depends on stage in tutorial)
    }
  }


  class GoToMainMenuForm extends ConfirmForm {
    GoToMainMenuForm() {
      super("Main Menu", "Are you sure you want to save and exit to the main menu?");
    }
    void submit() {
      this.canceled = true;
      TutorialInterface.this.saveAndExitToMainMenu();
    }
  }


  class OpenNewTutorialThread extends Thread {

    OpenNewTutorialThread() {
      super("OpenNewTutorialThread");
    }

    @Override
    void run() {
    }
  }


  class OpenSavedTutorialThread extends Thread {

    OpenSavedTutorialThread() {
      super("OpenSavedTutorialThread");
    }

    @Override
    void run() {
    }
  }


  private TutorialButton[] buttons = new TutorialButton[5];
  private Panel leftPanel = new Panel(LEFT, Constants.mapEditor_panelMinWidth,
    Constants.mapEditor_panelMaxWidth, Constants.mapEditor_panelStartWidth);
  private Panel rightPanel = new Panel(RIGHT, Constants.mapEditor_panelMinWidth,
    Constants.mapEditor_panelMaxWidth, Constants.mapEditor_panelStartWidth);

  private TutorialStatus status = TutorialStatus.INITIAL;
  private Level tutorial = null;

  private OpenNewTutorialThread newTutorialThread = null;
  private OpenSavedTutorialThread savedTutorialThread = null;


  TutorialInterface() {
    this.buttons[0] = new TutorialButton1();
    this.buttons[1] = new TutorialButton2();
    this.buttons[2] = new TutorialButton3();
    this.buttons[3] = new TutorialButton4();
    this.buttons[4] = new TutorialButton5();
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
    this.buttons[4].setXLocation(xi, xi + buttonSize);
  }


  Hero getCurrentHeroIfExists() {
    if (this.tutorial != null) {
      return this.tutorial.player;
    }
    return null;
  }

  void saveAndExitToMainMenu() {
    // save tutorial
    this.tutorial = null;
    global.state = ProgramState.ENTERING_MAINMENU;
  }

  void loseFocus() {
    if (this.tutorial != null) {
      this.tutorial.loseFocus();
    }
  }

  void gainFocus() {
    if (this.tutorial != null) {
      this.tutorial.gainFocus();
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
        break;
      case LOADING_SAVED:
        break;
      case PLAYING:
        if (this.tutorial != null) {
          this.tutorial.update(millis);
          if (this.leftPanel.collapsing || this.rightPanel.collapsing) {
            refreshLevelLocation = true;
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
      for (TutorialButton button : this.buttons) {
        button.update(millis);
      }
      if (this.tutorial != null) {
        this.tutorial.drawRightPanel(millis);
      }
    }
    if (this.leftPanel.open && !this.leftPanel.collapsing) {
      if (this.tutorial != null) {
        this.tutorial.drawLeftPanel(millis);
      }
    }
    if (refreshLevelLocation) {
      if (this.tutorial != null) {
        this.tutorial.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
      }
    }
  }

  void showNerdStats() {
    if (this.tutorial != null) {
      this.tutorial.displayNerdStats();
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
    if (this.tutorial != null) {
      this.tutorial.mouseMove(mX, mY);
      if (this.leftPanel.clicked || this.rightPanel.clicked) {
        refreshMapLocation = true;
      }
    }
    // left panel mouse move
    this.leftPanel.mouseMove(mX, mY);
    if (this.leftPanel.open && !this.leftPanel.collapsing) {
      if (this.tutorial != null) {
        if (this.tutorial.leftPanelElementsHovered()) {
          this.leftPanel.hovered = false;
        }
      }
      else if (this.tutorial != null) {
        if (this.tutorial.leftPanelElementsHovered()) {
          this.leftPanel.hovered = false;
        }
      }
    }
    // right panel mouse move
    this.rightPanel.mouseMove(mX, mY);
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (TutorialButton button : this.buttons) {
        button.mouseMove(mX, mY);
      }
    }
    // refresh map location
    if (refreshMapLocation) {
      if (this.tutorial != null) {
        this.tutorial.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
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
    if (this.tutorial != null) {
      this.tutorial.mousePress();
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
      for (TutorialButton button : this.buttons) {
        button.mousePress();
      }
    }
  }

  void mouseRelease(float mX, float mY) {
    if (this.tutorial != null) {
      this.tutorial.mouseRelease(mX, mY);
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
      for (TutorialButton button : this.buttons) {
        button.mouseRelease(mX, mY);
      }
    }
  }

  void scroll(int amount) {
    if (this.tutorial != null) {
      this.tutorial.scroll(amount);
    }
  }

  void keyPress() {
    if (this.tutorial != null) {
      this.tutorial.keyPress();
    }
  }

  void openEscForm() {
    this.form = new EscForm();
  }

  void keyRelease() {
    if (this.tutorial != null) {
      this.tutorial.keyRelease();
    }
  }
}
