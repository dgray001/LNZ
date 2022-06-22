class GameMap extends AbstractGameMap {
  class TerrainDimgThread extends AbstractTerrainDimgThread {
    TerrainDimgThread() {
      super("TerrainDimgThread");
    }
    void updateTerrainDisplay() {
      PImage new_terrain_display = GameMap.this.terrain_dimg.getImagePiece(
        round(startSquareX * terrain_resolution), round(startSquareY * terrain_resolution),
        round(visSquareX * terrain_resolution), round(visSquareY * terrain_resolution));
      new_terrain_display = resizeImage(new_terrain_display,
        round(xf_map - xi_map), round(yf_map - yi_map));
      GameMap.this.terrain_display = new_terrain_display;
    }
  }


  protected int mapWidth = 0;
  protected int mapHeight = 0;
  protected GameMapSquare[][] squares;

  protected DImg terrain_dimg;
  protected DImg fog_dimg;

  protected HashMap<Integer, Feature> features = new HashMap<Integer, Feature>();

  GameMap() {
    super();
  }
  GameMap(GameMapCode code, String folderPath) {
    super();
    this.code = code;
    this.mapName = GameMapCode.display_name(code);
    this.open(folderPath);
  }
  GameMap(String mapName, String folderPath) {
    super();
    this.mapName = mapName;
    this.open(folderPath);
  }
  GameMap(String mapName, int mapWidth, int mapHeight) {
    super();
    this.mapName = mapName;
    this.mapWidth = mapWidth;
    this.mapHeight = mapHeight;
    this.initializeSquares();
  }


  int mapXI() {
    return 0;
  }
  int mapYI() {
    return 0;
  }
  int mapXF() {
    return this.mapWidth;
  }
  int mapYF() {
    return this.mapHeight;
  }
  int currMapXI() {
    return 0;
  }
  int currMapYI() {
    return 0;
  }
  int currMapXF() {
    return this.mapWidth;
  }
  int currMapYF() {
    return this.mapHeight;
  }


  GameMapSquare mapSquare(int i, int j) {
    try {
      return this.squares[i][j];
    } catch(ArrayIndexOutOfBoundsException e) {
      return null;
    }
  }

  void initializeSquares() {
    this.squares = new GameMapSquare[this.mapWidth][this.mapHeight];
    for (int i = 0; i < this.squares.length; i++) {
      for (int j = 0; j < this.squares[i].length; j++) {
        this.squares[i][j] = new GameMapSquare();
      }
    }
  }

  void initializeBackgroundImage() {
    this.terrain_dimg = new DImg(this.mapWidth * this.terrain_resolution, this.mapHeight * this.terrain_resolution);
    this.terrain_dimg.setGrid(this.mapWidth, this.mapHeight);
    for (int i = 0; i < this.mapWidth; i++) {
      for (int j = 0; j < this.mapHeight; j++) {
        this.terrain_dimg.addImageGrid(this.mapSquare(i, j).terrainImage(), i, j);
      }
    }
    for (Feature f : this.features.values()) {
      if (f.displaysImage()) {
        this.terrain_dimg.addImageGrid(f.getImage(), int(floor(f.x)), int(floor(f.y)), f.sizeX, f.sizeY);
      }
    }
    this.fog_dimg = new DImg(this.mapWidth * Constants.map_fogResolution, this.mapHeight * Constants.map_fogResolution);
    this.fog_dimg.setGrid(this.mapWidth, this.mapHeight);
  }

  void colorFogGrid(color c, int i, int j) {
    this.fog_dimg.colorGrid(c, i, j);
  }

  void terrainImageGrid(PImage img, int x, int y, int w, int h) {
    if (this.terrain_dimg == null) {
      return;
    }
    this.terrain_dimg.addImageGrid(img, x, y, w, h);
  }

  void colorTerrainGrid(color c, int x, int y, int w, int h) {
    if (this.terrain_dimg == null) {
      return;
    }
    this.terrain_dimg.colorGrid(c, x, y, w, h);
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
      updateFeature(entry.getValue(), feature_iterator, time_elapsed);
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
