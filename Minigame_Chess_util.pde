enum ChessSetup {
  STANDARD;
}

class ChessBoard extends GridBoard {
  protected ChessSetup setup = null;
  protected ArrayList<ChessPiece> white_pieces = new ArrayList<ChessPiece>();
  protected ArrayList<ChessPiece> black_pieces = new ArrayList<ChessPiece>();

  ChessBoard() {
    super(8, 8);
  }

  void initializePieceMap() {
    this.pieces = new HashMap<Integer, GamePiece>();
  }

  void initializeSquares() {
    for (int i = 0; i < this.squares.length; i++) {
      for (int j = 0; j < this.squares[i].length; j++) {
        this.squares[i][j] = new ChessSquare(new IntegerCoordinate(i, j));
      }
    }
  }

  void setupBoard() {
    this.setupBoard(ChessSetup.STANDARD);
  }
  void setupBoard(ChessSetup setup) {
    this.setup = setup;
    this.clearBoard();
    this.white_pieces.clear();
    this.black_pieces.clear();
    // White back-rank
    ChessPiece white_rook1 = new ChessPiece(ChessPieceType.ROOK, ChessColor.WHITE);
    this.addPiece(white_rook1, 0, 0);
    ChessPiece white_knight1 = new ChessPiece(ChessPieceType.KNIGHT, ChessColor.WHITE);
    this.addPiece(white_knight1, 0, 1);
    ChessPiece white_bishop1 = new ChessPiece(ChessPieceType.BISHOP, ChessColor.WHITE);
    this.addPiece(white_bishop1, 0, 2);
    ChessPiece white_queen1 = new ChessPiece(ChessPieceType.QUEEN, ChessColor.WHITE);
    this.addPiece(white_queen1, 0, 3);
    ChessPiece white_king1 = new ChessPiece(ChessPieceType.KING, ChessColor.WHITE);
    this.addPiece(white_king1, 0, 4);
    ChessPiece white_bishop2 = new ChessPiece(ChessPieceType.BISHOP, ChessColor.WHITE);
    this.addPiece(white_bishop2, 0, 5);
    ChessPiece white_knight2 = new ChessPiece(ChessPieceType.KNIGHT, ChessColor.WHITE);
    this.addPiece(white_knight2, 0, 6);
    ChessPiece white_rook2 = new ChessPiece(ChessPieceType.ROOK, ChessColor.WHITE);
    this.addPiece(white_rook2, 0, 7);
    // White pawns
    ChessPiece white_pawn1 = new ChessPiece(ChessPieceType.PAWN, ChessColor.WHITE);
    this.addPiece(white_pawn1, 1, 0);
    ChessPiece white_pawn2 = new ChessPiece(ChessPieceType.PAWN, ChessColor.WHITE);
    this.addPiece(white_pawn1, 1, 1);
    ChessPiece white_pawn3 = new ChessPiece(ChessPieceType.PAWN, ChessColor.WHITE);
    this.addPiece(white_pawn1, 1, 2);
    ChessPiece white_pawn4 = new ChessPiece(ChessPieceType.PAWN, ChessColor.WHITE);
    this.addPiece(white_pawn1, 1, 3);
    ChessPiece white_pawn5 = new ChessPiece(ChessPieceType.PAWN, ChessColor.WHITE);
    this.addPiece(white_pawn1, 1, 4);
    ChessPiece white_pawn6 = new ChessPiece(ChessPieceType.PAWN, ChessColor.WHITE);
    this.addPiece(white_pawn1, 1, 5);
    ChessPiece white_pawn7 = new ChessPiece(ChessPieceType.PAWN, ChessColor.WHITE);
    this.addPiece(white_pawn1, 1, 6);
    ChessPiece white_pawn8 = new ChessPiece(ChessPieceType.PAWN, ChessColor.WHITE);
    this.addPiece(white_pawn1, 1, 7);
    // Black back-rank
    // Black pawns
  }
}


class ChessSquare extends BoardSquare {
  ChessSquare(IntegerCoordinate coordinate) {
    super(coordinate);
  }

  void initializePieceMap() {
    this.pieces = new HashMap<Integer, GamePiece>();
  }

  boolean canTakePiece(GamePiece piece) {
    if (this.empty()) {
      return true;
    }
    return false;
  }
}


enum ChessPieceType {
  KING, QUEEN, ROOK, BISHOP, KNIGHT, PAWN;
}

enum ChessColor {
  WHITE, BLACK;
}

class ChessPiece extends GamePiece {
  protected ChessPieceType type;
  protected ChessColor piece_color;

  ChessPiece(ChessPieceType type, ChessColor piece_color) {
    super();
    this.type = type;
    this.piece_color = piece_color;
  }
}
