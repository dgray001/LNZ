class GameMapArea extends AbstractGameMap {
  class TerrainDimgThread extends AbstractTerrainDimgThread {
    TerrainDimgThread() {
      super("TerrainDimgThread");
    }
    void updateTerrainDisplay() {
      for (int i = Math.floorDiv(startSquareX, Constants.map_chunkWidth); i <=
      Math.floorDiv(startSquareX + visSquareX, Constants.map_chunkWidth); i++) {
        for (int j = Math.floorDiv(startSquareY, Constants.map_chunkWidth); j <=
        Math.floorDiv(startSquareY + visSquareY, Constants.map_chunkWidth); j++) {
          // relevant chunks
        }
      }
      PImage new_terrain_display = GameMap.this.terrain_dimg.getImagePiece(
        round(startSquareX * terrain_resolution), round(startSquareY * terrain_resolution),
        round(visSquareX * terrain_resolution), round(visSquareY * terrain_resolution));
      new_terrain_display = resizeImage(new_terrain_display,
        round(xf_map - xi_map), round(yf_map - yi_map));
      GameMap.this.terrain_display = new_terrain_display;
    }
  }


  class Chunk {
    private GameMapSquare[][] squares;
    private HashMap<Integer, Feature> features = new HashMap<Integer, Feature>();
    private DImg terrain_dimg = new DImg(global.images.getBlackPixel());
    private DImg fog_dimg = new DImg(global.images.getBlackPixel());

    Chunk(IntegerCoordinate coordinate) {
      this.squares = new GameMapSquare[Constants.map_chunkWidth][Constants.map_chunkWidth];
      for (int i = 0; i < this.squares.length; i++) {
        for (int j = 0; j < this.squares[i].length; j++) {
          this.squares[i][j] = new GameMapSquare();
        }
      }
      // from coordinate either load previously-made chunk or create new one (not in thread)
      // then load image (in thread)
    }

    void save() {
      // save chunk in map folder
    }
  }


  protected HashMap<IntegerCoordinate, Chunk> chunk_reference = new HashMap<IntegerCoordinate, Chunk>();
  protected IntegerCoordinate current_chunk = new IntegerCoordinate(0, 0);

  protected String map_folder;
  protected int max_chunks_from_zero = 4;
  protected int chunk_view_radius = 1;
  protected int seed = 0;


  GameMapArea(String map_folder) {
    super();
    this.map_folder = map_folder;
  }


  int mapXI() {
    return -Constants.map_chunkWidth * this.max_chunks_from_zero;
  }
  int mapYI() {
    return -Constants.map_chunkWidth * this.max_chunks_from_zero;
  }
  int mapXF() {
    return Constants.map_chunkWidth * this.max_chunks_from_zero;
  }
  int mapYF() {
    return Constants.map_chunkWidth * this.max_chunks_from_zero;
  }
  int currMapXI() {
    return Constants.map_chunkWidth * (this.current_chunk.x - this.chunk_view_radius);
  }
  int currMapYI() {
    return Constants.map_chunkWidth * (this.current_chunk.y - this.chunk_view_radius);
  }
  int currMapXF() {
    return Constants.map_chunkWidth * (this.current_chunk.x + this.chunk_view_radius + 1);
  }
  int currMapYF() {
    return Constants.map_chunkWidth * (this.current_chunk.y + this.chunk_view_radius + 1);
  }


  GameMapSquare mapSquare(int i, int j) {
    try {
      Chunk chunk = this.chunk_reference.get(this.coordinateOf(i, j));
      if (chunk == null) {
        return null;
      }
      return chunk.squares[i % Constants.map_chunkWidth][j % Constants.map_chunkWidth];
    } catch(ArrayIndexOutOfBoundsException e) {
      return null;
    }
  }
  IntegerCoordinate coordinateOf(int i, int j) {
    return new IntegerCoordinate(Math.floorDiv(i, Constants.map_chunkWidth),
      Math.floorDiv(j, Constants.map_chunkWidth));
  }

  void initializeSquares() {
    this.refreshChunks();
  }
  void refreshChunks() {
    // remove unnecessary chunks from memory
    Iterator it = this.chunk_reference.entrySet().iterator();
    while(it.hasNext()) {
      Map.Entry<IntegerCoordinate, Chunk> entry = (Map.Entry<IntegerCoordinate, Chunk>)it.next();
      IntegerCoordinate coordinate = entry.getKey();
      if (coordinate.x > this.current_chunk.x + this.chunk_view_radius ||
        coordinate.x < this.current_chunk.x - this.chunk_view_radius ||
        coordinate.y > this.current_chunk.y + this.chunk_view_radius ||
        coordinate.y < this.current_chunk.y - this.chunk_view_radius) {
        entry.getValue().save();
        it.remove();
      }
    }
    // add needed new chunks
    for (int i = this.current_chunk.x - this.chunk_view_radius; i <= this.current_chunk.x + this.chunk_view_radius; i++) {
      for (int j = this.current_chunk.y - this.chunk_view_radius; j <= this.current_chunk.y + this.chunk_view_radius; j++) {
        IntegerCoordinate coordinate = new IntegerCoordinate(i, j);
        if (!this.coordinateInMap(coordinate)) {
          continue;
        }
        if (this.chunk_reference.containsKey(coordinate)) {
          continue;
        }
        this.chunk_reference.put(coordinate, new Chunk(coordinate));
      }
    }
  }
  boolean coordinateInMap(IntegerCoordinate coordinate) {
    if (abs(coordinate.x) <= this.max_chunks_from_zero && abs(coordinate.y) <= this.max_chunks_from_zero) {
      return true;
    }
    return false;
  }

  void initializeBackgroundImage() {}

  void colorFogGrid(color c, int i, int j) {
    Chunk chunk = this.chunk_reference.get(this.coordinateOf(new IntegerCoordinate(i, j)));
    if (chunk == null) {
      return;
    }
    chunk.fog_dimg.colorGrid(c, i % Constants.map_chunkWidth, j % Constants.map_chunkWidth);
  }

  void terrainImageGrid(PImage img, int x, int y, int w, int h) {
    Chunk chunk = this.chunk_reference.get(this.coordinateOf(new IntegerCoordinate(x, y)));
    if (chunk == null) {
      return;
    }
    chunk.terrain_dimg.addImageGrid(img, x % Constants.map_chunkWidth, y % Constants.map_chunkWidth, w, h);
  }

  void colorTerrainGrid(color c, int x, int y, int w, int h) {
    Chunk chunk = this.chunk_reference.get(this.coordinateOf(new IntegerCoordinate(i, j)));
    if (chunk == null) {
      return;
    }
    chunk.terrain_dimg.colorGrid(c, i % Constants.map_chunkWidth, j % Constants.map_chunkWidth);
  }

  void startTerrainDimgThread() {
    this.terrain_dimg_thread = new TerrainDimgThread();
    this.terrain_dimg_thread.start();
  }

  PImage getFogImagePiece(int fog_xi, int fog_yi, int fog_w, int fog_h) {
    return this.fog_dimg.getImagePiece(fog_xi, fog_yi, fog_w, fog_h);
  }

  void actuallyAddFeature(int code, Feature f) {
    this.features.put(code, f);
  }

  Feature getFeature(int code) {
    return this.features.get(code);
  }

  Collection<Feature> features() {
    return this.features.values();
  }

  void updateFeatures(int time_elapsed) {
    Iterator feature_iterator = this.features.entrySet().iterator();
    while(feature_iterator.hasNext()) {
      Map.Entry<Integer, Feature> entry = (Map.Entry<Integer, Feature>)feature_iterator.next();
      Feature f = entry.getValue();
      if (f.remove) {
        this.removeFeature(entry.getKey());
        feature_iterator.remove();
        continue;
      }
      f.update(time_elapsed, this);
      if (f.refresh_map_image) {
        this.refreshFeature(entry.getKey());
      }
      if (f.remove) {
        this.removeFeature(entry.getKey());
        feature_iterator.remove();
      }
    }
  }

  void updateFeaturesCheckRemovalOnly() {
    Iterator feature_iterator = this.features.entrySet().iterator();
    while(feature_iterator.hasNext()) {
      Map.Entry<Integer, Feature> entry = (Map.Entry<Integer, Feature>)feature_iterator.next();
      if (entry.getValue().remove) {
        this.removeFeature(entry.getKey());
        feature_iterator.remove();
      }
    }
  }


  void saveTerrain(PrintWriter file, String folderPath) {
    file.println("dimensions: " + this.mapWidth + ", " + this.mapHeight);
    for (int i = this.mapXI(); i < this.mapXF(); i++) {
      for (int j = this.mapYI(); j < this.mapYF(); j++) {
        file.println("terrain: " + i + ", " + j + ": " + this.mapSquare(i, j).terrain_id +
          ", " + this.mapSquare(i, j).base_elevation + ", " + this.mapSquare(i, j).explored);
      }
    }
    // add feature data
    for (Map.Entry<Integer, Feature> entry : this.features.entrySet()) {
      file.println("nextFeatureKey: " + entry.getKey());
      file.println(entry.getValue().fileString());
    }
  }

  void addImplementationSpecificData(String datakey, String data) {
    switch(datakey) {
      case "dimensions":
        String[] dimensions = split(data, ',');
        if (dimensions.length < 2) {
          global.errorMessage("ERROR: Map missing dimensions in data: " + data + ".");
          this.mapWidth = 1;
          this.mapHeight = 1;
        }
        else {
          this.mapWidth = toInt(trim(dimensions[0]));
          this.mapHeight = toInt(trim(dimensions[1]));
        }
        this.initializeSquares();
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not recognized for GameMap object.");
        break;
    }
  }
}
