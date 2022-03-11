enum HeroCode {
  ERROR, BEN;

  private static final List<HeroCode> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  public String display_name() {
    return HeroCode.display_name(this);
  }
  static public String display_name(Achievement a) {
    switch(a) {
      case BEN:
        return "Ben Nelson";
      default:
        return "-- Error --";
    }
  }

  static public HeroCode heroCode(String display_name) {
    for (HeroCode code : HeroCode.VALUES) {
      if (code == HeroCode.ERROR) {
        continue;
      }
      if (HeroCode.display_name(code).equals(display_name)) {
        return code;
      }
    }
    return ERROR;
  }
}



class Hero {
  protected HeroCode code;

  protected Location location;

  protected int hunger = 100;
  protected int thirst = 100;
}
