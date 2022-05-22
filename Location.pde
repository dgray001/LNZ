// level location
enum Location {
  ERROR, TUTORIAL, FRANCISCAN_FRANCIS, FRANCISCAN_OUTSIDE, AREA_GOLFCOURSE;

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
      case FRANCISCAN_OUTSIDE:
        return "Franciscan Campus";
      case AREA_GOLFCOURSE:
        return "Golf Course";
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
      case FRANCISCAN_OUTSIDE:
        return "franciscan_outside";
      case AREA_GOLFCOURSE:
        return "golf_course";
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
          case 0:
            return_location = Location.FRANCISCAN_OUTSIDE;
            break;
          default:
            return_location = Location.ERROR;
            break;
        }
        break;
      case FRANCISCAN_OUTSIDE:
        switch(completion_code) {
          case 0:
            return_location = Location.AREA_GOLFCOURSE;
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

  public boolean isArea() {
    return Location.isArea(this);
  }
  public static boolean isArea(Location a) {
    switch(a) {
      case AREA_GOLFCOURSE:
        return true;
      default:
        return false;
    }
  }
}
