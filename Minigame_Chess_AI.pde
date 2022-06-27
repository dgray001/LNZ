class ChessAI {
  private ChessBoard board = new ChessBoard();

  ChessAI() {
  }

  void reset() {
    this.board.setupBoard();
  }

  void addMove(ChessMove move) {
    this.board.makeMove(move, false);
  }

  ChessMove getMove() {
    ArrayList<ChessMove> possible_moves = new ArrayList<ChessMove>(this.board.valid_moves);
    if (possible_moves.size() == 0) {
      return null;
    }
    Collections.shuffle(possible_moves);
    return possible_moves.get(0);
  }
}


enum EvaluationAlgorithm {
  NONE, MATERIAL;
}


class ChessNode {
  private ChessNode parent = null;
  private ChessMove source_move = null;
  private ChessBoard board;
  private ArrayList<ChessNode> daughters = new ArrayList<ChessNode>();
  private boolean made_daughters = false;
  private boolean evaluated = false;
  private float base_evaluation = 0;
  private float evaluation = 0;

  ChessNode(ChessBoard board, ChessNode parent, ChessMove source_move) {
    this.board = board;
    this.parent = parent;
    this.source_move = source_move;
  }

  void makeDaughters() {
    if (this.made_daughters) {
      return;
    }
    this.made_daughters = true;
    for (ChessMove move : this.board.valid_moves) {
      ChessBoard copied = new ChessBoard(this.board);
      copied.makeMove(move);
      this.daughters.add(new ChessNode(copied, this, move));
    }
  }

  void evaluate(EvaluationAlgorithm algorithm) {
    if (this.evaluated) {
      return;
    }
    this.evaluated = true;
    switch(algorithm) {
      case NONE:
        this.base_evaluation = 0;
        break;
      case MATERIAL:
        this.base_evaluation = this.board.materialDifference();
        break;
    }
    // send base evaluation up to parent with last move
  }
}
