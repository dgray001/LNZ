enum AchievementCode {
  COMPLETED_TUTORIAL;

  private static final List<AchievementCode> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  public String display_name() {
    return AchievementCode.display_name(this);
  }
  public static String display_name(AchievementCode code) {
    switch(code) {
      case COMPLETED_TUTORIAL:
        return "Completed Tutorial";
      default:
        return "-- Error --";
    }
  }

  public String file_name() {
    return AchievementCode.file_name(this);
  }
  static public String file_name(AchievementCode code) {
    switch(code) {
      case COMPLETED_TUTORIAL:
        return "Completed_Tutorial";
      default:
        return "ERROR";
    }
  }

  public static AchievementCode achievementCode(String display_name) {
    for (AchievementCode code : AchievementCode.VALUES) {
      if (AchievementCode.display_name(code).equals(display_name) ||
        AchievementCode.file_name(code).equals(display_name)) {
        return code;
      }
    }
    return null;
  }

  public int tokens() {
    return AchievementCode.tokens(this);
  }
  public static int tokens(AchievementCode code) {
    switch(code) {
      case COMPLETED_TUTORIAL:
        return 1;
      default:
        return 0;
    }
  }
}
