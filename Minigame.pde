enum MinigameName {
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
