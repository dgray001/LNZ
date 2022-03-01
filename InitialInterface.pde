abstract class InterfaceLNZ {
  InterfaceLNZ() {
  }

  abstract void update();
  abstract void mouseMove(float mX, float mY);
  abstract void mousePress();
  abstract void mouseRelease();
}

class InitialInterface extends InterfaceLNZ {

  abstract class InitialInterfaceButton extends RectangleButton {
    InitialInterfaceButton(float xi, float yi, float xf, float yf) {
      super(xi, yi, xf, yf);
      this.noStroke();
      this.setColors(color(0, 129, 50, 255), color(0, 129, 50, 120), color(0, 129, 50, 170), color(0, 129, 50, 220), color(0));
    }

    void hover() {
    }
    void dehover() {
      this.clicked = false;
    }
    void click() {
    }
    void release() {
      this.stayDehovered();
    }
  }

  class InitialInterfaceButton1 extends InitialInterfaceButton {
    InitialInterfaceButton1(float buttonHeight) {
      super(width - Constants.initialInterface_buttonWidth - Constants.initialInterface_buttonGap,
        Constants.initialInterface_buttonGap,
        width - Constants.initialInterface_buttonGap,
        Constants.initialInterface_buttonGap + buttonHeight);
    }
  }

  class InitialInterfaceButton2 extends InitialInterfaceButton {
    InitialInterfaceButton2(float buttonHeight) {
      super(width - Constants.initialInterface_buttonWidth - Constants.initialInterface_buttonGap,
        2 * Constants.initialInterface_buttonGap + buttonHeight,
        width - Constants.initialInterface_buttonGap,
        2 * Constants.initialInterface_buttonGap + 2 * buttonHeight);
    }
  }

  class InitialInterfaceButton3 extends InitialInterfaceButton {
    InitialInterfaceButton3(float buttonHeight) {
      super(width - Constants.initialInterface_buttonWidth - Constants.initialInterface_buttonGap,
        3 * Constants.initialInterface_buttonGap + 2 * buttonHeight,
        width - Constants.initialInterface_buttonGap,
        3 * Constants.initialInterface_buttonGap + 3 * buttonHeight);
    }
  }

  class InitialInterfaceButton4 extends InitialInterfaceButton {
    InitialInterfaceButton4(float buttonHeight) {
      super(width - Constants.initialInterface_buttonWidth - Constants.initialInterface_buttonGap,
        4 * Constants.initialInterface_buttonGap + 3 * buttonHeight,
        width - Constants.initialInterface_buttonGap,
        4 * Constants.initialInterface_buttonGap + 4 * buttonHeight);
    }
  }

  class InitialInterfaceButton5 extends InitialInterfaceButton {
    InitialInterfaceButton5(float buttonHeight) {
      super(width - Constants.initialInterface_buttonWidth - Constants.initialInterface_buttonGap,
        5 * Constants.initialInterface_buttonGap + 4 * buttonHeight,
        width - Constants.initialInterface_buttonGap,
        5 * Constants.initialInterface_buttonGap + 5 * buttonHeight);
    }
  }

  private InitialInterfaceButton[] buttons = new InitialInterfaceButton[5];

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

  void update() {
    background(170);
    for (InitialInterfaceButton button : this.buttons) {
      button.update();
    }
  }

  void mouseMove(float mX, float mY) {
    for (InitialInterfaceButton button : this.buttons) {
      button.mouseMove(mX, mY);
    }
  }

  void mousePress() {
    for (InitialInterfaceButton button : this.buttons) {
      button.mousePress();
    }
  }

  void mouseRelease() {
    for (InitialInterfaceButton button : this.buttons) {
      button.mouseRelease();
    }
  }
}
