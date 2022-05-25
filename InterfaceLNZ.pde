abstract class FormLNZ extends Form {
  protected boolean canceled = false;
  protected float shadow_distance = 10;
  protected PImage img;
  protected color color_shadow = color(0, 150);
  protected boolean need_to_reset_cursor = true;

  FormLNZ(float xi, float yi, float xf, float yf) {
    super(xi, yi, xf, yf);
    this.img = getCurrImage();
    this.cancelButton();
    this.draggable = true;
  }

  @Override
  void update(int millis) {
    if (this.need_to_reset_cursor) {
      global.defaultCursor();
    }
    rectMode(CORNERS);
    fill(0);
    imageMode(CORNER);
    image(this.img, 0, 0);
    fill(color_shadow);
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

  void keyPress() {
    super.keyPress();
    if (key == ESC) {
      this.cancel();
    }
  }
}



abstract class InterfaceLNZ {

  abstract class ConfirmForm extends FormLNZ {
    ConfirmForm(String title, String message) {
      this(title, message, Constants.mapEditor_formWidth_small, Constants.mapEditor_formHeight_small);
    }
    ConfirmForm(String title, String message, boolean mediumForm) {
      this(title, message, Constants.mapEditor_formWidth, Constants.mapEditor_formHeight);
    }
    ConfirmForm(String title, String message, float formWidth, float formHeight) {
      super(0.5 * (width - formWidth), 0.5 * (height - formHeight),
        0.5 * (width + formWidth), 0.5 * (height + formHeight));
      this.setTitleText(title);
      this.setTitleSize(18);
      this.color_background = color(180, 250, 180);
      this.color_header = color(30, 170, 30);

      SubmitCancelFormField submit = new SubmitCancelFormField("  Ok  ", "Cancel");
      submit.button1.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      submit.button2.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      this.addField(new SpacerFormField(0));
      this.addField(new TextBoxFormField(message, formHeight - 130));
      this.addField(submit);
    }
  }


  class EscForm extends FormLNZ {
    class EscButtonFormField extends ButtonFormField {
      EscButtonFormField(String message) {
        super(message);
        this.button.setColors(color(170, 200), color(1, 0), color(40, 150), color(20, 180), color(255));
        this.button.raised_border = false;
        this.button.raised_body = false;
        this.button.noStroke();
        this.button.text_size = 20;
        this.extend_width = true;
      }
    }

    EscForm() {
      super(0.5 * (width - Constants.escFormWidth), 0.5 * (height - Constants.escFormHeight),
        0.5 * (width + Constants.escFormWidth), 0.5 * (height + Constants.escFormHeight));
      this.cancel = null;
      this.scrollbar_width_multiplier = 0;
      this.draggable = false;
      this.color_shadow = color(1, 0);
      this.setFieldCushion(20);
      this.setTitleText("Paused");
      this.setTitleSize(22);
      this.color_background = color(60, 120);
      this.color_header = color(1, 0);
      this.color_stroke = color(1, 0);
      this.color_title = color(255);

      this.addField(new SpacerFormField(0));
      this.addField(new EscButtonFormField("Continue"));
      this.addField(new EscButtonFormField("Options"));
      this.addField(new EscButtonFormField("Heroes"));
      this.addField(new EscButtonFormField("Achievements"));
      this.addField(new EscButtonFormField("Perk Tree"));
      this.addField(new EscButtonFormField("Save and Exit to Main Menu"));
    }

    @Override
    void update(int millis) {
      super.update(millis);
      stroke(255);
      strokeWeight(2);
      line(this.xi, this.yi, this.xf, this.yi);
      line(this.xi, this.yStart, this.xf, this.yStart);
      line(this.xi, this.yf, this.xf, this.yf);
      line(this.xi, this.yi, this.xi, this.yf);
      line(this.xf, this.yi, this.xf, this.yf);
    }

    void submit() {}

    @Override
    void buttonPress(int i) {
      switch(i) {
        case 1:
          this.cancel();
          break;
        case 2:
          InterfaceLNZ.this.return_to_esc_menu = true;
          InterfaceLNZ.this.esc_menu_img = this.img;
          InterfaceLNZ.this.optionsForm();
          break;
        case 3:
          InterfaceLNZ.this.return_to_esc_menu = true;
          InterfaceLNZ.this.esc_menu_img = this.img;
          InterfaceLNZ.this.heroesForm();
          break;
        case 4:
          InterfaceLNZ.this.return_to_esc_menu = true;
          InterfaceLNZ.this.esc_menu_img = this.img;
          InterfaceLNZ.this.achievementsForm();
          break;
        case 5:
          InterfaceLNZ.this.openPlayerTree();
          break;
        case 6:
          InterfaceLNZ.this.saveAndExitToMainMenu();
          break;
        default:
          break;
      }
    }
  }


  class HeroesForm extends FormLNZ {
    class HeroesFormField extends FormField {
      class HeroButton extends IconInverseButton {
        protected HeroCode code;
        protected Hero hero = null;
        HeroButton(float xi, float yi, float xf, float yf, HeroCode code) {
          super(xi, yi, xf, yf, global.images.getImage(code.getImagePath()));
          this.roundness = 4;
          this.adjust_for_text_descent = true;
          this.code = code;
          Element e = code.element();
          this.background_color = color(170, 170);
          this.setColors(elementalColorLocked(e), elementalColorDark(e), elementalColor(e),
            elementalColorLight(e), elementalColorText(e));
          this.show_message = true;
          this.message = code.display_name();
          this.text_size = 24;
          this.rippleTimer = 450;
          this.setStroke(color(0), 1);
          if (global.profile.heroes.containsKey(this.code)) {
            this.hero = global.profile.heroes.get(this.code);
            if (global.profile.curr_hero == this.code) {
              this.setStroke(color(255), 6);
            }
          }
        }
        void hover() {
          super.hover();
          this.message = this.code.display_name() + "\n" + this.code.title() +
            "\nLocation: " + this.hero.location.display_name();
          this.text_size = 16;
        }
        void dehover() {
          super.dehover();
          this.message = this.code.display_name();
          this.text_size = 24;
        }
        void release() {
          super.release();
          if (this.hovered || this.button_focused) {
            HeroesFormField.this.last_code_clicked = this.code;
            HeroesFormField.this.clicked = true;
          }
        }
      }

      protected HeroButton[] heroes = new HeroButton[2];
      protected HeroCode last_code_clicked = HeroCode.ERROR;
      protected boolean clicked = false;

      HeroesFormField(int index) {
        super("");
        switch(index) {
          case 0:
            this.heroes[0] = new HeroButton(0, 0, 0, 100, HeroCode.BEN);
            this.heroes[1] = new HeroButton(0, 0, 0, 100, HeroCode.DAN);
            break;
        }
        this.enable();
      }

      void disable() {
        for (HeroButton button : this.heroes) {
          if (button == null) {
            continue;
          }
          button.disabled = true;
        }
      }
      void enable() {
        for (HeroButton button : this.heroes) {
          if (button == null) {
            continue;
          }
          button.disabled = !global.profile.heroes.containsKey(button.code);
        }
      }

      boolean focusable() {
        for (int i = 0; i < this.heroes.length; i++) {
          if (this.heroes[this.heroes.length - 1 - i] == null) {
            continue;
          }
          if (this.heroes[this.heroes.length - 1 - i].button_focused) {
            return false;
          }
          return true;
        }
        return false;
      }
      void focus() {
        boolean refocused = false;
        for (int i = 0; i < this.heroes.length; i++) {
          if (this.heroes[i] == null) {
            continue;
          }
          if (this.heroes[i].button_focused) {
            this.heroes[i].button_focused = false;
            if (i == this.heroes.length - 1) {
              this.heroes[0].button_focused = true;
            }
            else {
              this.heroes[i + 1].button_focused = true;
            }
            refocused = true;
            break;
          }
        }
        if (!refocused) {
          this.heroes[0].button_focused = true;
        }
      }
      void defocus() {
        for (HeroButton button : this.heroes) {
          if (button == null) {
            continue;
          }
          button.button_focused = false;
        }
      }
      boolean focused() {
        for (HeroButton button : this.heroes) {
          if (button == null) {
            continue;
          }
          if (button.button_focused) {
            return true;
          }
        }
        return false;
      }

      void updateWidthDependencies() {
        float button_width = (this.field_width - 4) / this.heroes.length - (this.heroes.length - 1) * 10;
        for (int i = 0; i < this.heroes.length; i++) {
          if (this.heroes[i] == null) {
            continue;
          }
          this.heroes[i].setXLocation(2 + i * (button_width + 10), 2 + i * (button_width + 10) + button_width);
        }
      }

      float getHeight() {
        for (HeroButton button : this.heroes) {
          if (button == null) {
            continue;
          }
          return button.button_height();
        }
        return 0;
      }

      String getValue() {
        return this.last_code_clicked.file_name();
      }
      void setValue(String value) {
        this.message = value;
      }

      FormFieldSubmit update(int millis) {
        for (HeroButton button : this.heroes) {
          if (button == null) {
            continue;
          }
          button.update(millis);
        }
        if (this.clicked) {
          this.clicked = false;
          return FormFieldSubmit.BUTTON;
        }
        return FormFieldSubmit.NONE;
      }

      void mouseMove(float mX, float mY) {
        for (HeroButton button : this.heroes) {
          if (button == null) {
            continue;
          }
          button.mouseMove(mX, mY);
        }
      }

      void mousePress() {
        for (HeroButton button : this.heroes) {
          if (button == null) {
            continue;
          }
          button.mousePress();
        }
      }

      void mouseRelease(float mX, float mY) {
        for (HeroButton button : this.heroes) {
          if (button == null) {
            continue;
          }
          button.mouseRelease(mX, mY);
        }
      }

      void scroll(int amount) {}
      void keyPress() {
        for (HeroButton button : this.heroes) {
          if (button == null) {
            continue;
          }
          button.keyPress();
        }
      }
      void keyRelease() {
        for (HeroButton button : this.heroes) {
          if (button == null) {
            continue;
          }
          button.keyRelease();
        }
      }
      void submit() {}
    }

    HeroesForm() {
      super(0.5 * (width - Constants.profile_heroesFormWidth), 0.5 * (height - Constants.profile_heroesFormHeight),
        0.5 * (width + Constants.profile_heroesFormWidth), 0.5 * (height + Constants.profile_heroesFormHeight));
      this.setTitleText("Heroes");
      this.setTitleSize(22);
      this.color_shadow = color(0, 180);
      this.color_background = color(60);
      this.color_header = color(90);
      this.color_stroke = color(0);
      this.color_title = color(255);
      this.setFieldCushion(15);

      this.addField(new SpacerFormField(0));
      this.addField(new HeroesFormField(0));
    }

    void submit() {}

    void buttonPress(int i) {
      HeroCode code_clicked = HeroCode.ERROR;
      try {
        code_clicked = ((HeroesFormField)this.fields.get(i)).last_code_clicked;
      } catch(Exception e) {}
      if (code_clicked != HeroCode.ERROR) {
        InterfaceLNZ.this.openHeroForm(code_clicked);
      }
    }

    void keyPress() {
      super.keyPress();
      if (key == 'h' && global.holding_ctrl) {
        this.cancel();
      }
    }
  }


  class HeroForm extends FormLNZ {
    protected Hero hero;
    protected boolean switch_hero = true;
    HeroForm(Hero hero) {
      super(0.5 * (width - Constants.profile_heroFormWidth), 0.5 * (height - Constants.profile_heroFormHeight),
        0.5 * (width + Constants.profile_heroFormWidth), 0.5 * (height + Constants.profile_heroFormHeight));
      this.hero = hero;
      this.setTitleText(hero.code.display_name());
      this.setTitleSize(22);
      Element e = hero.element;
      this.color_background = elementalColorLight(e);
      this.color_header = elementalColor(e);
      this.color_stroke = elementalColorDark(e);
      this.color_title = elementalColorText(e);
      this.setFieldCushion(15);

      MessageFormField message1 = new MessageFormField("Location: " + hero.location.display_name());
      message1.text_color = elementalColorText(hero.element);
      MessageFormField message2 = new MessageFormField(hero.code.title());
      message2.text_color = elementalColorText(hero.element);
      TextBoxFormField textbox = new TextBoxFormField(hero.code.description(), 100);
      textbox.textbox.color_text = elementalColorText(hero.element);

      this.addField(new SpacerFormField(80));
      this.addField(message1);
      if (PlayingInterface.class.isInstance(InterfaceLNZ.this)) {
        SubmitFormField submit = null;
        if (global.profile.curr_hero == hero.code) {
          submit = new SubmitFormField("Continue Playing");
          this.switch_hero = false;
        }
        else {
          submit = new SubmitFormField("Play Hero");
        }
        submit.button.text_size = 18;
        submit.button.setColors(elementalColorLocked(hero.element), elementalColor(
          hero.element), elementalColorLight(hero.element), elementalColorDark(
          hero.element), elementalColorText(hero.element));
        this.addField(submit);
      }
      this.addField(new SpacerFormField(10));
      this.addField(message2);
      this.addField(textbox);
      this.addField(new SpacerFormField(10));
    }

    @Override
    void update(int millis) {
      super.update(millis);
      imageMode(CENTER);
      image(global.images.getImage(this.hero.code.getImagePath()), this.xCenter(), this.yStart + 40, 75, 75);
    }

    void submit() {
      if (this.switch_hero && PlayingInterface.class.isInstance(InterfaceLNZ.this)) {
        ((PlayingInterface)InterfaceLNZ.this).switchHero(this.hero);
      }
      this.canceled = true;
      InterfaceLNZ.this.return_to_heroes_menu = false;
    }

    void buttonPress(int i) {}
  }


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
      buttons.button1.setColors(color(180), color(240, 160, 160),
        color(190, 110, 110), color(140, 70, 70), color(0));
      buttons.button2.setColors(color(180), color(240, 160, 160),
        color(190, 110, 110), color(140, 70, 70), color(0));
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
      SliderFormField volume_master = new SliderFormField("Master Volume: ",
        Constants.options_volumeMin, Constants.options_volumeMax);
      volume_master.threshhold = Constants.optionsForm_threshhold_master;
      volume_master.addCheckbox("mute: ");
      SliderFormField volume_music = new SliderFormField("Music: ",
        Constants.options_volumeMin, Constants.options_volumeMax);
      volume_music.threshhold = Constants.optionsForm_threshhold_other;
      volume_music.addCheckbox("mute: ");
      SliderFormField volume_interface = new SliderFormField("Interface: ",
        Constants.options_volumeMin, Constants.options_volumeMax);
      volume_interface.threshhold = Constants.optionsForm_threshhold_other;
      volume_interface.addCheckbox("mute: ");
      SliderFormField volume_environment = new SliderFormField("Environment: ",
        Constants.options_volumeMin, Constants.options_volumeMax);
      volume_environment.threshhold = Constants.optionsForm_threshhold_other;
      volume_environment.addCheckbox("mute: ");
      SliderFormField volume_units = new SliderFormField("Units: ",
        Constants.options_volumeMin, Constants.options_volumeMax);
      volume_units.threshhold = Constants.optionsForm_threshhold_other;
      volume_units.addCheckbox("mute: ");
      SliderFormField volume_player = new SliderFormField("Player: ",
        Constants.options_volumeMin, Constants.options_volumeMax);
      volume_player.threshhold = Constants.optionsForm_threshhold_other;
      volume_player.addCheckbox("mute: ");
      SliderFormField map_move_speed = new SliderFormField("Camera Speed: ",
        Constants.map_minCameraSpeed, Constants.map_maxCameraSpeed);
      map_move_speed.threshhold = Constants.optionsForm_threshhold_other;
      SliderFormField inventory_bar_size = new SliderFormField("Inventory Bar Size: ", 80, 180);
      inventory_bar_size.threshhold = Constants.optionsForm_threshhold_other;
      inventory_bar_size.addCheckbox("hide: ");
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
      this.addField(inventory_bar_size);
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

      this.fields.get(9).setValue(global.profile.options.inventory_bar_size);
      if (global.profile.options.inventory_bar_hidden) {
        this.fields.get(9).disable();
      }
      else {
        this.fields.get(9).enable();
      }
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

      String hud_size = this.fields.get(9).getValue();
      if (hud_size.contains("disabled")) {
        global.profile.options.inventory_bar_hidden = true;
      }
      else {
        global.profile.options.inventory_bar_hidden = false;
      }
      global.profile.options.inventory_bar_size = toFloat(split(hud_size, ':')[0]);

      global.profile.options.change();
    }

    void buttonPress(int index) {
      switch(index) {
        case 11: // apply
          this.apply();
          break;
        case 15: // defaults
          global.profile.options.defaults();
          this.setFormFieldValues();
          break;
        default:
          break;
      }
    }

    void keyPress() {
      super.keyPress();
      if (key == 'o' && global.holding_ctrl) {
        this.cancel();
      }
    }
  }


  class AchievementsForm extends FormLNZ {
    class OpenPerkTreeButton extends RippleRectangleButton {
      OpenPerkTreeButton(float xi, float yi, float xf, float yf) {
        super(xi, yi, xf, yf);
        this.roundness = 4;
        this.show_message = true;
        this.noStroke();
        this.message = "Open Perk Tree";
        this.setColors(color(170, 170), color(1, 0), color(1, 0), color(150, 150), color(0));
        this.rippleTime = 700;
        this.text_size = 22;
      }
      @Override
      void drawButton() {
        super.drawButton();
        if (this.hovered) {
          noFill();
          stroke(150, 40, 40);
          strokeWeight(1);
          rectMode(CORNERS);
          rect(this.xi, this.yi, this.xf, this.yf, this.roundness);
        }
      }
      @Override
      void hover() {
        super.hover();
        this.color_text = color(150, 40, 40);
      }
      @Override
      void dehover() {
        super.dehover();
        this.color_text = color(0);
      }
      @Override
      void release() {
        super.release();
        if (this.hovered || this.button_focused) {
          AchievementsForm.this.submit();
        }
      }
    }

    AchievementsForm() {
      super(Constants.achievementsForm_widthOffset, Constants.achievementsForm_heightOffset,
        width - Constants.achievementsForm_widthOffset, height - Constants.achievementsForm_heightOffset);
      this.setTitleText("Achievements");
      this.setTitleSize(20);
      //this.color_background = color(180, 250, 250);
      this.color_background = color(150, 220, 220);
      this.color_header = color(50, 180, 180);
      if (global.profile == null) {
        this.canceled = true;
        return;
      }
      this.addField(new SpacerFormField(10));
      this.addField(new MessageFormField("Achievement Tokens: " + global.profile.achievement_tokens + " 〶"));
      SubmitFormField perk_tree = new SubmitFormField("");
      perk_tree.button = new OpenPerkTreeButton(0, 0, 0, 30);
      perk_tree.align_left = true;
      perk_tree.make_button_extra_tall = true;
      this.addField(perk_tree);
      this.addField(new SpacerFormField(30));
      ArrayList<MessageFormField> achievements_complete = new ArrayList<MessageFormField>();
      ArrayList<MessageFormField> achievements_incomplete = new ArrayList<MessageFormField>();
      for (AchievementCode code : AchievementCode.VALUES) {
        if (global.profile.achievements.get(code).equals(Boolean.TRUE)) {
          achievements_complete.add(new MessageFormField(code.display_name()));
        }
        else {
          achievements_incomplete.add(new MessageFormField(code.display_name()));
        }
      }
      for (MessageFormField field : achievements_complete) {
        field.text_color = color(0);
        this.addField(field);
      }
      for (MessageFormField field : achievements_incomplete) {
        field.text_color = color(170, 150);
        this.addField(field);
      }
    }

    void submit() {
      InterfaceLNZ.this.openPlayerTree();
    }

    void keyPress() {
      super.keyPress();
      if (key == 'a' && global.holding_ctrl) {
        this.cancel();
      }
    }
  }


  protected FormLNZ form = null;
  protected boolean return_to_esc_menu = false;
  protected boolean return_to_heroes_menu = false;
  protected PImage esc_menu_img = null;
  protected PImage heroes_menu_img = null;
  protected boolean showing_nerd_stats = false;

  InterfaceLNZ() {
  }

  boolean escFormOpened() {
    if (this.form == null) {
      return false;
    }
    if (EscForm.class.isInstance(this.form)) {
      return true;
    }
    return false;
  }

  void throwError(String message) {
    if (this.form != null && ErrorForm.class.isInstance(this.form)) {
      ((ErrorForm)this.form).addErrorMessage(message);
    }
    else {
      this.form = new ErrorForm(message);
    }
  }

  void achievementsForm() {
    this.form = new AchievementsForm();
  }

  void heroesForm() {
    this.form = new HeroesForm();
  }

  void openHeroForm(HeroCode code) {
    if (!global.profile.heroes.containsKey(code)) {
      return;
    }
    this.return_to_heroes_menu = true;
    this.heroes_menu_img = this.form.img;
    this.form = new HeroForm(global.profile.heroes.get(code));
  }

  void optionsForm() {
    this.form = new OptionsForm();
  }

  void openPlayerTree() {
    if (global.profile != null && !global.profile.player_tree.curr_viewing) {
      global.profile.player_tree.curr_viewing = true;
      global.profile.player_tree.setLocation(0, 0, width, height);
      global.profile.player_tree.setView(0, 0);
    }
  }

  void LNZ_update(int millis) {
    if (global.profile != null && global.profile.player_tree.curr_viewing) {
      global.setCursor("icons/cursor_white.png");
      global.profile.player_tree.update(millis);
    }
    else if (this.form == null) {
      global.defaultCursor("icons/cursor_white.png");
      this.update(millis);
    }
    else {
      global.defaultCursor("icons/cursor_white.png");
      this.form.update(millis);
      if (this.form.canceled) {
        this.form = null;
        if (this.return_to_heroes_menu) {
          this.return_to_heroes_menu = false;
          this.form = new HeroesForm();
          this.form.img = this.heroes_menu_img;
          this.heroes_menu_img = null;
        }
        else if (this.return_to_esc_menu) {
          this.return_to_esc_menu = false;
          this.form = new EscForm();
          this.form.img = this.esc_menu_img;
          this.esc_menu_img = null;
        }
        else {
          this.restartTimers();
        }
      }
    }
    if (this.showing_nerd_stats) {
      this.showNerdStats();
    }
  }

  void LNZ_mouseMove(float mX, float mY) {
    if (global.profile != null && global.profile.player_tree.curr_viewing) {
      global.profile.player_tree.mouseMove(mX, mY);
    }
    else if (this.form == null) {
      this.mouseMove(mX, mY);
    }
    else {
      this.form.mouseMove(mX, mY);
    }
  }

  void LNZ_mousePress() {
    if (global.profile != null && global.profile.player_tree.curr_viewing) {
      global.profile.player_tree.mousePress();
    }
    else if (this.form == null) {
      this.mousePress();
    }
    else {
      this.form.mousePress();
    }
  }

  void LNZ_mouseRelease(float mX, float mY) {
    if (global.profile != null && global.profile.player_tree.curr_viewing) {
      global.profile.player_tree.mouseRelease(mX, mY);
    }
    else if (this.form == null) {
      this.mouseRelease(mX, mY);
    }
    else {
      this.form.mouseRelease(mX, mY);
    }
  }

  void LNZ_scroll(int amount) {
    if (global.profile != null && global.profile.player_tree.curr_viewing) {
      global.profile.player_tree.scroll(amount);
    }
    else if (this.form == null) {
      this.scroll(amount);
    }
    else {
      this.form.scroll(amount);
    }
  }

  void LNZ_keyPress() {
    if (global.profile != null && global.profile.player_tree.curr_viewing) {
      global.profile.player_tree.keyPress();
    }
    else if (this.form == null) {
      this.keyPress();
      switch(key) {
        case ESC:
          this.openEscForm();
          break;
        case 'a':
        case 'A':
          if (this.form == null && global.holding_ctrl && global.profile != null) {
            this.form = new AchievementsForm();
          }
          break;
        case 'o':
        case 'O':
          if (this.form == null && global.holding_ctrl && global.profile != null) {
            this.form = new OptionsForm();
          }
          break;
        case 'h':
        case 'H':
          if (this.form == null && global.holding_ctrl && global.profile != null) {
            this.form = new HeroesForm();
          }
          break;
        case 'p':
        case 'P':
          if (global.holding_ctrl && global.profile != null) {
            this.openPlayerTree();
          }
          break;
        case 's':
        case 'S':
          if (global.holding_ctrl) {
            this.showing_nerd_stats = !this.showing_nerd_stats;
          }
          break;
      }
    }
    else {
      this.form.keyPress();
    }
  }

  void LNZ_keyRelease() {
    if (global.profile != null && global.profile.player_tree.curr_viewing) {
      global.profile.player_tree.keyRelease();
    }
    else if (this.form == null) {
      this.keyRelease();
    }
    else {
      this.form.keyRelease();
    }
  }


  abstract Hero getCurrentHeroIfExists();
  abstract void saveAndExitToMainMenu();
  abstract void loseFocus();
  abstract void gainFocus();
  abstract void restartTimers();
  abstract void update(int millis);
  abstract void showNerdStats();
  abstract void mouseMove(float mX, float mY);
  abstract void mousePress();
  abstract void mouseRelease(float mX, float mY);
  abstract void scroll(int amount);
  abstract void keyPress();
  abstract void openEscForm();
  abstract void keyRelease();
}
