enum AchievementCode {
  COMPLETED_TUTORIAL, COMPLETED_FRANCISCAN, COMPLETED_DANSHOUSE,

  CONTINUOUS_KILLSI, CONTINUOUS_KILLSII, CONTINUOUS_KILLSIII, CONTINUOUS_KILLSIV, CONTINUOUS_KILLSV,
  CONTINUOUS_KILLSVI, CONTINUOUS_KILLSVII, CONTINUOUS_KILLSVIII, CONTINUOUS_KILLSIX, CONTINUOUS_KILLSX,

  CONTINUOUS_DEATHSI, CONTINUOUS_DEATHSII, CONTINUOUS_DEATHSIII, CONTINUOUS_DEATHSIV, CONTINUOUS_DEATHSV,
  CONTINUOUS_DEATHSVI, CONTINUOUS_DEATHSVII, CONTINUOUS_DEATHSVIII, CONTINUOUS_DEATHSIX, CONTINUOUS_DEATHSX,

  CONTINUOUS_WALKI, CONTINUOUS_WALKII, CONTINUOUS_WALKIII, CONTINUOUS_WALKIV, CONTINUOUS_WALKV,
  CONTINUOUS_WALKVI, CONTINUOUS_WALKVII, CONTINUOUS_WALKVIII, CONTINUOUS_WALKIX, CONTINUOUS_WALKX,

  KILLED_JOHN_RANKIN,
  ;

  private static final List<AchievementCode> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  public String display_name() {
    return AchievementCode.display_name(this);
  }
  public static String display_name(AchievementCode code) {
    switch(code) {
      // completion
      case COMPLETED_TUTORIAL:
        return "Completed Tutorial";
      case COMPLETED_FRANCISCAN:
        return "Completed Francisan University Campaign";
      case COMPLETED_DANSHOUSE:
        return "Completed Water Works Rd Campaign";
      // continuous
      case CONTINUOUS_KILLSI:
        return "Killed " + Constants.achievement_kills_I + " units";
      case CONTINUOUS_KILLSII:
        return "Killed " + Constants.achievement_kills_II + " units";
      case CONTINUOUS_KILLSIII:
        return "Killed " + Constants.achievement_kills_III + " units";
      case CONTINUOUS_KILLSIV:
        return "Killed " + Constants.achievement_kills_IV + " units";
      case CONTINUOUS_KILLSV:
        return "Killed " + Constants.achievement_kills_V + " units";
      case CONTINUOUS_KILLSVI:
        return "Killed " + Constants.achievement_kills_VI + " units";
      case CONTINUOUS_KILLSVII:
        return "Killed " + Constants.achievement_kills_VII + " units";
      case CONTINUOUS_KILLSVIII:
        return "Killed " + Constants.achievement_kills_VIII + " units";
      case CONTINUOUS_KILLSIX:
        return "Killed " + Constants.achievement_kills_IX + " units";
      case CONTINUOUS_KILLSX:
        return "Killed " + Constants.achievement_kills_X + " units";
      case CONTINUOUS_DEATHSI:
        return "Died " + Constants.achievement_deaths_I + " times";
      case CONTINUOUS_DEATHSII:
        return "Died " + Constants.achievement_deaths_II + " times";
      case CONTINUOUS_DEATHSIII:
        return "Died " + Constants.achievement_deaths_III + " times";
      case CONTINUOUS_DEATHSIV:
        return "Died " + Constants.achievement_deaths_IV + " times";
      case CONTINUOUS_DEATHSV:
        return "Died " + Constants.achievement_deaths_V + " times";
      case CONTINUOUS_DEATHSVI:
        return "Died " + Constants.achievement_deaths_VI + " times";
      case CONTINUOUS_DEATHSVII:
        return "Died " + Constants.achievement_deaths_VII + " times";
      case CONTINUOUS_DEATHSVIII:
        return "Died " + Constants.achievement_deaths_VIII + " times";
      case CONTINUOUS_DEATHSIX:
        return "Died " + Constants.achievement_deaths_IX + " times";
      case CONTINUOUS_DEATHSX:
        return "Died " + Constants.achievement_deaths_X + " times";
      case CONTINUOUS_WALKI:
        return "Walked " + Constants.achievement_walk_I + " m";
      case CONTINUOUS_WALKII:
        return "Walked " + Constants.achievement_walk_II + " m";
      case CONTINUOUS_WALKIII:
        return "Walked " + Constants.achievement_walk_III + " m";
      case CONTINUOUS_WALKIV:
        return "Walked " + Constants.achievement_walk_IV + " m";
      case CONTINUOUS_WALKV:
        return "Walked " + Constants.achievement_walk_V + " m";
      case CONTINUOUS_WALKVI:
        return "Walked " + Constants.achievement_walk_VI + " m";
      case CONTINUOUS_WALKVII:
        return "Walked " + Constants.achievement_walk_VII + " m";
      case CONTINUOUS_WALKVIII:
        return "Walked " + Constants.achievement_walk_VIII + " m";
      case CONTINUOUS_WALKIX:
        return "Walked " + Constants.achievement_walk_IX + " m";
      case CONTINUOUS_WALKX:
        return "Walked " + Constants.achievement_walk_X + " m";
      // hidden
      case KILLED_JOHN_RANKIN:
        return "Killed John Rankin";
      default:
        return "-- Error --";
    }
  }

  public String file_name() {
    return AchievementCode.file_name(this);
  }
  public static String file_name(AchievementCode code) {
    switch(code) {
      // completion
      case COMPLETED_TUTORIAL:
        return "Completed_Tutorial";
      case COMPLETED_FRANCISCAN:
        return "Completed_Franciscan";
      case COMPLETED_DANSHOUSE:
        return "Completed_DansHouse";
      // continuous
      case CONTINUOUS_KILLSI:
        return "CONTINUOUS_KILLSI";
      case CONTINUOUS_KILLSII:
        return "CONTINUOUS_KILLSII";
      case CONTINUOUS_KILLSIII:
        return "CONTINUOUS_KILLSIII";
      case CONTINUOUS_KILLSIV:
        return "CONTINUOUS_KILLSIV";
      case CONTINUOUS_KILLSV:
        return "CONTINUOUS_KILLSV";
      case CONTINUOUS_KILLSVI:
        return "CONTINUOUS_KILLSVI";
      case CONTINUOUS_KILLSVII:
        return "CONTINUOUS_KILLSVII";
      case CONTINUOUS_KILLSVIII:
        return "CONTINUOUS_KILLSVIII";
      case CONTINUOUS_KILLSIX:
        return "CONTINUOUS_KILLSIX";
      case CONTINUOUS_KILLSX:
        return "CONTINUOUS_KILLSX";
      case CONTINUOUS_DEATHSI:
        return "CONTINUOUS_DEATHSI";
      case CONTINUOUS_DEATHSII:
        return "CONTINUOUS_DEATHSII";
      case CONTINUOUS_DEATHSIII:
        return "CONTINUOUS_DEATHSIII";
      case CONTINUOUS_DEATHSIV:
        return "CONTINUOUS_DEATHSIV";
      case CONTINUOUS_DEATHSV:
        return "CONTINUOUS_DEATHSV";
      case CONTINUOUS_DEATHSVI:
        return "CONTINUOUS_DEATHSVI";
      case CONTINUOUS_DEATHSVII:
        return "CONTINUOUS_DEATHSVII";
      case CONTINUOUS_DEATHSVIII:
        return "CONTINUOUS_DEATHSVIII";
      case CONTINUOUS_DEATHSIX:
        return "CONTINUOUS_DEATHSIX";
      case CONTINUOUS_DEATHSX:
        return "CONTINUOUS_DEATHSX";
      case CONTINUOUS_WALKI:
        return "CONTINUOUS_WALKI";
      case CONTINUOUS_WALKII:
        return "CONTINUOUS_WALKII";
      case CONTINUOUS_WALKIII:
        return "CONTINUOUS_WALKIII";
      case CONTINUOUS_WALKIV:
        return "CONTINUOUS_WALKIV";
      case CONTINUOUS_WALKV:
        return "CONTINUOUS_WALKV";
      case CONTINUOUS_WALKVI:
        return "CONTINUOUS_WALKVI";
      case CONTINUOUS_WALKVII:
        return "CONTINUOUS_WALKVII";
      case CONTINUOUS_WALKVIII:
        return "CONTINUOUS_WALKVIII";
      case CONTINUOUS_WALKIX:
        return "CONTINUOUS_WALKIX";
      case CONTINUOUS_WALKX:
        return "CONTINUOUS_WALKX";
      // hidden
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
      case COMPLETED_FRANCISCAN:
        return 1;
      case KILLED_JOHN_RANKIN:
        return 201;
      default:
        return -1;
    }
  }
}
