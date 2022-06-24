class Chess extends Minigame {
  private ChessBoard chessboard = new ChessBoard();

  Chess() {
    super(MinigameName.CHESS);
  }

  String displayName() {
    return "Chess";
  }
  void drawBottomPanel(int time_elapsed) {}
  void setLocation(float xi, float yi, float xf, float yf) {
    this.chessboard.setLocation(xi, yi, xf, yf);
  }
  void restartTimers() {}
  void displayNerdStats() {}
  boolean leftPanelElementsHovered() {
    return false;
  }
  FormLNZ getEscForm() {
    return null;
  }

  void update(int time_elapsed) {
    this.chessboard.update(time_elapsed);
  }
  void mouseMove(float mX, float mY) {
    this.chessboard.mouseMove(mX, mY);
  }
  void mousePress() {
    this.chessboard.mousePress();
  }
  void mouseRelease(float mX, float mY) {
    this.chessboard.mouseRelease(mX, mY);
  }
  void scroll(int amount) {}
  void keyPress() {}
  void keyRelease() {}

  void loseFocus() {}
  void gainFocus() {}
}
