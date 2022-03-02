
class MainMenuInterface extends InterfaceLNZ {

  class MainMenuGrowButton extends RippleRectangleButton {
    protected float xf_grow;
    protected float ratio; // ratio when shrunk (can have it be > 1 to make it shrink when hovered)
    protected float grow_speed = 0.8; // pixels / ms

    MainMenuGrowButton(float xi, float yi, float xf, float yf, float ratio) {
      super(xi, yi, xf * ratio, yf);
      this.xf_grow = xf;
      this.ratio = ratio;
      this.maxRippleDistance = xf - xi;
    }

    @Override
    void update() {
      int timeElapsed = millis() - this.lastUpdateTime;
      float pixelsMoved = timeElapsed * this.grow_speed;
      super.update();
      float pixelsLeft = 0;
      int pixelsToMove = 0;
      if (this.hovered) {
        pixelsLeft = this.xf_grow - this.xf;
        pixelsToMove = int(ceil(min(pixelsLeft, pixelsMoved)));
        if (pixelsToMove > 0) {
          this.stretchButton(pixelsToMove, RIGHT);
        }
      }
      else {
        pixelsLeft = this.xf_grow * this.ratio - this.xf;
        pixelsToMove = int(floor(max(pixelsLeft, -pixelsMoved)));
        if (pixelsToMove < 0) {
          this.stretchButton(pixelsToMove, RIGHT);
        }
      }
    }
  }


  private MainMenuGrowButton test = new MainMenuGrowButton(0, 500, 200, 560, 0.3);

  MainMenuInterface() {
    super();
  }

  void update() {
    // draw background
    background(global.color_background);
    test.update();
  }

  void mouseMove(float mX, float mY) {
    test.mouseMove(mX, mY);
  }

  void mousePress() {
    test.mousePress();
  }

  void mouseRelease() {
    test.mouseRelease();
  }
}
