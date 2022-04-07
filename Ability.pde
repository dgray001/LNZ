class Ability {
  private int ID = 0;
  private int timer_cooldown = 0;
  private int timer_other = 0;
  private int target_key = -1;

  Ability(int ID) {
    switch(ID) {
      default:
        global.errorMessage("ERROR: Ability ID " + this.ID + " not found.");
        break;
    }
  }

  String displayName() {
    switch(this.ID) {
      default:
        return "ERROR";
    }
  }

  String description() {
    switch(this.ID) {
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


  void update(Unit u, GameMap map) {
  }


  void update(int timeElapsed) {
    if (this.timer_cooldown > 0) {
      this.timer_cooldown -= timeElapsed;
    }
    if (this.timer_other > 0) {
      this.timer_other -= timeElapsed;
    }
  }


  float health(float curr_health) {
    switch(this.ID) {
      default:
        return curr_health;
    }
  }

  float attack(float curr_attack) {
    switch(this.ID) {
      default:
        return curr_attack;
    }
  }

  float magic(float curr_magic) {
    switch(this.ID) {
      default:
        return curr_magic;
    }
  }

  float defense(float curr_defense) {
    switch(this.ID) {
      default:
        return curr_defense;
    }
  }

  float resistance(float curr_resistance) {
    switch(this.ID) {
      default:
        return curr_resistance;
    }
  }

  float piercing(float curr_piercing) {
    switch(this.ID) {
      default:
        return curr_piercing;
    }
  }

  float penetration(float curr_penetration) {
    switch(this.ID) {
      default:
        return curr_penetration;
    }
  }

  float attackRange(float curr_attackRange) {
    switch(this.ID) {
      default:
        return curr_attackRange;
    }
  }

  float attackCooldown(float curr_attackCooldown) {
    switch(this.ID) {
      default:
        return curr_attackCooldown;
    }
  }

  float attackTime(float curr_attackTime) {
    switch(this.ID) {
      default:
        return curr_attackTime;
    }
  }

  float sight(float curr_sight) {
    switch(this.ID) {
      default:
        return curr_sight;
    }
  }

  float speed(float curr_speed) {
    switch(this.ID) {
      default:
        return curr_speed;
    }
  }

  float tenacity(float curr_tenacity) {
    switch(this.ID) {
      default:
        return curr_tenacity;
    }
  }

  int agility(int curr_agility) {
    switch(this.ID) {
      default:
        return curr_agility;
    }
  }
}
