class GameMapArea extends AbstractGameMap {
  class TerrainDimgThread extends AbstractTerrainDimgThread {
    TerrainDimgThread() {
      super("TerrainDimgThread");
    }
    void updateTerrainDisplay() {
      DImg new_terrain_display = new DImg(round(this.xf_map - this.xi_map), round(this.yf_map - this.yi_map));
      if (visSquareX == 0 || visSquareY == 0) {
        return;
      }
      int xi_chunk = int(Math.floorDiv((long)this.startSquareX, (long)Constants.map_chunkWidth));
      int yi_chunk = int(Math.floorDiv((long)this.startSquareY, (long)Constants.map_chunkWidth));
      int xf_chunk = int(Math.floorDiv((long)(this.startSquareX + this.visSquareX), (long)Constants.map_chunkWidth));
      int yf_chunk = int(Math.floorDiv((long)(this.startSquareY + this.visSquareY), (long)Constants.map_chunkWidth));
      for (int i = xi_chunk; i <= xf_chunk; i++) {
        for (int j = yi_chunk; j <= yf_chunk; j++) {
          Chunk chunk = GameMapArea.this.chunk_reference.get(new IntegerCoordinate(i, j));
          if (chunk == null) {
            continue;
          }
          float img_x = 0;
          if (i * Constants.map_chunkWidth < this.startSquareX) {
            img_x = negMod(this.startSquareX, Constants.map_chunkWidth);
          }
          float img_y = 0;
          if (j * Constants.map_chunkWidth < this.startSquareY) {
            img_y = negMod(this.startSquareY, Constants.map_chunkWidth);
          }
          float img_w = Constants.map_chunkWidth - img_x;
          if ((i + 1) * Constants.map_chunkWidth > this.startSquareX + this.visSquareX) {
            img_w = negMod(this.startSquareX + this.visSquareX, Constants.map_chunkWidth) - img_x;
          }
          float img_h = Constants.map_chunkWidth - img_y;
          if ((j + 1) * Constants.map_chunkWidth > this.startSquareY + this.visSquareY) {
            img_h = negMod(this.startSquareY + this.visSquareY, Constants.map_chunkWidth) - img_y;
          }
          PImage chunk_terrain_image = chunk.terrain_dimg.getImagePiece(round(img_x * this.terrain_resolution),
            round(img_y * this.terrain_resolution), round(img_w * this.terrain_resolution), round(img_h * this.terrain_resolution));
          int resized_w = round((this.xf_map - this.xi_map) * img_w / this.visSquareX);
          int resized_h = round((this.yf_map - this.yi_map) * img_h / this.visSquareY);
          chunk_terrain_image = resizeImage(chunk_terrain_image, resized_w, resized_h);
          int resized_xi = round(max(0, i * Constants.map_chunkWidth - this.startSquareX) * new_terrain_display.img.width / this.visSquareX);
          int resized_yi = round(max(0, j * Constants.map_chunkWidth - this.startSquareY) * new_terrain_display.img.height / this.visSquareY);
          new_terrain_display.addImage(chunk_terrain_image, resized_xi, resized_yi, resized_w, resized_h);
        }
      }
      GameMapArea.this.terrain_display = new_terrain_display.img;
    }
  }


  class Chunk {
    private GameMapSquare[][] squares;
    private HashMap<Integer, Feature> features = new HashMap<Integer, Feature>();
    private DImg terrain_dimg;
    private DImg fog_dimg;
    private IntegerCoordinate coordinate;

    Chunk(IntegerCoordinate coordinate) {
      this.squares = new GameMapSquare[Constants.map_chunkWidth][Constants.map_chunkWidth];
      for (int i = 0; i < this.squares.length; i++) {
        for (int j = 0; j < this.squares[i].length; j++) {
          this.squares[i][j] = new GameMapSquare();
        }
      }
      this.terrain_dimg = new DImg(Constants.map_chunkWidth * GameMapArea.this.terrain_resolution,
        Constants.map_chunkWidth * GameMapArea.this.terrain_resolution);
      this.terrain_dimg.setGrid(Constants.map_chunkWidth, Constants.map_chunkWidth);
      this.fog_dimg = new DImg(Constants.map_chunkWidth * Constants.map_fogResolution,
        Constants.map_chunkWidth * Constants.map_fogResolution);
      this.fog_dimg.setGrid(Constants.map_chunkWidth, Constants.map_chunkWidth);
      this.coordinate = coordinate;
      if (fileExists(this.fileName())) {
        this.load();
      }
      else {
        this.generate();
      }
    }

    String fileName() {
      return (GameMapArea.this.map_folder + "/" + this.coordinate.x + this.coordinate.y + ".chunk.lnz");
    }

    void generate() {
      int code = randomInt(151, 156);
      for (int i = 0; i < this.squares.length; i++) {
        for (int j = 0; j < this.squares[i].length; j++) {
          this.squares[i][j].setTerrain(code);
          this.terrain_dimg.addImageGrid(this.squares[i][j].terrainImage(), i, j);
        }
      }
      this.save();
    }

    void load() {
      String[] lines = loadStrings(this.fileName());
      if (lines == null) {
        global.errorMessage("ERROR: Reading chunk at path " + this.fileName() + " but no file exists.");
        return;
      }
      for (String line : lines) {
        String[] line_split = split(line, ':');
        if (line_split.length < 2) {
          continue;
        }
        String datakey = trim(line_split[0]);
        String data = trim(line_split[1]);
        for (int i = 2; i < line_split.length; i++) {
          data += ":" + line_split[i];
        }
        // add feature data
        this.addData(datakey, data);
      }
    }

    void addData(String datakey, String data) {
      switch(datakey) {
        case "terrain":
          String[] data_split = split(data, ':');
          if (data_split.length < 2) {
            global.errorMessage("ERROR: Terrain missing dimension in data: " + data + ".");
            break;
          }
          String[] terrain_dimensions = split(data_split[0], ',');
          if (terrain_dimensions.length < 2) {
            global.errorMessage("ERROR: Terrain dimensions missing dimension in data: " + data + ".");
            break;
          }
          int terrain_x = toInt(trim(terrain_dimensions[0]));
          int terrain_y = toInt(trim(terrain_dimensions[1]));
          String[] terrain_values = split(data_split[1], ',');
          if (terrain_values.length < 3) {
            global.errorMessage("ERROR: Terrain values missing dimension in data: " + data + ".");
            break;
          }
          int terrain_id = toInt(trim(terrain_values[0]));
          int terrain_height = toInt(trim(terrain_values[1]));
          try {
            GameMapSquare square = this.squares[terrain_x][terrain_y];
            square.setTerrain(terrain_id);
            this.terrain_dimg.addImageGrid(square.terrainImage(), terrain_x, terrain_y);
            //GameMapArea.this.setTerrainBaseElevation(terrain_height, terrain_x, terrain_y);
            //if (toBoolean(trim(terrain_values[2]))) {
            //  GameMapArea.this.exploreTerrain(terrain_x, terrain_y, false);
            //}
          }
          catch(ArrayIndexOutOfBoundsException e) {}
          break;
        default:
          global.errorMessage("ERROR: Datakey " + datakey + " not recognized.");
          break;
      }
    }

    void save() {
      PrintWriter file = createWriter(this.fileName());
      for (int i = 0; i < this.squares.length; i++) {
        for (int j = 0; j < this.squares[i].length; j++) {
          file.println("terrain: " + i + ", " + j + ": " + this.squares[i][j].terrain_id +
            ", " + this.squares[i][j].base_elevation + ", " + this.squares[i][j].explored);
        }
      }
      // save features
      file.flush();
      file.close();
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
    this.current_chunk = new IntegerCoordinate(round(floor(this.viewX / Constants.map_chunkWidth)),
      round(floor(this.viewY / Constants.map_chunkWidth)));
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
