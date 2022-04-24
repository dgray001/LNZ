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
      protected PlayerTreeCode code;
      protected ArrayList<PlayerTreeCode> dependencies = new ArrayList<PlayerTreeCode>();
      protected boolean in_view = false;
      protected boolean visible = false;
      protected boolean unlocked = false;

      PlayerTreeNode(PlayerTreeCode code) {
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

    protected HashMap<PlayerTreeCode, PlayerTreeNode> nodes = new HashMap<PlayerTreeCode, PlayerTreeNode>();
    protected NodeDetailsForm node_details = null;


    PlayerTree() {
      this.initializeNodes();
      //this.updateDependencies();
      //this.setView(0, 0);
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
  }



  private String display_name = "";

  private HashMap<AchievementCode, Boolean> achievements = new HashMap<AchievementCode, Boolean>();
  private int achievement_tokens = 0;
  private Options options;

  private HashMap<HeroCode, Hero> heroes = new HashMap<HeroCode, Hero>(); // maybe remove ??
  private HeroCode curr_hero = HeroCode.ERROR; // hero the player is playing as
  private Level curr_level; // level the player is playing

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
    file.flush();
    file.close();
    // this.curr_level.save()
    this.options.save();
  }
}


Profile readProfile(String path) {
  String[] lines = loadStrings(path);
  Profile p = new Profile();
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
      default:
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
