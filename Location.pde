// level location
enum Location {
  ERROR, TUTORIAL, FRANCISCAN_FRANCIS, FRANCISCAN_OUTSIDE;

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
}
