class IntegerCoordinate {
  private int x;
  private int y;
  private int hashCode;
  IntegerCoordinate(int x, int y) {
    this.x = x;
    this.y = y;
    this.hashCode = Objects.hash(x, y);
  }
  IntegerCoordinate copy() {
    return new IntegerCoordinate(this.x, this.y);
  }
  @Override
  public boolean equals(Object coordinate_object) {
    if (this == coordinate_object) {
      return true;
    }
    if (coordinate_object == null || this.getClass() != coordinate_object.getClass()) {
      return false;
    }
    IntegerCoordinate coordinate = (IntegerCoordinate)coordinate_object;
    if (this.x == coordinate.x && this.y == coordinate.y) {
      return true;
    }
    return false;
  }
  @Override
  public int hashCode() {
    return this.hashCode;
  }
  IntegerCoordinate[] adjacentCoordinates() {
    IntegerCoordinate[] adjacent_coordinates = new IntegerCoordinate[4];
    adjacent_coordinates[0] = new IntegerCoordinate(this.x + 1, this.y);
    adjacent_coordinates[1] = new IntegerCoordinate(this.x - 1, this.y);
    adjacent_coordinates[2] = new IntegerCoordinate(this.x, this.y + 1);
    adjacent_coordinates[3] = new IntegerCoordinate(this.x, this.y - 1);
    return adjacent_coordinates;
  }
  IntegerCoordinate[] cornerCoordinates() {
    IntegerCoordinate[] corner_coordinates = new IntegerCoordinate[4];
    corner_coordinates[0] = new IntegerCoordinate(this.x + 1, this.y + 1);
    corner_coordinates[1] = new IntegerCoordinate(this.x - 1, this.y + 1);
    corner_coordinates[2] = new IntegerCoordinate(this.x + 1, this.y - 1);
    corner_coordinates[3] = new IntegerCoordinate(this.x - 1, this.y - 1);
    return corner_coordinates;
  }
  IntegerCoordinate[] adjacentAndCornerCoordinates() {
    IntegerCoordinate[] adjacent_and_corner_coordinates = new IntegerCoordinate[8];
    adjacent_and_corner_coordinates[0] = new IntegerCoordinate(this.x + 1, this.y);
    adjacent_and_corner_coordinates[1] = new IntegerCoordinate(this.x - 1, this.y);
    adjacent_and_corner_coordinates[2] = new IntegerCoordinate(this.x, this.y + 1);
    adjacent_and_corner_coordinates[3] = new IntegerCoordinate(this.x, this.y - 1);
    adjacent_and_corner_coordinates[4] = new IntegerCoordinate(this.x + 1, this.y + 1);
    adjacent_and_corner_coordinates[5] = new IntegerCoordinate(this.x - 1, this.y + 1);
    adjacent_and_corner_coordinates[6] = new IntegerCoordinate(this.x + 1, this.y - 1);
    adjacent_and_corner_coordinates[7] = new IntegerCoordinate(this.x - 1, this.y - 1);
    return adjacent_and_corner_coordinates;
  }
  IntegerCoordinate[] knightMoves() {
    IntegerCoordinate[] knight_moves = new IntegerCoordinate[8];
    knight_moves[0] = new IntegerCoordinate(this.x + 1, this.y + 2);
    knight_moves[1] = new IntegerCoordinate(this.x + 1, this.y - 2);
    knight_moves[2] = new IntegerCoordinate(this.x - 1, this.y + 2);
    knight_moves[3] = new IntegerCoordinate(this.x - 1, this.y - 2);
    knight_moves[4] = new IntegerCoordinate(this.x + 2, this.y + 1);
    knight_moves[5] = new IntegerCoordinate(this.x + 2, this.y - 1);
    knight_moves[6] = new IntegerCoordinate(this.x - 2, this.y + 1);
    knight_moves[7] = new IntegerCoordinate(this.x - 2, this.y - 1);
    return knight_moves;
  }
}

// This function not fully tested, especially when error == 0
HashSet<IntegerCoordinate> squaresIntersectedByLine(FloatCoordinate p1, FloatCoordinate p2) {
  HashSet<IntegerCoordinate> intersections = new HashSet<IntegerCoordinate>();
  // declare parameters
  float dx = abs(p1.x - p2.x);
  float dy = abs(p1.y - p2.y);
  int x = round(floor(p1.x));
  int y = round(floor(p1.y));
  int n = 1;
  int x_increase = 0;
  int y_increase = 0;
  float error = 0;
  boolean infinite_error = false;
  boolean negative_infinite_error = false;
  // count intersections with grid lines
  if (dx == 0) {
    infinite_error = true;
  }
  else if (p2.x > p1.x) {
    x_increase = 1;
    n += round(floor(p2.x));
    error = (floor(p1.x) + 1 - p1.x) * dy;
  }
  else {
    x_increase = -1;
    n += x - round(floor(p2.x));
    error = (p1.x - floor(p1.x)) * dy;
  }
  if (dy == 0) {
    if (infinite_error) {
      infinite_error = false;
    }
    else {
      negative_infinite_error = true;
    }
  }
  else if (p2.y > p1.y) {
    y_increase = 1;
    n += round(floor(p2.y)) - y;
    error -= (floor(p1.y) + 1 - p1.y) * dx;
  }
  else {
    y_increase = -1;
    n += y - round(floor(p2.y));
    error -= (p1.y - floor(p1.y)) * dx;
  }
  // traverse line
  for (; n > 0; n--) {
    intersections.add(new IntegerCoordinate(x, y));
    if (infinite_error || (error > 0 && !negative_infinite_error)) {
      y += y_increase;
      error -= dx;
    }
    else {
      x += x_increase;
      error += dy;
    }
  }
  return intersections;
}

class FloatCoordinate {
  private float x;
  private float y;
  FloatCoordinate(float x, float y) {
    this.x = x;
    this.y = y;
  }
  boolean equals(FloatCoordinate coordinate) {
    if (abs(this.x - coordinate.x) < Constants.small_number && abs(this.y - coordinate.y) < Constants.small_number) {
      return true;
    }
    return false;
  }
}
