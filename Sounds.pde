class Sounds {
  private Minim minim;
  private AudioOutput out;
  private HashMap<String, Sampler> soundEffects = new HashMap<String, Sampler>();
  private String basePath = sketchPath("data/sounds/");

  Sounds(LNZ thisInstance) {
    this.minim = new Minim(thisInstance);
    this.out = this.minim.getLineOut();
  }

  void trigger(String soundPath) {
    if (this.soundEffects.containsKey(soundPath)) {
      this.soundEffects.get(soundPath).trigger();
    }
    else {
      String filePath = this.basePath + soundPath + ".wav";
      File f = new File(filePath);
      if (f.exists()) {
        Sampler s = new Sampler(filePath, 2, this.minim);
        s.patch(this.out);
        this.soundEffects.put(soundPath, s);
        s.trigger();
      }
      else {
        println("ERROR: Missing sound " + filePath + ".");
      }
    }
  }
}