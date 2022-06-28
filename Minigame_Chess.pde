enum ChessState {
  ANALYSIS, VS_COMPUTER;
}

class Chess extends Minigame {
  abstract class MoveBoxButton extends ImageButton {
    protected float width_ratio = 0.85; // ratio of width to height

    MoveBoxButton(String icon_name) {
      super(global.images.getImage("icons/" + icon_name + ".png"), 0, 0, 0, 0);
      this.use_time_elapsed = true;
      this.overshadow_colors = true;
      this.setColors(color(170, 170), color(1, 0), color(100, 80), color(200, 160), color(0));
    }

    void hover() {}
    void dehover() {}
    void click() {}
    void release() {
      if (this.hovered) {
        this.buttonFunction();
      }
    }

    abstract void buttonFunction();
  }

  class SpacerButton extends MoveBoxButton {
    SpacerButton(float width_ratio) {
      super("first");
      this.img = global.images.getTransparentPixel();
      this.width_ratio = width_ratio;
      this.overshadow_colors = false;
    }
    void buttonFunction() {}
  }

  class ViewFirstButton extends MoveBoxButton {
    ViewFirstButton() {
      super("first");
      this.width_ratio = 1.0;
    }
    void buttonFunction() {
      Chess.this.viewFirst();
    }
  }

  class ViewLastButton extends MoveBoxButton {
    ViewLastButton() {
      super("last");
      this.width_ratio = 1.0;
    }
    void buttonFunction() {
      Chess.this.viewLast();
    }
  }

  class ViewPreviousButton extends MoveBoxButton {
    ViewPreviousButton() {
      super("previous");
      this.width_ratio = 1.4;
    }
    void buttonFunction() {
      Chess.this.viewPrevious();
    }
  }

  class ViewNextButton extends MoveBoxButton {
    ViewNextButton() {
      super("next");
      this.width_ratio = 1.4;
    }
    void buttonFunction() {
      Chess.this.viewNext();
    }
  }

  class RotateBoardButton extends MoveBoxButton {
    RotateBoardButton() {
      super("flip");
    }
    void buttonFunction() {
      Chess.this.flipBoard();
    }
  }

  class ResetButton extends MoveBoxButton {
    ResetButton() {
      super("reset");
    }
    void buttonFunction() {
      Chess.this.resetAnalysisBoard();
    }
  }

  class VsComputerButton extends MoveBoxButton {
    VsComputerButton() {
      super("ai");
    }
    void buttonFunction() {
      Chess.this.startGameVsComputer();
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
    protected ArrayList<MoveBoxButton> buttons = new ArrayList<MoveBoxButton>();
    protected float button_min_size = 50;
    protected float button_gap = 5;

    MoveBox() {
      this.addButtons();
    }

    abstract void addButtons();

    void setLocation(float xi, float yi, float xf, float yf) {
      float button_weight = 0;
      for (MoveBoxButton button : this.buttons) {
        button_weight += button.width_ratio;
      }
      float button_height = 0;
      if (button_weight != 0) {
        button_height = min(this.button_min_size, (xf - xi - (this.buttons.size() - 1) * this.button_gap) / button_weight);
      }
      this.moves.setLocation(xi + this.button_gap, yi + this.button_gap,
        xf - this.button_gap, yf - 2 * this.button_gap - button_height);
      float x_curr = xi;
      for (MoveBoxButton button : this.buttons) {
        float button_width = button.width_ratio * button_height;
        button.setLocation(x_curr, yf - this.button_gap - button_height,
          x_curr + button_width, yf - this.button_gap);
        x_curr += button_width + this.button_gap;
      }
    }

    void addMove(ChessMove move) {
      this.moves.addLine(move.pgnString());
    }

    void gameEnded(GameEnds ends) {
      this.moves.addLine(ends.displayName());
    }

    void update(int time_elapsed) {
      this.moves.update(time_elapsed);
      for (MoveBoxButton button : this.buttons) {
        button.update(time_elapsed);
      }
    }

    void mouseMove(float mX, float mY) {
      this.moves.mouseMove(mX, mY);
      for (MoveBoxButton button : this.buttons) {
        button.mouseMove(mX, mY);
      }
    }

    void mousePress() {
      this.moves.mousePress();
      for (MoveBoxButton button : this.buttons) {
        button.mousePress();
      }
    }

    void mouseRelease(float mX, float mY) {
      this.moves.mouseRelease(mX, mY);
      for (MoveBoxButton button : this.buttons) {
        button.mouseRelease(mX, mY);
      }
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
    AnalysisMoveBox() {
      super();
      this.moves.setTitleText("Analysis");
    }

    void addButtons() {
      this.buttons.add(new RotateBoardButton());
      this.buttons.add(new SpacerButton(0.3));
      this.buttons.add(new ViewFirstButton());
      this.buttons.add(new ViewPreviousButton());
      this.buttons.add(new ViewNextButton());
      this.buttons.add(new ViewLastButton());
      this.buttons.add(new SpacerButton(0.3));
      this.buttons.add(new ResetButton());
      this.buttons.add(new VsComputerButton());
    }
  }


  class PlayingMoveBox extends MoveBox {
    PlayingMoveBox() {
      super();
      this.moves.setTitleText("Vs Computer");
    }

    void addButtons() {
      this.buttons.add(new RotateBoardButton());
      this.buttons.add(new SpacerButton(0.3));
      this.buttons.add(new ViewFirstButton());
    }
  }

  private ChessBoard chessboard = new ChessBoard();
  private ArrayList<ChessBoard> chessboard_views = new ArrayList<ChessBoard>();
  private int current_view = 0;
  private ChessState state = ChessState.ANALYSIS;
  private MoveBox move_box = new AnalysisMoveBox();

  private ChessAI chess_ai = new ChessAI();
  private boolean computers_turn = false;
  private int computers_time_left = 0;

  Chess() {
    super(MinigameName.CHESS);
    this.chessboard.setupBoard();
    this.initialChessboardView();
  }

  ChessBoard chessboardView() {
    if (this.current_view >= this.chessboard_views.size()) {
      return null;
    }
    return this.chessboard_views.get(this.current_view);
  }

  void initialChessboardView() {
    ChessBoard copied_board = new ChessBoard(this.chessboard);
    copied_board.toggle_human_controllable = true;
    this.chessboard_views.clear();
    this.chessboard_views.add(copied_board);
    this.current_view = this.chessboard_views.size() - 1;
    this.chessboard.toggle_human_controllable = false;
  }

  void updateView(ChessMove move) {
    ChessBoard copied_board = new ChessBoard(this.chessboard_views.get(this.chessboard_views.size() - 1));
    copied_board.makeMove(move);
    copied_board.toggle_human_controllable = true;
    this.chessboard_views.add(copied_board);
    this.current_view = this.chessboard_views.size() - 1;
    this.chessboard.toggle_human_controllable = false;
  }

  void viewFirst() {
    this.current_view = 0;
    if (this.chessboard_views.size() > 1) {
      this.chessboard.toggle_human_controllable = true;
    }
    this.refreshChessboardViewLocation();
  }

  void viewLast() {
    this.current_view = this.chessboard_views.size() - 1;
    this.chessboard.toggle_human_controllable = false;
    this.refreshChessboardViewLocation();
  }

  void viewPrevious() {
    if (this.current_view > 0) {
      this.current_view--;
      this.chessboard.toggle_human_controllable = true;
    }
    this.refreshChessboardViewLocation();
  }

  void viewNext() {
    if (this.current_view < this.chessboard_views.size() - 1) {
      this.current_view++;
      if (this.current_view == this.chessboard_views.size() - 1) {
        this.chessboard.toggle_human_controllable = false;
      }
    }
    this.refreshChessboardViewLocation();
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
    this.chessboardView().orientation = this.chessboard.orientation;
  }

  void resetAnalysisBoard() {
    if (this.state != ChessState.ANALYSIS) {
      global.errorMessage("ERROR: Can't reset analyis when not in analysis.");
      return;
    }
    this.chessboard.resetAnalysis();
    this.initialChessboardView();
    this.chess_ai.reset();
    this.move_box = new AnalysisMoveBox();
    this.refreshLocation();
  }

  void startGameVsComputer() {
    if (this.state == ChessState.VS_COMPUTER) {
      global.errorMessage("ERROR: Can't start game while in game vs computer.");
      return;
    }
    this.state = ChessState.VS_COMPUTER;
    this.move_box = new PlayingMoveBox();
    this.chessboard.setupBoard();
    this.initialChessboardView();
    this.chess_ai.reset();
    if (randomChance(0.5)) {
      this.chessboard.human_controlled = HumanMovable.WHITE;
      this.chessboard.orientation = BoardOrientation.RIGHT;
    }
    else {
      this.chessboard.human_controlled = HumanMovable.BLACK;
      this.chessboard.orientation = BoardOrientation.LEFT;
      this.startComputersTurn();
    }
    this.refreshLocation();
  }

  void drawBottomPanel(int time_elapsed) {}
  void setDependencyLocations(float xi, float yi, float xf, float yf) {
    this.chessboard.setLocation(xi + Constants.minigames_chessPanelsSize +
      Constants.minigames_edgeGap, yi + Constants.minigames_edgeGap, xf -
      Constants.minigames_chessPanelsSize - Constants.minigames_edgeGap, yf -
      Constants.minigames_edgeGap);
    this.refreshChessboardViewLocation();
    this.move_box.setLocation(xf - Constants.minigames_chessPanelsSize, yi, xf, yf);
  }
  void refreshChessboardViewLocation() {
    if (this.chessboardView() == null) {
      return;
    }
    this.chessboardView().setLocation(this.xi + Constants.minigames_chessPanelsSize +
      Constants.minigames_edgeGap, this.yi + Constants.minigames_edgeGap, this.xf -
      Constants.minigames_chessPanelsSize - Constants.minigames_edgeGap, this.yf -
      Constants.minigames_edgeGap);
    this.chessboardView().orientation = this.chessboard.orientation;
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

  void startComputersTurn() {
    this.computers_turn = true;
    this.computers_time_left = 100;
  }

  void update(int time_elapsed) {
    if (this.current_view < this.chessboard_views.size() - 1) {
      this.chessboardView().update(time_elapsed);
      this.chessboard.updateWithoutDisplay(time_elapsed);
    }
    else {
      this.chessboard.update(time_elapsed);
    }
    if (this.computers_turn) {
      this.computers_time_left -= time_elapsed;
      if (this.computers_time_left < 0) {
        this.computers_turn = false;
        ChessMove computers_move = this.chess_ai.getMove();
        if (computers_move == null) {
          if (this.chessboard.game_ended == null) {
            global.errorMessage("ERROR: Chess AI returned null move when game not over.");
            this.chessboard.makeRandomMove();
          }
        }
        else if (chessboard.valid_moves.contains(computers_move)) {
          this.chessboard.makeMove(computers_move);
        }
        else {
          String move_string = "Null";
          if (computers_move != null) {
            move_string = computers_move.pgnString();
          }
          String valid_moves = "";
          for (ChessMove move : this.chessboard.valid_moves) {
            valid_moves += "\n" + move.pgnString();
          }
          global.errorMessage("ERROR: Chess AI returned invalid move:\n" + move_string +
            "\n\nValid moves are:" + valid_moves);
          this.chessboard.makeRandomMove();
        }
      }
    }
    while (this.chessboard.move_queue.peek() != null) {
      ChessMove move = this.chessboard.move_queue.poll();
      this.move_box.addMove(move);
      this.chess_ai.addMove(move);
      this.updateView(move);
      if (this.chessboard.game_ended != null) {
        this.move_box.gameEnded(this.chessboard.game_ended);
      }
      else if (this.chessboard.computersTurn()) {
        this.startComputersTurn();
      }
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
