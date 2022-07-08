// level location
enum Location {
  ERROR, TUTORIAL,

  FRANCISCAN_FRANCIS, FRANCISCAN_LEV2_FRONTDOOR, FRANCISCAN_LEV2_AHIMDOOR,
  FRANCISCAN_LEV2_CHAPELDOOR, FRANCISCAN_LEV2_BROTHERSDOOR, FRANCISCAN_LEV2_CUSTODIALDOOR,
  FRANCISCAN_LEV3_KILLEDHECK, FRANCISCAN_LEV3_AROUNDCODA,
  AREA_FERNWOOD;

  private static final List<Location> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  public String display_name() {
    return Location.display_name(this);
  }
  public static String display_name(Location a) {
    switch(a) {
      case TUTORIAL:
        return "Tutorial";
      case FRANCISCAN_FRANCIS:
        return "Francis Hall";
      case FRANCISCAN_LEV2_FRONTDOOR:
      case FRANCISCAN_LEV2_AHIMDOOR:
      case FRANCISCAN_LEV2_CHAPELDOOR:
      case FRANCISCAN_LEV2_BROTHERSDOOR:
      case FRANCISCAN_LEV2_CUSTODIALDOOR:
      case FRANCISCAN_LEV3_KILLEDHECK:
      case FRANCISCAN_LEV3_AROUNDCODA:
        return "Franciscan Campus";
      case AREA_FERNWOOD:
        return "Fernwood State Forest";
      default:
        return "-- Error --";
    }
  }

  public String file_name() {
    return Location.file_name(this);
  }
  public static String file_name(Location a) {
    switch(a) {
      case TUTORIAL:
        return "tutorial";
      case FRANCISCAN_FRANCIS:
        return "franciscan_francis";
      case FRANCISCAN_LEV2_FRONTDOOR:
        return "franciscan_lev2_frontdoor";
      case FRANCISCAN_LEV2_AHIMDOOR:
        return "franciscan_lev2_ahimdoor";
      case FRANCISCAN_LEV2_CHAPELDOOR:
        return "franciscan_lev2_chapeldoor";
      case FRANCISCAN_LEV2_BROTHERSDOOR:
        return "franciscan_lev2_brothersdoor";
      case FRANCISCAN_LEV2_CUSTODIALDOOR:
        return "franciscan_lev2_custodialdoor";
      case FRANCISCAN_LEV3_KILLEDHECK:
        return "franciscan_lev3_killedheck";
      case FRANCISCAN_LEV3_AROUNDCODA:
        return "franciscan_lev3_aroundcoda";
      case AREA_FERNWOOD:
        return "area_fernwood";
      default:
        return "ERROR";
    }
  }

  public static Location location(String display_name) {
    for (Location location : Location.VALUES) {
      if (location == Location.ERROR) {
        continue;
      }
      if (Location.display_name(location).equals(display_name) ||
        Location.file_name(location).equals(display_name)) {
        return location;
      }
    }
    return Location.ERROR;
  }

  public Location nextLocation(int completion_code) {
    return Location.nextLocation(this, completion_code);
  }
  public static Location nextLocation(Location a, int completion_code) {
    Location return_location = Location.ERROR;
    switch(a) {
      case FRANCISCAN_FRANCIS:
        switch(completion_code) {
          case 0: // ctrl-c
            return_location = Location.FRANCISCAN_LEV2_FRONTDOOR;
            break;
          case 1:
            return_location = Location.FRANCISCAN_LEV2_FRONTDOOR;
            break;
          case 2:
            return_location = Location.FRANCISCAN_LEV2_AHIMDOOR;
            break;
          case 3:
            return_location = Location.FRANCISCAN_LEV2_CHAPELDOOR;
            break;
          case 4:
            return_location = Location.FRANCISCAN_LEV2_BROTHERSDOOR;
            break;
          case 5:
            return_location = Location.FRANCISCAN_LEV2_CUSTODIALDOOR;
            break;
          default:
            return_location = Location.ERROR;
            break;
        }
        break;
      case FRANCISCAN_LEV2_FRONTDOOR:
        switch(completion_code) {
          case 0: // ctrl-c
            return_location = Location.FRANCISCAN_LEV3_KILLEDHECK;
            break;
          case 1: // ahimdoor car
            return_location = Location.AREA_FERNWOOD;
            break;
          case 2: // lot boss car
            return_location = Location.AREA_FERNWOOD;
            break;
          case 3: // killed heck
            return_location = Location.FRANCISCAN_LEV3_KILLEDHECK;
            break;
          case 4: // around coda
            return_location = Location.FRANCISCAN_LEV3_AROUNDCODA;
            break;
          default:
            return_location = Location.ERROR;
            break;
        }
        break;
      case FRANCISCAN_LEV3_KILLEDHECK:
        switch(completion_code) {
          case 0:
            return_location = Location.AREA_FERNWOOD;
            break;
          case 1: // down hill boss
            return_location = Location.AREA_FERNWOOD;
            break;
          case 2: // starvaggi car
            return_location = Location.AREA_FERNWOOD;
            break;
          default:
            return_location = Location.ERROR;
            break;
        }
        break;
      case FRANCISCAN_LEV3_AROUNDCODA:
        switch(completion_code) {
          case 0:
            return_location = Location.AREA_FERNWOOD;
            break;
          case 1: // down hill boss
            return_location = Location.AREA_FERNWOOD;
            break;
          default:
            return_location = Location.ERROR;
            break;
        }
        break;
      case FRANCISCAN_LEV2_AHIMDOOR:
      case FRANCISCAN_LEV2_CHAPELDOOR:
      case FRANCISCAN_LEV2_BROTHERSDOOR:
      case FRANCISCAN_LEV2_CUSTODIALDOOR:
        switch(completion_code) {
          case 0:
            return_location = Location.AREA_FERNWOOD;
            break;
          default:
            return_location = Location.ERROR;
            break;
        }
        break;
      default:
        return_location = Location.ERROR;
        break;
    }
    return return_location;
  }

  public boolean isCampaignStart() {
    return Location.isCampaignStart(this);
  }
  public static boolean isCampaignStart(Location a) {
    switch(a) {
      case FRANCISCAN_FRANCIS:
        return true;
      default:
        return false;
    }
  }

  public Location getCampaignStart() {
    return Location.getCampaignStart(this);
  }
  public static Location getCampaignStart(Location a) {
    switch(a) {
      case FRANCISCAN_FRANCIS:
      case FRANCISCAN_LEV2_FRONTDOOR:
      case FRANCISCAN_LEV2_AHIMDOOR:
      case FRANCISCAN_LEV2_CHAPELDOOR:
      case FRANCISCAN_LEV2_BROTHERSDOOR:
      case FRANCISCAN_LEV2_CUSTODIALDOOR:
      case FRANCISCAN_LEV3_KILLEDHECK:
      case FRANCISCAN_LEV3_AROUNDCODA:
        return Location.FRANCISCAN_FRANCIS;
      default:
        return Location.ERROR;
    }
  }

  public boolean isArea() {
    return Location.isArea(this);
  }
  public static boolean isArea(Location a) {
    switch(a) {
      case AREA_FERNWOOD:
        return true;
      default:
        return false;
    }
  }

  public Location areaLocation() {
    return Location.areaLocation(this);
  }
  public static Location areaLocation(Location a) {
    switch(a) {
      case FRANCISCAN_FRANCIS:
      case FRANCISCAN_LEV2_FRONTDOOR:
      case FRANCISCAN_LEV2_AHIMDOOR:
      case FRANCISCAN_LEV2_CHAPELDOOR:
      case FRANCISCAN_LEV2_BROTHERSDOOR:
      case FRANCISCAN_LEV2_CUSTODIALDOOR:
      case FRANCISCAN_LEV3_KILLEDHECK:
      case FRANCISCAN_LEV3_AROUNDCODA:
        return Location.AREA_FERNWOOD;
      default:
        return Location.ERROR;
    }
  }

  public ArrayList<Location> locationsFromArea() {
    return Location.locationsFromArea(this);
  }
  public static ArrayList<Location> locationsFromArea(Location a) {
    ArrayList<Location> locations = new ArrayList<Location>();
    switch(a) {
      case AREA_FERNWOOD:
        locations.add(Location.FRANCISCAN_FRANCIS);
        break;
      default:
        break;
    }
    return locations;
  }
}
