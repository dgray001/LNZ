abstract class FormLNZ extends Form {
  protected boolean canceled = false;
  protected float shadow_distance = 10;
  protected PImage img;

  FormLNZ(float xi, float yi, float xf, float yf) {
    super(xi, yi, xf, yf);
    this.img = getCurrImage();
    this.cancelButton();
    this.draggable = true;
  }

  @Override
  void update(int millis) {
    rectMode(CORNERS);
    fill(0);
    //rect(0, 0, width, height);
    imageMode(CORNER);
    image(this.img, 0, 0);
    fill(0, 150);
    stroke(0, 1);
    translate(shadow_distance, shadow_distance);
    rect(this.xi, this.yi, this.xf, this.yf);
    translate(-shadow_distance, -shadow_distance);
    super.update(millis);
  }

  void cancel() {
    this.canceled = true;
  }

  void buttonPress(int i) {}
}


abstract class InterfaceLNZ {

  class OptionsForm extends FormLNZ {
    OptionsForm() {
      super(Constants.OptionsForm_widthOffset, Constants.OptionsForm_heightOffset,
        width - Constants.OptionsForm_widthOffset, height - Constants.OptionsForm_heightOffset);
      this.setTitleText("Options");
      this.setTitleSize(20);
      this.color_background = color(250, 250, 180);
      this.color_header = color(180, 180, 50);
      if (global.profile == null) {
        this.canceled = true;
        return;
      }
      // add fields for profile options
      SubmitFormField submit = new SubmitFormField("Save Options");
      submit.button.setColors(color(220), color(240, 240, 190),
        color(190, 190, 140), color(140, 140, 90), color(0));
      this.addField(submit);
    }

    void submit() {
      // set profile options
      global.profile.save();
      this.canceled = true;
    }
  }

  protected FormLNZ form = null;

  InterfaceLNZ() {
  }

  void LNZ_update(int millis) {
    if (this.form == null) {
      this.update(millis);
    }
    else {
      this.form.update(millis);
      if (this.form.canceled) {
        this.form = null;
      }
    }
  }

  void LNZ_mouseMove(float mX, float mY) {
    if (this.form == null) {
      this.mouseMove(mX, mY);
    }
    else {
      this.form.mouseMove(mX, mY);
    }
  }

  void LNZ_mousePress() {
    if (this.form == null) {
      this.mousePress();
    }
    else {
      this.form.mousePress();
    }
  }

  void LNZ_mouseRelease() {
    if (this.form == null) {
      this.mouseRelease();
    }
    else {
      this.form.mouseRelease();
    }
  }

  void LNZ_scroll(int amount) {
    if (this.form == null) {
      this.scroll(amount);
    }
    else {
      this.form.scroll(amount);
    }
  }

  void LNZ_keyPress() {
    if (this.form == null) {
      this.keyPress();
    }
    else {
      this.form.keyPress();
    }
  }

  void LNZ_keyRelease() {
    if (this.form == null) {
      this.keyRelease();
    }
    else {
      this.form.keyRelease();
    }
  }

  abstract void update(int millis);
  abstract void mouseMove(float mX, float mY);
  abstract void mousePress();
  abstract void mouseRelease();
  abstract void keyPress();
  abstract void keyRelease();
  abstract void scroll(int amount);
}



class InitialInterface extends InterfaceLNZ {

  abstract class InitialInterfaceButton extends RectangleButton {
    InitialInterfaceButton(float yi, float yf) {
      super(Constants.initialInterface_size - Constants.initialInterface_buttonWidth -
        Constants.initialInterface_buttonGap, yi, Constants.initialInterface_size -
        Constants.initialInterface_buttonGap, yf);
      this.setColors(color(0, 100, 30, 200), color(0, 129, 50, 150), color(0, 129, 50, 190), color(0, 129, 50, 230), color(255));
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
      background(30, 0, 0);
      global.menu = null;
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
      global.exit();
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

      SubmitFormField submit = new SubmitFormField("  Ok  ");
      submit.button.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      this.addField(new SpacerFormField(0));
      this.addField(new TextBoxFormField(message, 120));
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

  void update(int millis) {
    this.logo.update(millis);
    for (InitialInterfaceButton button : this.buttons) {
      button.update(millis);
    }
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

  void mouseRelease() {
    this.logo.mouseRelease();
    for (InitialInterfaceButton button : this.buttons) {
      button.mouseRelease();
    }
  }

  void scroll(int amount) {}
  void keyPress() {}
  void keyRelease() {}
}
