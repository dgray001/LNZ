class Ability {
  private int ID = 0;
  private int timer_cooldown = 0;
  private int timer_other = 0;
  private int target_key = -1;
  private int stacks = 0;
  private boolean toggle = false;

  Ability(int ID) {
    this.ID = ID;
    switch(this.ID) {
      case 101:
      case 102:
      case 103:
      case 104:
      case 105:
      case 106:
      case 107:
      case 108:
      case 109:
      case 110:
        break;
      default:
        global.errorMessage("ERROR: Ability ID " + this.ID + " not found.");
        break;
    }
  }

  String displayName() {
    switch(this.ID) {
      case 101:
        return "Fearless Leader";
      case 102:
        return "Mighty Pen";
      case 103:
        return "Nelson Glare";
      case 104:
        return "Senseless Grit";
      case 105:
        return "Rage of the Ben";
      case 106:
        return "Fearless Leader II";
      case 107:
        return "Mighty Pen II";
      case 108:
        return "Nelson Glare II";
      case 109:
        return "Senseless Grit II";
      case 110:
        return "Rage of the Ben II";
      default:
        return "ERROR";
    }
  }

  String description() {
    switch(this.ID) {
      case 101:
        return "Each time you damage, are damaged, or receive a negative status " +
          "effect, gain 2% rage, to a maximum of 100. Also gain 6% rage for " +
          "a kill. After not increasing rage for 4s your rage will decrease " +
          "by 1% every 1s. Gain +0.25% bonus tenacity and attack speed for " +
          "every rage you have.";
      case 102:
        return "";
      case 103:
        return "";
      case 104:
        return "";
      case 105:
        return "";
      case 106:
        return "Each time you damage, are damaged, or receive a negative status " +
          "effect, gain 4% rage, to a maximum of 100. Also gain 10% rage for " +
          "a kill. After not increasing rage for 6s your rage will decrease " +
          "by 1% every 1.5s. Gain +0.4% bonus tenacity and attack speed for " +
          "every rage you have.";
      case 107:
        return "";
      case 108:
        return "";
      case 109:
        return "";
      case 110:
        return "";
      default:
        return "-- error -- ";
    }
  }

  int manaCost() {
    switch(this.ID) {
      case 102:
        return 25;
      case 103:
        return -8;
      case 104:
        return -8;
      case 105:
        return -40;
      case 107:
        return 25;
      case 108:
        return -15;
      case 109:
        return -15;
      case 110:
        return -60;
      default:
        return 0;
    }
  }

  int timer_cooldown() {
    switch(this.ID) {
      case 102:
        return 6000;
      case 103:
        return 18000;
      case 104:
        return 15000;
      case 105:
        return 120000;
      case 107:
        return 5000;
      case 108:
        return 12000;
      case 109:
        return 10000;
      case 110:
        return 100000;
      default:
        return 0;
    }
  }


  PImage getImage() {
    return global.images.getImage("abilities/" + this.ID + ".png");
  }


  void activate(Unit u, GameMap map) {
    this.activate(u, map, -1);
  }
  void activate(Unit u, GameMap map, int target_key) {
    this.target_key = target_key;
    if (Hero.class.isInstance(u)) {
      Hero h = (Hero)u;
      h.decreaseMana(this.manaCost());
    }
    this.timer_cooldown = this.timer_cooldown();
    switch(this.ID) {
      default:
        global.errorMessage("ERROR: Can't activate ability with ID " + this.ID + ".");
        break;
    }
  }


  void update(int timeElapsed, Unit u, GameMap map) {
    this.update(timeElapsed);
    switch(this.ID) {
      case 101: // Fearless Leader I
        if (this.timer_other <= 0) {
          if (Hero.class.isInstance(u)) {
            ((Hero)u).decreaseMana(1);
          }
          else {
            global.errorMessage("ERROR: Only Hero units can have Ability " + this.ID + ".");
          }
          this.timer_other = 500;
        }
        break;
      case 106: // Fearless Leader II
        if (this.timer_other <= 0) {
          if (Hero.class.isInstance(u)) {
            ((Hero)u).decreaseMana(1);
          }
          else {
            global.errorMessage("ERROR: Only Hero units can have Ability " + this.ID + ".");
          }
          this.timer_other = 800;
        }
        break;
      default:
        break;
    }
  }


  void update(int timeElapsed) {
    if (this.timer_cooldown > 0) {
      this.timer_cooldown -= timeElapsed;
    }
    if (this.timer_other > 0) {
      this.timer_other -= timeElapsed;
    }
  }


  void addStack() {
    this.stacks++;
    switch(this.ID) {
      default:
        global.errorMessage("ERROR: Ability ID " + this.ID + " can't add stack.");
        break;
    }
  }


  String fileString() {
    String fileString = "\nnew: Ability: " + this.ID;
    fileString += "\ntimer_cooldown: " + this.timer_cooldown;
    fileString += "\ntimer_other: " + this.timer_other;
    fileString += "\ntarget_key: " + this.target_key;
    fileString += "\nstacks: " + this.stacks;
    fileString += "\ntoggle: " + this.toggle;
    return fileString;
  }

  void addData(String datakey, String data) {
    switch(datakey) {
      case "timer_cooldown":
        this.timer_cooldown = toInt(data);
        break;
      case "timer_other":
        this.timer_other = toInt(data);
        break;
      case "target_key":
        this.target_key = toInt(data);
        break;
      case "stacks":
        this.stacks = toInt(data);
        break;
      case "toggle":
        this.toggle = toBoolean(data);
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not found for Ability data.");
        break;
    }
  }
}
