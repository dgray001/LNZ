class ChessAI {
  private ChessBoard board = new ChessBoard();

  ChessAI() {
  }

  void reset() {
    this.board = new ChessBoard();
  }

  void addMove(ChessMove move) {
    this.board.makeMove(move, false);
  }

  ChessMove getMove() {
    ArrayList<ChessMove> possible_moves = new ArrayList<ChessMove>(this.board.valid_moves);
    Collections.shuffle(possible_moves);
    return possible_moves.get(0);
  }
}
