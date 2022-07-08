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


abstract class BottomRightNotification extends NotificationLNZ {
  private String header;
  private String content;
  private color color_background;
  private color color_text;

  BottomRightNotification(String header, String content, color color_background, color color_text) {
    super();
    this.header = header;
    this.content = content;
    this.color_background = color_background;
    this.color_text = color_text;
  }

  void drawNotification() {
    fill(this.color_background);
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
      fill(this.color_text);
      textSize(18);
      textAlign(CENTER, TOP);
      text(this.header, width - 0.5 * Constants.notification_achievement_width,
        height - Constants.notification_achievement_height - 1);
      float offset = textAscent() + textDescent() + 2;
      stroke(this.color_text);
      strokeWeight(2);
      line(width - Constants.notification_achievement_width + 3, height -
        Constants.notification_achievement_height + offset, width - 3, height -
        Constants.notification_achievement_height + offset);
      textSize(16);
      textAlign(CENTER, CENTER);
      text(this.content, width - 0.5 * Constants.notification_achievement_width,
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


class AchievementNotification extends BottomRightNotification {
  AchievementNotification(AchievementCode code) {
    super("Achievement Complete!", code.display_name(), color(160, 155, 88, 200), color(0));
  }
}


class AreaUnlockNotification extends BottomRightNotification {
  AreaUnlockNotification(Location location) {
    super("Area Unlocked!", location.display_name(), color(177, 156, 217, 200), color(0));
  }
}


class HeroUnlockNotification extends BottomRightNotification {
  HeroUnlockNotification(HeroCode code) {
    super("Hero Unlocked!", code.display_name(), color(255, 127, 127, 200), color(0));
  }
}


class MinigameUnlockNotification extends BottomRightNotification {
  MinigameUnlockNotification(MinigameName name) {
    super("Minigame Unlocked!", name.displayName(), color(100, 255, 255, 200), color(0));
  }
}
