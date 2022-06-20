enum MinigameName {
  CHESS, EPIC_FOOLS, ZAMBOS, BENDOUR,
  ;

  private static final List<MinigameName> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  public String displayName() {
    return MinigameName.displayName(this);
  }
  public static String displayName(MinigameName code) {
    switch(code) {
      case CHESS:
        return "Chess";
      case EPIC_FOOLS:
        return "Epic Fools";
      case ZAMBOS:
        return "Zambos";
      case BENDOUR:
        return "Bendour";
      default:
        return "-- Error --";
    }
  }

  public String fileName() {
    return MinigameName.fileName(this);
  }
  static public String fileName(MinigameName code) {
    switch(code) {
      case CHESS:
        return "Chess";
      case EPIC_FOOLS:
        return "Epic Fools";
      case ZAMBOS:
        return "Zambos";
      case BENDOUR:
        return "Bendour";
      default:
        return "ERROR";
    }
  }

  public static MinigameName minigameName(String display_name) {
    for (MinigameName code : MinigameName.VALUES) {
      if (MinigameName.displayName(code).equals(display_name) ||
        MinigameName.fileName(code).equals(display_name)) {
        return code;
      }
    }
    return null;
  }
}


abstract class Minigame {
  protected boolean completed = false;
  protected MinigameName name;

  Minigame(MinigameName name) {
    this.name = name;
  }

  abstract String displayName();
  abstract void drawLeftPanel(int time_elapsed);
  abstract void drawRightPanel(int time_elapsed);
  abstract void setLocation(float xi, float yi, float xf, float yf);
  abstract void restartTimers();
  abstract void displayNerdStats();
  abstract boolean leftPanelElementsHovered();
  abstract FormLNZ getEscForm();

  abstract void update(int time_elapsed);
  abstract void mouseMove(float mX, float mY);
  abstract void mousePress();
  abstract void mouseRelease(float mX, float mY);
  abstract void scroll(int amount);
  abstract void keyPress();
  abstract void keyRelease();

  abstract void loseFocus();
  abstract void gainFocus();
}
