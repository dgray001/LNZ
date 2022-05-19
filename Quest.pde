class Quest {
  protected int ID = 0;
  protected boolean met = false;
  protected int blink_time_left = Constants.level_questBlinkTime;
  protected int blinks_left = Constants.level_questBlinks;
  protected boolean blinking = false;

  Quest(int id) {
    this.ID = id;
  }

  void meet() {
    this.met = true;
    global.sounds.trigger_player("player/quest");
    this.blink_time_left = Constants.level_questBlinkTime;
    this.blinks_left = Constants.level_questBlinks;
    this.blinking = false;
  }

  void update(Level level, int timeElapsed) {
    if (this.blink_time_left > 0) {
      this.blink_time_left -= timeElapsed;
      if (this.blink_time_left <= 0) {
        if (this.blinking) {
          this.blinking = false;
          this.blink_time_left = Constants.level_questBlinkTime;
        }
        else if (this.blinks_left > 0) {
          this.blinking = true;
          this.blinks_left--;
          this.blink_time_left = Constants.level_questBlinkTime;
        }
      }
    }
    switch(this.ID) {
      case 1: // select ben
        break;
      case 2: // move toward arrow
        break;
      case 3: // go to room
        break;
      default:
        global.errorMessage("ERROR: Quest ID " + this.ID + " not recognized.");
        break;
    }
  }

  String name() {
    switch(this.ID) {
      case 1: // select ben
        return "Select Ben Nelson";
      case 2: // move toward arrow
        return "Move Ben Nelson toward the arrow";
      case 3: // go to room
        return "Go to your room";
      default:
        return "";
    }
  }

  String shortDescription() {
    switch(this.ID) {
      case 1: // select ben
        return "Select Ben Nelson by left-clicking him";
      case 2: // move toward arrow
        return "Move Ben Nelson toward the arrow by right-clicking near the arrow";
      case 3: // go to room
        return "Your room is on the second floor of Francis Hall";
      default:
        return "";
    }
  }
}
