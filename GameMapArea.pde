class GameMapArea extends AbstractGameMap {
  class TerrainDimgThread extends AbstractTerrainDimgThread {
    TerrainDimgThread() {
      super("TerrainDimgThread");
    }
    void updateTerrainDisplay() {
      DImg new_terrain_display = new DImg(round(xf_map - xi_map), round(yf_map - yi_map));
      if (visSquareX == 0 || visSquareY == 0) {
        return;
      }
      println(startSquareX, startSquareY, visSquareX, visSquareY);
      boolean i_first = true;
      int xi_chunk = int(Math.floorDiv((long)startSquareX, (long)Constants.map_chunkWidth));
      int yi_chunk = int(Math.floorDiv((long)startSquareY, (long)Constants.map_chunkWidth));
      int xf_chunk = int(Math.floorDiv((long)(startSquareX + visSquareX), (long)Constants.map_chunkWidth));
      int yf_chunk = int(Math.floorDiv((long)(startSquareY + visSquareY), (long)Constants.map_chunkWidth));
      for (int i = xi_chunk; i <= xf_chunk; i++, i_first = false) {
        boolean j_first = true;
        for (int j = yi_chunk; j <= yf_chunk; j++, j_first = false) {
          Chunk chunk = GameMapArea.this.chunk_reference.get(new IntegerCoordinate(i, j));
          if (chunk == null) {
            continue;
          }
          float img_x = 0;
          if (i_first) {
            img_x = Math.floorMod((long)startSquareX, (long)Constants.map_chunkWidth);
          }
          float img_y = 0;
          if (j_first) {
            img_y = Math.floorMod((long)startSquareY, (long)Constants.map_chunkWidth);
          }
          float img_w = Constants.map_chunkWidth - img_x;
          if (i == xf_chunk) {
            img_w = Math.floorMod((long)(startSquareX + visSquareX), (long)Constants.map_chunkWidth) - img_x;
          }
          float img_h = Constants.map_chunkWidth - img_y;
          if (j == yf_chunk) {
            img_h = Math.floorMod((long)(startSquareY + visSquareY), (long)Constants.map_chunkWidth) - img_y;
          }
          println("chunk:", i, j, " has nums:", img_x, img_y, img_w, img_h);
          PImage chunk_terrain_image = chunk.terrain_dimg.getImagePiece(round(img_x * terrain_resolution),
            round(img_y * terrain_resolution), round(img_w * terrain_resolution), round(img_h * terrain_resolution));
          int resized_w = round((xf_map - xi_map) * img_w / visSquareX);
          int resized_h = round((yf_map - yi_map) * img_h / visSquareY);
          chunk_terrain_image = resizeImage(chunk_terrain_image, resized_w, resized_h);
          int resized_xi = round(max(0, i * Constants.map_chunkWidth - startSquareX) * terrain_resolution);
          int resized_yi = round(max(0, j * Constants.map_chunkWidth - startSquareY) * terrain_resolution);
          new_terrain_display.addImage(chunk_terrain_image, resized_xi, resized_yi, resized_w, resized_h);
        }
      }
      new_terrain_display.img.save("data/areas/terrain" + millis() + ".png");
      GameMapArea.this.terrain_display = new_terrain_display.img;
    }
  }


  class Chunk {
    private GameMapSquare[][] squares;
    private HashMap<Integer, Feature> features = new HashMap<Integer, Feature>();
    private DImg terrain_dimg = new DImg(global.images.getRandomPixel());
    private DImg fog_dimg = new DImg(global.images.getTransparentPixel());

    Chunk(IntegerCoordinate coordinate) {
      this.squares = new GameMapSquare[Constants.map_chunkWidth][Constants.map_chunkWidth];
      for (int i = 0; i < this.squares.length; i++) {
        for (int j = 0; j < this.squares[i].length; j++) {
          this.squares[i][j] = new GameMapSquare();
        }
      }
      this.terrain_dimg.img = global.images.getColoredPixel(color(150 + 100 * coordinate.x, 200 - 40 * coordinate.y));
      this.terrain_dimg.setGrid(Constants.map_chunkWidth, Constants.map_chunkWidth);
      this.fog_dimg.setGrid(Constants.map_chunkWidth, Constants.map_chunkWidth);
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
    Chunk chunk = this.chunk_reference.get(this.coordinateOf(i, j));
    if (chunk == null) {
      return;
    }
    chunk.fog_dimg.colorGrid(c, Math.floorMod(i, Constants.map_chunkWidth),
      Math.floorMod(j, Constants.map_chunkWidth));
  }

  void terrainImageGrid(PImage img, int x, int y, int w, int h) {
    Chunk chunk = this.chunk_reference.get(this.coordinateOf(x, y));
    if (chunk == null) {
      return;
    }
    chunk.terrain_dimg.addImageGrid(img, Math.floorMod(x, Constants.map_chunkWidth),
      Math.floorMod(y, Constants.map_chunkWidth), w, h);
  }

  void colorTerrainGrid(color c, int x, int y, int w, int h) {
    Chunk chunk = this.chunk_reference.get(this.coordinateOf(x, y));
    if (chunk == null) {
      return;
    }
    chunk.terrain_dimg.colorGrid(c, Math.floorMod(x, Constants.map_chunkWidth),
      Math.floorMod(y, Constants.map_chunkWidth));
  }

  void startTerrainDimgThread() {
    this.refreshChunks();
    this.terrain_dimg_thread = new TerrainDimgThread();
    this.terrain_dimg_thread.start();
  }

  PImage getFogImagePiece(int fog_xi, int fog_yi, int fog_w, int fog_h) {
    // account for whatever spreading across many chunks (do this after terrain image working)
    //return this.fog_dimg.getImagePiece(fog_xi, fog_yi, fog_w, fog_h);
    return global.images.getTransparentPixel();
  }

  void actuallyAddFeature(int code, Feature f) {
    //this.features.put(code, f);
  }

  Feature getFeature(int code) {
    return null;
    //return this.features.get(code);
  }

  Collection<Feature> features() {
    return new ArrayList<Feature>();
    //return this.features.values();
  }

  void updateFeatures(int time_elapsed) {/*
    Iterator feature_iterator = this.features.entrySet().iterator();
    while(feature_iterator.hasNext()) {
      Map.Entry<Integer, Feature> entry = (Map.Entry<Integer, Feature>)feature_iterator.next();
      updateFeature(entry.getValue(), feature_iterator, time_elapsed);
    }*/
  }

  void updateFeaturesCheckRemovalOnly() {/*
    Iterator feature_iterator = this.features.entrySet().iterator();
    while(feature_iterator.hasNext()) {
      Map.Entry<Integer, Feature> entry = (Map.Entry<Integer, Feature>)feature_iterator.next();
      if (entry.getValue().remove) {
        this.removeFeature(entry.getKey());
        feature_iterator.remove();
      }
    }*/
  }


  void saveTerrain(PrintWriter file) {
    file.println("max_chunks_from_zero: " + this.max_chunks_from_zero);
    file.println("seed: " + this.seed);
    for (int i = this.mapXI(); i < this.mapXF(); i++) {
      for (int j = this.mapYI(); j < this.mapYF(); j++) {
        //file.println("terrain: " + i + ", " + j + ": " + this.mapSquare(i, j).terrain_id +
          //", " + this.mapSquare(i, j).base_elevation + ", " + this.mapSquare(i, j).explored);
      }
    }
    // add feature data
    /*for (Map.Entry<Integer, Feature> entry : this.features.entrySet()) {
      file.println("nextFeatureKey: " + entry.getKey());
      file.println(entry.getValue().fileString());
    }*/
  }
  @Override
  String fileType() {
    return "area";
  }

  void addImplementationSpecificData(String datakey, String data) {
    switch(datakey) {
      case "max_chunks_from_zero":
        this.max_chunks_from_zero = toInt(data);
        break;
      case "seed":
        this.seed = toInt(data);
        break;
      case "dimensions":
        /*String[] dimensions = split(data, ',');
        if (dimensions.length < 2) {
          global.errorMessage("ERROR: Map missing dimensions in data: " + data + ".");
          this.mapWidth = 1;
          this.mapHeight = 1;
        }
        else {
          this.mapWidth = toInt(trim(dimensions[0]));
          this.mapHeight = toInt(trim(dimensions[1]));
        }
        this.initializeSquares();*/
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not recognized for GameMap object.");
        break;
    }
  }
}
