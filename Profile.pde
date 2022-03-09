class Profile {
  class Options {
    private float volume_music;
    private float volume_interface;
    private float volume_environment;
    private float volume_units;
    private float volume_player;

    Options() {
      this.profileUpdated();
    }

    void profileUpdated() {
      this.defaults();
      this.read();
      this.change();
    }

    void defaults() {
      this.volume_music = Constants.options_defaultVolume;
      this.volume_interface = Constants.options_defaultVolume;
      this.volume_environment = Constants.options_defaultVolume;
      this.volume_units = Constants.options_defaultVolume;
      this.volume_player = Constants.options_defaultVolume;
    }

    void change() {
      if (Profile.this.invalidProfile()) {
        return;
      }
      global.sounds.setBackgroundGain(this.volume_music + Constants.options_volumeGainAdjustment);
      global.sounds.out_interface.setGain(this.volume_interface + Constants.options_volumeGainAdjustment);
      global.sounds.out_environment.setGain(this.volume_environment + Constants.options_volumeGainAdjustment);
      global.sounds.out_units.setGain(this.volume_units + Constants.options_volumeGainAdjustment);
      global.sounds.out_player.setGain(this.volume_player + Constants.options_volumeGainAdjustment);
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
          case "volume_music":
            this.volume_music = toFloat(trim(data[1]));
            break;
          case "volume_interface":
            this.volume_interface = toFloat(trim(data[1]));
            break;
          case "volume_environment":
            this.volume_environment = toFloat(trim(data[1]));
            break;
          case "volume_units":
            this.volume_units = toFloat(trim(data[1]));
            break;
          case "volume_player":
            this.volume_player = toFloat(trim(data[1]));
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
      file.println("volume_music: " + this.volume_music);
      file.println("volume_interface: " + this.volume_interface);
      file.println("volume_environment: " + this.volume_environment);
      file.println("volume_units: " + this.volume_units);
      file.println("volume_player: " + this.volume_player);
      file.flush();
      file.close();
    }
  }

  private String display_name = "";
  private HashMap<Achievement, Boolean> achievements = new HashMap<Achievement, Boolean>();
  private int achievement_tokens = 0;
  private Options options;

  Profile() {
    this("");
  }
  Profile(String s) {
    this.display_name = s;
    for (Achievement a : Achievement.VALUES) {
      this.achievements.put(a, false);
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

  void save() {
    PrintWriter file = createWriter(sketchPath("data/profiles/" + this.display_name.toLowerCase() + "/profile.lnz"));
    file.println("display_name: " + this.display_name);
    for (Achievement a : Achievement.VALUES) {
      if (this.achievements.get(a)) {
        file.println("achievement: " + a.display_name());
      }
    }
    file.println("achievement_tokens: " + this.achievement_tokens);
    file.flush();
    file.close();
    this.options.save();
  }
}


Profile readProfile(String path) {
  String[] lines = loadStrings(path);
  Profile p = new Profile();
  if (lines == null) {
    println("ERROR: Reading profile file but path " + path + " doesn't exist.");
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
        for (Achievement a : Achievement.VALUES) {
          if (a.display_name().equals(trim(data[1]))) {
            p.achievements.put(a, true);
            break;
          }
        }
        break;
      case "achievement_tokens":
        if (isInt(trim(data[1]))) {
          p.achievement_tokens = toInt(trim(data[1]));
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
