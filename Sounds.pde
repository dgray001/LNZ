class Sounds {
  private Minim minim;
  private AudioOutput out_interface;
  private HashMap<String, Sampler> sounds_interface = new HashMap<String, Sampler>();
  private String basePath = sketchPath("data/sounds/");

  Sounds(LNZ thisInstance) {
    this.minim = new Minim(thisInstance);
    this.out_interface = this.minim.getLineOut();
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
