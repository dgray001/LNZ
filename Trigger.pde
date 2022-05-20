class Trigger {
  private String triggerName = "";
  private int triggerID = -1; // level id

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
    boolean actuate = false;
    if (amalgam) {
      actuate = true;
    }
    for (Condition condition : this.conditions) {
      if (condition.update(timeElapsed, level)) {
        if (!amalgam) {
          actuate = true;
        }
      }
      else if (amalgam) {
        actuate = false;
      }
    }
    if (this.conditions.size() == 0 && !this.amalgam) {
      actuate = true;
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
      case 2: // selected specific unit
      case 3: // selected specific item
      case 4: // selected unit
      case 5: // selected item
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
      case 2: // selected specific unit
        this.display_name = "Select specific unit (" + this.number1 + ")";
        break;
      case 3: // selected specific item
        this.display_name = "Select specific item (" + this.number1 + ")";
        break;
      case 4: // selected unit id
        this.display_name = "Select unit (" + this.number1 + ")";
        break;
      case 5: // selected item id
        this.display_name = "Select item (" + this.number1 + ")";
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
      case 2: // selected specific unit
        if (this.met) {
          break;
        }
        if (level.currMap == null) {
          break;
        }
        if (Unit.class.isInstance(level.currMap.selected_object)) {
          Unit u = (Unit)level.currMap.selected_object;
          if (u.map_key == this.number1) {
            this.met = true;
          }
        }
        break;
      case 3: // selected specific item
        if (this.met) {
          break;
        }
        if (level.currMap == null) {
          break;
        }
        if (Item.class.isInstance(level.currMap.selected_object)) {
          Item i = (Item)level.currMap.selected_object;
          if (i.map_key == this.number1) {
            this.met = true;
          }
        }
        break;
      case 4: // selected unit
        if (this.met) {
          break;
        }
        if (level.currMap == null) {
          break;
        }
        if (Unit.class.isInstance(level.currMap.selected_object)) {
          Unit u = (Unit)level.currMap.selected_object;
          if (u.ID == this.number1) {
            this.met = true;
          }
        }
        break;
      case 5: // selected item
        if (this.met) {
          break;
        }
        if (level.currMap == null) {
          break;
        }
        if (Item.class.isInstance(level.currMap.selected_object)) {
          Item i = (Item)level.currMap.selected_object;
          if (i.ID == this.number1) {
            this.met = true;
          }
        }
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
      case 2: // selected specific unit
        break;
      case 3: // selected specific item
        break;
      case 4: // selected unit
        break;
      case 5: // selected item
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
        this.setID(toInt(data));
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
  private float decimal1 = 0;
  private float decimal2 = 0;
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
      case 7: // activate trigger
      case 8: // deactivate trigger
      case 9: // add quest
      case 10: // remove quest
      case 11: // lose control
      case 12: // gain control
      case 13: // move view
      case 14: // tint map
      case 15: // stop tinting map
      case 16: // show blinking arrow
      case 17: // complete quest
      case 18: // add visual effect
      case 19: // move view to player
      case 20: // unit chats
      case 21: // stop unit
      case 22: // stop player
      case 23: // stop units in rectangle
      case 24: // move unit
      case 25: // move player
      case 26: // move units in rectangle
      case 27: // face unit
      case 28: // face player
      case 29: // face units in rectangle
      case 30: // teleport unit
      case 31: // teleport player
      case 32: // teleport units in rectangle
      case 33: // change player hunger
      case 34: // change player thirst
      case 35: // change player mana
      case 36: // set player hunger
      case 37: // set player thirst
      case 38: // set player mana
      case 39: // change unit health
      case 40: // set unit health
      case 41: // change time
      case 42: // set time
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
        this.display_name = "Header Message (" + this.number + ")";
        break;
      case 5: // level chat
        this.display_name = "Level Chat";
        break;
      case 6: // win level
        this.display_name = "Win Level (" + this.number + ")";
        break;
      case 7: // activate trigger
        this.display_name = "Activate Trigger (" + this.number + ")";
        break;
      case 8: // deactivate trigger
        this.display_name = "Deactivate Trigger (" + this.number + ")";
        break;
      case 9: // add quest
        this.display_name = "Add Quest (" + this.number + ")";
        break;
      case 10: // remove quest
        this.display_name = "Remove Quest (" + this.number + ")";
        break;
      case 11: // lose control
        this.display_name = "Lose Control";
        break;
      case 12: // gain control
        this.display_name = "Gain Control";
        break;
      case 13: // move view
        this.display_name = "Move View";
        break;
      case 14: // tint map
        this.display_name = "Tint Map (" + this.number + ")";
        break;
      case 15: // stop tinting map
        this.display_name = "Remove Map Tint";
        break;
      case 16: // show blinking arrow
        this.display_name = "Blinking Arrow (" + this.number + ")";
        break;
      case 17: // complete quest
        this.display_name = "Complete Quest (" + this.number + ")";
        break;
      case 18: // add visual effect
        this.display_name = "Add Visual Effect (" + this.number + ")";
        break;
      case 19: // move view to player
        this.display_name = "Move View to Player";
        break;
      case 20: // unit chats
        this.display_name = "Unit Chats (" + this.number + ")";
        break;
      case 21: // stop unit
        this.display_name = "Stop Unit (" + this.number + ")";
        break;
      case 22: // stop player
        this.display_name = "Stop Player";
        break;
      case 23: // stop units in rectangle
        this.display_name = "Stop Units in Rectangle";
        break;
      case 24: // move unit
        this.display_name = "Move Unit (" + this.number + ")";
        break;
      case 25: // move player
        this.display_name = "Move Player";
        break;
      case 26: // move units rectangle
        this.display_name = "Move Units in Rectangle";
        break;
      case 27: // face unit
        this.display_name = "Face Unit (" + this.number + ")";
        break;
      case 28: // face player
        this.display_name = "Face Player";
        break;
      case 29: // face units in rectangle
        this.display_name = "Face Units in Rectangle";
        break;
      case 30: // teleport unit
        this.display_name = "Teleport Unit (" + this.number + ")";
        break;
      case 31: // teleport player
        this.display_name = "Teleport Player";
        break;
      case 32: // teleport units in rectangle
        this.display_name = "Teleport Units in Rectangle";
        break;
      case 33: // change player hunger
        this.display_name = "Change Player Hunger (" + this.number + ")";
        break;
      case 34: // change player thirst
        this.display_name = "Change Player Thirst (" + this.number + ")";
        break;
      case 35: // change player mana
        this.display_name = "Change Player Mana (" + this.number + ")";
        break;
      case 36: // set player hunger
        this.display_name = "Set Player Hunger (" + this.number + ")";
        break;
      case 37: // set player thirst
        this.display_name = "Set Player Thirst (" + this.number + ")";
        break;
      case 38: // set player mana
        this.display_name = "Set Player Mana (" + this.number + ")";
        break;
      case 39: // change unit health
        this.display_name = "Change Unit (" + this.number + ") Health (" + this.decimal1 + ")";
        break;
      case 40: // set unit health
        this.display_name = "Set Unit (" + this.number + ") Health (" + this.decimal1 + ")";
        break;
      case 41: // change time
        this.display_name = "Change Time (" + this.number + ")";
        break;
      case 42: // set time
        this.display_name = "Set Time (" + this.number + ")";
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
          level.currMap.addHeaderMessage(this.message, this.number);
        }
        break;
      case 5: // level chat
        level.chat(this.message);
        break;
      case 6: // win level
        level.complete(this.number);
        break;
      case 7: // activate trigger
        if (level.triggers.containsKey(this.number)) {
          level.triggers.get(this.number).active = true;
        }
        break;
      case 8: // deactivate trigger
        if (level.triggers.containsKey(this.number)) {
          level.triggers.get(this.number).active = false;
        }
        break;
      case 9: // add quest
        level.addQuest(this.number);
        break;
      case 10: // remove quest
        level.removeQuest(this.number);
        break;
      case 11: // Lose control
        level.loseControl();
        break;
      case 12: // gain control
        level.gainControl();
        break;
      case 13: // move view
        if (level.currMap != null) {
          level.currMap.setViewLocation(this.rectangle.centerX(), this.rectangle.centerY());
        }
        break;
      case 14: // tint map
        if (level.currMap != null) {
          level.currMap.show_tint = true;
          level.currMap.color_tint = this.number;
        }
        break;
      case 15: // stop tinting map
        if (level.currMap != null) {
          level.currMap.show_tint = false;
        }
        break;
      case 16: // show blinking arrow
        int frame = int(floor(Constants.gif_arrow_frames * (float(millis() %
          Constants.gif_arrow_time) / (1 + Constants.gif_arrow_time))));
        float translate_x = 0;
        switch(this.number) {
          case 1: // toward buttons
            translate_x = level.xf - 80;
            translate(translate_x, 0.9 * height);
            rotate(0.1 * PI);
            imageMode(CENTER);
            image(global.images.getImage("gifs/arrow/" + frame + ".png"), 0, 0, 130, 130);
            rotate(-0.1 * PI);
            translate(-translate_x, -0.9 * height);
            break;
          case 2: // panel collapse buttons
            translate_x = level.xf - 80;
            translate(translate_x, 0.05 * height);
            rotate(-0.2 * PI);
            imageMode(CENTER);
            image(global.images.getImage("gifs/arrow/" + frame + ".png"), 0, 0, 130, 130);
            rotate(0.2 * PI);
            translate(-translate_x, -0.05 * height);
            translate_x = level.xi + 80;
            translate(translate_x, 0.05 * height);
            rotate(-0.7 * PI);
            imageMode(CENTER);
            image(global.images.getImage("gifs/arrow/" + frame + ".png"), 0, 0, 130, 130);
            rotate(0.7 * PI);
            translate(-translate_x, -0.05 * height);
            break;
          case 3: // inventory bar
            translate_x = 0.5 * width;
            float translate_y = level.player.inventory_bar.yi - 70;
            translate(translate_x, translate_y);
            rotate(0.5 * PI);
            imageMode(CENTER);
            image(global.images.getImage("gifs/arrow/" + frame + ".png"), 0, 0, 130, 130);
            rotate(-0.5 * PI);
            translate(-translate_x, -translate_y);
            break;
          case 4: // player left panel form
            translate_x = level.xi + 65;
            translate(translate_x, 0.55 * height);
            rotate(PI);
            imageMode(CENTER);
            image(global.images.getImage("gifs/arrow/" + frame + ".png"), 0, 0, 130, 130);
            rotate(-PI);
            translate(-translate_x, -0.55 * height);
            break;
          case 5: // chatbox
            translate_x = level.xf - 65;
            translate(translate_x, 0.3 * height);
            imageMode(CENTER);
            image(global.images.getImage("gifs/arrow/" + frame + ".png"), 0, 0, 130, 130);
            translate(-translate_x, -0.3 * height);
            break;
          case 6: // questbox
            translate_x = level.xf - 65;
            translate(translate_x, 0.08 * height);
            imageMode(CENTER);
            image(global.images.getImage("gifs/arrow/" + frame + ".png"), 0, 0, 130, 130);
            translate(-translate_x, -0.08 * height);
            break;
          case 7: // selected object
            translate_x = level.xi + 65;
            translate(translate_x, 0.1 * height);
            rotate(PI);
            imageMode(CENTER);
            image(global.images.getImage("gifs/arrow/" + frame + ".png"), 0, 0, 130, 130);
            rotate(-PI);
            translate(-translate_x, -0.1 * height);
            break;
          case 8: // move toward arrow
            translate_x = 0.5 * width;
            translate(translate_x, 0.5 * height + 300);
            rotate(0.5 * PI);
            imageMode(CENTER);
            image(global.images.getImage("gifs/arrow/" + frame + ".png"), 0, 0, 130, 130);
            rotate(-0.5 * PI);
            translate(-translate_x, -0.5 * height - 300);
            break;
          default:
            global.errorMessage("ERROR: Blinking arrow ID " + this.number + " not recognized.");
            break;
        }
        break;
      case 17: // remove quest
        if (level.quests.containsKey(this.number)) {
          level.quests.get(this.number).meet();
        }
        break;
      case 18: // add visual effect
        if (level.currMap != null) {
          level.currMap.addVisualEffect(this.number, this.rectangle.centerX(), this.rectangle.centerY());
        }
        break;
      case 19: // move view to player
        if (level.currMap != null) {
          if (level.player != null) {
            level.currMap.setViewLocation(level.player.x, level.player.y);
          }
        }
        break;
      case 20: // unit chats
        if (level.currMap == null) {
          break;
        }
        if (level.currMap.units.containsKey(this.number)) {
          level.chat(level.currMap.units.get(this.number).display_name() + ": " + this.message);
          level.currMap.addVisualEffect(4009, level.currMap.units.get(this.number).x + 0.6, level.currMap.units.get(this.number).y - 0.4);
        }
        break;
      case 21: // stop unit
        if (level.currMap == null) {
          break;
        }
        if (level.currMap.units.containsKey(this.number)) {
          level.currMap.units.get(this.number).stopAction();
        }
        break;
      case 22: // stop player
        if (level.player != null) {
          level.player.stopAction();
        }
        break;
      case 23: // stop units in rectangle
        if (level.currMap == null) {
          break;
        }
        for (Map.Entry<Integer, Unit> entry : level.currMap.units.entrySet()) {
          if (this.rectangle.contains(entry.getValue())) {
            entry.getValue().stopAction();
          }
        }
        break;
      case 24: // move unit
        if (level.currMap == null) {
          break;
        }
        if (level.currMap.units.containsKey(this.number)) {
          level.currMap.units.get(this.number).moveTo(this.rectangle.centerX(), this.rectangle.centerY());
        }
        break;
      case 25: // move player
        if (level.player != null) {
          level.player.moveTo(this.rectangle.centerX(), this.rectangle.centerY());
        }
        break;
      case 26: // move units in rectangle
        if (level.currMap == null) {
          break;
        }
        for (Map.Entry<Integer, Unit> entry : level.currMap.units.entrySet()) {
          if (this.rectangle.contains(entry.getValue())) {
            level.player.moveTo(this.decimal1, this.decimal2);
          }
        }
        break;
      case 27: // face unit
        if (level.currMap == null) {
          break;
        }
        if (level.currMap.units.containsKey(this.number)) {
          level.currMap.units.get(this.number).turnTo(PI * this.decimal1 / 180.0);
        }
        break;
      case 28: // face player
        if (level.player != null) {
          level.player.turnTo(PI * this.decimal1 / 180.0);
        }
        break;
      case 29: // face units in rectangle
        if (level.currMap == null) {
          break;
        }
        for (Map.Entry<Integer, Unit> entry : level.currMap.units.entrySet()) {
          if (this.rectangle.contains(entry.getValue())) {
            entry.getValue().turnTo(PI * this.decimal1 / 180.0);
          }
        }
        break;
      case 30: // teleport unit
        if (level.currMap == null) {
          break;
        }
        if (level.currMap.units.containsKey(this.number)) {
          level.currMap.units.get(this.number).setLocation(this.rectangle.centerX(), this.rectangle.centerY());
        }
        break;
      case 31: // teleport player
        if (level.player != null) {
          level.player.setLocation(this.rectangle.centerX(), this.rectangle.centerY());
        }
        break;
      case 32: // teleport units in rectangle
        if (level.currMap == null) {
          break;
        }
        for (Map.Entry<Integer, Unit> entry : level.currMap.units.entrySet()) {
          if (this.rectangle.contains(entry.getValue())) {
            level.player.setLocation(this.decimal1, this.decimal2);
          }
        }
        break;
      case 33: // change player hunger
        if (level.player != null) {
          level.player.changeHunger(this.number);
        }
        break;
      case 34: // change player thirst
        if (level.player != null) {
          level.player.changeThirst(this.number);
        }
        break;
      case 35: // change player mana
        if (level.player != null) {
          level.player.changeMana(this.number);
        }
        break;
      case 36: // set player hunger
        if (level.player != null) {
          level.player.setHunger(this.number);
        }
        break;
      case 37: // set player thirst
        if (level.player != null) {
          level.player.setThirst(this.number);
        }
        break;
      case 38: // set player mana
        if (level.player != null) {
          level.player.setMana(this.number);
        }
        break;
      case 39: // change unit health
        if (level.currMap == null) {
          break;
        }
        if (level.currMap.units.containsKey(this.number)) {
          level.currMap.units.get(this.number).changeHealth(this.decimal1);
        }
        break;
      case 40: // set unit health
        if (level.currMap == null) {
          break;
        }
        if (level.currMap.units.containsKey(this.number)) {
          level.currMap.units.get(this.number).setHealth(this.decimal1);
        }
        break;
      case 41: // change time
        level.time.add(this.decimal1);
        break;
      case 42: // set time
        level.time.set(this.decimal1);
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
    fileString += "\ndecimal1: " + this.decimal1;
    fileString += "\ndecimal2: " + this.decimal2;
    fileString += "\nrectangle: " + this.rectangle.fileString();
    fileString += "\nend: Effect\n";
    return fileString;
  }

  void addData(String datakey, String data) {
    switch(datakey) {
      case "ID":
        this.setID(toInt(data));
        break;
      case "message":
        this.message = data;
        break;
      case "number":
        this.number = toInt(data);
        break;
      case "decimal1":
        this.decimal1 = toFloat(data);
        break;
      case "decimal2":
        this.decimal2 = toFloat(data);
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
