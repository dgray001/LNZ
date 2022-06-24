abstract class GridBoard {
  protected BoardSquare[][] squares;
  protected HashMap<Integer, GamePiece> pieces;
  protected int next_piece_key = 1;

  GridBoard(int w, int h) {
    this.squares = new BoardSquare[w][h];
    this.initializeSquares();
  }

  abstract void initializePieceMap();
  abstract void initializeSquares();

  void clearBoard() {
    for (int i = 0; i < this.squares.length; i++) {
      for (int j = 0; j < this.squares[i].length; j++) {
        this.squares[i][j].clearSquare();
      }
    }
  }

  void addPiece(GamePiece piece, IntegerCoordinate coordinate) {
    this.addPiece(piece, coordinate.x, coordinate.y);
  }
  void addPiece(GamePiece piece, int x, int y) {
    if (x < 0 || y < 0 || x >= this.boardWidth() || y >= this.boardHeight()) {
      return;
    }
    if (!this.squares[x][y].canTakePiece(piece)) {
      return;
    }
    piece.board_key = this.next_piece_key;
    this.pieces.put(this.next_piece_key, piece);
    this.squares[x][y].addPiece(piece);
    this.next_piece_key++;
  }
}


abstract class BoardSquare {
  protected IntegerCoordinate coordinate;
  protected HashMap<Integer, GamePiece> pieces;

  BoardSquare(IntegerCoordinate coordinate) {
    this.coordinate = coordinate;
    this.initializePieceMap();
  }

  abstract void initializePieceMap();

  void clearSquare() {
    this.pieces.clear();
  }

  void addPiece(GamePiece piece) {
    if (this.pieces.containsKey(piece.board_key) {
      return;
    }
    this.pieces.put(piece.board_key, piece);
    piece.coordinate = new IntegerCoordinate(this.coordinate.x, this.coordinate.y);
  }

  abstract boolean canTakePiece(GamePiece piece);

  boolean empty() {
    return this.pieces.isEmtpy();
  }
}


abstract class GamePiece {
  protected int board_key = -1;
  protected IntegerCoordinate coordinate = new IntegerCoordinate(0, 0);

  BoardPiece() {
  }

  PImage getImage();
}
