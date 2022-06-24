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
    this.addPiece(white_pawn2, 1, 1);
    ChessPiece white_pawn3 = new ChessPiece(ChessPieceType.PAWN, ChessColor.WHITE);
    this.addPiece(white_pawn3, 1, 2);
    ChessPiece white_pawn4 = new ChessPiece(ChessPieceType.PAWN, ChessColor.WHITE);
    this.addPiece(white_pawn4, 1, 3);
    ChessPiece white_pawn5 = new ChessPiece(ChessPieceType.PAWN, ChessColor.WHITE);
    this.addPiece(white_pawn5, 1, 4);
    ChessPiece white_pawn6 = new ChessPiece(ChessPieceType.PAWN, ChessColor.WHITE);
    this.addPiece(white_pawn6, 1, 5);
    ChessPiece white_pawn7 = new ChessPiece(ChessPieceType.PAWN, ChessColor.WHITE);
    this.addPiece(white_pawn7, 1, 6);
    ChessPiece white_pawn8 = new ChessPiece(ChessPieceType.PAWN, ChessColor.WHITE);
    this.addPiece(white_pawn8, 1, 7);
    // Black back-rank
    ChessPiece black_rook1 = new ChessPiece(ChessPieceType.ROOK, ChessColor.BLACK);
    this.addPiece(black_rook1, 7, 0);
    ChessPiece black_knight1 = new ChessPiece(ChessPieceType.KNIGHT, ChessColor.BLACK);
    this.addPiece(black_knight1, 7, 1);
    ChessPiece black_bishop1 = new ChessPiece(ChessPieceType.BISHOP, ChessColor.BLACK);
    this.addPiece(black_bishop1, 7, 2);
    ChessPiece black_queen1 = new ChessPiece(ChessPieceType.QUEEN, ChessColor.BLACK);
    this.addPiece(black_queen1, 7, 3);
    ChessPiece black_king1 = new ChessPiece(ChessPieceType.KING, ChessColor.BLACK);
    this.addPiece(black_king1, 7, 4);
    ChessPiece black_bishop2 = new ChessPiece(ChessPieceType.BISHOP, ChessColor.BLACK);
    this.addPiece(black_bishop2, 7, 5);
    ChessPiece black_knight2 = new ChessPiece(ChessPieceType.KNIGHT, ChessColor.BLACK);
    this.addPiece(black_knight2, 7, 6);
    ChessPiece black_rook2 = new ChessPiece(ChessPieceType.ROOK, ChessColor.BLACK);
    this.addPiece(black_rook2, 7, 7);
    // Black pawns
    ChessPiece black_pawn1 = new ChessPiece(ChessPieceType.PAWN, ChessColor.BLACK);
    this.addPiece(black_pawn1, 6, 0);
    ChessPiece black_pawn2 = new ChessPiece(ChessPieceType.PAWN, ChessColor.BLACK);
    this.addPiece(black_pawn2, 6, 1);
    ChessPiece black_pawn3 = new ChessPiece(ChessPieceType.PAWN, ChessColor.BLACK);
    this.addPiece(black_pawn3, 6, 2);
    ChessPiece black_pawn4 = new ChessPiece(ChessPieceType.PAWN, ChessColor.BLACK);
    this.addPiece(black_pawn4, 6, 3);
    ChessPiece black_pawn5 = new ChessPiece(ChessPieceType.PAWN, ChessColor.BLACK);
    this.addPiece(black_pawn5, 6, 4);
    ChessPiece black_pawn6 = new ChessPiece(ChessPieceType.PAWN, ChessColor.BLACK);
    this.addPiece(black_pawn6, 6, 5);
    ChessPiece black_pawn7 = new ChessPiece(ChessPieceType.PAWN, ChessColor.BLACK);
    this.addPiece(black_pawn7, 6, 6);
    ChessPiece black_pawn8 = new ChessPiece(ChessPieceType.PAWN, ChessColor.BLACK);
    this.addPiece(black_pawn8, 6, 7);
  }

  void addedPiece(GamePiece piece) {
    if (!ChessPiece.class.isInstance(piece)) {
      global.errorMessage("ERROR: Piece with class " + piece.getClass() + " not a chess piece.");
      return;
    }
    ChessPiece chess_piece = (ChessPiece)piece;
    switch(chess_piece.piece_color) {
      case WHITE:
        this.white_pieces.add(chess_piece);
        break;
      case BLACK:
        this.black_pieces.add(chess_piece);
        break;
      default:
        global.errorMessage("ERROR: Chess piece color " + chess_piece.piece_color + " not recognized.");
        break;
    }
  }

  void drawBoard() {
  }
}


class ChessSquare extends BoardSquare {
  protected ChessColor square_color;

  ChessSquare(IntegerCoordinate coordinate) {
    super(coordinate);
    this.square_color = ChessColor.colorFromSquare(coordinate);
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

  void drawSquare() {
    rectMode(CORNERS);
    noStroke();
    strokeWeight(0.01);
    switch(this.square_color) {
      case WHITE:
        fill(248, 240, 227);
        break;
      case BLACK:
        fill(165,42,42);
        break;
    }
    rect(this.button.xi, this.button.yi, this.button.xf, this.button.yf);
    imageMode(CORNERS);
    for (GamePiece piece : this.pieces.values()) {
      image(piece.getImage(), this.button.xi, this.button.yi, this.button.xf, this.button.yf);
    }
    if (this.button.clicked) {
      fill(200, 160);
      rect(this.button.xi, this.button.yi, this.button.xf, this.button.yf);
    }
    else if (this.button.hovered) {
      fill(120, 80);
      rect(this.button.xi, this.button.yi, this.button.xf, this.button.yf);
    }
  }
}


enum ChessPieceType {
  KING, QUEEN, ROOK, BISHOP, KNIGHT, PAWN;

  public String fileName() {
    return ChessPieceType.fileName(this);
  }
  public static String fileName(ChessPieceType type) {
    switch(type) {
      case KING:
        return "king";
      case QUEEN:
        return "queen";
      case ROOK:
        return "rook";
      case BISHOP:
        return "bishop";
      case KNIGHT:
        return "knight";
      case PAWN:
        return "pawn";
      default:
        return "";
    }
  }
}

enum ChessColor {
  WHITE, BLACK;

  public String fileName() {
    return ChessColor.fileName(this);
  }
  public static String fileName(ChessColor type) {
    switch(type) {
      case WHITE:
        return "white";
      case BLACK:
        return "black";
      default:
        return "";
    }
  }

  public static ChessColor colorFromSquare(IntegerCoordinate coordinate) {
    if ((coordinate.x + coordinate.y) % 2 == 0) {
      return ChessColor.BLACK;
    }
    return ChessColor.WHITE;
  }
}

class ChessPiece extends GamePiece {
  protected ChessPieceType type;
  protected ChessColor piece_color;

  ChessPiece(ChessPieceType type, ChessColor piece_color) {
    super();
    this.type = type;
    this.piece_color = piece_color;
  }

  PImage getImage() {
    return global.images.getImage("minigames/chess/" + this.piece_color.fileName() +
      "_" + this.type.fileName() + ".png");
  }
}
