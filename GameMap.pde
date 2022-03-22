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
  NONE("None"), MAP("Map"), FEATURE("Feature"), UNIT("Unit"), ITEM("Item");

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



enum MapFogHandling {
  DEFAULT("Default"), NONE("None"), EXPLORED("Explored"), NOFOG("NoFog");

  private static final List<MapFogHandling> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  private String name;

  private MapFogHandling(String name) {
    this.name = name;
  }

  static public MapFogHandling fogHandling(String name) {
    for (MapFogHandling fogH : MapFogHandling.VALUES) {
      if (fogH.name.equals(name)) {
        return fogH;
      }
    }
    return MapFogHandling.NONE;
  }
}



class GameMapSquare {
  private int base_elevation = 0;
  private int feature_elevation = 0;
  private int terrain_id = 0;
  private boolean explored = false;
  private boolean visible = false;

  GameMapSquare() {
    this.setTerrain(1);
  }
  GameMapSquare(int terrain_id) {
    this.setTerrain(terrain_id);
  }

  void setTerrain(int id) {
    this.terrain_id = id;
    if (id > 300) { // stairs
      this.base_elevation = 0;
    }
    else if (id > 200) { // walls
      this.base_elevation = 100;
    }
    else if (id > 100) { // floors
      this.base_elevation = 0;
    }
    else if (id == 1) { // map edge
      this.base_elevation = 100;
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
      case 132:
      case 133:
        return "Sidewalk";
      case 141:
      case 142:
      case 143:
        return "Sand";
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
      case 181:
      case 182:
      case 183:
      case 184:
      case 185:
        return "Water";
      case 201:
      case 202:
      case 203:
      case 204:
      case 205:
      case 206:
      case 207:
        return "Brick Wall";
      case 211:
      case 212:
      case 213:
        return "Wooden Wall";
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
      case 317:
      case 318:
      case 319:
      case 320:
      case 321:
      case 322:
      case 323:
      case 324:
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
      case 134:
        imageName += "gravel1.jpg";
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
      case 201:
        imageName += "brickWall_blue.jpg";
        break;
      case 202:
        imageName += "brickWall_gray.jpg";
        break;
      case 203:
        imageName += "brickWall_green.jpg";
        break;
      case 204:
        imageName += "brickWall_pink.jpg";
        break;
      case 205:
        imageName += "brickWall_red.jpg";
        break;
      case 206:
        imageName += "brickWall_yellow.jpg";
        break;
      case 207:
        imageName += "brickWall_white.jpg";
        break;
      case 211:
        imageName += "woodWall_light.jpg";
        break;
      case 212:
        imageName += "woodWall_brown.jpg";
        break;
      case 213:
        imageName += "woodWall_dark.jpg";
        break;
      case 301:
        imageName += "stairs_gray_up.jpg";
        break;
      case 302:
        imageName += "stairs_gray_down.jpg";
        break;
      case 303:
        imageName += "stairs_gray_left.jpg";
        break;
      case 304:
        imageName += "stairs_gray_right.jpg";
        break;
      case 305:
        imageName += "stairs_green_up.jpg";
        break;
      case 306:
        imageName += "stairs_green_down.jpg";
        break;
      case 307:
        imageName += "stairs_green_left.jpg";
        break;
      case 308:
        imageName += "stairs_green_right.jpg";
        break;
      case 309:
        imageName += "stairs_red_up.jpg";
        break;
      case 310:
        imageName += "stairs_red_down.jpg";
        break;
      case 311:
        imageName += "stairs_red_left.jpg";
        break;
      case 312:
        imageName += "stairs_red_right.jpg";
        break;
      case 313:
        imageName += "stairs_white_up.jpg";
        break;
      case 314:
        imageName += "stairs_white_down.jpg";
        break;
      case 315:
        imageName += "stairs_white_left.jpg";
        break;
      case 316:
        imageName += "stairs_white_right.jpg";
        break;
      case 317:
        imageName += "stairway_green_up.png";
        break;
      case 318:
        imageName += "stairway_green_down.png";
        break;
      case 319:
        imageName += "stairway_green_left.png";
        break;
      case 320:
        imageName += "stairway_green_right.png";
        break;
      case 321:
        imageName += "stairway_red_up.png";
        break;
      case 322:
        imageName += "stairway_red_down.png";
        break;
      case 323:
        imageName += "stairway_red_left.png";
        break;
      case 324:
        imageName += "stairway_red_right.png";
        break;

      default:
        imageName += "default.jpg";
        break;
    }
    return global.images.getImage(imageName);
  }
}



class GameMap {

  class HeaderMessage {
    private String message;
    private int text_align;
    private float text_size;
    private boolean fading = true;
    private boolean showing = true;
    private int fade_time = Constants.map_headerMessageFadeTime;
    private int show_time = Constants.map_headerMessageShowTime;
    private color color_background = color(110, 90, 70, 150);
    private color color_text = color(255);

    private float xi = 0;
    private float yi = 0;
    private float xf = 0;
    private float yf = 0;
    private float centerX = 0;
    private float centerY = 0;

    private int alpha = 255;
    private boolean hovered = false;
    private boolean remove = false;

    HeaderMessage(String message) {
      this(message, CENTER, Constants.map_defaultHeaderMessageTextSize);
    }
    HeaderMessage(String message, int text_align) {
      this(message, text_align, Constants.map_defaultHeaderMessageTextSize);
    }
    HeaderMessage(String message, int text_align, float text_size) {
      this.message = message;
      this.text_align = text_align;
      this.text_size = text_size;
      this.evaluateSize();
    }

    void evaluateSize() {
      textSize(this.text_size);
      float size_width = textWidth(this.message) + 4;
      float size_height = textAscent() + textDescent() + 2;
      switch(this.text_align) {
        case LEFT:
          this.xi = GameMap.this.xi + 5;
          this.yi = GameMap.this.yi + Constants.map_borderSize + 1;
          this.xf = this.xi + size_width;
          this.yf = this.yi + size_height;
          break;
        case RIGHT:
          this.xi = GameMap.this.xf - 5 - size_width;
          this.yi = GameMap.this.yi + Constants.map_borderSize + 1;
          this.xf = GameMap.this.xf - 5;
          this.yf = this.yi + size_height;
          break;
        case CENTER:
        default:
          this.xi = 0.5 * (width - size_width);
          this.yi = GameMap.this.yi + Constants.map_borderSize + 1;
          this.xf = 0.5 * (width + size_width);
          this.yf = this.yi + size_height;
          break;
      }
      this.centerX = this.xi + 0.5 * (this.xf - this.xi);
      this.centerY = this.yi + 0.5 * (this.yf - this.yi);
    }

    void updateView(int timeElapsed) {
      if (this.remove) {
        return;
      }
      if (this.fading) {
        this.fade_time -= timeElapsed;
        if (this.fade_time <= 0) {
          if (this.showing) {
            this.fading = false;
            this.show_time = Constants.map_headerMessageShowTime;
          }
          else {
            this.remove = true;
          }
        }
        if (this.showing) {
          this.alpha = int(round(255 * (Constants.map_headerMessageFadeTime - this.fade_time) / Constants.map_headerMessageFadeTime));
        }
        else {
          this.alpha = int(round(255 * this.fade_time / Constants.map_headerMessageFadeTime));
        }
      }
      else {
        this.alpha = 255;
        this.show_time -= timeElapsed;
        if (this.show_time <= 0) {
          this.fading = true;
          this.fade_time = Constants.map_headerMessageFadeTime;
          this.showing = false;
        }
      }
    }

    void drawMessage() {
      if (this.remove) {
        return;
      }
      rectMode(CORNERS);
      fill(this.color_background, alpha);
      rect(this.xi, this.yi, this.xf, this.yf);
      textAlign(CENTER, BOTTOM);
      textSize(this.text_size);
      fill(this.color_text, alpha);
      text(this.message, this.centerX, this.yf - 2);
    }

    void mouseMove(float mX, float mY) {
      if (mX > this.xi && mY > this.yi && mX < this.xf && mY < this.yf) {
        this.hovered = true;
      }
      else {
        this.hovered = false;
      }
    }

    void mousePress() {
      if (this.hovered) {
        this.fading = false;
        this.showing = true;
        this.show_time = Constants.map_headerMessageShowTime;
      }
    }
  }



  protected GameMapCode code = GameMapCode.ERROR;
  protected String mapName = "";
  protected boolean nullify = false;

  protected int mapWidth = 0;
  protected int mapHeight = 0;
  protected GameMapSquare[][] squares;

  protected DImg terrain_dimg;
  //protected DImg feature_dimg;
  protected DImg fog_dimg;
  protected MapFogHandling fogHandling = MapFogHandling.DEFAULT;
  protected color fogColor = color(170, 100);
  protected boolean draw_fog = true;
  protected PImage terrain_display = createImage(0, 0, RGB);
  //protected PImage feature_display = createImage(0, 0, ARGB);
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
  protected HashMap<Integer, Unit> units = new HashMap<Integer, Unit>();
  protected int nextUnitKey = 1;
  protected HashMap<Integer, Item> items = new HashMap<Integer, Item>();
  protected int nextItemKey = 1;
  //protected ArrayList<Projectile> projectiles = new ArrayList<Projectile>();
  //protected ArrayList<VisualEffect> visuals = new ArrayList<VisualEffect>();

  protected Queue<HeaderMessage> headerMessages = new LinkedList<HeaderMessage>();

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
    //this.feature_dimg = new DImg(this.mapWidth * Constants.map_featureResolution, this.mapHeight * Constants.map_featureResolution);
    //this.feature_dimg.setGrid(this.mapWidth, this.mapHeight);
    this.fog_dimg = new DImg(this.mapWidth * Constants.map_fogResolution, this.mapHeight * Constants.map_fogResolution);
    this.fog_dimg.setGrid(this.mapWidth, this.mapHeight);
    this.setFogHandling(this.fogHandling);
  }


  void setLocation(float xi, float yi, float xf, float yf) {
    this.xi = xi;
    this.yi = yi;
    this.xf = xf;
    this.yf = yf;
    this.refreshDisplayMapParameters();
  }


  void setFogHandling(MapFogHandling fogHandling) {
    this.fogHandling = fogHandling;
    switch(fogHandling) {
      case DEFAULT:
        this.fog_dimg.colorPixels(color(0));
        break;
      case NONE:
        this.fog_dimg.colorPixels(color(1, 0));
        for (int i = 0; i < this.mapWidth; i++) {
          for (int j = 0; j < this.mapHeight; j++) {
            this.exploreTerrain(i, j, false);
            this.setTerrainVisible(true, i, j, false);
          }
        }
        break;
      case NOFOG:
        this.fog_dimg.colorPixels(color(0));
        for (int i = 0; i < this.mapWidth; i++) {
          for (int j = 0; j < this.mapHeight; j++) {
            this.setTerrainVisible(true, i, j, false);
          }
        }
        break;
      case EXPLORED:
        this.fog_dimg.colorPixels(this.fogColor);
        for (int i = 0; i < this.mapWidth; i++) {
          for (int j = 0; j < this.mapHeight; j++) {
            this.exploreTerrain(i, j, false);
          }
        }
        break;
      default:
        println("ERROR: Fog handling " + fogHandling.name + " not recognized.");
        break;
    }
    this.refreshFogImage();
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
  //  this.feature_display = resizeImage(this.feature_dimg.getImagePiece(int(this.startSquareX * Constants.map_featureResolution),
  //    int(this.startSquareY * Constants.map_featureResolution), int(this.visSquareX * Constants.map_featureResolution),
  //    int(this.visSquareY * Constants.map_featureResolution)), int(this.xf_map - this.xi_map), int(this.yf_map - this.yi_map));
  }
  void refreshFogImage() {
    this.fog_display = this.fog_dimg.getImagePiece(int(this.startSquareX * Constants.map_fogResolution),
      int(this.startSquareY * Constants.map_fogResolution), int(this.visSquareX * Constants.map_fogResolution),
      int(this.visSquareY * Constants.map_fogResolution));
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
  void setTerrainBaseElevation(int h, int x, int y) {
    try {
      this.squares[x][y].base_elevation = h;
    }
    catch(IndexOutOfBoundsException e) {}
  }
  void exploreTerrain(int x, int y) {
    this.exploreTerrain(x, y, true);
  }
  void exploreTerrain(int x, int y, boolean refreshImage) {
    try {
      this.squares[x][y].explored = true;
      if (this.squares[x][y].visible) {
        this.fog_dimg.colorGrid(color(1, 0), x, y);
      }
      else {
        this.fog_dimg.colorGrid(this.fogColor, x, y);
      }
      if (refreshImage) {
        this.refreshFogImage();
      }
    }
    catch(IndexOutOfBoundsException e) {}
  }
  void setTerrainVisible(boolean visible, int x, int y) {
    this.setTerrainVisible(visible, x, y, true);
  }
  void setTerrainVisible(boolean visible, int x, int y, boolean refreshImage) {
    try {
      this.squares[x][y].visible = visible;
      if (!this.squares[x][y].explored) {
        this.fog_dimg.colorGrid(color(0), x, y);
      }
      if (!this.squares[x][y].visible) {
        this.fog_dimg.colorGrid(this.fogColor, x, y);
      }
      else {
        this.fog_dimg.colorGrid(color(1, 0), x, y);
      }
      if (refreshImage) {
        this.refreshFogImage();
      }
    }
    catch(IndexOutOfBoundsException e) {}
  }

  // add feature
  void addFeature(Feature f) {
    this.addFeature(f, true);
  }
  void addFeature(Feature f, boolean refreshImage) {
    if (!f.inMap(this.mapWidth, this.mapHeight)) {
      return;
    }
    for (int i = int(floor(f.x)); i < int(floor(f.x + f.sizeX)); i++) {
      for (int j = int(floor(f.y)); j < int(floor(f.y + f.sizeY)); j++) {
        this.squares[i][j].feature_elevation += f.sizeZ;
      }
    }
    if (f.isFog()) {
      //this.fog_dimg.addImageGrid(f.getImage(), int(floor(f.x)), int(floor(f.y)), f.sizeX, f.sizeY);
      if (refreshImage) {
        this.refreshFogImage();
      }
    }
    else {
      //this.feature_dimg.addImageGrid(f.getImage(), int(floor(f.x)), int(floor(f.y)), f.sizeX, f.sizeY);
      if (refreshImage) {
        this.refreshFeatureImage();
      }
    }
    this.features.add(f);
  }
  // remove feature
  void removeFeature(int index) {
    if (index < 0 || index >= this.features.size()) {
      return;
    }
    Feature f = this.features.get(index);
    if (!f.inMap(this.mapWidth, this.mapHeight)) {
      return;
    }
    for (int i = int(floor(f.x)); i < int(floor(f.x + f.sizeX)); i++) {
      for (int j = int(floor(f.y)); j < int(floor(f.y + f.sizeY)); j++) {
        this.squares[i][j].feature_elevation -= f.sizeZ;
      }
    }
    //this.feature_dimg.colorGrid(color(1, 0), int(round(f.x)), int(round(f.y)), f.sizeX, f.sizeY);
    for (int i = 0; i < this.features.size(); i++) {
      if (i == index) {
        continue;
      }
      Feature f2 = this.features.get(i);
      if (f2.x < f.x + f.sizeX && f2.y < f.y + f.sizeY && f2.x + f2.sizeX > f.x && f2.y + f2.sizeY > f.y) {
        DImg dimg = new DImg(f2.getImage());
        dimg.setGrid(f2.sizeX, f2.sizeY);
        int xi_overlap = int(round(max(f.x, f2.x)));
        int yi_overlap = int(round(max(f.y, f2.y)));
        int w_overlap = int(round(min(f.xf() - xi_overlap, f2.xf() - xi_overlap)));
        int h_overlap = int(round(min(f.yf() - yi_overlap, f2.yf() - yi_overlap)));
        PImage imagePiece = dimg.getImageGridPiece(xi_overlap - int(round(f2.x)),
          yi_overlap - int(round(f2.y)), w_overlap, h_overlap);
        imagePiece.save("test.png");
        //this.feature_dimg.addImageGrid(imagePiece, xi_overlap, yi_overlap, w_overlap, h_overlap);
      }
    }
    this.refreshFeatureImage();
    this.features.remove(index);
  }

  // add unit
  void addUnit(Unit u) {
    this.addUnit(u, this.nextUnitKey);
    this.nextUnitKey++;
  }
  void addUnit(Unit u, int code) {
    this.units.put(code, u);
  }
  // remove unit
  void removeUnit(int code) {
    if (this.units.containsKey(code)) {
      this.units.get(code).remove = true;
    }
  }

  // add item
  void addItem(Item i) {
    this.addItem(i, this.nextItemKey);
    this.nextItemKey++;
  }
  void addItem(Item i, int code) {
    this.items.put(code, i);
  }
  // remove item
  void removeItem(int code) {
    if (this.items.containsKey(code)) {
      this.items.get(code).remove = true;
    }
  }


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
    //image(this.feature_display, this.xi_map, this.yi_map, this.xf_map, this.yf_map);
    imageMode(CORNER);
    for (int i = 0; i < this.features.size(); i++) {
      Feature f = this.features.get(i);
      if (!f.inView(this.startSquareX, this.startSquareY, this.startSquareX + this.visSquareX, this.startSquareY + this.visSquareY)) {
        continue;
      }
      float translateX = this.xi_map + (f.x - this.startSquareX) * this.zoom;
      float translateY = this.yi_map + (f.y - this.startSquareY) * this.zoom;
      translate(translateX, translateY);
      image(f.getImage(), 0, 0, f.width() * this.zoom, f.height() * this.zoom);
      translate(-translateX, -translateY);
    }
    // display units
    imageMode(CENTER);
    Iterator unit_iterator = this.units.entrySet().iterator();
    while(unit_iterator.hasNext()) {
      Map.Entry<Integer, Unit> entry = (Map.Entry<Integer, Unit>)unit_iterator.next();
      Unit u = entry.getValue();
      if (!u.inView(this.startSquareX, this.startSquareY, this.startSquareX + this.visSquareX, this.startSquareY + this.visSquareY)) {
        continue;
      }
      float translateX = this.xi_map + (u.x - this.startSquareX) * this.zoom;
      float translateY = this.yi_map + (u.y - this.startSquareY) * this.zoom;
      translate(translateX, translateY);
      image(u.getImage(), 0, 0, u.width() * this.zoom, u.height() * this.zoom);
      translate(-translateX, -translateY);
    }
    // display items
    imageMode(CENTER);
    Iterator item_iterator = this.items.entrySet().iterator();
    while(item_iterator.hasNext()) {
      Map.Entry<Integer, Item> entry = (Map.Entry<Integer, Item>)item_iterator.next();
      Item i = entry.getValue();
      if (!i.inView(this.startSquareX, this.startSquareY, this.startSquareX + this.visSquareX, this.startSquareY + this.visSquareY)) {
        continue;
      }
      float translateX = this.xi_map + (i.x - this.startSquareX) * this.zoom;
      float translateY = this.yi_map + (i.y - this.startSquareY) * this.zoom;
      translate(translateX, translateY);
      image(i.getImage(), 0, 0, i.width() * this.zoom, i.height() * this.zoom);
      translate(-translateX, -translateY);
    }
    // display projectiles
    // display visual effects
    // display fog
    if (this.draw_fog) {
      imageMode(CORNERS);
      image(this.fog_display, this.xi_map, this.yi_map, this.xf_map, this.yf_map);
    }
    // header messages
    if (this.headerMessages.peek() != null) {
      this.headerMessages.peek().drawMessage();
    }
  }


  void updateView(int timeElapsed) {
    boolean refreshView = false;
    // moving view
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
    // header messages
    if (this.headerMessages.peek() != null) {
      this.headerMessages.peek().updateView(timeElapsed);
      if (this.headerMessages.peek().remove) {
        this.headerMessages.remove();
      }
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
    Iterator unit_iterator = this.units.entrySet().iterator();
    while(unit_iterator.hasNext()) {
      Map.Entry<Integer, Unit> entry = (Map.Entry<Integer, Unit>)unit_iterator.next();
      Unit u = entry.getValue();
      if (u.remove) {
        unit_iterator.remove();
        continue;
      }
      u.update(timeElapsed);
      if (u.remove) {
        unit_iterator.remove();
      }
    }
    // Update items
    Iterator item_iterator = this.items.entrySet().iterator();
    while(item_iterator.hasNext()) {
      Map.Entry<Integer, Item> entry = (Map.Entry<Integer, Item>)item_iterator.next();
      Item i = entry.getValue();
      if (i.remove) {
        item_iterator.remove();
        continue;
      }
      i.update(timeElapsed);
      if (i.remove) {
        item_iterator.remove();
      }
    }
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
    Iterator unit_iterator = this.units.entrySet().iterator();
    while(unit_iterator.hasNext()) {
      Map.Entry<Integer, Unit> entry = (Map.Entry<Integer, Unit>)unit_iterator.next();
      if (entry.getValue().remove) {
        unit_iterator.remove();
      }
    }
    // Check items
    Iterator item_iterator = this.items.entrySet().iterator();
    while(item_iterator.hasNext()) {
      Map.Entry<Integer, Item> entry = (Map.Entry<Integer, Item>)item_iterator.next();
      if (entry.getValue().remove) {
        item_iterator.remove();
      }
    }
    // Check projectiles
    // Check visual effects
  }


  void update(int millis) {
    int timeElapsed = millis - this.lastUpdateTime;
    this.updateMap(timeElapsed); // map and mapObject logic
    this.updateView(timeElapsed); // if moving or zooming (daylight changes?)
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
      for (Map.Entry<Integer, Unit> entry : this.units.entrySet()) {
        Unit u = entry.getValue();
        u.mouseMove(this.mX, this.mY);
        if (u.hovered) {
          this.hovered_object = u;
        }
      }
      for (Map.Entry<Integer, Item> entry : this.items.entrySet()) {
        Item i = entry.getValue();
        i.mouseMove(this.mX, this.mY);
        if (i.hovered) {
          this.hovered_object = i;
        }
      }
      // hovered for header message
      if (this.headerMessages.peek() != null) {
        this.headerMessages.peek().mouseMove(mX, mY);
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
      for (Map.Entry<Integer, Unit> entry : this.units.entrySet()) {
        entry.getValue().hovered = false;
      }
      for (Map.Entry<Integer, Item> entry : this.items.entrySet()) {
        entry.getValue().hovered = false;
      }
    }
  }

  void mousePress() {
    // clicked for header message
    if (this.headerMessages.peek() != null) {
      this.headerMessages.peek().mousePress();
    }
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
          ", " + this.squares[i][j].base_elevation + ", " + this.squares[i][j].explored);
      }
    }
    // add feature data
    for (Feature f : this.features) {
      file.println(f.fileString());
    }
    // add unit data
    for (Map.Entry<Integer, Unit> entry : this.units.entrySet()) {
      file.println("nextUnitKey: " + entry.getKey());
      file.println(entry.getValue().fileString());
    }
    // add item data
    for (Map.Entry<Integer, Item> entry : this.items.entrySet()) {
      file.println("nextItemKey: " + entry.getKey());
      file.println(entry.getValue().fileString());
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

    Feature curr_feature = null;
    int max_unit_key = 0;
    Unit curr_unit = null;
    int max_item_key = 0;
    Item curr_item = null;

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
        ReadFileObject type = ReadFileObject.objectType(trim(parameters[1]));
        switch(type) {
          case MAP:
            object_queue.push(type);
            break;
          case FEATURE:
            if (parameters.length < 3) {
              println("ERROR: Feature ID missing in Feature constructor.");
              break;
            }
            object_queue.push(type);
            curr_feature = new Feature(toInt(trim(parameters[2])));
            break;
          case UNIT:
            if (parameters.length < 3) {
              println("ERROR: Unit ID missing in Feature constructor.");
              break;
            }
            object_queue.push(type);
            curr_unit = new Unit(toInt(trim(parameters[2])));
            break;
          case ITEM:
            if (parameters.length < 3) {
              println("ERROR: Item ID missing in Feature constructor.");
              break;
            }
            object_queue.push(type);
            curr_item = new Item(toInt(trim(parameters[2])));
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
            case FEATURE:
              if (curr_feature == null) {
                println("ERROR: Trying to end a null feature.");
              }
              this.addFeature(curr_feature, false);
              curr_feature = null;
              break;
            case UNIT:
              if (curr_unit == null) {
                println("ERROR: Trying to end a null unit.");
              }
              if (this.nextUnitKey > max_unit_key) {
                max_unit_key = this.nextUnitKey;
              }
              this.addUnit(curr_unit);
              curr_unit = null;
              break;
            case ITEM:
              if (curr_item == null) {
                println("ERROR: Trying to end a null item.");
              }
              if (this.nextItemKey > max_item_key) {
                max_item_key = this.nextItemKey;
              }
              this.addItem(curr_item);
              curr_item = null;
              break;
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
          case FEATURE:
            if (curr_feature == null) {
              println("ERROR: Trying to add feature data to null feature.");
            }
            curr_feature.addData(dataname, data);
            break;
          case UNIT:
            if (curr_unit == null) {
              println("ERROR: Trying to add unit data to null unit.");
            }
            curr_unit.addData(dataname, data);
            break;
          case ITEM:
            if (curr_item == null) {
              println("ERROR: Trying to add item data to null item.");
            }
            curr_item.addData(dataname, data);
            break;
          default:
            break;
        }
      }
    }

    this.nextUnitKey = max_unit_key + 1;
    this.nextItemKey = max_item_key + 1;
  }


  void addData(String datakey, String data) {
    switch(datakey) {
      case "code":
        this.code = GameMapCode.gameMapCode(data);
        break;
      case "mapName":
        this.mapName = data;
        break;
      case "fogHandling":
        this.setFogHandling(MapFogHandling.fogHandling(data));
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
        if (terrain_dimensions.length < 2) {
          println("ERROR: Terrain dimensions missing dimension in data: " + data + ".");
          break;
        }
        int terrain_x = toInt(trim(terrain_dimensions[0]));
        int terrain_y = toInt(trim(terrain_dimensions[1]));
        String[] terrain_values = split(data_split[1], ',');
        if (terrain_values.length < 3) {
          println("ERROR: Terrain values missing dimension in data: " + data + ".");
          break;
        }
        int terrain_id = toInt(trim(terrain_values[0]));
        int terrain_height = toInt(trim(terrain_values[1]));
        this.setTerrain(terrain_id, terrain_x, terrain_y, false);
        this.setTerrainBaseElevation(terrain_height, terrain_x, terrain_y);
        if (toBoolean(trim(terrain_values[2]))) {
          this.exploreTerrain(terrain_x, terrain_y);
        }
        break;
      case "nextUnitKey":
        this.nextUnitKey = toInt(data);
        break;
      case "nextItemKey":
        this.nextItemKey = toInt(data);
        break;
      default:
        println("ERROR: Datakey " + datakey + " not recognized for GameMap object.");
        break;
    }
  }
}



class GameMapEditor extends GameMap {
  protected boolean dropping_terrain = false;
  protected int terrain_id = 0;
  protected MapObject dropping_object;
  protected MapObject prev_dropping_object;

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
    // check map object removals
    this.updateMapCheckObjectRemovalOnly();
    // update view
    this.updateView(timeElapsed);
    // draw map
    this.drawMap();
    // draw grid
    if (this.draw_grid) {
      stroke(255);
      strokeWeight(0.5);
      textSize(10);
      textAlign(LEFT, TOP);
      rectMode(CORNER);
      for (int i = int(ceil(this.startSquareX)); i < int(floor(this.startSquareX + this.visSquareX)); i++) {
        for (int j = int(ceil(this.startSquareY)); j < int(floor(this.startSquareY + this.visSquareY)); j++) {
          float x = this.xi_map + this.zoom * (i - this.startSquareX);
          float y = this.yi_map + this.zoom * (j - this.startSquareY);
          fill(200, 0);
          rect(x, y, this.zoom, this.zoom);
          fill(255);
          text("(" + i + ", " + j + ")", x + 1, y + 1);
        }
      }
    }
    // draw object dropping
    if (this.hovered_area) {
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
          else if (Unit.class.isInstance(this.dropping_object)) {
            this.dropping_object.setLocation(this.mX, this.mY);
            this.addUnit((Unit)this.dropping_object);
            this.dropping_object = new Unit(this.dropping_object.ID);
          }
          else if (Item.class.isInstance(this.dropping_object)) {
            this.dropping_object.setLocation(this.mX, this.mY);
            this.addItem((Item)this.dropping_object);
            this.dropping_object = new Item(this.dropping_object.ID);
          }
        }
        break;
      case CENTER:
        if (this.dropping_terrain) {
          this.dropping_terrain = false;
          this.dropping_object = null;
          this.prev_dropping_object = null;
        }
        else {
          if (this.dropping_object == null) {
            this.dropping_object = this.prev_dropping_object;
          }
          else {
            this.prev_dropping_object = this.dropping_object;
            this.dropping_object = null;
          }
        }
        break;
    }
    // clicked for header message
    if (this.headerMessages.peek() != null) {
      this.headerMessages.peek().mousePress();
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
        case 'z':
          this.draw_grid = !this.draw_grid;
          if (this.draw_grid) {
            this.headerMessages.add(new HeaderMessage("Showing Grid"));
          }
          else {
            this.headerMessages.add(new HeaderMessage("Hiding Grid"));
          }
          break;
        case 'x':
          this.draw_fog = !this.draw_fog;
          if (this.draw_fog) {
            this.headerMessages.add(new HeaderMessage("Showing Fog"));
          }
          else {
            this.headerMessages.add(new HeaderMessage("Hiding Fog"));
          }
          break;
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
