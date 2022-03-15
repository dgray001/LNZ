enum GameMapCode {
  ERROR, HOMEBASE, FRANCIS_FLOOR2, FRANCIS_FLOOR1, FRANCIS_GROUND;

  private static final List<GameMapCode> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  public String display_name() {
    return GameMapCode.display_name(this);
  }
  static public String display_name(GameMapCode a) {
    switch(a) {
      case HOMEBASE:
        return "Home Base";
      case FRANCIS_FLOOR2:
        return "Francis Hall, 2nd floor";
      case FRANCIS_FLOOR1:
        return "Francis Hall, 1st floor";
      case FRANCIS_GROUND:
        return "Francis Hall, ground floor";
      default:
        return "-- Error --";
    }
  }

  public String file_name() {
    return GameMapCode.file_name(this);
  }
  static public String file_name(GameMapCode a) {
    switch(a) {
      case HOMEBASE:
        return "HOMEBASE";
      case FRANCIS_FLOOR2:
        return "FRANCIS_FLOOR2";
      case FRANCIS_FLOOR1:
        return "FRANCIS_FLOOR1";
      case FRANCIS_GROUND:
        return "FRANCIS_GROUND";
      default:
        return "ERROR";
    }
  }

  static public GameMapCode gameMapCode(String display_name) {
    for (GameMapCode code : GameMapCode.VALUES) {
      if (code == GameMapCode.ERROR) {
        continue;
      }
      if (GameMapCode.display_name(code).equals(display_name) ||
        GameMapCode.file_name(code).equals(display_name)) {
        return code;
      }
    }
    return GameMapCode.ERROR;
  }
}



enum ReadFileObject {
  NONE("None"), MAP("Map");

  private static final List<ReadFileObject> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  private String name;

  private ReadFileObject(String name) {
    this.name = name;
  }

  static public ReadFileObject objectType(String name) {
    for (ReadFileObject type : ReadFileObject.VALUES) {
      if (type == ReadFileObject.NONE) {
        continue;
      }
      if (type.name.equals(name)) {
        return type;
      }
    }
    return ReadFileObject.NONE;
  }
}



class GameMapSquare {
  private int baseHeight = 0;
  private int terrain_id = 0;

  GameMapSquare() {
    this.setTerrain(1);
  }
  GameMapSquare(int terrain_id) {
    this.setTerrain(terrain_id);
  }

  void setTerrain(int id) {
    this.terrain_id = id;
    if (id > 300) { // stairs
      this.baseHeight = 0;
    }
    else if (id > 200) { // walls
      this.baseHeight = 100;
    }
    else if (id > 100) { // floors
      this.baseHeight = 0;
    }
    else if (id == 1) { // map edge
      this.baseHeight = 100;
    }
    else {
      println("ERROR: Terrain ID " + id + " not found.");
    }
  }

  String terrainName() {
    switch(this.terrain_id) {
      case 101: // floors
      case 102:
      case 103:
      case 104:
        return "Carpet";
      case 111:
      case 112:
      case 113:
        return "Wood Floor";
      case 121:
      case 122:
      case 123:
        return "Tile Floor";
      case 131:
        return "Concrete Floor";
      case 151:
      case 152:
      case 153:
      case 154:
      case 155:
      case 156:
        return "Grass";
      case 161:
      case 162:
      case 163:
        return "Dirt";
      case 171:
      case 172:
      case 173:
      case 174:
      case 175:
      case 176:
      case 177:
      case 178:
      case 179:
        return "Road";
      case 201:
      case 202:
      case 203:
      case 204:
      case 205:
      case 206:
      case 207:
        return "Brick Wall";
      case 301:
      case 302:
      case 303:
      case 304:
      case 305:
      case 306:
      case 307:
      case 308:
      case 309:
      case 310:
      case 311:
      case 312:
      case 313:
      case 314:
      case 315:
      case 316:
        return "Stairs";
      default:
        return null;
    }
  }

  PImage terrainImage() {
    String imageName = "terrain/";
    switch(this.terrain_id) {
      case 1:
        imageName += "default.jpg";
        break;
      case 101:
        imageName += "carpet_light.jpg";
        break;
      case 102:
        imageName += "carpet_gray.jpg";
        break;
      case 103:
        imageName += "carpet_dark.jpg";
        break;
      case 104:
        imageName += "carpet_green.jpg";
        break;
      case 111:
        imageName += "woodFloor_light.jpg";
        break;
      case 112:
        imageName += "woodFloor_brown.jpg";
        break;
      case 113:
        imageName += "woodFloor_dark.jpg";
        break;
      case 121:
        imageName += "tile_red.jpg";
        break;
      case 122:
        imageName += "tile_green.jpg";
        break;
      case 123:
        imageName += "tile_gray.jpg";
        break;
      case 131:
        imageName += "concrete.jpg";
        break;
      case 132:
        imageName += "sidewalk1.jpg";
        break;
      case 133:
        imageName += "sidewalk2.jpg";
        break;
      case 141:
        imageName += "sand1.jpg";
        break;
      case 142:
        imageName += "sand2.jpg";
        break;
      case 143:
        imageName += "sand3.jpg";
        break;
      case 144:
        imageName += "sand3_left.jpg";
        break;
      case 145:
        imageName += "sand3_up.jpg";
        break;
      case 151:
        imageName += "grass1.jpg";
        break;
      case 152:
        imageName += "grass2.jpg";
        break;
      case 153:
        imageName += "grass3.jpg";
        break;
      case 154:
        imageName += "grass4.jpg";
        break;
      case 155:
        imageName += "grass2_line_left.jpg";
        break;
      case 156:
        imageName += "grass2_line_up.jpg";
        break;
      case 161:
        imageName += "dirt1.jpg";
        break;
      case 162:
        imageName += "dirt2.jpg";
        break;
      case 163:
        imageName += "dirt3.jpg";
        break;
      case 171:
        imageName += "road1.jpg";
        break;
      case 172:
        imageName += "road2.jpg";
        break;
      case 173:
        imageName += "road3.jpg";
        break;
      case 174:
        imageName += "road1_left.jpg";
        break;
      case 175:
        imageName += "road1_up.jpg";
        break;
      case 176:
        imageName += "road2_left.jpg";
        break;
      case 177:
        imageName += "road2_up.jpg";
        break;
      case 178:
        imageName += "road2_left_double.jpg";
        break;
      case 179:
        imageName += "road2_up_double.jpg";
        break;
      case 181:
        imageName += "water1.png";
        break;
      case 182:
        imageName += "water2.png";
        break;
      case 183:
        imageName += "water3.jpg";
        break;
      case 184:
        imageName += "water4.jpg";
        break;
      case 185:
        imageName += "water5.png";
        break;

      default:
        imageName += "default.jpg";
        break;
    }
    return global.images.getImage(imageName);
  }
}



class GameMap {
  protected GameMapCode code = GameMapCode.ERROR;
  protected String mapName = "";
  protected boolean nullify = false;

  protected int mapWidth = 0;
  protected int mapHeight = 0;
  protected GameMapSquare[][] squares;

  protected DImg terrain_dimg;
  protected DImg feature_dimg;
  protected DImg fog_dimg;
  protected boolean draw_fog = true;
  protected PImage terrain_display = createImage(0, 0, RGB);
  protected PImage feature_display = createImage(0, 0, ARGB);
  protected PImage fog_display = createImage(0, 0, ARGB);

  protected float viewX = 0;
  protected float viewY = 0;
  protected float zoom = Constants.map_defaultZoom;
  protected boolean view_moving_left = false;
  protected boolean view_moving_right = false;
  protected boolean view_moving_up = false;
  protected boolean view_moving_down = false;

  protected float xi = 0;
  protected float yi = 0;
  protected float xf = 0;
  protected float yf = 0;
  protected color color_border = color(60);
  protected color color_background = color(20);

  protected float xi_map = 0;
  protected float yi_map = 0;
  protected float xf_map = 0;
  protected float yf_map = 0;

  protected float startSquareX = 0;
  protected float startSquareY = 0;
  protected float visSquareX = 0;
  protected float visSquareY = 0;

  protected int lastUpdateTime = millis();

  protected boolean hovered_area = false;
  protected boolean hovered = false;
  protected float mX = 0;
  protected float mY = 0;
  protected MapObject hovered_object;

  protected ArrayList<Feature> features = new ArrayList<Feature>();
  //protected HashMap<Integer, Unit> units = new HashMap<Integer, Unit>();
  //protected int nextUnitID = 1;
  //protected HashMap<Integer, Item> items = new HashMap<Integer, Item>();
  //protected int nextItemID = 1;
  //protected ArrayList<Projectile> projectiles = new ArrayList<Projectile>();
  //protected ArrayList<VisualEffect> visuals = new ArrayList<VisualEffect>();

  GameMap(GameMapCode code, String folderPath) {
    this.code = code;
    this.mapName = GameMapCode.display_name(code);
    this.open(folderPath);
  }
  GameMap(String mapName, String folderPath) {
    this.mapName = mapName;
    this.open(folderPath);
  }
  GameMap(String mapName, int mapWidth, int mapHeight) {
    this.mapName = mapName;
    this.mapWidth = mapWidth;
    this.mapHeight = mapHeight;
    this.initializeSquares();
  }


  void initializeSquares() {
    this.squares = new GameMapSquare[this.mapWidth][this.mapHeight];
    for (int i = 0; i < this.mapWidth; i++) {
      for (int j = 0; j < this.mapHeight; j++) {
        this.squares[i][j] = new GameMapSquare();
      }
    }
    this.terrain_dimg = new DImg(this.mapWidth * Constants.map_terrainResolution, this.mapHeight * Constants.map_terrainResolution);
    this.terrain_dimg.setGrid(this.mapWidth, this.mapHeight);
    this.terrain_dimg.colorPixels(color(20));
    this.feature_dimg = new DImg(this.mapWidth * Constants.map_featureResolution, this.mapHeight * Constants.map_featureResolution);
    this.feature_dimg.setGrid(this.mapWidth, this.mapHeight);
    this.fog_dimg = new DImg(this.mapWidth * Constants.map_fogResolution, this.mapHeight * Constants.map_fogResolution);
    this.fog_dimg.setGrid(this.mapWidth, this.mapHeight);
  }


  void setLocation(float xi, float yi, float xf, float yf) {
    this.xi = xi;
    this.yi = yi;
    this.xf = xf;
    this.yf = yf;
    this.refreshDisplayMapParameters();
  }


  void refreshDisplayMapParameters() { // in another thread ?
    this.startSquareX = max(0, this.viewX - (0.5 * width - this.xi - Constants.map_borderSize) / this.zoom);
    this.startSquareY = max(0, this.viewY - (0.5 * height - this.yi - Constants.map_borderSize) / this.zoom);
    this.xi_map = 0.5 * width - (this.viewX - this.startSquareX) * this.zoom;
    this.yi_map = 0.5 * height - (this.viewY - this.startSquareY) * this.zoom;
    this.visSquareX = min(this.mapWidth - this.startSquareX, (this.xf - this.xi_map - Constants.map_borderSize) / this.zoom);
    this.visSquareY = min(this.mapHeight - this.startSquareY, (this.yf - this.yi_map - Constants.map_borderSize) / this.zoom);
    this.xf_map = this.xi_map + this.visSquareX * this.zoom;
    this.yf_map = this.yi_map + this.visSquareY * this.zoom;
    this.refreshDisplayImages();
  }

  void refreshDisplayImages() {
    this.refreshTerrainImage();
    this.refreshFeatureImage();
    this.refreshFogImage();
  }
  void refreshTerrainImage() {
    this.terrain_display = resizeImage(this.terrain_dimg.getImagePiece(int(this.startSquareX * Constants.map_terrainResolution),
      int(this.startSquareY * Constants.map_terrainResolution), int(this.visSquareX * Constants.map_terrainResolution),
      int(this.visSquareY * Constants.map_terrainResolution)), int(this.xf_map - this.xi_map), int(this.yf_map - this.yi_map));
  }
  void refreshFeatureImage() {
    this.feature_display = resizeImage(this.feature_dimg.getImagePiece(int(this.startSquareX * Constants.map_featureResolution),
      int(this.startSquareY * Constants.map_featureResolution), int(this.visSquareX * Constants.map_featureResolution),
      int(this.visSquareY * Constants.map_featureResolution)), int(this.xf_map - this.xi_map), int(this.yf_map - this.yi_map));
  }
  void refreshFogImage() {
    this.fog_display = resizeImage(this.feature_dimg.getImagePiece(int(this.startSquareX * Constants.map_fogResolution),
      int(this.startSquareY * Constants.map_fogResolution), int(this.visSquareX * Constants.map_fogResolution),
      int(this.visSquareY * Constants.map_fogResolution)), int(this.xf_map - this.xi_map), int(this.yf_map - this.yi_map));
  }

  void setZoom(float zoom) {
    if (zoom > Constants.map_maxZoom) {
      zoom = Constants.map_maxZoom;
    }
    else if (zoom < Constants.map_minZoom) {
      zoom = Constants.map_minZoom;
    }
    this.zoom = zoom;
    this.refreshDisplayMapParameters();
  }
  void changeZoom(float amount) {
    this.setZoom(this.zoom + amount);
  }

  void setViewLocation(float viewX, float viewY) {
    this.setViewLocation(viewX, viewY, true);
  }
  void setViewLocation(float viewX, float viewY, boolean refreshImage) {
    if (viewX < 0) {
      viewX = 0;
    }
    else if (viewX > this.mapWidth) {
      viewX = this.mapWidth;
    }
    if (viewY < 0) {
      viewY = 0;
    }
    else if (viewY > this.mapHeight) {
      viewY = this.mapHeight;
    }
    this.viewX = viewX;
    this.viewY = viewY;
    if (refreshImage) {
      this.refreshDisplayMapParameters();
    }
  }
  void moveView(float changeX, float changeY) {
    this.moveView(changeX, changeY, true);
  }
  void moveView(float changeX, float changeY, boolean refreshImage) {
    this.setViewLocation(this.viewX + changeX, this.viewY + changeY, refreshImage);
  }


  void setTerrain(int id, int x, int y) {
    this.setTerrain(id, x, y, true);
  }
  void setTerrain(int id, int x, int y, boolean refreshImage) {
    try {
      this.squares[x][y].setTerrain(id);
      this.terrain_dimg.addImageGrid(this.squares[x][y].terrainImage(), x, y);
      if (refreshImage) {
        this.refreshDisplayImages();
      }
    }
    catch(IndexOutOfBoundsException e) {}
  }
  void setTerrainHeight(int h, int x, int y) {
    try {
      this.squares[x][y].baseHeight = h;
    }
    catch(IndexOutOfBoundsException e) {}
  }

  void addFeature(Feature f) {
    if (!f.inMap(this.mapWidth, this.mapHeight)) {
      return;
    }
    this.feature_dimg.addImageGrid(f.getImage(), int(floor(f.x)), int(floor(f.y)), f.xSize, f.ySize);
    this.refreshFeatureImage();
    this.features.add(f);
  }
  void removeFeature(int index) {
    if (index < 0 || index >= this.features.size()) {
      return;
    }
    Feature f = this.features.get(index);
    // clear grid where feature was
    this.feature_dimg.colorGrid(color(1, 0), int(round(f.x)), int(round(f.y)), f.xSize, f.ySize);
    // add back in feature images that overlap
    for (int i = 0; i < this.features.size(); i++) {
      if (i == index) {
        continue;
      }
      Feature f2 = this.features.get(i);
      if (f2.x < f.x + f.xSize && f2.y < f.y + f.ySize && f2.x + f2.xSize > f.x && f2.y + f2.ySize > f.y) {
        DImg dimg = new DImg(f2.getImage());
        dimg.setGrid(f2.xSize, f2.ySize);
        int xi_overlap = int(round(max(f.x, f2.x)));
        int yi_overlap = int(round(max(f.y, f2.y)));
        int w_overlap = int(round(min(f.xf() - xi_overlap, f2.xf() - xi_overlap)));
        int h_overlap = int(round(min(f.yf() - yi_overlap, f2.yf() - yi_overlap)));
        PImage imagePiece = dimg.getImageGridPiece(xi_overlap - int(round(f2.x)),
          yi_overlap - int(round(f2.y)), w_overlap, h_overlap);
        imagePiece.save("test.png");
        this.feature_dimg.addImageGrid(imagePiece, xi_overlap, yi_overlap, w_overlap, h_overlap);
      }
    }
    // refresh image
    this.refreshFeatureImage();
    // remove feature
    this.features.remove(index);
  }

  //void addUnit(Unit u) {
  //}
  // remove unit

  //void addItem(Item i) {
  //}
  // remove item


  void drawMap() {
    rectMode(CORNERS);
    noStroke();
    fill(this.color_border);
    rect(this.xi, this.yi, this.xf, this.yf);
    fill(this.color_background);
    rect(this.xi + Constants.map_borderSize, this.yi + Constants.map_borderSize,
      this.xf - Constants.map_borderSize, this.yf - Constants.map_borderSize);
    // display terrain
    imageMode(CORNERS);
    image(this.terrain_display, this.xi_map, this.yi_map, this.xf_map, this.yf_map);
    // display feature
    image(this.feature_display, this.xi_map, this.yi_map, this.xf_map, this.yf_map);
    // display units
    // display items
    // display projectiles
    // display visual effects
    // display fog
    if (this.draw_fog) {
      imageMode(CORNERS);
      image(this.fog_display, this.xi_map, this.yi_map, this.xf_map, this.yf_map);
    }
  }


  void updateView(int timeElapsed) {
    boolean refreshView = false;
    if (this.view_moving_left) {
      this.moveView(-timeElapsed * global.profile.options.map_viewMoveSpeedFactor, 0, false);
      refreshView = true;
    }
    if (this.view_moving_right) {
      this.moveView(timeElapsed * global.profile.options.map_viewMoveSpeedFactor, 0, false);
      refreshView = true;
    }
    if (this.view_moving_up) {
      this.moveView(0, -timeElapsed * global.profile.options.map_viewMoveSpeedFactor, false);
      refreshView = true;
    }
    if (this.view_moving_down) {
      this.moveView(0, timeElapsed * global.profile.options.map_viewMoveSpeedFactor, false);
      refreshView = true;
    }
    if (refreshView) {
      this.refreshDisplayMapParameters();
    }
  }


  void updateMap(int timeElapsed) {
    // Update features
    for (int i = 0; i < this.features.size(); i++) {
      if (this.features.get(i).remove) {
        this.removeFeature(i);
        i--;
        continue;
      }
      this.features.get(i).update(timeElapsed);
      if (this.features.get(i).remove) {
        this.removeFeature(i);
        i--;
      }
    }
    // Update units
    // Update items
    // Update projectiles
    // Update visual effects
  }


  void updateMapCheckObjectRemovalOnly() {
    // Check features
    for (int i = 0; i < this.features.size(); i++) {
      if (this.features.get(i).remove) {
        this.removeFeature(i);
        i--;
      }
    }
    // Check units
    // Check items
    // Check projectiles
    // Check visual effects
  }


  void update(int millis) {
    int timeElapsed = millis - this.lastUpdateTime;
    this.updateMap(timeElapsed); // map and mapObject logic
    this.updateView(timeElapsed); // visual changes in map
    this.drawMap(); // everything visual
    this.lastUpdateTime = millis;
  }

  void mouseMove(float mX, float mY) {
    if (mX > this.xi_map && mY > this.yi_map && mX < this.xf_map && mY < this.yf_map) {
      this.hovered = true;
      this.hovered_area = true;
      this.mX = this.startSquareX + (mX - this.xi_map) / this.zoom;
      this.mY = this.startSquareY + (mY - this.yi_map) / this.zoom;
      // update hovered for map objects
      this.hovered_object = null;
      for (Feature f : this.features) {
        f.mouseMove(this.mX, this.mY);
        if (f.hovered) {
          this.hovered_object = f;
        }
      }
    }
    else {
      this.hovered = false;
      if (mX > this.xi && mY > this.yi && mX < this.xf && mY < this.yf) {
        this.hovered_area = true;
      }
      else {
        this.hovered_area = false;
      }
      // dehover map objects
      for (Feature f : this.features) {
        f.hovered = false;
      }
    }
  }

  void mousePress() {
  }

  void mouseRelease() {
  }

  void scroll(int amount) {
    if (this.hovered_area) {
      this.changeZoom(Constants.map_scrollZoomFactor * amount);
    }
  }

  void keyPress() {
  }

  void keyRelease() {
  }


  void save(String folderPath) {
    PrintWriter file;
    if (this.code == GameMapCode.ERROR) {
      file = createWriter(folderPath + "/" + this.mapName + ".map.lnz");
    }
    else {
      file = createWriter(folderPath + "/" + this.code.file_name() + ".map.lnz");
    }
    file.println("new: Map");
    file.println("code: " + this.code.file_name());
    file.println("mapName: " + this.mapName);
    file.println("dimensions: " + this.mapWidth + ", " + this.mapHeight);
    for (int i = 0; i < this.mapWidth; i++) {
      for (int j = 0; j < this.mapHeight; j++) {
        file.println("terrain: " + i + ", " + j + ": " + this.squares[i][j].terrain_id +
          ", " + this.squares[i][j].baseHeight);
      }
    }
    file.println("end: Map");
    file.flush();
    file.close();
  }


  void open(String folderPath) {
    String[] lines;
    String path;
    if (this.code == GameMapCode.ERROR) {
      path = folderPath + "/" + this.mapName + ".map.lnz";
    }
    else {
      path = folderPath + "/" + this.code.file_name() + ".map.lnz";
    }
    lines = loadStrings(path);
    if (lines == null) {
      println("ERROR: Reading map at path " + path + " but no file exists.");
      this.nullify = true;
      return;
    }

    Stack<ReadFileObject> object_queue = new Stack<ReadFileObject>();

    for (String line : lines) {
      String[] parameters = split(line, ':');
      if (parameters.length < 2) {
        continue;
      }

      String dataname = trim(parameters[0]);
      String data = trim(parameters[1]);
      for (int i = 2; i < parameters.length; i++) {
        data += ":" + parameters[i];
      }
      if (dataname.equals("new")) {
        ReadFileObject type = ReadFileObject.objectType(data);
        switch(type) {
          case MAP:
            object_queue.push(type);
            break;
          default:
            break;
        }
      }
      else if (dataname.equals("end")) {
        ReadFileObject type = ReadFileObject.objectType(data);
        if (object_queue.empty()) {
          println("ERROR: Tring to end a " + type.name + " object but not inside any object.");
        }
        else if (type.name.equals(object_queue.peek().name)) {
          switch(object_queue.pop()) {
            case MAP:
              return;
            default:
              break;
          }
        }
        else {
          println("ERROR: Tring to end a " + type.name + " object while inside a " + object_queue.peek().name + " object.");
        }
      }
      else {
        switch(object_queue.peek()) {
          case MAP:
            this.addData(dataname, data);
            break;
          default:
            break;
        }
      }
    }
  }


  void addData(String dataname, String data) {
    switch(dataname) {
      case "code":
        this.code = GameMapCode.gameMapCode(data);
        break;
      case "mapName":
        this.mapName = data;
        break;
      case "dimensions":
        String[] dimensions = split(data, ',');
        if (dimensions.length < 2) {
          println("ERROR: Map missing dimensions in data: " + data + ".");
          this.mapWidth = 1;
          this.mapHeight = 1;
        }
        else {
          this.mapWidth = toInt(trim(dimensions[0]));
          this.mapHeight = toInt(trim(dimensions[1]));
        }
        this.initializeSquares();
        break;
      case "terrain":
        String[] data_split = split(data, ':');
        if (data_split.length < 2) {
          println("ERROR: Terrain missing dimension in data: " + data + ".");
          break;
        }
        String[] terrain_dimensions = split(data_split[0], ',');
        int terrain_x = toInt(trim(terrain_dimensions[0]));
        int terrain_y = toInt(trim(terrain_dimensions[1]));
        String[] terrain_values = split(data_split[1], ',');
        int terrain_id = toInt(trim(terrain_values[0]));
        int terrain_height = toInt(trim(terrain_values[1]));
        this.setTerrain(terrain_id, terrain_x, terrain_y, false);
        this.setTerrainHeight(terrain_height, terrain_x, terrain_y);
        break;
      default:
        println("ERROR: Dataname " + dataname + " not recognized for GameMap object.");
        break;
    }
  }
}



class GameMapEditor extends GameMap {
  protected boolean dropping_terrain = false;
  protected int terrain_id = 0;
  protected MapObject dropping_object;

  protected boolean draw_grid = true;

  GameMapEditor(GameMapCode code, String folderPath) {
    super(code, folderPath);
  }
  GameMapEditor(String mapName, String folderPath) {
    super(mapName, folderPath);
  }
  GameMapEditor(String mapName, int mapWidth, int mapHeight) {
    super(mapName, mapWidth, mapHeight);
  }


  void dropTerrain(int id) {
    this.dropping_terrain = true;
    this.terrain_id = id;
  }


  @Override
  void update(int millis) {
    int timeElapsed = millis - this.lastUpdateTime;

    // update view
    this.updateView(timeElapsed);

    // draw map
    this.drawMap();

    // check map object removals
    this.updateMapCheckObjectRemovalOnly();

    // draw grid
    if (this.draw_grid) {
      stroke(255);
      strokeWeight(0.5);
      textSize(10);
      textAlign(LEFT, TOP);
      rectMode(CORNER);
      for (int i = int(ceil(this.startSquareX)); i < int(floor(this.startSquareX + this.visSquareX)); i++) {
        for (int j = int(ceil(this.startSquareY)); j < int(floor(this.startSquareY + this.visSquareY)); j++) {
          float x = this.xi_map + this.zoom * i;
          float y = this.yi_map + this.zoom * j;
          fill(200, 50);
          rect(x, y, this.zoom, this.zoom);
          fill(255);
          text("(" + i + ", " + j + ")", x + 1, y + 1);
        }
      }
    }

    // draw object dropping
    if (!this.hovered_area) {
      return;
    }
    if (this.dropping_terrain) {
      imageMode(CENTER);
      image((new GameMapSquare(this.terrain_id)).terrainImage(), mouseX, mouseY, this.zoom, this.zoom);
    }
    else if (this.dropping_object == null) {
      imageMode(CORNER);
      image(global.images.getImage("items/eraser.png"), mouseX, mouseY, this.zoom, this.zoom);
    }
    else {
      if (Feature.class.isInstance(this.dropping_object)) {
        imageMode(CORNER);
        image(this.dropping_object.getImage(), mouseX - 0.5 * this.zoom, mouseY - 0.5 * this.zoom,
          this.zoom * this.dropping_object.width(), this.zoom * this.dropping_object.height());
      }
      else {
        imageMode(CENTER);
        image(this.dropping_object.getImage(), mouseX, mouseY, this.zoom *
          this.dropping_object.width(), this.zoom * this.dropping_object.height());
      }
    }

    this.lastUpdateTime = millis;
  }

  @Override
  void mousePress() {
    switch(mouseButton) {
      case LEFT:
        break;
      case RIGHT:
        if (this.dropping_terrain) {
          this.setTerrain(this.terrain_id, int(floor(this.mX)), int(floor(this.mY)));
        }
        else if (this.dropping_object == null) { // erase
          if (this.hovered_object != null) {
            this.hovered_object.remove = true;
          }
        }
        else {
          if (Feature.class.isInstance(this.dropping_object)) {
            this.dropping_object.setLocation(this.mX, this.mY);
            this.addFeature((Feature)this.dropping_object);
            this.dropping_object = new Feature(this.dropping_object.ID);
          }
          // else if unit, item
        }
        break;
      case CENTER:
        this.dropping_terrain = false;
        this.dropping_object = null;
        break;
    }
  }

  @Override
  void keyPress() {
    if (key == CODED) {
      switch(keyCode) {
        case LEFT:
          this.view_moving_left = true;
          break;
        case RIGHT:
          this.view_moving_right = true;
          break;
        case UP:
          this.view_moving_up = true;
          break;
        case DOWN:
          this.view_moving_down = true;
          break;
      }
    }
    else {
      switch(key) {
      }
    }
  }

  @Override
  void keyRelease() {
    if (key == CODED) {
      switch(keyCode) {
        case LEFT:
          this.view_moving_left = false;
          break;
        case RIGHT:
          this.view_moving_right = false;
          break;
        case UP:
          this.view_moving_up = false;
          break;
        case DOWN:
          this.view_moving_down = false;
          break;
      }
    }
    else {
      switch(key) {
      }
    }
  }
}
