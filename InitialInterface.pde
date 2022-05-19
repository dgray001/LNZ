class InitialInterface extends InterfaceLNZ {

  abstract class InitialInterfaceButton extends RectangleButton {
    InitialInterfaceButton(float yi, float yf) {
      super(Constants.initialInterface_size - Constants.initialInterface_buttonWidth -
        Constants.initialInterface_buttonGap, yi, Constants.initialInterface_size -
        Constants.initialInterface_buttonGap, yf);
      this.setColors(color(0, 100, 30, 200), color(0, 129, 50, 150),
        color(0, 129, 50, 190), color(0, 129, 50, 230), color(255));
      this.noStroke();
      this.show_message = true;
      this.text_size = 15;
    }

    void hover() {
      global.sounds.trigger_interface("interfaces/buttonOn1");
      InitialInterface.this.logo.release();
    }
    void dehover() {
      this.clicked = false;
    }
    void click() {
      InitialInterface.this.logo.release();
    }
    void release() {
      this.stayDehovered();
      InitialInterface.this.logo.release();
      InitialInterface.this.logo.release();
    }
  }

  class InitialInterfaceButton1 extends InitialInterfaceButton {
    InitialInterfaceButton1(float buttonHeight) {
      super(Constants.initialInterface_buttonGap,
        Constants.initialInterface_buttonGap + buttonHeight);
      this.message = "Launch";
    }

    @Override
    void release() {
      super.release();
      global.sounds.trigger_interface("interfaces/buttonClick4");
      global.state = ProgramState.ENTERING_MAINMENU;
      background(global.color_background);
      surface.setSize(displayWidth, displayHeight);
      surface.setLocation(0, 0);
    }
  }

  class InitialInterfaceButton2 extends InitialInterfaceButton {
    InitialInterfaceButton2(float buttonHeight) {
      super(2 * Constants.initialInterface_buttonGap + buttonHeight,
        2 * Constants.initialInterface_buttonGap + 2 * buttonHeight);
      this.message = "Uninstall";
    }

    @Override
    void release() {
      super.release();
      global.sounds.trigger_interface("interfaces/buttonClick3");
      InitialInterface.this.form = new InitialInterfaceForm("Uninstall Game", "Just delete it ya dip");
    }
  }

  class InitialInterfaceButton3 extends InitialInterfaceButton {
    InitialInterfaceButton3(float buttonHeight) {
      super(3 * Constants.initialInterface_buttonGap + 2 * buttonHeight,
        3 * Constants.initialInterface_buttonGap + 3 * buttonHeight);
      this.message = "Reset\nGame";
    }

    @Override
    void release() {
      super.release();
      global.sounds.trigger_interface("interfaces/buttonClick3");
      InitialInterface.this.form = new InitialInterfaceForm("Reset Game", "Why would you want to reinstall a test version?");
    }
  }

  class InitialInterfaceButton4 extends InitialInterfaceButton {
    InitialInterfaceButton4(float buttonHeight) {
      super(4 * Constants.initialInterface_buttonGap + 3 * buttonHeight,
        4 * Constants.initialInterface_buttonGap + 4 * buttonHeight);
      this.message = "Version\nHistory";
    }

    @Override
    void release() {
      super.release();
      global.sounds.trigger_interface("interfaces/buttonClick3");
      InitialInterface.this.form = new InitialInterfaceForm("Version History", Constants.version_history);
    }
  }

  class InitialInterfaceButton5 extends InitialInterfaceButton {
    InitialInterfaceButton5(float buttonHeight) {
      super(5 * Constants.initialInterface_buttonGap + 4 * buttonHeight,
        5 * Constants.initialInterface_buttonGap + 5 * buttonHeight);
      this.message = "Exit";
    }

    @Override
    void release() {
      super.release();
      global.sounds.trigger_interface("interfaces/buttonClick3");
      global.exitDelay();
    }
  }

  class LogoImageButton extends ImageButton {
    LogoImageButton() {
      super(global.images.getImage("logo.png"), 0, 0, 400, 400);
    }

    void hover() {
    }
    void dehover() {
    }
    void click() {
      this.color_tint = color(255, 200, 200);
    }
    void release() {
      this.color_tint = color(255);
    }
  }

  class InitialInterfaceForm extends FormLNZ {
    InitialInterfaceForm(String title, String message) {
      super(0.5 * Constants.initialInterface_size - 120, 0.5 * Constants.initialInterface_size - 120,
        0.5 * Constants.initialInterface_size + 120, 0.5 * Constants.initialInterface_size + 120);
      this.setTitleText(title);
      this.setTitleSize(18);
      this.color_background = color(180, 250, 180);
      this.color_header = color(30, 170, 30);
      this.scrollbar.setButtonColors(color(170), color(190, 255, 190),
        color(220, 255, 220), color(160, 220, 160), color(0));

      SubmitFormField submit = new SubmitFormField("  Ok  ");
      submit.button.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      this.addField(new SpacerFormField(0));
      TextBoxFormField textbox = new TextBoxFormField(message, 120);
      textbox.textbox.scrollbar.setButtonColors(color(170), color(190, 255, 190),
        color(220, 255, 220), color(160, 220, 160), color(0));
      this.addField(textbox);
      this.addField(submit);
    }
    void submit() {
      this.canceled = true;
    }
  }

  private InitialInterfaceButton[] buttons = new InitialInterfaceButton[5];
  private LogoImageButton logo = new LogoImageButton();

  InitialInterface() {
    super();
    float buttonHeight = (Constants.initialInterface_size - (this.buttons.length + 1) *
      Constants.initialInterface_buttonGap) / this.buttons.length;
    this.buttons[0] = new InitialInterfaceButton1(buttonHeight);
    this.buttons[1] = new InitialInterfaceButton2(buttonHeight);
    this.buttons[2] = new InitialInterfaceButton3(buttonHeight);
    this.buttons[3] = new InitialInterfaceButton4(buttonHeight);
    this.buttons[4] = new InitialInterfaceButton5(buttonHeight);
  }

  void saveAndExitToMainMenu() {}

  Hero getCurrentHeroIfExists() {
    return null;
  }

  void update(int millis) {
    this.logo.update(millis);
    for (InitialInterfaceButton button : this.buttons) {
      button.update(millis);
    }
  }

  void showNerdStats() {
    fill(0);
    textSize(14);
    textAlign(LEFT, TOP);
    float y_stats = 1;
    float line_height = textAscent() + textDescent() + 2;
    text("FPS: " + int(global.lastFPS), 1, y_stats);
  }

  void mouseMove(float mX, float mY) {
    this.logo.mouseMove(mX, mY);
    for (InitialInterfaceButton button : this.buttons) {
      button.mouseMove(mX, mY);
    }
  }

  void mousePress() {
    this.logo.mousePress();
    for (InitialInterfaceButton button : this.buttons) {
      button.mousePress();
    }
  }

  void mouseRelease(float mX, float mY) {
    this.logo.mouseRelease(mX, mY);
    for (InitialInterfaceButton button : this.buttons) {
      button.mouseRelease(mX, mY);
    }
  }

  void scroll(int amount) {}
  void keyPress() {}
  void openEscForm() {}
  void keyRelease() {}
  void loseFocus() {}
  void gainFocus() {}
  void restartTimers() {}
}
