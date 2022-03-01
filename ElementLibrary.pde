abstract class Button {
  // state
  private boolean hidden = false;
  private boolean disabled = false;
  private boolean hovered = false;
  private boolean clicked = false;
  // colors
  private color color_disabled = color(220, 180);
  private color color_default = color(220);
  private color color_hover = color(170);
  private color color_click = color(120);
  private color color_text = color(0);
  private color color_stroke = color(0);
  // config
  private String message = "";
  private boolean show_message = false;
  private int text_size = 14;
  private boolean show_stroke = true;
  private float stroke_weight = 0.5;
  private boolean show_hover_message = false;

  Button() {
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
      noStroke();
    }
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
  private float xi;
  private float yi;
  private float xf;
  private float yf;
  private int roundness = 8;

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
