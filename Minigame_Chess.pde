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

  class VsComputerButton extends ImageButton {
    VsComputerButton() {
      super(global.images.getImage("icons/ai.png"), 0, 0, 0, 0);
      this.use_time_elapsed = true;
    }

    void hover() {}
    void dehover() {}
    void click() {}
    void release() {
      if (this.hovered) {
        Chess.this.startGameVsComputer();
      }
    }
  }


  abstract class MoveBox {
    class MoveContainer extends ListTextBox {
      MoveContainer() {
        super();
      }

      void click() {
      }

      void doubleclick() {
      }
    }


    protected MoveContainer moves = new MoveContainer();

    MoveBox() {
    }

    abstract void setLocation(float xi, float yi, float xf, float yf);

    void addMove(ChessMove move) {
      this.moves.addLine(move.pgnString());
    }


    void update(int time_elapsed) {
      this.moves.update(time_elapsed);
    }

    void mouseMove(float mX, float mY) {
      this.moves.mouseMove(mX, mY);
    }

    void mousePress() {
      this.moves.mousePress();
    }

    void mouseRelease(float mX, float mY) {
      this.moves.mouseRelease(mX, mY);
    }

    void scroll(int amount) {
      this.moves.scroll(amount);
    }

    void keyPress() {
      this.moves.keyPress();
    }

    void keyRelease() {
    }
  }


  class AnalysisMoveBox extends MoveBox {
    protected RotateBoardButton rotate_board = new RotateBoardButton();
    protected VsComputerButton vs_computer = new VsComputerButton();

    AnalysisMoveBox() {
      super();
    }

    void setLocation(float xi, float yi, float xf, float yf) {
      this.moves.setLocation(xi, yi, xf, yf - 54);
      this.rotate_board.setLocation(xi + 2, yf - 52, xi + 52, yf - 2);
      this.vs_computer.setLocation(xi + 54, yf - 52, xi + 106, yf - 2);
    }


    @Override
    void update(int time_elapsed) {
      super.update(time_elapsed);
      this.rotate_board.update(time_elapsed);
      this.vs_computer.update(time_elapsed);
    }

    @Override
    void mouseMove(float mX, float mY) {
      super.mouseMove(mX, mY);
      this.rotate_board.mouseMove(mX, mY);
      this.vs_computer.mouseMove(mX, mY);
    }

    @Override
    void mousePress() {
      super.mousePress();
      this.rotate_board.mousePress();
      this.vs_computer.mousePress();
    }

    @Override
    void mouseRelease(float mX, float mY) {
      super.mouseRelease(mX, mY);
      this.rotate_board.mouseRelease(mX, mY);
      this.vs_computer.mouseRelease(mX, mY);
    }
  }


  class PlayingMoveBox extends MoveBox {
    PlayingMoveBox() {
      super();
    }

    void setLocation(float xi, float yi, float xf, float yf) {
      this.moves.setLocation(xi, yi, xf, yf);
      // smaller for times
    }
  }

  private ChessBoard chessboard = new ChessBoard();
  private ChessAI chess_ai = new ChessAI();
  private ChessState state = ChessState.ANALYSIS;
  private MoveBox move_box = new AnalysisMoveBox();

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

  void startGameVsComputer() {
    if (this.state == ChessState.VS_COMPUTER) {
      global.errorMessage("ERROR: Can't start game while in game vs computer.");
      return;
    }
    this.state = ChessState.VS_COMPUTER;
    this.move_box = new PlayingMoveBox();
    this.chessboard.setupBoard();
    this.chess_ai.reset();
    if (randomChance(0.5)) {
      this.chessboard.human_controlled = HumanMovable.WHITE;
      this.chessboard.orientation = BoardOrientation.RIGHT;
    }
    else {
      this.chessboard.human_controlled = HumanMovable.BLACK;
      this.chessboard.orientation = BoardOrientation.LEFT;
    }
    this.refreshLocation();
  }

  void drawBottomPanel(int time_elapsed) {}
  void setDependencyLocations(float xi, float yi, float xf, float yf) {
    this.chessboard.setLocation(xi + Constants.minigames_chessPanelsSize +
      Constants.minigames_edgeGap, yi + Constants.minigames_edgeGap, xf -
      Constants.minigames_chessPanelsSize - Constants.minigames_edgeGap, yf -
      Constants.minigames_edgeGap);
    this.move_box.setLocation(xf - Constants.minigames_chessPanelsSize, yi, xf, yf);
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
    while (this.chessboard.move_queue.peek() != null) {
      ChessMove move = this.chessboard.move_queue.poll();
      this.move_box.addMove(move);
      this.chess_ai.addMove(move);
    }
    this.move_box.update(time_elapsed);
  }
  void mouseMove(float mX, float mY) {
    this.chessboard.mouseMove(mX, mY);
    this.move_box.mouseMove(mX, mY);
  }
  void mousePress() {
    this.chessboard.mousePress();
    this.move_box.mousePress();
  }
  void mouseRelease(float mX, float mY) {
    this.chessboard.mouseRelease(mX, mY);
    this.move_box.mouseRelease(mX, mY);
  }
  void scroll(int amount) {
    this.move_box.scroll(amount);
  }
  void keyPress() {
    this.move_box.keyPress();
  }
  void keyRelease() {
    this.move_box.keyRelease();
  }

  void loseFocus() {}
  void gainFocus() {}
}
