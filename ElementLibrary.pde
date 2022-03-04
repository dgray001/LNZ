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
  // timer
  protected int hold_timer = 0;
  protected int lastUpdateTime = millis();

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

  void update(int millis) {
    if (!this.hidden) {
      drawButton();
      if (this.clicked) {
        this.hold_timer += millis - this.lastUpdateTime;
      }
    }
    this.lastUpdateTime = millis;
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
      this.hold_timer = 0;
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
    this.writeText();
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
    this.writeText();
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
  protected int number_buckets = 50;
  protected HashMap<Integer, ArrayList<Pixel>> buckets;
  protected float clickX = 0;
  protected float clickY = 0;
  protected float maxRippleDistance;

  RippleRectangleButton(float xi, float yi, float xf, float yf) {
    super(createImage(int(xf - xi), int(yf - yi), ARGB), xi, yi, xf, yf);
    this.refreshColor();
    this.maxRippleDistance = max(this.button_width(), this.button_height());
  }

  @Override
  void update(int millis) {
    int timeElapsed = millis - this.lastUpdateTime;
    super.update(millis);
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






class ScrollBar {
  abstract class ScrollBarButton extends RectangleButton {
    protected int time_hold = 350;
    protected int time_click = 80;
    protected boolean held = false;

    ScrollBarButton(float xi, float yi, float xf, float yf) {
      super(xi, yi, xf, yf);
      this.roundness = 0;
    }

    @Override
    void update(int millis) {
      super.update(millis);
      if (this.clicked) {
        if (this.held) {
          if (this.hold_timer > this.time_click) {
            this.hold_timer -= this.time_click;
            this.click();
          }
        }
        else {
          if (this.hold_timer > this.time_hold) {
            this.hold_timer -= this.time_hold;
            this.held = true;
            this.click();
          }
        }
      }
    }

    void hover() {
    }
    void dehover() {
    }
    void release() {
      this.held = false;
    }
  }

  class ScrollBarUpButton extends ScrollBarButton {
    ScrollBarUpButton(float xi, float yi, float xf, float yf) {
      super(xi, yi, xf, yf);
    }
    @Override
    void dehover() {
      this.clicked = false;
    }
    void click() {
      ScrollBar.this.decreaseValue(1);
    }
  }

  class ScrollBarDownButton extends ScrollBarButton {
    ScrollBarDownButton(float xi, float yi, float xf, float yf) {
      super(xi, yi, xf, yf);
    }
    @Override
    void dehover() {
      this.clicked = false;
    }
    void click() {
      ScrollBar.this.increaseValue(1);
    }
  }

  class ScrollBarUpSpaceButton extends ScrollBarButton {
    ScrollBarUpSpaceButton(float xi, float yi, float xf, float yf) {
      super(xi, yi, xf, yf);
      this.setColors(color(170, 0), color(170, 0), color(170, 0), color(0), color(0));
    }
    void click() {
      ScrollBar.this.decreaseValuePercent(0.1);
    }
  }

  class ScrollBarDownSpaceButton extends ScrollBarButton {
    ScrollBarDownSpaceButton(float xi, float yi, float xf, float yf) {
      super(xi, yi, xf, yf);
      this.setColors(color(170, 0), color(170, 0), color(170, 0), color(0), color(0));
    }
    void click() {
      ScrollBar.this.increaseValuePercent(0.1);
    }
  }

  class ScrollBarBarButton extends ScrollBarButton {
    protected float val = 0;
    ScrollBarBarButton(float xi, float yi, float xf, float yf) {
      super(xi, yi, xf, yf);
    }
    @Override
    void update(int millis) {
      if (!this.hidden) {
        drawButton();
        if (this.clicked) {
          this.hold_timer += millis - this.lastUpdateTime;
          if (ScrollBar.this.vertical) {
            ScrollBar.this.increaseValue((mouseY - this.val) / ScrollBar.this.value_size);
          }
          else {
            ScrollBar.this.increaseValue((mouseX - this.val) / ScrollBar.this.value_size);
          }
          this.click();
        }
      }
      this.lastUpdateTime = millis;
    }
    void click() {
      if (ScrollBar.this.vertical) {
        this.val = mouseY;
      }
      else {
        this.val = mouseX;
      }
    }
  }

  protected ScrollBarUpButton button_up = new ScrollBarUpButton(0, 0, 0, 0);
  protected ScrollBarDownButton button_down = new ScrollBarDownButton(0, 0, 0, 0);
  protected ScrollBarUpSpaceButton button_upspace = new ScrollBarUpSpaceButton(0, 0, 0, 0);
  protected ScrollBarDownSpaceButton button_downspace = new ScrollBarDownSpaceButton(0, 0, 0, 0);
  protected ScrollBarBarButton button_bar = new ScrollBarBarButton(0, 0, 0, 0);

  protected float minValue = 0;
  protected float maxValue = 0;
  protected float value = 0;

  protected float xi;
  protected float yi;
  protected float xf;
  protected float yf;
  protected boolean vertical;
  protected float bar_size = 0;
  protected float min_size = 0;
  protected float value_size = 0;
  protected float step_size = 10; // constant

  ScrollBar(float xi, float yi, float xf, float yf, boolean vertical) {
    this.vertical = vertical;
    this.setLocation(xi, yi, xf, yf);
  }

  void setLocation(float xi, float yi, float xf, float yf) {
    this.xi = xi;
    this.yi = yi;
    this.xf = xf;
    this.yf = yf;
    if (this.vertical) {
      this.bar_size = this.xf - this.xi;
      if (3 * this.bar_size > this.yf - this.yi) {
        this.bar_size = (this.yf - this.yi) / 3.0;
        this.min_size = 0.5 * this.bar_size;
      }
      else {
        this.min_size = min(this.bar_size, (this.yf - this.yi) / 9.0);
      }
      this.button_up.setLocation(this.xi, this.yi, this.xf, this.yi + this.bar_size);
      this.button_down.setLocation(this.xi, this.yf - this.bar_size, this.xf, this.yf);
    }
    else {
      this.bar_size = this.yf - this.yi;
      if (3 * this.bar_size > this.xf - this.xi) {
        this.bar_size = (this.xf - this.xi) / 3.0;
        this.min_size = 0.5 * this.bar_size;
      }
      else {
        this.min_size = min(this.bar_size, (this.xf - this.xi) / 9.0);
      }
      this.button_up.setLocation(this.xi, this.yi, this.xi + this.bar_size, this.yf);
      this.button_down.setLocation(this.xf - this.bar_size, this.yi, this.xf, this.yf);
    }
    this.refreshBarButtonSizes();
  }

  void refreshBarButtonSizes() {
    float bar_height = 0;
    if (this.vertical) {
      bar_height = this.yf - this.yi - 2 * this.bar_size;
    }
    else {
      bar_height = this.xf - this.xi - 2 * this.bar_size;
    }
    float bar_button_size = max(this.min_size, bar_height - this.step_size * (this.maxValue - this.minValue));
    if (this.maxValue == this.minValue) {
      this.value_size = 0;
    }
    else {
      this.value_size = (bar_height - bar_button_size) / (this.maxValue - this.minValue);
    }
    this.refreshBarButtons();
  }

  void refreshBarButtons() {
    if (this.vertical) {
      float cut_one = this.yi + this.bar_size + this.value_size * (this.value - this.minValue);
      float cut_two = this.yf - this.bar_size - this.value_size * (this.maxValue - this.value);
      this.button_upspace.setLocation(this.xi, this.yi + this.bar_size, this.xf, cut_one);
      this.button_downspace.setLocation(this.xi, cut_two, this.xf, this.yf - this.bar_size);
      this.button_bar.setLocation(this.xi, cut_one, this.xf, cut_two);
    }
    else {
      float cut_one = this.xi + this.bar_size + this.value_size * (this.value - this.minValue);
      float cut_two = this.xf - this.bar_size - this.value_size * (this.maxValue - this.value);
      this.button_upspace.setLocation(this.xi + this.bar_size, this.yi, cut_one, this.yf);
      this.button_downspace.setLocation(cut_two, this.yi, this.xf - this.bar_size, this.yf);
      this.button_bar.setLocation(cut_one, this.yi, cut_two, this.yf);
    }
  }

  void updateMinValue(float minValue) {
    this.minValue = minValue;
    if (this.minValue > this.maxValue) {
      this.minValue = this.maxValue;
    }
    if (this.value < this.minValue) {
      this.value = this.minValue;
    }
    this.refreshBarButtonSizes();
  }

  void updateMaxValue(float maxValue) {
    this.maxValue = maxValue;
    if (this.maxValue < this.minValue) {
      this.maxValue = this.minValue;
    }
    if (this.value > this.maxValue) {
      this.value = this.maxValue;
    }
    this.refreshBarButtonSizes();
  }

  void updateValue(float value) {
    this.value = value;
    if (this.value < this.minValue) {
      this.value = this.minValue;
    }
    else if (this.value > this.maxValue) {
      this.value = this.maxValue;
    }
    this.refreshBarButtons();
  }

  void increaseValue(float amount) {
    this.updateValue(this.value + amount);
  }
  void decreaseValue(float amount) {
    this.updateValue(this.value - amount);
  }
  void increaseValuePercent(float percent) {
    this.updateValue(this.value + percent * (this.maxValue - this.minValue));
  }
  void decreaseValuePercent(float percent) {
    this.updateValue(this.value - percent * (this.maxValue - this.minValue));
  }

  void update(int millis) {
    this.button_up.update(millis);
    this.button_down.update(millis);
    this.button_upspace.update(millis);
    this.button_downspace.update(millis);
    this.button_bar.update(millis);
  }

  void mouseMove(float mX, float mY) {
    this.button_up.mouseMove(mX, mY);
    this.button_down.mouseMove(mX, mY);
    this.button_upspace.mouseMove(mX, mY);
    this.button_downspace.mouseMove(mX, mY);
    this.button_bar.mouseMove(mX, mY);
  }

  void mousePress() {
    this.button_up.mousePress();
    this.button_down.mousePress();
    this.button_upspace.mousePress();
    this.button_downspace.mousePress();
    this.button_bar.mousePress();
  }

  void mouseRelease() {
    this.button_up.mouseRelease();
    this.button_down.mouseRelease();
    this.button_upspace.mouseRelease();
    this.button_downspace.mouseRelease();
    this.button_bar.mouseRelease();
  }
}
