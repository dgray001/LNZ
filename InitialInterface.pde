abstract class InterfaceLNZ {
  InterfaceLNZ() {
  }

  abstract void update(int millis);
  abstract void mouseMove(float mX, float mY);
  abstract void mousePress();
  abstract void mouseRelease();
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
      global.sounds.trigger("interfaces/buttonOn1");
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
      global.sounds.trigger("interfaces/buttonClick4");
      global.state = ProgramState.ENTERING_MAINMENU;
      background(global.color_background);
      surface.setSize(displayWidth, displayHeight);
      surface.setLocation(0, 0);
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
      global.sounds.trigger("interfaces/buttonClick3");
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
      global.sounds.trigger("interfaces/buttonClick3");
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
      global.sounds.trigger("interfaces/buttonClick3");
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
      global.sounds.trigger("interfaces/buttonClick3");
      super.release();
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

  private InitialInterfaceButton[] buttons = new InitialInterfaceButton[5];
  private LogoImageButton logo = new LogoImageButton();

  private TextBox test = new TextBox(10, 10, 280, 360);

  InitialInterface() {
    super();
    float buttonHeight = (Constants.initialInterface_size - (this.buttons.length + 1) *
      Constants.initialInterface_buttonGap) / this.buttons.length;
    this.buttons[0] = new InitialInterfaceButton1(buttonHeight);
    this.buttons[1] = new InitialInterfaceButton2(buttonHeight);
    this.buttons[2] = new InitialInterfaceButton3(buttonHeight);
    this.buttons[3] = new InitialInterfaceButton4(buttonHeight);
    this.buttons[4] = new InitialInterfaceButton5(buttonHeight);
    test.setText("THIS IS SOME TEXT WITH S O M E WO");
  }

  void update(int millis) {
    this.logo.update(millis);
    for (InitialInterfaceButton button : this.buttons) {
      button.update(millis);
    }
    test.update(millis);
  }

  void mouseMove(float mX, float mY) {
    this.logo.mouseMove(mX, mY);
    for (InitialInterfaceButton button : this.buttons) {
      button.mouseMove(mX, mY);
    }
    test.mouseMove(mX, mY);
  }

  void mousePress() {
    this.logo.mousePress();
    for (InitialInterfaceButton button : this.buttons) {
      button.mousePress();
    }
    test.mousePress();
  }

  void mouseRelease() {
    this.logo.mouseRelease();
    for (InitialInterfaceButton button : this.buttons) {
      button.mouseRelease();
    }
    test.mouseRelease();
  }

  void scroll(int amount) {
    test.scroll(amount);
  }
}
