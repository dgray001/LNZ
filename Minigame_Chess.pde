enum ChessState {
  ANALYSIS, VS_COMPUTER;
}

class Chess extends Minigame {
  class RotateBoardButton extends ImageButton {
    RotateBoardButton() {
      super(global.images.getImage("icons/flip.png"), 0, 0, 0, 0);
      this.use_time_elapsed = true;
    }

    void hover() {}
    void dehover() {}
    void click() {}
    void release() {
      if (this.hovered) {
        Chess.this.flipBoard();
      }
    }
  }

  private ChessBoard chessboard = new ChessBoard();

  private RotateBoardButton rotate = new RotateBoardButton();

  Chess() {
    super(MinigameName.CHESS);
    this.chessboard.setupBoard();
  }

  void flipBoard() {
    switch(this.chessboard.orientation) {
      case RIGHT:
        this.chessboard.orientation = BoardOrientation.LEFT;
        break;
      case LEFT:
        this.chessboard.orientation = BoardOrientation.RIGHT;
        break;
    }
  }

  void drawBottomPanel(int time_elapsed) {}
  void setLocation(float xi, float yi, float xf, float yf) {
    this.chessboard.setLocation(xi + Constants.minigames_edgeGap, yi + Constants.
      minigames_edgeGap, xf - Constants.minigames_edgeGap, yf - Constants.minigames_edgeGap);
    this.rotate.setLocation(xf - 300, yi + 200, xf - 260, yi + 240);
  }
  void restartTimers() {}
  void displayNerdStats() {
    fill(255);
    textSize(14);
    textAlign(LEFT, TOP);
    float y_stats = 1;
    float line_height = textAscent() + textDescent() + 2;
    text("FPS: " + int(global.lastFPS), 1, y_stats);
  }
  boolean leftPanelElementsHovered() {
    return false;
  }
  FormLNZ getEscForm() {
    return null;
  }

  void update(int time_elapsed) {
    this.chessboard.update(time_elapsed);
    this.rotate.update(time_elapsed);
  }
  void mouseMove(float mX, float mY) {
    this.chessboard.mouseMove(mX, mY);
    this.rotate.mouseMove(mX, mY);
  }
  void mousePress() {
    this.chessboard.mousePress();
    this.rotate.mousePress();
  }
  void mouseRelease(float mX, float mY) {
    this.chessboard.mouseRelease(mX, mY);
    this.rotate.mouseRelease(mX, mY);
  }
  void scroll(int amount) {}
  void keyPress() {}
  void keyRelease() {}

  void loseFocus() {}
  void gainFocus() {}
}
