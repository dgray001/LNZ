enum PlayingStatus {
  WORLD_MAP, STARTING_NEW, LOADING_SAVED, PLAYING;
}


class PlayingInterface extends InterfaceLNZ {

  abstract class PlayingButton extends RectangleButton {
    PlayingButton() {
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

  class PlayingButton1 extends PlayingButton {
    PlayingButton1() {
      super();
      this.message = "";
    }
    void release() {
      if (!this.hovered) {
        return;
      }
      this.stayDehovered();
      Hero h = PlayingInterface.this.getCurrentHeroIfExists();
      if (h != null) {
        if (PlayingInterface.this.form != null || PlayingInterface.this.status != PlayingStatus.PLAYING) {
          return;
        }
        if (this.message.contains("Abandon")) {
          PlayingInterface.this.form = new AbandonLevelWhilePlayingForm(h);
        }
        else {
          PlayingInterface.this.form = new EnterNewCampaignForm(h);
        }
      }
    }
  }

  class PlayingButton2 extends PlayingButton {
    PlayingButton2() {
      super();
      this.message = "Options";
    }
    void release() {
      if (!this.hovered) {
        return;
      }
      this.stayDehovered();
      PlayingInterface.this.form = new OptionsForm();
    }
  }

  class PlayingButton3 extends PlayingButton {
    PlayingButton3() {
      super();
      this.message = "Heroes";
    }
    void release() {
      if (!this.hovered) {
        return;
      }
      this.stayDehovered();
      PlayingInterface.this.form = new HeroesForm();
    }
  }

  class PlayingButton4 extends PlayingButton {
    PlayingButton4() {
      super();
      this.message = "Main\nMenu";
    }
    void release() {
      if (!this.hovered) {
        return;
      }
      this.stayDehovered();
      PlayingInterface.this.form = new GoToMainMenuForm();
    }
  }


  class GoToMainMenuForm extends ConfirmForm {
    GoToMainMenuForm() {
      super("Main Menu", "Are you sure you want to save and exit to the main menu?");
    }
    void submit() {
      this.canceled = true;
      PlayingInterface.this.saveAndExitToMainMenu();
    }
  }


  abstract class PlayingForm extends FormLNZ {
    PlayingForm(String title, float formWidth, float formHeight) {
      super(0.5 * (width - formWidth), 0.5 * (height - formHeight),
        0.5 * (width + formWidth), 0.5 * (height + formHeight));
      this.setTitleText(title);
      this.setTitleSize(18);
      this.color_background = color(180, 250, 180);
      this.color_header = color(30, 170, 30);
    }
  }


  class ConfirmStartLevelForm extends PlayingForm {
    protected Hero hero = null;
    ConfirmStartLevelForm(Hero hero) {
      super("Start Level: " + hero.location.display_name(), 550, 390);
      this.hero = hero;

      MessageFormField message1 = new MessageFormField("Begin the following level?");
      if (hero.location.isArea()) {
        message1.setValue("Begin playing in the following area?");
      }
      MessageFormField message2 = new MessageFormField("Hero: " + hero.display_name());
      message2.text_color = color(120, 30, 120);
      message2.setTextSize(18);
      MessageFormField message3 = new MessageFormField("Location: " + hero.location.display_name());
      message3.text_color = color(120, 30, 120);
      message3.setTextSize(18);
      MessageFormField message4 = new MessageFormField("");
      message4.text_color = color(150, 20, 20);
      message4.setTextSize(18);
      SubmitCancelFormField submit = new SubmitCancelFormField("Begin Level", "Abandon Level");
      submit.button1.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      submit.button2.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      if (hero.location.isArea()) {
        submit.button1.message = "Enter Area";
        submit.button2.message = "";
        submit.button2.disabled = true;
      }
      ButtonFormField switch_hero = new ButtonFormField("Switch Hero");
      switch_hero.button.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));

      this.addField(new SpacerFormField(10));
      this.addField(message1);
      this.addField(message2);
      this.addField(message3);
      this.addField(new SpacerFormField(10));
      this.addField(message4);
      this.addField(new SpacerFormField(10));
      this.addField(submit);
      this.addField(switch_hero);
    }

    @Override
    void cancel() {
      if (this.hero.location.isArea()) {
        this.fields.get(5).setValue("You can't abandon an area.");
        return;
      }
      Location area_location = this.hero.location.areaLocation();
      if (global.profile.areas.containsKey(area_location) && global.profile.areas.get(area_location) == Boolean.TRUE) {
        PlayingInterface.this.form = new ConfirmAbandonForm();
        this.canceled = true;
      }
      else {
        this.fields.get(5).setValue("You can't abandon this level as you haven't explored the surrounding area.");
      }
    }

    void submit() {
      PlayingInterface.this.startLevel();
      this.canceled = true;
    }

    @Override
    void buttonPress(int i) {
      switch(i) {
        case 8: // switch hero
          PlayingInterface.this.heroesForm();
          break;
        default:
          global.errorMessage("ERROR: Button press code " + i + " not recognized in ConfirmStartLevelForm.");
          break;
      }
    }
  }


  class ConfirmContinueLevelForm extends PlayingForm {
    protected Hero hero = null;
    ConfirmContinueLevelForm(Hero hero) {
      super("Continue Level: " + hero.location.display_name(), 550, 440);
      this.hero = hero;

      MessageFormField message1 = new MessageFormField("Continue the following level?");
      if (hero.location.isArea()) {
        message1.setValue("Continue playing in the following area?");
      }
      MessageFormField message2 = new MessageFormField("Hero: " + hero.display_name());
      message2.text_color = color(120, 30, 120);
      message2.setTextSize(18);
      MessageFormField message3 = new MessageFormField("Location: " + hero.location.display_name());
      message3.text_color = color(120, 30, 120);
      message3.setTextSize(18);
      MessageFormField message4 = new MessageFormField("");
      message4.text_color = color(150, 20, 20);
      message4.setTextSize(18);
      SubmitCancelFormField submit = new SubmitCancelFormField("Continue Level", "Abandon Level");
      submit.button1.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      submit.button2.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      if (hero.location.isArea()) {
        submit.button1.message = "Continue";
        submit.button2.message = "";
        submit.button2.disabled = true;
      }
      ButtonFormField switch_hero = new ButtonFormField("Switch Hero");
      switch_hero.button.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      ButtonFormField restart_level = new ButtonFormField("Restart Level");
      restart_level.button.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));

      this.addField(new SpacerFormField(10));
      this.addField(message1);
      this.addField(message2);
      this.addField(message3);
      this.addField(new SpacerFormField(10));
      this.addField(message4);
      this.addField(new SpacerFormField(10));
      this.addField(submit);
      this.addField(switch_hero);
      if (!hero.location.isArea()) {
        this.addField(restart_level);
      }
    }

    @Override
    void cancel() {
      if (this.hero.location.isArea()) {
        this.fields.get(5).setValue("You can't abandon an area.");
        return;
      }
      Location area_location = this.hero.location.areaLocation();
      if (global.profile.areas.containsKey(area_location) && global.profile.areas.get(area_location) == Boolean.TRUE) {
        PlayingInterface.this.form = new ConfirmAbandonForm();
        this.canceled = true;
      }
      else {
        this.fields.get(5).setValue("You can't abandon this level as you haven't explored the surrounding area.");
      }
    }

    void submit() {
      PlayingInterface.this.continueLevel();
      this.canceled = true;
    }

    @Override
    void buttonPress(int i) {
      switch(i) {
        case 8: // switch hero
          PlayingInterface.this.heroesForm();
          break;
        case 9: // restart level
          if (this.hero.location.isArea()) {
            this.fields.get(5).setValue("You can't restart an area.");
            return;
          }
          PlayingInterface.this.form = new ConfirmRestartForm();
          this.canceled = true;
          break;
        default:
          global.errorMessage("ERROR: Button press code " + i + " not recognized in ConfirmContinueLevelForm.");
          break;
      }
    }
  }


  class AbandonLevelWhilePlayingForm extends PlayingForm {
    protected Hero hero = null;
    AbandonLevelWhilePlayingForm(Hero hero) {
      super("Abandon Level: " + hero.location.display_name(), 550, 440);
      this.hero = hero;
      this.cancel = null;

      MessageFormField message1 = new MessageFormField("Abandon the following level?");
      MessageFormField message2 = new MessageFormField("Hero: " + hero.display_name());
      message2.text_color = color(120, 30, 120);
      message2.setTextSize(18);
      MessageFormField message3 = new MessageFormField("Location: " + hero.location.display_name());
      message3.text_color = color(120, 30, 120);
      if (hero.location.isArea()) {
        message1.setValue("You can't abandon an area."); // basic instruction on how to start next level
      }
      message3.setTextSize(18);
      MessageFormField message4 = new MessageFormField("");
      message4.text_color = color(150, 20, 20);
      message4.setTextSize(18);
      SubmitCancelFormField submit = new SubmitCancelFormField("Abandon Level", "Restart Level");
      submit.button1.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      submit.button2.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      if (hero.location.isArea()) {
        submit.button1.message = "Continue";
        submit.button2.message = "";
        submit.button2.disabled = true;
      }
      ButtonFormField switch_hero = new ButtonFormField("Switch Hero");
      switch_hero.button.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      ButtonFormField continue_level = new ButtonFormField("Continue Level");
      continue_level.button.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));

      this.addField(new SpacerFormField(10));
      this.addField(message1);
      this.addField(message2);
      this.addField(message3);
      this.addField(new SpacerFormField(10));
      this.addField(message4);
      this.addField(new SpacerFormField(10));
      this.addField(submit);
      this.addField(switch_hero);
      this.addField(continue_level);
    }

    @Override
    void cancel() {
      if (this.hero.location.isArea()) {
        this.fields.get(5).setValue("You can't restart an area.");
        return;
      }
      PlayingInterface.this.form = new ConfirmRestartForm();
      this.canceled = true;
    }

    void submit() {
      if (this.hero.location.isArea()) {
        this.fields.get(5).setValue("You can't abandon an area.");
        return;
      }
      Location area_location = this.hero.location.areaLocation();
      if (global.profile.areas.containsKey(area_location) && global.profile.areas.get(area_location) == Boolean.TRUE) {
        PlayingInterface.this.form = new ConfirmAbandonForm();
        this.canceled = true;
      }
      else {
        this.fields.get(5).setValue("You can't abandon this level as you haven't explored the surrounding area.");
      }
    }

    @Override
    void buttonPress(int i) {
      switch(i) {
        case 8: // switch hero
          PlayingInterface.this.heroesForm();
          break;
        case 9: // continue level
          this.canceled = true;
          break;
        default:
          global.errorMessage("ERROR: Button press code " + i + " not recognized in AbandonLevelWhilePlayingForm.");
          break;
      }
    }
  }


  abstract class ConfirmActionForm extends FormLNZ {
    ConfirmActionForm(String title, String message) {
      super(0.5 * width - 120, 0.5 * height - 120, 0.5 * width + 120, 0.5 * height + 120);
      this.setTitleText(title);
      this.setTitleSize(18);
      this.color_background = color(180, 250, 180);
      this.color_header = color(30, 170, 30);
      this.scrollbar.setButtonColors(color(170), color(190, 255, 190),
        color(220, 255, 220), color(160, 220, 160), color(0));

      SubmitCancelFormField submit = new SubmitCancelFormField("  Ok  ", "Cancel");
      submit.button1.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      submit.button2.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      TextBoxFormField textbox = new TextBoxFormField(message, 120);
      textbox.textbox.scrollbar.setButtonColors(color(170), color(190, 255, 190),
        color(220, 255, 220), color(160, 220, 160), color(0));

      this.addField(new SpacerFormField(0));
      this.addField(textbox);
      this.addField(submit);
    }

    void submit() {
      this.canceled = true;
      this.doAction();
    }

    abstract void doAction();
  }


  class ConfirmAbandonForm extends ConfirmActionForm {
    ConfirmAbandonForm() {
      super("Abandon Level", "Are you sure you want to abandon the level?");
    }
    void doAction() {
      if (PlayingInterface.this.status == PlayingStatus.PLAYING) {
        PlayingInterface.this.saveAndReturnToInitialState();
      }
      PlayingInterface.this.abandonLevel();
    }
  }


  class ConfirmRestartForm extends ConfirmActionForm {
    ConfirmRestartForm() {
      super("Restart Level", "Are you sure you want to restart the level?");
    }
    void doAction() {
      if (PlayingInterface.this.status == PlayingStatus.PLAYING) {
        PlayingInterface.this.saveAndReturnToInitialState();
      }
      PlayingInterface.this.restartLevel();
    }
  }


  class ConfirmLaunchCampaign extends ConfirmActionForm {
    protected Location location = Location.ERROR;
    ConfirmLaunchCampaign(Location location) {
      super("Launch Campaign", "Are you sure you want to launch a new campaign?");
      this.location = location;
    }
    void doAction() {
      PlayingInterface.this.saveAndReturnToInitialState();
      PlayingInterface.this.launchCampaign(this.location);
    }
  }


  class EnterNewCampaignForm extends FormLNZ {
    protected Hero hero = null;
    protected DropDownList list = null;

    EnterNewCampaignForm(Hero hero) {
      super(0.5 * (width - 300), 0.5 * (height - 400),
        0.5 * (width + 300), 0.5 * (height + 400));
      this.setTitleText("Enter New Campaign");
      this.setTitleSize(18);
      this.color_background = color(180, 250, 180);
      this.color_header = color(30, 170, 30);
      this.hero = hero;

      TextBoxFormField list_field = new TextBoxFormField("", 100);
      this.list = new DropDownList();
      this.list.setLocation(0, 0, 0, 100);
      this.list.hint_text = "Select Campaign to Launch";
      boolean first = true;
      for (Location a : hero.location.locationsFromArea()) {
        if (first) {
          first = false;
          this.list.setText(a.display_name());
        }
        else {
          this.list.addLine(a.display_name());
        }
      }
      list_field.textbox = this.list;
      SubmitCancelFormField submit = new SubmitCancelFormField("Launch Campaign", "Cancel");
      submit.button1.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      submit.button2.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));

      this.addField(new SpacerFormField(0));
      this.addField(list_field);
      this.addField(submit);
    }

    void submit() {
      String location_name = this.list.highlightedLine();
      if (location_name == null) {
        return;
      }
      Location new_location = Location.location(location_name);
      if (new_location == null || new_location == Location.ERROR) {
        global.errorMessage("ERROR: The location name " + location_name +
          " gave an invalid location.");
        return;
      }
      if (!new_location.isCampaignStart()) {
        global.errorMessage("ERROR: The location " + new_location.display_name() +
          " is not the start of any campaign.");
        return;
      }
      for (Map.Entry<HeroCode, Hero> entry : global.profile.heroes.entrySet()) {
        // can't enter campaign another hero is in
        if (entry.getValue().location.getCampaignStart() == new_location) {
          return;
        }
      }
      PlayingInterface.this.form = new ConfirmLaunchCampaign(new_location);
      this.canceled = true;
    }
  }


  class OpenNewLevelThread extends Thread {
    private Level level = null;
    private Hero hero = null;
    private String curr_status = "";
    private boolean running = true;

    OpenNewLevelThread(Hero hero) {
      super("OpenNewLevelThread");
      this.setDaemon(true);
      this.hero = hero;
    }

    void stopThread() {
      this.running = false;
      deleteFolder(PlayingInterface.this.savePath + this.hero.location.file_name());
    }

    @Override
    void run() {
      while(this.running) {
        this.curr_status += "Gathering Level Data";
        if (this.hero == null) {
          this.curr_status += " -> No hero found.";
          delay(2500);
          return;
        }
        if (this.hero.location == null || this.hero.location == Location.ERROR) {
          this.curr_status += " -> No hero location found.";
          delay(2500);
          return;
        }
        this.level = new Level("data/locations", this.hero.location);
        if (this.level.nullify) {
          this.curr_status += " -> " + global.lastErrorMessage();
          delay(2500);
          return;
        }
        this.curr_status += "\nCopying Data";
        mkdir(PlayingInterface.this.savePath);
        String destination_folder = PlayingInterface.this.savePath + this.hero.location.file_name();
        deleteFolder(destination_folder);
        copyFolder("data/locations/" + this.hero.location.file_name(), destination_folder);
        this.level.folderPath = PlayingInterface.this.savePath;
        this.level.save();
        if (!this.hero.location.isArea()) {
          PrintWriter hero_file = createWriter(destination_folder + "/old_hero.lnz");
          hero_file.println(this.hero.fileString());
          hero_file.flush();
          hero_file.close();
        }
        if (this.level.nullify) {
          this.curr_status += " -> " + global.lastErrorMessage();
          delay(2500);
          return;
        }
        this.curr_status += "\nOpening Map";
        this.level.setPlayer(this.hero);
        if (this.level.nullify) {
          this.curr_status += " -> " + global.lastErrorMessage();
          delay(2500);
          return;
        }
        if (!global.images.loaded_map_gifs) {
          this.curr_status += "\nLoading Animations";
          global.images.loadMapGifs();
        }
        break;
      }
    }
  }


  class OpenSavedLevelThread extends Thread {
    private Level level = null;
    private Hero hero = null;
    private String curr_status = "";
    private boolean running = true;

    OpenSavedLevelThread(Hero hero) {
      super("OpenSavedLevelThread");
      this.setDaemon(true);
      this.hero = hero;
    }

    void stopThread() {
      this.running = false;
    }

    @Override
    void run() {
      while(this.running) {
        this.curr_status += "Opening Saved Level";
        if (this.hero == null) {
          this.curr_status += " -> No hero found.";
          delay(2500);
          return;
        }
        if (this.hero.location == null || this.hero.location == Location.ERROR) {
          this.curr_status += " -> No hero location found.";
          delay(2500);
          return;
        }
        String destination_folder = "data/profiles/" + global.profile.display_name.toLowerCase() + "/locations/";
        this.level = new Level(destination_folder, this.hero.location);
        if (this.level.nullify) {
          this.curr_status += " -> " + global.lastErrorMessage();
          delay(2500);
          return;
        }
        curr_status += "\nOpening Map";
        this.level.openCurrMap();
        this.level.addPlayer(this.hero);
        if (this.level.nullify) {
          this.curr_status += " -> " + global.lastErrorMessage();
          delay(2500);
          return;
        }
        if (!global.images.loaded_map_gifs) {
          this.curr_status += "\nLoading Animations";
          global.images.loadMapGifs();
        }
        break;
      }
    }
  }


  class LoadWorldMapThread extends Thread {
    LoadWorldMapThread() {
      super("LoadWorldMapThread");
      this.setDaemon(true);
    }
    @Override
    void run() {
      WorldMap map = new WorldMap();
      PlayingInterface.this.world_map = map;
    }
  }


  private PlayingButton[] buttons = new PlayingButton[4];
  private Panel leftPanel = new Panel(LEFT, Constants.mapEditor_panelMinWidth,
    Constants.mapEditor_panelMaxWidth, Constants.mapEditor_panelStartWidth);
  private Panel rightPanel = new Panel(RIGHT, Constants.mapEditor_panelMinWidth,
    Constants.mapEditor_panelMaxWidth, Constants.mapEditor_panelStartWidth);

  private String savePath = "data/profiles/" + global.profile.display_name.toLowerCase() + "/locations/";
  private WorldMap world_map = null;
  private Level level = null;
  private PlayingStatus status = PlayingStatus.WORLD_MAP;
  private boolean check_level_save = false;

  private OpenNewLevelThread newLevelThread = null;
  private OpenSavedLevelThread savedLevelThread = null;
  private LoadWorldMapThread worldMapThread = null;

  private boolean return_to_confirmStartLevelForm = false;
  private boolean return_to_confirmContinueLevelForm = false;
  private boolean return_to_confirmAbandonLevelForm = false;


  PlayingInterface() {
    this.buttons[0] = new PlayingButton1();
    this.buttons[1] = new PlayingButton2();
    this.buttons[2] = new PlayingButton3();
    this.buttons[3] = new PlayingButton4();
    this.leftPanel.addIcon(global.images.getImage("icons/triangle_gray.png"));
    this.rightPanel.addIcon(global.images.getImage("icons/triangle_gray.png"));
    this.leftPanel.color_background = global.color_panelBackground;
    this.rightPanel.color_background = global.color_panelBackground;
    this.resizeButtons();
    this.worldMapThread = new LoadWorldMapThread();
    this.worldMapThread.start();
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


  void checkLevelSave() {
    if (global.profile.curr_hero == null || global.profile.curr_hero == HeroCode.ERROR) {
      global.errorMessage("ERROR: Profile has no current hero.");
      return;
    }
    Hero curr_hero = global.profile.heroes.get(global.profile.curr_hero);
    if (curr_hero == null) {
      global.errorMessage("ERROR: Profile missing curr hero " + global.profile.curr_hero + ".");
      return;
    }
    if (curr_hero.location == null || curr_hero.location == Location.ERROR) {
      global.errorMessage("ERROR: Hero " + curr_hero.display_name() + " missing location data.");
      return;
    }
    if (folderExists(this.savePath + curr_hero.location.file_name())) {
      this.form = new ConfirmContinueLevelForm(curr_hero);
    }
    else {
      this.form = new ConfirmStartLevelForm(curr_hero);
    }
  }

  void startLevel() {
    if (this.level != null) {
      global.errorMessage("ERROR: Trying to open level save when current level not null.");
      return;
    }
    if (this.status != PlayingStatus.WORLD_MAP) {
      global.errorMessage("ERROR: Trying to open level save when current status is " + this.status + ".");
      return;
    }
    if (global.profile.curr_hero == null || global.profile.curr_hero == HeroCode.ERROR) {
      global.errorMessage("ERROR: Profile has no current hero.");
      return;
    }
    Hero curr_hero = global.profile.heroes.get(global.profile.curr_hero);
    if (curr_hero == null) {
      global.errorMessage("ERROR: Profile missing curr hero " + global.profile.curr_hero + ".");
      return;
    }
    if (curr_hero.location == null || curr_hero.location == Location.ERROR) {
      global.errorMessage("ERROR: Hero " + curr_hero.display_name() + " missing location data.");
      return;
    }
    this.status = PlayingStatus.STARTING_NEW;
    this.newLevelThread = new OpenNewLevelThread(curr_hero);
    this.newLevelThread.start();
  }

  void continueLevel() {
    if (this.level != null) {
      global.errorMessage("ERROR: Trying to open level save when current level not null.");
      return;
    }
    if (this.status != PlayingStatus.WORLD_MAP) {
      global.errorMessage("ERROR: Trying to open level save when current status is " + this.status + ".");
      return;
    }
    if (global.profile.curr_hero == null || global.profile.curr_hero == HeroCode.ERROR) {
      global.errorMessage("ERROR: Profile has no current hero.");
      return;
    }
    Hero curr_hero = global.profile.heroes.get(global.profile.curr_hero);
    if (curr_hero == null) {
      global.errorMessage("ERROR: Profile missing curr hero " + global.profile.curr_hero + ".");
      return;
    }
    if (curr_hero.location == null || curr_hero.location == Location.ERROR) {
      global.errorMessage("ERROR: Hero " + curr_hero.display_name() + " missing location data.");
      return;
    }
    if (!folderExists(this.savePath + curr_hero.location.file_name())) {
      global.errorMessage("ERROR: No save folder at " + (this.savePath + curr_hero.location.file_name()) + ".");
      return;
    }
    this.status = PlayingStatus.LOADING_SAVED;
    this.savedLevelThread = new OpenSavedLevelThread(curr_hero);
    this.savedLevelThread.start();
  }

  void restartLevel() {
    if (this.level != null) {
      global.errorMessage("ERROR: Trying to restart level when current level not null.");
      return;
    }
    if (this.status != PlayingStatus.WORLD_MAP) {
      global.errorMessage("ERROR: Trying to restart level save when current status is " + this.status + ".");
      return;
    }
    if (global.profile.curr_hero == null || global.profile.curr_hero == HeroCode.ERROR) {
      global.errorMessage("ERROR: Profile has no current hero.");
      return;
    }
    Hero curr_hero = global.profile.heroes.get(global.profile.curr_hero);
    if (curr_hero == null) {
      global.errorMessage("ERROR: Profile missing curr hero " + global.profile.curr_hero + ".");
      return;
    }
    if (curr_hero.location == null || curr_hero.location == Location.ERROR) {
      global.errorMessage("ERROR: Hero " + curr_hero.display_name() + " missing location data.");
      return;
    }
    if (!folderExists(this.savePath + curr_hero.location.file_name())) {
      global.errorMessage("ERROR: No save folder at " + (this.savePath + curr_hero.location.file_name()) + ".");
      return;
    }
    if (curr_hero.location.isArea()) {
      global.errorMessage("ERROR: Can't restart " + curr_hero.location.display_name() + " since it's an area.");
      return;
    }
    Hero hero = readHeroFile(this.savePath + curr_hero.location.file_name() + "/old_hero.lnz");
    if (hero == null || hero.code == HeroCode.ERROR || hero.code != curr_hero.code || hero.location != curr_hero.location) {
      global.errorMessage("ERROR: Can't restart " + curr_hero.location.display_name() + " since old hero data corrupted.");
      return;
    }
    deleteFolder(this.savePath + curr_hero.location.file_name());
    global.profile.heroes.put(hero.code, hero);
    this.status = PlayingStatus.STARTING_NEW;
    this.newLevelThread = new OpenNewLevelThread(hero);
    this.newLevelThread.start();
  }

  void abandonLevel() {
    if (this.level != null) {
      global.errorMessage("ERROR: Trying to restart level when current level not null.");
      return;
    }
    if (this.status != PlayingStatus.WORLD_MAP) {
      global.errorMessage("ERROR: Trying to restart level save when current status is " + this.status + ".");
      return;
    }
    if (global.profile.curr_hero == null || global.profile.curr_hero == HeroCode.ERROR) {
      global.errorMessage("ERROR: Profile has no current hero.");
      return;
    }
    Hero curr_hero = global.profile.heroes.get(global.profile.curr_hero);
    if (curr_hero == null) {
      global.errorMessage("ERROR: Profile missing curr hero " + global.profile.curr_hero + ".");
      return;
    }
    if (curr_hero.location == null || curr_hero.location == Location.ERROR) {
      global.errorMessage("ERROR: Hero " + curr_hero.display_name() + " missing location data.");
      return;
    }
    if (curr_hero.location.isArea()) {
      global.errorMessage("ERROR: Can't abandon " + curr_hero.location.display_name() + " since it's an area.");
      return;
    }
    Location area_location = curr_hero.location.areaLocation();
    if (!global.profile.areas.containsKey(area_location) || global.profile.areas.get(area_location) == Boolean.FALSE) {
      global.errorMessage("ERROR: Can't abandon " + curr_hero.location.display_name() + " since its area isn't unlocked.");
      return;
    }
    if (folderExists(this.savePath + curr_hero.location.file_name())) {
      Hero hero = readHeroFile(this.savePath + curr_hero.location.file_name() + "/old_hero.lnz");
      if (hero == null || hero.code == HeroCode.ERROR || hero.code != curr_hero.code || hero.location != curr_hero.location) {
        global.errorMessage("ERROR: Can't restart " + curr_hero.location.display_name() + " since old hero data corrupted.");
        return;
      }
      deleteFolder(this.savePath + curr_hero.location.file_name());
      hero.location = area_location;
      global.profile.heroes.put(hero.code, hero);
      this.status = PlayingStatus.LOADING_SAVED;
      this.savedLevelThread = new OpenSavedLevelThread(hero);
      this.savedLevelThread.start();
    }
    else {
      curr_hero.location = area_location;
      this.status = PlayingStatus.STARTING_NEW;
      this.newLevelThread = new OpenNewLevelThread(curr_hero);
      this.newLevelThread.start();
    }
  }

  void launchCampaign(Location new_location) {
    if (this.level != null) {
      global.errorMessage("ERROR: Trying to launch new campaign when current level not null.");
      return;
    }
    if (this.status != PlayingStatus.WORLD_MAP) {
      global.errorMessage("ERROR: Trying to launch new campaign save when current status is " + this.status + ".");
      return;
    }
    if (global.profile.curr_hero == null || global.profile.curr_hero == HeroCode.ERROR) {
      global.errorMessage("ERROR: Profile has no current hero.");
      return;
    }
    Hero curr_hero = global.profile.heroes.get(global.profile.curr_hero);
    if (curr_hero == null) {
      global.errorMessage("ERROR: Profile missing curr hero " + global.profile.curr_hero + ".");
      return;
    }
    if (curr_hero.location == null || curr_hero.location == Location.ERROR) {
      global.errorMessage("ERROR: Hero " + curr_hero.display_name() + " missing location data.");
      return;
    }
    if (!curr_hero.location.isArea()) {
      global.errorMessage("ERROR: Can't launch new campaign since hero in " +
        curr_hero.location.display_name() + " which is not an area.");
      return;
    }
    if (new_location == null || new_location == Location.ERROR) {
      global.errorMessage("ERROR: New location does not exist.");
      return;
    }
    ArrayList<Location> campaign_locations = curr_hero.location.locationsFromArea();
    boolean valid_new_location = false;
    for (Location a : campaign_locations) {
      if (a == new_location) {
        valid_new_location = true;
        break;
      }
    }
    if (!valid_new_location) {
      global.errorMessage("ERROR: New location " + new_location.display_name() +
        " is not accessible from hero's current location " + curr_hero.location.display_name());
      return;
    }
    if (!new_location.isCampaignStart()) {
      global.errorMessage("ERROR: New location " + new_location.display_name() +
        " is not a campaign start point.");
      return;
    }
    for (Map.Entry<HeroCode, Hero> entry : global.profile.heroes.entrySet()) {
      // can't enter campaign another hero is in
      if (entry.getValue().location.getCampaignStart() == new_location) {
        global.errorMessage("ERROR: New location " + new_location.display_name() +
          " is being played by " + entry.getValue().display_name() + " already.");
        return;
      }
    }
    curr_hero.location = new_location;
    this.status = PlayingStatus.STARTING_NEW;
    this.newLevelThread = new OpenNewLevelThread(curr_hero);
    this.newLevelThread.start();
  }

  void switchHero(Hero hero) {
    if (hero == null || hero.code == null || hero.code == HeroCode.ERROR) {
      global.errorMessage("ERROR: Can't switch to a hero code that doesn't exist.");
      return;
    }
    if (!global.profile.heroes.containsKey(hero.code)) {
      global.errorMessage("ERROR: Can't switch to a hero that hasn't beens unlocked.");
      return;
    }
    if (global.profile.curr_hero == hero.code) {
      return;
    }
    switch(this.status) {
      case WORLD_MAP:
        break;
      case STARTING_NEW:
        if (this.newLevelThread == null) {
          global.errorMessage("ERROR: No thread in new level status.");
          break;
        }
        this.newLevelThread.stopThread();
        this.newLevelThread = null;
        break;
      case LOADING_SAVED:
        if (this.savedLevelThread == null) {
          global.errorMessage("ERROR: No thread in open level status.");
          break;
        }
        this.savedLevelThread.stopThread();
        this.savedLevelThread = null;
        break;
      case PLAYING:
        if (this.level == null) {
          global.errorMessage("ERROR: No level in playing status.");
          break;
        }
        this.level.save();
        this.level = null;
        break;
      default:
        global.errorMessage("ERROR: Playing status " + this.status + " not recognized.");
        break;
    }
    global.profile.curr_hero = hero.code;
    global.profile.saveHeroesFile();
    this.status = PlayingStatus.WORLD_MAP;
  }


  void completedLevel(int completion_code) {
    if (this.level == null || this.status != PlayingStatus.PLAYING) {
      global.errorMessage("ERROR: Can't complete level when not playing one.");
      return;
    }
    if (this.level.player == null || this.level.player.code == null || this.level.player.code == HeroCode.ERROR) {
      global.errorMessage("ERROR: Can't complete level without a player object.");
      return;
    }
    global.log("Completed level " + this.level.location.display_name() + " with code " + completion_code + ".");
    Location next_location = Location.nextLocation(this.level.location, completion_code);
    if (next_location == Location.ERROR) {
      global.errorMessage("ERROR: Completion code " + completion_code +
        " not recognized for location " + this.level.location.display_name() + ".");
    }
    this.level.player.stopAction();
    this.level.player.statuses.clear();
    this.level.player.restartAbilityTimers();
    deleteFolder(this.savePath + this.level.player.location.file_name());
    this.level.player.location = next_location;
    global.profile.saveHeroesFile();
    if (next_location.isArea()) {
      global.profile.unlockArea(next_location);
    }
    this.status = PlayingStatus.WORLD_MAP;
    this.level = null;
  }


  Hero getCurrentHeroIfExists() {
    if (this.level != null) {
      return this.level.player;
    }
    return null;
  }

  void saveLevel() {
    if (this.level == null) {
      return;
    }
    this.level.save();
    global.profile.saveHeroesFile();
  }

  void saveAndExitToMainMenu() {
    this.saveAndReturnToInitialState();
    global.state = ProgramState.ENTERING_MAINMENU;
  }

  void saveAndReturnToInitialState() {
    this.saveLevel();
    this.status = PlayingStatus.WORLD_MAP;
    this.level = null;
  }

  void loseFocus() {
    if (this.level != null) {
      this.level.loseFocus();
    }
  }

  void gainFocus() {
    if (this.level != null) {
      this.level.gainFocus();
    }
  }

  void restartTimers() {
    if (this.level != null) {
      this.level.restartTimers();
    }
  }

  void update(int millis) {
    boolean refreshLevelLocation = false;
    switch(this.status) {
      case WORLD_MAP:
        if (this.world_map != null) {
          this.world_map.update(millis);
        }
        else {
          rectMode(CORNERS);
          noStroke();
          fill(ccolor(60));
          rect(this.leftPanel.size, 0, width - this.rightPanel.size, height);
        }
        break;
      case STARTING_NEW:
        if (this.newLevelThread.isAlive()) {
          fill(global.color_mapBorder);
          noStroke();
          rectMode(CORNERS);
          rect(this.leftPanel.size, 0, width - this.rightPanel.size, height);
          fill(global.color_loadingScreenBackground);
          rect(this.leftPanel.size + Constants.map_borderSize, Constants.map_borderSize,
              width - this.rightPanel.size - Constants.map_borderSize, height - Constants.map_borderSize);
          fill(ccolor(0));
          textSize(24);
          textAlign(LEFT, TOP);
          text(this.newLevelThread.curr_status + " ...", this.leftPanel.size +
            Constants.map_borderSize + 30, Constants.map_borderSize + 30);
          imageMode(CENTER);
          int frame = int(floor(Constants.gif_loading_frames * (float(millis %
            Constants.gif_loading_time) / (1 + Constants.gif_loading_time))));
          image(global.images.getImage("gifs/loading/" + frame + ".png"), 0.5 * width, 0.5 * height, 250, 250);
        }
        else {
          if (this.newLevelThread.level == null || this.newLevelThread.level.nullify) {
            this.level = null;
            this.status = PlayingStatus.WORLD_MAP;
          }
          else {
            this.level = this.newLevelThread.level;
            this.level.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
            this.level.restartTimers();
            if (this.level.album_name != null) {
              global.sounds.play_background(this.level.album_name);
            }
            this.status = PlayingStatus.PLAYING;
            if (this.level.location.isArea()) {
              this.buttons[0].message = "Launch\nCampaign";
            }
            else {
              this.buttons[0].message = "Abandon\nLevel";
            }
          }
          this.newLevelThread = null;
          return;
        }
        break;
      case LOADING_SAVED:
        if (this.savedLevelThread.isAlive()) {
          fill(global.color_mapBorder);
          noStroke();
          rectMode(CORNERS);
          rect(this.leftPanel.size, 0, width - this.rightPanel.size, height);
          fill(global.color_loadingScreenBackground);
          rect(this.leftPanel.size + Constants.map_borderSize, Constants.map_borderSize,
              width - this.rightPanel.size - Constants.map_borderSize, height - Constants.map_borderSize);
          fill(ccolor(0));
          textSize(24);
          textAlign(LEFT, TOP);
          text(this.savedLevelThread.curr_status + " ...", this.leftPanel.size +
            Constants.map_borderSize + 30, Constants.map_borderSize + 30);
          imageMode(CENTER);
          int frame = int(floor(Constants.gif_loading_frames * (float(millis %
            Constants.gif_loading_time) / (1 + Constants.gif_loading_time))));
          image(global.images.getImage("gifs/loading/" + frame + ".png"), 0.5 * width, 0.5 * height, 250, 250);
        }
        else {
          if (this.savedLevelThread.level == null || this.savedLevelThread.level.nullify ||
            this.savedLevelThread.level.currMap == null || this.savedLevelThread.level.currMap.nullify) {
            this.level = null;
            this.status = PlayingStatus.WORLD_MAP;
          }
          else {
            this.level = this.savedLevelThread.level;
            this.level.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
            this.level.restartTimers();
            if (this.level.album_name != null) {
              global.sounds.play_background(this.level.album_name);
            }
            this.level.currMap.addHeaderMessage(GameMapCode.display_name(this.level.currMap.code));
            this.status = PlayingStatus.PLAYING;
            if (this.level.location.isArea()) {
              this.buttons[0].message = "Launch\nCampaign";
            }
            else {
              this.buttons[0].message = "Abandon\nLevel";
            }
          }
          this.savedLevelThread = null;
          return;
        }
        break;
      case PLAYING:
        if (this.level != null) {
          this.level.update(millis);
          if (this.leftPanel.collapsing || this.rightPanel.collapsing) {
            refreshLevelLocation = true;
          }
          if (this.level.completed) {
            this.completedLevel(this.level.completion_code);
          }
        }
        else {
          global.errorMessage("ERROR: In playing status but no level to update.");
          this.status = PlayingStatus.WORLD_MAP;
        }
        break;
      default:
        global.errorMessage("ERROR: Playing status " + this.status + " not recognized.");
        break;
    }
    this.leftPanel.update(millis);
    this.rightPanel.update(millis);
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (PlayingButton button : this.buttons) {
        button.update(millis);
      }
      if (this.level != null) {
        this.level.drawRightPanel(millis);
      }
    }
    if (this.leftPanel.open && !this.leftPanel.collapsing) {
      if (this.level != null) {
        this.level.drawLeftPanel(millis);
      }
    }
    if (refreshLevelLocation) {
      if (this.level != null) {
        this.level.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
      }
    }
    if (this.check_level_save && this.status == PlayingStatus.WORLD_MAP) {
      this.checkLevelSave();
      this.check_level_save = false;
    }
  }

  void showNerdStats() {
    if (this.level != null) {
      this.level.displayNerdStats();
    }
    else {
      fill(ccolor(255));
      textSize(14);
      textAlign(LEFT, TOP);
      float y_stats = 1;
      float line_height = textAscent() + textDescent() + 2;
      text("FPS: " + int(global.lastFPS), 1, y_stats);
    }
  }

  void mouseMove(float mX, float mY) {
    boolean refreshMapLocation = false;
    if (this.status == PlayingStatus.WORLD_MAP && this.world_map != null) {
      this.world_map.mouseMove(mX, mY);
    }
    // level mouse move
    if (this.level != null) {
      this.level.mouseMove(mX, mY);
      if (this.leftPanel.clicked || this.rightPanel.clicked) {
        refreshMapLocation = true;
      }
    }
    // left panel mouse move
    this.leftPanel.mouseMove(mX, mY);
    if (this.leftPanel.open && !this.leftPanel.collapsing) {
      if (this.level != null) {
        if (this.level.leftPanelElementsHovered()) {
          this.leftPanel.hovered = false;
        }
      }
    }
    // right panel mouse move
    this.rightPanel.mouseMove(mX, mY);
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (PlayingButton button : this.buttons) {
        button.mouseMove(mX, mY);
      }
    }
    // refresh map location
    if (refreshMapLocation) {
      if (this.level != null) {
        this.level.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
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
    if (this.status == PlayingStatus.WORLD_MAP && this.world_map != null) {
      this.world_map.mousePress();
    }
    if (this.level != null) {
      this.level.mousePress();
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
      for (PlayingButton button : this.buttons) {
        button.mousePress();
      }
    }
  }

  void mouseRelease(float mX, float mY) {
    if (this.status == PlayingStatus.WORLD_MAP && this.world_map != null) {
      this.world_map.mouseRelease(mX, mY);
    }
    if (this.level != null) {
      this.level.mouseRelease(mX, mY);
    }
    this.leftPanel.mouseRelease(mX, mY);
    this.rightPanel.mouseRelease(mX, mY);
    if (this.leftPanel.hovered || this.rightPanel.hovered) {
      global.setCursor("icons/cursor_resizeh.png");
    }
    else {
      global.defaultCursor("icons/cursor_resizeh.png", "icons/cursor_resizeh_white.png");
    }
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (PlayingButton button : this.buttons) {
        button.mouseRelease(mX, mY);
      }
    }
  }

  void scroll(int amount) {
    if (this.status == PlayingStatus.WORLD_MAP && this.world_map != null) {
      this.world_map.scroll(amount);
    }
    if (this.level != null) {
      this.level.scroll(amount);
    }
  }

  void keyPress() {
    if (this.level != null) {
      this.level.keyPress();
    }
  }

  void openEscForm() {
    this.form = new EscForm();
  }

  void keyRelease() {
    if (this.level != null) {
      this.level.keyRelease();
    }
  }
}
