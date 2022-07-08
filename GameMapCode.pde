enum GameMapCode {
  ERROR, AREA_FERNWOOD, FRANCIS_FLOOR2, FRANCIS_FLOOR1, FRANCIS_GROUND,
  FRONTDOOR_FRONTDOOR, FRONTDOOR_AHIMDOOR, FRONTDOOR_CIRCLE, FRONTDOOR_ABANDONED,
    FRONTDOOR_CHAPEL, FRONTDOOR_CODA, FRONTDOOR_OUTSIDEFF, FRONTDOOR_INSIDEFF,
    FRONTDOOR_HILL, FRONTDOOR_LOT,
  FRANCIS_OUTSIDE_AHIM, FRANCIS_OUTSIDE_BROTHERS, FRANCIS_OUTSIDE_CHAPEL,
  FRANCIS_OUTSIDE_CUSTODIAL;

  private static final List<GameMapCode> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  public String display_name() {
    return GameMapCode.display_name(this);
  }
  public static String display_name(GameMapCode a) {
    switch(a) {
      case AREA_FERNWOOD:
        return "Fernwood Forest";
      case FRANCIS_FLOOR2:
        return "Francis Hall, 2nd floor";
      case FRANCIS_FLOOR1:
        return "Francis Hall, 1st floor";
      case FRANCIS_GROUND:
        return "Francis Hall, ground floor";
      case FRONTDOOR_FRONTDOOR:
        return "Outside Francis Hall, front door";
      case FRONTDOOR_AHIMDOOR:
        return "Outside Francis Hall, Ahim door";
      case FRONTDOOR_CIRCLE:
        return "Francisan Campus, the circle";
      case FRONTDOOR_ABANDONED:
        return "Francisan Campus, front hillside";
      case FRONTDOOR_HILL:
        return "Francisan Campus, front hillside";
      case FRONTDOOR_LOT:
        return "Franciscan Campus, lower parking lot";
      case FRONTDOOR_CHAPEL:
        return "Francisan Campus, outside Chapel";
      case FRONTDOOR_CODA:
        return "Francisan Campus, outside CODA";
      case FRONTDOOR_OUTSIDEFF:
        return "Francisan Campus, outside FFH";
      case FRONTDOOR_INSIDEFF:
        return "Finnegan Fieldhouse";

      case FRANCIS_OUTSIDE_AHIM:
        return "Outside Francis Hall, Ahim door";
      case FRANCIS_OUTSIDE_BROTHERS:
        return "Outside Francis Hall, Brother's door";
      case FRANCIS_OUTSIDE_CHAPEL:
        return "Outside Francis Hall, chapel door";
      case FRANCIS_OUTSIDE_CUSTODIAL:
        return "Outside Francis Hall, custodial door";
      default:
        return "-- Error --";
    }
  }

  public String file_name() {
    return GameMapCode.file_name(this);
  }
  public static String file_name(GameMapCode a) {
    switch(a) {
      case AREA_FERNWOOD:
        return "AREA_FERNWOOD";

      case FRANCIS_FLOOR2:
        return "FRANCIS_FLOOR2";
      case FRANCIS_FLOOR1:
        return "FRANCIS_FLOOR1";
      case FRANCIS_GROUND:
        return "FRANCIS_GROUND";

      case FRONTDOOR_FRONTDOOR:
        return "FRONTDOOR_FRONTDOOR";
      case FRONTDOOR_AHIMDOOR:
        return "FRONTDOOR_AHIMDOOR";
      case FRONTDOOR_CIRCLE:
        return "FRONTDOOR_CIRCLE";
      case FRONTDOOR_ABANDONED:
        return "FRONTDOOR_ABANDONED";
      case FRONTDOOR_HILL:
        return "FRONTDOOR_HILL";
      case FRONTDOOR_LOT:
        return "FRONTDOOR_LOT";
      case FRONTDOOR_CHAPEL:
        return "FRONTDOOR_CHAPEL";
      case FRONTDOOR_CODA:
        return "FRONTDOOR_CODA";
      case FRONTDOOR_OUTSIDEFF:
        return "FRONTDOOR_OUTSIDEFF";
      case FRONTDOOR_INSIDEFF:
        return "FRONTDOOR_INSIDEFF";

      case FRANCIS_OUTSIDE_AHIM:
        return "FRANCIS_OUTSIDE_AHIM";
      case FRANCIS_OUTSIDE_BROTHERS:
        return "FRANCIS_OUTSIDE_BROTHERS";
      case FRANCIS_OUTSIDE_CHAPEL:
        return "FRANCIS_OUTSIDE_CHAPEL";
      case FRANCIS_OUTSIDE_CUSTODIAL:
        return "FRANCIS_OUTSIDE_CUSTODIAL";
      default:
        return "ERROR";
    }
  }

  public static GameMapCode gameMapCode(String display_name) {
    for (GameMapCode code : GameMapCode.VALUES) {
      if (code == GameMapCode.ERROR) {
        continue;
      }
      if (GameMapCode.display_name(code).equals(display_name) ||
        GameMapCode.file_name(code).equals(display_name)) {
        return code;
      }
    }
    return GameMapCode.ERROR;
  }
}
