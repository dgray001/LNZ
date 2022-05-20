enum TutorialStatus {
  INITIAL, STARTING_NEW, LOADING_SAVED, PLAYING;
}


class TutorialInterface extends InterfaceLNZ {

  abstract class TutorialButton extends RectangleButton {
    TutorialButton() {
      super(0, 0.94 * height, 0, height - Constants.mapEditor_buttonGapSize);
      this.raised_border = true;
      this.roundness = 0;
      this.setColors(color(170), color(222, 184, 135), color(244, 164, 96), color(205, 133, 63), color(0));
      this.show_message = true;
    }
    void hover() {
      global.sounds.trigger_interface("interfaces/buttonOn2");
    }
    void dehover() {}
    void click() {
      global.sounds.trigger_interface("interfaces/buttonClick1");
    }
  }

  class TutorialButton1 extends TutorialButton {
    TutorialButton1() {
      super();
      this.message = "Restart\nTutorial";
    }
    void release() {
      if (!this.hovered) {
        return;
      }
      this.stayDehovered();
      TutorialInterface.this.form = new RestartTutorialForm();
    }
  }

  class TutorialButton2 extends TutorialButton {
    TutorialButton2() {
      super();
      this.message = "Options";
    }
    void release() {
      if (!this.hovered) {
        return;
      }
      this.stayDehovered();
      TutorialInterface.this.form = new OptionsForm();
    }
  }

  class TutorialButton3 extends TutorialButton {
    TutorialButton3() {
      super();
      this.message = "Heroes";
    }
    void release() {
      if (!this.hovered) {
        return;
      }
      this.stayDehovered();
      TutorialInterface.this.form = new HeroesForm();
    }
  }

  class TutorialButton4 extends TutorialButton {
    TutorialButton4() {
      super();
      this.message = "Main\nMenu";
    }
    void release() {
      if (!this.hovered) {
        return;
      }
      this.stayDehovered();
      TutorialInterface.this.form = new GoToMainMenuForm();
    }
  }


  class GoToMainMenuForm extends ConfirmForm {
    GoToMainMenuForm() {
      super("Main Menu", "Are you sure you want to save and exit to the main menu?");
    }
    void submit() {
      this.canceled = true;
      TutorialInterface.this.saveAndExitToMainMenu();
    }
  }

  class RestartTutorialForm extends ConfirmForm {
    RestartTutorialForm() {
      super("Restart Tutorial", "Are you sure you want to restart the tutorial? " +
        "Any current progress will be lost.");
    }
    void submit() {
      this.canceled = true;
      TutorialInterface.this.startNewTutorial();
    }
  }


  class OpenNewTutorialThread extends Thread {
    private Level level;
    private String curr_status = "";

    OpenNewTutorialThread() {
      super("OpenNewTutorialThread");
    }

    @Override
    void run() {
      this.curr_status += "Creating New Tutorial";
      this.level = new Level("data/locations", Location.TUTORIAL);
      if (this.level.nullify) {
        this.curr_status += " -> " + global.lastErrorMessage();
        delay(2500);
        return;
      }
      this.curr_status += "\nCopying Data";
      String destination_folder = "data/profiles/" + global.profile.display_name.toLowerCase() + "/locations/";
      if (!folderExists(destination_folder)) {
        mkdir(destination_folder);
      }
      deleteFolder(destination_folder + Location.TUTORIAL.file_name());
      copyFolder("data/locations/" + Location.TUTORIAL.file_name(),
        destination_folder + Location.TUTORIAL.file_name());
      this.level.folderPath = destination_folder;
      this.level.save();
      if (this.level.nullify) {
        this.curr_status += " -> " + global.lastErrorMessage();
        delay(2500);
        return;
      }
      this.curr_status += "\nOpening Map";
      this.level.setPlayer(new Hero(HeroCode.BEN));
      if (this.level.nullify) {
        this.curr_status += " -> " + global.lastErrorMessage();
        delay(2500);
        return;
      }
      if (!global.images.loaded_map_gifs) {
        this.curr_status += "\nLoading Animations";
        global.images.loadMapGifs();
      }
    }
  }


  class OpenSavedTutorialThread extends Thread {
    private Level level;
    private String curr_status = "";

    OpenSavedTutorialThread() {
      super("OpenSavedTutorialThread");
    }

    @Override
    void run() {
      this.curr_status += "Opening Saved Tutorial";
      String destination_folder = "data/profiles/" + global.profile.display_name.toLowerCase() + "/locations/";
      this.level = new Level(destination_folder, Location.TUTORIAL);
      if (this.level.nullify) {
        this.curr_status += " -> " + global.lastErrorMessage();
        delay(2500);
        return;
      }
      this.curr_status += "\nOpening Hero";
      Hero hero = null;
      String[] lines = loadStrings(destination_folder + "tutorial/hero.lnz");
      if (lines == null) {
        global.errorMessage("ERROR: Reading hero at path " + (destination_folder +
          "tutorial/hero.lnz") + " but no hero file exists.");
        this.curr_status += " -> " + global.lastErrorMessage();
        delay(2500);
        return;
      }
      Stack<ReadFileObject> object_queue = new Stack<ReadFileObject>();
      StatusEffectCode curr_status_code = StatusEffectCode.ERROR;
      StatusEffect curr_status = null;
      Ability curr_ability = null;
      Item curr_item = null;
      boolean ended_hero = false;
      for (String line : lines) {
        String[] parameters = split(line, ':');
        if (parameters.length < 2) {
          continue;
        }
        String dataname = trim(parameters[0]);
        String data = trim(parameters[1]);
        for (int i = 2; i < parameters.length; i++) {
          data += ":" + parameters[i];
        }
        if (dataname.equals("new")) {
          ReadFileObject type = ReadFileObject.objectType(trim(parameters[1]));
          switch(type) {
            case HERO:
              if (parameters.length < 3) {
                global.errorMessage("ERROR: Unit ID missing in Hero constructor.");
                break;
              }
              object_queue.push(type);
              hero = new Hero(toInt(trim(parameters[2])));
              hero.abilities.clear();
              break;
            case INVENTORY:
              if (hero == null) {
                global.errorMessage("ERROR: Trying to start an inventory in a null hero.");
              }
              object_queue.push(type);
              break;
            case ITEM:
              if (hero == null) {
                global.errorMessage("ERROR: Trying to start an item in a null hero.");
              }
              if (parameters.length < 3) {
                global.errorMessage("ERROR: Item ID missing in Item constructor.");
                break;
              }
              object_queue.push(type);
              curr_item = new Item(toInt(trim(parameters[2])));
              break;
            case STATUS_EFFECT:
              if (hero == null) {
                global.errorMessage("ERROR: Trying to start a status effect in a null hero.");
              }
              object_queue.push(type);
              curr_status = new StatusEffect();
              break;
            case ABILITY:
              if (hero == null) {
                global.errorMessage("ERROR: Trying to start an ability in a null hero.");
              }
              if (parameters.length < 3) {
                global.errorMessage("ERROR: Ability ID missing in Projectile constructor.");
                break;
              }
              object_queue.push(type);
              curr_ability = new Ability(toInt(trim(parameters[2])));
              break;
            default:
              global.errorMessage("ERROR: Can't add a " + type + " type to Heroes data.");
              break;
          }
        }
        else if (dataname.equals("end")) {
          ReadFileObject type = ReadFileObject.objectType(trim(parameters[1]));
          if (object_queue.empty()) {
            global.errorMessage("ERROR: Tring to end a " + type.name + " object but not inside any object.");
          }
          else if (type.name.equals(object_queue.peek().name)) {
            switch(object_queue.pop()) {
              case HERO:
                if (hero == null) {
                  global.errorMessage("ERROR: Trying to end a null hero.");
                  break;
                }
                if (!object_queue.empty()) {
                  global.errorMessage("ERROR: Trying to end a hero but inside another object.");
                  break;
                }
                if (hero.code == HeroCode.ERROR) {
                  global.errorMessage("ERROR: Trying to end hero with errored code.");
                  break;
                }
                ended_hero = true;
                break;
              case INVENTORY:
                if (hero == null) {
                  global.errorMessage("ERROR: Trying to end an inventory in a null hero.");
                  break;
                }
                break;
              case ITEM:
                if (curr_item == null) {
                  global.errorMessage("ERROR: Trying to end a null item.");
                  break;
                }
                if (object_queue.empty()) {
                  global.errorMessage("ERROR: Trying to end an item not inside any other object.");
                  break;
                }
                if (object_queue.peek() != ReadFileObject.HERO) {
                  global.errorMessage("ERROR: Trying to end an ability not inside a hero.");
                  break;
                }
                switch(object_queue.peek()) {
                  case HERO:
                    if (parameters.length < 3) {
                      global.errorMessage("ERROR: GearSlot code missing in Item constructor.");
                      break;
                    }
                    GearSlot code = GearSlot.gearSlot(trim(parameters[2]));
                    if (hero == null) {
                      global.errorMessage("ERROR: Trying to add gear to null hero.");
                      break;
                    }
                    hero.gear.put(code, curr_item);
                    break;
                  case INVENTORY:
                    if (parameters.length < 3) {
                      global.errorMessage("ERROR: No positional information for inventory item.");
                      break;
                    }
                    int index = toInt(trim(parameters[2]));
                    if (hero == null) {
                      global.errorMessage("ERROR: Trying to add inventory item to null hero.");
                      break;
                    }
                    Item i = hero.inventory.placeAt(curr_item, index, true);
                    if (i != null) {
                      global.errorMessage("ERROR: Item already exists at position " + index + ".");
                      break;
                    }
                    break;
                  default:
                    global.errorMessage("ERROR: Trying to end an item inside a " + object_queue.peek().name + ".");
                    break;
                }
                curr_item = null;
                break;
              case STATUS_EFFECT:
                if (curr_status == null) {
                  global.errorMessage("ERROR: Trying to end a null status effect.");
                  break;
                }
                if (object_queue.empty()) {
                  global.errorMessage("ERROR: Trying to end a status effect not inside any other object.");
                  break;
                }
                if (object_queue.peek() != ReadFileObject.HERO) {
                  global.errorMessage("ERROR: Trying to end a status effect not inside a hero.");
                  break;
                }
                if (hero == null) {
                  global.errorMessage("ERROR: Trying to end a status effect inside a null hero.");
                  break;
                }
                hero.statuses.put(curr_status_code, curr_status);
                curr_status = null;
                break;
              case ABILITY:
                if (curr_ability == null) {
                  global.errorMessage("ERROR: Trying to end a null ability.");
                  break;
                }
                if (object_queue.empty()) {
                  global.errorMessage("ERROR: Trying to end an ability not inside any other object.");
                  break;
                }
                if (object_queue.peek() != ReadFileObject.HERO) {
                  global.errorMessage("ERROR: Trying to end an ability not inside a hero.");
                  break;
                }
                if (hero == null) {
                  global.errorMessage("ERROR: Trying to end an ability inside a null hero.");
                  break;
                }
                hero.abilities.add(curr_ability);
                curr_ability = null;
                break;
            }
          }
          else {
            global.errorMessage("ERROR: Tring to end a " + type.name + " object but current object is a " + object_queue.peek().name + ".");
          }
        }
        else {
          switch(object_queue.peek()) {
            case HERO:
              if (hero == null) {
                global.errorMessage("ERROR: Trying to add hero data to a null hero.");
                break;
              }
              if (dataname.equals("next_status_code")) {
                curr_status_code = StatusEffectCode.code(data);
              }
              else {
                hero.addData(dataname, data);
              }
              break;
            case INVENTORY:
              if (hero == null) {
                global.errorMessage("ERROR: Trying to add hero inventory data to a null hero.");
                break;
              }
              hero.inventory.addData(dataname, data);
              break;
            case ITEM:
              if (curr_item == null) {
                global.errorMessage("ERROR: Trying to add item data to a null item.");
                break;
              }
              curr_item.addData(dataname, data);
              break;
            case STATUS_EFFECT:
              if (curr_status == null) {
                global.errorMessage("ERROR: Trying to add status effect data to a null status effect.");
                break;
              }
              curr_status.addData(dataname, data);
              break;
            case ABILITY:
              if (curr_ability == null) {
                global.errorMessage("ERROR: Trying to add ability data to a null ability.");
                break;
              }
              curr_status.addData(dataname, data);
              break;
            default:
              break;
          }
        }
      }
      if (!ended_hero) {
        global.errorMessage("ERROR: Hero data never ended.");
      }
      if (!global.lastErrorMessage().equals("None")) {
        this.curr_status += " -> " + global.lastErrorMessage();
        delay(2500);
        return;
      }
      this.curr_status += "\nOpening Map";
      this.level.openCurrMap();
      this.level.addPlayer(hero);
      if (this.level.nullify) {
        this.curr_status += " -> " + global.lastErrorMessage();
        delay(2500);
        return;
      }
      if (!global.images.loaded_map_gifs) {
        this.curr_status += "\nLoading Animations";
        global.images.loadMapGifs();
      }
    }
  }


  private TutorialButton[] buttons = new TutorialButton[4];
  private Panel leftPanel = new Panel(LEFT, Constants.mapEditor_panelMinWidth,
    Constants.mapEditor_panelMaxWidth, Constants.mapEditor_panelStartWidth);
  private Panel rightPanel = new Panel(RIGHT, Constants.mapEditor_panelMinWidth,
    Constants.mapEditor_panelMaxWidth, Constants.mapEditor_panelStartWidth);

  private TutorialStatus status = TutorialStatus.INITIAL;
  private Level tutorial = null;

  private OpenNewTutorialThread newTutorialThread = null;
  private OpenSavedTutorialThread savedTutorialThread = null;


  TutorialInterface() {
    this.buttons[0] = new TutorialButton1();
    this.buttons[1] = new TutorialButton2();
    this.buttons[2] = new TutorialButton3();
    this.buttons[3] = new TutorialButton4();
    this.leftPanel.addIcon(global.images.getImage("icons/triangle_gray.png"));
    this.rightPanel.addIcon(global.images.getImage("icons/triangle_gray.png"));
    this.leftPanel.color_background = global.color_panelBackground;
    this.rightPanel.color_background = global.color_panelBackground;
    this.resizeButtons();
    this.checkTutorialSave();
  }


  void resizeButtons() {
    float buttonSize = (this.rightPanel.size_curr - 5 * Constants.mapEditor_buttonGapSize) / 4.0;
    float xi = width - this.rightPanel.size_curr + Constants.mapEditor_buttonGapSize;
    this.buttons[0].setXLocation(xi, xi + buttonSize);
    xi += buttonSize + Constants.mapEditor_buttonGapSize;
    this.buttons[1].setXLocation(xi, xi + buttonSize);
    xi += buttonSize + Constants.mapEditor_buttonGapSize;
    this.buttons[2].setXLocation(xi, xi + buttonSize);
    xi += buttonSize + Constants.mapEditor_buttonGapSize;
    this.buttons[3].setXLocation(xi, xi + buttonSize);
  }


  void checkTutorialSave() {
    if (folderExists("data/profiles/" + global.profile.display_name.toLowerCase() +
      "/locations/" + Location.TUTORIAL.file_name())) {
      this.status = TutorialStatus.LOADING_SAVED;
      this.tutorial = null;
      this.savedTutorialThread = new OpenSavedTutorialThread();
      this.savedTutorialThread.start();
      return;
    }
    this.startNewTutorial();
  }

  void startNewTutorial() {
    this.status = TutorialStatus.STARTING_NEW;
    this.tutorial = null;
    this.newTutorialThread = new OpenNewTutorialThread();
    this.newTutorialThread.start();
  }

  void completedTutorial(int completion_code) {
    global.log("Completed tutorial with code " + completion_code + ".");
    switch(completion_code) {
      case 0: // default
        this.tutorial = null;
        deleteFolder(this.destination_folder() + Location.TUTORIAL.file_name());
        global.profile.achievement(AchievementCode.COMPLETED_TUTORIAL);
        this.saveAndExitToMainMenu();
        break;
      default:
        global.errorMessage("ERROR: Completion code " + completion_code + " not recognized for tutorial.");
        break;
    }
  }


  Hero getCurrentHeroIfExists() {
    if (this.tutorial != null) {
      return this.tutorial.player;
    }
    return null;
  }

  String destination_folder() {
    return ("data/profiles/" + global.profile.display_name.toLowerCase() + "/locations/");
  }

  void saveTutorial() {
    if (this.tutorial == null) {
      return;
    }
    this.tutorial.save();
    if (this.tutorial.player == null) {
      return;
    }
    PrintWriter file = createWriter(this.destination_folder() + Location.TUTORIAL.file_name() + "/hero.lnz");
    file.println(this.tutorial.player.fileString());
    file.flush();
    file.close();
  }

  void saveAndExitToMainMenu() {
    this.saveTutorial();
    this.tutorial = null;
    global.state = ProgramState.ENTERING_MAINMENU;
  }

  void loseFocus() {
    if (this.tutorial != null) {
      this.tutorial.loseFocus();
    }
  }

  void gainFocus() {
    if (this.tutorial != null) {
      this.tutorial.gainFocus();
    }
  }

  void restartTimers() {
    if (this.tutorial != null) {
      this.tutorial.restartTimers();
    }
  }

  void update(int millis) {
    boolean refreshLevelLocation = false;
    switch(this.status) {
      case INITIAL:
        rectMode(CORNERS);
        noStroke();
        fill(60);
        rect(this.leftPanel.size, 0, width - this.rightPanel.size, height);
        break;
      case STARTING_NEW:
        if (this.newTutorialThread.isAlive()) {
          fill(global.color_mapBorder);
          noStroke();
          rectMode(CORNERS);
          rect(this.leftPanel.size, 0, width - this.rightPanel.size, height);
          fill(global.color_loadingScreenBackground);
          rect(this.leftPanel.size + Constants.map_borderSize, Constants.map_borderSize,
              width - this.rightPanel.size - Constants.map_borderSize, height - Constants.map_borderSize);
          fill(0);
          textSize(24);
          textAlign(LEFT, TOP);
          text(this.newTutorialThread.curr_status + " ...", this.leftPanel.size +
            Constants.map_borderSize + 30, Constants.map_borderSize + 30);
          imageMode(CENTER);
          int frame = int(floor(Constants.gif_loading_frames * (float(millis %
            Constants.gif_loading_time) / (1 + Constants.gif_loading_time))));
          image(global.images.getImage("gifs/loading/" + frame + ".png"), 0.5 * width, 0.5 * height, 250, 250);
        }
        else {
          if (this.newTutorialThread.level == null || this.newTutorialThread.level.nullify) {
            this.tutorial = null;
            this.status = TutorialStatus.INITIAL;
          }
          else {
            this.tutorial = this.newTutorialThread.level;
            this.tutorial.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
            this.tutorial.restartTimers();
            this.status = TutorialStatus.PLAYING;
            this.saveTutorial();
          }
          this.newTutorialThread = null;
          return;
        }
        break;
      case LOADING_SAVED:
        if (this.savedTutorialThread.isAlive()) {
          fill(global.color_mapBorder);
          noStroke();
          rectMode(CORNERS);
          rect(this.leftPanel.size, 0, width - this.rightPanel.size, height);
          fill(global.color_loadingScreenBackground);
          rect(this.leftPanel.size + Constants.map_borderSize, Constants.map_borderSize,
              width - this.rightPanel.size - Constants.map_borderSize, height - Constants.map_borderSize);
          fill(0);
          textSize(24);
          textAlign(LEFT, TOP);
          text(this.savedTutorialThread.curr_status + " ...", this.leftPanel.size +
            Constants.map_borderSize + 30, Constants.map_borderSize + 30);
          imageMode(CENTER);
          int frame = int(floor(Constants.gif_loading_frames * (float(millis %
            Constants.gif_loading_time) / (1 + Constants.gif_loading_time))));
          image(global.images.getImage("gifs/loading/" + frame + ".png"), 0.5 * width, 0.5 * height, 250, 250);
        }
        else {
          if (this.savedTutorialThread.level == null || this.savedTutorialThread.level.nullify) {
            this.tutorial = null;
            this.status = TutorialStatus.INITIAL;
          }
          else {
            this.tutorial = this.savedTutorialThread.level;
            this.tutorial.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
            this.status = TutorialStatus.PLAYING;
          }
          this.savedTutorialThread = null;
          return;
        }
        break;
      case PLAYING:
        if (this.tutorial != null) {
          this.tutorial.update(millis);
          if (this.leftPanel.collapsing || this.rightPanel.collapsing) {
            refreshLevelLocation = true;
          }
          if (this.tutorial.completed) {
            this.completedTutorial(this.tutorial.completion_code);
          }
        }
        break;
      default:
        global.errorMessage("Tutorial status " + this.status + " not recognized.");
        break;
    }
    this.leftPanel.update(millis);
    this.rightPanel.update(millis);
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (TutorialButton button : this.buttons) {
        button.update(millis);
      }
      if (this.tutorial != null) {
        this.tutorial.drawRightPanel(millis);
      }
    }
    if (this.leftPanel.open && !this.leftPanel.collapsing) {
      if (this.tutorial != null) {
        this.tutorial.drawLeftPanel(millis);
      }
    }
    if (refreshLevelLocation) {
      if (this.tutorial != null) {
        this.tutorial.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
      }
    }
  }

  void showNerdStats() {
    if (this.tutorial != null) {
      this.tutorial.displayNerdStats();
    }
    else {
      fill(255);
      textSize(14);
      textAlign(LEFT, TOP);
      float y_stats = 1;
      float line_height = textAscent() + textDescent() + 2;
      text("FPS: " + int(global.lastFPS), 1, y_stats);
    }
  }

  void mouseMove(float mX, float mY) {
    boolean refreshMapLocation = false;
    // level mouse move
    if (this.tutorial != null) {
      this.tutorial.mouseMove(mX, mY);
      if (this.leftPanel.clicked || this.rightPanel.clicked) {
        refreshMapLocation = true;
      }
    }
    // left panel mouse move
    this.leftPanel.mouseMove(mX, mY);
    if (this.leftPanel.open && !this.leftPanel.collapsing) {
      if (this.tutorial != null) {
        if (this.tutorial.leftPanelElementsHovered()) {
          this.leftPanel.hovered = false;
        }
      }
      else if (this.tutorial != null) {
        if (this.tutorial.leftPanelElementsHovered()) {
          this.leftPanel.hovered = false;
        }
      }
    }
    // right panel mouse move
    this.rightPanel.mouseMove(mX, mY);
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (TutorialButton button : this.buttons) {
        button.mouseMove(mX, mY);
      }
    }
    // refresh map location
    if (refreshMapLocation) {
      if (this.tutorial != null) {
        this.tutorial.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
      }
    }
    // cursor icon resolution
    if (this.leftPanel.clicked || this.rightPanel.clicked) {
      this.resizeButtons();
      global.setCursor("icons/cursor_resizeh_white.png");
    }
    else if (this.leftPanel.hovered || this.rightPanel.hovered) {
      global.setCursor("icons/cursor_resizeh.png");
    }
    else {
      global.defaultCursor("icons/cursor_resizeh_white.png", "icons/cursor_resizeh.png");
    }
  }

  void mousePress() {
    if (this.tutorial != null) {
      this.tutorial.mousePress();
    }
    this.leftPanel.mousePress();
    this.rightPanel.mousePress();
    if (this.leftPanel.clicked || this.rightPanel.clicked) {
      global.setCursor("icons/cursor_resizeh_white.png");
    }
    else {
      global.defaultCursor("icons/cursor_resizeh_white.png");
    }
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (TutorialButton button : this.buttons) {
        button.mousePress();
      }
    }
  }

  void mouseRelease(float mX, float mY) {
    if (this.tutorial != null) {
      this.tutorial.mouseRelease(mX, mY);
    }
    this.leftPanel.mouseRelease(mX, mY);
    this.rightPanel.mouseRelease(mX, mY);
    if (this.leftPanel.hovered || this.rightPanel.hovered) {
      global.setCursor("icons/cursor_resizeh.png");
    }
    else {
      global.defaultCursor("icons/cursor_resizeh.png");
    }
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (TutorialButton button : this.buttons) {
        button.mouseRelease(mX, mY);
      }
    }
  }

  void scroll(int amount) {
    if (this.tutorial != null) {
      this.tutorial.scroll(amount);
    }
  }

  void keyPress() {
    if (this.tutorial != null) {
      this.tutorial.keyPress();
    }
  }

  void openEscForm() {
    this.form = new EscForm();
  }

  void keyRelease() {
    if (this.tutorial != null) {
      this.tutorial.keyRelease();
    }
  }
}
