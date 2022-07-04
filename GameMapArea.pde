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
    class LoadChunkThread extends Thread {
      LoadChunkThread() {
        super("LoadChunkThread");
        this.setDaemon(true);
      }

      @Override
      void run() {
        if (fileExists(Chunk.this.fileName())) {
          Chunk.this.load();
        }
        else {
          Chunk.this.generate();
        }
      }
    }


    private GameMapSquare[][] squares;
    private HashMap<Integer, Feature> features = new HashMap<Integer, Feature>();
    private DImg terrain_dimg;
    private DImg fog_dimg;
    private IntegerCoordinate coordinate;

    private LoadChunkThread thread;

    Chunk(IntegerCoordinate coordinate) {
      this.squares = new GameMapSquare[Constants.map_chunkWidth][Constants.map_chunkWidth];
      for (int i = 0; i < this.squares.length; i++) {
        for (int j = 0; j < this.squares[i].length; j++) {
          this.squares[i][j] = new GameMapSquare();
        }
      }
      this.coordinate = coordinate;
      Chunk.this.terrain_dimg = new DImg(Constants.map_chunkWidth * GameMapArea.this.terrain_resolution,
        Constants.map_chunkWidth * GameMapArea.this.terrain_resolution);
      Chunk.this.terrain_dimg.setGrid(Constants.map_chunkWidth, Constants.map_chunkWidth);
      Chunk.this.fog_dimg = new DImg(Constants.map_chunkWidth * Constants.map_fogResolution,
        Constants.map_chunkWidth * Constants.map_fogResolution);
      Chunk.this.fog_dimg.setGrid(Constants.map_chunkWidth, Constants.map_chunkWidth);
    }

    void loadChunk() {
      this.thread = new LoadChunkThread();
      this.thread.start();
    }

    String fileName() {
      return (GameMapArea.this.map_folder + "/" + this.coordinate.x + this.coordinate.y + ".chunk.lnz");
    }

    int chunkXI() {
      return this.coordinate.x * Constants.map_chunkWidth;
    }
    int chunkYI() {
      return this.coordinate.y * Constants.map_chunkWidth;
    }
    int chunkXF() {
      return (this.coordinate.x + 1) * Constants.map_chunkWidth;
    }
    int chunkYF() {
      return (this.coordinate.y + 1) * Constants.map_chunkWidth;
    }

    void generate() {
      randomSeed(GameMapArea.this.seed + this.coordinate.hashCode());
      int code = randomInt(151, 156);
      for (int i = 0; i < this.squares.length; i++) {
        for (int j = 0; j < this.squares[i].length; j++) {
          this.squares[i][j].setTerrain(code);
          this.terrain_dimg.addImageGrid(this.squares[i][j].terrainImage(), i, j);
        }
      }
      GameMapArea.this.addFeature(new Feature(442, this.chunkXI() + 1, this.chunkYI() + 1));
      this.save();
      GameMapArea.this.refreshTerrainImage();
    }

    void load() {
      String[] lines = loadStrings(this.fileName());
      if (lines == null) {
        global.errorMessage("ERROR: Reading chunk at path " + this.fileName() + " but no file exists.");
        return;
      }

      Stack<ReadFileObject> object_queue = new Stack<ReadFileObject>();

      Feature curr_feature = null;
      int next_feature_key = 0;
      int max_item_key = 0;
      Item curr_item = null;
      Item curr_item_internal = null; // for item inventories

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
        if (datakey.equals("new")) {
          ReadFileObject type = ReadFileObject.objectType(trim(line_split[1]));
          switch(type) {
            case FEATURE:
              if (line_split.length < 3) {
                global.errorMessage("ERROR: Feature ID missing in Feature constructor.");
                break;
              }
              object_queue.push(type);
              curr_feature = new Feature(toInt(trim(line_split[2])));
              break;
            case ITEM:
              if (line_split.length < 3) {
                global.errorMessage("ERROR: Item ID missing in Item constructor.");
                break;
              }
              object_queue.push(type);
              if (curr_item == null) {
                curr_item = new Item(toInt(trim(line_split[2])));
              }
              else {
                if (curr_item_internal != null) {
                  global.errorMessage("ERROR: Can't create an internal item inside an internal item.");
                  break;
                }
                if (curr_item.inventory == null) {
                  global.errorMessage("ERROR: Can't create an internal item " +
                    "inside an item with no inventory.");
                  break;
                }
                curr_item_internal = new Item(toInt(trim(line_split[2])));
              }
              break;
            default:
              global.errorMessage("ERROR: Can't add a " + type + " type to Chunk data.");
              break;
          }
        }
        else if (datakey.equals("end")) {
          ReadFileObject type = ReadFileObject.objectType(trim(line_split[1]));
          if (object_queue.empty()) {
            global.errorMessage("ERROR: Tring to end a " + type.name + " object but not inside any object.");
          }
          else if (type.name.equals(object_queue.peek().name)) {
            switch(object_queue.pop()) {
              case FEATURE:
                if (curr_feature == null) {
                  global.errorMessage("ERROR: Trying to end a null feature.");
                  break;
                }
                GameMapArea.this.addFeature(curr_feature, false, next_feature_key);
                curr_feature = null;
                break;
              case ITEM:
                if (curr_item == null) {
                  global.errorMessage("ERROR: Trying to end a null item.");
                  break;
                }
                if (object_queue.empty()) {
                  global.errorMessage("ERROR: Trying to end an item not inside any other object.");
                  break;
                }
                switch(object_queue.peek()) {
                  case FEATURE:
                    if (line_split.length < 3) {
                      global.errorMessage("ERROR: Ending item in feature inventory " +
                        "but no slot information given.");
                      break;
                    }
                    if (curr_feature == null) {
                      global.errorMessage("ERROR: Trying to add item to null feature.");
                      break;
                    }
                    if (curr_feature.inventory == null) {
                      global.errorMessage("ERROR: Trying to add item to feature " +
                        "inventory but curr_feature has no inventory.");
                      break;
                    }
                    if (trim(line_split[1]).equals("item_array")) {
                      if (curr_feature.items == null) {
                        global.errorMessage("ERROR: Trying to add item to feature " +
                          "item array but curr_feature has no item array.");
                        break;
                      }
                      curr_feature.items.add(curr_item);
                      break;
                    }
                    if (!isInt(trim(line_split[2]))) {
                      global.errorMessage("ERROR: Ending item in feature inventory " +
                        "but no slot information given.");
                      break;
                    }
                    int slot_number = toInt(trim(line_split[2]));
                    if (slot_number < 0 || slot_number >= curr_feature.inventory.slots.size()) {
                      global.errorMessage("ERROR: Trying to add item to feature " +
                        "inventory but slot number " + slot_number + " out of range.");
                      break;
                    }
                    curr_feature.inventory.slots.get(slot_number).item = curr_item;
                    break;
                  case ITEM:
                    if (curr_item_internal == null) {
                      global.errorMessage("ERROR: Trying to end a null internal item.");
                      break;
                    }
                    if (line_split.length < 3 || !isInt(trim(line_split[2]))) {
                      global.errorMessage("ERROR: Ending item in item inventory " +
                        "but no slot number given.");
                      break;
                    }
                    if (curr_item == null) {
                      global.errorMessage("ERROR: Trying to add item to null item.");
                      break;
                    }
                    if (curr_item.inventory == null) {
                      global.errorMessage("ERROR: Trying to add item to item " +
                        "inventory but curr_item has no inventory.");
                      break;
                    }
                    int item_slot_number = toInt(trim(line_split[2]));
                    if (item_slot_number < 0 || item_slot_number >= curr_item.inventory.slots.size()) {
                      global.errorMessage("ERROR: Trying to add item to feature " +
                        "inventory but slot number " + item_slot_number + " out of range.");
                      break;
                    }
                    curr_item.inventory.slots.get(item_slot_number).item = curr_item_internal;
                    break;
                  default:
                    global.errorMessage("ERROR: Trying to end an item inside a " +
                      object_queue.peek().name + " in Chunk data.");
                    break;
                }
                if (curr_item_internal == null) {
                  curr_item = null;
                }
                else {
                  curr_item_internal = null;
                }
                break;
              default:
                global.errorMessage("ERROR: Trying to end a " + type.name + " which is not known.");
                break;
            }
          }
          else {
            global.errorMessage("ERROR: Tring to end a " + type.name + " object " +
              "but current object is a " + object_queue.peek().name + ".");
          }
        }
        else if (!object_queue.empty()) {
          switch(object_queue.peek()) {
            case FEATURE:
              if (curr_feature == null) {
                global.errorMessage("ERROR: Trying to add feature data to a null feature.");
                break;
              }
              curr_feature.addData(datakey, data);
              break;
            case ITEM:
              if (curr_item == null) {
                global.errorMessage("ERROR: Trying to add item data to a null item.");
                break;
              }
              if (curr_item_internal != null) {
                curr_item_internal.addData(datakey, data);
              }
              else {
                curr_item.addData(datakey, data);
              }
              break;
            default:
              break;
          }
        }
        else {
          switch(datakey) {
            case "nextFeatureKey":
              next_feature_key = toInt(data);
              break;
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
                square.base_elevation = terrain_height;
                this.terrain_dimg.addImageGrid(square.terrainImage(), terrain_x, terrain_y);
                if (toBoolean(trim(terrain_values[2]))) {
                  square.explored = true;
                }
              }
              catch(ArrayIndexOutOfBoundsException e) {}
              break;
            default:
              global.errorMessage("ERROR: Datakey " + datakey + " not recognized.");
              break;
          }
        }
      }
      GameMapArea.this.refreshTerrainImage();
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
      for (Map.Entry<Integer, Feature> entry : this.features.entrySet()) {
        file.println("nextFeatureKey: " + entry.getKey());
        file.println(entry.getValue().fileString());
      }
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
        Chunk newChunk = new Chunk(coordinate);
        this.chunk_reference.put(coordinate, newChunk);
        newChunk.loadChunk();
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
    IntegerCoordinate coordinate = this.coordinateOf(round(f.x), round(f.y));
    Chunk chunk = this.chunk_reference.get(coordinate);
    if (chunk == null) {
      global.log("WARNING: Can't find chunk with coordinates " + coordinate.x +
        ", " + coordinate.y + " to add feature to.");
      return;
    }
    chunk.features.put(code, f);
  }

  Feature getFeature(int code) {
    for (Chunk chunk : this.chunk_reference.values()) {
      if (chunk.features.containsKey(code)) {
        return chunk.features.get(code);
      }
    }
    return null;
  }

  Collection<Feature> features() { // remove this, make logic more specific
    ArrayList<Feature> feature_list = new ArrayList<Feature>();
    for (Chunk chunk : this.chunk_reference.values()) {
      feature_list.addAll(chunk.features.values());
    }
    return feature_list;
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
    file.println("nextFeatureKey: " + this.nextFeatureKey);
    Iterator it = this.chunk_reference.entrySet().iterator();
    while(it.hasNext()) {
      Map.Entry<IntegerCoordinate, Chunk> entry = (Map.Entry<IntegerCoordinate, Chunk>)it.next();
      entry.getValue().save();
    }
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
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not recognized for GameMap object.");
        break;
    }
  }
}
