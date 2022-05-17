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
  private String display_name = "Condition";

  private int number1 = 0;
  private int number2 = 0;
  private Rectangle rectangle = new Rectangle();

  private boolean met = false;

  Condition() {}

  void setID(int ID) {
    this.ID = ID;
    switch(ID) {
      case 0: // nothing
      case 1: // timer
      case 2:
      case 3:
      case 4:
      case 5:
      case 6: // player in rectangle
        break;
      default:
        global.errorMessage("ERROR: Condition ID " + ID + " not recognized.");
        break;
    }
    this.setName();
  }

  void setName() {
    switch(this.ID) {
      case 1: // timer
        if (number1 < 1000) {
          this.display_name = "Timer (" + this.number1 + " ms)";
        }
        else {
          this.display_name = "Timer (" + round(this.number1/100.0)/10.0 + " s)";
        }
        break;
      case 6: // player in rectangle
        this.display_name = "Player in: " + this.rectangle.fileString();
        break;
      default:
        this.display_name = "Condition";
        break;
    }
  }

  boolean update(int timeElapsed, Level level) {
    switch(this.ID) {
      case 0: // nothing
        break;
      case 1: // timer
        if (!this.met) {
          this.number2 -= timeElapsed;
          if (this.number2 < 0) {
            this.met = true;
          }
        }
        break;
      case 2:
      case 3:
      case 4:
      case 5:
        break;
      case 6: // player in rectangle
        if (this.met) {
          break;
        }
        if (level.player == null) {
          break;
        }
        if (level.currMapName == null) {
          break;
        }
        if (this.rectangle.contains(level.player, level.currMapName)) {
          this.met = true;
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
      case 0: // nothing
        break;
      case 1: // timer
        this.number2 = this.number1;
        break;
      case 6: // player in rectangle
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
    fileString += "\nrectangle: " + this.rectangle.fileString();
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
      case "rectangle":
        this.rectangle.addData(data);
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
  private String display_name = "Effect";

  private String message = "";
  private int number = 0;
  private Rectangle rectangle = new Rectangle();

  Effect() {}

  void setID(int ID) {
    this.ID = ID;
    switch(ID) {
      case 0: // nothing
      case 1: // console log
      case 2: // LNZ log
      case 3: // timestamp log
      case 4: // header messae
      case 5: // level chat
      case 6: // win level
        break;
      default:
        global.errorMessage("ERROR: Effect ID " + ID + " not recognized.");
        break;
    }
    this.setName();
  }

  void setName() {
    switch(this.ID) {
      case 1: // console log
        this.display_name = "Console Log";
        break;
      case 2: // LNZ log
        this.display_name = "LNZ Log";
        break;
      case 3: // timestamp log
        this.display_name = "Timestamp Log";
        break;
      case 4: // header messae
        this.display_name = "Header Message";
        break;
      case 5: // level chat
        this.display_name = "Level Chat";
        break;
      case 6: // win level
        this.display_name = "Win Level";
        break;
      default:
        this.display_name = "Effect";
        break;
    }
  }

  void actuate(Level level) {
    switch(this.ID) {
      case 0: // nothing
        break;
      case 1: // console log
        println(this.message);
        break;
      case 2: // LNZ log
        global.log(this.message);
        break;
      case 3: // Timestamp log
        global.log(millis() + this.message);
        break;
      case 4: // header message
        if (level.currMap != null) {
          level.currMap.addHeaderMessage(this.message);
        }
        break;
      case 5: // level chat
        level.chat(this.message);
        break;
      case 6: // win level
        level.complete(this.number);
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
    fileString += "\nnumber: " + this.number;
    fileString += "\nrectangle: " + this.rectangle.fileString();
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
      case "number":
        this.number = toInt(data);
        break;
      case "rectangle":
        this.rectangle.addData(data);
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not recognized for Effect object.");
        break;
    }
  }
}
