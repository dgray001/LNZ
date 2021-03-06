class Sounds {
  private Minim minim;

  private AudioPlayer background_track;
  private float volume_background = 0;
  private boolean muted_background = false;
  private boolean playing_background = false;
  private boolean loop_background = true;
  private String album_name = "";
  private int track_number = 1;

  private AudioOutput out_interface;
  private HashMap<String, Sampler> sounds_interface = new HashMap<String, Sampler>();
  private AudioOutput out_environment;
  private HashMap<String, Sampler> sounds_environment = new HashMap<String, Sampler>();
  private AudioOutput out_units;
  private HashMap<String, Sampler> sounds_units = new HashMap<String, Sampler>();
  private AudioOutput out_player;
  private HashMap<String, Sampler> sounds_player = new HashMap<String, Sampler>();

  private String basePath = sketchPath("data/sounds/");

  Sounds(LNZ thisInstance) {
    this.minim = new Minim(thisInstance);
    this.out_interface = this.minim.getLineOut();
    this.out_environment = this.minim.getLineOut();
    this.out_units = this.minim.getLineOut();
    this.out_player = this.minim.getLineOut();
  }

  void play_background(String album_name) {
    this.play_background(album_name, true);
  }
  void play_background(String album_name, boolean loop_background) {
    if (this.album_name.equals(album_name)) {
      return;
    }
    this.stop_background();
    this.playing_background = true;
    this.loop_background = loop_background;
    this.album_name = album_name;
    this.track_number = 0;
  }

  void stop_background() {
    if (this.background_track != null) {
      this.background_track.pause();
      this.background_track.close();
      this.background_track = null;
    }
  }

  void pause_background() {
    if (this.background_track != null) {
      this.background_track.pause();
    }
  }

  void resume_background() {
    if (this.background_track != null) {
      this.background_track.play();
    }
  }

  void setBackgroundVolume(float volume, boolean muted) {
    this.volume_background = volume;
    this.muted_background = muted;
    if (this.background_track != null) {
      this.background_track.setGain(volume);
      if (this.muted_background) {
        this.background_track.mute();
      }
      else {
        this.background_track.unmute();
      }
    }
  }

  void update() {
    if (this.playing_background) {
      if (this.background_track == null || !this.background_track.isPlaying()) {
        this.track_number++;
        String track_path = "data/sounds/background/" + this.album_name + this.track_number + ".wav";
        if (fileExists(track_path)) {
          this.background_track = minim.loadFile(track_path);
          this.background_track.play();
          this.setBackgroundVolume(this.volume_background, this.muted_background);
        }
        else if (this.loop_background) {
          this.track_number = 0;
        }
        else {
          this.playing_background = false;
        }
      }
    }
  }

  void trigger_interface(String soundPath) {
    if (this.sounds_interface.containsKey(soundPath)) {
      this.sounds_interface.get(soundPath).trigger();
    }
    else {
      String filePath = this.basePath + soundPath + ".wav";
      File f = new File(filePath);
      if (f.exists()) {
        Sampler s = new Sampler(filePath, 2, this.minim);
        s.patch(this.out_interface);
        this.sounds_interface.put(soundPath, s);
        s.trigger();
      }
      else {
        global.log("Sounds: Missing interface sound " + filePath + ".");
      }
    }
  }
  void silence_interface(String soundPath) {
    if (this.sounds_interface.containsKey(soundPath)) {
      this.sounds_interface.get(soundPath).stop();
    }
  }

  void trigger_environment(String soundPath) {
    this.trigger_environment(soundPath, 0, 0);
  }
  void trigger_environment(String soundPath, float xDif, float yDif) {
    float distance = sqrt(xDif * xDif + yDif * yDif);
    if (distance > Constants.map_defaultMaxSoundDistance) {
      return;
    }
    if (this.sounds_environment.containsKey(soundPath)) {
      this.sounds_environment.get(soundPath).trigger();
    }
    else {
      String filePath = this.basePath + soundPath + ".wav";
      File f = new File(filePath);
      if (f.exists()) {
        Sampler s = new Sampler(filePath, 2, this.minim);
        s.patch(this.out_environment);
        this.sounds_environment.put(soundPath, s);
        s.trigger();
      }
      else {
        global.log("Sounds: Missing environment sound " + filePath + ".");
      }
    }
  }
  void silence_environment(String soundPath) {
    if (this.sounds_environment.containsKey(soundPath)) {
      this.sounds_environment.get(soundPath).stop();
    }
  }

  void trigger_units(String soundPath) {
    this.trigger_units(soundPath, 0, 0);
  }
  void trigger_units(String soundPath, float xDif, float yDif) {
    float distance = sqrt(xDif * xDif + yDif * yDif);
    if (distance > Constants.map_defaultMaxSoundDistance) {
      return;
    }
    if (this.sounds_units.containsKey(soundPath)) {
      this.sounds_units.get(soundPath).trigger();
    }
    else {
      String filePath = this.basePath + soundPath + ".wav";
      File f = new File(filePath);
      if (f.exists()) {
        Sampler s = new Sampler(filePath, 2, this.minim);
        s.patch(this.out_units);
        this.sounds_units.put(soundPath, s);
        s.trigger();
      }
      else {
        global.log("Sounds: Missing units sound " + filePath + ".");
      }
    }
  }
  void silence_units(String soundPath) {
    if (this.sounds_units.containsKey(soundPath)) {
      this.sounds_units.get(soundPath).stop();
    }
  }

  void trigger_player(String soundPath) {
    this.trigger_player(soundPath, 0, 0);
  }
  void trigger_player(String soundPath, float xDif, float yDif) {
    float distance = sqrt(xDif * xDif + yDif * yDif);
    if (distance > Constants.map_defaultMaxSoundDistance) {
      return;
    }
    if (this.sounds_player.containsKey(soundPath)) {
      this.sounds_player.get(soundPath).trigger();
    }
    else {
      String filePath = this.basePath + soundPath + ".wav";
      File f = new File(filePath);
      if (f.exists()) {
        Sampler s = new Sampler(filePath, 2, this.minim);
        s.patch(this.out_player);
        this.sounds_player.put(soundPath, s);
        s.trigger();
      }
      else {
        global.log("Sounds: Missing player sound " + filePath + ".");
      }
    }
  }
  void silence_player(String soundPath) {
    if (this.sounds_player.containsKey(soundPath)) {
      this.sounds_player.get(soundPath).stop();
    }
  }
}
