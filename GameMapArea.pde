class GameMapArea extends GameMap {
  class TerrainDimgThreadArea extends TerrainDimgThread {
    TerrainDimgThreadArea() {
      super();
    }

    @Override
    void run() {
      float startSquareX = GameMapArea.this.startSquareX;
      float startSquareY = GameMapArea.this.startSquareY;
      float visSquareX = GameMapArea.this.visSquareX;
      float visSquareY = GameMapArea.this.visSquareY;
      float terrain_resolution = GameMapArea.this.terrain_resolution;
      float xi_map = GameMapArea.this.xi_map;
      float xf_map = GameMapArea.this.xf_map;
      float yi_map = GameMapArea.this.yi_map;
      float yf_map = GameMapArea.this.yf_map;
      float zoom = GameMapArea.this.zoom;
      PImage new_terrain_display = GameMapArea.this.terrain_dimg.getImagePiece(
        round(startSquareX * terrain_resolution), round(startSquareY * terrain_resolution),
        round(visSquareX * terrain_resolution), round(visSquareY * terrain_resolution));
      new_terrain_display = resizeImage(new_terrain_display,
        round(xf_map - xi_map), round(yf_map - yi_map));
      GameMapArea.this.terrain_display = new_terrain_display;
      GameMapArea.this.startSquareX_old = startSquareX;
      GameMapArea.this.startSquareY_old = startSquareY;
      GameMapArea.this.visSquareX_old = visSquareX;
      GameMapArea.this.visSquareY_old = visSquareY;
      GameMapArea.this.xi_map_old = xi_map;
      GameMapArea.this.xf_map_old = xf_map;
      GameMapArea.this.yi_map_old = yi_map;
      GameMapArea.this.yf_map_old = yf_map;
      GameMapArea.this.xi_map_dif = 0;
      GameMapArea.this.xf_map_dif = 0;
      GameMapArea.this.yi_map_dif = 0;
      GameMapArea.this.yf_map_dif = 0;
      GameMapArea.this.zoom_old = zoom;
    }
  }


  class MouseMoveThreadArea extends Thread {
    private float mX = 0;
    private float mY = 0;

    MouseMoveThreadArea(float mX, float mY) {
      super("MouseMoveThreadArea");
      this.mX = mX;
      this.mY = mY;
    }

    @Override
    void run() {
    }
  }



  protected HashMap<IntegerCoordinate, GameMapSquare[][]> squares_reference =
    new HashMap<IntegerCoordinate, GameMapSquare[][]>();
  protected HashMap<IntegerCoordinate, DImg> terrain_dimg_reference = new HashMap<IntegerCoordinate, DImg>();
  protected HashMap<IntegerCoordinate, DImg> fog_dimg_reference = new HashMap<IntegerCoordinate, DImg>();
  protected int xi_rendering = 0;
  protected int yi_rendering = 0;

  protected int max_chunks_from_zero = 4;
  protected int seed = 0;

  GameMapArea() {
    super();
    this.mapWidth = Constants.map_chunkWidth;
    this.mapHeight = Constants.map_chunkWidth;
    this.terrain_resolution = global.profile.options.terrain_resolution;
  }


  @Override
  int mapXI() {
    return -Constants.map_chunkWidth * this.max_chunks_from_zero;
  }
  @Override
  int mapYI() {
    return -Constants.map_chunkWidth * this.max_chunks_from_zero;
  }
  @Override
  int mapXF() {
    return Constants.map_chunkWidth * this.max_chunks_from_zero;
  }
  @Override
  int mapYF() {
    return Constants.map_chunkWidth * this.max_chunks_from_zero;
  }


  IntegerCoordinate chunkFrom(int i, int j) {
    return new IntegerCoordinate(round(floor(float(i) / Constants.map_chunkWidth)),
      round(floor(float(j) / Constants.map_chunkWidth)));
  }

  @Override
  GameMapSquare mapSquare(int i, int j) {
    try {
      IntegerCoordinate chunk = this.chunkFrom(i, j);
      return this.squares_reference.get(chunk)[i - chunk.x * Constants.
        map_chunkWidth][j - chunk.y * Constants.map_chunkWidth];
    } catch(ArrayIndexOutOfBoundsException e) {
      return null;
    }
  }

  @Override
  void initializeSquares() {} // initialize squares lazily
  void initializeSquares(IntegerCoordinate chunk) {
    GameMapSquare[][] squares = new GameMapSquare[Constants.map_chunkWidth][Constants.map_chunkWidth];
    for (int i = 0; i < Constants.map_chunkWidth; i++) {
      for (int j = 0; j < Constants.map_chunkWidth; j++) {
        squares[i][j] = new GameMapSquare();
      }
    }
    try {
      if (this.squares_reference.get(chunk) == null) {
        this.squares_reference.put(chunk, squares);
      }
      else {
        global.errorMessage("ERROR: Trying to initialize squares in chunk " +
          chunk + " but it already has its squares initialized.");
      }
    } catch(ArrayIndexOutOfBoundsException e) {}
  }


  @Override
  void initializeTerrain() {} // initialize terrain lazily
  void initializeTerrain(IntegerCoordinate chunk) {
    try {
      if (this.terrain_dimg_reference.get(chunk) != null) {
        global.errorMessage("ERROR: Trying to initialize terrain in chunk " +
          chunk + " but it already has its terrain initialized.");
        return;
      }
      if (this.squares_reference.get(chunk) == null) {
        global.errorMessage("ERROR: Trying to initialize terrain in chunk " +
          chunk + " but its squares have not been initialized.");
        return;
      }
      DImg new_terrain_dimg = new DImg(Constants.map_chunkWidth * this.terrain_resolution,
        Constants.map_chunkWidth * this.terrain_resolution);
      new_terrain_dimg.setGrid(Constants.map_chunkWidth, Constants.map_chunkWidth);
      for (int i = 0; i < Constants.map_chunkWidth; i++) {
        for (int j = 0; j < Constants.map_chunkWidth; j++) {
          new_terrain_dimg.addImageGrid(this.squares_reference.get(chunk)[i][j].terrainImage(), i, j);
        }
      }
      for (Feature f : this.features.values()) {
        if (!f.displaysImage()) {
          continue;
        }
        if (f.xf() < Constants.map_chunkWidth * chunk.x || f.yf() < Constants.
          map_chunkWidth * chunk.y || f.xi() > Constants.map_chunkWidth * (1 +
          chunk.x) || f.yi() > Constants.map_chunkWidth * (1 + chunk.y)) {
          continue;
        }
        new_terrain_dimg.addImageGrid(f.getImage(), int(floor(f.x)),
          int(floor(f.y)), f.sizeX, f.sizeY);
      }
      this.terrain_dimg_reference.put(chunk, new_terrain_dimg);
      DImg new_fog_dimg = new DImg(Constants.map_chunkWidth * Constants.map_fogResolution,
        Constants.map_chunkWidth * Constants.map_fogResolution);
      new_fog_dimg.setGrid(Constants.map_chunkWidth, Constants.map_chunkWidth);
      this.fog_dimg_reference.put(chunk, new_fog_dimg);
      this.setFogHandling(this.fogHandling);
    } catch(ArrayIndexOutOfBoundsException e) {}
  }


  @Override
  void setFogHandling(MapFogHandling fogHandling) {
    this.fogHandling = fogHandling;
    for (Map.Entry<IntegerCoordinate, GameMapSquare[][]> entry : this.squares_reference.entrySet()) {
      GameMapSquare[][] squares_grid = entry.getValue();
      DImg fog_dimg = this.fog_dimg_reference.get(entry.getKey());
      for (int i = 0; i < squares_grid.length; i++) {
        for (int j = 0; j < squares_grid[i].length; j++) {
          GameMapSquare square = squares_grid[i][j];
          switch(fogHandling) {
            case DEFAULT:
              if (square.mapEdge()) {
                fog_dimg.colorGrid(Constants.color_transparent, i, j);
              }
              else if (!square.explored) {
                fog_dimg.colorGrid(Constants.color_black, i, j);
              }
              else if (!square.visible) {
                fog_dimg.colorGrid(this.fogColor, i, j);
              }
              else {
                fog_dimg.colorGrid(Constants.color_transparent, i, j);
              }
              break;
            case NONE:
              fog_dimg.colorGrid(Constants.color_transparent, i, j);
              this.exploreTerrainAndVisible(i + entry.getKey().x * Constants.map_chunkWidth,
                j + entry.getKey().y * Constants.map_chunkWidth, false);
              break;
            case NOFOG:
              this.setTerrainVisible(true, i + entry.getKey().x * Constants.map_chunkWidth,
                j + entry.getKey().y * Constants.map_chunkWidth, false);
                if (square.mapEdge()) {
                  fog_dimg.colorGrid(Constants.color_transparent, i, j);
                }
                else if (!square.explored) {
                  fog_dimg.colorGrid(Constants.color_black, i, j);
                }
                else {
                  fog_dimg.colorGrid(Constants.color_transparent, i, j);
                }
              break;
            case EXPLORED:
              this.exploreTerrain(i + entry.getKey().x * Constants.map_chunkWidth,
                j + entry.getKey().y * Constants.map_chunkWidth, false);
                if (square.mapEdge()) {
                  fog_dimg.colorGrid(Constants.color_transparent, i, j);
                }
                else if (!square.visible) {
                  fog_dimg.colorGrid(Constants.color_black, i, j);
                }
                else {
                  fog_dimg.colorGrid(Constants.color_transparent, i, j);
                }
              break;
            default:
              global.errorMessage("ERROR: Fog handling " + fogHandling.name + " not recognized.");
              break;
          }
        }
      }
    }
    this.refreshFogImage();
  }

  void refreshTerrainImage() {
    if (this.terrain_dimg_thread.isAlive()) {
      this.update_terrain_display = true;
    }
    else {
      this.update_terrain_display = false;
      this.terrain_dimg_thread = new TerrainDimgThreadArea();
      this.terrain_dimg_thread.start();
    }
  }
  void refreshFogImage() {
    int fog_xi = round(floor(this.startSquareX_old * Constants.map_fogResolution));
    this.xi_fog = this.xi_map_old - this.zoom_old * (this.startSquareX_old - float(fog_xi) / Constants.map_fogResolution);
    int fog_yi = round(floor(this.startSquareY_old * Constants.map_fogResolution));
    this.yi_fog = this.yi_map_old - this.zoom_old * (this.startSquareY_old - float(fog_yi) / Constants.map_fogResolution);
    int fog_w = round(ceil(this.visSquareX_old * Constants.map_fogResolution));
    this.xf_fog = this.xi_fog + this.zoom_old * (float(fog_w) / Constants.map_fogResolution);
    if (this.xf_fog + Constants.small_number < this.xf_map_old) {
      fog_w++;
      this.xf_fog += this.zoom_old / Constants.map_fogResolution;
    }
    int fog_h = round(ceil(this.visSquareY_old * Constants.map_fogResolution));
    this.yf_fog = this.yi_fog + this.zoom_old * (float(fog_h) / Constants.map_fogResolution);
    if (this.yf_fog + Constants.small_number < this.yf_map_old) {
      fog_h++;
      this.yf_fog += this.zoom_old / Constants.map_fogResolution;
    }
    this.fog_display = this.fog_dimg.getImagePiece(fog_xi, fog_yi, fog_w, fog_h);
  }
}
