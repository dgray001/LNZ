
class MainMenuInterface extends InterfaceLNZ {

  class MainMenuGrowButton extends RippleRectangleButton {
    protected float xf_grow;
    protected float ratio; // ratio when shrunk (can have it be > 1 to make it shrink when hovered)
    protected float grow_speed = 0.7; // pixels / ms

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


  class backgroundImageThread extends Thread {
    private PImage img = createImage(width, height, ARGB);
    private float distance_threshhold = 150;
    private float mX = mouseX;
    private float mY = mouseY;

    backgroundImageThread() {
      super("backgroundImageThread");
    }

    @Override
    void run() {
      DImg dimg = new DImg(this.img);
      dimg.makeTransparent(255);
      dimg.addImagePercent(global.images.getImage("hillary.png"), 0, 0, 1, 1);
      dimg.brightenGradient(0, this.distance_threshhold, this.mX, this.mY);
      this.img = dimg.img;
    }
  }

  private MainMenuGrowButton test = new MainMenuGrowButton(0, 500, 200, 560, 0.3);
  private PImage backgroundImage;
  backgroundImageThread thread = new backgroundImageThread();

  MainMenuInterface() {
    super();
    this.backgroundImage = createImage(width, height, ARGB);
  }

  void update() {
    // draw background
    imageMode(CORNER);
    image(this.backgroundImage, 0, 0);
    // update elements
    test.update();
    // restart thread
    if (!this.thread.isAlive()) {
      this.backgroundImage = this.thread.img;
      this.thread = new backgroundImageThread();
      this.thread.start();
    }
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
