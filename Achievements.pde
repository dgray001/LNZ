enum AchievementCode {
  COMPLETED_TUTORIAL, KILLED_JOHN_RANKIN;

  private static final List<AchievementCode> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  public String display_name() {
    return AchievementCode.display_name(this);
  }
  public static String display_name(AchievementCode code) {
    switch(code) {
      case COMPLETED_TUTORIAL:
        return "Completed Tutorial";
      case KILLED_JOHN_RANKIN:
        return "Killed John Rankin";
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
      case KILLED_JOHN_RANKIN:
        return "Killed_John_Rankin";
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
  public static AchievementCode achievementCode(int id) {
    for (AchievementCode code : AchievementCode.VALUES) {
      if (AchievementCode.id(code) == id) {
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
      default:
        return 1;
    }
  }

  public int id() {
    return AchievementCode.id(this);
  }
  public static int id(AchievementCode code) {
    switch(code) {
      case COMPLETED_TUTORIAL:
        return 0;
      case KILLED_JOHN_RANKIN:
        return 1;
      default:
        return -1;
    }
  }
}
