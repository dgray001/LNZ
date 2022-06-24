class Chess extends Minigame {

  Chess() {
    super(MinigameName.CHESS);
  }

  String displayName() {
    return "Chess";
  }
  void drawBottomPanel(int time_elapsed) {}
  void setLocation(float xi, float yi, float xf, float yf) {}
  void restartTimers() {}
  void displayNerdStats() {}
  boolean leftPanelElementsHovered() {
    return false;
  }
  FormLNZ getEscForm() {
    return null;
  }

  void update(int time_elapsed) {}
  void mouseMove(float mX, float mY) {}
  void mousePress() {}
  void mouseRelease(float mX, float mY) {}
  void scroll(int amount) {}
  void keyPress() {}
  void keyRelease() {}

  void loseFocus() {}
  void gainFocus() {}
}
