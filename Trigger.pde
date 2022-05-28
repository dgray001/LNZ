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
    else if (this.amalgam) {
      for (Condition condition : this.conditions) {
        condition.met = false;
      }
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

  private boolean not_condition = false;
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
      case 7: // unit exists
      case 8: // has hero upgrade
      case 9: // unit in rectangle
      case 10: // unit health
      case 11: // holding item
      case 12: // player hunger
      case 13: // player thirst
      case 14: // player mana
      case 15: // time after
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
        this.display_name = "Select Specific Unit (" + this.number1 + ")";
        break;
      case 3: // selected specific item
        this.display_name = "Select Specific Item (" + this.number1 + ")";
        break;
      case 4: // selected unit id
        this.display_name = "Select Unit (" + this.number1 + ")";
        break;
      case 5: // selected item id
        this.display_name = "Select Item (" + this.number1 + ")";
        break;
      case 6: // player in rectangle
        this.display_name = "Player In: " + this.rectangle.fileString();
        break;
      case 7: // unit exists
        this.display_name = "Unit Exists (" + this.number1 + ")";
        break;
      case 8: // has hero upgrade
        this.display_name = "Has Hero Upgrade (" + HeroTreeCode.codeFromId(this.number1) + ")";
        break;
      case 9: // unit in rectangle
        this.display_name = "Unit (" + this.number1 + ") In: " + this.rectangle.fileString();
        break;
      case 10: // unit health
        this.display_name = "Unit (" + this.number1 + ") Health above (" + this.number2 + ")";
        break;
      case 11: // holding item
        this.display_name = "Player Holding Item (" + this.number1 + ")";
        break;
      case 12: // player hunger
        this.display_name = "Player Hunger Above (" + this.number1 + ")";
        break;
      case 13: // player thirst
        this.display_name = "Player Thirst Above (" + this.number1 + ")";
        break;
      case 14: // player mana
        this.display_name = "Player Mana Above (" + this.number1 + ")";
        break;
      case 15: // time after
        this.display_name = "Time after (" + this.number1 + ")";
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
      case 7: // unit exists
        if (this.met) {
          break;
        }
        if (level.currMap == null) {
          break;
        }
        if (level.currMap.units.containsKey(this.number1)) {
          this.met = true;
        }
        break;
      case 8: // has hero upgrade
        if (this.met) {
          break;
        }
        if (level.player == null) {
          break;
        }
        if (level.player.heroTree.nodes.get(HeroTreeCode.codeFromId(this.number1)).unlocked) {
          this.met = true;
        }
        break;
      case 9: // unit in rectangle
        if (this.met) {
          break;
        }
        if (level.currMap == null) {
          break;
        }
        if (!level.currMap.units.containsKey(this.number1)) {
          break;
        }
        if (this.rectangle.contains(level.currMap.units.get(this.number1), level.currMapName)) {
          this.met = true;
        }
        break;
      case 10: // unit health
        if (this.met) {
          break;
        }
        if (level.currMap == null) {
          break;
        }
        if (!level.currMap.units.containsKey(this.number1)) {
          break;
        }
        if (level.currMap.units.get(this.number1).curr_health > this.number2) {
          this.met = true;
        }
        break;
      case 11: // holding item
        if (this.met) {
          break;
        }
        if (level.player == null) {
          break;
        }
        if (level.player.holding(this.number1)) {
          this.met = true;
        }
        break;
      case 12: // player hunger
        if (this.met) {
          break;
        }
        if (level.player == null) {
          break;
        }
        if (level.player.hunger > this.number1) {
          this.met = true;
        }
        break;
      case 13: // player thirst
        if (this.met) {
          break;
        }
        if (level.player == null) {
          break;
        }
        if (level.player.thirst > this.number1) {
          this.met = true;
        }
        break;
      case 14: // player mana
        if (this.met) {
          break;
        }
        if (level.player == null) {
          break;
        }
        if (level.player.curr_mana > this.number1) {
          this.met = true;
        }
        break;
      case 15: // time after
        if (this.met) {
          break;
        }
        if (level.time.value >= this.number1) {
          this.met = true;
        }
        break;
      default:
        global.errorMessage("ERROR: Condition ID " + ID + " not recognized.");
        return false;
    }
    if (this.not_condition) {
      this.met = !this.met;
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
      case 7: // unit exists
        break;
      case 8: // has hero upgrade
        break;
      case 9: // unit in rectangle
        break;
      case 10: // unit health
        break;
      case 11: // holding item
        break;
      case 12: // player hunger
        break;
      case 13: // player thirst
        break;
      case 14: // player mana
        break;
      case 15: // time after
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
    fileString += "\nnot_condition: " + this.not_condition;
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
      case "not_condition":
        this.not_condition = toBoolean(data);
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
      case 43: // add item to player inventory
      case 44: // clear player inventory
      case 45: // create unit
      case 46: // clear level chat
      case 47: // grant hero tree upgrade
      case 48: // refresh cooldown on ability
      case 49: // change terrain in rectangle
      case 50: // add feature
      case 51: // remove features in rectangle
      case 52: // unlock achievement
      case 53: // give unit status effect
      case 54: // give player status effect
      case 55: // give units in rectangle status effect
      case 56: // explore rectangle
      case 57: // decision form
      case 58: // set background music
      case 59: // trigger sleeping
      case 60: // set background volume
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
        this.display_name = "Change Time (" + this.decimal1 + ")";
        break;
      case 42: // set time
        this.display_name = "Set Time (" + this.decimal1 + ")";
        break;
      case 43: // add item to player inventory
        this.display_name = "Add Item to Inventory (" + this.number + ")";
        break;
      case 44: // clear player inventory
        this.display_name = "Clear Player Inventory";
        break;
      case 45: // create unit
        this.display_name = "Create Unit (" + this.number + ")";
        break;
      case 46: // clear level chat
        this.display_name = "Clear Level Chat";
        break;
      case 47: // grant hero tree upgrade
        this.display_name = "Give Player Upgrade (" + HeroTreeCode.codeFromId(this.number) + ")";
        break;
      case 48: // refresh cooldown on ability
        this.display_name = "Refresh Ability (" + this.number + ")";
        break;
      case 49: // change terrain in rectangle
        this.display_name = "Change Terrain to (" + this.number + ")";
        break;
      case 50: // add feature
        this.display_name = "Add Feature (" + this.number + ")";
        break;
      case 51: // remove features in rectangle
        this.display_name = "Remove Features from rectangle";
        break;
      case 52: // unlock achievement
        this.display_name = "Unlock Achievement (" + this.number + ")";
        break;
      case 53: // give unit status effect
        this.display_name = "Give Unit (" + this.number + ") Status Effect " + this.message;
        break;
      case 54: // give player status effect
        this.display_name = "Give Player Status Effect " + this.message;
        break;
      case 55: // give units in rectangle status effect
        this.display_name = "Give Units in Rectangle Status Effect " + this.message;
        break;
      case 56: // explore rectangle
        this.display_name = "Explore Rectangle: " + this.rectangle.fileString();
        break;
      case 57: // decision form
        this.display_name = "Decision Form (" + this.number + ")";
        break;
      case 58: // set background music
        this.display_name = "Play Background Music (" + this.message + ")";
        break;
      case 59: // trigger sleeping
        this.display_name = "Trigger Sleeping";
        break;
      case 60: // set background volume
        if (this.number > 0) {
          this.display_name = "Set Background Volume (" + this.decimal1 + ")";
        }
        else {
          this.display_name = "Mute Background Volume";
        }
        break;
      default:
        this.display_name = "Effect";
        break;
    }
  }

  void actuate(Level level) {
    StatusEffectCode code = null;
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
          if (this.number == 0) { // default to brown with transparency 100
            level.currMap.color_tint = 1681075482;
          }
          else {
            level.currMap.color_tint = this.number;
          }
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
          case 9: // xp/level
            translate_x = level.xi + 65;
            translate(translate_x, 0.65 * height);
            rotate(PI);
            imageMode(CENTER);
            image(global.images.getImage("gifs/arrow/" + frame + ".png"), 0, 0, 130, 130);
            rotate(-PI);
            translate(-translate_x, -0.65 * height);
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
            entry.getValue().moveTo(this.decimal1, this.decimal2);
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
            entry.getValue().setLocation(this.decimal1, this.decimal2);
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
      case 43: // add item to player inventory
        if (level.player != null) {
          Item leftover = level.player.inventory.stash(new Item(this.number));
          if (leftover != null && !leftover.remove && level.currMap != null) {
            level.currMap.addItem(leftover, level.player.frontX(), level.player.frontY());
          }
        }
        break;
      case 44: // clear player inventory
        if (level.player != null) {
          level.player.inventory.clear();
        }
        break;
      case 45: // create unit
        if (level.currMap != null) {
          Unit u = new Unit(this.number, this.rectangle.centerX(), this.rectangle.centerY());
          if (this.decimal1 > 0) {
            level.currMap.addUnit(u, int(round(this.decimal1)));
          }
          else {
            level.currMap.addUnit(u);
          }
        }
        break;
      case 46: // clear level chat
        if (level.level_chatbox != null) {
          level.level_chatbox.clearText();
        }
        break;
      case 47: // grant hero tree upgrade
        if (level.player != null) {
          level.player.upgrade(HeroTreeCode.codeFromId(this.number));
        }
        break;
      case 48: // refresh cooldown on ability
        if (level.player == null) {
          break;
        }
        if (this.number < 0 || this.number >= level.player.abilities.size()) {
          break;
        }
        if (level.player.abilities.get(this.number) == null) {
          break;
        }
        level.player.abilities.get(this.number).timer_cooldown = 0;
        break;
      case 49: // change terrain in rectangle
        if (level.currMap == null) {
          break;
        }
        for (int i = int(round(this.rectangle.xi)); i < int(round(this.rectangle.xf)); i++) {
          for (int j = int(round(this.rectangle.yi)); j < int(round(this.rectangle.yf)); j++) {
            try {
              level.currMap.setTerrain(this.number, i, j, false);
            } catch(Exception e) {}
          }
        }
        level.currMap.refreshDisplayImages();
        break;
      case 50: // add feature
        if (level.currMap != null) {
          Feature f = new Feature(this.number, int(floor(this.rectangle.xi)), int(floor(this.rectangle.yi)));
          f.number = int(round(this.decimal1));
          level.currMap.addFeature(f);
        }
        break;
      case 51: // remove features in rectangle
        if (level.currMap != null) {
          for (Feature f : level.currMap.features) {
            if (this.rectangle.contains(f)) {
              f.remove = true;
            }
          }
        }
        break;
      case 52: // unlock achievement
        global.profile.achievement(AchievementCode.achievementCode(this.number));
        break;
      case 53: // give unit status effect
        code = StatusEffectCode.code(this.message);
        if (code == null || code == StatusEffectCode.ERROR) {
          break;
        }
        if (level.currMap == null) {
          break;
        }
        if (level.currMap.units.containsKey(this.number)) {
          if (this.decimal1 > 0) {
            level.currMap.units.get(this.number).refreshStatusEffect(code, this.decimal1);
          }
          else {
            level.currMap.units.get(this.number).addStatusEffect(code);
          }
        }
        break;
      case 54: // give player status effect
        code = StatusEffectCode.code(this.message);
        if (code == null || code == StatusEffectCode.ERROR) {
          break;
        }
        if (level.player == null) {
          break;
        }
        if (this.decimal1 > 0) {
          level.player.refreshStatusEffect(code, this.decimal1);
        }
        else {
          level.player.addStatusEffect(code);
        }
        break;
      case 55: // give units in rectangle status effect
        code = StatusEffectCode.code(this.message);
        if (code == null || code == StatusEffectCode.ERROR) {
          break;
        }
        if (level.currMap == null) {
          break;
        }
        for (Map.Entry<Integer, Unit> entry : level.currMap.units.entrySet()) {
          if (this.rectangle.contains(entry.getValue())) {
            if (this.decimal1 > 0) {
              entry.getValue().refreshStatusEffect(code, this.decimal1);
            }
            else {
              entry.getValue().addStatusEffect(code);
            }
          }
        }
        break;
      case 56: // explore rectangle
        if (level.currMap == null) {
          break;
        }
        if (!level.currMapName.equals(this.rectangle.mapName)) {
          break;
        }
        level.currMap.exploreRectangle(this.rectangle);
        break;
      case 57: // decision form
        level.decisionForm(this.number);
        break;
      case 58: // set background music
        global.sounds.play_background(this.message);
        break;
      case 59: // trigger sleeping
        level.sleeping = true;
        level.sleep_timer = Constants.feature_bedSleepTimer;
        level.loseControl();
        if (level.player != null) {
          level.player.stopAction();
        }
        break;
      case 60: // set background volume
        if (this.number > 0) {
          global.profile.options.volume_music = this.decimal1;
          global.profile.options.volume_music_muted = false;
        }
        else {
          global.profile.options.volume_music = this.decimal1;
          global.profile.options.volume_music_muted = true;
        }
        global.profile.options.change();
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
