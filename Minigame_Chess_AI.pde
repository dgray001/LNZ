enum DecisionAlgorithm {
  RANDOM;
}


class ChessAI {
  private ChessNode head_node;
  private DecisionAlgorithm decision_algorithm = DecisionAlgorithm.RANDOM;

  ChessAI() {
  }

  void reset() {
    this.head_node = new ChessNode(new ChessBoard(), null, null);
    this.head_node.board.setupBoard();
  }

  void addMove(ChessMove move) {
    ChessNode daughter = this.head_node.getDaughter(move);
    if (daughter == null) {
      global.errorMessage("ERROR: GameTree corrupted; can't find appropriate daughter node.");
      return;
    }
    this.head_node = daughter;
    this.head_node.parent = null;
    this.head_node.source_move = null;
    // update head node
  }

  ChessMove getMove() {
    ArrayList<ChessMove> possible_moves = new ArrayList<ChessMove>(this.head_node.board.valid_moves);
    if (possible_moves.size() == 0) {
      return null;
    }
    switch(this.decision_algorithm) {
      case RANDOM:
      default:
        Collections.shuffle(possible_moves);
        return possible_moves.get(0);
    }
  }
}


enum EvaluationAlgorithm {
  NONE, MATERIAL;
}


class ChessNode {
  private ChessNode parent = null;
  private ChessMove source_move = null;
  private ChessBoard board;
  private HashMap<ChessMove, ChessNode> daughters = new HashMap<ChessMove, ChessNode>();
  private boolean made_daughters = false;
  private boolean evaluated = false;
  private float base_evaluation = 0;
  private float evaluation = 0;

  ChessNode(ChessBoard board, ChessNode parent, ChessMove source_move) {
    this.board = board;
    this.parent = parent;
    this.source_move = source_move;
  }

  ChessNode getDaughter(ChessMove move) {
    if (!this.made_daughters) {
      if (this.board.valid_moves.contains(move)) {
        ChessBoard copied = new ChessBoard(this.board);
        copied.makeMove(move);
        return new ChessNode(copied, this, move);
      }
      else {
        return null;
      }
    }
    return this.daughters.get(move);
  }

  void makeDaughters() {
    if (this.made_daughters) {
      return;
    }
    if (!this.evaluated) {
      this.evaluate(EvaluationAlgorithm.NONE);
    }
    this.made_daughters = true;
    for (ChessMove move : this.board.valid_moves) {
      ChessBoard copied = new ChessBoard(this.board);
      copied.makeMove(move);
      this.daughters.put(move, new ChessNode(copied, this, move));
    }
  }

  void evaluate(EvaluationAlgorithm algorithm) {
    if (this.evaluated) {
      return;
    }
    this.evaluated = true;
    switch(algorithm) {
      case MATERIAL:
        this.base_evaluation = this.board.materialDifference();
        break;
      case NONE:
      default:
        this.base_evaluation = 0;
        break;
    }
    // send base evaluation up to parent with last move
  }
}
