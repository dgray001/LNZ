class Ability {
  private int ID = 0;
  private float timer_cooldown = 0;
  private float timer_other = 0;
  private Unit target_unit = null;
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
        return "Alkaloid Secretion";
      case 115:
        return "Anuran Appetite";
      case 116:
        return "Aposematic Camouflage II";
      case 117:
        return "Tongue Lash II";
      case 118:
        return "Amphibious Leap II";
      case 119:
        return "Alkaloid Secretion II";
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
          "by " + round((1-Constants.ability_103_debuff)*100) + "% for " + (Constants.
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
          "by " + round((1-Constants.ability_108_debuff)*100) + "% for " + (Constants.
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
        return "As a Frog-Human hybrid, Dan can express his inner frog enery.\n" +
          "If still for " + int(round(Constants.ability_111_stillTime)) +
          "s, enemies cannot see you without getting within " + Constants.
          ability_111_distance + "m.\nWhile Dan is camouflaged, attacking or " +
          "casting \'Tongue Lash\' or \'Amphibious Leap\' will have " + int(
          100.0 * (Constants.ability_111_powerBuff-1)) + "% more power.\n\nDan " +
          "also absorbs frog energy from his surroundings, regenerating a frog " +
          "energy every " + Constants.ability_111_regenTime + "ms.";
      case 112:
        return "Dan lashes out his frog-like tongue.\nLash your tongue " + Constants.
          ability_112_distance + "m and damage the first enemy it hits for " +
          Constants.ability_112_basePower + " + (" + round(Constants.ability_112_physicalRatio
          *100) + "% attack power + " + round(Constants.ability_112_magicalRatio*100) +
          "% magic power) magical power.\nThe enemy hit will also be slowed " +
          int((1-Constants.ability_112_slowAmount)*100) + "% for " + (Constants.
          ability_112_slowTime/1000) + "s.";
      case 113:
        return "Dan leaps like the frog he believes he is.\nJump " + Constants.
          ability_113_jumpDistance + "m and with " + Constants.ability_113_basePower +
          " + (" + round(Constants.ability_113_physicalRatio*100) + "% attack power " +
          "+ " + round(Constants.ability_113_magicalRatio*100) + "% magic power) " +
          "magical power deal splash damage and stun for " + (Constants.ability_113_stunTime/
          1000) + "s all enemies within a " + Constants.ability_113_splashRadius +
          "m radius of where you land.\nKills decrease the remaining cooldown of " +
          "\'Tongue Lash\' by " + ((1-Constants.ability_113_killCooldownReduction)*100) +
          "%.\nIf drenched, the jump distance is " + Constants.ability_113_drenchedJumpDistance +
          "m and the splash radius is " + Constants.ability_113_drenchedSplashRadius + "m.";
      case 114:
        return "Dan secretes poisonous alkaloids in all directions around him.\n" +
          "While this ability is active, Dan will deal " + round(100*
          Constants.ability_114_currHealth) + "% curr health and additional " +
          "damage with " + Constants.ability_114_basePower + " + (0% attack " +
          "power + " + round(Constants.ability_114_magicRatio*100) + "% magic " +
          "power) magical power to all enemies within " + round(10 * Constants.
          ability_114_range)/10.0 + "m of him every " + Constants.ability_114_tickTime +
          "ms.\nEnemies hit by \'Alkaloid Secretion\' will also be rotting for " +
          (Constants.ability_114_rotTime/1000.0) + "s.\nThe mana cost is consumed " +
          "every time damage is dealt.";
      case 115:
        return "With a frog's appetite, Dan is sometimes more interested in " +
          "eating his enemies than actually killing them.\nDevour target enemy " +
          "within " + Constants.ability_115_range + "m, making them suppressed, " +
          "untargetable, and decayed while devoured.\nRecast this ability to spit " +
          "them out " + Constants.ability_115_regurgitateDistance + "m and deal " +
          "damage with " + Constants.ability_115_basePower + " + (" + round(100*Constants.
          ability_115_physicalRatio) + "% attack power + " + round(100*Constants.
          ability_115_magicalRatio) + "% magic power) magic damage.\nIf this ability " +
          "is not recast within " + (Constants.ability_115_maxTime/1000.0) + "s " +
          "it will be automatically recast.";
      case 116:
        return "As a Frog-Human hybrid, Dan can express his inner frog enery.\n" +
          "If still for " + int(round(Constants.ability_116_stillTime)) +
          "s, enemies cannot see you without getting within " + Constants.
          ability_116_distance + "m.\nWhile Dan is camouflaged, attacking or " +
          "casting \'Tongue Lash\' or \'Amphibious Leap\' will have " + int(
          100.0 * (Constants.ability_116_powerBuff-1)) + "% more power.\n\nDan " +
          "also absorbs frog energy from his surroundings, regenerating a frog " +
          "energy every " + Constants.ability_116_regenTime + "ms.";
      case 117:
        return "Dan lashes out his frog-like tongue.\nLash your tongue " + Constants.
          ability_117_distance + "m and damage the first enemy it hits for " +
          Constants.ability_117_basePower + " + (" + round(Constants.ability_117_physicalRatio
          *100) + "% attack power + " + round(Constants.ability_117_magicalRatio*100) +
          "% magic power) magical power.\nThe enemy hit will also be slowed " +
          int((1-Constants.ability_112_slowAmount)*100) + "% for " + (Constants.
          ability_117_slowTime/1000) + "s.";
      case 118:
        return "Dan leaps like the frog he always wanted to be.\nJump " + Constants.
          ability_118_jumpDistance + "m and with " + Constants.ability_118_basePower +
          " + (" + round(Constants.ability_118_physicalRatio*100) + "% attack power " +
          "+ " + round(Constants.ability_118_magicalRatio*100) + "% magic power) " +
          "magical power deal splash damage and stun for " + (Constants.ability_118_stunTime/
          1000) + "s all enemies within a " + Constants.ability_118_splashRadius +
          "m radius of where you land.\nKills decrease the remaining cooldown of " +
          "\'Tongue Lash\' by " + ((1-Constants.ability_118_killCooldownReduction)*100) +
          "%.\nIf drenched, the jump distance is " + Constants.ability_118_drenchedJumpDistance +
          "m and the splash radius is " + Constants.ability_118_drenchedSplashRadius + "m.";
      case 119:
        return "Dan secretes poisonous alkaloids in all directions around him.\n" +
          "While this ability is active, Dan will deal " + round(100*
          Constants.ability_119_currHealth) + "% curr health and additional " +
          "damage with " + Constants.ability_119_basePower + " + (0% attack " +
          "power + " + round(Constants.ability_119_magicRatio*100) + "% magic " +
          "power) magical power to all enemies within " + round(10 * Constants.
          ability_119_range)/10.0 + " m of him every " + Constants.ability_114_tickTime +
          "ms.\nEnemies hit by \'Alkaloid Secretion\' will also be rotting for " +
          (Constants.ability_114_rotTime/1000.0) + "s.\nThe mana cost is consumed " +
          "every time damage is dealt.";
      case 120:
        return "With a frog's appetite, Dan is sometimes more interested in " +
          "eating his enemies than actually killing them.\nDevour target enemy " +
          "within " + Constants.ability_115_range + "m, making them suppressed, " +
          "untargetable, and decayed while devoured.\nRecast this ability to spit " +
          "them out " + Constants.ability_115_regurgitateDistance + "m and deal " +
          "damage with " + Constants.ability_120_basePower + " + (" + round(100*Constants.
          ability_120_physicalRatio) + "% attack power + " + round(100*Constants.
          ability_120_magicalRatio) + "% magic power) magic damage.\nIf this ability " +
          "is not recast within " + (Constants.ability_120_maxTime/1000.0) + "s " +
          "it will be automatically recast.";
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

  float timer_cooldown() {
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
      case 111:
        return Constants.ability_111_stillTime;
      case 112:
        return 6000;
      case 113:
        return 18000;
      case 114:
        return 2000;
      case 115:
        return 120000;
      case 116:
        return Constants.ability_116_stillTime;
      case 117:
        return 5000;
      case 118:
        return 16000;
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
      case 115:
      case 120:
        if (this.toggle) {
          return true;
        }
        else {
          return false;
        }
      default:
        return false;
    }
  }

  boolean castsOnTarget() {
    switch(this.ID) {
      case 115: // Anuran Appetite
      case 120: // Anuran Appetite II
        if (this.toggle) {
          return false;
        }
        else {
          return true;
        }
      default:
        return false;
    }
  }

  float castsOnTargetRange() {
    switch(this.ID) {
      case 115: // Anuran Appetite
      case 120: // Anuran Appetite II
        return Constants.ability_115_range;
      default:
        return 0;
    }
  }

  boolean checkMana() {
    switch(this.ID) {
      case 101:
      case 102:
      case 103:
      case 106:
      case 107:
      case 108:
        return false;
      case 115:
      case 120:
        if (this.toggle) {
          return false;
        }
        else {
          return true;
        }
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
    this.activate(u, source_key, map, null, -1);
  }
  void activate(Unit u, int source_key, GameMap map, Unit target_unit, int target_key) {
    int ability_index = u.curr_action_id;
    u.curr_action_id = 0;
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
    if (this.castsOnTarget()) {
      this.target_unit = target_unit;
      this.target_key = target_key;
      if (this.target_unit == null || this.target_unit.remove) {
        return;
      }
      if (u.distance(this.target_unit) > this.castsOnTargetRange()) {
        return;
      }
    }
    u.decreaseMana(this.manaCost());
    this.timer_cooldown = this.timer_cooldown();
    VisualEffect ve;
    switch(this.ID) {
      case 102: // Mighty Pen
        map.addProjectile(new Projectile(3001, source_key, u));
        global.sounds.trigger_units("items/throw", u.x - map.viewX, u.y - map.viewY);
        break;
      case 103: // Nelson Glare
        this.timer_other = Constants.ability_103_castTime;
        this.toggle = true;
        u.curr_action = UnitAction.CASTING;
        u.curr_action_id = ability_index;
        global.sounds.trigger_units("units/ability/103", u.x - map.viewX, u.y - map.viewY);
        break;
      case 104: // Senseless Grit
        u.healPercent(Constants.ability_104_activeHealAmount, false);
        u.addStatusEffect(StatusEffectCode.SENSELESS_GRIT, Constants.ability_104_speedBuffTimer);
        global.sounds.trigger_units("units/ability/104", u.x - map.viewX, u.y - map.viewY);
        break;
      case 105: // Rage of the Ben
        u.increaseMana(Constants.ability_105_rageGain);
        u.addStatusEffect(StatusEffectCode.INVULNERABLE, Constants.ability_105_buffTime);
        u.addStatusEffect(StatusEffectCode.RAGE_OF_THE_BEN, Constants.ability_105_buffTime);
        global.sounds.trigger_units("units/ability/105", u.x - map.viewX, u.y - map.viewY);
        break;
      case 107: // Mighty Pen II
        map.addProjectile(new Projectile(3002, source_key, u));
        global.sounds.trigger_units("items/throw", u.x - map.viewX, u.y - map.viewY);
        break;
      case 108: // Nelson Glare II
        this.timer_other = Constants.ability_108_castTime;
        this.toggle = true;
        u.curr_action = UnitAction.CASTING;
        u.curr_action_id = ability_index;
        global.sounds.trigger_units("units/ability/103", u.x - map.viewX, u.y - map.viewY);
        break;
      case 109: // Senseless Grit II
        u.healPercent(Constants.ability_109_activeHealAmount, false);
        u.addStatusEffect(StatusEffectCode.SENSELESS_GRITII, Constants.ability_109_speedBuffTimer);
        global.sounds.trigger_units("units/ability/104", u.x - map.viewX, u.y - map.viewY);
        break;
      case 110: // Rage of the Ben II
        u.increaseMana(Constants.ability_110_rageGain);
        u.addStatusEffect(StatusEffectCode.INVULNERABLE, Constants.ability_110_buffTime);
        u.addStatusEffect(StatusEffectCode.RAGE_OF_THE_BENII, Constants.ability_110_buffTime);
        global.sounds.trigger_units("units/ability/110", u.x - map.viewX, u.y - map.viewY);
        break;
      case 112: // Tongue Lash
        this.timer_other = Constants.ability_112_castTime;
        this.toggle = true;
        u.curr_action = UnitAction.CASTING;
        u.curr_action_id = ability_index;
        global.sounds.trigger_units("units/ability/112", u.x - map.viewX, u.y - map.viewY);
        break;
      case 113: // Amphibious Leap
        if (u.drenched()) {
          this.timer_other = Constants.ability_113_drenchedJumpDistance;
        }
        else {
          this.timer_other = Constants.ability_113_jumpDistance;
        }
        this.toggle = true;
        u.curr_action_unhaltable = true;
        u.curr_action = UnitAction.CASTING;
        u.curr_action_id = ability_index;
        global.sounds.trigger_units("units/ability/113", u.x - map.viewX, u.y - map.viewY);
        break;
      case 114: // Alkaloid Secretion
        if (u.alkaloidSecretion()) {
          u.removeStatusEffect(StatusEffectCode.ALKALOID_SECRETION);
          global.sounds.silence_units("units/ability/114");
        }
        else {
          u.addStatusEffect(StatusEffectCode.ALKALOID_SECRETION);
          global.sounds.trigger_units("units/ability/114_start", u.x - map.viewX, u.y - map.viewY);
          global.sounds.trigger_units("units/ability/114", u.x - map.viewX, u.y - map.viewY);
          u.increaseMana(this.manaCost());
          this.timer_cooldown = 0;
        }
        break;
      case 115: // Anuran Appetite
        if (this.toggle) {
          this.timer_other = 0;
          u.increaseMana(this.manaCost());
        }
        else {
          this.toggle = true;
          this.timer_cooldown = 0;
          this.timer_other = Constants.ability_115_maxTime;
          this.target_unit.addStatusEffect(StatusEffectCode.SUPPRESSED, Constants.ability_115_maxTime);
          this.target_unit.addStatusEffect(StatusEffectCode.UNTARGETABLE, Constants.ability_115_maxTime);
          this.target_unit.addStatusEffect(StatusEffectCode.INVULNERABLE, Constants.ability_115_maxTime);
          this.target_unit.addStatusEffect(StatusEffectCode.INVISIBLE, Constants.ability_115_maxTime);
          this.target_unit.addStatusEffect(StatusEffectCode.UNCOLLIDABLE, Constants.ability_115_maxTime);
          this.target_unit.addStatusEffect(StatusEffectCode.DECAYED, Constants.ability_115_maxTime);
          global.sounds.trigger_units("units/ability/115", u.x - map.viewX, u.y - map.viewY);
        }
        break;
      case 117: // Tongue Last II
        this.timer_other = Constants.ability_112_castTime;
        this.toggle = true;
        u.curr_action = UnitAction.CASTING;
        global.sounds.trigger_units("units/ability/112", u.x - map.viewX, u.y - map.viewY);
        break;
      case 118: // Amphibious Leap II
        if (u.drenched()) {
          this.timer_other = Constants.ability_118_drenchedJumpDistance;
        }
        else {
          this.timer_other = Constants.ability_118_jumpDistance;
        }
        this.toggle = true;
        u.curr_action_unhaltable = true;
        u.curr_action = UnitAction.CASTING;
        global.sounds.trigger_units("units/ability/113", u.x - map.viewX, u.y - map.viewY);
        break;
      case 119: // Alkaloid Secretion II
        if (u.alkaloidSecretionII()) {
          u.removeStatusEffect(StatusEffectCode.ALKALOID_SECRETIONII);
          global.sounds.silence_units("units/ability/114");
        }
        else {
          u.addStatusEffect(StatusEffectCode.ALKALOID_SECRETIONII);
          global.sounds.trigger_units("units/ability/114_start", u.x - map.viewX, u.y - map.viewY);
          global.sounds.trigger_units("units/ability/114", u.x - map.viewX, u.y - map.viewY);
          u.increaseMana(this.manaCost());
          this.timer_cooldown = 0;
        }
        break;
      case 120: // Anuran Appetite II
        if (this.toggle) {
          this.timer_other = 0;
          u.increaseMana(this.manaCost());
        }
        else {
          this.toggle = true;
          this.timer_cooldown = 0;
          this.timer_other = Constants.ability_120_maxTime;
          this.target_unit.addStatusEffect(StatusEffectCode.SUPPRESSED, Constants.ability_120_maxTime);
          this.target_unit.addStatusEffect(StatusEffectCode.UNTARGETABLE, Constants.ability_120_maxTime);
          this.target_unit.addStatusEffect(StatusEffectCode.INVULNERABLE, Constants.ability_120_maxTime);
          this.target_unit.addStatusEffect(StatusEffectCode.INVISIBLE, Constants.ability_120_maxTime);
          this.target_unit.addStatusEffect(StatusEffectCode.UNCOLLIDABLE, Constants.ability_120_maxTime);
          this.target_unit.addStatusEffect(StatusEffectCode.DECAYED, Constants.ability_120_maxTime);
          global.sounds.trigger_units("units/ability/115", u.x - map.viewX, u.y - map.viewY);
        }
        break;
      default:
        global.errorMessage("ERROR: Can't activate ability with ID " + this.ID + ".");
        break;
    }
  }


  void update(int timeElapsed, Unit u, GameMap map) {
    this.update(timeElapsed);
    float max_distance = 0;
    float box_width = 0;
    float box_height = 0;
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
        if (u.curr_action != UnitAction.CASTING) {
          this.toggle = false;
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
          u.stopAction();
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
        if (u.curr_action != UnitAction.CASTING) {
          this.toggle = false;
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
          u.stopAction();
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
            global.sounds.trigger_units("units/ability/111", u.x - map.viewX, u.y - map.viewY);
          }
        }
        else {
          this.timer_cooldown = this.timer_cooldown();
        }
        break;
      case 112: // Tongue Lash
        if (!this.toggle) {
          break;
        }
        if (u.curr_action != UnitAction.CASTING) {
          this.toggle = false;
          break;
        }
        box_width = Constants.ability_112_distance * (1 - this.timer_other / Constants.ability_112_castTime);
        box_height = u.size;
        for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
          Unit target = entry.getValue();
          if (target.alliance == u.alliance) {
            continue;
          }
          PVector distance = new PVector(target.x - u.x, target.y - u.y);
          distance.rotate(-u.facingA);
          if (distance.x + target.size > 0 && distance.y + target.size > -0.5 *
            box_height && distance.x - target.size < box_width && distance.y -
            target.size < 0.5 * box_height) {
            // collision
            float power = Constants.ability_112_basePower + u.power(Constants.
              ability_112_physicalRatio, Constants.ability_112_magicalRatio);
            if (u.aposematicCamouflageII()) {
              power *= Constants.ability_116_powerBuff;
            }
            else if (u.aposematicCamouflage()) {
              power *= Constants.ability_111_powerBuff;
            }
            float damage = target.calculateDamageFrom(power, DamageType.MAGICAL,
              Element.BROWN, u.piercing(), u.penetration());
            target.damage(u, damage);
            target.refreshStatusEffect(StatusEffectCode.TONGUE_LASH, Constants.ability_112_slowTime);
            this.toggle = false;
            u.stopAction();
            global.sounds.trigger_units("units/ability/112_hit", u.x - map.viewX, u.y - map.viewY);
            break;
          }
        }
        if (this.timer_other <= 0) {
          this.toggle = false;
          u.stopAction();
        }
        break;
      case 113: // Amphibious Leap
        if (!this.toggle) {
          break;
        }
        if (u.curr_action != UnitAction.CASTING) {
          this.toggle = false;
          break;
        }
        this.timer_other -= u.last_move_distance;
        if (u.distanceFromPoint(u.curr_action_x, u.curr_action_y) < u.last_move_distance) {
          this.timer_other = 0;
        }
        if (this.timer_other <= 0) {
          this.toggle = false;
          u.stopAction();
          float splash_radius = 0;
          if (u.drenched()) {
            map.addVisualEffect(4004, u.x, u.y);
            splash_radius = Constants.ability_113_drenchedSplashRadius;
          }
          else {
            map.addVisualEffect(4003, u.x, u.y);
            splash_radius = Constants.ability_113_splashRadius;
          }
          float power = Constants.ability_113_basePower + u.power(Constants.
            ability_113_physicalRatio, Constants.ability_113_magicalRatio);
          for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
            Unit target = entry.getValue();
            if (target.alliance == u.alliance) {
              continue;
            }
            if (u.distance(target) > splash_radius) {
              continue;
            }
            target.damage(u, target.calculateDamageFrom(power, DamageType.MAGICAL,
              Element.BROWN, u.piercing(), u.penetration()));
            target.refreshStatusEffect(StatusEffectCode.STUNNED, Constants.ability_113_stunTime);
          }
          global.sounds.trigger_units("units/ability/113_land", u.x - map.viewX, u.y - map.viewY);
        }
        break;
      case 114: // Alkaloid Secretion
        if (!u.alkaloidSecretion()) {
          break;
        }
        if (this.timer_other <= 0) {
          if (u.currMana() < this.manaCost()) {
            u.removeStatusEffect(StatusEffectCode.ALKALOID_SECRETION);
            break;
          }
          else {
            u.decreaseMana(this.manaCost());
          }
          this.timer_other = Constants.ability_114_tickTime;
          float power = Constants.ability_114_basePower + u.power(0, Constants.ability_114_magicRatio);
          for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
            Unit target = entry.getValue();
            if (target.alliance == u.alliance) {
              continue;
            }
            if (u.distance(target) > Constants.ability_114_range) {
              continue;
            }
            target.damage(u, Constants.ability_114_currHealth * target.curr_health);
            target.damage(u, target.calculateDamageFrom(power, DamageType.MAGICAL,
              Element.BROWN, u.piercing(), u.penetration()));
            target.refreshStatusEffect(StatusEffectCode.ROTTING, Constants.ability_114_rotTime);
          }
          map.addVisualEffect(4007, u.x, u.y);
          global.sounds.trigger_units("units/ability/114", u.x - map.viewX, u.y - map.viewY);
        }
        break;
      case 115: // Anuran Appetite
        if (!this.toggle) {
          break;
        }
        if (this.target_unit == null || this.target_unit.remove || u.remove) {
          this.toggle = false;
          break;
        }
        if (this.timer_other <= 0) {
          this.toggle = false;
          this.target_unit.removeStatusEffect(StatusEffectCode.SUPPRESSED);
          this.target_unit.removeStatusEffect(StatusEffectCode.UNTARGETABLE);
          this.target_unit.removeStatusEffect(StatusEffectCode.INVULNERABLE);
          this.target_unit.removeStatusEffect(StatusEffectCode.INVISIBLE);
          this.target_unit.removeStatusEffect(StatusEffectCode.UNCOLLIDABLE);
          this.target_unit.x = u.frontX();
          this.target_unit.y = u.frontY();
          this.target_unit.setFacing(u.facingX, u.facingY);
          this.target_unit.curr_action = UnitAction.MOVING;
          this.target_unit.curr_action_id = 1;
          this.target_unit.curr_action_unstoppable = true;
          this.target_unit.curr_action_unhaltable = true;
          this.target_unit.curr_action_x = this.target_unit.x + u.facingX * Constants.ability_115_regurgitateDistance;
          this.target_unit.curr_action_y = this.target_unit.y + u.facingY * Constants.ability_115_regurgitateDistance;
          float power = Constants.ability_115_basePower + u.power(Constants.
            ability_115_physicalRatio, Constants.ability_115_magicalRatio);
          this.target_unit.damage(u, this.target_unit.calculateDamageFrom(power,
            DamageType.MAGICAL, Element.BROWN, u.piercing(), u.penetration()));
          global.sounds.trigger_units("units/ability/115_spit", u.x - map.viewX, u.y - map.viewY);
          global.sounds.silence_units("units/ability/115");
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
            global.sounds.trigger_units("units/ability/111", u.x - map.viewX, u.y - map.viewY);
          }
        }
        else {
          this.timer_cooldown = this.timer_cooldown();
        }
        break;
      case 117: // Tongue Lash II
        if (!this.toggle) {
          break;
        }
        if (u.curr_action != UnitAction.CASTING) {
          this.toggle = false;
          break;
        }
        box_width = Constants.ability_117_distance * (1 - this.timer_other / Constants.ability_112_castTime);
        box_height = u.size;
        for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
          Unit target = entry.getValue();
          if (target.alliance == u.alliance) {
            continue;
          }
          PVector distance = new PVector(target.x - u.x, target.y - u.y);
          distance.rotate(-u.facingA);
          if (distance.x + target.size > 0 && distance.y + target.size > -0.5 *
            box_height && distance.x - target.size < box_width && distance.y -
            target.size < 0.5 * box_height) {
            // collision
            float power = Constants.ability_117_basePower + u.power(Constants.
              ability_117_physicalRatio, Constants.ability_117_magicalRatio);
            float damage = target.calculateDamageFrom(power, DamageType.MAGICAL,
              Element.BROWN, u.piercing(), u.penetration());
            if (u.aposematicCamouflageII()) {
              power *= Constants.ability_116_powerBuff;
            }
            else if (u.aposematicCamouflage()) {
              power *= Constants.ability_111_powerBuff;
            }
            target.damage(u, damage);
            target.refreshStatusEffect(StatusEffectCode.TONGUE_LASH, Constants.ability_117_slowTime);
            this.toggle = false;
            u.stopAction();
            global.sounds.trigger_units("units/ability/112_hit", u.x - map.viewX, u.y - map.viewY);
            break;
          }
        }
        if (this.timer_other <= 0) {
          this.toggle = false;
          u.stopAction();
        }
        break;
      case 118: // Amphibious Leap II
        if (!this.toggle) {
          break;
        }
        if (u.curr_action != UnitAction.CASTING) {
          this.toggle = false;
          break;
        }
        this.timer_other -= u.last_move_distance;
        if (u.distanceFromPoint(u.curr_action_x, u.curr_action_y) < u.last_move_distance) {
          this.timer_other = 0;
        }
        if (this.timer_other <= 0) {
          this.toggle = false;
          u.stopAction();
          float splash_radius = 0;
          if (u.drenched()) {
            map.addVisualEffect(4006, u.x, u.y);
            splash_radius = Constants.ability_118_drenchedSplashRadius;
          }
          else {
            map.addVisualEffect(4005, u.x, u.y);
            splash_radius = Constants.ability_118_splashRadius;
          }
          float power = Constants.ability_118_basePower + u.power(Constants.
            ability_118_physicalRatio, Constants.ability_118_magicalRatio);
          for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
            Unit target = entry.getValue();
            if (target.alliance == u.alliance) {
              continue;
            }
            if (u.distance(target) > splash_radius) {
              continue;
            }
            target.damage(u, target.calculateDamageFrom(power, DamageType.MAGICAL,
              Element.BROWN, u.piercing(), u.penetration()));
            target.refreshStatusEffect(StatusEffectCode.STUNNED, Constants.ability_118_stunTime);
          }
          global.sounds.trigger_units("units/ability/113_land", u.x - map.viewX, u.y - map.viewY);
        }
        break;
      case 119: // Alkaloid Secretion II
        if (!u.alkaloidSecretionII()) {
          break;
        }
        if (this.timer_other <= 0) {
          if (u.currMana() < this.manaCost()) {
            u.removeStatusEffect(StatusEffectCode.ALKALOID_SECRETIONII);
            break;
          }
          else {
            u.decreaseMana(this.manaCost());
          }
          this.timer_other = Constants.ability_114_tickTime;
          float power = Constants.ability_119_basePower + u.power(0, Constants.ability_119_magicRatio);
          for (Map.Entry<Integer, Unit> entry : map.units.entrySet()) {
            Unit target = entry.getValue();
            if (target.alliance == u.alliance) {
              continue;
            }
            if (u.distance(target) > Constants.ability_119_range) {
              continue;
            }
            target.damage(u, Constants.ability_119_currHealth * target.curr_health);
            target.damage(u, target.calculateDamageFrom(power, DamageType.MAGICAL,
              Element.BROWN, u.piercing(), u.penetration()));
            target.refreshStatusEffect(StatusEffectCode.ROTTING, Constants.ability_114_rotTime);
          }
          map.addVisualEffect(4008, u.x, u.y);
          global.sounds.trigger_units("units/ability/114", u.x - map.viewX, u.y - map.viewY);
        }
        break;
      case 120: // Anuran Appetite II
        if (!this.toggle) {
          break;
        }
        if (this.target_unit == null || this.target_unit.remove || u.remove) {
          this.toggle = false;
          break;
        }
        if (this.timer_other <= 0) {
          this.toggle = false;
          this.target_unit.removeStatusEffect(StatusEffectCode.SUPPRESSED);
          this.target_unit.removeStatusEffect(StatusEffectCode.UNTARGETABLE);
          this.target_unit.removeStatusEffect(StatusEffectCode.INVULNERABLE);
          this.target_unit.removeStatusEffect(StatusEffectCode.INVISIBLE);
          this.target_unit.removeStatusEffect(StatusEffectCode.UNCOLLIDABLE);
          this.target_unit.x = u.frontX();
          this.target_unit.y = u.frontY();
          this.target_unit.setFacing(u.facingX, u.facingY);
          this.target_unit.curr_action = UnitAction.MOVING;
          this.target_unit.curr_action_id = 1;
          this.target_unit.curr_action_unstoppable = true;
          this.target_unit.curr_action_unhaltable = true;
          this.target_unit.curr_action_x = this.target_unit.x + u.facingX * Constants.ability_115_regurgitateDistance;
          this.target_unit.curr_action_y = this.target_unit.y + u.facingY * Constants.ability_115_regurgitateDistance;
          float power = Constants.ability_120_basePower + u.power(Constants.
            ability_120_physicalRatio, Constants.ability_120_magicalRatio);
          this.target_unit.damage(u, this.target_unit.calculateDamageFrom(power,
            DamageType.MAGICAL, Element.BROWN, u.piercing(), u.penetration()));
          global.sounds.trigger_units("units/ability/115_spit", u.x - map.viewX, u.y - map.viewY);
          global.sounds.silence_units("units/ability/115");
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
    switch(this.ID) {
      case 113: // Amphibious Leap
      case 118: // Amphiibous Leap II
        break;
      default:
        if (this.timer_other > 0) {
          this.timer_other -= timeElapsed;
          if (this.timer_other < 0) {
            this.timer_other = 0;
          }
        }
        break;
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
