class Ability {
  private int ID = 0;
  private float timer_cooldown = 0;
  private float timer_other = 0;
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
      // Daniel Gray
      case 111:
      case 112:
      case 113:
      case 114:
      case 115:
      case 116:
      case 117:
      case 118:
      case 119:
      case 120:
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
      // Daniel Gray
      case 111:
        return "Aposematic Camouflage";
      case 112:
        return "Tongue Lash";
      case 113:
        return "Amphibious Leap";
      case 114:
        return "Alkaloid Excretion";
      case 115:
        return "Anuran Appetite";
      case 116:
        return "Aposematic Camouflage II";
      case 117:
        return "Tongue Lash II";
      case 118:
        return "Amphibious Leap II";
      case 119:
        return "Alkaloid Excretion II";
      case 120:
        return "Anuran Appetite II";
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
          "effect, gain " + Constants.ability_101_rageGain + "% rage, to a " +
          "maximum of 100. Also gain " + Constants.ability_101_rageGainKill +
          "% rage for a kill. After not increasing rage for " + (Constants.
          ability_101_cooldownTimer/1000) + "s your rage will decrease by 1% " +
          "every " + (Constants.ability_101_tickTimer/1000) + "s.\nGain +" +
          (100*Constants.ability_101_bonusAmount) + "% bonus tenacity and attack " +
          "speed for every rage you have.";
      case 102:
        return "Ben knows well the Pen is mightier than the Sword.\nThrow a " +
          "pen with " + Constants.ability_102_powerBase + " + (" + round(Constants.
          ability_102_powerRatio*100) + "% attack power + " + round(Constants.ability_102_powerRatio*
          100) + "% magic power) mixed power " + Constants.ability_102_distance + "m. If " +
          "Ben is holding a pen or pencil it has " + Constants.ability_102_powerBasePen +
          " (" + round(Constants.ability_102_powerRatioPen*100) + "% attack power + " + round(Constants.
          ability_102_powerRatioPen*100) + "% magic power) mixed power.\nIf Mighty Pen hits " +
          "a target Ben will heal for " + (Constants.ability_102_healRatio*100) +
          "% of damage dealt.";
      case 103:
        return "We all cower when Ben throws his glare our way.\nFace target " +
          "direction and glare at all enemies in a cone " + Constants.
          ability_103_range + "m long, lowering their attack and movement speed " +
          "by " + round((1 - Constants.ability_103_debuff)*100) + "% for " + (Constants.
          ability_103_time/1000) + "s.\nEnemies in the center of the cone are " +
          "also silenced for the duration.";
      case 104:
        return "Ben's grit transcends all reason.\nPassive: Heal " + round(
          Constants.ability_104_passiveHealAmount*100) + "% missing health " +
          "every " + (Constants.ability_104_passiveHealTimer/1000) + "s.\nActive: " +
          "Heal " + round(Constants.ability_104_activeHealAmount*100) + "% " +
          "missing health and gain " + round((Constants.ability_104_speedBuff-1)*100) +
          "% move speed when targeting enemies for " + (Constants.
          ability_104_speedBuffTimer/1000) + "s.";
      case 105:
        return "Ben unleashes the totality of his rage.\nInstantly gain " +
          Constants.ability_105_rageGain + " rage, become invulnerable and " +
          "gain +" + round((Constants.ability_105_buffAmount-1)*100) + "% attack " +
          "for " + (Constants.ability_105_buffTime/1000) + "s.\nDuring Rage of " +
          "the Ben:\n - Your passive rage increases are increased by " + round(
          (Constants.ability_105_rageGainBonus-1)*100) + "%\n - You gain a " + round(
          (Constants.ability_105_fullRageBonus-1)*100) + "% bonus to tenacity and " +
          "attack speed if your rage is at 100%\n - You cannot cast Mighty Pen (a)";
      case 106:
        return "Ben is our fearless leader so never backs down from a fight.\n" +
          "Each time you damage, are damaged, or receive a negative status " +
          "effect, gain " + Constants.ability_106_rageGain + "% rage, to a " +
          "maximum of 100. Also gain " + Constants.ability_106_rageGainKill +
          "% rage for a kill. After not increasing rage for " + Constants.
          ability_106_cooldownTimer/1000 + "s your rage will decrease by 1% " +
          "every " + Constants.ability_106_tickTimer/1000 + "s.\nGain +" +
          Constants.ability_106_bonusAmount + "% bonus tenacity and attack " +
          "speed for every rage you have.";
      case 107:
        return "Ben knows well the Pen is mightier than the Sword.\nThrow a " +
          "pen with " + Constants.ability_107_powerBase + " + (" + round(Constants.
          ability_107_powerRatio*100) + "% attack power + " + round(Constants.ability_107_powerRatio*
          100) + "% magic power) mixed power " + Constants.ability_107_distance + "m. If " +
          "Ben is holding a pen or pencil it has " + Constants.ability_107_powerBasePen +
          " (" + round(Constants.ability_107_powerRatioPen*100) + "% attack power + " + round(Constants.
          ability_107_powerRatioPen*100) + "% magic power) mixed power.\nIf Mighty Pen hits " +
          "a target Ben will heal for " + round(Constants.ability_107_healRatio*100) +
          "% of damage dealt.";
      case 108:
        return "We all cower when Ben throws his glare our way.\nFace target " +
          "direction and glare at all enemies in a cone " + Constants.
          ability_108_range + "m long, lowering their attack and movement speed " +
          "by " + round((1 - Constants.ability_108_debuff)*100) + "% for " + (Constants.
          ability_108_time/1000) + "s.\nEnemies in the center of the cone are " +
          "also silenced for the duration.";
      case 109:
        return "Ben's grit transcends all reason.\nPassive: Heal " + round(
          Constants.ability_109_passiveHealAmount*100) + "% missing health " +
          "every " + (Constants.ability_109_passiveHealTimer/1000) + "s.\nActive: " +
          "Heal " + round(Constants.ability_109_activeHealAmount*100) + "% " +
          "missing health and gain " + round((Constants.ability_109_speedBuff-1)*100) +
          "% move speed when targeting enemies for " + (Constants.
          ability_109_speedBuffTimer/1000) + "s.";
      case 110:
        return "Ben unleashes the totality of his rage.\nInstantly gain " +
          Constants.ability_110_rageGain + " rage, become invulnerable and " +
          "gain +" + round((Constants.ability_110_buffAmount-1)*100) + "% attack " +
          "for " + (Constants.ability_110_buffTime/1000) + "s.\nDuring Rage of " +
          "the Ben:\n - Your passive rage increases are increased by " + round(
          (Constants.ability_110_rageGainBonus-1)*100) + "%\n - You gain a " + round(
          (Constants.ability_110_fullRageBonus-1)*100) + "% bonus to tenacity and " +
          "attack speed if your rage is at 100%\n - You cannot cast Mighty Pen (a)";
      // Daniel Gray
      case 111:
        return "If still for " + int(round(Constants.ability_111_stillTime)) +
          "s, enemies cannot see you without getting within " + Constants.
          ability_111_distance + "m.\nWhile Dan is camouflaged, attacking or " +
          "casting \'Tongue Lash\' or \'Amphibious Leap\' will have " + int(
          100.0 * (Constants.ability_111_powerBuff-1)) + "% more power.\n\nDan " +
          "also absorbs frog energy from his surroundings, regenerating a frog " +
          "energy every " + Constants.ability_111_regenTime + " ms.";
      case 112:
        return "";
      case 113:
        return "";
      case 114:
        return "";
      case 115:
        return "";
      case 116:
        return "If still for " + int(round(Constants.ability_116_stillTime)) +
          "s, enemies cannot see you without getting within " + Constants.
          ability_116_distance + "m.\nWhile Dan is camouflaged, attacking or " +
          "casting \'Tongue Lash\' or \'Amphibious Leap\' will have " + int(
          100.0 * (Constants.ability_116_powerBuff-1)) + "% more power.\n\nDan " +
          "also absorbs frog energy from his surroundings, regenerating a frog " +
          "energy every " + Constants.ability_116_regenTime + " ms.";
      case 117:
        return "";
      case 118:
        return "";
      case 119:
        return "";
      case 120:
        return "";
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
      // Daniel Gray
      case 112:
        return 10;
      case 113:
        return 20;
      case 114:
        return 2;
      case 115:
        return 60;
      case 117:
        return 15;
      case 118:
        return 30;
      case 119:
        return 3;
      case 120:
        return 90;
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
      // Daniel Gray
      case 112:
        return 6000;
      case 113:
        return 18000;
      case 114:
        return 2000;
      case 115:
        return 120000;
      case 117:
        return 5000;
      case 118:
        return 15000;
      case 119:
        return 1200;
      case 120:
        return 90000;
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
      case 112:
      case 113:
      case 117:
      case 118:
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
      case 111:
      case 116:
        image_id = 111;
      case 112:
      case 117:
        image_id = 112;
      case 113:
      case 118:
        image_id = 113;
      case 114:
      case 119:
        image_id = 114;
      case 115:
      case 120:
        image_id = 115;
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
        if (u.rageOfTheBen()) {
          return;
        }
        break;
      default:
        break;
    }
    this.target_key = target_key;
    u.decreaseMana(this.manaCost());
    this.timer_cooldown = this.timer_cooldown();
    VisualEffect ve;
    switch(this.ID) {
      case 102: // Mighty Pen
        map.addProjectile(new Projectile(3001, source_key, u));
        break;
      case 103: // Nelson Glare
        this.timer_other = Constants.ability_103_castTime;
        this.toggle = true;
        ve = new VisualEffect(4103);
        ve.setLocation(u.x, u.y);
        ve.setValues(u.facingA - Constants.ability_103_coneAngle, u.facingA +
          Constants.ability_103_coneAngle, Constants.ability_103_castTime);
        map.addVisualEffect(ve);
        break;
      case 104: // Senseless Grit
        u.healPercent(Constants.ability_104_activeHealAmount, false);
        u.addStatusEffect(StatusEffectCode.SENSELESS_GRIT, Constants.ability_104_speedBuffTimer);
        break;
      case 105: // Rage of the Ben
        u.increaseMana(Constants.ability_105_rageGain);
        u.addStatusEffect(StatusEffectCode.INVULNERABLE, Constants.ability_105_buffTime);
        u.addStatusEffect(StatusEffectCode.RAGE_OF_THE_BEN, Constants.ability_105_buffTime);
        break;
      case 107: // Mighty Pen II
        map.addProjectile(new Projectile(3002, source_key, u));
        break;
      case 108: // Nelson Glare II
        this.timer_other = Constants.ability_108_castTime;
        this.toggle = true;
        ve = new VisualEffect(4108);
        ve.setLocation(u.x, u.y);
        ve.setValues(u.facingA - Constants.ability_108_coneAngle, u.facingA +
          Constants.ability_108_coneAngle, Constants.ability_108_castTime);
        map.addVisualEffect(ve);
        break;
      case 109: // Senseless Grit II
        u.healPercent(Constants.ability_109_activeHealAmount, false);
        u.addStatusEffect(StatusEffectCode.SENSELESS_GRITII, Constants.ability_109_speedBuffTimer);
        break;
      case 110: // Rage of the Ben II
        u.increaseMana(Constants.ability_110_rageGain);
        u.addStatusEffect(StatusEffectCode.INVULNERABLE, Constants.ability_110_buffTime);
        u.addStatusEffect(StatusEffectCode.RAGE_OF_THE_BENII, Constants.ability_110_buffTime);
        break;
      default:
        global.errorMessage("ERROR: Can't activate ability with ID " + this.ID + ".");
        break;
    }
  }


  void update(int timeElapsed, Unit u, GameMap map) {
    this.update(timeElapsed);
    float max_distance = 0;
    switch(this.ID) {
      case 101: // Fearless Leader I
        if (this.timer_other <= 0) {
          u.decreaseMana(1);
          this.timer_other = Constants.ability_101_tickTimer;
        }
        break;
      case 103: // Nelson Glare
        if (!this.toggle) {
          break;
        }
        max_distance = Constants.ability_103_range * (1 - this.timer_other
          / Constants.ability_103_castTime);
        for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
          Unit target = entry.getValue();
          if (target.alliance == u.alliance) {
            continue;
          }
          // already hit
          if (target.nelsonGlare()) {
            continue;
          }
          float distance = u.centerDistance(target);
          if (distance > max_distance + target.size) {
            continue;
          }
          if (distance > 0) {
            float angle = abs((float)Math.atan2(target.y - u.y, target.x - u.x) - u.facingA);
            float unit_angle = 2 * asin(0.5 * target.size / distance);
            if (angle > unit_angle + Constants.ability_103_coneAngle) {
              continue;
            }
          }
          target.addStatusEffect(StatusEffectCode.NELSON_GLARE, Constants.ability_103_time);
        }
        if (this.timer_other <= 0) {
          this.toggle = false;
        }
        break;
      case 104: // Senseless Grit
        if (this.timer_other <= 0) {
          u.healPercent(Constants.ability_104_passiveHealAmount, false);
          this.timer_other = Constants.ability_104_passiveHealTimer;
        }
        break;
      case 106: // Fearless Leader II
        if (this.timer_other <= 0) {
          u.decreaseMana(1);
          this.timer_other = Constants.ability_106_tickTimer;
        }
        break;
      case 108: // Nelson Glare II
        if (!this.toggle) {
          break;
        }
        max_distance = Constants.ability_108_range * (1 - this.timer_other
          / Constants.ability_108_castTime);
        for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
          Unit target = entry.getValue();
          if (target.alliance == u.alliance) {
            continue;
          }
          // already hit
          if (target.nelsonGlareII()) {
            continue;
          }
          float distance = u.centerDistance(target);
          if (distance > max_distance + target.size) {
            continue;
          }
          if (distance > 0) {
            float angle = abs((float)Math.atan2(target.y - u.y, target.x - u.x) - u.facingA);
            float unit_angle = 2 * asin(0.5 * target.size / distance);
            if (angle > unit_angle + Constants.ability_108_coneAngle) {
              continue;
            }
          }
          target.addStatusEffect(StatusEffectCode.NELSON_GLAREII, Constants.ability_108_time);
        }
        if (this.timer_other <= 0) {
          this.toggle = false;
        }
        break;
      case 109: // Senseless Grit II
        if (this.timer_other <= 0) {
          u.healPercent(Constants.ability_109_passiveHealAmount, false);
          this.timer_other = Constants.ability_109_passiveHealTimer;
        }
        break;
      case 111: // Aposematic Camouflage
        if (this.timer_other <= 0) {
          u.increaseMana(1);
          this.timer_other = Constants.ability_111_regenTime;
        }
        if (u.curr_action == UnitAction.NONE) {
          if (this.timer_cooldown <= 0 && !u.aposematicCamouflage() && !u.visible()) {
            u.addStatusEffect(StatusEffectCode.APOSEMATIC_CAMOUFLAGE);
          }
        }
        else {
          this.timer_cooldown = Constants.ability_111_stillTime;
        }
        break;
      case 116: // Aposematic Camouflage II
        if (this.timer_other <= 0) {
          u.increaseMana(1);
          this.timer_other = Constants.ability_116_regenTime;
        }
        if (u.curr_action == UnitAction.NONE) {
          if (this.timer_cooldown <= 0 && !u.aposematicCamouflageII() && !u.visible()) {
            u.addStatusEffect(StatusEffectCode.APOSEMATIC_CAMOUFLAGEII);
          }
        }
        else {
          this.timer_cooldown = Constants.ability_116_stillTime;
        }
        break;
      default:
        break;
    }
  }


  void update(int timeElapsed) {
    if (this.timer_cooldown > 0) {
      this.timer_cooldown -= timeElapsed;
      if (this.timer_cooldown < 0) {
        this.timer_cooldown = 0;
      }
    }
    if (this.timer_other > 0) {
      this.timer_other -= timeElapsed;
      if (this.timer_other < 0) {
        this.timer_other = 0;
      }
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
        this.timer_cooldown = toFloat(data);
        break;
      case "timer_other":
        this.timer_other = toFloat(data);
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
