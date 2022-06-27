enum ChessSetup {
  STANDARD;
}

enum HumanMovable {
  NONE, WHITE, BLACK, BOTH;
}

enum GameEnds {
  WHITE_CHECKMATES, BLACK_CHECKMATES, STALEMATE, REPETITION, FIFTY_MOVE,
  WHITE_TIME, BLACK_TIME; // abandonment, resignation, agree to draw

  public String displayName() {
    return GameEnds.displayName(this);
  }
  public static String displayName(GameEnds end) {
    switch(end) {
      case WHITE_CHECKMATES:
        return "Checkmate - White is Victorious";
      case BLACK_CHECKMATES:
        return "Checkmate - Black is Victorious";
      case STALEMATE:
        return "Stalemate - Draw";
      case REPETITION:
        return "Repetition - Draw";
      case FIFTY_MOVE:
        return "Fifty Move rule - Draw";
      case WHITE_TIME:
        return "White time out - Black is Victorious";
      case BLACK_TIME:
        return "Black time out - White is Victorious";
      default:
        return "Error";
    }
  }

  public int points() {
    return GameEnds.points(this);
  }
  public static int points(GameEnds end) {
    switch(end) {
      case WHITE_CHECKMATES:
        return 1;
      case BLACK_CHECKMATES:
        return -1;
      case STALEMATE:
        return 0;
      case REPETITION:
        return 0;
      case FIFTY_MOVE:
        return 0;
      case WHITE_TIME:
        return -1;
      case BLACK_TIME:
        return 1;
      default:
        return 0;
    }
  }
}

class ChessBoard extends GridBoard {
  class ChessSquare extends BoardSquare {
    protected ChessColor square_color;
    protected boolean clicked = false;
    protected boolean can_move_to = false;

    ChessSquare(IntegerCoordinate coordinate) {
      super(coordinate);
      this.square_color = ChessColor.colorFromSquare(coordinate);
    }
    ChessSquare copy() {
      ChessSquare square = new ChessSquare(this.coordinate.copy());
      square.square_color = this.square_color;
      square.clicked = this.clicked;
      square.can_move_to = this.can_move_to;
      return square;
    }

    void initializePieceMap() {
      this.pieces = new HashMap<Integer, GamePiece>();
    }

    ChessPiece getPiece() {
      for (GamePiece piece : this.pieces.values()) {
        if (piece == null || piece.remove) {
          continue;
        }
        return (ChessPiece)piece;
      }
      return null;
    }

    boolean canTakePiece(GamePiece piece) {
      if (piece == null || piece.remove || !ChessPiece.class.isInstance(piece)) {
        return false;
      }
      if (this.empty()) {
        return true;
      }
      return false;
    }

    void drawSquare() {
      rectMode(CORNERS);
      stroke(0, 1);
      switch(this.square_color) {
        case WHITE:
          fill(248, 240, 227);
          break;
        case BLACK:
          fill(165, 42, 42);
          break;
      }
      rect(this.button.xi, this.button.yi, this.button.xf, this.button.yf);
      imageMode(CORNERS);
      for (GamePiece piece : this.pieces.values()) {
        if (piece == null || piece.remove) {
          continue;
        }
        image(piece.getImage(), this.button.xi, this.button.yi, this.button.xf, this.button.yf);
      }
      if (this.can_move_to) {
        ellipseMode(CENTER);
        if (this.empty()) {
          fill(200, 160);
          stroke(200, 160);
          circle(this.button.xCenter(), this.button.yCenter(), 0.3 * this.button.button_width());
        }
        else {
          fill(0, 1);
          stroke(200, 160);
          strokeWeight(6);
          circle(this.button.xCenter(), this.button.yCenter(), this.button.button_width());
        }
      }
      if ((this.clicked || this.button.clicked) && !this.empty()) {
        fill(200, 160);
        stroke(200, 160);
        rect(this.button.xi, this.button.yi, this.button.xf, this.button.yf);
      }
      else if (this.button.hovered) {
        fill(120, 80);
        stroke(120, 80);
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
  protected HumanMovable human_controlled = HumanMovable.BOTH;
  protected ArrayList<ChessPiece> white_pieces = new ArrayList<ChessPiece>();
  protected ArrayList<ChessPiece> black_pieces = new ArrayList<ChessPiece>();

  protected ChessColor turn = ChessColor.WHITE;
  protected HashSet<ChessMove> valid_moves = new HashSet<ChessMove>();
  protected HashSet<ChessMove> return_moves = new HashSet<ChessMove>();
  protected boolean calculate_return_moves = true;

  protected ChessColor in_check = null;
  protected ArrayList<ChessMove> moves = new ArrayList<ChessMove>();
  protected Queue<ChessMove> move_queue = new ArrayDeque<ChessMove>();
  protected GameEnds game_ended = null; // null until game ends

  protected IntegerCoordinate coordinate_dragging = null;
  protected IntegerCoordinate coordinate_clicked = null;

  ChessBoard() {
    super(8, 8);
    this.orientation = BoardOrientation.RIGHT;
  }
  ChessBoard(ChessBoard board) {
    super(8, 8);
    this.orientation = board.orientation;
    this.next_piece_key = board.next_piece_key;
    this.setup = board.setup;
    this.turn = board.turn;
    this.calculate_return_moves = board.calculate_return_moves;
    this.in_check = board.in_check;
    if (board.coordinate_dragging == null) {
      this.coordinate_dragging = null;
    }
    else {
      this.coordinate_dragging = board.coordinate_dragging.copy();
    }
    if (board.coordinate_clicked == null) {
      this.coordinate_clicked = null;
    }
    else {
      this.coordinate_clicked = board.coordinate_clicked.copy();
    }
    for (int i = 0; i < this.squares.length; i++) {
      for (int j = 0; j < this.squares[i].length; j++) {
        this.squares[i][j] = ((ChessSquare)board.squares[i][j]).copy();
      }
    }
    for (GamePiece piece : board.pieces.values()) {
      this.addPiece(((ChessPiece)piece).copy(), piece.coordinate.x, piece.coordinate.y, piece.board_key);
    }
    for (ChessMove move : board.valid_moves) {
      this.valid_moves.add(move.copy());
    }
    for (ChessMove move : board.return_moves) {
      this.return_moves.add(move.copy());
    }
    for (ChessMove move : board.moves) {
      this.moves.add(move.copy());
    }
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
    this.move_queue.clear();
    this.game_ended = null;
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

  int materialDifference() {
    return this.whiteMaterial() - this.blackMaterial();
  }

  int whiteMaterial() {
    int material = 0;
    for (ChessPiece piece : this.white_pieces) {
      if (piece == null || piece.remove) {
        continue;
      }
      material += piece.type.material();
    }
    return material;
  }

  int blackMaterial() {
    int material = 0;
    for (ChessPiece piece : this.black_pieces) {
      if (piece == null || piece.remove) {
        continue;
      }
      material += piece.type.material();
    }
    return material;
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
    this.return_moves.clear();
    this.turn = chess_color;
    this.in_check = null;
    switch(chess_color) {
      case WHITE:
        for (ChessPiece piece : this.black_pieces) {
          if (piece.remove) {
            continue;
          }
          if (this.calculate_return_moves) {
            piece.updateValidMoves(this, true);
            this.return_moves.addAll(piece.valid_moves);
          }
          piece.valid_moves.clear();
        }
        if (this.inCheck()) {
          this.in_check = chess_color;
        }
        for (ChessPiece piece : this.white_pieces) {
          if (piece.remove) {
            continue;
          }
          piece.updateValidMoves(this, !this.calculate_return_moves);
          this.valid_moves.addAll(piece.valid_moves);
        }
        break;
      case BLACK:
        for (ChessPiece piece : this.white_pieces) {
          if (piece.remove) {
            continue;
          }
          if (this.calculate_return_moves) {
            piece.updateValidMoves(this, true);
            this.return_moves.addAll(piece.valid_moves);
          }
          piece.valid_moves.clear();
        }
        if (this.inCheck()) {
          this.in_check = chess_color;
        }
        for (ChessPiece piece : this.black_pieces) {
          if (piece.remove) {
            continue;
          }
          piece.updateValidMoves(this, !this.calculate_return_moves);
          this.valid_moves.addAll(piece.valid_moves);
        }
        break;
    }
    if (this.valid_moves.size() == 0) { // game over
      switch(this.in_check) {
        case WHITE:
          this.game_ended = GameEnds.BLACK_CHECKMATES;
          break;
        case BLACK:
          this.game_ended = GameEnds.WHITE_CHECKMATES;
          break;
        default:
          this.game_ended = GameEnds.STALEMATE;
          break;
      }
    }
  }

  boolean inCheck() {
    for (ChessMove move : this.return_moves) {
      if (move.capture && this.pieceAt(move.target) != null &&
        this.pieceAt(move.target).type == ChessPieceType.KING) {
        return true;
      }
    }
    return false;
  }

  boolean canTakeKing() {
    for (ChessMove move : this.valid_moves) {
      if (move.capture && this.pieceAt(move.target) != null &&
        this.pieceAt(move.target).type == ChessPieceType.KING) {
        return true;
      }
    }
    return false;
  }

  boolean humanCanMakeMove() {
    switch(this.human_controlled) {
      case NONE:
        return false;
      case WHITE:
        return this.turn == ChessColor.WHITE;
      case BLACK:
        return this.turn == ChessColor.BLACK;
      case BOTH:
        return true;
    }
    return false;
  }

  boolean computersTurn() {
    if (this.valid_moves.size() == 0) {
      return false;
    }
    switch(this.human_controlled) {
      case NONE:
        return true;
      case WHITE:
        return this.turn != ChessColor.WHITE;
      case BLACK:
        return this.turn != ChessColor.BLACK;
      case BOTH:
        return false;
    }
    return false;
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

  void afterUpdate() {
    for (int i = 0; i < this.white_pieces.size(); i++) {
      if (this.white_pieces.get(i).remove) {
        this.white_pieces.remove(i);
        i--;
      }
    }
    for (int i = 0; i < this.black_pieces.size(); i++) {
      if (this.black_pieces.get(i).remove) {
        this.black_pieces.remove(i);
        i--;
      }
    }
  }

  void clicked(IntegerCoordinate coordinate) {
    if (!this.humanCanMakeMove()) {
      return;
    }
    if (coordinate == null) {
      return;
    }
    if (this.pieceAt(coordinate) != null) {
      this.coordinate_dragging = coordinate;
      //((ChessSquare)this.squareAt(coordinate)).clicked = true;
    }
  }

  void released(IntegerCoordinate coordinate) {
    if (!this.humanCanMakeMove()) {
      return;
    }
    if (coordinate == null) {
      return;
    }
    ChessPiece piece = this.pieceAt(coordinate);
    if (this.coordinate_clicked == null && piece != null && piece.piece_color == this.turn) {
      ChessSquare square = ((ChessSquare)this.squareAt(coordinate));
      if (square.button.hovered) {
        this.coordinate_clicked = coordinate;
        square.clicked = true;
      }
      else {
        // use dragged
      }
    }
    else if (piece != null && piece.piece_color == this.turn) {
      ChessSquare square = ((ChessSquare)this.squareAt(coordinate));
      if (square.button.hovered) {
        ((ChessSquare)this.squareAt(this.coordinate_clicked)).clicked = false;
        this.coordinate_clicked = coordinate;
        square.clicked = true;
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
    this.updateSquaresMarked();
  }

  void updateSquaresMarked() {
    boolean all_false = false;
    ChessPiece piece = this.pieceAt(this.coordinate_clicked);
    if (piece == null) {
      all_false = true;
    }
    for (BoardSquare[] squares_row : this.squares) {
      for (BoardSquare board_square : squares_row) {
        ChessSquare square = (ChessSquare)board_square;
        if (all_false) {
          square.can_move_to = false;
          continue;
        }
        square.can_move_to = piece.canMoveTo(square.coordinate);
      }
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
    if (target_piece == null) { // check for en passant
      if (source_piece.type == ChessPieceType.PAWN && source.y != target.y) {
        target_piece = this.pieceAt(new IntegerCoordinate(source.x, target.y));
      }
    }
    ChessMove potential_move = new ChessMove(source, target, target_piece != null,
      source_piece.piece_color, source_piece.type);
    if (!this.valid_moves.contains(potential_move)) {
      return;
    }
    this.makeMove(potential_move);
  }

  void makeRandomMove() {
    ArrayList<ChessMove> possible_moves = new ArrayList<ChessMove>(this.valid_moves);
    Collections.shuffle(possible_moves);
    this.makeMove(possible_moves.get(0));
  }

  void makeMove(ChessMove move) {
    this.makeMove(move, true);
  }
  void makeMove(ChessMove move, boolean play_sound) {
    ChessPiece source_piece = this.pieceAt(move.source);
    if (source_piece == null) {
      return;
    }
    ChessPiece target_piece = this.pieceAt(move.target);
    if (target_piece != null && target_piece.piece_color == source_piece.piece_color) {
      return;
    }
    if (target_piece == null) { // check for en passant
      if (source_piece.type == ChessPieceType.PAWN && move.source.y != move.target.y) {
        target_piece = this.pieceAt(new IntegerCoordinate(move.source.x, move.target.y));
      }
    }
    if (target_piece != null) {
      target_piece.remove = true;
      if (play_sound) {
        global.sounds.trigger_player("minigames/chess/capture");
      }
    }
    else {
      if (move.castlingMove()) { // check for castling
        IntegerCoordinate rook_source = move.castlingMoveRookSource(this);
        ChessPiece rook = this.pieceAt(rook_source);
        if (rook == null || rook.remove || rook.piece_color != source_piece.piece_color ||
          rook.type != ChessPieceType.ROOK || rook.has_moved) {
          global.errorMessage("ERROR: Can't castle with invalid rook.");
          return;
        }
        IntegerCoordinate rook_target = move.castlingMoveRookTarget();
        BoardSquare rook_target_square = this.squareAt(rook_target);
        if (rook_source == null || rook_target == null || !rook_target_square.empty()) {
          global.errorMessage("ERROR: Can't castle with invalid rook squares.");
          return;
        }
        rook.last_coordinate = rook.coordinate.copy();
        rook.has_moved = true;
        this.squareAt(rook_source).clearSquare();
        rook_target_square.addPiece(rook);
      }
      if (play_sound) {
        global.sounds.trigger_player("minigames/chess/move");
      }
    }
    source_piece.last_coordinate = source_piece.coordinate.copy();
    source_piece.has_moved = true;
    this.squareAt(move.source).clearSquare();
    this.squareAt(move.target).addPiece(source_piece);
    this.moves.add(move);
    this.move_queue.add(move);
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
    ChessPiece piece = ((ChessSquare)square).getPiece();
    if (piece != null && piece.remove) {
      piece = null;
    }
    return piece;
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

  public int material() {
    return ChessPieceType.material(this);
  }
  public static int material(ChessPieceType type) {
    switch(type) {
      case KING:
        return 0;
      case QUEEN:
        return 8;
      case ROOK:
        return 5;
      case BISHOP:
        return 3;
      case KNIGHT:
        return 3;
      case PAWN:
        return 1;
      default:
        return 0;
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
  protected HashSet<ChessMove> valid_moves = new HashSet<ChessMove>();
  protected boolean has_moved = false;
  protected IntegerCoordinate last_coordinate = null;

  ChessPiece(ChessPieceType type, ChessColor piece_color) {
    super();
    this.type = type;
    this.piece_color = piece_color;
  }
  ChessPiece copy() {
    ChessPiece piece = new ChessPiece(this.type, this.piece_color);
    piece.board_key = this.board_key;
    piece.remove = this.remove;
    piece.coordinate = this.coordinate.copy();
    piece.has_moved = this.has_moved;
    if (this.last_coordinate == null) {
      piece.last_coordinate = null;
    }
    else {
      piece.last_coordinate = this.last_coordinate.copy();
    }
    for (ChessMove move : this.valid_moves) {
      piece.valid_moves.add(move.copy());
    }
    return piece;
  }

  PImage getImage() {
    return global.images.getImage("minigames/chess/" + this.piece_color.fileName() +
      "_" + this.type.fileName() + ".png");
  }

  boolean canMoveTo(IntegerCoordinate coordinate) {
    for (ChessMove move : this.valid_moves) {
      if (move.target.equals(coordinate)) {
        return true;
      }
    }
    return false;
  }

  void updateValidMoves(ChessBoard board) {
    this.updateValidMoves(board, false);
  }
  void updateValidMoves(ChessBoard board, boolean ignore_check) {
    this.valid_moves.clear();
    if (this.remove) {
      return;
    }
    switch(this.type) {
      case KING:
        for (IntegerCoordinate target : this.coordinate.adjacentAndCornerCoordinates()) {
          if (!board.contains(target)) {
            continue;
          }
          ChessPiece target_piece = board.pieceAt(target);
          if (target_piece != null && target_piece.piece_color == this.piece_color) {
            continue;
          }
          this.valid_moves.add(new ChessMove(this.coordinate, target,
            target_piece != null, this.piece_color, this.type));
        }
        this.addCastlingMoves(board);
        break;
      case QUEEN:
        this.addBishopMoves(board);
        this.addRookMoves(board);
        break;
      case ROOK:
        this.addRookMoves(board);
        break;
      case BISHOP:
        this.addBishopMoves(board);
        break;
      case KNIGHT:
        for (IntegerCoordinate target : this.coordinate.knightMoves()) {
          if (!board.contains(target)) {
            continue;
          }
          ChessPiece target_piece = board.pieceAt(target);
          if (target_piece != null && target_piece.piece_color == this.piece_color) {
            continue;
          }
          this.valid_moves.add(new ChessMove(this.coordinate, target,
            target_piece != null, this.piece_color, this.type));
        }
        break;
      case PAWN:
        IntegerCoordinate move1 = null;
        IntegerCoordinate capture_left = null;
        IntegerCoordinate capture_right = null;
        IntegerCoordinate capture_left_en_passant = null;
        IntegerCoordinate capture_right_en_passant = null;
        IntegerCoordinate move2 = null;
        switch(this.piece_color) {
          case WHITE:
            move1 = new IntegerCoordinate(this.coordinate.x + 1, this.coordinate.y);
            capture_left = new IntegerCoordinate(this.coordinate.x + 1, this.coordinate.y + 1);
            capture_left_en_passant = new IntegerCoordinate(this.coordinate.x, this.coordinate.y + 1);
            capture_right = new IntegerCoordinate(this.coordinate.x + 1, this.coordinate.y - 1);
            capture_right_en_passant = new IntegerCoordinate(this.coordinate.x, this.coordinate.y - 1);
            if (!this.has_moved) {
              move2 = new IntegerCoordinate(this.coordinate.x + 2, this.coordinate.y);
            }
            break;
          case BLACK:
            move1 = new IntegerCoordinate(this.coordinate.x - 1, this.coordinate.y);
            capture_left = new IntegerCoordinate(this.coordinate.x - 1, this.coordinate.y + 1);
            capture_left_en_passant = new IntegerCoordinate(this.coordinate.x, this.coordinate.y + 1);
            capture_right = new IntegerCoordinate(this.coordinate.x - 1, this.coordinate.y - 1);
            capture_right_en_passant = new IntegerCoordinate(this.coordinate.x, this.coordinate.y - 1);
            if (!this.has_moved) {
              move2 = new IntegerCoordinate(this.coordinate.x - 2, this.coordinate.y);
            }
            break;
        }
        boolean move1_valid = false;
        if (move1 != null) {
          ChessPiece target_piece = board.pieceAt(move1);
          if (board.contains(move1) && (target_piece == null || target_piece.remove)) {
            this.valid_moves.add(new ChessMove(this.coordinate, move1, false,
              this.piece_color, this.type));
            move1_valid = true;
          }
        }
        if (capture_left != null) {
          ChessPiece target_piece = board.pieceAt(capture_left);
          if (target_piece == null || target_piece.remove) {
            ChessPiece maybe_target_piece = board.pieceAt(capture_left_en_passant);
            if (maybe_target_piece != null && maybe_target_piece.type == ChessPieceType.
              PAWN && maybe_target_piece.has_moved && abs(maybe_target_piece.
              coordinate.x - maybe_target_piece.last_coordinate.x) == 2) {
              target_piece = maybe_target_piece;
            }
          }
          if (board.contains(capture_left) && target_piece != null && target_piece.piece_color != this.piece_color) {
            this.valid_moves.add(new ChessMove(this.coordinate, capture_left, true,
              this.piece_color, this.type));
          }
        }
        if (capture_right != null) {
          ChessPiece target_piece = board.pieceAt(capture_right);
          if (target_piece == null || target_piece.remove) {
            ChessPiece maybe_target_piece = board.pieceAt(capture_right_en_passant);
            if (maybe_target_piece != null && maybe_target_piece.type == ChessPieceType.
              PAWN && maybe_target_piece.has_moved && abs(maybe_target_piece.
              coordinate.x - maybe_target_piece.last_coordinate.x) == 2) {
              target_piece = maybe_target_piece;
            }
          }
          if (board.contains(capture_right) && target_piece != null && target_piece.piece_color != this.piece_color) {
            this.valid_moves.add(new ChessMove(this.coordinate, capture_right, true,
              this.piece_color, this.type));
          }
        }
        if (move2 != null && move1_valid) {
          ChessPiece target_piece = board.pieceAt(move2);
          if (board.contains(move2) && target_piece == null) {
            this.valid_moves.add(new ChessMove(this.coordinate, move2, false,
              this.piece_color, this.type));
          }
        }
        break;
      default:
        break;
    }
    if (ignore_check) {
      return;
    }
    for (Iterator<ChessMove> i = this.valid_moves.iterator(); i.hasNext();) {
      ChessMove move = i.next();
      ChessBoard copied_board = new ChessBoard(board);
      copied_board.calculate_return_moves = false;
      copied_board.makeMove(move, false);
      if (copied_board.canTakeKing()) {
        i.remove();
      }
    }
  }

  void addCastlingMoves(ChessBoard board) {
    if (this.has_moved) {
      return;
    }
    ChessPiece[] rooks = new ChessPiece[2];
    rooks[0] = board.pieceAt(new IntegerCoordinate(this.coordinate.x, 0));
    rooks[1] = board.pieceAt(new IntegerCoordinate(this.coordinate.x, board.boardHeight() - 1));
    for (ChessPiece rook : rooks) {
      if (rook == null || rook.remove || rook.piece_color != this.piece_color ||
        rook.type != ChessPieceType.ROOK || rook.has_moved) {
        continue;
      }
      if (board.in_check == this.piece_color) {
        continue;
      }
      int direction = 1;
      if (rook.coordinate.y < this.coordinate.y) {
        direction = -1;
      }
      boolean blocking = false;
      for (int i = this.coordinate.y + direction; (i > 0 && i < board.boardHeight() - 1); i += direction) {
        ChessPiece piece = board.pieceAt(new IntegerCoordinate(this.coordinate.x, i));
        if (piece == null || piece.remove) {
          continue;
        }
        blocking = true;
        break;
      }
      if (blocking) {
        continue;
      }
      ChessMove through_check_check = new ChessMove(this.coordinate, new IntegerCoordinate(
        this.coordinate.x, this.coordinate.y + direction), false, this.piece_color, this.type);
      ChessBoard copied_board = new ChessBoard(board);
      copied_board.calculate_return_moves = false;
      copied_board.makeMove(through_check_check, false);
      if (copied_board.canTakeKing()) {
        continue;
      }
      this.valid_moves.add(new ChessMove(this.coordinate, new IntegerCoordinate(
        this.coordinate.x, this.coordinate.y + 2 * direction), false, this.piece_color, this.type));
    }
  }

  void addBishopMoves(ChessBoard board) {
    for (int x = this.coordinate.x + 1, y = this.coordinate.y + 1; (x <
      board.boardWidth() && y < board.boardHeight()); x++, y++) {
      IntegerCoordinate target = new IntegerCoordinate(x, y);
      if (!board.contains(target)) {
        break;
      }
      ChessPiece target_piece = board.pieceAt(target);
      if (target_piece == null || target_piece.remove || target_piece.piece_color != this.piece_color) {
        this.valid_moves.add(new ChessMove(this.coordinate, target,
          (target_piece != null && !target_piece.remove), this.piece_color, this.type));
      }
      if (target_piece != null && !target_piece.remove) {
        break;
      }
    }
    for (int x = this.coordinate.x + 1, y = this.coordinate.y - 1; x <
      board.boardWidth() && y >= 0; x++, y--) {
      IntegerCoordinate target = new IntegerCoordinate(x, y);
      if (!board.contains(target)) {
        break;
      }
      ChessPiece target_piece = board.pieceAt(target);
      if (target_piece == null || target_piece.remove || target_piece.piece_color != this.piece_color) {
        this.valid_moves.add(new ChessMove(this.coordinate, target,
          (target_piece != null && !target_piece.remove), this.piece_color, this.type));
      }
      if (target_piece != null && !target_piece.remove) {
        break;
      }
    }
    for (int x = this.coordinate.x - 1, y = this.coordinate.y + 1; x
      >= 0 && y < board.boardHeight(); x--, y++) {
      IntegerCoordinate target = new IntegerCoordinate(x, y);
      if (!board.contains(target)) {
        break;
      }
      ChessPiece target_piece = board.pieceAt(target);
      if (target_piece == null || target_piece.remove || target_piece.piece_color != this.piece_color) {
        this.valid_moves.add(new ChessMove(this.coordinate, target,
          (target_piece != null && !target_piece.remove), this.piece_color, this.type));
      }
      if (target_piece != null && !target_piece.remove) {
        break;
      }
    }
    for (int x = this.coordinate.x - 1, y = this.coordinate.y - 1; x >= 0 && y >= 0; x--, y--) {
      IntegerCoordinate target = new IntegerCoordinate(x, y);
      if (!board.contains(target)) {
        break;
      }
      ChessPiece target_piece = board.pieceAt(target);
      if (target_piece == null || target_piece.remove || target_piece.piece_color != this.piece_color) {
        this.valid_moves.add(new ChessMove(this.coordinate, target,
          (target_piece != null && !target_piece.remove), this.piece_color, this.type));
      }
      if (target_piece != null && !target_piece.remove) {
        break;
      }
    }
  }

  void addRookMoves(ChessBoard board) {
    for (int x = this.coordinate.x + 1, y = this.coordinate.y; x < board.boardWidth(); x++) {
      IntegerCoordinate target = new IntegerCoordinate(x, y);
      if (!board.contains(target)) {
        break;
      }
      ChessPiece target_piece = board.pieceAt(target);
      if (target_piece == null || target_piece.remove || target_piece.piece_color != this.piece_color) {
        this.valid_moves.add(new ChessMove(this.coordinate, target,
          (target_piece != null && !target_piece.remove), this.piece_color, this.type));
      }
      if (target_piece != null && !target_piece.remove) {
        break;
      }
    }
    for (int x = this.coordinate.x, y = this.coordinate.y + 1; y < board.boardHeight(); y++) {
      IntegerCoordinate target = new IntegerCoordinate(x, y);
      if (!board.contains(target)) {
        break;
      }
      ChessPiece target_piece = board.pieceAt(target);
      if (target_piece == null || target_piece.remove || target_piece.piece_color != this.piece_color) {
        this.valid_moves.add(new ChessMove(this.coordinate, target,
          (target_piece != null && !target_piece.remove), this.piece_color, this.type));
      }
      if (target_piece != null && !target_piece.remove) {
        break;
      }
    }
    for (int x = this.coordinate.x - 1, y = this.coordinate.y; x >= 0; x--) {
      IntegerCoordinate target = new IntegerCoordinate(x, y);
      if (!board.contains(target)) {
        break;
      }
      ChessPiece target_piece = board.pieceAt(target);
      if (target_piece == null || target_piece.remove || target_piece.piece_color != this.piece_color) {
        this.valid_moves.add(new ChessMove(this.coordinate, target,
          (target_piece != null && !target_piece.remove), this.piece_color, this.type));
      }
      if (target_piece != null && !target_piece.remove) {
        break;
      }
    }
    for (int x = this.coordinate.x, y = this.coordinate.y - 1; y >= 0; y--) {
      IntegerCoordinate target = new IntegerCoordinate(x, y);
      if (!board.contains(target)) {
        break;
      }
      ChessPiece target_piece = board.pieceAt(target);
      if (target_piece == null || target_piece.remove || target_piece.piece_color != this.piece_color) {
        this.valid_moves.add(new ChessMove(this.coordinate, target,
          (target_piece != null && !target_piece.remove), this.piece_color, this.type));
      }
      if (target_piece != null && !target_piece.remove) {
        break;
      }
    }
  }
}


String chessBoardNotation(IntegerCoordinate coordinate) {
  return Character.toString('a' + coordinate.y) + Integer.toString(coordinate.x + 1);
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
  ChessMove copy() {
    return new ChessMove(this.source.copy(), this.target.copy(), this.capture,
      this.source_color, this.source_type);
  }

  String pgnString() {
    String source_string = chessBoardNotation(this.source);
    String target_string = chessBoardNotation(this.target);
    String piece_string = "";
    switch(this.source_type) {
      case KING:
        piece_string = "K";
        break;
      case QUEEN:
        piece_string = "Q";
        break;
      case ROOK:
        piece_string = "R";
        break;
      case BISHOP:
        piece_string = "B";
        break;
      case KNIGHT:
        piece_string = "N";
        break;
    }
    if (this.capture) {
      target_string = "x" + target_string;
    }
    return piece_string + source_string + target_string;
  }

  @Override
  public int hashCode() {
    return Objects.hash(source.x, source.y, target.x, target.y, capture, source_color, source_type);
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

  boolean castlingMove() {
    return (this.source.x == this.target.x && abs(this.source.y - this.target.y) == 2 &&
      !this.capture && this.source_type == ChessPieceType.KING);
  }

  IntegerCoordinate castlingMoveRookSource(ChessBoard board) {
    if (!this.castlingMove()) {
      return null;
    }
    if (this.source.y < this.target.y) {
      return new IntegerCoordinate(this.source.x, board.boardHeight() - 1);
    }
    else {
      return new IntegerCoordinate(this.source.x, 0);
    }
  }

  IntegerCoordinate castlingMoveRookTarget() {
    if (!this.castlingMove()) {
      return null;
    }
    if (this.source.y < this.target.y) {
      return new IntegerCoordinate(this.source.x, this.source.y + 1);
    }
    else {
      return new IntegerCoordinate(this.source.x, this.source.y - 1);
    }
  }
}
