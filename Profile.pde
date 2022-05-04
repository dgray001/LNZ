enum PlayerTreeCode {
  CAN_PLAY;
  private static final List<PlayerTreeCode> VALUES = Collections.unmodifiableList(Arrays.asList(values()));
}



class Profile {
  class Options {
    private float volume_master;
    private boolean volume_master_muted;
    private float volume_music;
    private boolean volume_music_muted;
    private float volume_interface;
    private boolean volume_interface_muted;
    private float volume_environment;
    private boolean volume_environment_muted;
    private float volume_units;
    private boolean volume_units_muted;
    private float volume_player;
    private boolean volume_player_muted;

    private float map_viewMoveSpeedFactor;

    Options() {
      this.profileUpdated();
    }

    void profileUpdated() {
      this.defaults();
      this.read();
      this.change();
    }

    void defaults() {
      this.volume_master = Constants.options_defaultVolume;
      this.volume_master_muted = false;
      this.volume_music = Constants.options_defaultVolume;
      this.volume_music_muted = false;
      this.volume_interface = Constants.options_defaultVolume;
      this.volume_interface_muted = false;
      this.volume_environment = Constants.options_defaultVolume;
      this.volume_environment_muted = false;
      this.volume_units = Constants.options_defaultVolume;
      this.volume_units_muted = false;
      this.volume_player = Constants.options_defaultVolume;
      this.volume_player_muted = false;
      this.map_viewMoveSpeedFactor = Constants.map_defaultCameraSpeed;
    }

    void change() {
      if (Profile.this.invalidProfile()) {
        return;
      }
      float master_gain_adjustment = this.volume_master + Constants.options_volumeGainAdjustment;

      if (this.volume_master_muted || this.volume_music_muted) {
        global.sounds.setBackgroundGain(this.volume_music + Constants.options_volumeGainAdjustment + master_gain_adjustment, true);
      }
      else {
        global.sounds.setBackgroundGain(this.volume_music + Constants.options_volumeGainAdjustment + master_gain_adjustment, false);
      }

      if (this.volume_master_muted || this.volume_interface_muted) {
        global.sounds.out_interface.mute();
      }
      else {
        global.sounds.out_interface.unmute();
      }
      global.sounds.out_interface.setGain(this.volume_interface + Constants.options_volumeGainAdjustment + master_gain_adjustment);

      if (this.volume_master_muted || this.volume_environment_muted) {
        global.sounds.out_environment.mute();
      }
      else {
        global.sounds.out_environment.unmute();
      }
      global.sounds.out_environment.setGain(this.volume_environment + Constants.options_volumeGainAdjustment + master_gain_adjustment);

      if (this.volume_master_muted || this.volume_units_muted) {
        global.sounds.out_units.mute();
      }
      else {
        global.sounds.out_units.unmute();
      }
      global.sounds.out_units.setGain(this.volume_units + Constants.options_volumeGainAdjustment + master_gain_adjustment);

      if (this.volume_master_muted || this.volume_player_muted) {
        global.sounds.out_player.mute();
      }
      else {
        global.sounds.out_player.unmute();
      }
      global.sounds.out_player.setGain(this.volume_player + Constants.options_volumeGainAdjustment + master_gain_adjustment);
    }

    void read() {
      if (Profile.this.invalidProfile()) {
        return;
      }
      String[] lines = loadStrings(sketchPath("data/profiles/" + Profile.this.display_name.toLowerCase() + "/options.lnz"));
      if (lines == null) {
        this.save(); // save defaults if no options exists
        return;
      }
      for (String line : lines) {
        String[] data = split(line, ':');
        if (data.length < 2) {
          continue;
        }
        switch(data[0]) {
          case "volume_master":
            this.volume_master = toFloat(trim(data[1]));
            break;
          case "volume_master_muted":
            this.volume_master_muted = toBoolean(trim(data[1]));
            break;
          case "volume_music":
            this.volume_music = toFloat(trim(data[1]));
            break;
          case "volume_music_muted":
            this.volume_music_muted = toBoolean(trim(data[1]));
            break;
          case "volume_interface":
            this.volume_interface = toFloat(trim(data[1]));
            break;
          case "volume_interface_muted":
            this.volume_interface_muted = toBoolean(trim(data[1]));
            break;
          case "volume_environment":
            this.volume_environment = toFloat(trim(data[1]));
            break;
          case "volume_environment_muted":
            this.volume_environment_muted = toBoolean(trim(data[1]));
            break;
          case "volume_units":
            this.volume_units = toFloat(trim(data[1]));
            break;
          case "volume_units_muted":
            this.volume_units_muted = toBoolean(trim(data[1]));
            break;
          case "volume_player":
            this.volume_player = toFloat(trim(data[1]));
            break;
          case "volume_player_muted":
            this.volume_player_muted = toBoolean(trim(data[1]));
            break;
          case "map_viewMoveSpeedFactor":
            this.map_viewMoveSpeedFactor = toFloat(trim(data[1]));
            break;
          default:
            break;
        }
      }
    }

    void save() {
      if (Profile.this.invalidProfile()) {
        return;
      }
      PrintWriter file = createWriter(sketchPath("data/profiles/" + Profile.this.display_name.toLowerCase() + "/options.lnz"));
      file.println("volume_master: " + this.volume_master);
      file.println("volume_master_muted: " + this.volume_master_muted);
      file.println("volume_music: " + this.volume_music);
      file.println("volume_music_muted: " + this.volume_music_muted);
      file.println("volume_interface: " + this.volume_interface);
      file.println("volume_interface_muted: " + this.volume_interface_muted);
      file.println("volume_environment: " + this.volume_environment);
      file.println("volume_environment_muted: " + this.volume_environment_muted);
      file.println("volume_units: " + this.volume_units);
      file.println("volume_units_muted: " + this.volume_units_muted);
      file.println("volume_player: " + this.volume_player);
      file.println("volume_player_muted: " + this.volume_player_muted);
      file.println("map_viewMoveSpeedFactor: " + this.map_viewMoveSpeedFactor);
      file.flush();
      file.close();
    }
  }



  class PlayerTree {
    class PlayerTreeNode {
      class PlayerTreeNodeButton1 extends RectangleButton {
        PlayerTreeNodeButton1(float xi, float yi, float button_height) {
          super(xi, yi, xi + 4 * button_height, yi + button_height);
          this.show_message = true;
        }

        void hover() {}
        void dehover() {}
        void click() {}
        void release() {}
      }

      class PlayerTreeNodeButton2 extends CircleButton {
        PlayerTreeNodeButton2(float xi, float yi, float button_height) {
          super(xi + 0.5 * button_height, yi + 0.5 * button_height, 0.5 * button_height);
          this.show_message = true;
        }

        void hover() {}
        void dehover() {}
        void click() {}
        void release() {}
      }

      protected PlayerTreeCode code;
      protected ArrayList<PlayerTreeCode> dependencies = new ArrayList<PlayerTreeCode>();
      protected boolean in_view = false;
      protected boolean visible = false;
      protected boolean unlocked = false;
      protected PlayerTreeNodeButton1 button1;
      protected PlayerTreeNodeButton2 button2;

      PlayerTreeNode(PlayerTreeCode code, float xi, float yi, float button_height) {
        this.code = code;
        this.button1 = new PlayerTreeNodeButton1(xi, yi, button_height);
        this.button2 = new PlayerTreeNodeButton2(xi, yi, button_height);
      }

      void setDependencies() {
        switch(this.code) {
          case CAN_PLAY:
            break;
          default:
            global.errorMessage("ERROR: PlayerTreeCode " + this.code + " not recognized.");
            break;
        }
      }

      void visible() {
        this.visible = true;
      }

      void unlock() {
        this.unlocked = true;
      }


      void update(int millis) {
        this.button1.update(millis);
        this.button2.update(millis);
      }

      void mouseMove(float mX, float mY) {
        this.button1.mouseMove(mX, mY);
        this.button2.mouseMove(mX, mY);
      }

      boolean hovered() {
        return this.button1.hovered || this.button2.hovered;
      }

      void mousePress() {
        this.button1.mousePress();
        this.button2.mousePress();
      }

      void mouseRelease(float mX, float mY) {
        this.button1.mouseRelease(mX, mY);
        this.button2.mouseRelease(mX, mY);
      }
    }


    class NodeDetailsForm extends Form {
      protected boolean canceled = false;
      protected PlayerTreeNode node;
      protected float shadow_distance = 10;
      protected PImage img;

      NodeDetailsForm(PlayerTreeNode node) {
        super(0.5 * (width - Constants.profile_treeForm_width), 0.5 * (height - Constants.profile_treeForm_height),
          0.5 * (width + Constants.profile_treeForm_width), 0.5 * (height + Constants.profile_treeForm_height));
        this.img = getCurrImage();
        this.cancelButton();
        this.draggable = false;
        this.node = node;
      }

      void cancel() {
        this.canceled = true;
      }

      void submit() {
        // try unlock node
        this.canceled = true;
      }

      void buttonPress(int index) {}
    }


    class BackButton extends RectangleButton {
      BackButton() {
        super(0, 0, 0, 0);
        this.setColors(color(170), color(1, 0), color(40, 120), color(20, 150), color(255));
        this.noStroke();
        this.show_message = true;
        this.message = "Back";
        this.text_size = 18;
        this.adjust_for_text_descent = true;
      }

      void hover() {}
      void dehover() {}
      void click() {}
      void release() {
        if (this.hovered) {
          PlayerTree.this.curr_viewing = false;
        }
      }
    }


    protected float xi = 0;
    protected float yi = 0;
    protected float xf = 0;
    protected float yf = 0;
    protected float xCenter = 0.5 * width;
    protected float yCenter = 0.5 * height;

    protected float tree_xi = 0;
    protected float tree_yi = 0;
    protected float tree_xf = 0;
    protected float tree_yf = 0;
    protected float translateX = 0;
    protected float translateY = 0;

    protected float viewX = 0;
    protected float viewY = 0;
    protected float zoom = 1.0;
    protected float inverse_zoom = 1.0;
    protected boolean curr_viewing = false;

    protected boolean dragging = false;
    protected float last_mX = mouseX;
    protected float last_mY = mouseY;
    protected boolean hovered = false;

    protected float lowestX = 0;
    protected float lowestY = 0;
    protected float highestX = 0;
    protected float highestY = 0;

    protected color color_background = color(30);

    protected HashMap<PlayerTreeCode, PlayerTreeNode> nodes = new HashMap<PlayerTreeCode, PlayerTreeNode>();
    protected NodeDetailsForm node_details = null;
    protected BackButton back_button = new BackButton();


    PlayerTree() {
      this.initializeNodes();
      this.updateDependencies();
      this.setView(0, 0);
    }


    void initializeNodes() {
      for (PlayerTreeCode code : PlayerTreeCode.VALUES) {
        switch(code) {
          case CAN_PLAY:
            break;
          default:
            global.errorMessage("ERROR: PlayerTreeCode " + code + " not recognized.");
            break;
        }
      }
    }


    void updateDependencies() {
      for (Map.Entry<PlayerTreeCode, PlayerTreeNode> entry : this.nodes.entrySet()) {
        if (entry.getValue().visible) {
          continue;
        }
        boolean visible = true;
        for (PlayerTreeCode code : entry.getValue().dependencies) {
          if (!this.nodes.get(code).unlocked) {
            visible = false;
            break;
          }
        }
        if (visible) {
          entry.getValue().visible();
        }
      }
    }


    void setLocation(float xi, float yi, float xf, float yf) {
      this.xi = xi;
      this.yi = yi;
      this.xf = xf;
      this.yf = yf;
      this.setView(this.viewX, this.viewY);
      this.back_button.setLocation(xf - 120, yf - 70, xf - 30, yf - 30);
    }

    void moveView(float moveX, float moveY) {
      this.setView(this.viewX + moveX, this.viewY + moveY);
    }
    void setView(float viewX, float viewY) {
      if (viewX < this.lowestX) {
        viewX = this.lowestX;
      }
      else if (viewX > this.highestX) {
        viewX = this.highestX;
      }
      if (viewY < this.lowestY) {
        viewY = this.lowestY;
      }
      else if (viewY > this.highestY) {
        viewY = this.highestY;
      }
      this.viewX = viewX;
      this.viewY = viewY;
      this.tree_xi = viewX - this.inverse_zoom * (this.xCenter - this.xi);
      this.tree_yi = viewY - this.inverse_zoom * (this.yCenter - this.yi);
      this.tree_xf = viewX - this.inverse_zoom * (this.xCenter - this.xf);
      this.tree_yf = viewY - this.inverse_zoom * (this.yCenter - this.yf);
      this.translateX = this.xCenter - this.zoom * viewX;
      this.translateY = this.yCenter - this.zoom * viewY;
      for (Map.Entry<PlayerTreeCode, PlayerTreeNode> entry : this.nodes.entrySet()) {
        if (entry.getValue().button1.xi > this.tree_xi && entry.getValue().button1.yi > this.tree_yi &&
          entry.getValue().button1.xf < this.tree_xf && entry.getValue().button1.yf < this.tree_yf) {
          entry.getValue().in_view = true;
        }
        else {
          entry.getValue().in_view = false;
        }
      }
    }


    String shortMessage(PlayerTreeCode code) {
      switch(code) {
        case CAN_PLAY:
          return "";
        default:
          global.errorMessage("ERROR: PlayerTreeCode " + code + " not recognized.");
          return "";
      }
    }

    String longMessage(PlayerTreeCode code) {
      switch(code) {
        case CAN_PLAY:
          return "";
        default:
          global.errorMessage("ERROR: PlayerTreeCode " + code + " not recognized.");
          return "";
      }
    }

    String name(PlayerTreeCode code) {
      switch(code) {
        case CAN_PLAY:
          return "";
        default:
          global.errorMessage("ERROR: PlayerTreeCode " + code + " not recognized.");
          return "";
      }
    }

    String description(PlayerTreeCode code) {
      switch(code) {
        case CAN_PLAY:
          return "";
        default:
          global.errorMessage("ERROR: PlayerTreeCode " + code + " not recognized.");
          return "";
      }
    }

    int cost(PlayerTreeCode code) {
      switch(code) {
        case CAN_PLAY:
          return 1;
        default:
          global.errorMessage("ERROR: PlayerTreeCode " + code + " not recognized.");
          return 0;
      }
    }


    void update(int millis) {
      if (this.node_details != null) {
        this.node_details.update(millis);
        if (this.node_details.canceled) {
          this.node_details = null;
        }
        return;
      }
      rectMode(CORNERS);
      fill(this.color_background);
      noStroke();
      rect(this.xi, this.yi, this.xf, this.yf);
      translate(this.translateX, this.translateY);
      scale(this.zoom, this.zoom);
      for (Map.Entry<PlayerTreeCode, PlayerTreeNode> entry : this.nodes.entrySet()) {
        rectMode(CORNERS);
        translate(entry.getValue().button1.xCenter(), entry.getValue().button1.yCenter());
        for (PlayerTreeCode dependency : entry.getValue().dependencies) {
          PlayerTreeNode dependent = this.nodes.get(dependency);
          strokeWeight(2);
          float connector_width = 6;
          if (entry.getValue().unlocked) {
            //fill(this.color_connectorFill_unlocked);
            //stroke(this.color_connectorStroke_unlocked);
            strokeWeight(4);
            connector_width = 10;
          }
          else if (entry.getValue().visible || dependent.unlocked) {
            //fill(this.color_connectorFill_visible);
            //stroke(this.color_connectorStroke_visible);
            strokeWeight(3);
            connector_width = 8;
          }
          else {
            //fill(this.color_connectorFill_locked);
            //stroke(this.color_connectorStroke_locked);
          }
          float xDif = dependent.button1.xCenter() - entry.getValue().button1.xCenter();
          float yDif = dependent.button1.yCenter() - entry.getValue().button1.yCenter();
          float rotation = (float)Math.atan2(yDif, xDif);
          float distance = sqrt(xDif * xDif + yDif * yDif);
          rotate(rotation);
          //rect(0, -connector_width, distance, connector_width);
          rotate(-rotation);
        }
        translate(-entry.getValue().button1.xCenter(), -entry.getValue().button1.yCenter());
      }
      for (Map.Entry<PlayerTreeCode, PlayerTreeNode> entry : this.nodes.entrySet()) {
        if (entry.getValue().in_view) {
          entry.getValue().update(millis);
        }
      }
      scale(this.inverse_zoom, this.inverse_zoom);
      translate(-this.translateX, -this.translateY);
      this.back_button.update(millis);
    }

    void mouseMove(float mX, float mY) {
      if (this.node_details != null) {
        this.node_details.mouseMove(mX, mY);
        return;
      }
      this.back_button.mouseMove(mX, mY);
      if (this.dragging) {
        this.moveView(this.inverse_zoom * (this.last_mX - mX), this.inverse_zoom * (this.last_mY - mY));
      }
      this.last_mX = mX;
      this.last_mY = mY;
      if (mX > this.xi && mY > this.yi && mX < this.xf && mY < this.yf) {
        this.hovered = true;
      }
      else {
        this.hovered = false;
      }
      mX -= this.translateX;
      mY -= this.translateY;
      mX *= this.inverse_zoom;
      mY *= this.inverse_zoom;
      for (Map.Entry<PlayerTreeCode, PlayerTreeNode> entry : this.nodes.entrySet()) {
        if (entry.getValue().in_view) {
          entry.getValue().mouseMove(mX, mY);
        }
      }
    }

    void mousePress() {
      if (this.node_details != null) {
        this.node_details.mousePress();
        return;
      }
      this.back_button.mousePress();
      boolean button_hovered = false;
      for (Map.Entry<PlayerTreeCode, PlayerTreeNode> entry : this.nodes.entrySet()) {
        if (entry.getValue().in_view) {
          entry.getValue().mousePress();
          if (entry.getValue().hovered()) {
            button_hovered = true;
          }
        }
      }
      if (!button_hovered && mouseButton == LEFT && this.hovered) {
        this.dragging = true;
      }
    }

    void mouseRelease(float mX, float mY) {
      if (this.node_details != null) {
        this.node_details.mouseRelease(mX, mY);
        return;
      }
      this.back_button.mouseRelease(mX, mY);
      if (mouseButton == LEFT) {
        this.dragging = false;
      }
      mX -= this.translateX;
      mY -= this.translateY;
      for (Map.Entry<PlayerTreeCode, PlayerTreeNode> entry : this.nodes.entrySet()) {
        if (entry.getValue().in_view) {
          entry.getValue().mouseRelease(mX, mY);
        }
      }
    }

    void scroll(int amount) {
      if (this.node_details != null) {
        this.node_details.scroll(amount);
        return;
      }
      this.zoom -= amount * 0.01;
      if (this.zoom < 0.5) {
        this.zoom = 0.5;
      }
      if (this.zoom > 1.5) {
        this.zoom = 1.5;
      }
      this.inverse_zoom = 1 / this.zoom;
      this.setView(this.viewX, this.viewY);
    }

    void keyPress() {
      if (this.node_details != null) {
        this.node_details.keyPress();
        return;
      }
      if (key == ESC) {
        this.curr_viewing = false;
      }
    }

    void keyRelease() {
      if (this.node_details != null) {
        this.node_details.keyRelease();
        return;
      }
    }
  }



  private String display_name = "";

  private HashMap<AchievementCode, Boolean> achievements = new HashMap<AchievementCode, Boolean>();
  private int achievement_tokens = 0;
  private PlayerTree player_tree = new PlayerTree();
  private Options options;

  private HashMap<HeroCode, Hero> heroes = new HashMap<HeroCode, Hero>(); // maybe remove ??
  private HeroCode curr_hero = HeroCode.ERROR; // hero the player is playing as

  private EnderChestInventory ender_chest = new EnderChestInventory();
  private float money = 0;

  Profile() {
    this("");
  }
  Profile(String s) {
    this.display_name = s;
    for (AchievementCode code : AchievementCode.VALUES) {
      this.achievements.put(code, false);
    }
    this.options = new Options();
  }

  boolean invalidProfile() {
    String name = this.display_name.toLowerCase();
    return name == null || name.equals("") || !folderExists("data/profiles/" + name);
  }

  void profileUpdated() {
    this.options.profileUpdated();
    this.save();
  }

  void achievement(AchievementCode code) {
    if (this.achievements.get(code).equals(Boolean.FALSE)) {
      //this.achievements.put(code, Boolean.TRUE);
      this.achievement_tokens += code.tokens();
      this.save();
      global.notification = new AchievementNotification(code);
    }
  }

  void save() {
    PrintWriter file = createWriter(sketchPath("data/profiles/" + this.display_name.toLowerCase() + "/profile.lnz"));
    file.println("display_name: " + this.display_name);
    for (AchievementCode code : AchievementCode.VALUES) {
      if (this.achievements.get(code).equals(Boolean.TRUE)) {
        file.println("achievement: " + code.file_name());
      }
    }
    file.println("achievement_tokens: " + this.achievement_tokens);
    // println heroes
    file.println("curr_hero: " + this.curr_hero.file_name());
    file.println("money: " + this.money);
    file.println(this.ender_chest.internalFileString());
    file.flush();
    file.close();
    this.options.save();
  }
}


Profile readProfile(String path) {
  String[] lines = loadStrings(path);
  Profile p = new Profile();
  Item curr_item = null;
  boolean in_item = false;
  if (lines == null) {
    global.errorMessage("ERROR: Reading profile file but path " + path + " doesn't exist.");
    return p;
  }
  for (String line : lines) {
    String[] data = split(line, ':');
    if (data.length < 2) {
      continue;
    }
    switch(data[0]) {
      case "display_name":
        p.display_name = trim(data[1]);
        break;
      case "achievement":
        AchievementCode code = AchievementCode.achievementCode(trim(data[1]));
        if (code != null) {
          p.achievements.put(code, Boolean.TRUE);
        }
        break;
      case "achievement_tokens":
        if (isInt(trim(data[1]))) {
          p.achievement_tokens = toInt(trim(data[1]));
        }
        break;
      case "curr_hero":
        p.curr_hero = HeroCode.heroCode(trim(data[1]));
        break;
      case "money":
        if (isFloat(trim(data[1]))) {
          p.money = toFloat(trim(data[1]));
        }
        break;
      case "new":
        switch(trim(data[1])) {
          case "Item":
            if (data.length < 3) {
              global.errorMessage("ERROR: Item ID missing in Item constructor.");
              break;
            }
            if (curr_item != null) {
              global.errorMessage("ERROR: Can't create a new Item inside an Item.");
              break;
            }
            curr_item = new Item(toInt(trim(data[2])));
            in_item = true;
            break;
          default:
            global.errorMessage("ERROR: Trying to create a new " + trim(data[1]) +
              " which is invalid for profile data.");
            break;
        }
        break;
      case "end":
        switch(trim(data[1])) {
          case "Item":
            if (curr_item == null) {
              global.errorMessage("ERROR: Can't end a null Item.");
              break;
            }
            if (data.length < 3) {
              global.errorMessage("ERROR: No positional information for ender chest item.");
              break;
            }
            int index = toInt(trim(data[2]));
            Item i = p.ender_chest.placeAt(curr_item, index, true);
            if (i != null) {
              global.errorMessage("ERROR: Item already exists at position " + index + ".");
              break;
            }
            curr_item = null;
            in_item = false;
            break;
          default:
            global.errorMessage("ERROR: Trying to create a new " + trim(data[1]) +
              " which is invalid for profile data.");
            break;
        }
        break;
      default:
        if (in_item) {
          curr_item.addData(trim(data[0]), trim(data[1]));
          continue;
        }
        break;
    }
  }
  p.profileUpdated();
  return p;
}


int isValidProfileName(String s) {
  if (s == null) {
    return 1;
  }
  else if (s.equals("")) {
    return 1;
  }
  for (int i = 0; i < s.length(); i++) {
    char c = s.charAt(i);
    if (i == 0 && !Character.isLetter(c)) {
      return 2;
    }
    else if (!Character.isLetterOrDigit(c)) {
      return 3;
    }
  }
  for (Path p : listEntries(sketchPath("data/profiles/"))) {
    String filename = p.getFileName().toString().toLowerCase();
    if (filename.equals(s.toLowerCase())) {
      return 4;
    }
  }
  return 0;
}
