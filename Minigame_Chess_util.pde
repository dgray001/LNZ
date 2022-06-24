enum ChessSetup {
  STANDARD;
}

class ChessBoard extends GridBoard {
  class ChessSquare extends BoardSquare {
    protected ChessColor square_color;
    protected boolean clicked = false;

    ChessSquare(IntegerCoordinate coordinate) {
      super(coordinate);
      this.square_color = ChessColor.colorFromSquare(coordinate);
    }

    void initializePieceMap() {
      this.pieces = new HashMap<Integer, GamePiece>();
    }

    ChessPiece getPiece() {
      for (GamePiece piece : this.pieces.values()) {
        return (ChessPiece)piece;
      }
      return null;
    }

    boolean canTakePiece(GamePiece piece) {
      if (piece == null || !ChessPiece.class.isInstance(piece)) {
        return false;
      }
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
        if (piece.remove) {
          continue;
        }
        image(piece.getImage(), this.button.xi, this.button.yi, this.button.xf, this.button.yf);
      }
      if ((this.clicked || this.button.clicked) && !this.empty()) {
        fill(200, 160);
        rect(this.button.xi, this.button.yi, this.button.xf, this.button.yf);
      }
      else if (this.button.hovered) {
        fill(120, 80);
        rect(this.button.xi, this.button.yi, this.button.xf, this.button.yf);
      }
    }

    void clicked() {
      ChessBoard.this.clicked(this.coordinate);
    }

    void released() {
      ChessBoard.this.released(this.coordinate);
    }
  }


  protected ChessSetup setup = null;
  protected ArrayList<ChessPiece> white_pieces = new ArrayList<ChessPiece>();
  protected ArrayList<ChessPiece> black_pieces = new ArrayList<ChessPiece>();
  protected ChessColor turn = ChessColor.WHITE;
  protected HashSet<ChessMove> valid_moves = new HashSet<ChessMove>();

  protected ArrayList<ChessMove> moves = new ArrayList<ChessMove>();

  protected IntegerCoordinate coordinate_dragging = null;
  protected IntegerCoordinate coordinate_clicked = null;

  ChessBoard() {
    super(8, 8);
    this.orientation = BoardOrientation.LEFT;
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
    this.valid_moves.clear();
    this.moves.clear();
    this.turn = ChessColor.WHITE;
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
    // calculate move
    this.startTurn(ChessColor.WHITE);
  }

  void nextTurn() {
    switch(this.turn) {
      case WHITE:
        this.startTurn(ChessColor.BLACK);
        break;
      case BLACK:
        this.startTurn(ChessColor.WHITE);
        break;
    }
  }
  void startTurn(ChessColor chess_color) {
    this.valid_moves.clear();
    switch(chess_color) {
      case WHITE:
        for (ChessPiece piece : this.white_pieces) {
          piece.updateMoveToSquares(this);
          this.valid_moves.addAll(piece.move_to_squares);
        }
        for (ChessPiece piece : this.black_pieces) {
          piece.move_to_squares.clear();
        }
        break;
      case BLACK:
        for (ChessPiece piece : this.white_pieces) {
          piece.move_to_squares.clear();
        }
        for (ChessPiece piece : this.black_pieces) {
          piece.updateMoveToSquares(this);
          this.valid_moves.addAll(piece.move_to_squares);
        }
        break;
    }
    this.turn = chess_color;
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

  void clicked(IntegerCoordinate coordinate) {
    if (coordinate == null) {
      return;
    }
    if (this.pieceAt(coordinate) != null) {
      this.coordinate_dragging = coordinate;
      //((ChessSquare)this.squareAt(coordinate)).clicked = true;
    }
  }

  void released(IntegerCoordinate coordinate) {
    if (coordinate == null) {
      return;
    }
    if (this.coordinate_clicked == null && this.pieceAt(coordinate) != null) {
      ChessSquare square = ((ChessSquare)this.squareAt(coordinate));
      if (square.button.hovered) {
        this.coordinate_clicked = coordinate;
        square.clicked = true;
        this.pieceAt(coordinate).updateMoveToSquares(this);
      }
      else {
        // use dragged
      }
    }
    else if (this.coordinate_clicked != null) {
      this.tryMovePiece(this.coordinate_clicked, coordinate);
      ((ChessSquare)this.squareAt(this.coordinate_clicked)).clicked = false;
      this.coordinate_clicked = null;
    }
  }

  void tryMovePiece(IntegerCoordinate source, IntegerCoordinate target) {
    ChessPiece source_piece = this.pieceAt(source);
    if (source_piece == null) {
      return;
    }
    ChessPiece target_piece = this.pieceAt(target);
    if (target_piece != null && target_piece.piece_color == source_piece.piece_color) {
      return;
    }
    ChessMove potential_move = new ChessMove(source, target, target_piece != null,
      source_piece.piece_color, source_piece.type);
    if (!this.valid_moves.contains(potential_move)) {
      return;
    }
    if (target_piece != null) {
      target_piece.remove = true;
      global.sounds.trigger_player("minigames/chess/capture");
    }
    else {
      global.sounds.trigger_player("minigames/chess/move");
    }
    this.squareAt(source).clearSquare();
    this.squareAt(target).addPiece(source_piece);
    this.moves.add(potential_move);
    this.nextTurn();
  }

  ChessPiece pieceAt(IntegerCoordinate coordinate) {
    BoardSquare square = this.squareAt(coordinate);
    if (square == null) {
      return null;
    }
    if (square.empty()) {
      return null;
    }
    return ((ChessSquare)square).getPiece();
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
  protected HashSet<ChessMove> move_to_squares = new HashSet<ChessMove>();

  ChessPiece(ChessPieceType type, ChessColor piece_color) {
    super();
    this.type = type;
    this.piece_color = piece_color;
  }

  PImage getImage() {
    return global.images.getImage("minigames/chess/" + this.piece_color.fileName() +
      "_" + this.type.fileName() + ".png");
  }

  void updateMoveToSquares(ChessBoard board) {
    this.move_to_squares.clear();
    switch(this.type) {
      case KING:
        for (IntegerCoordinate target : this.coordinate.adjacentAndCornerCoordinates()) {
          if (!board.contains(target)) {
            continue;
          }
          this.move_to_squares.add(new ChessMove(this.coordinate, target,
            !board.squareAt(target).empty(), this.piece_color, this.type));
        }
        break;
      case QUEEN:
        break;
      case ROOK:
        break;
      case BISHOP:
        break;
      case KNIGHT:
        break;
      case PAWN:
        break;
      default:
        break;
    }
  }
}


class ChessMove {
  private IntegerCoordinate source;
  private IntegerCoordinate target;
  private boolean capture;
  private ChessColor source_color;
  private ChessPieceType source_type;

  ChessMove(IntegerCoordinate source, IntegerCoordinate target, boolean capture,
    ChessColor source_color, ChessPieceType source_type) {
    this.source = source;
    this.target = target;
    this.capture = capture;
    this.source_color = source_color;
    this.source_type = source_type;
  }

  @Override
  public boolean equals(Object chessmove_object) {
    if (this == chessmove_object) {
      return true;
    }
    if (chessmove_object == null || this.getClass() != chessmove_object.getClass()) {
      return false;
    }
    ChessMove chessmove = (ChessMove)chessmove_object;
    if (this.source.equals(chessmove.source) && this.target.equals(chessmove.target) &&
      this.capture == chessmove.capture && this.source_color == chessmove.source_color &&
      this.source_type == chessmove.source_type) {
      return true;
    }
    return false;
  }
}
