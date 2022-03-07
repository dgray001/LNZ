enum Achievement {
  TEST;

  private static final List<Achievement> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  public String display_name() {
    return Achievement.display_name(this);
  }
  static public String display_name(Achievement a) {
    switch(a) {
      case TEST:
        return "Test";
      default:
        return "-- Error --";
    }
  }

  public int tokens() {
    return Achievement.tokens(this);
  }
  static public int tokens(Achievement a) {
    switch(a) {
      case TEST:
        return 1;
      default:
        return 0;
    }
  }
}
