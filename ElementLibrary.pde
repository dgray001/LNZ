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
  protected boolean show_hover_message = false;
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

  void setFill() {
    if (this.disabled) {
      fill(this.color_disabled);
    }
    else if (this.clicked) {
      fill(this.color_click);
    }
    else if (this.hovered) {
      fill(this.color_hover);
    }
    else {
      fill(this.color_default);
    }
    if (this.show_stroke) {
      stroke(this.color_stroke);
      strokeWeight(this.stroke_weight);
    }
    else {
      strokeWeight(0);
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
      this.release();
    }
    this.clicked = false;
  }

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

  RectangleButton(float xi, float yi, float xf, float yf) {
    super();
    this.xi = xi;
    this.yi = yi;
    this.xf = xf;
    this.yf = yf;
  }

  void drawButton() {
    this.setFill();
    rectMode(CORNERS);
    rect(this.xi, this.yi, this.xf, this.yf, this.roundness);
  }

  void moveButton(float xMove, float yMove) {
    this.xi += xMove;
    this.yi += yMove;
    this.xf += xMove;
    this.yf += yMove;
  }

  boolean mouseOn(float mX, float mY) {
    if (mX >= this.xi && mY >= this.yi &&
      mX <= this.xf && mY <= this.yf) {
      return true;
    }
    return false;
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

  void drawButton() {
    this.setFill();
    ellipseMode(RADIUS);
    ellipse(this.xc, this.yc, this.xr, this.yr);
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
  }

  void drawButton() {
    this.setFill();
    triangle(this.x1, this.y1, this.x2, this.y2, this.x3, this.y3);
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
