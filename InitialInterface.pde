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
      super(xi, yi, xf);
    }

    void hover() {
    }
    void dehover() {
    }
    void click() {
    }
    void release() {
    }
  }

  class InitialInterfaceButton1 extends InitialInterfaceButton {
    InitialInterfaceButton1() {
      super(100, 100, 20, 30);
    }
  }

  private InitialInterfaceButton1 button = new InitialInterfaceButton1();

  InitialInterface() {
    super();
  }

  void update() {
    this.button.update();
  }

  void mouseMove(float mX, float mY) {
    this.button.mouseMove(mX, mY);
  }

  void mousePress() {
    this.button.mousePress();
  }

  void mouseRelease() {
    this.button.mouseRelease();
  }
}
