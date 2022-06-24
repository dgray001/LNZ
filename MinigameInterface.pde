enum MinigameStatus {
  INITIAL, LAUNCHING, PLAYING;
}

class MinigameInterface extends InterfaceLNZ {

  abstract class MinigameButton extends RectangleButton {
    MinigameButton() {
      super(0.95 * width, 0, width - Constants.mapEditor_buttonGapSize, 0);
      this.raised_border = true;
      this.roundness = 0;
      this.setColors(color(170), color(90, 140, 155), color(110, 170, 195), color(80, 130, 150), color(0));
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


  class MinigameChooser {
    class MinigameChooserButton extends ImageButton {
      MinigameChooserButton(MinigameName minigame) {
        super(global.images.getImage(minigame.imagePath()), 0, 0, 0, 0);
      }

      void hover() {}
      void dehover() {}
      void click() {}
      void release() {}
    }

    private ArrayList<MinigameChooserButton> buttons = new ArrayList<MinigameChooserButton>();
    private ScrollBar scrollbar = new ScrollBar(0, 0, 0, 0, false);

    private float xi = 0;
    private float yi = 0;
    private float xf = 0;
    private float yf = 0;

    private boolean hovered = false;

    MinigameChooser() {
      this.scrollbar.setButtonColors(color(170), color(90, 140, 155),
        color(110, 170, 195), color(80, 130, 150), color(0));
      this.scrollbar.useElapsedTime();
      for (MinigameName minigame : global.profile.minigames) {
        this.buttons.add(new MinigameChooserButton(minigame));
      }
    }


    void setLocation(float xi, float yi, float xf, float yf) {
      this.xi = xi;
      this.yi = yi;
      this.xf = xf;
      this.yf = yf;
      float button_width = this.yf - this.yi - 3 * Constants.minigames_edgeGap - Constants.minigames_scrollbarWidth;
      for (MinigameChooserButton button : this.buttons) {
        button.setLocation(0, 0, button_width, button_width);
      }
      this.scrollbar.setLocation(this.xi + Constants.minigames_edgeGap, this.yf -
        Constants.minigames_edgeGap - Constants.minigames_scrollbarWidth, this.xf -
        Constants.minigames_edgeGap, this.yf - Constants.minigames_edgeGap);
      float all_buttons_width = this.buttons.size() * (button_width + Constants.
        minigames_buttonGap) - Constants.minigames_buttonGap;
      float excess_width = this.xf - this.xi - 2 * Constants.minigames_edgeGap;
      this.scrollbar.updateMaxValue(round(ceil(excess_width / (button_width + Constants.minigames_edgeGap))));
    }


    void update(int time_elapsed) {
      this.scrollbar.update(time_elapsed);
    }

    void mouseMove(float mX, float mY) {
      this.scrollbar.mouseMove(mX, mY);
      if (mX > this.xi && mX < this.xf && mY > this.yi && mY < this.yf) {
        this.hovered = true;
      }
      else {
        this.hovered = false;
      }
    }

    void mousePress() {
      this.scrollbar.mousePress();
    }

    void mouseRelease(float mX, float mY) {
      this.scrollbar.mouseRelease(mX, mY);
    }

    void scroll(int amount) {
      if (this.hovered) {
        this.scrollbar.increaseValue(amount);
      }
    }
  }


  private MinigameButton[] buttons = new MinigameButton[1];
  private Panel bottomPanel = new Panel(DOWN, Constants.minigames_panelWidth);
  private MinigameChooser minigame_chooser = new MinigameChooser();

  private Minigame minigame = null;
  private MinigameStatus status = MinigameStatus.INITIAL;
  private boolean return_to_playing = false;
  private int last_update_time = millis();


  MinigameInterface() {
    this.buttons[0] = new MinigameButton1();
    this.bottomPanel.removeButton();
    this.bottomPanel.cant_resize = true;
    this.bottomPanel.color_background = color(50, 80, 100, 150);
    this.resizeButtons();
  }


  void resizeButtons() {
    float buttonSize = (this.bottomPanel.size_curr - 5 * Constants.mapEditor_buttonGapSize) / 4.0;
    float yf = height - Constants.mapEditor_buttonGapSize;
    this.buttons[0].setYLocation(yf - buttonSize, yf);
    yf -= buttonSize + Constants.mapEditor_buttonGapSize;
    this.minigame_chooser.setLocation(5, height + 5 - this.bottomPanel.size, this.buttons[0].xi - 5, height - 5);
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
        rect(0, 0, width, height - this.bottomPanel.size);
        this.minigame_chooser.update(time_elapsed);
        break;
      case LAUNCHING:
        break;
      case PLAYING:
        if (this.minigame != null) {
          this.minigame.update(time_elapsed);
          if (this.bottomPanel.collapsing) {
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
    this.bottomPanel.update(millis);
    if (this.bottomPanel.open && !this.bottomPanel.collapsing) {
      for (MinigameButton button : this.buttons) {
        button.update(millis);
      }
      if (this.minigame != null) {
        this.minigame.drawBottomPanel(time_elapsed);
      }
    }
    if (refreshLevelLocation) {
      if (this.minigame != null) {
        this.minigame.setLocation(0, 0, width, height - this.bottomPanel.size);
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
    if (this.status == MinigameStatus.INITIAL) {
      this.minigame_chooser.mouseMove(mX, mY);
    }
    // minigame mouse move
    if (this.minigame != null) {
      this.minigame.mouseMove(mX, mY);
      if (this.bottomPanel.clicked) {
        refreshMapLocation = true;
      }
    }
    // right panel mouse move
    this.bottomPanel.mouseMove(mX, mY);
    if (this.bottomPanel.open && !this.bottomPanel.collapsing) {
      for (MinigameButton button : this.buttons) {
        button.mouseMove(mX, mY);
      }
    }
    // refresh minigame location
    if (refreshMapLocation) {
      if (this.minigame != null) {
        this.minigame.setLocation(0, 0, width, height - this.bottomPanel.size);
      }
    }
    // cursor icon resolution
    if (this.bottomPanel.clicked) {
      this.resizeButtons();
      global.setCursor("icons/cursor_resizeh_white.png");
    }
    else if (this.bottomPanel.hovered) {
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
    if (this.status == MinigameStatus.INITIAL) {
      this.minigame_chooser.mousePress();
    }
    this.bottomPanel.mousePress();
    if (this.bottomPanel.clicked) {
      global.setCursor("icons/cursor_resizeh_white.png");
    }
    else {
      global.defaultCursor("icons/cursor_resizeh_white.png");
    }
    if (this.bottomPanel.open && !this.bottomPanel.collapsing) {
      for (MinigameButton button : this.buttons) {
        button.mousePress();
      }
    }
  }

  void mouseRelease(float mX, float mY) {
    if (this.minigame != null) {
      this.minigame.mouseRelease(mX, mY);
    }
    if (this.status == MinigameStatus.INITIAL) {
      this.minigame_chooser.mouseRelease(mX, mY);
    }
    this.bottomPanel.mouseRelease(mX, mY);
    if (this.bottomPanel.hovered) {
      global.setCursor("icons/cursor_resizeh.png");
    }
    else {
      global.defaultCursor("icons/cursor_resizeh.png", "icons/cursor_resizeh_white.png");
    }
    if (this.bottomPanel.open && !this.bottomPanel.collapsing) {
      for (MinigameButton button : this.buttons) {
        button.mouseRelease(mX, mY);
      }
    }
  }

  void scroll(int amount) {
    if (this.minigame != null) {
      this.minigame.scroll(amount);
    }
    if (this.status == MinigameStatus.INITIAL) {
      this.minigame_chooser.scroll(amount);
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
