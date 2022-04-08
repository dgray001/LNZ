enum StatusEffectCode {
  ERROR("Error"), HUNGRY("Hungry"), WEAK("Weak"), THIRSTY("Thirsty"), WOOZY("Woozy"),
  CONFUSED("Confused"), INVULNERABLE("Invulnerable"), UNKILLABLE("Unkillable"),
  BLEEDING("Bleeding"), HEMORRHAGING("Hemorrhaging"), WILTED("Wilted"), WITHERED("Withered"),
  DRENCHED("Drenched"), DROWNING("Drowning"), BURNT("Burning"), CHARRED("Charred"),
  CHILLED("Chilled"), FROZEN("Frozen"), SICK("Sick"), DISEASED("Diseased"), ROTTING("Rotting"),
  DECAYED("Decayed"), SHAKEN("Shaken"), FALLEN("Fallen"), SHOCKED("Shocked"),
  PARALYZED("Paralyzed"), UNSTABLE("Unstable"), RADIOACTIVE("Radioactive"),

  NELSON_GLARE("Nelson Glared"), SENSELESS_GRIT("Senseless Grit"),
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
