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
  protected float text_size = 14;
  protected boolean show_stroke = true;
  protected float stroke_weight = 0.5;
  protected boolean stay_dehovered = false;
  protected boolean adjust_for_text_descent = false;
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
      if (this.adjust_for_text_descent) {
        text(this.message, this.xCenter(), this.yCenter() - textDescent());
      }
      else {
        text(this.message, this.xCenter(), this.yCenter());
      }
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
    if (mouseButton != LEFT) {
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
    if (mouseButton != LEFT) {
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
  protected boolean raised_border = false;
  protected boolean raised_body = false;
  protected boolean shadow = false;
  protected float shadow_amount = 5;

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
    rectMode(CORNERS);
    if (this.shadow) {
      fill(0, 180);
      rect(this.xi + this.shadow_amount, this.yi + this.shadow_amount,
        this.xf + this.shadow_amount, this.yf + this.shadow_amount, this.roundness);
    }
    this.setFill();
    if (this.shadow && this.clicked) {
      translate(this.shadow_amount, this.shadow_amount);
    }
    if (this.raised_body) {
      fill(255, 0);
      rect(this.xi, this.yi, this.xf, this.yf, this.roundness);
      stroke(255, 0);
      if (this.clicked) {
        fill(darken(this.fillColor()));
        rect(this.xi, this.yi, this.xf, this.yCenter());
        fill(brighten(this.fillColor()));
        rect(this.xi, this.yCenter(), this.xf, this.yf);
      }
      else {
        fill(brighten(this.fillColor()));
        rect(this.xi, this.yi, this.xf, this.yCenter(), this.roundness);
        fill(darken(this.fillColor()));
        rect(this.xi, this.yCenter(), this.xf, this.yf, this.roundness);
      }
    }
    else {
      rect(this.xi, this.yi, this.xf, this.yf, this.roundness);
    }
    this.writeText();
    if (this.shadow && this.clicked) {
      translate(-this.shadow_amount, -this.shadow_amount);
    }
    if (this.raised_border) {
      strokeWeight(1);
      if (this.clicked) {
        stroke(0);
        line(this.xi, this.yi, this.xf, this.yi);
        line(this.xi, this.yi, this.xi, this.yf);
        stroke(255);
        line(this.xf, this.yf, this.xf, this.yi);
        line(this.xf, this.yf, this.xi, this.yf);
      }
      else {
        stroke(255);
        line(this.xi, this.yi, this.xf, this.yi);
        line(this.xi, this.yi, this.xi, this.yf);
        stroke(0);
        line(this.xf, this.yf, this.xf, this.yi);
        line(this.xf, this.yf, this.xi, this.yf);
      }
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


abstract class CheckBox extends RectangleButton {
  protected boolean checked = false;
  protected color color_check = color(0);
  protected float offset = 0;

  CheckBox(float xi, float yi, float size) {
    this(xi, yi, xi + size, xi + size);
  }
  CheckBox(float xi, float yi, float xf, float yf) {
    super(xi, yi, xf, yf);
    this.setColors(color(170, 170), color(170, 0), color(170, 50), color(170, 120), color(0));
    this.roundness = 0;
    this.stroke_weight = 2;
  }

  @Override
  void setLocation(float xi, float yi, float xf, float yf) {
    super.setLocation(xi, yi, xf, yf);
    this.offset = 0.1 * (xf  - xi);
  }

  @Override
  void drawButton() {
    super.drawButton();
    if (this.checked) {
      strokeWeight(this.stroke_weight);
      stroke(this.color_stroke);
      line(this.xi + offset, this.yi + offset, this.xf - offset, this.yf - offset);
      line(this.xi + offset, this.yf - offset, this.xf - offset, this.yi + offset);
    }
  }

  void click() {
    this.checked = !this.checked;
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

  void setLocation(float xc, float yc, float xr, float yr) {
    this.xc = xc;
    this.yc = yc;
    this.xr = xr;
    this.yr = yr;
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
  float radius() {
    return this.xr;
  }

  void setLocation(float xc, float yc, float radius) {
    super.setLocation(xc, yc, radius, radius);
  }
}



abstract class RadioButton extends CircleButton {
  protected boolean checked = false;
  protected color color_active = color(0);

  RadioButton(float xc, float yc, float r) {
    super(xc, yc, r);
    this.setColors(color(170, 120), color(170, 0), color(170, 40), color(170, 80), color(0));
  }

  @Override
  void drawButton() {
    super.drawButton();
    if (this.checked) {
      fill(this.color_active);
      ellipseMode(RADIUS);
      circle(this.xCenter(), this.yCenter(), 0.6 * this.radius());
    }
    if (this.clicked) {
      fill(this.color_active, 135);
      ellipseMode(RADIUS);
      circle(this.xCenter(), this.yCenter(), 1.4 * this.radius());
    }
  }

  void click() {
    this.checked = !this.checked;
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
    float arrowWidth = 0;
    float arrowRatio = 0.1;
    float cushionRatio = 1.5;
    ScrollBarUpButton(float xi, float yi, float xf, float yf) {
      super(xi, yi, xf, yf);
      refreshArrowWidth();
      this.raised_border = true;
    }
    @Override
    void setLocation(float xi, float yi, float xf, float yf) {
      super.setLocation(xi, yi, xf, yf);
      this.refreshArrowWidth();
    }
    void refreshArrowWidth() {
      if (ScrollBar.this.vertical) {
        this.arrowWidth = this.arrowRatio * this.button_height();
      }
      else {
        this.arrowWidth = this.arrowRatio * this.button_width();
      }
    }
    @Override
    void drawButton() {
      super.drawButton();
      stroke(0);
      strokeWeight(this.arrowWidth);
      if (ScrollBar.this.vertical) {
        line(this.xi + this.cushionRatio * this.arrowWidth, this.yf - this.cushionRatio * this.arrowWidth,
          this.xCenter(), this.yi + this.cushionRatio * this.arrowWidth);
        line(this.xf - this.cushionRatio * this.arrowWidth, this.yf - this.cushionRatio * this.arrowWidth,
          this.xCenter(), this.yi + this.cushionRatio * this.arrowWidth);
      }
      else {
        line(this.xf - this.cushionRatio * this.arrowWidth, this.yi + this.cushionRatio * this.arrowWidth,
          this.xi + this.cushionRatio * this.arrowWidth, this.yCenter());
        line(this.xf - this.cushionRatio * this.arrowWidth, this.yf - this.cushionRatio * this.arrowWidth,
          this.xi + this.cushionRatio * this.arrowWidth, this.yCenter());
      }
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
    float arrowWidth = 0;
    float arrowRatio = 0.1;
    float cushionRatio = 1.5;
    ScrollBarDownButton(float xi, float yi, float xf, float yf) {
      super(xi, yi, xf, yf);
      refreshArrowWidth();
      this.raised_border = true;
    }
    @Override
    void setLocation(float xi, float yi, float xf, float yf) {
      super.setLocation(xi, yi, xf, yf);
      this.refreshArrowWidth();
    }
    void refreshArrowWidth() {
      if (ScrollBar.this.vertical) {
        this.arrowWidth = this.arrowRatio * this.button_height();
      }
      else {
        this.arrowWidth = this.arrowRatio * this.button_width();
      }
    }
    @Override
    void drawButton() {
      super.drawButton();
      stroke(0);
      strokeWeight(this.arrowWidth);
      if (ScrollBar.this.vertical) {
        line(this.xi + this.cushionRatio * this.arrowWidth, this.yi + this.cushionRatio * this.arrowWidth,
          this.xCenter(), this.yf - this.cushionRatio * this.arrowWidth);
        line(this.xf - this.cushionRatio * this.arrowWidth, this.yi + this.cushionRatio * this.arrowWidth,
          this.xCenter(), this.yf - this.cushionRatio * this.arrowWidth);
      }
      else {
        line(this.xi + this.cushionRatio * this.arrowWidth, this.yi + this.cushionRatio * this.arrowWidth,
          this.xf - this.cushionRatio * this.arrowWidth, this.yCenter());
        line(this.xi + this.cushionRatio * this.arrowWidth, this.yf - this.cushionRatio * this.arrowWidth,
          this.xf - this.cushionRatio * this.arrowWidth, this.yCenter());
      }
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
      this.setColors(color(180), color(235), color(235), color(0), color(0));
    }
    void click() {
      ScrollBar.this.decreaseValuePercent(0.1);
    }
    @Override
    void release() {
      super.release();
      this.hovered = false;
    }
  }

  class ScrollBarDownSpaceButton extends ScrollBarButton {
    ScrollBarDownSpaceButton(float xi, float yi, float xf, float yf) {
      super(xi, yi, xf, yf);
      this.setColors(color(180), color(235), color(235), color(0), color(0));
    }
    void click() {
      ScrollBar.this.increaseValuePercent(0.1);
    }
    @Override
    void release() {
      super.release();
      this.hovered = false;
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
        if (this.clicked && ScrollBar.this.value_size != 0) {
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

  ScrollBar(boolean vertical) {
    this(0, 0, 0, 0, vertical);
  }
  ScrollBar(float xi, float yi, float xf, float yf, boolean vertical) {
    this.vertical = vertical;
    this.setLocation(xi, yi, xf, yf);
  }

  void move(float xMove, float yMove) {
    this.xi += xMove;
    this.yi += yMove;
    this.xf += xMove;
    this.yf += yMove;
    this.button_up.moveButton(xMove, yMove);
    this.button_down.moveButton(xMove, yMove);
    this.button_upspace.moveButton(xMove, yMove);
    this.button_downspace.moveButton(xMove, yMove);
    this.button_bar.moveButton(xMove, yMove);
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
  void increaseMinValue(float amount) {
    this.updateMinValue(this.minValue + amount);
  }
  void decreaseMinValue(float amount) {
    this.updateMinValue(this.minValue - amount);
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
  void increaseMaxValue(float amount) {
    this.updateMaxValue(this.maxValue + amount);
  }
  void decreaseMaxValue(float amount) {
    this.updateMaxValue(this.maxValue - amount);
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



class TextBox {
  protected float xi = 0;
  protected float yi = 0;
  protected float xf = 0;
  protected float yf = 0;
  protected boolean hovered = false;
  protected int lastUpdateTime = 0;

  protected ScrollBar scrollbar = new ScrollBar(true);
  protected float scrollbar_max_width = 50;
  protected float scrollbar_min_width = 25;

  protected String text_ref = "";
  protected ArrayList<String> text_lines = new ArrayList<String>();
  protected float text_size = 15;
  protected float text_leading = 0;

  protected String text_title_ref = null;
  protected String text_title = null;
  protected float title_size = 22;

  protected color color_background = color(250);
  protected color color_header = color(200);
  protected color color_stroke = color(0);
  protected color color_text = color(0);
  protected color color_title = color(0);

  TextBox() {
    this(0, 0, 0, 0);
  }
  TextBox(float xi, float yi, float xf, float yf) {
    this.setLocation(xi, yi, xf, yf);
  }

  void setLocation(float xi, float yi, float xf, float yf) {
    this.xi = xi;
    this.yi = yi;
    this.xf = xf;
    this.yf = yf;
    this.refreshTitle();
  }

  void setTextSize(float text_size) {
    this.text_size = text_size;
    this.refreshText();
  }

  void setTitleSize(float title_size) {
    this.title_size = title_size;
    this.refreshTitle();
  }

  void refreshTitle() {
    this.setTitleText(this.text_title_ref);
  }

  void setTitleText(String title) {
    this.text_title_ref = title;
    float scrollbar_width = min(this.scrollbar_max_width, 0.05 * (xf - xi));
    scrollbar_width = max(this.scrollbar_min_width, scrollbar_width);
    scrollbar_width = min(0.05 * (xf - xi), scrollbar_width);
    if (title == null) {
      this.text_title = null;
      this.scrollbar.setLocation(xf - scrollbar_width, yi, xf, yf);
    }
    else {
      this.text_title = "";
      textSize(this.title_size);
      for (int i = 0; i < title.length(); i++) {
        char nextChar = title.charAt(i);
        if (textWidth(this.text_title + nextChar) < this.xf - this.xi - 3) {
          this.text_title += nextChar;
        }
        else {
          break;
        }
      }
      this.scrollbar.setLocation(xf - scrollbar_width, yi + 1 + textAscent() + textDescent(), xf, yf);
    }
    this.refreshText();
  }

  void refreshText() {
    this.setText(this.text_ref);
  }

  void addText(String text) {
    this.setText(this.text_ref + text);
  }

  void setText(String text) {
    this.text_ref = text;
    this.text_lines.clear();
    float currY = this.yi + 1;
    if (this.text_title_ref != null) {
      textSize(this.title_size);
      currY += textAscent() + textDescent() + 2;
    }
    textSize(this.text_size);
    float text_height = textAscent() + textDescent();
    float effective_xf = this.xf - this.xi - 3 - this.scrollbar.bar_size;
    int lines_above = 0;
    String[] lines = split(text, '\n');
    String currLine = "";
    boolean firstWord = true;
    for (int i = 0; i < lines.length; i++) {
      String[] words = split(lines[i], ' ');
      for (int j = 0; j < words.length; j++) {
        String word = " ";
        if (firstWord) {
          word = "";
        }
        word += words[j];
        if (textWidth(currLine + word) < effective_xf) {
          currLine += word;
          firstWord = false;
        }
        else if (firstWord) {
          for (int k = 0; k < word.length(); k++) {
            char nextChar = word.charAt(k);
            if (textWidth(currLine + nextChar) < effective_xf) {
              currLine += nextChar;
            }
            else {
              this.text_lines.add(currLine);
              currLine = "" + nextChar;
              firstWord = true;
              if (currY + text_height + 1 > this.yf) {
                lines_above++;
              }
              currY += text_height + this.text_leading;
            }
          }
          firstWord = false;
        }
        else {
          this.text_lines.add(currLine);
          currLine = words[j];
          firstWord = false;
          if (currY + text_height + 1 > this.yf) {
            lines_above++;
          }
          currY += text_height + this.text_leading;
        }
      }
      this.text_lines.add(currLine);
      currLine = "";
      firstWord = true;
      if (currY + text_height + 1 > this.yf) {
        lines_above++;
      }
      currY += text_height + this.text_leading;
    }
    this.scrollbar.updateMaxValue(lines_above);
  }

  void update(int millis) {
    rectMode(CORNERS);
    fill(this.color_background);
    stroke(this.color_stroke);
    strokeWeight(1);
    rect(this.xi, this.yi, this.xf, this.yf);
    float currY = this.yi + 1;
    if (this.text_title_ref != null) {
      fill(this.color_header);
      textSize(this.title_size);
      rect(this.xi, this.yi, this.xf, this.yi + textAscent() + textDescent() + 1);
      fill(this.color_title);
      textAlign(CENTER, TOP);
      text(this.text_title, this.xi + 0.5 * (this.xf - this.xi), currY);
      currY += textAscent() + textDescent() + 2;
    }
    fill(this.color_text);
    textAlign(LEFT, TOP);
    textSize(this.text_size);
    float text_height = textAscent() + textDescent();
    for (int i = int(floor(this.scrollbar.value)); i < this.text_lines.size(); i++, currY += text_height + this.text_leading) {
      if (currY + text_height + 1 > this.yf) {
        break;
      }
      text(this.text_lines.get(i), this.xi + 2, currY);
    }
    if (this.scrollbar.maxValue != this.scrollbar.minValue) {
      this.scrollbar.update(millis);
    }
    this.lastUpdateTime = millis;
  }

  void mouseMove(float mX, float mY) {
    this.scrollbar.mouseMove(mX, mY);
    if (mX > this.xi && mX < this.xf && mY > this.yi && mY < this.yf) {
      this.hovered = true;
    }
    else {
      this.hovered = false;
    }
  }

  void mousePress() {
    this.scrollbar.mousePress();
  }

  void mouseRelease() {
    this.scrollbar.mouseRelease();
  }

  void scroll(int amount) {
    if (this.hovered) {
      this.scrollbar.increaseValue(amount);
    }
  }
}


abstract class ListTextBox extends TextBox {
  protected ArrayList<String> text_lines_ref;
  protected int line_hovered = -1;
  protected int line_clicked = -1;
  protected color highlight_color = color(100, 100, 250, 120);
  protected int doubleclickTimer = 0;
  protected int doubleclickTime = 400;

  ListTextBox() {
    this(0, 0, 0, 0);
  }
  ListTextBox(float xi, float yi, float xf, float yf) {
    super(xi, yi, xf, yf);
  }

  @Override
  void setText(String text) {
    this.text_ref = text;
    this.text_lines.clear();
    this.text_lines_ref = new ArrayList<String>();
    float currY = this.yi + 1;
    if (this.text_title_ref != null) {
      textSize(this.title_size);
      currY += textAscent() + textDescent() + 2;
    }
    textSize(this.text_size);
    float text_height = textAscent() + textDescent();
    float effective_xf = this.xf - this.xi - 3 - this.scrollbar.bar_size;
    int lines_above = 0;
    String[] lines = split(text, '\n');
    for (String line : lines) {
      this.text_lines_ref.add(line);
      String currLine = "";
      for (int i = 0; i < line.length(); i++) {
        char nextChar = line.charAt(i);
        if (textWidth(currLine + nextChar) < effective_xf) {
          currLine += nextChar;
        }
        else {
          break;
        }
      }
      this.text_lines.add(currLine);
      if (currY + text_height + 1 > this.yf) {
        lines_above++;
      }
      currY += text_height + this.text_leading;
    }
    this.scrollbar.updateMaxValue(lines_above);
  }

  void addLine(String line) {
    this.addText("\n" + line);
  }

  String highlightedLine() {
    if (this.line_clicked < 0 || this.line_clicked >= this.text_lines_ref.size()) {
      return null;
    }
    return this.text_lines_ref.get(this.line_clicked);
  }

  @Override
  void update(int millis) {
    int timeElapsed = millis - this.lastUpdateTime;
    super.update(millis);
    if (this.doubleclickTimer > 0) {
      this.doubleclickTimer -= timeElapsed;
    }
    if (this.line_clicked < floor(this.scrollbar.value)) {
      return;
    }
    float currY = this.yi + 1;
    if (this.text_title_ref != null) {
      textSize(this.title_size);
      currY += textAscent() + textDescent() + 2;
    }
    textSize(this.text_size);
    float text_height = textAscent() + textDescent();
    currY += (this.line_clicked - floor(this.scrollbar.value)) * (text_height + this.text_leading);
    if (currY + text_height + 1 > this.yf) {
      return;
    }
    rectMode(CORNERS);
    fill(this.highlight_color);
    strokeWeight(0.001);
    stroke(this.highlight_color);
    rect(this.xi + 1, currY, this.xf - this.xi - 2 - this.scrollbar.bar_size, currY + text_height);
  }

  @Override
  void mouseMove(float mX, float mY) {
    this.scrollbar.mouseMove(mX, mY);
    if (mX > this.xi && mX < this.xf && mY > this.yi && mY < this.yf) {
      this.hovered = true;
      float currY = this.yi + 1;
      if (this.text_title_ref != null) {
        textSize(this.title_size);
        currY += textAscent() + textDescent() + 2;
      }
      textSize(this.text_size);
      float line_height = textAscent() + textDescent() + this.text_leading;
      int target_line = int(floor(this.scrollbar.value) + floor((mY - currY) / line_height));
      if (target_line < 0 || mX > (this.xf - this.scrollbar.bar_size) || target_line >= this.text_lines_ref.size() ||
        (currY + (1 + target_line - floor(this.scrollbar.value)) * line_height + 1 > this.yf)) {
        this.line_hovered = -1;
      }
      else {
        this.line_hovered = target_line;
      }
    }
    else {
      this.hovered = false;
      this.line_hovered = -1;
    }
  }

  @Override
  void mousePress() {
    this.scrollbar.mousePress();
    if (this.line_hovered > -1) {
      if (this.doubleclickTimer > 0  && this.line_clicked == this.line_hovered) {
        this.line_clicked = this.line_hovered;
        this.doubleclick();
      }
      else {
        this.line_clicked = this.line_hovered;
        this.click();
      }
      this.doubleclickTimer = this.doubleclickTime;
    }
    else {
      this.line_clicked = this.line_hovered;
    }
  }

  void keyPress() {
    if (!this.hovered) {
      return;
    }
    if (key == CODED) {
      switch(keyCode) {
        case UP:
          if (this.line_clicked > 0) {
            this.line_clicked--;
          }
          break;
        case DOWN:
          if (this.line_clicked < this.text_lines_ref.size() - 1) {
            this.line_clicked++;
          }
          break;
        default:
          break;
      }
    }
  }

  abstract void click(); // click on line
  abstract void doubleclick(); // doubleclick on line
}




class InputBox extends RectangleButton {
  protected String text = "";
  protected String hint_text = "";
  protected color hint_color = color(80);
  protected boolean typing = false;
  protected String display_text = "";

  protected int location_display = 0;
  protected int location_cursor = 0;

  protected float cursor_weight = 1;
  protected int cursor_blink_time = 450;
  protected int cursor_blink_timer = 0;
  protected boolean cursor_blinking = true;

  InputBox(float xi, float yi, float xf, float yf) {
    super(xi, yi, xf, yf);
    this.roundness = 0;
    this.setColors(color(170), color(220), color(220), color(255), color(0));
  }

  void refreshText() {
    this.setText(this.text);
  }
  void setText(String text) {
    if (text == null) {
      text = "";
    }
    this.text = text;
    this.updateDisplayText();
    if (this.location_cursor > this.text.length()) {
      this.location_cursor = this.text.length();
    }
    if (this.location_cursor > this.location_display + this.display_text.length()) {
      this.location_display = this.location_cursor - this.display_text.length();
      this.updateDisplayText();
    }
  }

  void setTextSize(float text_size) {
    this.text_size = text_size;
    this.refreshText();
  }

  @Override
  void setLocation(float xi, float yi, float xf, float yf) {
    super.setLocation(xi, yi, xf, yf);
    this.updateDisplayText();
  }

  @Override
  void stretchButton(float amount, int direction) {
    super.stretchButton(amount, direction);
    this.updateDisplayText();
  }

  void updateDisplayText() {
    if (this.text == null) {
      this.text = "";
    }
    this.display_text = "";
    textSize(this.text_size);
    float maxWidth = this.xf - this.xi - 2 - textWidth(' ');
    boolean decreaseDisplayLocation = true;
    for (int i = this.location_display; i < this.text.length(); i++ ) {
      if (textWidth(this.display_text + this.text.charAt(i)) > maxWidth) {
        decreaseDisplayLocation = false;
        break;
      }
      this.display_text += this.text.charAt(i);
    }
    if (decreaseDisplayLocation) {
      while(this.location_display > 0 && textWidth(this.text.charAt(
        this.location_display - 1) + this.display_text) <= maxWidth) {
        this.location_display--;
        this.display_text = this.text.charAt(this.location_display) + this.display_text;
      }
    }
    // if say increased text size
    else if (this.location_cursor - this.location_display > this.display_text.length()) {
      int dif = this.location_cursor - this.location_display - this.display_text.length();
      this.location_display += dif;
      this.display_text = this.display_text.substring(dif);
    }
  }

  void resetBlink() {
    this.cursor_blinking = true;
    this.cursor_blink_timer = 0;
  }

  @Override
  color fillColor() {
    if (this.disabled) {
      return this.color_disabled;
    }
    else if (this.typing) {
      return this.color_click;
    }
    else {
      return this.color_default;
    }
  }

  @Override
  void drawButton() {
    super.drawButton();
    textAlign(LEFT, TOP);
    if (this.text.equals("")) {
      textSize(this.text_size - 2);
      fill(this.hint_color);
      text(this.hint_text, this.xi + 2, this.yi + 1);
    }
    else {
      textSize(this.text_size);
      fill(this.color_text);
      text(this.display_text, this.xi + 2, this.yi + 1);
    }
    if (this.typing && this.cursor_blinking) {
      strokeWeight(this.cursor_weight);
      fill(this.color_stroke);
      float x_cursor = this.xi + 2 + textWidth(this.display_text.substring(
        0, this.location_cursor - this.location_display));
      line(x_cursor, this.yi + 2, x_cursor, this.yf - 2);
    }
  }

  @Override
  void update(int millis) {
    int timeElapsed = millis - this.lastUpdateTime;
    super.update(millis);
    if (this.typing) {
      this.cursor_blink_timer += timeElapsed;
      if (this.cursor_blink_timer > this.cursor_blink_time) {
        this.cursor_blink_timer -= this.cursor_blink_time;
        this.cursor_blinking = !this.cursor_blinking;
      }
    }
  }

  void dehover() {
  }

  void hover() {
  }

  @Override
  void mousePress() {
    this.typing = false;
    super.mousePress();
  }
  void click() {
    this.typing = true;
    this.resetBlink();
  }

  void release() {
  }

  void keyPress() {
    if (!this.typing) {
      return;
    }
    if (key == CODED) {
      switch(keyCode) {
        case LEFT:
          this.location_cursor--;
          if (this.location_cursor < 0) {
            this.location_cursor = 0;
          }
          else if (this.location_cursor < this.location_display) {
            this.location_display--;
            this.updateDisplayText();
          }
          break;
        case RIGHT:
          this.location_cursor++;
          if (this.location_cursor > this.text.length()) {
            this.location_cursor = this.text.length();
          }
          else if (this.location_cursor > this.location_display + this.display_text.length()) {
            this.location_display++;
            this.updateDisplayText();
          }
          break;
        case KeyEvent.VK_HOME:
          this.location_cursor = 0;
          this.location_display = 0;
          this.updateDisplayText();
          break;
        case KeyEvent.VK_END:
          this.location_cursor = this.text.length();
          this.location_display = this.text.length();
          this.updateDisplayText();
          break;
        default:
          break;
      }
    }
    else {
      switch(key) {
        case BACKSPACE:
          if (this.location_cursor > 0) {
            this.location_cursor--;
            if (this.location_cursor < this.location_display) {
              this.location_display--;
            }
            this.setText(this.text.substring(0, this.location_cursor) +
              this.text.substring(this.location_cursor + 1, this.text.length()));
          }
          break;
        case TAB:
          break;
        case ENTER:
        case RETURN:
          break;
        case ESC:
          this.typing = false;
          break;
        case DELETE:
          break;
        default:
          this.location_cursor++;
          if (this.location_cursor > this.location_display + this.display_text.length()) {
            this.location_display++;
          }
          this.setText(this.text.substring(0, this.location_cursor - 1) + key +
            this.text.substring(this.location_cursor - 1, this.text.length()));
          break;
      }
    }
    this.resetBlink();
  }

  void keyRelease() {
    if (!this.typing) {
      return;
    }
    this.resetBlink();
  }
}




class Slider  {
  class SliderButton extends CircleButton {
    protected boolean active = false;
    protected float active_grow_factor = 1.3;
    protected color active_color = color(0, 50, 0);
    protected float lastX = 0;
    protected float changeFactor = 1;

    SliderButton() {
      super(0, 0, 0);
      this.setColors(color(170), color(255, 0), color(255, 0), color(255, 0), color(0));
      strokeWeight(2);
    }

    @Override
    float radius() {
      if (this.active) {
        return this.active_grow_factor * super.radius();
      }
      else {
        return super.radius();
      }
    }

    color lineColor() {
      if (this.active) {
        return this.active_color;
      }
      else {
        return this.color_stroke;
      }
    }

    @Override
    void drawButton() {
      ellipseMode(RADIUS);
      if (this.active) {
        fill(this.active_color);
      }
      else {
        noFill();
      }
      stroke(this.lineColor());
      strokeWeight(Slider.this.line_thickness);
      circle(this.xc, this.yc, this.radius());
    }

    void mouseMove(float mX, float mY) {
      super.mouseMove(mX, mY);
      if (this.active && this.clicked) {
        this.moveButton(mX - this.lastX, 0);
        this.changeFactor = 1; // how much value actually changed (accounting for step_size)
        Slider.this.refreshValue();
        this.lastX += this.changeFactor * (mX - this.lastX);
      }
      else {
        this.lastX = mX;
      }
    }

    void mousePress() {
      super.mousePress();
      if (!this.hovered) {
        this.active = false;
      }
    }

    void scroll(int amount) {
      if (!this.active) {
        return;
      }
      Slider.this.step(amount);
    }

    void keyPress() {
      if (!this.active) {
        return;
      }
      if (key == CODED) {
        switch(keyCode) {
          case LEFT:
            Slider.this.step(-1);
            break;
          case RIGHT:
            Slider.this.step(1);
            break;
          default:
            break;
        }
      }
    }

    void hover() {}
    void dehover() {}
    void release() {}

    void click() {
      this.active = true;
    }
  }

  protected float xi;
  protected float yi;
  protected float xf;
  protected float yf;
  protected float yCenter;

  protected float min_value = 0;
  protected float max_value = 0;
  protected float step_size = -1;
  protected boolean no_step = true;
  protected float value = 0;

  protected SliderButton button = new SliderButton();
  protected float offset;
  protected float line_thickness = 3;

  Slider() {
    this(0, 0, 0, 0);
  }
  Slider(float xi, float yi, float xf, float yf) {
    this.setLocation(xi, yi, xf, yf);
  }

  void setLocation(float xi, float yi, float xf, float yf) {
    this.xi = xi;
    this.yi = yi;
    this.xf = xf;
    this.yf = yf;
    this.yCenter = yi + 0.5 * (yf - yi);
    this.button.setLocation(xi, this.yCenter, 0.5 * (yf - yi) / this.button.active_grow_factor);
    this.offset = this.button.xr * this.button.active_grow_factor;
    this.refreshButton();
  }

  // called when slider changes value or size (this never changes value)
  void refreshButton() {
    if (this.min_value == this.max_value) {
      this.button.moveButton(this.xi + this.offset - this.button.xCenter(), 0);
      return;
    }
    float targetX = this.xi + this.offset + (this.xf - 2 * this.offset - this.xi) *
      (this.value - this.min_value) / (this.max_value - this.min_value);
    this.button.moveButton(targetX - this.button.xCenter(), 0);
  }

  // called when button changes value (this changes value so calls refreshButton)
  void refreshValue() {
    float targetValue = this.min_value + (this.button.xCenter() - this.xi - this.offset)
      * (this.max_value - this.min_value) / (this.xf - 2 * this.offset - this.xi);
    boolean hitbound = false;
    if (targetValue >= this.max_value) {
      float change = targetValue - this.value;
      if (change > 0) {
        this.button.changeFactor = (this.max_value - this.value) / change;
      }
      targetValue = this.max_value;
      hitbound = true;
    }
    else if (targetValue <= this.min_value) {
      float change = targetValue - this.value;
      if (change < 0) {
        this.button.changeFactor = (this.min_value - this.value) / change;
      }
      targetValue = this.min_value;
      hitbound = true;
    }
    float change = targetValue - this.value;
    if (!this.no_step && !hitbound && this.step_size != 0 && change != 0) {
      float new_change = this.step_size * (floor(change / this.step_size));
      this.button.changeFactor = new_change/change;
      change = new_change;
    }
    this.value += change;
    this.refreshButton();
  }

  void bounds(float min, float max, float step) {
    if (min > max) {
      min = max;
    }
    this.min_value = min;
    this.max_value = max;
    this.step_size = step;
    if (this.value < min) {
      this.value = min;
    }
    else if (this.value > max) {
      this.value = max;
    }
    if (step > 0) {
      this.no_step = false;
    }
    else {
      this.no_step = true;
    }
  }

  void step(int amount) {
    if (this.no_step) {
      this.value += 0.1 * (this.max_value - this.min_value) * amount;
    }
    else {
      this.value += this.step_size * amount;
    }
    if (this.value > this.max_value) {
      this.value = this.max_value;
    }
    else if (this.value < this.min_value) {
      this.value = this.min_value;
    }
    this.refreshButton();
  }

  void setValue(float value) {
    this.value = value;
    if (this.value > this.max_value) {
      this.value = this.max_value;
    }
    else if (this.value < this.min_value) {
      this.value = this.min_value;
    }
    this.refreshButton();
  }

  void update(int millis) {
    strokeWeight(this.line_thickness);
    stroke(this.button.active_color);
    line(min(this.xi + this.offset, this.button.xc - this.button.radius()),
      this.yCenter, this.button.xc - this.button.radius(), this.yCenter);
    stroke(this.button.color_stroke);
    line(this.button.xc + this.button.radius(), this.yCenter,
      max(this.xf - this.offset, this.button.xc + this.button.radius()), this.yCenter);
    this.button.update(millis);
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

  void scroll(int amount) {
    this.button.scroll(amount);
  }

  void keyPress() {
    this.button.keyPress();
  }
}




enum FormFieldSubmit {
  NONE, SUBMIT, CANCEL;
}

abstract class FormField {
  protected String message;
  protected float field_width = 0;

  FormField(String message) {
    this.message = message;
  }

  float getWidth() {
    return this.field_width;
  }
  void setWidth(float new_width) {
    this.field_width = new_width;
    this.updateWidthDependencies();
  }

  abstract void updateWidthDependencies();
  abstract float getHeight();
  abstract String getValue();
  abstract void setValue(String newValue);

  abstract FormFieldSubmit update(int millis);
  abstract void mouseMove(float mX, float mY);
  abstract void mousePress();
  abstract void mouseRelease();
  abstract void keyPress();
  abstract void keyRelease();
  abstract void scroll(int amount);

  abstract void submit();
}


// Spacer
class SpacerFormField extends FormField {
  protected float spacer_height;

  SpacerFormField(float spacer_height) {
    super("");
    this.spacer_height = spacer_height;
  }

  void updateWidthDependencies() {}

  float getHeight() {
    return this.spacer_height;
  }

  String getValue() {
    return this.message;
  }
  void setValue(String newValue) {
    this.message = newValue;
  }

  FormFieldSubmit update(int millis) {
    return FormFieldSubmit.NONE;
  }
  void mouseMove(float mX, float mY) {}
  void mousePress() {}
  void mouseRelease() {}
  void scroll(int amount) {}
  void keyPress() {}
  void keyRelease() {}
  void submit() {}
}


// One line message
class MessageFormField extends FormField {
  protected String display_message; // can be different if truncated
  protected float default_text_size = 22;
  protected float minimum_text_size = 8;
  protected float text_size = 0;
  protected color text_color = color(0);

  MessageFormField(String message) {
    super(message);
    this.display_message = message;
  }

  void setTextSize(float new_text_size) {
    this.default_text_size = new_text_size;
    this.updateWidthDependencies();
  }

  void updateWidthDependencies() {
    float max_width = this.field_width - 2;
    this.text_size = this.default_text_size;
    textSize(this.text_size);
    this.display_message = this.message;
    while(textWidth(this.display_message) > max_width) {
      this.text_size -= 0.2;
      textSize(this.text_size);
      if (this.text_size < this.minimum_text_size) {
        this.text_size = this.minimum_text_size;
        textSize(this.text_size);
        String truncated_string = "";
        for (int i = 0 ; i < this.display_message.length(); i++) {
          char c = this.display_message.charAt(i);
          if (textWidth(truncated_string + c) <= max_width) {
            truncated_string += c;
          }
          else {
            this.display_message = truncated_string;
            break;
          }
        }
        break;
      }
    }
  }

  float getHeight() {
    textSize(this.text_size);
    return textAscent() + textDescent() + 2;
  }

  String getValue() {
    return this.message;
  }
  void setValue(String newValue) {
    this.message = newValue;
    this.updateWidthDependencies();
  }

  FormFieldSubmit update(int millis) {
    textSize(this.text_size);
    textAlign(LEFT, TOP);
    fill(this.text_color);
    text(this.display_message, 1, 1);
    return FormFieldSubmit.NONE;
  }

  void mouseMove(float mX, float mY) {
  }

  void mousePress() {}
  void mouseRelease() {}
  void scroll(int amount) {}
  void keyPress() {}
  void keyRelease() {}
  void submit() {}
}


// Multi-line message
class TextBoxFormField extends FormField {
  protected TextBox textbox = new TextBox(0, 0, 0, 0);

  TextBoxFormField(String message, float box_height) {
    super(message);
    this.textbox.setText(message);
    this.textbox.setLocation(0, 0, 0, box_height);
    this.textbox.color_background = color(255, 0);
    this.textbox.color_header = color(255, 0);
    this.textbox.color_stroke = color(255, 0);
  }

  void updateWidthDependencies() {
    this.textbox.setLocation(0, 0, this.field_width, this.getHeight());
  }
  float getHeight() {
    return this.textbox.yf - this.textbox.yi;
  }

  String getValue() {
    return this.textbox.text_ref;
  }
  void setValue(String newValue) {
    this.textbox.setText(newValue);
  }

  FormFieldSubmit update(int millis) {
    this.textbox.update(millis);
    return FormFieldSubmit.NONE;
  }

  void mouseMove(float mX, float mY) {
    this.textbox.mouseMove(mX, mY);
  }

  void mousePress() {
    this.textbox.mousePress();
  }

  void mouseRelease() {
    this.textbox.mouseRelease();
  }

  void scroll(int amount) {
    this.textbox.scroll(amount);
  }

  void keyPress() {}
  void keyRelease() {}
  void submit() {}
}


// String input
class StringFormField extends MessageFormField {
  protected InputBox input = new InputBox(0, 0, 0, 0);

  StringFormField(String message) {
    this(message, "");
  }
  StringFormField(String message, String hint) {
    super(message);
    if (hint != null) {
      this.input.hint_text = hint;
    }
  }

  void updateWidthDependencies() {
    float temp_field_width = this.field_width;
    this.field_width = 0.5 * this.field_width;
    super.updateWidthDependencies();
    this.field_width = temp_field_width;
    this.input.setTextSize(this.text_size);
    textSize(this.text_size);
    this.input.setLocation(textWidth(this.message), 0, this.field_width, textAscent() + textDescent() + 2);
  }

  @Override
  String getValue() {
    return this.input.text;
  }
  @Override
  void setValue(String newValue) {
    this.input.setText(newValue);
  }

  @Override
  FormFieldSubmit update(int millis) {
    this.input.update(millis);
    return super.update(millis);
  }

  @Override
  void mouseMove(float mX, float mY) {
    this.input.mouseMove(mX, mY);
  }

  @Override
  void mousePress() {
    this.input.mousePress();
  }

  @Override
  void mouseRelease() {
    this.input.mouseRelease();
  }

  @Override
  void keyPress() {
    this.input.keyPress();
  }
  @Override
  void keyRelease() {
    this.input.keyRelease();
  }
}


class IntegerFormField extends StringFormField {
  protected int min_value = 0;
  protected int max_value = 0;

  IntegerFormField(String message) {
    this(message, "");
  }
  IntegerFormField(String message, String hint) {
    this(message, hint, 0, 0);
  }
  IntegerFormField(String message, int min, int max) {
    this(message, "", min, max);
  }
  IntegerFormField(String message, String hint, int min, int max) {
    super(message, hint);
    this.min_value = min;
    this.max_value = max;
  }

  void submit() {
    int value = toInt(this.input.text);
    if (value > this.max_value) {
      value = this.max_value;
    }
    else if (value < this.min_value) {
      value = this.min_value;
    }
    this.input.setText(Integer.toString(value));
  }
}


class FloatFormField extends StringFormField {
  protected float min_value = 0;
  protected float max_value = 0;

  FloatFormField(String message) {
    this(message, "");
  }
  FloatFormField(String message, String hint) {
    this(message, hint, 0, 0);
  }
  FloatFormField(String message, float min, float max) {
    this(message, "", min, max);
  }
  FloatFormField(String message, String hint, float min, float max) {
    super(message, hint);
    this.min_value = min;
    this.max_value = max;
  }

  void submit() {
    float value = toFloat(this.input.text);
    if (value > this.max_value) {
      value = this.max_value;
    }
    else if (value < this.min_value) {
      value = this.min_value;
    }
    this.input.setText(Float.toString(value));
  }
}


class BooleanFormField extends StringFormField {
  BooleanFormField(String message) {
    this(message, "");
  }
  BooleanFormField(String message, String hint) {
    super(message, hint);
  }

  void submit() {
    this.input.setText(Boolean.toString(toBoolean(this.input.text)));
  }
}


// Array of radio buttons
class RadiosFormField extends MessageFormField {
  class DefaultRadioButton extends RadioButton {
    DefaultRadioButton(String message) {
      super(0, 0, 0);
      this.message = message;
    }
    void hover() {
    }
    void dehover() {
    }
    void release() {
    }
  }

  protected ArrayList<RadioButton> radios = new ArrayList<RadioButton>();
  protected float radio_padding = 6;
  protected int index_selected = -1;

  RadiosFormField(String message) {
    super(message);
  }

  void addRadio() {
    this.addRadio("");
  }
  void addRadio(String message) {
    this.addRadio(new DefaultRadioButton(message));
  }
  void addRadio(RadioButton radio) {
    this.radios.add(radio);
    this.updateWidthDependencies();
  }

  @Override
  void updateWidthDependencies() {
    super.updateWidthDependencies();
    float currY = super.getHeight() + this.radio_padding;
    textSize(this.text_size - 2);
    for (RadioButton radio : this.radios) {
      radio.text_size = this.text_size - 2;
      float radius = 0.5 * min(0.8 * (textAscent() + textDescent() + 2), abs(this.field_width - textWidth(radio.message)));
      float xc = textWidth(radio.message) + radius;
      float yc = currY + 0.5 * (textAscent() + textDescent() + 2);
      radio.setLocation(xc, yc, radius);
      currY += textAscent() + textDescent() + 2 + this.radio_padding;
    }
  }

  @Override
  float getHeight() {
    float field_height = super.getHeight();
    field_height += this.radios.size() * this.radio_padding;
    boolean first = true;
    for (RadioButton radio : this.radios) {
      textSize(radio.text_size);
      field_height += textAscent() + textDescent() + 2;
    }
    return field_height;
  }

  @Override
  String getValue() {
    return Integer.toString(this.index_selected);
  }
  @Override
  void setValue(String newValue) {
    if (isInt(newValue)) {
      this.index_selected = toInt(newValue);
      this.uncheckOthers();
    }
  }

  @Override
  FormFieldSubmit update(int millis) {
    FormFieldSubmit returnValue = super.update(millis);
    for (RadioButton radio : this.radios) {
      textSize(radio.text_size);
      textAlign(LEFT, TOP);
      fill(radio.color_text);
      text(radio.message, 1, radio.yCenter() - radio.radius() + 1);
      radio.update(millis);
    }
    return returnValue;
  }

  @Override
  void mouseMove(float mX, float mY) {
    for (RadioButton radio : this.radios) {
      radio.mouseMove(mX, mY);
    }
  }

  @Override
  void mousePress() {
    for (int i = 0; i < this.radios.size(); i++) {
      RadioButton radio = this.radios.get(i);
      boolean pressed = radio.checked;
      radio.mousePress();
      if (!pressed && radio.checked) {
        this.index_selected = i;
        this.uncheckOthers();
      }
    }
  }

  void uncheckOthers() {
    for (int i = 0; i < this.radios.size(); i++) {
      if (i == this.index_selected) {
        continue;
      }
      this.radios.get(i).checked = false;
    }
  }

  @Override
  void mouseRelease() {
    for (RadioButton radio : this.radios) {
      radio.mouseRelease();
    }
  }
}


// Single checkbox
class CheckboxFormField extends MessageFormField {
  class DefaultCheckBox extends CheckBox {
    DefaultCheckBox() {
      super(0, 0, 0, 0);
    }
    void hover() {
    }
    void dehover() {
    }
    void release() {
    }
  }

  protected CheckBox checkbox = new DefaultCheckBox();

  CheckboxFormField(String message) {
    super(message);
  }

  @Override
  void updateWidthDependencies() {
    float temp_field_width = this.field_width;
    this.field_width = 0.75 * this.field_width;
    super.updateWidthDependencies();
    this.field_width = temp_field_width;
    textSize(this.text_size);
    float checkboxsize = min(0.8 * this.getHeight(), this.field_width - textWidth(this.message));
    float xi = textWidth(this.message);
    float yi = 0.5 * (this.getHeight() - checkboxsize);
    this.checkbox.setLocation(xi, yi, xi + checkboxsize, yi + checkboxsize);
  }

  @Override
  String getValue() {
    return Boolean.toString(this.checkbox.checked);
  }
  @Override
  void setValue(String newValue) {
    if (isBoolean(newValue)) {
      this.checkbox.checked = toBoolean(newValue);
    }
  }

  @Override
  FormFieldSubmit update(int millis) {
    this.checkbox.update(millis);
    return super.update(millis);
  }

  @Override
  void mouseMove(float mX, float mY) {
    this.checkbox.mouseMove(mX, mY);
  }

  @Override
  void mousePress() {
    this.checkbox.mousePress();
  }

  @Override
  void mouseRelease() {
    this.checkbox.mouseRelease();
  }
}


// Slider
class SliderFormField extends MessageFormField {
  protected Slider slider = new Slider();
  protected float max_slider_height = 30;

  SliderFormField(String message, float max) {
    this(message, 0, max, -1);
  }
  SliderFormField(String message, float min, float max) {
    this(message, min, max, -1);
  }
  SliderFormField(String message, float min, float max, float step) {
    super(message);
    this.slider.bounds(min, max, step);
    this.slider.setValue(min);
  }

  @Override
  void updateWidthDependencies() {
    float temp_field_width = this.field_width;
    this.field_width = 0.4 * this.field_width;
    super.updateWidthDependencies();
    this.field_width = temp_field_width;
    textSize(this.text_size);
    float sliderheight = min(this.getHeight(), this.max_slider_height);
    float xi = textWidth(this.message) + 0.05 * this.field_width;
    float yi = 0.5 * (this.getHeight() - sliderheight);
    this.slider.setLocation(xi, yi, this.field_width, yi + sliderheight);
  }

  @Override
  String getValue() {
    return Float.toString(this.slider.value);
  }
  @Override
  void setValue(String newValue) {
    if (isFloat(newValue)) {
      this.slider.setValue(toFloat(newValue));
    }
  }

  @Override
  FormFieldSubmit update(int millis) {
    this.slider.update(millis);
    return super.update(millis);
  }

  @Override
  void mouseMove(float mX, float mY) {
    this.slider.mouseMove(mX, mY);
  }

  @Override
  void mousePress() {
    this.slider.mousePress();
  }

  @Override
  void mouseRelease() {
    this.slider.mouseRelease();
  }

  @Override
  void scroll(int amount) {
    this.slider.scroll(amount);
  }

  @Override
  void keyPress() {
    this.slider.keyPress();
  }
}


// Submit button (submits and cancels)
class SubmitFormField extends FormField {
  class SubmitButton extends RectangleButton {
    SubmitButton(float xi, float yi, float xf, float yf) {
      super(xi, yi, xf, yf);
      this.roundness = 0;
      this.raised_body = true;
      this.raised_border = true;
      this.adjust_for_text_descent = true;
    }
    void hover() {
    }
    void dehover() {
    }
    void click() {
    }
    void release() {
      if (this.hovered) {
        SubmitFormField.this.submitted = true;
      }
    }
  }

  protected SubmitButton button = new SubmitButton(0, 0, 0, 30);
  protected boolean submitted = false;
  protected boolean submit_button = true;

  SubmitFormField(String message) {
    this(message, true);
  }
  SubmitFormField(String message, boolean submit_button) {
    super(message);
    this.button.message = message;
    this.button.show_message = true;
    this.submit_button = submit_button;
  }

  void updateWidthDependencies() {
    textSize(this.button.text_size);
    float desiredWidth = textWidth(this.button.message + "  ");
    if (desiredWidth > this.field_width) {
      this.button.setLocation(0, 0, this.field_width, 30);
    }
    else {
      this.button.setLocation(0.5 * (this.field_width - desiredWidth), 0,
        0.5 * (this.field_width + desiredWidth), 30);
    }
  }

  float getHeight() {
    return this.button.yf - this.button.yi;
  }

  String getValue() {
    return this.message;
  }
  @Override
  void setValue(String newValue) {
    if (isBoolean(newValue)) {
      this.submit_button = toBoolean(newValue);
    }
  }

  FormFieldSubmit update(int millis) {
    this.button.update(millis);
    if (this.submitted) {
      this.submitted = false;
      if (this.submit_button) {
        return FormFieldSubmit.SUBMIT;
      }
      else {
        return FormFieldSubmit.CANCEL;
      }
    }
    return FormFieldSubmit.NONE;
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

  void scroll(int amount) {
  }

  void keyPress() {}
  void keyRelease() {}
  void submit() {}
}



abstract class Form {
  class CancelButton extends RectangleButton {
    CancelButton(float xi, float yi, float xf, float yf) {
      super(xi, yi, xf, yf);
      this.roundness = 0;
      this.setColors(color(170), color(240, 30, 30), color(255, 60, 60), color(180, 0, 0), color(0));
      this.color_stroke = color(0, 1);
    }
    @Override
    void drawButton() {
      super.drawButton();
      stroke(0);
      strokeWeight(1.5);
      float offset = 0.05 * this.button_width();
      line(this.xi + offset, this.yi + offset, this.xf - offset, this.yf - offset);
      line(this.xi + offset, this.yf - offset, this.xf - offset, this.yi + offset);
    }
    void hover() {
    }
    void dehover() {
    }
    void click() {
    }
    void release() {
      if (this.hovered) {
        Form.this.cancelForm();
      }
    }
  }

  protected float xi = 0;
  protected float yi = 0;
  protected float xf = 0;
  protected float yf = 0;
  protected boolean hovered = false;
  protected CancelButton cancel;

  protected ScrollBar scrollbar = new ScrollBar(0, 0, 0, 0, true);
  protected float scrollbar_max_width = 60;
  protected float scrollbar_min_width = 30;

  protected ArrayList<FormField> fields = new ArrayList<FormField>();
  protected float fieldCushion = 20;
  protected float yStart = 0;

  protected String text_title_ref = null;
  protected String text_title = null;
  protected float title_size = 22;

  protected color color_background = color(210);
  protected color color_header = color(170);
  protected color color_stroke = color(0);
  protected color color_title = color(0);

  protected boolean draggable = false;
  protected boolean hovered_header = false;
  protected boolean dragging = false;
  protected float dragX = 0;
  protected float dragY = 0;

  Form() {
    this(0, 0, 0, 0);
  }
  Form(float xi, float yi, float xf, float yf) {
    this.setLocation(xi, yi, xf, yf);
  }

  void cancelButton() {
    textSize(this.title_size);
    this.cancelButton(textAscent() + textDescent() + 1);
  }
  void cancelButton(float size) {
    this.cancel = new CancelButton(this.xf - size, this.yi + 1, this.xf, this.yi + size);
    this.refreshTitle();
  }

  float form_width() {
    return this.xf - this.xi;
  }
  float form_height() {
    return this.yf - this.yi;
  }

  void setLocation(float xi, float yi, float xf, float yf) {
    this.xi = xi;
    this.yi = yi;
    this.xf = xf;
    this.yf = yf;
    this.refreshTitle();
    for (FormField field : this.fields) {
      field.setWidth(this.xf - this.xi - 3 - this.scrollbar.bar_size);
    }
  }

  void moveForm(float xMove, float yMove) {
    this.xi += xMove;
    this.yi += yMove;
    this.xf += xMove;
    this.yf += yMove;
    this.scrollbar.move(xMove, yMove);
    if (this.cancel != null) {
      this.cancel.moveButton(xMove, yMove);
    }
    this.yStart += yMove;
    if (this.xi >= width || this.xf <= 0 || (this.cancel != null && this.xf <= this.cancel.button_width())
      || this.yi >= height || this.yStart <= 0) {
      this.toCenter();
      this.dragging = false;
    }
  }

  void toCenter() {
    float xMove = 0.5 * (width - this.form_width()) - this.xi;
    float yMove = 0.5 * (height - this.form_height()) - this.yi;
    this.moveForm(xMove, yMove);
  }

  void refreshTitle() {
    this.setTitleText(this.text_title_ref);
  }
  void setTitleSize(float title_size) {
    this.title_size = title_size;
    this.refreshTitle();
    if (this.cancel != null) {
      textSize(this.title_size);
      if (this.cancel.button_height() > textAscent() + textDescent() + 1) {
        this.cancelButton();
      }
    }
  }
  void setTitleText(String title) {
    this.text_title_ref = title;
    float scrollbar_width = min(this.scrollbar_max_width, 0.08 * (this.xf - this.xi));
    scrollbar_width = max(this.scrollbar_min_width, scrollbar_width);
    scrollbar_width = min(0.08 * (this.xf - this.xi), scrollbar_width);
    if (title == null) {
      this.text_title = null;
      this.scrollbar.setLocation(this.xf - scrollbar_width, this.yi, this.xf, this.yf);
      this.yStart = this.yi + 1;
    }
    else {
      this.text_title = "";
      textSize(this.title_size);
      for (int i = 0; i < title.length(); i++) {
        char nextChar = title.charAt(i);
        if (textWidth(this.text_title + nextChar) < this.xf - this.xi - 3) {
          this.text_title += nextChar;
        }
        else {
          break;
        }
      }
      this.yStart = this.yi + 2 + textAscent() + textDescent();
      this.scrollbar.setLocation(xf - scrollbar_width, this.yStart, this.xf, this.yf);
    }
  }

  void setFieldCushion(float fieldCushion) {
    this.fieldCushion = fieldCushion;
    this.refreshScrollbar();
  }


  void addField(FormField field) {
    field.setWidth(this.xf - this.xi - 3 - this.scrollbar.bar_size);
    this.fields.add(field);
    this.refreshScrollbar();
  }

  void removeField(int index) {
    if (index < 0 || index >= this.fields.size()) {
      return;
    }
    this.fields.remove(index);
    this.refreshScrollbar();
  }

  void refreshScrollbar() {
    float currY = this.yStart;
    for (int i = 0; i < this.fields.size(); i++) {
      currY += this.fields.get(i).getHeight();
      if (i > 0) {
        currY += this.fieldCushion;
      }
      if (currY + 2 > this.yf) {
        this.scrollbar.updateMaxValue(this.fields.size());
        return;
      }
    }
    this.scrollbar.updateMaxValue(0);
  }


  void update(int millis) {
    rectMode(CORNERS);
    fill(this.color_background);
    stroke(this.color_stroke);
    strokeWeight(1);
    rect(this.xi, this.yi, this.xf, this.yf);
    if (this.text_title_ref != null) {
      fill(this.color_header);
      textSize(this.title_size);
      rect(this.xi, this.yi, this.xf, this.yi + textAscent() + textDescent() + 1);
      fill(this.color_title);
      textAlign(CENTER, TOP);
      float center = this.xi + 0.5 * (this.xf - this.xi);
      if (this.cancel != null) {
        center -= 0.5 * this.cancel.button_width();
      }
      text(this.text_title, center, this.yi + 1);
    }
    if (this.cancel != null) {
      this.cancel.update(millis);
    }
    float currY = this.yStart;
    translate(this.xi + 1, 0);
    for (int i = int(floor(this.scrollbar.value)); i < this.fields.size(); i++) {
      if (currY + this.fields.get(i).getHeight() > this.yf) {
        break;
      }
      translate(0, currY);
      FormFieldSubmit submit = this.fields.get(i).update(millis);
      if (submit == FormFieldSubmit.SUBMIT) {
        this.submitForm();
      }
      else if (submit == FormFieldSubmit.CANCEL) {
        this.cancelForm();
      }
      translate(0, -currY);
      currY += this.fields.get(i).getHeight() + this.fieldCushion;
    }
    translate(-this.xi - 1, 0);
    if (this.scrollbar.maxValue != this.scrollbar.minValue) {
      this.scrollbar.update(millis);
    }
  }

  void mouseMove(float mX, float mY) {
    this.scrollbar.mouseMove(mX, mY);
    if (this.cancel != null) {
      this.cancel.mouseMove(mX, mY);
    }
    if (this.dragging) {
      this.moveForm(mouseX - this.dragX, mouseY - this.dragY);
      this.dragX = mouseX;
      this.dragY = mouseY;
    }
    this.hovered_header = false;
    if (mX > this.xi && mX < this.xf && mY > this.yi && mY < this.yf) {
      this.hovered = true;
      if (this.text_title_ref != null) {
        if (mY < this.yStart) {
          if (this.cancel == null || !this.cancel.hovered) {
            this.hovered_header = true;
          }
        }
      }
      mX -= this.xi + 1;
      mY -= this.yStart;
      float currY = this.yStart;
      for (int i = int(floor(this.scrollbar.value)); i < this.fields.size(); i++) {
        if (currY + this.fields.get(i).getHeight() > this.yf) {
          break;
        }
        this.fields.get(i).mouseMove(mX, mY);
        mY -= this.fields.get(i).getHeight() + this.fieldCushion;
        currY += this.fields.get(i).getHeight() + this.fieldCushion;
      }
    }
    else {
      this.hovered = false;
    }
  }

  void mousePress() {
    this.scrollbar.mousePress();
    if (this.cancel != null) {
      this.cancel.mousePress();
    }
    for (FormField field : this.fields) {
      field.mousePress();
    }
    if (this.hovered_header) {
      this.dragging = true;
      this.dragX = mouseX;
      this.dragY = mouseY;
    }
  }

  void mouseRelease() {
    this.scrollbar.mouseRelease();
    if (this.cancel != null) {
      this.cancel.mouseRelease();
    }
    for (FormField field : this.fields) {
      field.mouseRelease();
    }
    this.dragging = false;
  }

  void scroll(int amount) {
    if (this.hovered) {
      this.scrollbar.increaseValue(amount);
    }
    for (FormField field : this.fields) {
      field.scroll(amount);
    }
  }

  void keyPress() {
    for (FormField field : this.fields) {
      field.keyPress();
    }
  }

  void keyRelease() {
    for (FormField field : this.fields) {
      field.keyRelease();
    }
  }


  void submitForm() {
    for (FormField field : this.fields) {
      field.submit();
    }
    this.submit();
  }

  void cancelForm() {
    this.cancel();
  }

  abstract void submit();
  abstract void cancel();
}
