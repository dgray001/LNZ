abstract class Button {
  // state
  protected boolean hidden = false;
  protected boolean disabled = false;
  protected boolean hovered = false;
  protected boolean clicked = false;
  // colors
  protected color color_disabled = color(220, 180);
  protected color color_default = color(220);
  protected color color_hover = color(170);
  protected color color_click = color(120);
  protected color color_text = color(0);
  protected color color_stroke = color(0);
  // config
  protected String message = "";
  protected boolean show_message = false;
  protected int text_size = 14;
  protected boolean show_stroke = true;
  protected float stroke_weight = 0.5;
  protected boolean stay_dehovered = false;

  Button() {
  }

  void setColors(color c_dis, color c_def, color c_hov, color c_cli, color c_tex) {
    this.color_disabled = c_dis;
    this.color_default = c_def;
    this.color_hover = c_hov;
    this.color_click = c_cli;
    this.color_text = c_tex;
  }

  void setStroke(color c_str, float stroke_weight) {
    this.color_stroke = c_str;
    this.stroke_weight = stroke_weight;
    this.show_stroke = true;
  }
  void noStroke() {
    this.show_stroke = false;
  }

  color fillColor() {
    if (this.disabled) {
      return this.color_disabled;
    }
    else if (this.clicked) {
      return this.color_click;
    }
    else if (this.hovered) {
      return this.color_hover;
    }
    else {
      return this.color_default;
    }
  }

  void setFill() {
    fill(this.fillColor());
    if (this.show_stroke) {
      stroke(this.color_stroke);
      strokeWeight(this.stroke_weight);
    }
    else {
      strokeWeight(0.0001);
      noStroke();
    }
  }

  void writeText() {
    if (this.show_message) {
      fill(this.color_text);
      textAlign(CENTER, CENTER);
      textSize(this.text_size);
      text(this.message, this.xCenter(), this.yCenter());
    }
  }


  void stayDehovered() {
    this.stay_dehovered = true;
    this.hovered = false;
  }

  void update() {
    if (!this.hidden) {
      drawButton();
    }
  }

  void mouseMove(float mX, float mY) {
    if (this.disabled) {
      return;
    }
    boolean prev_hover = this.hovered;
    this.hovered = this.mouseOn(mX, mY);
    if (this.stay_dehovered) {
      if (this.hovered) {
        this.hovered = false;
      }
      else {
        this.stay_dehovered = false;
      }
    }
    if (prev_hover && !this.hovered) {
      this.dehover();
    }
    else if (!prev_hover && this.hovered) {
      this.hover();
    }
  }

  void mousePress() {
    if (this.disabled) {
      return;
    }
    if (this.hovered) {
      this.clicked = true;
      this.click();
    }
    else {
      this.clicked = false;
    }
  }

  void mouseRelease() {
    if (this.disabled) {
      return;
    }
    if (this.clicked) {
      this.clicked = false;
      this.release();
    }
    this.clicked = false;
  }

  abstract float xCenter();
  abstract float yCenter();
  abstract float button_width();
  abstract float button_height();
  abstract void drawButton();
  abstract void moveButton(float xMove, float yMove);
  abstract boolean mouseOn(float mX, float mY);
  abstract void hover();
  abstract void dehover();
  abstract void click();
  abstract void release();
}



abstract class RectangleButton extends Button {
  protected float xi;
  protected float yi;
  protected float xf;
  protected float yf;
  protected int roundness = 8;
  protected float xCenter;
  protected float yCenter;

  RectangleButton(float xi, float yi, float xf, float yf) {
    super();
    this.setLocation(xi, yi, xf, yf);
  }

  float xCenter() {
    return this.xCenter;
  }

  float yCenter() {
    return this.yCenter;
  }

  float button_width() {
    return this.xf - this.xi;
  }

  float button_height() {
    return this.yf - this.yi;
  }

  void drawButton() {
    this.setFill();
    rectMode(CORNERS);
    rect(this.xi, this.yi, this.xf, this.yf, this.roundness);
    if (this.show_message) {
      this.writeText();
    }
  }

  void setLocation(float xi, float yi, float xf, float yf) {
    this.xi = xi;
    this.yi = yi;
    this.xf = xf;
    this.yf = yf;
    this.xCenter = this.xi + 0.5 * (this.xf - this.xi);
    this.yCenter = this.yi + 0.5 * (this.yf - this.yi);
  }

  void moveButton(float xMove, float yMove) {
    this.xi += xMove;
    this.yi += yMove;
    this.xf += xMove;
    this.yf += yMove;
    this.xCenter = this.xi + 0.5 * (this.xf - this.xi);
    this.yCenter = this.yi + 0.5 * (this.yf - this.yi);
  }

  void stretchButton(float amount, int direction) {
    switch(direction) {
      case UP:
        this.setLocation(this.xi, this.yi - amount, this.xf, this.yf);
        break;
      case DOWN:
        this.setLocation(this.xi, this.yi, this.xf, this.yf + amount);
        break;
      case LEFT:
        this.setLocation(this.xi - amount, this.yi, this.xf, this.yf);
        break;
      case RIGHT:
        this.setLocation(this.xi, this.yi, this.xf + amount, this.yf);
        break;
      default:
        break;
    }
  }

  boolean mouseOn(float mX, float mY) {
    if (mX >= this.xi && mY >= this.yi &&
      mX <= this.xf && mY <= this.yf) {
      return true;
    }
    return false;
  }
}


abstract class ImageButton extends RectangleButton {
  protected PImage img;
  protected color color_tint = color(255);

  ImageButton(PImage img, float xi, float yi, float xf, float yf) {
    super(xi, yi, xf, yf);
    this.img = img;
  }

  @Override
  void drawButton() {
    tint(this.color_tint);
    imageMode(CORNERS);
    image(this.img, this.xi, this.yi, this.xf, this.yf);
    noTint();
  }
}


abstract class RippleRectangleButton extends ImageButton {
  class Pixel {
    private int x;
    private int y;
    private float x_pixel;
    private float y_pixel;
    Pixel(int x, int y, float x_pixel, float y_pixel) {
      this.x = x;
      this.y = y;
      this.x_pixel = x_pixel;
      this.y_pixel = y_pixel;
    }
    float distance(float mX, float mY) {
      return sqrt((mX - this.x_pixel) * (mX - this.x_pixel) +
        (mY - this.y_pixel) * (mY - this.y_pixel));
    }
  }

  protected int rippleTime = 250;
  protected int rippleTimer = 0;
  protected int lastUpdateTime = millis();
  protected int number_buckets = 50;
  protected HashMap<Integer, ArrayList<Pixel>> buckets;
  protected float clickX = 0;
  protected float clickY = 0;
  protected float maxRippleDistance;

  RippleRectangleButton(float xi, float yi, float xf, float yf) {
    super(createImage(int(xf - xi), int(yf - yi), RGB), xi, yi, xf, yf);
    this.refreshColor();
    this.maxRippleDistance = max(this.button_width(), this.button_height());
  }

  @Override
  void update() {
    super.update();
    int timeElapsed = millis() - this.lastUpdateTime;
    this.lastUpdateTime = millis();
    if (this.rippleTimer > 0) {
      this.rippleTimer -= timeElapsed;
      if (this.rippleTimer <= 0) {
        this.refreshColor();
      }
      else {
        this.colorPixels();
      }
    }
  }

  @Override
  void drawButton() {
    tint(this.color_tint);
    imageMode(CORNERS);
    image(this.img, this.xi, this.yi, this.xf, this.yf);
    noTint();
  }

  void refreshColor() {
    DImg dimg = new DImg(this.img);
    dimg.colorPixels(this.fillColor());
    this.img = dimg.img;
    this.rippleTimer = 0;
  }

  void initializeRipple() {
    this.buckets = new HashMap<Integer, ArrayList<Pixel>>();
    for (int i = 0; i < this.number_buckets; i++) {
      this.buckets.put(i, new ArrayList<Pixel>());
    }
    float keyMultiplier = float(this.rippleTime) / this.number_buckets;
    for (int i = 0; i < this.img.height; i++) {
      for (int j = 0; j < this.img.width; j++) {
        float x = this.xi + this.button_width() * j / this.img.width;
        float y = this.yi + this.button_height() * i / this.img.height;
        Pixel p = new Pixel(j, i, x, y);
        float distance = p.distance(this.clickX, this.clickY);
        int timer = int(floor(this.rippleTime * (1 - distance / this.maxRippleDistance) / keyMultiplier));
        if (this.buckets.containsKey(timer)) {
          this.buckets.get(timer).add(p);
        }
      }
    }
    this.rippleTimer = this.rippleTime;
  }

  void colorPixels() {
    DImg dimg = new DImg(this.img);
    float currDistance = this.maxRippleDistance * (this.rippleTime - this.rippleTimer) / this.rippleTime;
    float keyMultiplier = float(this.rippleTime) / this.number_buckets;
    for (Map.Entry<Integer, ArrayList<Pixel>> entry : this.buckets.entrySet()) {
      if (entry.getKey() * keyMultiplier > this.rippleTimer) {
        for (Pixel p : entry.getValue()) {
          dimg.colorPixel(p.x, p.y, this.color_click);
        }
        entry.getValue().clear();
      }
    }
  }

  void hover() {
    this.refreshColor();
  }

  void dehover() {
    this.refreshColor();
  }

  void click() {
    this.clickX = mouseX;
    this.clickY = mouseY;
    this.initializeRipple();
  }

  void release() {
    this.refreshColor();
  }
}




abstract class EllipseButton extends Button {
  protected float xc;
  protected float yc;
  protected float xr;
  protected float yr;

  EllipseButton(float xc, float yc, float xr, float yr) {
    super();
    this.xc = xc;
    this.yc = yc;
    this.xr = xr;
    this.yr = yr;
  }

  float xCenter() {
    return this.xc;
  }

  float yCenter() {
    return this.yc;
  }

  float button_width() {
    return 2 * this.xr;
  }

  float button_height() {
    return 2 * this.yr;
  }

  void drawButton() {
    this.setFill();
    ellipseMode(RADIUS);
    ellipse(this.xc, this.yc, this.xr, this.yr);
    this.writeText();
  }

  void moveButton(float xMove, float yMove) {
    this.xc += xMove;
    this.yc += yMove;
  }

  boolean mouseOn(float mX, float mY) {
    if (this.xr == 0 || this.yr == 0) {
      return false;
    }
    float xRatio = (mX - this.xc) / this.xr;
    float yRatio = (mY - this.yc) / this.yr;
    if (xRatio * xRatio + yRatio * yRatio <= 1) {
      return true;
    }
    return false;
  }
}



abstract class CircleButton extends EllipseButton {
  CircleButton(float xc, float yc, float r) {
    super(xc, yc, r, r);
  }
}



abstract class TriangleButton extends Button {
  protected float x1;
  protected float y1;
  protected float x2;
  protected float y2;
  protected float x3;
  protected float y3;
  protected float dotvv;
  protected float dotuu;
  protected float dotvu;
  protected float constant;
  protected float xCenter;
  protected float yCenter;

  TriangleButton(float x1, float y1, float x2, float y2, float x3, float y3) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.x3 = x3;
    this.y3 = y3;
    this.dotvv = (x3 - x1) * (x3 - x1) + (y3 - y1) * (y3 - y1);
    this.dotuu = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
    this.dotvu = (x3 - x1) * (x2 - x1) + (y3 - y1) * (y2 - y1);
    this.constant = this.dotvv * this.dotuu - this.dotvu * this.dotvu;
    this.xCenter = (x1 + x2 + x3) / 3.0;
    this.yCenter = (y1 + y2 + y3) / 3.0;
  }

  float xCenter() {
    return this.xCenter;
  }

  float yCenter() {
    return this.yCenter;
  }

  void drawButton() {
    this.setFill();
    triangle(this.x1, this.y1, this.x2, this.y2, this.x3, this.y3);
    this.writeText();
  }

  void moveButton(float xMove, float yMove) {
    this.x1 += xMove;
    this.y1 += yMove;
    this.x2 += xMove;
    this.y2 += yMove;
    this.x3 += xMove;
    this.y3 += yMove;
  }

  boolean mouseOn(float mX, float mY) {
    float dotvp = (this.x3 - this.x1) * (mX - this.x1) + (this.y3 - this.y1) * (mY - this.y1);
    float dotup = (this.x2 - this.y1) * (mX - this.x1) + (this.y2 - this.y1) * (mY - this.y1);
    if (this.constant == 0) {
      return false;
    }
    float t1 = (this.dotuu * dotvp - this.dotvu * dotup) / this.constant;
    float t2 = (this.dotvv * dotup - this.dotvu * dotvp) / this.constant;
    println(t1, t2);
    if (t1 >= 0 && t2 >= 0 && t1 + t2 < 1) {
      return true;
    }
    return false;
  }
}
