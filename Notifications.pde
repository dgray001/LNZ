abstract class NotificationLNZ {
  protected boolean sliding_in = true;
  protected boolean sliding_out = false;
  protected boolean finished = false;
  protected boolean hovered = false;
  protected float time_left = Constants.notification_slide_time;

  NotificationLNZ() {
  }

  void update(int time_elapsed) {
    if (this.finished) {
      return;
    }
    this.drawNotification();
    this.time_left -= time_elapsed;
    if (this.time_left < 0) {
      if (this.sliding_in) {
        this.sliding_in = false;
        this.time_left = Constants.notification_display_time;
      }
      else if (this.sliding_out) {
        this.finished = true;
      }
      else {
        this.sliding_out = true;
        this.time_left = Constants.notification_slide_time;
      }
    }
  }

  abstract void drawNotification();

  void mouseMove(float mX, float mY) {
    if (!this.sliding_in && !this.sliding_out && this.hovered(mX, mY)) {
      this.time_left = Constants.notification_display_time;
      this.hovered = true;
    }
    else {
      this.hovered = false;
    }
  }

  abstract boolean hovered(float mX, float mY);

  void mousePress() {
    if (this.hovered) {
      this.finished = true;
    }
  }
}


class AchievementNotification extends NotificationLNZ {
  AchievementCode code;
  AchievementNotification(AchievementCode code) {
    super();
    this.code = code;
  }

  void drawNotification() {
    fill(160, 155, 88, 200);
    noStroke();
    rectMode(CORNERS);
    if (this.sliding_in) {
      float curr_height = Constants.notification_achievement_height *
        (1 - this.time_left / Constants.notification_slide_time);
      rect(width - Constants.notification_achievement_width, height - curr_height, width, height);
    }
    else if (this.sliding_out) {
      float curr_height = Constants.notification_achievement_height *
        this.time_left / Constants.notification_slide_time;
      rect(width - Constants.notification_achievement_width, height - curr_height, width, height);
    }
    else {
      rect(width - Constants.notification_achievement_width, height -
        Constants.notification_achievement_height, width, height);
      fill(0);
      textSize(18);
      textAlign(CENTER, TOP);
      text("Achievement Complete!", width - 0.5 * Constants.notification_achievement_width,
        height - Constants.notification_achievement_height - 1);
      float offset = textAscent() + textDescent() + 2;
      stroke(0);
      strokeWeight(2);
      line(width - Constants.notification_achievement_width + 3, height -
        Constants.notification_achievement_height + offset, width - 3, height -
        Constants.notification_achievement_height + offset);
      textSize(16);
      textAlign(CENTER, CENTER);
      text(code.display_name(), width - 0.5 * Constants.notification_achievement_width,
        height - 0.5 * (Constants.notification_achievement_height - offset));
    }
  }

  boolean hovered(float mX, float mY) {
    if (width - mX < Constants.notification_achievement_width && height - mY <
      Constants.notification_achievement_height && mX < width && mY < height) {
      return true;
    }
    return false;
  }
}
