enum ReadFileObject {
  NONE("None"), MAP("Map"), FEATURE("Feature"), UNIT("Unit"), ITEM("Item"),
  PROJECTILE("Projectile"), LEVEL("Level"), LINKER("Linker"), TRIGGER("Trigger"),
  CONDITION("Condition"), EFFECT("Effect"), STATUS_EFFECT("StatusEffect"),
  ABILITY("Ability"), HERO("Hero"), INVENTORY("Inventory");

  private static final List<ReadFileObject> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  private String name;

  private ReadFileObject(String name) {
    this.name = name;
  }

  public static ReadFileObject objectType(String name) {
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

  public static MapFogHandling fogHandling(String name) {
    for (MapFogHandling fogH : MapFogHandling.VALUES) {
      if (fogH.name.equals(name)) {
        return fogH;
      }
    }
    return MapFogHandling.NONE;
  }

  public boolean show_fog() {
    return MapFogHandling.show_fog(this);
  }
  public static boolean show_fog(MapFogHandling fogHandling) {
    switch(fogHandling) {
      case NONE:
      case NOFOG:
        return false;
      default:
        return true;
    }
  }
}



abstract class AbstractGameMap {
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
    private boolean clickable = true;
    private boolean centered = false;

    private float xi = 0;
    private float yi = 0;
    private float xf = 0;
    private float yf = 0;
    private float centerX = 0;
    private float centerY = 0;
    private int index = 0;

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

    void setTextSize(float text_size) {
      this.text_size = text_size;
      this.evaluateSize();
    }

    void evaluateSize() {
      textSize(this.text_size);
      float size_width = textWidth(this.message) + 4;
      float size_height = textAscent() + textDescent() + 2;
      switch(this.text_align) {
        case LEFT:
          this.xi = AbstractGameMap.this.xi + 5;
          this.yi = AbstractGameMap.this.yi + Constants.map_borderSize + 1;
          this.xf = this.xi + size_width;
          this.yf = this.yi + size_height;
          break;
        case RIGHT:
          this.xi = AbstractGameMap.this.xf - 5 - size_width;
          this.yi = AbstractGameMap.this.yi + Constants.map_borderSize + 1;
          this.xf = AbstractGameMap.this.xf - 5;
          this.yf = this.yi + size_height;
          break;
        case CENTER:
        default:
          this.xi = 0.5 * (width - size_width);
          this.yi = AbstractGameMap.this.yi + Constants.map_borderSize + 1;
          this.xf = 0.5 * (width + size_width);
          this.yf = this.yi + size_height;
          break;
      }
      this.centerX = this.xi + 0.5 * (this.xf - this.xi);
      this.centerY = this.yi + 0.5 * (this.yf - this.yi);
    }

    void placeCenter() {
      this.placeCenter(34);
    }
    void placeCenter(float text_size) {
      this.centered = true;
      this.text_size = text_size;
      textSize(this.text_size);
      float size_width = textWidth(this.message) + 4;
      float size_height = textAscent() + textDescent() + 2;
      this.xi = 0.5 * (width - size_width);
      this.yi = 0.5 * (height - size_height);
      this.xf = 0.5 * (width + size_width);
      this.yf = 0.5 * (height + size_height);
      this.centerX = this.xi + 0.5 * (this.xf - this.xi);
      this.centerY = this.yi + 0.5 * (this.yf - this.yi);
    }

    void updateView(int timeElapsed, int index) {
      if (this.remove) {
        return;
      }
      this.index = index;
      if (this.fading) {
        this.fade_time -= timeElapsed;
        if (this.fade_time <= 0) {
          if (this.showing) {
            this.fading = false;
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
      float translate_amount = this.index * (this.yf - this.yi + 4);
      translate(0, translate_amount);
      rectMode(CORNERS);
      fill(this.color_background, alpha);
      rect(this.xi, this.yi, this.xf, this.yf);
      textAlign(CENTER, BOTTOM);
      textSize(this.text_size);
      fill(this.color_text, alpha);
      text(this.message, this.centerX, this.yf - 2);
      translate(0, -translate_amount);
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
      if (this.hovered && this.clickable) {
        this.fading = false;
        this.showing = true;
        this.show_time = Constants.map_headerMessageShowTime;
      }
    }
  }



  class SelectedObjectTextbox extends TextBox {
    SelectedObjectTextbox() {
      super(Constants.map_selectedObjectPanelGap, 0.2 * height, Constants.
        map_selectedObjectPanelGap, 0.5 * height - 5);
      this.color_background = Constants.color_transparent;
      this.color_header = Constants.color_transparent;
      this.color_stroke = Constants.color_transparent;
      this.scrollbar.setButtonColors(color(170),
        adjust_color_brightness(global.color_panelBackground, 1.1),
        adjust_color_brightness(global.color_panelBackground, 1.2),
        adjust_color_brightness(global.color_panelBackground, 0.95), Constants.color_black);
      this.scrollbar.button_upspace.setColors(Constants.color_transparent, Constants.color_transparent,
        Constants.color_transparent, Constants.color_black, Constants.color_black);
      this.scrollbar.button_downspace.setColors(Constants.color_transparent, Constants.color_transparent,
        Constants.color_transparent, Constants.color_black, Constants.color_black);
      this.scrollbar.button_up.raised_border = false;
      this.scrollbar.button_down.raised_border = false;
    }
  }



  abstract class ConfirmForm extends FormLNZ {
    protected boolean canceled = false;

    ConfirmForm(String title, String message) {
      super(0.5 * (width - Constants.mapEditor_formWidth_small), 0.5 * (height - Constants.mapEditor_formHeight_small),
        0.5 * (width + Constants.mapEditor_formWidth_small), 0.5 * (height + Constants.mapEditor_formHeight_small));
      this.setTitleText(title);
      this.setTitleSize(18);
      this.color_background = color(180, 250, 180);
      this.color_header = color(30, 170, 30);

      SubmitCancelFormField submit = new SubmitCancelFormField("  Ok  ", "Cancel");
      submit.button1.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      submit.button2.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      this.addField(new SpacerFormField(0));
      this.addField(new TextBoxFormField(message, 120));
      this.addField(submit);
      this.min_x = AbstractGameMap.this.xi;
      this.min_y = AbstractGameMap.this.yi;
      this.max_x = AbstractGameMap.this.xf;
      this.max_y = AbstractGameMap.this.yf;
    }

    @Override
    void cancel() {
      this.canceled = true;
    }
  }



  abstract class AbstractTerrainDimgThread extends Thread {
    AbstractTerrainDimgThread(String thread_name) {
      super(thread_name);
    }
    @Override
    void run() {
      this.runThread();
    }
    abstract void runThread();
  }



  abstract class AbstractMouseMoveThread extends Thread {
    AbstractMouseMoveThread(String thread_name) {
      super(thread_name);
    }
    @Override
    void run() {
      this.runThread();
    }
    abstract void runThread();
  }



  protected GameMapCode code = GameMapCode.ERROR;
  protected String mapName = "";
  protected boolean nullify = false;
  protected int maxHeight = Constants.map_maxHeight;

  protected int terrain_resolution = Constants.map_terrainResolutionDefault;
  protected MapFogHandling fogHandling = MapFogHandling.DEFAULT;
  protected color fogColor = Constants.color_fog;
  protected boolean draw_fog = true;
  protected PImage terrain_display = createImage(0, 0, RGB);
  protected AbstractTerrainDimgThread terrain_dimg_thread;
  protected boolean update_terrain_display = false;
  protected boolean update_terrain_display_from_thread = false;
  protected PImage fog_display = createImage(0, 0, ARGB);

  protected float viewX = 0;
  protected float viewY = 0;
  protected float zoom = Constants.map_defaultZoom;
  protected float zoom_old = Constants.map_defaultZoom;
  protected boolean view_moving_left = false;
  protected boolean view_moving_right = false;
  protected boolean view_moving_up = false;
  protected boolean view_moving_down = false;

  protected float xi = 0;
  protected float yi = 0;
  protected float xf = 0;
  protected float yf = 0;
  protected color color_border = global.color_mapBackground;
  protected color color_background = global.color_mapBorder;
  protected color color_tint = Constants.color_transparent;
  protected boolean show_tint = false;

  protected float xi_map = 0;
  protected float yi_map = 0;
  protected float xf_map = 0;
  protected float yf_map = 0;
  protected float xi_map_old = 0;
  protected float yi_map_old = 0;
  protected float xf_map_old = 0;
  protected float yf_map_old = 0;
  protected float xi_map_dif = 0;
  protected float yi_map_dif = 0;
  protected float xf_map_dif = 0;
  protected float yf_map_dif = 0;

  protected float xi_fog = 0;
  protected float yi_fog = 0;
  protected float xf_fog = 0;
  protected float yf_fog = 0;

  protected float startSquareX = 0;
  protected float startSquareY = 0;
  protected float visSquareX = 0;
  protected float visSquareY = 0;
  protected float startSquareX_old = 0;
  protected float startSquareY_old = 0;
  protected float visSquareX_old = 0;
  protected float visSquareY_old = 0;

  protected int lastUpdateTime = millis();

  protected boolean hovered = false; // hover map
  protected boolean hovered_area = false; // hover GameMap-given area
  protected boolean hovered_border = false; // hover border
  protected boolean hovered_explored = false;
  protected boolean hovered_visible = false;
  protected boolean force_all_hoverable = false;

  protected float mX = 0;
  protected float mY = 0;
  protected float last_x = 0;
  protected float last_y = 0;
  protected AbstractMouseMoveThread mouse_move_thread = null;
  protected boolean restart_mouseMoveThread = false;
  protected MapObject hovered_object = null;
  protected MapObject selected_object = null;
  protected SelectedObjectTextbox selected_object_textbox = null;
  protected ArrayList<HeaderMessage> headerMessages = new ArrayList<HeaderMessage>();

  protected int nextFeatureKey = 1;
  protected HashMap<Integer, Unit> units = new HashMap<Integer, Unit>();
  protected int nextUnitKey = 1;
  protected int zombie_counter = 0;
  protected boolean in_control = true;
  protected HashMap<Integer, Item> items = new HashMap<Integer, Item>();
  protected int nextItemKey = 1;
  protected ArrayList<Projectile> projectiles = new ArrayList<Projectile>();
  protected ArrayList<VisualEffect> visualEffects = new ArrayList<VisualEffect>();

  protected float timer_refresh_fog = 0;
  protected float base_light_level = Constants.level_dayLightLevel;
  protected boolean outside_map = true;


  // put readfile/constructors into abstract as much as possible
  AbstractGameMap() {}


  abstract int mapXI();
  abstract int mapYI();
  abstract int mapXF();
  abstract int mapYF();
  abstract int currMapXI();
  abstract int currMapYI();
  abstract int currMapXF();
  abstract int currMapYF();
  int currWidth() {
    return this.currMapXF() - this.currMapXI();
  }
  int currHeight() {
    return this.currMapYF() - this.currMapYI();
  }

  abstract GameMapSquare mapSquare(int i, int j); // return null if out of bounds
  abstract void initializeSquares();
  void initializeTerrain() {
    this.terrain_resolution = global.profile.options.terrain_resolution;
    this.initializeBackgroundImage();
    this.setFogHandling(this.fogHandling);
  }
  abstract void initializeBackgroundImage();

  void setLocation(float xi, float yi, float xf, float yf) {
    this.xi = xi;
    this.yi = yi;
    this.xf = xf;
    this.yf = yf;
    if (this.selected_object_textbox != null) {
      this.selected_object_textbox.setXLocation(Constants.map_selectedObjectPanelGap,
        xi - Constants.map_selectedObjectPanelGap);
    }
    this.refreshDisplayMapParameters();
  }

  void setFogHandling(MapFogHandling fogHandling) {
    this.fogHandling = fogHandling;
    switch(fogHandling) {
      case DEFAULT:
        for (int i = this.currMapXI(); i < this.currMapXF(); i++) {
          for (int j = this.currMapYI(); j < this.currMapYF(); j++) {
            if (this.mapSquare(i, j).mapEdge()) {
              this.colorFogGrid(Constants.color_transparent, i, j);
            }
            else if (!this.mapSquare(i, j).explored) {
              this.colorFogGrid(Constants.color_black, i, j);
            }
            else if (!this.mapSquare(i, j).visible) {
              this.colorFogGrid(this.fogColor, i, j);
            }
            else {
              this.colorFogGrid(Constants.color_transparent, i, j);
            }
          }
        }
        break;
      case NONE:
        for (int i = this.currMapXI(); i < this.currMapXF(); i++) {
          for (int j = this.currMapYI(); j < this.currMapYF(); j++) {
            this.exploreTerrainAndVisible(i, j, false);
            this.colorFogGrid(Constants.color_transparent, i, j);
          }
        }
        break;
      case NOFOG:
        for (int i = this.currMapXI(); i < this.currMapXF(); i++) {
          for (int j = this.currMapYI(); j < this.currMapYF(); j++) {
            this.setTerrainVisible(true, i, j, false);
            if (this.mapSquare(i, j).mapEdge()) {
              this.colorFogGrid(Constants.color_transparent, i, j);
            }
            else if (!mapSquare(i, j).explored) {
              this.colorFogGrid(Constants.color_black, i, j);
            }
            else {
              this.colorFogGrid(Constants.color_transparent, i, j);
            }
          }
        }
        break;
      case EXPLORED:
        for (int i = this.currMapXI(); i < this.currMapXF(); i++) {
          for (int j = this.currMapYI(); j < this.currMapYF(); j++) {
            this.exploreTerrain(i, j, false);
            if (this.mapSquare(i, j).mapEdge()) {
              this.colorFogGrid(Constants.color_transparent, i, j);
            }
            else if (!this.mapSquare(i, j).visible) {
              this.colorFogGrid(this.fogColor, i, j);
            }
            else {
              this.colorFogGrid(Constants.color_transparent, i, j);
            }
          }
        }
        break;
      default:
        global.errorMessage("ERROR: Fog handling " + fogHandling.name + " not recognized.");
        break;
    }
    this.refreshFogImage();
  }
  abstract void colorFogGrid(color c, int i, int j);
  void terrainImageGrid(PImage img, int x, int y) {
    this.terrainImageGrid(img, x, y, 1, 1);
  }
  abstract void terrainImageGrid(PImage img, int x, int y, int w, int h);
  void colorTerrainGrid(color c, int x, int y) {
    this.colorTerrainGrid(c, x, y, 1, 1);
  }
  abstract void colorTerrainGrid(color c, int x, int y, int w, int h);

  void refreshDisplayMapParameters() {
    this.startSquareX = max(this.mapXI(), this.viewX - (0.5 * width - this.xi - Constants.map_borderSize) / this.zoom);
    this.startSquareY = max(this.mapYI(), this.viewY - (0.5 * height - this.yi - Constants.map_borderSize) / this.zoom);
    this.xi_map = 0.5 * width - (this.viewX - this.startSquareX) * this.zoom;
    this.yi_map = 0.5 * height - (this.viewY - this.startSquareY) * this.zoom;
    this.visSquareX = min(this.mapXF() - this.startSquareX, (this.xf - this.xi_map - Constants.map_borderSize) / this.zoom);
    this.visSquareY = min(this.mapYF() - this.startSquareY, (this.yf - this.yi_map - Constants.map_borderSize) / this.zoom);
    this.xf_map = this.xi_map + this.visSquareX * this.zoom;
    this.yf_map = this.yi_map + this.visSquareY * this.zoom;
    this.xi_map_dif = this.startSquareX - this.startSquareX_old;
    this.yi_map_dif = this.startSquareY - this.startSquareY_old;
    this.xf_map_dif = xi_map_dif + this.visSquareX - this.visSquareX_old;
    this.yf_map_dif = yi_map_dif + this.visSquareY - this.visSquareY_old;
    this.refreshDisplayImages();
  }

  void refreshDisplayImages() {
    this.refreshTerrainImage();
    this.refreshFogImage();
  }

  void refreshTerrainImage() {
    if (this.terrain_dimg_thread != null && this.terrain_dimg_thread.isAlive()) {
      this.update_terrain_display = true;
    }
    else {
      this.update_terrain_display = false;
      this.startTerrainDimgThread();
    }
  }
  abstract void startTerrainDimgThread();

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
    this.fog_display = this.getFogImagePiece(fog_xi, fog_yi, fog_w, fog_h);
  }
  abstract PImage getFogImagePiece(int fog_xi, int fog_yi, int fog_w, int fog_h);

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
    if (viewX < this.mapXI()) {
      viewX = this.mapXI();
    }
    else if (viewX > this.mapXF()) {
      viewX = this.mapXF();
    }
    if (viewY < this.mapYI()) {
      viewY = mapYI();
    }
    else if (viewY > this.mapYF()) {
      viewY = this.mapYF();
    }
    this.viewX = viewX;
    this.viewY = viewY;
    if (refreshImage) {
      this.refreshDisplayMapParameters();
      this.updateCursorPosition();
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
      this.mapSquare(x, y).setTerrain(id);
      this.terrainImageGrid(this.mapSquare(x, y).terrainImage(), x, y);
      if (refreshImage) {
        this.refreshDisplayImages();
      }
    }
    catch(IndexOutOfBoundsException e) {}
  }
  void setTerrainBaseElevation(int h, int x, int y) {
    try {
      this.mapSquare(x, y).base_elevation = h;
    }
    catch(NullPointerException e) {}
  }
  void exploreRectangle(Rectangle rect) {
    for (int i = int(rect.xi); i < int(rect.xf); i++) {
      for (int j = int(rect.yi); j < int(rect.yf); j++) {
        this.exploreTerrain(i, j, true);
      }
    }
  }
  void exploreTerrain(int x, int y) {
    this.exploreTerrain(x, y, true);
  }
  void exploreTerrain(int x, int y, boolean refreshFogImage) {
    try {
      if (this.mapSquare(x, y).explored) {
        return;
      }
      this.mapSquare(x, y).explored = true;
      if (refreshFogImage) {
        if (this.mapSquare(x, y).mapEdge()) {
          this.colorFogGrid(Constants.color_transparent, x, y);
        }
        else if (this.mapSquare(x, y).visible) {
          this.colorFogGrid(this.mapSquare(x, y).getColor(Constants.color_transparent), x, y);
        }
        else {
          this.colorFogGrid(this.mapSquare(x, y).getColor(this.fogColor), x, y);
        }
      }
    }
    catch(NullPointerException e) {}
  }
  void exploreTerrainAndVisible(int x, int y) {
    this.exploreTerrainAndVisible(x, y, true);
  }
  void exploreTerrainAndVisible(int x, int y, boolean refreshFogImage) {
    try {
      if (this.mapSquare(x, y).explored && this.mapSquare(x, y).visible) {
        return;
      }
      this.mapSquare(x, y).explored = true;
      this.mapSquare(x, y).visible = true;
      if (refreshFogImage) {
        if (this.mapSquare(x, y).mapEdge()) {
          this.colorFogGrid(Constants.color_transparent, x, y);
        }
        else {
          this.colorFogGrid(this.mapSquare(x, y).getColor(Constants.color_transparent), x, y);
        }
      }
    }
    catch(NullPointerException e) {}
  }
  void setTerrainVisible(boolean visible, int x, int y) {
    this.setTerrainVisible(visible, x, y, true);
  }
  void setTerrainVisible(boolean visible, int x, int y, boolean refreshFogImage) {
    try {
      if (this.mapSquare(x, y).visible == visible) {
        return;
      }
      this.mapSquare(x, y).visible = visible;
      if (refreshFogImage) {
        if (!this.mapSquare(x, y).explored) {
        }
        else if (this.mapSquare(x, y).mapEdge()) {
          this.colorFogGrid(Constants.color_transparent, x, y);
        }
        else if (this.mapSquare(x, y).visible) {
          this.colorFogGrid(this.mapSquare(x, y).getColor(Constants.color_transparent), x, y);
        }
        else {
          this.colorFogGrid(this.mapSquare(x, y).getColor(this.fogColor), x, y);
        }
      }
    }
    catch(NullPointerException e) {}
  }


  // add feature
  void addFeature(int id, int x, int y) {
    this.addFeature(new Feature(id, x, y), true);
  }
  void addFeature(Feature f) {
    this.addFeature(f, true);
  }
  void addFeature(Feature f, boolean refreshImage) {
    this.addFeature(f, refreshImage, this.nextFeatureKey);
    this.nextFeatureKey++;
  }
  void addFeature(Feature f, boolean refreshImage, int code) {
    if (!f.inMap(this.mapXI(), this.mapYI(), this.mapXF(), this.mapYF())) {
      return;
    }
    for (int i = round(f.x); i < round(f.x + f.sizeX); i++) {
      for (int j = round(f.y); j < round(f.y + f.sizeY); j++) {
        if (f.ignoreSquare(i - round(f.x), j - round(f.y))) {
          continue;
        }
        this.mapSquare(i, j).addedFeature(f);
      }
    }
    if (f.displaysImage()) {
      this.terrainImageGrid(f.getImage(), round(floor(f.x)), round(floor(f.y)), f.sizeX, f.sizeY);
    }
    if (refreshImage) {
      this.refreshTerrainImage();
    }
    f.map_key = code;
    switch(f.ID) {
      case 195: // light switches
      case 196:
      case 197:
      case 198:
        if (f.number <= 0) {
          f.number = f.map_key - 1;
        }
        break;
      default:
        break;
    }
    this.actuallyAddFeature(code, f);
  }
  abstract void actuallyAddFeature(int code, Feature f);

  // remove feature
  void removeFeature(int code) {
    Feature f = this.getFeature(code);
    if (f == null) {
      return;
    }
    f.remove = true;
    if (!f.inMap(this.mapXI(), this.mapYI(), this.mapXF(), this.mapYF())) {
      return;
    }
    for (int i = round(f.x); i < round(f.x + f.sizeX); i++) {
      for (int j = round(f.y); j < round(f.y + f.sizeY); j++) {
        if (f.ignoreSquare(i - round(f.x), j - round(f.y))) {
          continue;
        }
        this.mapSquare(i, j).removedFeature(f);
      }
    }
    if (!f.displaysImage()) {
      return;
    }
    this.removeFeatureImage(f);
    this.refreshTerrainImage();
  }
  abstract Feature getFeature(int code);
  abstract Collection<Feature> features();

  // refresh feature image (remove then add)
  void refreshFeature(int code) {
    Feature f = this.getFeature(code);
    if (f == null) {
      return;
    }
    f.refresh_map_image = false;
    if (!f.inMap(this.mapXI(), this.mapYI(), this.mapXF(), this.mapYF())) {
      return;
    }
    if (!f.displaysImage()) {
      return;
    }
    this.removeFeatureImage(f);
    this.terrainImageGrid(f.getImage(), round(floor(f.x)), round(floor(f.y)), f.sizeX, f.sizeY);
    this.refreshTerrainImage();
  }

  void removeFeatureImage(Feature f) {
    this.colorTerrainGrid(Constants.color_transparent, round(f.x), round(f.y), f.sizeX, f.sizeY);
    for (int i = round(f.xi()); i < round(f.xf()); i++) {
      for (int j = round(f.yi()); j < round(f.yf()); j++) {
        this.terrainImageGrid(this.mapSquare(i, j).terrainImage(), i, j);
      }
    }
    for (Feature f2 : this.features()) {
      if (f2.map_key == f.map_key) {
        continue;
      }
      if (f2.x < f.x + f.sizeX && f2.y < f.y + f.sizeY && f2.x + f2.sizeX > f.x && f2.y + f2.sizeY > f.y) {
        DImg dimg = new DImg(f2.getImage());
        dimg.setGrid(f2.sizeX, f2.sizeY);
        int xi_overlap = round(max(f.x, f2.x));
        int yi_overlap = round(max(f.y, f2.y));
        int w_overlap = round(min(f.xf() - xi_overlap, f2.xf() - xi_overlap));
        int h_overlap = round(min(f.yf() - yi_overlap, f2.yf() - yi_overlap));
        PImage imagePiece = dimg.getImageGridPiece(xi_overlap - round(f2.x),
          yi_overlap - round(f2.y), w_overlap, h_overlap);
        this.terrainImageGrid(imagePiece, xi_overlap, yi_overlap, w_overlap, h_overlap);
      }
    }
  }

  // add unit
  void addUnit(Unit u, float x, float y) {
    u.setLocation(x, y);
    this.addUnit(u);
  }
  void addUnit(Unit u) {
    this.addUnit(u, this.nextUnitKey);
    this.nextUnitKey++;
  }
  void addUnit(Unit u, int code) {
    this.units.put(code, u);
    u.map_key = code;
    if (u.x - u.size - Constants.small_number < this.mapXI()) {
      u.x = this.mapXI() + u.size + Constants.small_number;
    }
    else if (u.x + u.size + Constants.small_number > this.mapXF()) {
      u.x = this.mapXF() - u.size - Constants.small_number;
    }
    if (u.y - u.size - Constants.small_number < this.mapYI()) {
      u.y = this.mapYI() + u.size + Constants.small_number;
    }
    else if (u.y + u.size + Constants.small_number > this.mapYF()) {
      u.y = this.mapYF() - u.size - Constants.small_number;
    }
    u.curr_squares_on = u.getSquaresOn();
    u.resolveFloorHeight(this);
    if (u.type.equals("Zombie")) {
      this.zombie_counter++;
    }
  }
  // remove unit
  void removeUnit(int code) {
    if (this.units.containsKey(code)) {
      this.units.get(code).remove = true;
    }
  }
  // add player unit
  void addPlayer(Hero player) {
    player.ai_controlled = false;
    this.addUnit(player, 0);
    this.setViewLocation(player.x, player.y);
  }

  // add item
  void addItem(Item i) {
    this.addItem(i, true);
  }
  void addItemAsIs(Item i) {
    int disappear_timer = i.disappear_timer;
    this.addItem(i, i.disappearing);
    i.disappear_timer = disappear_timer;
  }
  void addItemAsIs(Item i, int code) {
    int disappear_timer = i.disappear_timer;
    this.addItem(i, code, i.disappearing);
    i.disappear_timer = disappear_timer;
  }
  void addItem(Item i, boolean auto_disappear) {
    this.addItem(i, this.nextItemKey, auto_disappear);
    this.nextItemKey++;
  }
  void addItem(Item i, float x, float y) {
    this.addItem(i, x, y, true);
  }
  void addItem(Item i, float x, float y, boolean auto_disappear) {
    i.setLocation(x, y);
    this.addItem(i, this.nextItemKey, auto_disappear);
    this.nextItemKey++;
  }
  void addItem(Item i, int code) {
    this.addItem(i, code, true);
  }
  void addItem(Item i, int code, boolean auto_disappear) {
    if (auto_disappear) {
      i.disappearing = true;
      i.disappear_timer = Constants.item_disappearTimer;
    }
    else {
      i.disappearing = false;
    }
    this.items.put(code, i);
    if (i.x - i.size - Constants.small_number < this.mapXI()) {
      i.x = this.mapXI() + i.size + Constants.small_number;
    }
    else if (i.x + i.size + Constants.small_number > this.mapXF()) {
      i.x = this.mapXF() - i.size - Constants.small_number;
    }
    if (i.y - i.size - Constants.small_number < this.mapYI()) {
      i.y = this.mapYI() + i.size + Constants.small_number;
    }
    else if (i.y + i.size + Constants.small_number > this.mapYF()) {
      i.y = this.mapYF() - i.size - Constants.small_number;
    }
    i.map_key = code;
  }
  // remove item
  void removeItem(int code) {
    if (this.items.containsKey(code)) {
      this.items.get(code).remove = true;
    }
  }

  // add projectile
  void addProjectile(Projectile p) {
    this.projectiles.add(p);
  }
  // remove projectile
  void removeProjectile(int index) {
    if (index < 0 || index >= this.projectiles.size()) {
      return;
    }
    this.projectiles.remove(index);
  }

  // add visual effect
  void addVisualEffect(int id, float v_x, float v_y) {
    VisualEffect v = new VisualEffect(id);
    v.setLocation(v_x, v_y);
    this.addVisualEffect(v);
  }
  void addVisualEffect(VisualEffect v) {
    switch(v.ID) {
      case 4001:
        for (VisualEffect ve : this.visualEffects) {
          if (ve.ID == 4001) {
            ve.remove = true;
          }
        }
        break;
    }
    this.visualEffects.add(v);
  }
  // remove visual effect
  void removeVisualEffect(int index) {
    if (index < 0 || index >= this.visualEffects.size()) {
      return;
    }
    this.visualEffects.remove(index);
  }

  void addHeaderMessage(String message) {
    this.headerMessages.add(new HeaderMessage(message));
    if (this.headerMessages.size() > Constants.map_maxHeaderMessages) {
      this.headerMessages.remove(0);
    }
  }
  void addHeaderMessage(String message, int message_id) {
    HeaderMessage header_message = new HeaderMessage(message);
    switch(message_id) {
      case 1: // center of screen
        header_message.placeCenter();
        header_message.clickable = false;
        break;
      case 2: // center of screen and longer
        header_message.placeCenter();
        header_message.show_time = 6000;
        header_message.clickable = false;
        break;
      case 3: // longer
        header_message.show_time = 5000;
        header_message.clickable = false;
        break;
      case 4: // center of screen and bigger
        header_message.placeCenter(40);
        header_message.clickable = false;
        break;
      case 5: // center of screen and bigger and longer
        header_message.placeCenter(40);
        header_message.show_time = 6000;
        header_message.clickable = false;
        break;
      default:
        break;
    }
    this.headerMessages.add(header_message);
    if (this.headerMessages.size() > Constants.map_maxHeaderMessages) {
      this.headerMessages.remove(0);
    }
  }


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
    Map<Thread, StackTraceElement[]> all_threads = Thread.getAllStackTraces();
    text("Active Threads: " + all_threads.size(), this.xi + 1, y_stats);
    y_stats += line_height;
    int gamemap_threads = 0;
    int unit_threads = 0;
    for (Thread thread : all_threads.keySet()) {
      String thread_name = thread.getName();
      if (thread_name.equals("TerrainDimgThread") || thread_name.equals("MouseMoveThread")) {
        gamemap_threads++;
      }
      else if (thread_name.equals("PathFindingThread")) {
        unit_threads++;
      }
    }
    text("GameMap Threads: " + gamemap_threads, this.xi + 1, y_stats);
    y_stats += line_height;
    text("Unit Threads: " + unit_threads, this.xi + 1, y_stats);
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


  void drawMap() {
    if (this.update_terrain_display) {
      this.update_terrain_display = false;
      this.refreshTerrainImage();
    }
    rectMode(CORNERS);
    noStroke();
    fill(this.color_border);
    rect(this.xi, this.yi, this.xf, this.yf);
    fill(this.color_background);
    rect(this.xi + Constants.map_borderSize, this.yi + Constants.map_borderSize,
      this.xf - Constants.map_borderSize, this.yf - Constants.map_borderSize);
    // hovered info
    if (this.hovered_object != null && this.hovered_object.remove) {
      this.hovered_object = null;
    }
    String nameDisplayed = null;
    color ellipseColor = color(255);
    float ellipseWeight = 0.8;
    // display terrain
    imageMode(CORNERS);
    image(this.terrain_display, this.xi_map_old + this.xi_map_dif, this.yi_map_old +
      this.yi_map_dif, this.xf_map_old + this.xf_map_dif, this.yf_map_old + this.yf_map_dif);
    if (this.hovered && this.hovered_explored) {
      try {
        nameDisplayed = this.mapSquare(int(this.mX), int(this.mY)).terrainName();
      } catch(NullPointerException e) {}
    }
    imageMode(CORNER);
    for (int i = round(ceil(this.startSquareX_old)); i < round(floor(this.startSquareX_old + this.visSquareX_old)); i++) {
      for (int j = round(ceil(this.startSquareY_old)); j < round(floor(this.startSquareY_old + this.visSquareY_old)); j++) {
        if (this.mapSquare(i, j).terrain_id == 191) {
          image(this.mapSquare(i, j).terrainImage(), this.xi_map_old + (i - this.startSquareX_old) *
            this.zoom_old, this.yi_map_old + (j - this.startSquareY_old) * this.zoom_old, this.zoom_old, this.zoom_old);
        }
      }
    }
    // display units
    boolean display_player = false;
    imageMode(CENTER);
    Iterator unit_iterator = this.units.entrySet().iterator();
    while(unit_iterator.hasNext()) {
      Map.Entry<Integer, Unit> entry = (Map.Entry<Integer, Unit>)unit_iterator.next();
      Unit u = entry.getValue();
      if (!u.inView(this.startSquareX_old, this.startSquareY_old, this.startSquareX_old +
        this.visSquareX_old, this.startSquareY_old + this.visSquareY_old)) {
        continue;
      }
      if (u.map_key == 0) {
        display_player = true;
        continue;
      }
      if (this.draw_fog && !this.mapSquare(int(u.x), int(u.y)).visible) {
        if (!this.units.containsKey(0) || u.alliance != this.units.get(0).alliance) {
          continue;
        }
      }
      this.displayUnit(u);
    }
    if (display_player) {
      this.displayUnit(this.units.get(0), true);
    }
    // display items
    imageMode(CENTER);
    Iterator item_iterator = this.items.entrySet().iterator();
    while(item_iterator.hasNext()) {
      Map.Entry<Integer, Item> entry = (Map.Entry<Integer, Item>)item_iterator.next();
      Item i = entry.getValue();
      if (!i.inView(this.startSquareX_old, this.startSquareY_old, this.startSquareX_old +
        this.visSquareX_old, this.startSquareY_old + this.visSquareY_old)) {
        continue;
      }
      if (this.draw_fog && !this.mapSquare(int(i.x), int(i.y)).visible) {
        continue;
      }
      float translateX = this.xi_map_old + (i.x - this.startSquareX_old) * this.zoom_old;
      float translateY = this.yi_map_old + (i.y - this.startSquareY_old - Constants.item_bounceOffset *
        i.bounce.value / float(Constants.item_bounceConstant)) * this.zoom_old;
      translate(translateX, translateY);
      image(i.getImage(), 0, 0, i.width() * this.zoom_old, i.height() * this.zoom_old);
      if (i.stack > 1) {
        fill(255);
        textSize(14);
        textAlign(RIGHT, BOTTOM);
        text(i.stack, i.size * this.zoom_old - 2, i.size * this.zoom_old - 2);
      }
      translate(-translateX, -translateY);
    }
    // display projectiles
    imageMode(CENTER);
    for (Projectile p : this.projectiles) {
      if (!p.inView(this.startSquareX_old, this.startSquareY_old, this.startSquareX_old +
        this.visSquareX_old, this.startSquareY_old + this.visSquareY_old)) {
        continue;
      }
      if (this.draw_fog && !this.mapSquare(int(p.x), int(p.y)).visible) {
        continue;
      }
      float translateX = this.xi_map_old + (p.x - this.startSquareX_old) * this.zoom_old;
      float translateY = this.yi_map_old + (p.y - this.startSquareY_old) * this.zoom_old;
      translate(translateX, translateY);
      rotate(p.facingA);
      image(p.getImage(), 0, 0, p.width() * this.zoom_old, p.height() * this.zoom_old);
      rotate(-p.facingA);
      translate(-translateX, -translateY);
    }
    // display visual effects
    imageMode(CENTER);
    for (VisualEffect v : this.visualEffects) {
      float translateX = this.xi_map_old + (v.x - this.startSquareX_old) * this.zoom_old;
      float translateY = this.yi_map_old + (v.y - this.startSquareY_old) * this.zoom_old;
      translate(translateX, translateY);
      v.display(this.zoom_old);
      translate(-translateX, -translateY);
    }
    // name displayed
    MapObject this_hovered_object = this.hovered_object;
    if (this_hovered_object != null) {
      nameDisplayed = this_hovered_object.display_name();
      float ellipseX = this.xi_map_old + this.zoom_old * (this_hovered_object.xCenter() - this.startSquareX_old);
      float ellipseY = this.yi_map_old + this.zoom_old * (this_hovered_object.yCenter() - this.startSquareY_old);
      float ellipseDiameterX = this.zoom_old * this_hovered_object.width();
      float ellipseDiameterY = this.zoom_old * this_hovered_object.height();
      ellipseMode(CENTER);
      noFill();
      stroke(ellipseColor);
      strokeWeight(ellipseWeight);
      ellipse(ellipseX, ellipseY, ellipseDiameterX, ellipseDiameterY);
    }
    if (nameDisplayed != null) {
      textSize(18);
      float name_width = textWidth(nameDisplayed) + 2;
      float name_height = textAscent() + textDescent() + 2;
      float name_xi = mouseX + 2;
      float name_yi = mouseY - name_height - global.configuration.cursor_size * 0.3;
      if (mouseX > 0.5 * width) {
        name_xi -= name_width + 4;
      }
      fill(global.color_nameDisplayed_background);
      rectMode(CORNER);
      noStroke();
      rect(name_xi, name_yi, name_width, name_height);
      fill(global.color_nameDisplayed_text);
      textAlign(LEFT, TOP);
      text(nameDisplayed, name_xi + 1, name_yi + 1);
    }
    // display fog
    if (this.draw_fog) {
      imageMode(CORNERS);
      image(this.fog_display, this.xi_fog, this.yi_fog, this.xf_fog, this.yf_fog);
    }
    // map tint
    if (this.show_tint) {
      rectMode(CORNERS);
      fill(this.color_tint);
      noStroke();
      rect(this.xi, this.yi, this.xf, this.yf);
    }
    // header messages
    for (HeaderMessage message : this.headerMessages) {
      message.drawMessage();
    }
  }


  void displayUnit(Unit u) {
    this.displayUnit(u, false);
  }
  void displayUnit(Unit u, boolean player_unit) {
    if (u.invisible()) {
      return;
    }
    float translateX = this.xi_map_old + (u.x - this.startSquareX_old) * this.zoom_old;
    float translateY = this.yi_map_old + (u.y - this.startSquareY_old) * this.zoom_old;
    boolean removeCache = false;
    translate(translateX, translateY);
    float net_rotation = 0;
    boolean flip = false;
    if (abs(u.facingA) > HALF_PI) {
      flip = true;
      net_rotation = (PI - abs(u.facingA)) * u.facingA / abs(u.facingA) + u.facingAngleModifier();
    }
    else {
      net_rotation = u.facingA + u.facingAngleModifier();
    }
    if (flip) {
      scale(-1, 1);
    }
    rotate(net_rotation);
    float extra_translate_x = 0;
    float extra_translate_y = 0;
    if (u.diseased()) {
      tint(90, 250, 90);
      removeCache = true;
    }
    else if (u.sick()) {
      tint(150, 255, 150);
      removeCache = true;
    }
    if (u.frozen()) {
      tint(50, 180, 250);
      removeCache = true;
    }
    else if (u.chilled()) {
      tint(120, 220, 255);
      removeCache = true;
    }
    if (u.rageOfTheBenII()) {
      tint(255, 160, 160);
      removeCache = true;
      extra_translate_x = Constants.ability_110_shakeConstant - random(2 * Constants.ability_110_shakeConstant);
      extra_translate_y = Constants.ability_110_shakeConstant - random(2 * Constants.ability_110_shakeConstant);
    }
    else if (u.rageOfTheBen()) {
      tint(255, 80, 80);
      removeCache = true;
      extra_translate_x = Constants.ability_105_shakeConstant - random(2 * Constants.ability_105_shakeConstant);
      extra_translate_y = Constants.ability_105_shakeConstant - random(2 * Constants.ability_105_shakeConstant);
    }
    if (u.aposematicCamouflage() || u.aposematicCamouflageII()) {
      tint(255, 150);
      removeCache = true;
    }
    if (u.alkaloidSecretion()) {
      ellipseMode(CENTER);
      fill(128, 82, 48, 100);
      noStroke();
      ellipse(0, 0, 2 * Constants.ability_114_range * this.zoom_old, 2 * Constants.ability_114_range * this.zoom_old);
    }
    if (u.alkaloidSecretionII()) {
      ellipseMode(CENTER);
      fill(128, 82, 48, 100);
      noStroke();
      ellipse(0, 0, 2 * Constants.ability_119_range * this.zoom_old, 2 * Constants.ability_119_range * this.zoom_old);
    }
    translate(extra_translate_x, extra_translate_y);
    if (removeCache) {
      g.removeCache(u.getImage());
    }
    imageMode(CENTER);
    image(u.getImage(), 0, 0, u.width() * this.zoom_old, u.height() * this.zoom_old);
    if (player_unit && global.player_blinking) {
      ellipseMode(CENTER);
      noFill();
      stroke(255);
      strokeWeight(0.5);
      ellipse(0, 0, u.width() * this.zoom_old, u.height() * this.zoom_old);
    }
    if (u.weapon() != null) {
      float translateItemX = 0.9 * (u.xRadius() + Constants.unit_weaponDisplayScaleFactor * Constants.item_defaultSize) * this.zoom_old;
      float translateItemY = 0.4 * (u.yRadius() + Constants.unit_weaponDisplayScaleFactor * Constants.item_defaultSize) * this.zoom_old;
      translate(translateItemX, translateItemY);
      float weapon_adjust_x = Constants.unit_weaponDisplayScaleFactor * u.weapon().width() * this.zoom_old;
      float weapon_adjust_y = Constants.unit_weaponDisplayScaleFactor * u.weapon().height() * this.zoom_old;
      image(u.weapon().getImage(), 0, 0, weapon_adjust_x, weapon_adjust_y);
      if (u.weapon().stack > 1) {
        fill(255);
        textSize(12);
        textAlign(RIGHT, BOTTOM);
        text(u.weapon().stack, 0.5 * weapon_adjust_x - 1, 0.5 * weapon_adjust_y - 1);
      }
      translate(-translateItemX, -translateItemY);
    }
    else if (player_unit) {
      float translateItemX = 0.9 * (u.xRadius() + Constants.unit_weaponDisplayScaleFactor * Constants.item_defaultSize) * this.zoom_old;
      float translateItemY = 0.4 * (u.yRadius() + Constants.unit_weaponDisplayScaleFactor * Constants.item_defaultSize) * this.zoom_old;
      translate(translateItemX, translateItemY);
      image(global.images.getImage("icons/hand.png"), 0, 0, Constants.unit_weaponDisplayScaleFactor *
        2 * Constants.item_defaultSize * this.zoom_old, Constants.unit_weaponDisplayScaleFactor *
        2 * Constants.item_defaultSize * this.zoom_old);
      translate(-translateItemX, -translateItemY);
    }
    if (u.charred()) {
      int flame_frame = int(floor(Constants.gif_fire_frames * ((u.random_number +
        millis()) % Constants.gif_fire_time) / Constants.gif_fire_time));
      PImage fire_img = global.images.getImage("gifs/fire/" + flame_frame + ".png");
      tint(255, 220);
      image(fire_img, 0, 0, u.width() * this.zoom_old, u.height() * this.zoom_old);
      g.removeCache(fire_img);
      noTint();
      g.removeCache(fire_img);
    }
    else if (u.burnt()) {
      int flame_frame = int(floor(Constants.gif_fire_frames * ((u.random_number +
        millis()) % Constants.gif_fire_time) / Constants.gif_fire_time));
      PImage fire_img = global.images.getImage("gifs/fire/" + flame_frame + ".png");
      tint(255, 160);
      image(fire_img, 0, 0, u.width() * this.zoom_old, u.height() * this.zoom_old);
      g.removeCache(fire_img);
      noTint();
      g.removeCache(fire_img);
    }
    if (u.drenched()) {
      int drenched_frame = int(floor(Constants.gif_drenched_frames * ((u.random_number +
        millis()) % Constants.gif_drenched_time) / Constants.gif_drenched_time));
      image(global.images.getImage("gifs/drenched/" + drenched_frame + ".png"), 0, 0, u.width() * this.zoom_old, u.height() * this.zoom_old);
    }
    if (u.curr_action == UnitAction.CASTING) {
      try {
        Ability a = u.abilities.get(u.curr_action_id);
        float img_width = 0;
        float img_height = 0;
        switch(a.ID) {
          case 103: // Nelson Glare
            ellipseMode(RADIUS);
            fill(170, 200);
            noStroke();
            img_width = Constants.ability_103_range * (1 - a.timer_other / Constants.ability_103_castTime);
            arc(0, 0, img_width * this.zoom_old, img_width * this.zoom_old, -Constants.
              ability_103_coneAngle, Constants.ability_103_coneAngle, PIE);
            fill(100, 200);
            arc(0, 0, img_width * this.zoom_old, img_width * this.zoom_old, -0.3 *
              Constants.ability_103_coneAngle, 0.3 * Constants.ability_103_coneAngle, PIE);
            break;
          case 108: // Nelson Glare II
            ellipseMode(RADIUS);
            fill(170, 200);
            noStroke();
            img_width = Constants.ability_108_range * (1 - a.timer_other / Constants.ability_108_castTime);
            arc(0, 0, img_width * this.zoom_old, img_width * this.zoom_old, -Constants.
              ability_108_coneAngle, Constants.ability_108_coneAngle, PIE);
            fill(100, 200);
            arc(0, 0, img_width * this.zoom_old, img_width * this.zoom_old, -0.3 *
              Constants.ability_108_coneAngle, 0.3 * Constants.ability_108_coneAngle, PIE);
            break;
          case 112: // Tongue Lash
            img_width = Constants.ability_112_distance * (1 - a.timer_other / Constants.ability_112_castTime);
            img_height = u.size;
            image(global.images.getImage("abilities/tongue.png"), 0.5 * img_width * this.zoom_old,
              0, img_width * this.zoom_old, img_height * this.zoom_old);
            break;
          case 117: // Tongue Lash II
            img_width = Constants.ability_117_distance * (1 - a.timer_other / Constants.ability_112_castTime);
            img_height = u.size;
            image(global.images.getImage("abilities/tongue.png"), 0.5 * img_width * this.zoom_old,
              0, img_width * this.zoom_old, img_height * this.zoom_old);
            break;
          case 1001: // Blow Smoke
            img_width = Constants.ability_1001_range * (1 - a.timer_other / Constants.ability_1001_castTime);
            img_height = img_width * Constants.ability_1001_tanConeAngle;
            image(global.images.getImage("abilities/smoke.png"), 0.5 * img_width * this.zoom_old,
              0, img_width * this.zoom_old, img_height * this.zoom_old);
            break;
          default:
            break;
        }
      } catch(Exception e) {}
    }
    if (removeCache) {
      g.removeCache(u.getImage());
      noTint();
      g.removeCache(u.getImage());
    }
    translate(-extra_translate_x, -extra_translate_y);
    rotate(-net_rotation);
    if (flip) {
      scale(-1, 1);
    }
    // healthbar
    float healthbarWidth = Constants.unit_healthbarWidth * this.zoom_old;
    float healthbarHeight = Constants.unit_healthbarHeight * this.zoom_old;
    float manaBarHeight = 0;
    if (Hero.class.isInstance(u)) {
      manaBarHeight += Constants.hero_manabarHeight * this.zoom;
    }
    float totalHeight = healthbarHeight + manaBarHeight;
    float translateHealthBarX = -0.5 * healthbarWidth;
    float translateHealthBarY = -1.2 * u.size * this.zoom_old - totalHeight;
    textSize(totalHeight - 0.5);
    translate(translateHealthBarX, translateHealthBarY);
    stroke(200);
    strokeWeight(0.8);
    fill(0);
    rectMode(CORNER);
    rect(0, 0, healthbarWidth, totalHeight);
    rect(0, 0, totalHeight, totalHeight);
    fill(255);
    textSize(healthbarHeight - 1);
    textAlign(CENTER, TOP);
    text(u.level, 0.5 * totalHeight, 1 - textDescent());
    if (player_unit) {
      fill(50, 255, 50);
    }
    else if (u.alliance == Alliance.BEN) {
      fill(50, 50, 255);
    }
    else {
      fill(255, 50, 50);
    }
    noStroke();
    float health_ratio = u.curr_health / u.health();
    if (health_ratio >= 1) {
      rect(totalHeight, 0, healthbarWidth - totalHeight, healthbarHeight);
      fill(255);
      health_ratio = min(1, health_ratio - 1);
      rectMode(CORNERS);
      rect(healthbarWidth - health_ratio * (healthbarWidth - totalHeight), 0, healthbarWidth, healthbarHeight);
    }
    else {
      rect(totalHeight, 0, health_ratio * (healthbarWidth - totalHeight), healthbarHeight);
      if (u.timer_last_damage > 0) {
        fill(255, 220, 50, int(255 * u.timer_last_damage / Constants.unit_healthbarDamageAnimationTime));
        float damage_ratio = u.last_damage_amount / u.health();
        rect(totalHeight + health_ratio * (healthbarWidth - totalHeight),
          0, damage_ratio * (healthbarWidth - totalHeight), healthbarHeight);
      }
    }
    if (Hero.class.isInstance(u)) {
      rectMode(CORNER);
      fill(255, 255, 0);
      float mana_ratio = u.currMana() / u.mana();
      if (mana_ratio >= 1) {
        rect(totalHeight, healthbarHeight, healthbarWidth - totalHeight, manaBarHeight);
        fill(255);
        mana_ratio = min(1, mana_ratio - 1);
        rectMode(CORNERS);
        rect(healthbarWidth - mana_ratio * (healthbarWidth - totalHeight),
          healthbarHeight, healthbarWidth, totalHeight);
      }
      else {
        rect(totalHeight, healthbarHeight, mana_ratio * (healthbarWidth - totalHeight), manaBarHeight);
      }
    }
    textSize(healthbarHeight + 1);
    fill(255);
    textAlign(CENTER, BOTTOM);
    text(u.display_name(), 0.5 * healthbarWidth, - 1 - textDescent());
    translate(-translateHealthBarX, -translateHealthBarY);
    translate(-translateX, -translateY);
  }


  void drawLeftPanel(int millis) {
    float currY = Constants.map_selectedObjectPanelGap;
    if (this.selected_object != null) {
      if (this.selected_object_textbox == null) {
        this.selected_object_textbox = new SelectedObjectTextbox();
        this.selected_object_textbox.setXLocation(Constants.map_selectedObjectPanelGap,
            xi - Constants.map_selectedObjectPanelGap);
      }
      fill(255);
      textSize(Constants.map_selectedObjectTitleTextSize);
      textAlign(CENTER, TOP);
      text(this.selected_object.display_name(), 0.5 * this.xi, currY);
      currY += textAscent() + textDescent() + Constants.map_selectedObjectPanelGap;
      float image_height = min(this.selected_object_textbox.yi - 2 * Constants.
        map_selectedObjectImageGap - currY, this.xi - 2 * Constants.map_selectedObjectPanelGap);
      float image_width = min(this.xi - 2 * Constants.map_selectedObjectPanelGap,
        image_height * this.selected_object.width() / this.selected_object.height());
      imageMode(CENTER);
      currY += 0.5 * image_height + Constants.map_selectedObjectImageGap;
      image(this.selected_object.getImage(), 0.5 * this.xi, currY, image_width, image_height);
      if (Item.class.isInstance(this.selected_object)) {
        Item i = (Item)this.selected_object;
        if (i.stack > 1) {
          fill(255);
          textAlign(RIGHT, BOTTOM);
          textSize(24);
          text(i.stack, 0.5 * (this.xi + image_width) - 2, currY + 0.5 * image_height - 2);
        }
        this.selected_object_textbox.setText(this.selected_object.selectedObjectTextboxText());
        this.selected_object_textbox.update(millis);
        // item tier image
        PImage tier_image = global.images.getImage("icons/tier_" + i.tier + ".png");
        float tier_image_width = (Constants.map_tierImageHeight * tier_image.width) / tier_image.height;
        imageMode(CORNER);
        image(tier_image, this.selected_object_textbox.xf - tier_image_width - 4,
          this.selected_object_textbox.yi + 4, tier_image_width, Constants.map_tierImageHeight);
      }
      else if (Unit.class.isInstance(this.selected_object) || Hero.class.isInstance(this.selected_object)) {
        Unit u = (Unit)this.selected_object;
        // weapon
        if (u.weapon() != null) {
          float weapon_image_width = image_width * Constants.unit_weaponDisplayScaleFactor * u.weapon().width() / u.width();
          float weapon_image_height = image_height * Constants.unit_weaponDisplayScaleFactor * u.weapon().height() / u.height();
          float weapon_image_x = 0.5 * this.xi + 0.45 * (image_width + weapon_image_width);
          float weapon_image_y = currY + 0.2 * (image_height + weapon_image_height);
          image(u.weapon().getImage(), weapon_image_x, weapon_image_y, weapon_image_width, weapon_image_height);
        }
        boolean lower_textbox = (u.statuses.size() > 0);
        if (lower_textbox) {
          this.selected_object_textbox.setYLocation(this.selected_object_textbox.yi +
            Constants.map_statusImageHeight + 4, this.selected_object_textbox.yf);
        }
        this.selected_object_textbox.setText(this.selected_object.selectedObjectTextboxText());
        this.selected_object_textbox.update(millis);
        // status effects
        float x_status = 3;
        float y_status = this.selected_object_textbox.yi - Constants.map_statusImageHeight - 2;
        StatusEffectCode status_effect_hovered = null;
        for (Map.Entry<StatusEffectCode, StatusEffect> entry : u.statuses.entrySet()) {
          imageMode(CORNER);
          rectMode(CORNER);
          ellipseMode(CENTER);
          fill(255, 150);
          stroke(0);
          strokeWeight(1);
          rect(x_status, y_status, Constants.map_statusImageHeight, Constants.map_statusImageHeight);
          image(global.images.getImage(entry.getKey().getImageString()), x_status,
            y_status, Constants.map_statusImageHeight, Constants.map_statusImageHeight);
          if (!entry.getValue().permanent) {
            fill(100, 100, 255, 140);
            noStroke();
            try {
              float angle = -HALF_PI + 2 * PI * entry.getValue().timer_gone / entry.getValue().timer_gone_start;
              arc(x_status + 0.5 * Constants.map_statusImageHeight, y_status +
                0.5 * Constants.map_statusImageHeight, Constants.map_statusImageHeight,
                Constants.map_statusImageHeight, -HALF_PI, angle, PIE);
            } catch(Exception e) {}
          }
          if (mouseX > x_status && mouseX < x_status + Constants.map_statusImageHeight &&
            mouseY > y_status && mouseY < y_status + Constants.map_statusImageHeight) {
            status_effect_hovered = entry.getKey();
          }
          x_status += Constants.map_statusImageHeight + 2;
        }
        if (status_effect_hovered != null) {
          noStroke();
          fill(global.color_nameDisplayed_background);
          textSize(14);
          float rect_height = textAscent() + textDescent() + 2;
          float rect_width = textWidth(status_effect_hovered.code_name()) + 2;
          rect(mouseX + 1, mouseY - rect_height - 1, rect_width, rect_height);
          fill(255);
          textAlign(LEFT, TOP);
          text(status_effect_hovered.code_name(), mouseX + 2, mouseY - rect_height - 1);
        }
        // unit tier image
        PImage tier_image = global.images.getImage("icons/tier_" + u.tier() + ".png");
        float tier_image_width = (Constants.map_tierImageHeight * tier_image.width) / tier_image.height;
        imageMode(CORNER);
        image(tier_image, this.selected_object_textbox.xf - tier_image_width - 4,
          this.selected_object_textbox.yi + 4, tier_image_width, Constants.map_tierImageHeight);
        // raise textbox
        if (lower_textbox) {
          this.selected_object_textbox.setYLocation(this.selected_object_textbox.yi -
            Constants.map_statusImageHeight - 4, this.selected_object_textbox.yf);
        }
      }
      else {
        this.selected_object_textbox.setText(this.selected_object.selectedObjectTextboxText());
        this.selected_object_textbox.update(millis);
      }
    }
    stroke(0);
    strokeWeight(1.5);
    line(0, 0.5 * height, this.xi, 0.5 * height);
  }

  boolean leftPanelElementsHovered() {
    if (this.selected_object != null && this.selected_object_textbox != null) {
      if (this.selected_object_textbox.hovered) {
        return true;
      }
    }
    return false;
  }


  void updateView(int timeElapsed) {
    boolean refreshView = false;
    // lockscreen
    if ((global.profile.options.lock_screen || global.holding_space) && this.in_control && this.units.containsKey(0)) {
      this.setViewLocation(this.units.get(0).x, this.units.get(0).y);
      refreshView = true;
    }
    else {
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
    }
    this.timer_refresh_fog -= timeElapsed;
    if (this.timer_refresh_fog < 0) {
      this.timer_refresh_fog += global.profile.options.fog_update_time;
      this.refreshFog();
    }
    if (refreshView) {
      this.refreshDisplayMapParameters();
    }
    else {
      this.refreshFogImage();
    }
    // header messages
    int centered = 0;
    for (int i = 0; i < this.headerMessages.size(); i++) {
      int index = i - centered;
      if (this.headerMessages.get(i).centered) {
        index = centered;
        centered++;
      }
      this.headerMessages.get(i).updateView(timeElapsed, index);
      if (this.headerMessages.get(i).remove) {
        this.headerMessages.remove(i);
      }
    }
  }

  void refreshFog() {
    for (int k = 0; k < Constants.map_lightUpdateIterations; k++) {
      for (int i = max(round(floor(this.startSquareX)) - 8, this.mapXI());
        i <= min(round(ceil(this.startSquareX + this.visSquareX)) + 8, this.mapXF()); i++) {
        for (int j = max(round(floor(this.startSquareY)) - 8, this.mapYI());
          j <= min(round(ceil(this.startSquareY + this.visSquareY)) + 8, this.mapYF()); j++) {
          try {
            if (k == 0) {
              this.mapSquare(i, j).original_light = this.mapSquare(i, j).light_level;
            }
            this.mapSquare(i, j).updateLightLevel(this, i, j);
            if (k == Constants.map_lightUpdateIterations - 1) {
              this.mapSquare(i, j).light_source = false;
              if (abs(this.mapSquare(i, j).light_level - this.mapSquare(i, j).original_light) < Constants.small_number) {
                continue;
              }
              if (this.mapSquare(i, j).mapEdge()) {
                this.colorFogGrid(Constants.color_transparent, i, j);
              }
              else if (this.mapSquare(i, j).visible) {
                this.colorFogGrid(this.mapSquare(i, j).getColor(Constants.color_transparent), i, j);
              }
              else if (this.mapSquare(i, j).explored) {
                this.colorFogGrid(this.mapSquare(i, j).getColor(this.fogColor), i, j);
              }
              else {
                this.colorFogGrid(this.mapSquare(i, j).getColor(Constants.color_black), i, j);
              }
            }
          } catch(NullPointerException e) {}
        }
      }
    }
    if (this.units.containsKey(0)) {
      this.units.get(0).refreshPlayerSight(this);
    }
  }

  void updateMap(int time_elapsed) {
    // Update features
    this.updateFeatures(time_elapsed);
    // Update units
    Iterator unit_iterator = this.units.entrySet().iterator();
    while(unit_iterator.hasNext()) {
      Map.Entry<Integer, Unit> entry = (Map.Entry<Integer, Unit>)unit_iterator.next();
      Unit u = entry.getValue();
      if (u.remove) {
        u.destroy(this);
        unit_iterator.remove();
        if (u.type.equals("Zombie")) {
          this.zombie_counter--;
        }
        continue;
      }
      u.update(time_elapsed, this);
      if (u.remove) {
        u.destroy(this);
        unit_iterator.remove();
        if (u.type.equals("Zombie")) {
          this.zombie_counter--;
        }
      }
    }
    this.updatePlayerUnit(time_elapsed);
    // Update items
    Iterator item_iterator = this.items.entrySet().iterator();
    while(item_iterator.hasNext()) {
      Map.Entry<Integer, Item> entry = (Map.Entry<Integer, Item>)item_iterator.next();
      Item i = entry.getValue();
      if (i.remove) {
        item_iterator.remove();
        continue;
      }
      i.update(time_elapsed);
      try {
        if (this.mapSquare(int(i.x), int(i.y)).terrain_id == 191) {
          i.remove = true;
        }
      } catch(NullPointerException e) {
      }
      if (i.remove) {
        item_iterator.remove();
      }
    }
    // Update projectiles
    for (int i = 0; i < this.projectiles.size(); i++) {
      if (this.projectiles.get(i).remove) {
        this.removeProjectile(i);
        i--;
        continue;
      }
      this.projectiles.get(i).update(time_elapsed, this);
      if (this.projectiles.get(i).remove) {
        this.removeProjectile(i);
        i--;
      }
    }
    // Update visual effects
    for (int i = 0; i < this.visualEffects.size(); i++) {
      if (this.visualEffects.get(i).remove) {
        this.removeVisualEffect(i);
        i--;
        continue;
      }
      this.visualEffects.get(i).update(time_elapsed);
      if (this.visualEffects.get(i).remove) {
        this.removeVisualEffect(i);
        i--;
      }
    }
  }
  abstract void updateFeatures(int time_elapsed);
  abstract void updateFeaturesCheckRemovalOnly();

  void updatePlayerUnit(int timeElapsed) {
    if (!this.units.containsKey(0)) {
      return;
    }
    if (!Hero.class.isInstance(this.units.get(0))) {
      return;
    }
    Hero player = (Hero)this.units.get(0);
    if (global.holding_shift) {
      player.addStatusEffect(StatusEffectCode.SNEAKING);
    }
    else {
      player.removeStatusEffect(StatusEffectCode.SNEAKING);
    }
  }

  void updateMapCheckObjectRemovalOnly() {
    // Check features
    this.updateFeaturesCheckRemovalOnly();
    // Check units
    Iterator unit_iterator = this.units.entrySet().iterator();
    while(unit_iterator.hasNext()) {
      Map.Entry<Integer, Unit> entry = (Map.Entry<Integer, Unit>)unit_iterator.next();
      if (entry.getValue().remove) {
        entry.getValue().destroy(this);
        unit_iterator.remove();
        if (entry.getValue().type.equals("Zombie")) {
          this.zombie_counter--;
        }
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
    for (int i = 0; i < this.projectiles.size(); i++) {
      if (this.projectiles.get(i).remove) {
        this.removeProjectile(i);
        i--;
      }
    }
    // Check visual effects
    for (int i = 0; i < this.visualEffects.size(); i++) {
      if (this.visualEffects.get(i).remove) {
        this.removeVisualEffect(i);
        i--;
        continue;
      }
    }
  }

  void splashDamage(float explode_x, float explode_y, float explode_range,
    float explode_maxPower, float explode_minPower, int source_key,
    DamageType damageType, Element element, float piercing, float penetration,
    boolean friendly_fire) {
    if (explode_range <= 0) {
      return;
    }
    Unit source = this.units.get(source_key);
    for (Map.Entry<Integer, Unit> entry : this.units.entrySet()) {
      Unit u = entry.getValue();
      if (source != null && !friendly_fire && source.alliance == u.alliance) {
        continue;
      }
      float distance = u.distanceFromPoint(explode_x, explode_y);
      float distance_ratio = 1 - distance / explode_range;
      if (distance_ratio <= 0) {
        continue;
      }
      float net_power = explode_minPower + distance_ratio * (explode_maxPower - explode_minPower);
      u.damage(source, u.calculateDamageFrom(net_power, damageType, element, piercing, penetration));
    }
  }


  // return max height from list of map squares
  int maxHeightOfSquares(ArrayList<IntegerCoordinate> coordinates, boolean moving_onto) {
    int max_height = -100;
    for (IntegerCoordinate coordinate : coordinates) {
      try {
        int square_elevation = this.mapSquare(coordinate.x, coordinate.y).elevation(moving_onto);
        if (square_elevation > max_height) {
          max_height = square_elevation;
        }
      } catch(NullPointerException e) {}
    }
    return max_height;
  }

  int heightOfSquare(IntegerCoordinate coordinate, boolean moving_onto) {
    return this.heightOfSquare(coordinate.x, coordinate.y, moving_onto);
  }
  int heightOfSquare(int x, int y, boolean moving_onto) {
    int square_height = -100;
    try {
      square_height = this.mapSquare(x, y).elevation(moving_onto);
    } catch(NullPointerException e) {}
    return square_height;
  }

  boolean containsMapSquare(IntegerCoordinate coordinate) {
    if (coordinate.x >= this.mapXI() && coordinate.x < this.mapXF() &&
      coordinate.y >= this.mapYI() && coordinate.y < this.mapYF()) {
      return true;
    }
    return false;
  }


  void updateCursorPosition() {
    this.updateCursorPosition(this.last_x, this.last_y);
  }
  void updateCursorPosition(float mouse_x, float mouse_y) {
    this.mX = this.startSquareX + (this.last_x - this.xi_map) / this.zoom;
    this.mY = this.startSquareY + (this.last_y - this.yi_map) / this.zoom;
  }
}
