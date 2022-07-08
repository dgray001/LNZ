class GameMapArea extends AbstractGameMap {
  class TerrainDimgThread extends AbstractTerrainDimgThread {
    TerrainDimgThread() {
      super("TerrainDimgThread");
    }
    void updateTerrainDisplay() {
      DImg new_terrain_display = new DImg(round(this.xf_map - this.xi_map), round(this.yf_map - this.yi_map));
      if (this.visSquareX == 0 || this.visSquareY == 0) {
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
          PImage chunk_fog_image = chunk.fog_dimg.getImagePiece(round(img_x * this.terrain_resolution),
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


  class FogDImgThread extends Thread {
    private int fog_xi = 0;
    private int fog_yi = 0;
    private int fog_w = 0;
    private int fog_h = 0;
    private boolean replay = false;
    FogDImgThread(int fog_xi, int fog_yi, int fog_w, int fog_h) {
      super("FogDImgThread");
      this.setDaemon(true);
      this.fog_xi = fog_xi;
      this.fog_yi = fog_yi;
      this.fog_w = fog_w * Constants.map_fogResolution;
      this.fog_h = fog_h * Constants.map_fogResolution;
    }
    @Override
    void run() {
      while(true) {
        IntegerCoordinate current = GameMapArea.this.current_chunk.copy();
        for (int i = current.x - GameMapArea.this.chunk_view_radius; i <= current.x + GameMapArea.this.chunk_view_radius; i++) {
          for (int j = current.y - GameMapArea.this.chunk_view_radius; j <= current.y + GameMapArea.this.chunk_view_radius; j++) {
            Chunk chunk = GameMapArea.this.chunk_reference.get(new IntegerCoordinate(i, j));
            if (chunk == null) {
              continue;
            }
            GameMapArea.this.fog_dimg.addImageGrid(chunk.fog_dimg.img,
              i - current.x + GameMapArea.this.chunk_view_radius,
              j - current.y + GameMapArea.this.chunk_view_radius);
          }
        }
        this.fog_xi = this.fog_xi - (current.x - GameMapArea.this.chunk_view_radius) * Constants.map_chunkWidth * Constants.map_fogResolution;
        this.fog_yi = this.fog_yi - (current.y - GameMapArea.this.chunk_view_radius) * Constants.map_chunkWidth * Constants.map_fogResolution;
        GameMapArea.this.fog_display = GameMapArea.this.fog_dimg.getImagePiece(this.fog_xi, this.fog_yi, this.fog_w, this.fog_h);
        if (this.replay) {
          this.replay = false;
        }
        else {
          return;
        }
      }
    }
  }


  class HangingImage {
    private IntegerCoordinate chunk_coordinate;
    private PImage newImg;
    private int newImgX;
    private int newImgY;
    private int newImgW;
    private int newImgH;
    private int x;
    private int y;
    private int w;
    private int h;
    HangingImage(IntegerCoordinate chunk_coordinate, PImage newImg, int newImgX,
      int newImgY, int newImgW, int newImgH, int x, int y, int w, int h) {
      this.chunk_coordinate = chunk_coordinate;
      this.newImg = newImg;
      this.newImgX = newImgX;
      this.newImgY = newImgY;
      this.newImgW = newImgW;
      this.newImgH = newImgH;
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
    }
    boolean resolve() {
      Chunk chunk = GameMapArea.this.chunk_reference.get(this.chunk_coordinate);
      if (chunk == null) {
        return false;
      }
      chunk.terrain_dimg.addImageGrid(this.newImg, this.newImgX, this.newImgY,
        this.newImgW, this.newImgH, this.x, this.y, this.w, this.h);
      return true;
    }
  }


  class HangingFeaturesThread extends Thread {
    HangingFeaturesThread() {
      super("HangingFeaturesThread");
      this.setDaemon(true);
    }
    @Override
    void run() {
      while(true) {
        delay(200);
        if (GameMapArea.this == null || GameMapArea.this.nullify) {
          return;
        }
        GameMapArea.this.checkHangingFeatures();
        GameMapArea.this.checkHangingImages();
      }
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
        Chunk.this.applyFogHandling();
      }
    }


    private GameMapSquare[][] squares;
    private ConcurrentHashMap<Integer, Feature> features = new ConcurrentHashMap<Integer, Feature>();
    private DImg terrain_dimg;
    private DImg fog_dimg;
    private IntegerCoordinate coordinate;
    private Biome biome = Biome.NONE;

    private LoadChunkThread thread;
    private boolean remove = false; // used to avoid concurrent modification error if trying to remove while generating chunk

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

    void applyFogHandling() {
      for (int i = 0; i < this.squares.length; i++) {
        for (int j = 0; j < this.squares[i].length; j++) {
          GameMapSquare square = this.squares[i][j];
          if (square == null) {
            continue;
          }
          switch(GameMapArea.this.fogHandling) {
            case DEFAULT:
              if (square.mapEdge()) {
                this.colorFogGrid(Constants.color_transparent, i, j);
              }
              else if (!square.explored) {
                this.colorFogGrid(Constants.color_black, i, j);
              }
              else if (!square.visible) {
                this.colorFogGrid(GameMapArea.this.fogColor, i, j);
              }
              else {
                this.colorFogGrid(Constants.color_transparent, i, j);
              }
              break;
            case NONE:
              square.explored = true;
              square.visible = true;
              this.colorFogGrid(Constants.color_transparent, i, j);
              break;
            case NOFOG:
              square.visible = true;
              if (square.mapEdge()) {
                this.colorFogGrid(Constants.color_transparent, i, j);
              }
              else if (!square.explored) {
                this.colorFogGrid(Constants.color_black, i, j);
              }
              else {
                this.colorFogGrid(Constants.color_transparent, i, j);
              }
              break;
            case EXPLORED:
              square.explored = true;
              if (square.mapEdge()) {
                this.colorFogGrid(Constants.color_transparent, i, j);
              }
              else if (!square.visible) {
                this.colorFogGrid(GameMapArea.this.fogColor, i, j);
              }
              else {
                this.colorFogGrid(Constants.color_transparent, i, j);
              }
              break;
          }
        }
      }
    }

    void colorFogGrid(color c, int i, int j) {
      this.fog_dimg.colorGrid(c, i, j);
    }

    void generate() {
      this.biome = GameMapArea.this.getBiome(this.coordinate);
      // Generate BiomeReturns from Perlin noise
      BiomeReturn[][] biome_return = new BiomeReturn[Constants.map_chunkWidth][Constants.map_chunkWidth];
      for (int i = 0; i < biome_return.length; i++) {
        for (int j = 0; j < biome_return[i].length; j++) {
          IntegerCoordinate square = new IntegerCoordinate(this.chunkXI() + i, this.chunkYI() + j);
          float noise_value = GameMapArea.this.perlinNoise(square, false);
          biome_return[i][j] = processPerlinNoise(this.biome, noise_value);
        }
      }
      // Base terrain from perlin noise and biome
      for (int i = 0; i < this.squares.length; i++) {
        for (int j = 0; j < this.squares[i].length; j++) {
          this.squares[i][j].setTerrain(biome_return[i][j].terrain_code);
          this.terrain_dimg.addImageGrid(this.squares[i][j].terrainImage(), i, j);
        }
      }
      // Base features from perlin noise and biome
      for (int i = 0; i < this.squares.length; i++) {
        for (int j = 0; j < this.squares[i].length; j++) {
          if (biome_return[i][j].spawn_feature) {
            GameMapArea.this.addFeature(biome_return[i][j].feature_id, this.chunkXI() + i, this.chunkYI() + j);
          }
        }
      }
      // terrain structures ??
      // add features ??
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
            case "biome":
              this.biome = Biome.biome(data);
              break;
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
      file.println("biome: " + this.biome.fileName());
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


  protected AreaLocation area_location = AreaLocation.FERNWOOD_FOREST;

  protected ConcurrentHashMap<IntegerCoordinate, Chunk> chunk_reference = new ConcurrentHashMap<IntegerCoordinate, Chunk>();
  protected IntegerCoordinate current_chunk = new IntegerCoordinate(0, 0);
  protected DImg fog_dimg;
  protected FogDImgThread fog_dimg_thread = null;

  protected String map_folder;
  protected int max_chunks_from_zero = 4;
  protected int chunk_view_radius = 1;
  protected int seed = 0;

  // prevents nullptr on perlinNoise() since noise/noiseDetail/noiseSeed not thread-safe (maybe??)
  protected boolean waiting_for_noise_initialization = true;

  // keeps track of features that are hanging over unloaded chunks when added / removed
  protected ConcurrentHashMap<IntegerCoordinate, ConcurrentHashMap<Integer, Feature>> hanging_features =
    new ConcurrentHashMap<IntegerCoordinate, ConcurrentHashMap<Integer, Feature>>();
  protected Queue<HangingImage> hanging_images = new ConcurrentLinkedQueue<HangingImage>();
  protected HangingFeaturesThread hanging_features_thread;


  GameMapArea(String map_folder) {
    super();
    this.map_folder = map_folder;
    noiseSeed(this.seed);
    noiseDetail(Constants.map_noiseOctaves, 0.55);
    this.waiting_for_noise_initialization = false;
    this.startTerrainDimgThread();
    this.hanging_features_thread = new HangingFeaturesThread();
    this.hanging_features_thread.start(); // runs continuously
  }


  synchronized float perlinNoise(IntegerCoordinate coordinate, boolean chunk_noise) {
    if (coordinate == null) {
      return 0;
    }
    try {
      if (chunk_noise) {
        return noise(coordinate.x * Constants.map_chunkPerlinMultiplier + Constants.map_noiseOffsetX,
          coordinate.y * Constants.map_chunkPerlinMultiplier + Constants.map_noiseOffsetY);
      }
      else {
        return noise(coordinate.x * Constants.map_mapPerlinMultiplier + Constants.map_noiseOffsetX,
          coordinate.y * Constants.map_mapPerlinMultiplier + Constants.map_noiseOffsetY);
      }
    } catch(NullPointerException e) {
      return 0;
    }
  }

  Biome getBiome(IntegerCoordinate coordinate) {
    float noise_value = this.perlinNoise(coordinate, true);
    return this.area_location.getBiome(noise_value);
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
      IntegerCoordinate coordinate = this.coordinateOf(i, j);
      Chunk chunk = this.chunk_reference.get(coordinate);
      if (chunk == null) {
        return null;
      }
      return chunk.squares[Math.floorMod(i, Constants.map_chunkWidth)][Math.floorMod(j, Constants.map_chunkWidth)];
    } catch(ArrayIndexOutOfBoundsException e) {
      return null;
    }
  }
  IntegerCoordinate coordinateOf(int i, int j) {
    return new IntegerCoordinate(Math.floorDiv(i, Constants.map_chunkWidth),
      Math.floorDiv(j, Constants.map_chunkWidth));
  }

  void initializeSquares() {}
  void refreshChunks() {
    // remove unnecessary chunks from memory
    Iterator it = this.chunk_reference.entrySet().iterator();
    while(it.hasNext()) {
      Map.Entry<IntegerCoordinate, Chunk> entry = (Map.Entry<IntegerCoordinate, Chunk>)it.next();
      IntegerCoordinate coordinate = entry.getKey();
      if (entry.getValue().remove || coordinate.x > this.current_chunk.x + this.chunk_view_radius ||
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

  void initializeBackgroundImage() {
    int chunk_view_width = (this.chunk_view_radius * 2 + 1);
    this.fog_dimg = new DImg(chunk_view_width * Constants.map_chunkWidth * Constants.map_fogResolution,
      chunk_view_width * Constants.map_chunkWidth * Constants.map_fogResolution);
    this.fog_dimg.setGrid(chunk_view_width, chunk_view_width);
  }

  void colorFogGrid(color c, int i, int j) {
    Chunk chunk = this.chunk_reference.get(this.coordinateOf(i, j));
    if (chunk == null) {
      return;
    }
    chunk.fog_dimg.colorGrid(c, Math.floorMod(i, Constants.map_chunkWidth),
      Math.floorMod(j, Constants.map_chunkWidth));
  }

  void terrainImageGrid(PImage img, int x, int y, int w, int h) {
    IntegerCoordinate coordinate = this.coordinateOf(x, y);
    Chunk chunk = this.chunk_reference.get(this.coordinateOf(x, y));
    if (chunk == null || w < 1 || h < 1) {
      // data corruption
      return;
    }
    int relative_x = Math.floorMod(x, Constants.map_chunkWidth);
    int relative_y = Math.floorMod(y, Constants.map_chunkWidth);
    chunk.terrain_dimg.addImageGrid(img, relative_x, relative_y, w, h);
    // now check for hanging
    boolean x_hanging = false;
    boolean y_hanging = false;
    if (relative_x + w > Constants.map_chunkWidth) {
      x_hanging = true;
    }
    if (relative_y + h > Constants.map_chunkWidth) {
      y_hanging = true;
    }
    if (x_hanging && y_hanging) {
      int remaining_width = relative_x + w - Constants.map_chunkWidth;
      int img_width = round(img.width * float(remaining_width) / w);
      int remaining_height = relative_y + h - Constants.map_chunkWidth;
      int img_height = round(img.height * float(remaining_height) / h);
      IntegerCoordinate x_edge = this.coordinateOf(x + w, y);
      Chunk x_chunk = this.chunk_reference.get(x_edge);
      if (x_chunk == null) {
      }
      else {
        x_chunk.terrain_dimg.addImageGrid(img, img.width - img_width, 0, img_width,
          img.height - img_height, 0, relative_y, remaining_width, Constants.map_chunkWidth - relative_y);
      }
      IntegerCoordinate y_edge = this.coordinateOf(x, y + h);
      Chunk y_chunk = this.chunk_reference.get(y_edge);
      if (y_chunk == null) {
      }
      else {
        y_chunk.terrain_dimg.addImageGrid(img, 0, img.height - img_height, img.width
          - img_width, img_height, relative_x, 0, Constants.map_chunkWidth - relative_x, remaining_height);
      }
      IntegerCoordinate xy_edge = this.coordinateOf(x + w, y + h);
      Chunk xy_chunk = this.chunk_reference.get(xy_edge);
      if (xy_chunk == null) {
      }
      else {
        xy_chunk.terrain_dimg.addImageGrid(img, img.width - img_width, img.height - img_height,
          img_width, img_height, 0, 0, remaining_width, remaining_height);
      }
    }
    else if (x_hanging) {
      IntegerCoordinate x_edge = this.coordinateOf(x + w, y);
      Chunk x_chunk = this.chunk_reference.get(x_edge);
      int remaining_width = relative_x + w - Constants.map_chunkWidth;
      int img_width = round(img.width * float(remaining_width) / w);
      if (x_chunk == null) {
      }
      else {
        x_chunk.terrain_dimg.addImageGrid(img, img.width - img_width, 0, img_width,
          img.height, 0, relative_y, remaining_width, h);
      }
    }
    else if (y_hanging) {
      IntegerCoordinate y_edge = this.coordinateOf(x, y + h);
      Chunk y_chunk = this.chunk_reference.get(y_edge);
      int remaining_height = relative_y + h - Constants.map_chunkWidth;
      int img_height = round(img.height * float(remaining_height) / h);
      if (y_chunk == null) {
      }
      else {
        y_chunk.terrain_dimg.addImageGrid(img, 0, img.height - img_height, img.width,
          img_height, relative_x, 0, w, remaining_height);
      }
    }
  }

  void colorTerrainGrid(color c, int x, int y, int w, int h) {
    Chunk chunk = this.chunk_reference.get(this.coordinateOf(x, y));
    if (chunk == null) {
      return;
    }
    chunk.terrain_dimg.colorGrid(c, Math.floorMod(x, Constants.map_chunkWidth),
      Math.floorMod(y, Constants.map_chunkWidth));
  }

  synchronized void startTerrainDimgThread() {
    if (this.waiting_for_noise_initialization) {
      return;
    }
    this.refreshChunks();
    this.terrain_dimg_thread = new TerrainDimgThread();
    this.terrain_dimg_thread.start();
  }

  PImage getFogImagePiece(int fog_xi, int fog_yi, int fog_w, int fog_h) {
    // set fog display in terrain dimg thread
    if (this.fog_dimg_thread != null && this.fog_dimg_thread.isAlive()) {
      this.fog_dimg_thread.replay = true;
    }
    else {
      this.fog_dimg_thread = new FogDImgThread(fog_xi, fog_yi, fog_w, fog_h);
      this.fog_dimg_thread.start();
    }
    return this.fog_dimg.getImagePiece(fog_xi, fog_yi, fog_w, fog_h);
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

  void featureAddedMapSquareNotFound(IntegerCoordinate coordinate, Feature f) {
    // feature hanging over edge of unloaded chunk when added
    if (f == null || f.remove) {
      return;
    }
    if (!this.hanging_features.containsKey(coordinate)) {
      this.hanging_features.put(coordinate, new ConcurrentHashMap<Integer, Feature>());
    }
    this.hanging_features.get(coordinate).putIfAbsent(f.map_key, f);
  }

  void featureRemovedMapSquareNotFound(IntegerCoordinate coordinate, Feature f) {
    // feature hanging over edge of unloaded chunk when removed
    if (f == null || f.remove) {
      return;
    }
    if (!this.hanging_features.containsKey(coordinate)) {
      return;
    }
    this.hanging_features.get(coordinate).remove(f.map_key);
    if (this.hanging_features.get(coordinate).isEmpty()) {
      this.hanging_features.remove(coordinate);
    }
  }

  synchronized void checkHangingFeatures() {
    Iterator hanging_features_iterator = this.hanging_features.entrySet().iterator();
    while(hanging_features_iterator.hasNext()) {
      Map.Entry<IntegerCoordinate, ConcurrentHashMap<Integer, Feature>> entry =
        (Map.Entry<IntegerCoordinate, ConcurrentHashMap<Integer, Feature>>)hanging_features_iterator.next();
      GameMapSquare square = this.mapSquare(entry.getKey().x, entry.getKey().y);
      if (square == null) {
        continue;
      }
      Iterator coordinate_iterator = entry.getValue().entrySet().iterator();
      while(coordinate_iterator.hasNext()) {
        Map.Entry<Integer, Feature> feature_entry = (Map.Entry<Integer, Feature>)coordinate_iterator.next();
        if (feature_entry.getValue() == null || feature_entry.getValue().remove) {
          coordinate_iterator.remove();
          continue;
        }
        if (this.resolveHangingFeature(feature_entry.getValue(), entry.getKey())) {
          coordinate_iterator.remove();
        }
      }
      if (entry.getValue().isEmpty()) {
        hanging_features_iterator.remove();
      }
    }
  }

  synchronized void checkHangingImages() {
    Iterator<HangingImage> hanging_image_iterator = this.hanging_images.iterator();
    while(hanging_image_iterator.hasNext()) {
      HangingImage hanging_image = hanging_image_iterator.next();
      if (hanging_image.resolve()) {
        hanging_image_iterator.remove();
      }
    }
  }

  boolean featureHanging(Feature f) {
    if (f == null || f.remove) {
      return false;
    }
    IntegerCoordinate x_edge = this.coordinateOf(round(f.x + f.sizeX), round(f.y));
    IntegerCoordinate y_edge = this.coordinateOf(round(f.x), round(f.y + f.sizeY));
    IntegerCoordinate xy_edge = this.coordinateOf(round(f.x + f.sizeX), round(f.y + f.sizeY));
    Chunk x_chunk = this.chunk_reference.get(x_edge);
    Chunk y_chunk = this.chunk_reference.get(y_edge);
    Chunk xy_chunk = this.chunk_reference.get(xy_edge);
    return (x_chunk == null || y_chunk == null || xy_chunk == null);
  }

  boolean resolveHangingFeature(Feature f, IntegerCoordinate coordinate) {
    if (f == null || f.remove) {
      return true;
    }
    GameMapSquare square = this.mapSquare(coordinate.x, coordinate.y);
    Chunk chunk = this.chunk_reference.get(this.coordinateOf(coordinate.x, coordinate.y));
    if (square == null || chunk == null) { // still hanging
      return false;
    }
    square.addedFeature(f);
    int x_chunk = Math.floorMod(coordinate.x, Constants.map_chunkWidth);
    int y_chunk = Math.floorMod(coordinate.y, Constants.map_chunkWidth);
    DImg dimg = new DImg(f.getImage());
    dimg.setGrid(f.sizeX, f.sizeY);
    PImage image_piece = dimg.getImageGridPiece(coordinate.x - round(f.x), coordinate.y - round(f.y));
    chunk.terrain_dimg.addImageGrid(image_piece, x_chunk, y_chunk);
    return true;
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
  }

  void updateFeatures(int time_elapsed) {
    for (Chunk chunk : this.chunk_reference.values()) {
      Iterator feature_iterator = chunk.features.entrySet().iterator();
      while(feature_iterator.hasNext()) {
        Map.Entry<Integer, Feature> entry = (Map.Entry<Integer, Feature>)feature_iterator.next();
        updateFeature(entry.getValue(), feature_iterator, time_elapsed);
      }
    }
  }

  void updateFeaturesCheckRemovalOnly() {
    for (Chunk chunk : this.chunk_reference.values()) {
      Iterator feature_iterator = chunk.features.entrySet().iterator();
      while(feature_iterator.hasNext()) {
        Map.Entry<Integer, Feature> entry = (Map.Entry<Integer, Feature>)feature_iterator.next();
        if (entry.getValue().remove) {
          this.removeFeature(entry.getKey());
          feature_iterator.remove();
        }
      }
    }
  }


  @Override
  void displayNerdStats() {
    fill(255);
    textSize(14);
    textAlign(LEFT, TOP);
    float y_stats = this.yi + 31;
    float line_height = textAscent() + textDescent() + 2;
    text("Map Location: " + this.code.display_name(), this.xi + 1, y_stats);
    y_stats += line_height;
    text("FPS: " + int(global.lastFPS), this.xi + 1, y_stats);
    y_stats += line_height;
    try {
      text("Biome: " + this.chunk_reference.get(this.current_chunk).biome.displayName(), this.xi + 1, y_stats);
      y_stats += line_height;
    } catch(NullPointerException e) {}
    Map<Thread, StackTraceElement[]> all_threads = Thread.getAllStackTraces();
    text("Active Threads: " + all_threads.size(), this.xi + 1, y_stats);
    y_stats += line_height;
    int gamemap_threads = 0;
    int unit_threads = 0;
    for (Thread thread : all_threads.keySet()) {
      String thread_name = thread.getName();
      if (thread_name.equals("TerrainDimgThread") || thread_name.equals("MouseMoveThread") ||
        thread_name.equals("LoadChunkThread") || thread_name.equals("FogDImgThread")) {
        gamemap_threads++;
      }
      else if (thread_name.equals("PathFindingThread")) {
        unit_threads++;
      }
    }
    text("GameMap Threads: " + gamemap_threads, this.xi + 1, y_stats);
    y_stats += line_height;
    text("Unit Threads: " + unit_threads, this.xi + 1, y_stats);
    y_stats += line_height;
    text("Current View: " + this.viewX + ", " + this.viewY, this.xi + 1, y_stats);
    if (this.units.containsKey(0)) {
      y_stats += line_height;
      text("Location: (" + this.units.get(0).x + ", " + this.units.get(0).y +
        ", " + this.units.get(0).curr_height + ")", this.xi + 1, y_stats);
      y_stats += line_height;
      text("Facing: (" + this.units.get(0).facingX + ", " + this.units.get(0).facingY +
        ", " + this.units.get(0).facingA + ")", this.xi + 1, y_stats);
      y_stats += line_height;
      text("Height: (" + this.units.get(0).curr_height + ", " + this.units.get(0).floor_height +
        ", " + this.units.get(0).unit_height + ")", this.xi + 1, y_stats);
      try {
        GameMapSquare square = this.mapSquare(int(this.units.get(0).x), int(this.units.get(0).y));
        y_stats += line_height;
        text("Terrain: (" + square.terrainName() + ", " + int(10.0 * square.light_level)/10.0 + ")", this.xi + 1, y_stats);
      } catch(NullPointerException e) {}
    }
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
        noiseSeed(this.seed);
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not recognized for GameMap object.");
        break;
    }
  }
}
