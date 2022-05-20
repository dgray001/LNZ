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
    if (this.met) {
      return;
    }
    switch(this.ID) {
      case 1: // select ben
        break;
      case 2: // move toward arrow
        break;
      case 3: // go to room
        break;
      case 4: // kill chicken
        break;
      case 5: // unlock inventory
        break;
      case 6: // use backpack
        if (level.player != null && level.player.inventory.slots.size() > 2) {
          this.meet();
        }
        break;
      case 7: // damage john rankin
        break;
      case 8: // drink water
        break;
      case 9: // eat food
        break;
      case 10: // sleep
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
      case 4: // kill chicken
        return "Kill the chicken";
      case 5: // unlock inventory
        return "Unlock your inventory";
      case 6: // use backpack
        return "Use your backpack";
      case 7: // damage john rankin
        return "Chase away John Rankin";
      case 8: // drink water
        return "Drink water";
      case 9: // eat food
        return "Eat food";
      case 10: // sleep
        return "Go to sleep";
      default:
        return "";
    }
  }

  String shortDescription() {
    switch(this.ID) {
      case 1: // select ben
        return "Select Ben Nelson by left-clicking him.";
      case 2: // move toward arrow
        return "Move Ben Nelson toward the arrow by right-clicking near the arrow.";
      case 3: // go to room
        return "Your room is on the second floor of Francis Hall.";
      case 4: // kill chicken
        return "Attack the chicken by right-clicking it.";
      case 5: // unlock inventory
        return "Unlock your inventory in the HeroTree, which you can open with 'ctrl-t'.";
      case 6: // use backpack
        return "Use your backpack by placing it in your primary hand and pressing 'r'.";
      case 7: // damage john rankin
        return "Chase away John Rankin by damaging him. Your base attack won't be enough.";
      case 8: // drink water
        return "Drink water by right-clicking the water fountain outside your room.";
      case 9: // eat food
        return "There's food in your fridge that will quell your hunger.";
      case 10: // sleep
        return "Go to sleep by right-clicking your bed at night-time.";
      default:
        return "";
    }
  }
}
