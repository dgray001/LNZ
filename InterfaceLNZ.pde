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

  class ErrorForm extends FormLNZ {
    ErrorForm(String errorMessage) {
      super(0.5 * (width - Constants.errorForm_width), 0.5 * (height - Constants.errorForm_height),
        0.5 * (width + Constants.errorForm_width), 0.5 * (height + Constants.errorForm_height));
      this.setTitleText("Error Detected");
      this.setTitleSize(20);
      this.setFieldCushion(0);
      this.color_background = color(250, 150, 150);
      this.color_header = color(180, 50, 50);
      this.addField(new SpacerFormField(20));
      this.addField(new MessageFormField("Error detected on this frame."));
      this.addField(new SpacerFormField(10));
      this.addField(new TextBoxFormField("Error message:\n" + errorMessage, 100));
      this.addField(new SpacerFormField(20));
      this.addField(new MessageFormField("Check the data/error folder for logs and image."));
      this.addField(new SpacerFormField(20));
      this.addField(new CheckboxFormField("Send error report  "));
      this.addField(new SpacerFormField(20));
      SubmitCancelFormField buttons = new SubmitCancelFormField("Continue\n(may crash)", "Exit");
      textSize(buttons.button1.text_size);
      buttons.setButtonHeight(2 * (textAscent() + textDescent() + 2));
      this.addField(buttons);
      this.img.save("data/logs/screenshot.jpg");
    }

    void submit() {
      if (this.fields.get(7).getValue().equals(Boolean.toString(true))) {
        this.sendEmail();
      }
      this.canceled = true;
    }

    @Override
    void cancel() {
      if (this.fields.get(7).getValue().equals(Boolean.toString(true))) {
        this.sendEmail();
      }
      global.exitDelay();
    }

    void sendEmail() {
      global.log("Send email (not configured).");
    }

    void addErrorMessage(String message) {
      this.fields.get(3).setValue(this.fields.get(3).getValue() + "\n\nError Message:\n" + message);
    }
  }


  class OptionsForm extends FormLNZ {
    OptionsForm() {
      super(Constants.optionsForm_widthOffset, Constants.optionsForm_heightOffset,
        width - Constants.optionsForm_widthOffset, height - Constants.optionsForm_heightOffset);
      this.setTitleText("Options");
      this.setTitleSize(20);
      this.setFieldCushion(0);
      this.color_background = color(250, 250, 180);
      this.color_header = color(180, 180, 50);
      if (global.profile == null) {
        this.canceled = true;
        return;
      }
      SliderFormField volume_master = new SliderFormField("Master Volume: ", 0, 100);
      volume_master.threshhold = Constants.optionsForm_threshhold_master;
      volume_master.addCheckbox("mute: ");
      SliderFormField volume_music = new SliderFormField("Music: ", 0, 100);
      volume_music.threshhold = Constants.optionsForm_threshhold_other;
      volume_music.addCheckbox("mute: ");
      SliderFormField volume_interface = new SliderFormField("Interface: ", 0, 100);
      volume_interface.threshhold = Constants.optionsForm_threshhold_other;
      volume_interface.addCheckbox("mute: ");
      SliderFormField volume_environment = new SliderFormField("Environment: ", 0, 100);
      volume_environment.threshhold = Constants.optionsForm_threshhold_other;
      volume_environment.addCheckbox("mute: ");
      SliderFormField volume_units = new SliderFormField("Units: ", 0, 100);
      volume_units.threshhold = Constants.optionsForm_threshhold_other;
      volume_units.addCheckbox("mute: ");
      SliderFormField volume_player = new SliderFormField("Player: ", 0, 100);
      volume_player.threshhold = Constants.optionsForm_threshhold_other;
      volume_player.addCheckbox("mute: ");
      SliderFormField map_move_speed = new SliderFormField("Camera Speed: ",
        Constants.map_minCameraSpeed, Constants.map_maxCameraSpeed);
      map_move_speed.threshhold = Constants.optionsForm_threshhold_other;
      SubmitFormField apply = new ButtonFormField("Apply");
      apply.button.setColors(color(220), color(240, 240, 190),
        color(190, 190, 140), color(140, 140, 90), color(0));
      SubmitFormField submit = new SubmitFormField("Save Options");
      submit.button.setColors(color(220), color(240, 240, 190),
        color(190, 190, 140), color(140, 140, 90), color(0));
      SubmitFormField defaults = new ButtonFormField("Defaults");
      defaults.button.setColors(color(220), color(240, 240, 190),
        color(190, 190, 140), color(140, 140, 90), color(0));
      SubmitFormField cancel = new SubmitFormField("Cancel", false);
      cancel.button.setColors(color(220), color(240, 240, 190),
        color(190, 190, 140), color(140, 140, 90), color(0));

      this.addField(volume_master);
      this.addField(volume_music);
      this.addField(volume_interface);
      this.addField(volume_environment);
      this.addField(volume_units);
      this.addField(volume_player);
      this.addField(new SpacerFormField(10));
      this.addField(map_move_speed);
      this.addField(new SpacerFormField(10));
      this.addField(apply);
      this.addField(new SpacerFormField(10));
      this.addField(submit);
      this.addField(new SpacerFormField(10));
      this.addField(defaults);
      this.addField(new SpacerFormField(10));
      this.addField(cancel);

      this.setFormFieldValues();
    }

    void setFormFieldValues() {
      this.fields.get(0).setValue(global.profile.options.volume_master);
      if (global.profile.options.volume_master_muted) {
        this.fields.get(0).disable();
      }
      else {
        this.fields.get(0).enable();
      }

      this.fields.get(1).setValue(global.profile.options.volume_music);
      if (global.profile.options.volume_music_muted) {
        this.fields.get(1).disable();
      }
      else {
        this.fields.get(1).enable();
      }

      this.fields.get(2).setValue(global.profile.options.volume_interface);
      if (global.profile.options.volume_interface_muted) {
        this.fields.get(2).disable();
      }
      else {
        this.fields.get(2).enable();
      }

      this.fields.get(3).setValue(global.profile.options.volume_environment);
      if (global.profile.options.volume_environment_muted) {
        this.fields.get(3).disable();
      }
      else {
        this.fields.get(3).enable();
      }

      this.fields.get(4).setValue(global.profile.options.volume_units);
      if (global.profile.options.volume_units_muted) {
        this.fields.get(4).disable();
      }
      else {
        this.fields.get(4).enable();
      }

      this.fields.get(5).setValue(global.profile.options.volume_player);
      if (global.profile.options.volume_player_muted) {
        this.fields.get(5).disable();
      }
      else {
        this.fields.get(5).enable();
      }

      this.fields.get(7).setValue(global.profile.options.map_viewMoveSpeedFactor);
    }

    void submit() {
      this.apply();
      global.profile.save();
      this.canceled = true;
    }

    void apply() {
      String vol_master = this.fields.get(0).getValue();
      if (vol_master.contains("disabled")) {
        global.profile.options.volume_master_muted = true;
      }
      else {
        global.profile.options.volume_master_muted = false;
      }
      global.profile.options.volume_master = toFloat(split(vol_master, ':')[0]);

      String vol_music = this.fields.get(1).getValue();
      if (vol_music.contains("disabled")) {
        global.profile.options.volume_music_muted = true;
      }
      else {
        global.profile.options.volume_music_muted = false;
      }
      global.profile.options.volume_music = toFloat(split(vol_music, ':')[0]);

      String vol_interface = this.fields.get(2).getValue();
      if (vol_interface.contains("disabled")) {
        global.profile.options.volume_interface_muted = true;
      }
      else {
        global.profile.options.volume_interface_muted = false;
      }
      global.profile.options.volume_interface = toFloat(split(vol_interface, ':')[0]);

      String vol_environment = this.fields.get(3).getValue();
      if (vol_environment.contains("disabled")) {
        global.profile.options.volume_environment_muted = true;
      }
      else {
        global.profile.options.volume_environment_muted = false;
      }
      global.profile.options.volume_environment = toFloat(split(vol_environment, ':')[0]);

      String vol_units = this.fields.get(4).getValue();
      if (vol_units.contains("disabled")) {
        global.profile.options.volume_units_muted = true;
      }
      else {
        global.profile.options.volume_units_muted = false;
      }
      global.profile.options.volume_units = toFloat(split(vol_units, ':')[0]);

      String vol_player = this.fields.get(5).getValue();
      if (vol_player.contains("disabled")) {
        global.profile.options.volume_player_muted = true;
      }
      else {
        global.profile.options.volume_player_muted = false;
      }
      global.profile.options.volume_player = toFloat(split(vol_player, ':')[0]);

      String camera_speed = this.fields.get(7).getValue();
      global.profile.options.map_viewMoveSpeedFactor = toFloat(split(camera_speed, ':')[0]);

      global.profile.options.change();
    }

    void buttonPress(int index) {
      switch(index) {
        case 9: // apply
          this.apply();
          break;
        case 13: // defaults
          global.profile.options.defaults();
          this.setFormFieldValues();
          break;
        default:
          break;
      }
    }
  }


  class AchievementsForm extends FormLNZ {
    AchievementsForm() {
      super(Constants.achievementsForm_widthOffset, Constants.achievementsForm_heightOffset,
        width - Constants.achievementsForm_widthOffset, height - Constants.achievementsForm_heightOffset);
      this.setTitleText("Achievements");
      this.setTitleSize(20);
      this.color_background = color(180, 250, 250);
      this.color_header = color(50, 180, 180);
      if (global.profile == null) {
        this.canceled = true;
        return;
      }
      // add fields for profile achievements
    }

    void submit() {
    }
  }


  protected FormLNZ form = null;

  InterfaceLNZ() {
  }

  void throwError(String message) {
    if (this.form != null && ErrorForm.class.isInstance(this.form)) {
      ((ErrorForm)this.form).addErrorMessage(message);
    }
    else {
      this.form = new ErrorForm(message);
    }
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

  void LNZ_mouseRelease(float mX, float mY) {
    if (this.form == null) {
      this.mouseRelease(mX, mY);
    }
    else {
      this.form.mouseRelease(mX, mY);
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

  abstract void loseFocus();
  abstract void gainFocus();
  abstract void update(int millis);
  abstract void mouseMove(float mX, float mY);
  abstract void mousePress();
  abstract void mouseRelease(float mX, float mY);
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

  void mouseRelease(float mX, float mY) {
    this.logo.mouseRelease(mX, mY);
    for (InitialInterfaceButton button : this.buttons) {
      button.mouseRelease(mX, mY);
    }
  }

  void scroll(int amount) {}
  void keyPress() {}
  void keyRelease() {}


  void loseFocus() {}

  void gainFocus() {}
}
