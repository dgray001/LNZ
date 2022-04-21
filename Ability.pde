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
      // Ben Nelson
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
      // Ben Nelson
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
      // Ben Nelson
      case 101:
        return "Ben is our fearless leader so never backs down from a fight.\n" +
          "Each time you damage, are damaged, or receive a negative status " +
          "effect, gain 2% rage, to a maximum of 100. Also gain 6% rage for " +
          "a kill. After not increasing rage for 4s your rage will decrease " +
          "by 1% every 1s. Gain +0.25% bonus tenacity and attack speed for " +
          "every rage you have.";
      case 102:
        return "Ben knows well the Pen is mightier than the Sword.\nThrow a " +
          "pen with 1 (40% + 40%) mixed power 5m. If Ben is holding a pen or " +
          "pencil it has 5 (80% + 80%) mixed power.\nIf Mighty Pen hits a " +
          "target Ben will heal for 20% of damage dealt.";
      case 103:
        return "We all cower when Ben throws his glare our way.\nFace target " +
          "direction and glare at all enemies in a cone 2m long, lowering " +
          "their attack and movement speed by 15% for 4s.\nEnemies in the " +
          "center of the cone are also silenced for the duration.";
      case 104:
        return "Ben's grit transcends all reason.\nPassive: Heal 1% missing " +
          "health every 3s.\nActive: Heal 15% missing health and gain 25% " +
          "move speed when targeting enemies for 3s.";
      case 105:
        return "Ben unleashes the totality of his rage.\nInstantly gain 40 " +
          "rage, become invulnerable and gain +40% attack for 5s.\nDuring " +
          "Rage of the Ben, your passive rage increases are increased by 40%, " +
          "you gain a 30% bonus to tenacity and attack speed if your rage is " +
          "at 100%, and you cannot cast Mighty Pen (a).";
      case 106:
        return "Ben is our fearless leader so never backs down from a fight.\n" +
          "Each time you damage, are damaged, or receive a negative status " +
          "effect, gain 4% rage, to a maximum of 100. Also gain 10% rage for " +
          "a kill. After not increasing rage for 6s your rage will decrease " +
          "by 1% every 1.5s. Gain +0.4% bonus tenacity and attack speed for " +
          "every rage you have.";
      case 107:
        return "Ben knows well the Pen is mightier than the Sword.\nThrow a " +
          "pen with 10 (50% + 50%) mixed power 5m. If Ben is holding a pen or " +
          "pencil it has 50 (100% + 100%) mixed power.\nIf Mighty Pen hits a " +
          "target Ben will heal for 30% of damage dealt.";
      case 108:
        return "We all cower when Ben throws his glare our way.\nFace target " +
          "direction and glare at all enemies in a cone 3m long, lowering " +
          "their attack and movement speed by 25% for 5s.\nEnemies in the " +
          "center of the cone are also silenced for the duration.";
      case 109:
        return "Ben's grit transcends all reason.\nPassive: Heal 1% missing " +
          "health every 1.5s.\nActive: Heal 25% missing health and gain 35% " +
          "move speed when targeting enemies for 4s.";
      case 110:
        return "Ben unleashes the totality of his rage.\nInstantly gain 60 " +
          "rage, become invulnerable and gain +50% attack for 7s.\nDuring " +
          "Rage of the Ben, your passive rage increases are increased by 60%, " +
          "you gain a 50% bonus to tenacity and attack speed if your rage is " +
          "at 100%, and you cannot cast Mighty Pen (a).";
      default:
        return "-- error -- ";
    }
  }

  int manaCost() {
    switch(this.ID) {
      // Ben Nelson
      case 102:
        return 25;
      case 103:
        return 0;
      case 104:
        return 0;
      case 105:
        return -40;
      case 107:
        return 25;
      case 108:
        return 0;
      case 109:
        return 0;
      case 110:
        return -60;
      default:
        return 0;
    }
  }

  int timer_cooldown() {
    switch(this.ID) {
      // Ben Nelson
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

  boolean turnsCaster() {
    switch(this.ID) {
      case 102:
      case 103:
      case 107:
      case 108:
        return true;
      default:
        return false;
    }
  }

  boolean castsOnTarget() {
    switch(this.ID) {
      default:
        return false;
    }
  }

  boolean checkMana() {
    switch(this.ID) {
      case 102:
      case 103:
        return false;
      default:
        return true;
    }
  }


  PImage getImage() {
    int image_id = 0;
    switch(this.ID) {
      // Ben Nelson
      case 101:
      case 106:
        image_id = 101;
      case 102:
      case 107:
        image_id = 102;
      case 103:
      case 108:
        image_id = 103;
      case 104:
      case 109:
        image_id = 104;
      case 105:
      case 110:
        image_id = 105;
      default:
        break;
    }
    return global.images.getImage("abilities/" + this.ID + ".png");
  }


  void activate(Unit u, int source_key, GameMap map) {
    this.activate(u, source_key, map, -10);
  }
  void activate(Unit u, int source_key, GameMap map, int target_key) {
    switch(this.ID) {
      case 102: // Mighty Pen
      case 107: // Mighty Pen II
        //if (u.rage_of_the_ben()) {
        //  return;
        //}
        break;
      default:
        break;
    }
    this.target_key = target_key;
    u.decreaseMana(this.manaCost());
    this.timer_cooldown = this.timer_cooldown();
    switch(this.ID) {
      case 102: // Mighty Pen
        map.addProjectile(new Projectile(3001, source_key, u));
        break;
      case 107: // Mighty Pen II
        map.addProjectile(new Projectile(3002, source_key, u));
        break;
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
