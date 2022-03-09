class Sounds {
  private Minim minim;

  private AudioPlayer background_track;
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
  }

  void play_background(String album_name) {
    this.play_background(album_name, true);
  }
  void play_background(String album_name, boolean loop_background) {
    if (this.album_name.equals(album_name)) {
      return;
    }
    this.background_track = null;
    this.playing_background = true;
    this.loop_background = loop_background;
    this.album_name = album_name;
    this.track_number = 0;
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

  void update() {
    if (this.playing_background) {
      if (this.background_track == null || !this.background_track.isPlaying()) {
        this.track_number++;
        String track_path = "data/sounds/background/" + this.album_name + this.track_number + ".wav";
        if (fileExists(track_path)) {
          this.background_track = minim.loadFile(track_path);
          this.background_track.play();
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
        println("ERROR: Missing sound " + filePath + ".");
      }
    }
  }
}
