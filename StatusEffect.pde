enum StatusEffectCode {
  ERROR("Error"), HUNGRY("Hungry"), WEAK("Weak"), THIRSTY("Thirsty"), WOOZY("Woozy"),
  CONFUSED("Confused"), INVULNERABLE("Invulnerable"), UNKILLABLE("Unkillable"),
  BLEEDING("Bleeding"), HEMORRHAGING("Hemorrhaging"), WILTED("Wilted"), WITHERED("Withered"),
  DRENCHED("Drenched"), DROWNING("Drowning"), BURNT("Burnt"), CHARRED("Charred"),
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
