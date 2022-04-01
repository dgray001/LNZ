class Trigger {
  private String triggerName = "";

  private boolean active = false;
  private boolean looping = false;
  private boolean amalgam = true; // all conditions must be met (&& vs || condition list)

  private ArrayList<Condition> conditions = new ArrayList<Condition>();
  private ArrayList<Effect> effects = new ArrayList<Effect>();

  Trigger() {}
  Trigger(String triggerName) {
    this.triggerName = triggerName;
  }

  void update(int timeElapsed, Level level) {
    if (!this.active) {
      return;
    }
    boolean actuate = true;
    if (amalgam) {
      actuate = false;
    }
    for (Condition condition : this.conditions) {
      if (condition.update(timeElapsed, level)) {
        if (amalgam) {
          actuate = true;
        }
      }
      else {
        if (!amalgam) {
          actuate = false;
        }
      }
    }
    if (actuate) {
      this.actuate(level);
    }
  }

  void actuate(Level level) {
    for (Effect effect : this.effects) {
      effect.actuate(level);
    }
    for (Condition condition : this.conditions) {
      condition.reset();
    }
    if (!this.looping) {
      this.active = false;
    }
  }

  String fileString() {
    String fileString = "\nnew: Trigger";
    fileString += "\ntriggerName: " + this.triggerName;
    fileString += "\nactive: " + this.active;
    fileString += "\nlooping: " + this.looping;
    fileString += "\namalgam: " + this.amalgam;
    for (Condition condition : this.conditions) {
      fileString += condition.fileString();
    }
    for (Effect effect : this.effects) {
      fileString += effect.fileString();
    }
    fileString += "\nend: Trigger\n";
    return fileString;
  }

  void addData(String datakey, String data) {
    switch(datakey) {
      case "triggerName":
        this.triggerName = data;
        break;
      case "active":
        this.active = toBoolean(data);
        break;
      case "looping":
        this.looping = toBoolean(data);
        break;
      case "amalgam":
        this.amalgam = toBoolean(data);
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not recognized for Trigger object.");
        break;
    }
  }
}




class Condition {
  private int ID = 0;
  private String display_name = "-- ERROR --";

  private int number1 = 0;
  private int number2 = 0;

  private boolean met = false;

  Condition() {}

  void setID(int ID) {
    this.ID = ID;
    switch(ID) {
      case 1:
        break;
      default:
        global.errorMessage("ERROR: Condition ID " + ID + " not recognized.");
        break;
    }
    this.setName();
  }

  void setName() {
    switch(this.ID) {
      case 1:
        if (number1 < 1000) {
          this.display_name = "Timer (" + this.number1 + " ms)";
        }
        else {
          this.display_name = "Timer (" + round(this.number1/100.0)/10.0 + " s)";
        }
      default:
        this.display_name = "-- ERROR --";
    }
  }

  boolean update(int timeElapsed, Level level) {
    switch(this.ID) {
      case 1:
        if (!this.met) {
          this.number2 -= timeElapsed;
          if (this.number2 < 0) {
            this.met = true;
          }
        }
        break;
      default:
        global.errorMessage("ERROR: Condition ID " + ID + " not recognized.");
        return false;
    }
    return this.met;
  }

  void reset() {
    this.met = false;
    switch(this.ID) {
      case 1:
        this.number2 = this.number1;
        break;
      default:
        global.errorMessage("ERROR: Condition ID " + ID + " not recognized.");
        break;
    }
  }

  String fileString() {
    String fileString = "\nnew: Condition";
    fileString += "\nID: " + this.ID;
    fileString += "\nnumber1: " + this.number1;
    fileString += "\nnumber2: " + this.number2;
    fileString += "\nmet: " + this.met;
    fileString += "\nend: Condition\n";
    return fileString;
  }

  void addData(String datakey, String data) {
    switch(datakey) {
      case "ID":
        this.ID = toInt(data);
        break;
      case "number1":
        this.number1 = toInt(data);
        break;
      case "number2":
        this.number2 = toInt(data);
        break;
      case "met":
        this.met = toBoolean(data);
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not recognized for Condition object.");
        break;
    }
  }
}




class Effect {
  private int ID = 0;
  private String display_name = "-- ERROR --";

  private String message = "";

  Effect() {}

  void setID(int ID) {
    this.ID = ID;
    switch(ID) {
      case 1:
        break;
      default:
        global.errorMessage("ERROR: Effect ID " + ID + " not recognized.");
        break;
    }
  }

  void setName() {
    switch(this.ID) {
      case 1:
        this.display_name = "Log";
      default:
        this.display_name = "-- ERROR --";
    }
  }

  void actuate(Level level) {
    switch(this.ID) {
      case 1:
        println(this.message);
        break;
      default:
        global.errorMessage("ERROR: Effect ID " + ID + " not recognized.");
        break;
    }
  }

  String fileString() {
    String fileString = "\nnew: Effect";
    fileString += "\nID: " + this.ID;
    fileString += "\nmessage: " + this.message;
    fileString += "\nend: Effect\n";
    return fileString;
  }

  void addData(String datakey, String data) {
    switch(datakey) {
      case "ID":
        this.ID = toInt(data);
        break;
      case "message":
        this.message = data;
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not recognized for Effect object.");
        break;
    }
  }
}
