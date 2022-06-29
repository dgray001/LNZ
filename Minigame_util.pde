enum BoardOrientation {
  STANDARD, LEFT, RIGHT;
}

abstract class GridBoard {
  abstract class BoardSquare {
    class SquareButton extends RectangleButton {
      protected boolean no_draw_button = false;

      SquareButton() {
        super(0, 0, 0, 0);
        this.use_time_elapsed = true;
        this.force_left_button = false;
        this.roundness = 0;
        this.setColors(color(1, 0), color(1, 0), color(1, 0), color(1, 0), color(1, 0));
      }

      void turnOffDrawing() {
        this.no_draw_button = true;
      }
      void turnOnDrawing() {
        this.no_draw_button = false;
      }

      @Override
      void drawButton() {
        if (this.no_draw_button) {
          return;
        }
        super.drawButton();
      }

      void dehover() {}
      void hover() {}
      void click() {
        BoardSquare.this.clicked();
      }
      void release() {
        BoardSquare.this.released();
      }
    }

    protected IntegerCoordinate coordinate;
    protected HashMap<Integer, GamePiece> pieces;
    protected SquareButton button = new SquareButton();

    BoardSquare(IntegerCoordinate coordinate) {
      this.coordinate = coordinate;
      this.initializePieceMap();
    }

    abstract void initializePieceMap();

    void clearSquare() {
      this.pieces.clear();
    }

    void addPiece(GamePiece piece) {
      if (this.pieces.containsKey(piece.board_key)) {
        global.errorMessage("ERROR: Can't add piece with key " + piece.board_key +
          " to square " + this.coordinate.x + ", " + this.coordinate.y + ".");
        return;
      }
      this.pieces.put(piece.board_key, piece);
      piece.coordinate = new IntegerCoordinate(this.coordinate.x, this.coordinate.y);
    }

    abstract boolean canTakePiece(GamePiece piece);

    boolean empty() {
      return this.pieces.isEmpty();
    }

    void setSize(float size) {
      this.button.setLocation(0, 0, size, size);
    }

    void update(int time_elapsed) {
      this.updateWithoutDisplay(time_elapsed);
      this.drawSquare();
    }
    void updateWithoutDisplay(int time_elapsed) {
      this.button.turnOffDrawing();
      this.button.update(time_elapsed);
      this.button.turnOnDrawing();
      Iterator iterator = this.pieces.entrySet().iterator();
      while(iterator.hasNext()) {
        Map.Entry<Integer, GamePiece> entry = (Map.Entry<Integer, GamePiece>)iterator.next();
        if (entry.getValue().remove) {
          iterator.remove();
        }
      }
    }
    abstract void drawSquare();

    void mouseMove(float mX, float mY) {
      this.button.mouseMove(mX, mY);
    }

    void mousePress() {
      this.button.mousePress();
    }

    void mouseRelease(float mX, float mY) {
      this.button.mouseRelease(mX, mY);
    }

    abstract void clicked();
    abstract void released();
  }


  protected BoardSquare[][] squares;
  protected BoardOrientation orientation = BoardOrientation.STANDARD;
  protected HashMap<Integer, GamePiece> pieces;
  protected int next_piece_key = 1;

  protected float xi = 0;
  protected float yi = 0;
  protected float xf = 0;
  protected float yf = 0;
  protected float xi_draw = 0;
  protected float yi_draw = 0;
  protected float square_length = 0;

  protected IntegerCoordinate coordinate_hovered = null;

  GridBoard(int w, int h) {
    this.squares = new BoardSquare[w][h];
    this.initializeSquares();
    this.initializePieceMap();
  }

  void setOrientation(BoardOrientation orientation) {
    if (this.boardWidth() != this.boardHeight()) {
      return;
    }
    this.orientation = orientation;
  }

  int boardWidth() {
    return this.squares.length;
  }
  int boardHeight() {
    if (this.squares.length > 0) {
      return this.squares[0].length;
    }
    return 0;
  }

  boolean contains(IntegerCoordinate coordinate) {
    return this.squareAt(coordinate) != null;
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

  BoardSquare squareAt(IntegerCoordinate coordinate) {
    if (coordinate == null) {
      return null;
    }
    try {
      return this.squares[coordinate.x][coordinate.y];
    } catch(ArrayIndexOutOfBoundsException e) {
      return null;
    }
  }

  void addPiece(GamePiece piece, IntegerCoordinate coordinate) {
    this.addPiece(piece, coordinate.x, coordinate.y);
  }
  void addPiece(GamePiece piece, int x, int y) {
    if (x < 0 || y < 0 || x >= this.boardWidth() || y >= this.boardHeight()) {
      global.errorMessage("ERROR: Can't add piece to square " + x + ", " + y +
        " since that square is not on the board.");
      return;
    }
    if (!this.squares[x][y].canTakePiece(piece)) {
      global.errorMessage("ERROR: Can't add piece with key " + piece.board_key +
        " to square " + x + ", " + y + " since it won't take it.");
      return;
    }
    this.addPiece(piece, x, y, this.next_piece_key);
    this.next_piece_key++;
  }
  void addPiece(GamePiece piece, int x, int y, int board_key) {
    piece.board_key = board_key;
    this.pieces.put(board_key, piece);
    this.squares[x][y].addPiece(piece);
    this.addedPiece(piece);
  }

  abstract void addedPiece(GamePiece piece);

  void setLocation(float xi, float yi, float xf, float yf) {
    this.xi = xi;
    this.yi = yi;
    this.xf = xf;
    this.yf = yf;
    if (this.boardWidth() == 0 || this.boardHeight() == 0) {
      return;
    }

    float square_length_from_width = (xf - xi) / this.boardWidth();
    float square_length_from_height = (yf - yi) / this.boardHeight();
    this.square_length = min(square_length_from_width, square_length_from_height);
    for (int i = 0; i < this.squares.length; i++) {
      for (int j = 0; j < this.squares[i].length; j++) {
        this.squares[i][j].setSize(this.square_length);
      }
    }
    this.xi_draw = xi + 0.5 * (xf - xi - this.boardWidth() * this.square_length);
    this.yi_draw = yi + 0.5 * (yf - yi - this.boardHeight() * this.square_length);
  }

  float squareCenterX(IntegerCoordinate coordinate) {
    if (coordinate == null) {
      return 0;
    }
    float x_curr = this.xi_draw;
    switch(this.orientation) {
      case STANDARD:
        x_curr += coordinate.x * this.square_length;
        break;
      case LEFT:
        x_curr += (this.squares[0].length - 1 - coordinate.y) * this.square_length;
        break;
      case RIGHT:
        x_curr += coordinate.y * this.square_length;
        break;
    }
    return x_curr + 0.5 * this.square_length;
  }

  float squareCenterY(IntegerCoordinate coordinate) {
    if (coordinate == null) {
      return 0;
    }
    float y_curr = this.yi_draw;
    switch(this.orientation) {
      case STANDARD:
        y_curr += coordinate.y * this.square_length;
        break;
      case LEFT:
        y_curr += coordinate.x * this.square_length;
        break;
      case RIGHT:
        y_curr += (this.squares.length - 1 - coordinate.x) * this.square_length;
        break;
    }
    return y_curr + 0.5 * this.square_length;
  }

  void update(int time_elapsed) {
    float x_curr = this.xi_draw;
    float y_curr = this.yi_draw;
    switch(this.orientation) {
      case STANDARD:
        for (int i = 0; i < this.squares.length; i++, x_curr += this.square_length) {
          y_curr = this.yi_draw;
          for (int j = 0; j < this.squares[i].length; j++, y_curr += this.square_length) {
            translate(x_curr, y_curr);
            this.squares[i][j].update(time_elapsed);
            translate(-x_curr, -y_curr);
          }
        }
        break;
      case LEFT:
        for (int j = this.squares[0].length - 1; j >= 0; j--, x_curr += this.square_length) {
          y_curr = this.yi_draw;
          for (int i = 0; i < this.squares.length; i++, y_curr += this.square_length) {
            translate(x_curr, y_curr);
            this.squares[i][j].update(time_elapsed);
            translate(-x_curr, -y_curr);
          }
        }
        break;
      case RIGHT:
        for (int j = 0; j < this.squares[0].length; j++, x_curr += this.square_length) {
          y_curr = this.yi_draw;
          for (int i = this.squares.length - 1; i >= 0; i--, y_curr += this.square_length) {
            translate(x_curr, y_curr);
            this.squares[i][j].update(time_elapsed);
            translate(-x_curr, -y_curr);
          }
        }
        break;
    }
    this.removePieces();
    this.afterUpdate();
  }
  void updateWithoutDisplay(int time_elapsed) {
    for (int i = 0; i < this.squares.length; i++) {
      for (int j = 0; j < this.squares[i].length; j++) {
        this.squares[i][j].updateWithoutDisplay(time_elapsed);
      }
    }
    this.removePieces();
  }
  void removePieces() {
    Iterator iterator = this.pieces.entrySet().iterator();
    while(iterator.hasNext()) {
      Map.Entry<Integer, GamePiece> entry = (Map.Entry<Integer, GamePiece>)iterator.next();
      if (entry.getValue().remove) {
        iterator.remove();
      }
    }
  }
  abstract void afterUpdate();

  void mouseMove(float mX, float mY) {
    this.coordinate_hovered = null;
    float x_curr = this.xi_draw;
    float y_curr = this.yi_draw;
    switch(this.orientation) {
      case STANDARD:
        for (int i = 0; i < this.squares.length; i++, x_curr += this.square_length) {
          y_curr = this.yi_draw;
          for (int j = 0; j < this.squares[i].length; j++, y_curr += this.square_length) {
            this.squares[i][j].mouseMove(mX - x_curr, mY - y_curr);
            if (this.squares[i][j].button.hovered) {
              this.coordinate_hovered = this.squares[i][j].coordinate;
            }
          }
        }
        break;
      case LEFT:
        for (int j = this.squares[0].length - 1; j >= 0; j--, x_curr += this.square_length) {
          y_curr = this.yi_draw;
          for (int i = 0; i < this.squares.length; i++, y_curr += this.square_length) {
            this.squares[i][j].mouseMove(mX - x_curr, mY - y_curr);
            if (this.squares[i][j].button.hovered) {
              this.coordinate_hovered = this.squares[i][j].coordinate;
            }
          }
        }
        break;
      case RIGHT:
        for (int j = 0; j < this.squares[0].length; j++, x_curr += this.square_length) {
          y_curr = this.yi_draw;
          for (int i = this.squares.length - 1; i >= 0; i--, y_curr += this.square_length) {
            this.squares[i][j].mouseMove(mX - x_curr, mY - y_curr);
            if (this.squares[i][j].button.hovered) {
              this.coordinate_hovered = this.squares[i][j].coordinate;
            }
          }
        }
        break;
    }
  }

  void mousePress() {
    for (int i = 0; i < this.squares.length; i++) {
      for (int j = 0; j < this.squares[i].length; j++) {
        this.squares[i][j].mousePress();
      }
    }
  }

  void mouseRelease(float mX, float mY) {
    float x_curr = this.xi_draw;
    float y_curr = this.yi_draw;
    switch(this.orientation) {
      case STANDARD:
        for (int i = 0; i < this.squares.length; i++, x_curr += this.square_length) {
          y_curr = this.yi_draw;
          for (int j = 0; j < this.squares[i].length; j++, y_curr += this.square_length) {
            this.squares[i][j].mouseRelease(mX - x_curr, mY - y_curr);
          }
        }
        break;
      case LEFT:
        for (int j = this.squares[0].length - 1; j >= 0; j--, x_curr += this.square_length) {
          y_curr = this.yi_draw;
          for (int i = 0; i < this.squares.length; i++, y_curr += this.square_length) {
            this.squares[i][j].mouseRelease(mX - x_curr, mY - y_curr);
          }
        }
        break;
      case RIGHT:
        for (int j = 0; j < this.squares[0].length; j++, x_curr += this.square_length) {
          y_curr = this.yi_draw;
          for (int i = this.squares.length - 1; i >= 0; i--, y_curr += this.square_length) {
            this.squares[i][j].mouseRelease(mX - x_curr, mY - y_curr);
          }
        }
        break;
    }
  }
}


abstract class GamePiece {
  protected int board_key = -1;
  protected boolean remove = false;
  protected IntegerCoordinate coordinate = new IntegerCoordinate(0, 0);

  GamePiece() {
  }

  abstract PImage getImage();
}
