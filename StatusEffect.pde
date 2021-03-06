enum StatusEffectCode {
  ERROR("Error"), HUNGRY("Hungry"), WEAK("Weak"), THIRSTY("Thirsty"), WOOZY("Woozy"),
  CONFUSED("Confused"), INVULNERABLE("Invulnerable"), UNKILLABLE("Unkillable"),
  BLEEDING("Bleeding"), HEMORRHAGING("Hemorrhaging"), WILTED("Wilted"), WITHERED("Withered"),
  VISIBLE("Visible"), SUPPRESSED("Suppressed"), UNTARGETABLE("Untargetable"),
  STUNNED("Stunned"), INVISIBLE("Invisible"), UNCOLLIDABLE("Uncollidable"),
  RUNNING("Running"),

  DRENCHED("Drenched"), DROWNING("Drowning"), BURNT("Burning"), CHARRED("Charred"),
  CHILLED("Chilled"), FROZEN("Frozen"), SICK("Sick"), DISEASED("Diseased"), ROTTING("Rotting"),
  DECAYED("Decayed"), SHAKEN("Shaken"), FALLEN("Fallen"), SHOCKED("Shocked"),
  PARALYZED("Paralyzed"), UNSTABLE("Unstable"), RADIOACTIVE("Radioactive"),

  NELSON_GLARE("Nelson Glared"), NELSON_GLAREII("Nelson Glared"), SENSELESS_GRIT(
  "Senseless Grit"), SENSELESS_GRITII("Senseless Grit"), RAGE_OF_THE_BEN(
  "Rage of the Ben"), RAGE_OF_THE_BENII("Rage of the Ben"),

  APOSEMATIC_CAMOUFLAGE("Camouflaged"), APOSEMATIC_CAMOUFLAGEII("Camouflaged"),
  TONGUE_LASH("Slowed"), ALKALOID_SECRETION("Secreting Alkaloids"), ALKALOID_SECRETIONII(
  "Secreting Alkaloids"),
  ;

  private static final List<StatusEffectCode> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  private String code_name;
  private StatusEffectCode(String code_name) {
    this.code_name = code_name;
  }
  public String code_name() {
    return this.code_name;
  }
  public static String code_name(StatusEffectCode code) {
    return code.code_name();
  }

  public static StatusEffectCode code(String code_name) {
    for (StatusEffectCode code : StatusEffectCode.VALUES) {
      if (code == StatusEffectCode.ERROR) {
        continue;
      }
      if (code.code_name().equals(code_name)) {
        return code;
      }
    }
    return StatusEffectCode.ERROR;
  }

  public boolean negative() {
    return StatusEffectCode.negative(this);
  }
  public static boolean negative(StatusEffectCode code) {
    switch(code) {
      case INVULNERABLE:
      case UNKILLABLE:
      case UNTARGETABLE:
      case INVISIBLE:
      case UNCOLLIDABLE:
      case RUNNING:
      case SENSELESS_GRIT:
      case SENSELESS_GRITII:
      case RAGE_OF_THE_BEN:
      case RAGE_OF_THE_BENII:
      case APOSEMATIC_CAMOUFLAGE:
      case APOSEMATIC_CAMOUFLAGEII:
      case ALKALOID_SECRETION:
      case ALKALOID_SECRETIONII:
        return false;
      default:
        return true;
    }
  }

  public Element element() {
    return StatusEffectCode.element(this);
  }
  public static Element element(StatusEffectCode code) {
    switch(code) {
      case DRENCHED:
      case DROWNING:
        return Element.BLUE;
      case BURNT:
      case CHARRED:
        return Element.RED;
      case CHILLED:
      case FROZEN:
        return Element.CYAN;
      case SICK:
      case DISEASED:
        return Element.ORANGE;
      case ROTTING:
      case DECAYED:
      case APOSEMATIC_CAMOUFLAGE:
      case APOSEMATIC_CAMOUFLAGEII:
      case TONGUE_LASH:
      case ALKALOID_SECRETION:
      case ALKALOID_SECRETIONII:
        return Element.BROWN;
      case SHAKEN:
      case FALLEN:
        return Element.PURPLE;
      case SHOCKED:
      case PARALYZED:
        return Element.YELLOW;
      case UNSTABLE:
      case RADIOACTIVE:
        return Element.MAGENTA;
      default:
        return Element.GRAY;
    }
  }

  public String getImageString() {
    String image_path = "statuses/";
    switch(this) {
      case INVULNERABLE:
        image_path += "invulnerable.png";
        break;
      case UNKILLABLE:
        image_path += "unkillable.png";
        break;
      case HUNGRY:
        image_path += "hungry.png";
        break;
      case WEAK:
        image_path += "weak.png";
        break;
      case THIRSTY:
        image_path += "thirsty.png";
        break;
      case WOOZY:
        image_path += "woozy.png";
        break;
      case CONFUSED:
        image_path += "confused.png";
        break;
      case BLEEDING:
        image_path += "bleeding.png";
        break;
      case HEMORRHAGING:
        image_path += "hemorrhaging.png";
        break;
      case WILTED:
        image_path += "wilted.png";
        break;
      case WITHERED:
        image_path += "withered.png";
        break;
      case VISIBLE:
        image_path += "visible.png";
        break;
      case SUPPRESSED:
        image_path += "suppressed.png";
        break;
      case UNTARGETABLE:
        image_path += "untargetable.png";
        break;
      case STUNNED:
        image_path += "stunned.png";
        break;
      case INVISIBLE:
        image_path += "invisible.png";
        break;
      case UNCOLLIDABLE:
        image_path += "uncollidable.png";
        break;
      case RUNNING:
        image_path += "running.png";
        break;
      case DRENCHED:
        image_path += "drenched.png";
        break;
      case DROWNING:
        image_path += "drowning.png";
        break;
      case BURNT:
        image_path += "burning.png";
        break;
      case CHARRED:
        image_path += "charred.png";
        break;
      case CHILLED:
        image_path += "chilled.png";
        break;
      case FROZEN:
        image_path += "frozen.jpg";
        break;
      case SICK:
        image_path += "sick.png";
        break;
      case DISEASED:
        image_path += "diseased.png";
        break;
      case ROTTING:
        image_path += "rotting.png";
        break;
      case DECAYED:
        image_path += "decayed.png";
        break;
      case SHAKEN:
        image_path += "shaken.png";
        break;
      case FALLEN:
        image_path += "fallen.png";
        break;
      case SHOCKED:
        image_path += "shocked.png";
        break;
      case PARALYZED:
        image_path += "paralyzed.png";
        break;
      case UNSTABLE:
        image_path += "unstable.png";
        break;
      case RADIOACTIVE:
        image_path += "radioactive.png";
        break;
      case NELSON_GLARE:
      case NELSON_GLAREII:
        image_path += "nelson_glare.png";
        break;
      case SENSELESS_GRIT:
      case SENSELESS_GRITII:
        image_path += "senseless_grit.png";
        break;
      case RAGE_OF_THE_BEN:
      case RAGE_OF_THE_BENII:
        image_path += "rage_of_the_ben.png";
        break;
      case APOSEMATIC_CAMOUFLAGE:
      case APOSEMATIC_CAMOUFLAGEII:
        image_path += "camouflaged.jpg";
        break;
      case TONGUE_LASH:
        image_path += "slowed.png";
        break;
      case ALKALOID_SECRETION:
      case ALKALOID_SECRETIONII:
        image_path += "alkaloid_secretion.png";
        break;
      default:
        image_path += "default.png";
        break;
    }
    return image_path;
  }

  public String description() {
    switch(this) {
      case INVULNERABLE:
        return "This unit does not take damage from any source.";
      case UNKILLABLE:
        return "This unit cannot be killed.";
      case HUNGRY:
        return "This unit is hungry and will slowly take damage to 50% max health." +
          "\nHunger can also lead to weakness.";
      case WEAK:
        return "This unit is weak and has 90% effective stats (attack, defense, etc.).";
      case THIRSTY:
        return "This unit is thirsty and will slowly take damage to 35% max health." +
          "\nThirst can also lead to becoming woozy or confused.";
      case WOOZY:
        return "This unit is woozy and will randomly stop what they are " +
          "doing and turn another direction.";
      case CONFUSED:
        return "This unit is confused and will randomly stop what they are " +
          "doing and move in a random direction.";
      case BLEEDING:
        return "This unit is bleeding and will take damage to 10% max health." +
          "\nBleeding can also lead to hemorrhaging";
      case HEMORRHAGING:
        return "This unit is hemorraghing and will quickly die if it is not stopped.";
      case WILTED:
        return "This unit is wilted and has 80% effective stats (attack, defense, etc.).";
      case WITHERED:
        return "This unit is withered and has 70% effective stats (attack, defense, etc.).";
      case VISIBLE:
        return "This unit is visible and can be seen by enemies.";
      case SUPPRESSED:
        return "This unit is suppressed and cannot perform any action";
      case UNTARGETABLE:
        return "This unit is untargetable and cannot be targeted by attacks, abilities, or spells.";
      case STUNNED:
        return "This unit is stunned and cannot move, attack, use abilities, or cast spells.";
      case INVISIBLE:
        return "This unit is invisible and cannot be seen.";
      case UNCOLLIDABLE:
        return "This unit is uncollidable and cannot be collided with.";
      case RUNNING:
        return "This unit is running and has moves 35% faster.";
      case DRENCHED:
        return "This unit is drenched so will take more damage from blue damage." +
          "\nIf this unit is red it will also slowly take damage to 20% max health.";
      case DROWNING:
        return "This unit is drowning and will quickly take damage to their death." +
          "\nDrowning will also make the unit drenched." +
          "\nIf this unit is blue it will only take damage to 5% max health.";
      case BURNT:
        return "This unit is burning and will take damage to its death." +
          "\nBurning also has chance to make this unit charred." +
          "\nIf this unit is red they cannot die from burning.";
      case CHARRED:
        return "This unit is charred and will quickly take damage to its death." +
          "\nIf this unit is red they cannot die from being charred.";
      case CHILLED:
        return "This unit is chilled and has 50% reduced movement speed and attack speed." +
          "\nIf this unit is cyan being chilled will only decrease their speed by 20%.";
      case FROZEN:
        return "This unit is frozen and cannot move or attack." +
          "\nIf this unit is orange they will take small damage to 10% max health.";
      case SICK:
        return "This unit is sick and cannot defend themselves. They will take 15% " +
          "more damage and have their defensive stats reduced by 15%.";
      case DISEASED:
        return "This unit is sick and cannot defend themselves. They will take 30% " +
          "more damage and have their defensive stats reduced by 30%.";
      case ROTTING:
        return "This unit is rotting and will take damage to 10% max health." +
          "\nIf this unit is blue they can die from rotting; if this unit is " +
          "brown they only take damage to 20% max health.";
      case DECAYED:
        return "This unit is decayed and will take damage to their death." +
          "\nIf this unit is brown they will only take damage to 10% max health.";
      case SHAKEN:
        return "";
      case FALLEN:
        return "";
      case SHOCKED:
        return "";
      case PARALYZED:
        return "";
      case UNSTABLE:
        return "";
      case RADIOACTIVE:
        return "";
      case NELSON_GLARE:
        return "This unit is Nelson glared and has 15% reduced attack and speed.";
      case NELSON_GLAREII:
        return "This unit is Nelson glared and has 25% reduced attack and speed.";
      case SENSELESS_GRIT:
        return "This unit has senseless grit and has +25% move speed when targeting enemies.";
      case SENSELESS_GRITII:
        return "This unit has senseless grit and has +35% move speed when targeting enemies.";
      case RAGE_OF_THE_BEN:
        return "This unit has the rage of the Ben and has 40% increased attack and incrased rage gains.";
      case RAGE_OF_THE_BENII:
        return "This unit has the rage of the Ben and has 50% increased attack and incrased rage gains.";
      case APOSEMATIC_CAMOUFLAGE:
        return "This unit is camouflaged and cannot be seen by enemies.\nThis " +
        "unit will also have +40% bonus power the first attack they deliver " +
        "while camouflaged.";
      case APOSEMATIC_CAMOUFLAGEII:
        return "This unit is camouflaged and cannot be seen by enemies.\nThis " +
        "unit will also have +70% bonus power the first attack they deliver " +
        "while camouflaged.";
      case TONGUE_LASH:
        return "This unit has been tongue lashed and is slowed by 30%.";
      case ALKALOID_SECRETION:
      case ALKALOID_SECRETIONII:
        return "This unit is secreting alkaloids and damaging nearby enemy units " +
        "every 500ms while also making them rot.";
      default:
        return "";
    }
  }
}


class StatusEffect {
  private boolean permanent = false;
  private float timer_gone_start = 0;
  private float timer_gone = 0;
  private float number = 0; // usually a timer for DoTs

  StatusEffect() {}
  StatusEffect(StatusEffectCode code, float timer) {
    this(code, timer, false);
  }
  StatusEffect(StatusEffectCode code, boolean permanent) {
    this(code, 0, permanent);
  }
  StatusEffect(StatusEffectCode code, float timer, boolean permanent) {
    this.timer_gone_start = timer;
    this.timer_gone = timer;
    this.permanent = permanent;
    switch(code) {
      case HUNGRY:
        this.number = Constants.status_hunger_tickTimer;
        break;
      case THIRSTY:
        this.number = Constants.status_thirst_tickTimer;
        break;
      case WOOZY:
        this.number = Constants.status_woozy_tickMaxTimer;
        break;
      case CONFUSED:
        this.number = Constants.status_confused_tickMaxTimer;
        break;
      case BLEEDING:
        this.number = Constants.status_bleed_tickTimer;
        break;
      case HEMORRHAGING:
        this.number = Constants.status_hemorrhage_tickTimer;
        break;
      case UNKILLABLE:
        this.number = 1;
        break;
      default:
        break;
    }
  }

  void update(int millis) {
    if (!this.permanent) {
      this.timer_gone -= millis;
    }
  }

  void startTimer(float timer) {
    this.permanent = false;
    this.timer_gone_start = timer;
    this.timer_gone = timer;
  }

  void addTime(float extra_time) {
    this.timer_gone_start += extra_time;
    this.timer_gone += extra_time;
  }

  void refreshTime(float time) {
    this.timer_gone = max(this.timer_gone, time);
    this.timer_gone_start = this.timer_gone;
  }

  String fileString() {
    String fileString = "\nnew: StatusEffect";
    fileString += "\npermanent: " + this.permanent;
    fileString += "\ntimer_gone_start: " + this.timer_gone_start;
    fileString += "\ntimer_gone: " + this.timer_gone;
    fileString += "\nnumber: " + this.number;
    fileString += "\nend: StatusEffect";
    return fileString;
  }

  void addData(String datakey, String data) {
    switch(datakey) {
      case "permanent":
        this.permanent = toBoolean(data);
        break;
      case "timer_gone_start":
        this.timer_gone_start = toFloat(data);
        break;
      case "timer_gone":
        this.timer_gone = toFloat(data);
        break;
      case "number":
        this.number = toFloat(data);
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not found for StatusEffect data.");
        break;
    }
  }
}
