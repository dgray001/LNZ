enum Element {
  GRAY("Gray"), BLUE("Blue"), RED("Red"), CYAN("Cyan"), ORANGE("Orange"),
    BROWN("Brown"), PURPLE("Purple"), YELLOW("Yellow"), MAGENTA("Magenta");

  private static final List<Element> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  private String element_name;
  private Element(String element_name) {
    this.element_name = element_name;
  }
  public String element_name() {
    return this.element_name;
  }
  public static String element_name(Element element) {
    return element.element_name();
  }

  public static Element element(String element_name) {
    for (Element element : Element.VALUES) {
      if (element.element_name().equals(element_name)) {
        return element;
      }
    }
    return Element.GRAY;
  }

  public float resistanceFactorTo(Element element) {
    return Element.resistanceFactorTo(this, element);
  }
  public static float resistanceFactorTo(Element target, Element source) {
    switch(target) {
      case BLUE:
        switch(source) {
          case BLUE:
            return Constants.resistance_blue_blue;
          case RED:
            return Constants.resistance_blue_red;
          case BROWN:
            return Constants.resistance_blue_brown;
          default:
            return Constants.resistance_default;
        }
      case RED:
        switch(source) {
          case RED:
            return Constants.resistance_red_red;
          case CYAN:
            return Constants.resistance_red_cyan;
          case BLUE:
            return Constants.resistance_red_blue;
          default:
            return Constants.resistance_default;
        }
      case CYAN:
        switch(source) {
          case CYAN:
            return Constants.resistance_cyan_cyan;
          case ORANGE:
            return Constants.resistance_cyan_orange;
          case RED:
            return Constants.resistance_cyan_red;
          default:
            return Constants.resistance_default;
        }
      case ORANGE:
        switch(source) {
          case ORANGE:
            return Constants.resistance_orange_orange;
          case BROWN:
            return Constants.resistance_orange_brown;
          case CYAN:
            return Constants.resistance_orange_cyan;
          default:
            return Constants.resistance_default;
        }
      case BROWN:
        switch(source) {
          case BROWN:
            return Constants.resistance_brown_brown;
          case BLUE:
            return Constants.resistance_brown_blue;
          case ORANGE:
            return Constants.resistance_brown_orange;
          default:
            return Constants.resistance_default;
        }
      case PURPLE:
        switch(source) {
          case PURPLE:
            return Constants.resistance_purple_purple;
          case YELLOW:
            return Constants.resistance_purple_yellow;
          case MAGENTA:
            return Constants.resistance_purple_magenta;
          default:
            return Constants.resistance_default;
        }
      case YELLOW:
        switch(source) {
          case YELLOW:
            return Constants.resistance_yellow_yellow;
          case MAGENTA:
            return Constants.resistance_yellow_magenta;
          case PURPLE:
            return Constants.resistance_yellow_purple;
          default:
            return Constants.resistance_default;
        }
      case MAGENTA:
        switch(source) {
          case MAGENTA:
            return Constants.resistance_magenta_magenta;
          case PURPLE:
            return Constants.resistance_magenta_purple;
          case YELLOW:
            return Constants.resistance_magenta_yellow;
          default:
            return Constants.resistance_default;
        }
      default:
        return Constants.resistance_default;
    }
  }
}
