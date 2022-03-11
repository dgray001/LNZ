enum Campaign {
  ERROR, FRANCISCAN;

  private static final List<Campaign> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  public ArrayList<Location> levels() {
    return Campaign.levels(this);
  }
  static public ArrayList<Location> levels(Campaign campaign) {
    ArrayList<Location> levels = new ArrayList<Location>();
    switch(campaign) {
      case FRANCISCAN:
        levels.add(Location.FRANCISCAN_FRANCIS);
        levels.add(Location.FRANCISCAN_OUTSIDE);
        break;
      default:
        break;
    }
    return levels;
  }

  static public Campaign campaign(Location location) {
    switch(location) {
      case FRANCISCAN_FRANCIS:
      case FRANCISCAN_OUTSIDE:
        return Campaign.FRANCISCAN;
      default:
        break;
    }
    return Campaign.ERROR;
  }

  public Location first() {
    return Campaign.first(this);
  }
  static public Location first(Campaign campaign) {
    switch(campaign) {
      case FRANCISCAN:
        return Location.FRANCISCAN_FRANCIS; // switch to outside so that when you return to francis hall you can start outside ??
      default:
        break;
    }
    return Location.ERROR;
  }

  public Location next(int completionCode) {
    return Campaign.next(this, completionCode);
  }
  static public Location next(Campaign campaign, int completionCode) {
    switch(campaign) {
      default:
        break;
    }
    return Location.ERROR;
  }
}
