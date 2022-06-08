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
      this.min_x = GameMap.this.xi;
      this.min_y = GameMap.this.yi;
      this.max_x = GameMap.this.xf;
      this.max_y = GameMap.this.yf;
    }

    @Override
    void cancel() {
      this.canceled = true;
    }
  }


  class TerrainDimgThread extends Thread {
    TerrainDimgThread() {
      super("TerrainDimgThread");
    }

    @Override
    void run() {
      float startSquareX = GameMap.this.startSquareX;
      float startSquareY = GameMap.this.startSquareY;
      float visSquareX = GameMap.this.visSquareX;
      float visSquareY = GameMap.this.visSquareY;
      float terrain_resolution = GameMap.this.terrain_resolution;
      float xi_map = GameMap.this.xi_map;
      float xf_map = GameMap.this.xf_map;
      float yi_map = GameMap.this.yi_map;
      float yf_map = GameMap.this.yf_map;
      float zoom = GameMap.this.zoom;
      PImage new_terrain_display = GameMap.this.terrain_dimg.getImagePiece(
        round(startSquareX * terrain_resolution), round(startSquareY * terrain_resolution),
        round(visSquareX * terrain_resolution), round(visSquareY * terrain_resolution));
      new_terrain_display = resizeImage(new_terrain_display,
        round(xf_map - xi_map), round(yf_map - yi_map));
      GameMap.this.terrain_display = new_terrain_display;
      GameMap.this.startSquareX_old = startSquareX;
      GameMap.this.startSquareY_old = startSquareY;
      GameMap.this.visSquareX_old = visSquareX;
      GameMap.this.visSquareY_old = visSquareY;
      GameMap.this.xi_map_old = xi_map;
      GameMap.this.xf_map_old = xf_map;
      GameMap.this.yi_map_old = yi_map;
      GameMap.this.yf_map_old = yf_map;
      GameMap.this.xi_map_dif = 0;
      GameMap.this.xf_map_dif = 0;
      GameMap.this.yi_map_dif = 0;
      GameMap.this.yf_map_dif = 0;
      GameMap.this.zoom_old = zoom;
    }
  }


  class MouseMoveThread extends Thread {
    private float mX = 0;
    private float mY = 0;

    MouseMoveThread(float mX, float mY) {
      super("MouseMoveThread");
      this.mX = mX;
      this.mY = mY;
    }

    @Override
    void run() {
      if (this.mX < Constants.small_number) {
        GameMap.this.view_moving_left = true;
        if (!global.holding_right) {
          GameMap.this.view_moving_right = false;
        }
      }
      else if (this.mX > width - 1 - Constants.small_number) {
        GameMap.this.view_moving_right = true;
        if (!global.holding_left) {
          GameMap.this.view_moving_left = false;
        }
      }
      else {
        if (!global.holding_right) {
          GameMap.this.view_moving_right = false;
        }
        if (!global.holding_left) {
          GameMap.this.view_moving_left = false;
        }
      }
      if (this.mY < Constants.small_number) {
        GameMap.this.view_moving_up = true;
        if (!global.holding_down) {
          GameMap.this.view_moving_down = false;
        }
      }
      else if (this.mY > height - 1 - Constants.small_number) {
        GameMap.this.view_moving_down = true;
        if (!global.holding_up) {
          GameMap.this.view_moving_up = false;
        }
      }
      else {
        if (!global.holding_down) {
          GameMap.this.view_moving_down = false;
        }
        if (!global.holding_up) {
          GameMap.this.view_moving_up = false;
        }
      }
      GameMap.this.updateCursorPosition(this.mX, this.mY);
      if (GameMap.this.selected_object != null && GameMap.this.selected_object_textbox != null) {
        GameMap.this.selected_object_textbox.mouseMove(this.mX, this.mY);
      }
      if (GameMap.this.draw_fog) {
        GameMap.this.hovered_explored = false;
        GameMap.this.hovered_visible = false;
      }
      else {
        GameMap.this.hovered_explored = true;
        GameMap.this.hovered_visible = true;
      }
      boolean default_cursor = true;
      boolean viewing_inventory = false;
      if (GameMap.this.units.containsKey(0) && Hero.class.isInstance(GameMap.this.units.get(0))) {
        viewing_inventory = ((Hero)GameMap.this.units.get(0)).inventory.viewing;
      }
      if (mX > GameMap.this.xi_map && mY > GameMap.this.yi_map && mX < GameMap.
        this.xf_map && mY < GameMap.this.yf_map && !viewing_inventory) {
        GameMap.this.hovered = true;
        GameMap.this.hovered_area = true;
        GameMap.this.hovered_border = false;
        // update hovered for map objects
        GameMap.this.hovered_object = null;
        try {
          if (!GameMap.this.draw_fog || GameMap.this.squares[int(floor(
            GameMap.this.mX))][int(floor(GameMap.this.mY))].visible) {
            GameMap.this.hovered_explored = true;
            GameMap.this.hovered_visible = true;
          }
          else if (!GameMap.this.draw_fog || GameMap.this.squares[int(floor(
            GameMap.this.mX))][int(floor(GameMap.this.mY))].explored) {
            GameMap.this.hovered_explored = true;
          }
        } catch(ArrayIndexOutOfBoundsException e) {}
        for (Map.Entry<Integer, Feature> entry : GameMap.this.features.entrySet()) {
          Feature f = entry.getValue();
          f.mouseMove(GameMap.this.mX, GameMap.this.mY);
          if (f.hovered) {
            if (!GameMap.this.force_all_hoverable) {
              switch(f.ID) {
                case 186: // outside light source
                case 187: // invisible light source
                case 188:
                case 189:
                case 190:
                  f.hovered = false;
                  continue;
              }
            }
            if (!GameMap.this.hovered_explored) {
              f.hovered = false;
              continue;
            }
            GameMap.this.hovered_object = f;
            global.setCursor("icons/cursor_interact.png");
            default_cursor = false;
          }
        }
        for (Map.Entry<Integer, Unit> entry : GameMap.this.units.entrySet()) {
          Unit u = entry.getValue();
          u.mouseMove(GameMap.this.mX, GameMap.this.mY);
          if (u.hovered) {
            if (!GameMap.this.hovered_visible) {
              if (GameMap.this.units.containsKey(0)) {
                if (!GameMap.this.hovered_explored || GameMap.this.units.get(0).alliance != u.alliance) {
                  u.hovered = false;
                  continue;
                }
              }
              else {
                u.hovered = false;
                continue;
              }
            }
            GameMap.this.hovered_object = u;
            if (GameMap.this.units.containsKey(0) && u.alliance != GameMap.this.units.get(0).alliance) {
              global.setCursor("icons/cursor_attack.png");
              default_cursor = false;
            }
          }
        }
        for (Map.Entry<Integer, Item> entry : GameMap.this.items.entrySet()) {
          Item i = entry.getValue();
          i.mouseMove(GameMap.this.mX, GameMap.this.mY);
          if (i.hovered) {
            if (!GameMap.this.hovered_visible) {
              i.hovered = false;
              continue;
            }
            GameMap.this.hovered_object = i;
            if (GameMap.this.units.containsKey(0) && GameMap.this.units.get(0).tier() >= i.tier) {
              global.setCursor("icons/cursor_pickup.png");
              default_cursor = false;
            }
          }
        }
        // hovered for header message
        for (HeaderMessage message : GameMap.this.headerMessages) {
          message.mouseMove(mX, mY);
        }
      }
      else {
        GameMap.this.hovered = false;
        GameMap.this.hovered_object = null;
        GameMap.this.hovered_explored = false;
        GameMap.this.hovered_visible = false;
        if (mX > GameMap.this.xi && mY > GameMap.this.yi && mX < GameMap.this.xf && mY < GameMap.this.yf) {
          GameMap.this.hovered_area = true;
          if (mX < GameMap.this.xi + Constants.map_borderSize || mX > GameMap.this.xf - Constants.map_borderSize ||
            mY < GameMap.this.yi + Constants.map_borderSize || mY > GameMap.this.yf - Constants.map_borderSize) {
            GameMap.this.hovered_border = true;
          }
          else {
            GameMap.this.hovered_border = false;
          }
        }
        else {
          GameMap.this.hovered_area = false;
          GameMap.this.hovered_border = false;
        }
        // dehover map objects
        for (Feature f : GameMap.this.features.values()) {
          f.hovered = false;
        }
        for (Map.Entry<Integer, Unit> entry : GameMap.this.units.entrySet()) {
          entry.getValue().hovered = false;
        }
        for (Map.Entry<Integer, Item> entry : GameMap.this.items.entrySet()) {
          entry.getValue().hovered = false;
        }
      }
      // aiming for player
      if (GameMap.this.units.containsKey(0) && global.holding_ctrl && !viewing_inventory && GameMap.this.in_control) {
        switch(GameMap.this.units.get(0).curr_action) {
          case AIMING:
            GameMap.this.units.get(0).aim(GameMap.this.mX, GameMap.this.mY);
            break;
          case MOVING:
            GameMap.this.units.get(0).moveTo(GameMap.this.mX, GameMap.this.mY);
            break;
          case NONE:
            GameMap.this.units.get(0).face(GameMap.this.mX, GameMap.this.mY);
            break;
        }
      }
      if (default_cursor) {
        global.defaultCursor("icons/cursor_interact.png", "icons/cursor_attack.png", "icons/cursor_pickup.png");
      }
      if (GameMap.this.restart_mouseMoveThread) {
        GameMap.this.startMouseMoveThread();
        GameMap.this.restart_mouseMoveThread = false;
      }
    }
  }



  protected GameMapCode code = GameMapCode.ERROR;
  protected String mapName = "";
  protected boolean nullify = false;

  protected int mapWidth = 0;
  protected int mapHeight = 0;
  protected GameMapSquare[][] squares;
  protected int maxHeight = Constants.map_maxHeight;

  protected int terrain_resolution = Constants.map_terrainResolutionDefault;
  protected DImg terrain_dimg;
  protected DImg fog_dimg;
  protected MapFogHandling fogHandling = MapFogHandling.DEFAULT;
  protected color fogColor = Constants.color_fog;
  protected boolean draw_fog = true;
  protected PImage terrain_display = createImage(0, 0, RGB);
  protected boolean update_terrain_display = false;
  protected boolean update_terrain_display_from_thread = false;
  protected TerrainDimgThread terrain_dimg_thread = new TerrainDimgThread();
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
  protected MouseMoveThread mouse_move_thread = null;
  protected boolean restart_mouseMoveThread = false;
  protected MapObject hovered_object = null;

  protected MapObject selected_object = null;
  protected SelectedObjectTextbox selected_object_textbox = null;
  protected ArrayList<HeaderMessage> headerMessages = new ArrayList<HeaderMessage>();

  protected HashMap<Integer, Feature> features = new HashMap<Integer, Feature>();
  protected int nextFeatureKey = 1;
  protected HashMap<Integer, Unit> units = new HashMap<Integer, Unit>();
  protected int nextUnitKey = 1;
  protected boolean in_control = true;
  protected HashMap<Integer, Item> items = new HashMap<Integer, Item>();
  protected int nextItemKey = 1;
  protected ArrayList<Projectile> projectiles = new ArrayList<Projectile>();
  protected ArrayList<VisualEffect> visualEffects = new ArrayList<VisualEffect>();

  protected float timer_refresh_fog = 0;
  protected float base_light_level = 10;
  protected boolean outside_map = true;

  GameMap() {}
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


  GameMapSquare mapSquare(int i, int j) {
    try {
      return this.squares[i][j];
    } catch(ArrayIndexOutOfBoundsException e) {
      return null;
    }
  }

  void initializeSquares() {
    this.squares = new GameMapSquare[this.mapWidth][this.mapHeight];
    for (int i = 0; i < this.mapWidth; i++) {
      for (int j = 0; j < this.mapHeight; j++) {
        this.squares[i][j] = new GameMapSquare();
      }
    }
  }


  void initializeTerrain() {
    this.terrain_resolution = global.profile.options.terrain_resolution;
    this.terrain_dimg = new DImg(this.mapWidth * this.terrain_resolution, this.mapHeight * this.terrain_resolution);
    this.terrain_dimg.setGrid(this.mapWidth, this.mapHeight);
    for (int i = 0; i < this.mapWidth; i++) {
      for (int j = 0; j < this.mapHeight; j++) {
        this.terrain_dimg.addImageGrid(this.squares[i][j].terrainImage(), i, j);
      }
    }
    for (Feature f : this.features.values()) {
      if (f.displaysImage()) {
        this.terrain_dimg.addImageGrid(f.getImage(), int(floor(f.x)), int(floor(f.y)), f.sizeX, f.sizeY);
      }
    }
    this.fog_dimg = new DImg(this.mapWidth * Constants.map_fogResolution, this.mapHeight * Constants.map_fogResolution);
    this.fog_dimg.setGrid(this.mapWidth, this.mapHeight);
    this.setFogHandling(this.fogHandling);
  }


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
        for (int i = 0; i < this.mapWidth; i++) {
          for (int j = 0; j < this.mapHeight; j++) {
            if (this.mapSquare(i, j).mapEdge()) {
              this.fog_dimg.colorGrid(Constants.color_transparent, i, j);
            }
            else if (!this.mapSquare(i, j).explored) {
              this.fog_dimg.colorGrid(Constants.color_black, i, j);
            }
            else if (!this.mapSquare(i, j).visible) {
              this.fog_dimg.colorGrid(this.fogColor, i, j);
            }
            else {
              this.fog_dimg.colorGrid(Constants.color_transparent, i, j);
            }
          }
        }
        break;
      case NONE:
        this.fog_dimg.colorPixels(Constants.color_transparent);
        for (int i = 0; i < this.mapWidth; i++) {
          for (int j = 0; j < this.mapHeight; j++) {
            this.exploreTerrainAndVisible(i, j, false);
          }
        }
        break;
      case NOFOG:
        for (int i = 0; i < this.mapWidth; i++) {
          for (int j = 0; j < this.mapHeight; j++) {
            this.setTerrainVisible(true, i, j, false);
            if (this.mapSquare(i, j).mapEdge()) {
              this.fog_dimg.colorGrid(Constants.color_transparent, i, j);
            }
            else if (!mapSquare(i, j).explored) {
              this.fog_dimg.colorGrid(Constants.color_black, i, j);
            }
            else {
              this.fog_dimg.colorGrid(Constants.color_transparent, i, j);
            }
          }
        }
        break;
      case EXPLORED:
        for (int i = 0; i < this.mapWidth; i++) {
          for (int j = 0; j < this.mapHeight; j++) {
            this.exploreTerrain(i, j, false);
            if (this.mapSquare(i, j).mapEdge()) {
              this.fog_dimg.colorGrid(Constants.color_transparent, i, j);
            }
            else if (!this.mapSquare(i, j).visible) {
              this.fog_dimg.colorGrid(this.fogColor, i, j);
            }
            else {
              this.fog_dimg.colorGrid(Constants.color_transparent, i, j);
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

  void refreshDisplayMapParameters() { // in another thread ?
    this.startSquareX = max(0, this.viewX - (0.5 * width - this.xi - Constants.map_borderSize) / this.zoom);
    this.startSquareY = max(0, this.viewY - (0.5 * height - this.yi - Constants.map_borderSize) / this.zoom);
    this.xi_map = 0.5 * width - (this.viewX - this.startSquareX) * this.zoom;
    this.yi_map = 0.5 * height - (this.viewY - this.startSquareY) * this.zoom;
    this.visSquareX = min(this.mapWidth - this.startSquareX, (this.xf - this.xi_map - Constants.map_borderSize) / this.zoom);
    this.visSquareY = min(this.mapHeight - this.startSquareY, (this.yf - this.yi_map - Constants.map_borderSize) / this.zoom);
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
    if (this.terrain_dimg_thread.isAlive()) {
      this.update_terrain_display = true;
    }
    else {
      this.update_terrain_display = false;
      this.terrain_dimg_thread = new TerrainDimgThread();
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
      this.squares[x][y].setTerrain(id);
      if (this.terrain_dimg != null) {
        this.terrain_dimg.addImageGrid(this.squares[x][y].terrainImage(), x, y);
      }
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
      if (this.squares[x][y].explored) {
        return;
      }
      this.squares[x][y].explored = true;
      if (refreshFogImage) {
        if (this.squares[x][y].mapEdge()) {
          this.fog_dimg.colorGrid(Constants.color_transparent, x, y);
        }
        else if (this.squares[x][y].visible) {
          this.fog_dimg.colorGrid(this.squares[x][y].getColor(Constants.color_transparent), x, y);
        }
        else {
          this.fog_dimg.colorGrid(this.squares[x][y].getColor(this.fogColor), x, y);
        }
      }
    }
    catch(IndexOutOfBoundsException e) {}
  }
  void exploreTerrainAndVisible(int x, int y) {
    this.exploreTerrainAndVisible(x, y, true);
  }
  void exploreTerrainAndVisible(int x, int y, boolean refreshFogImage) {
    try {
      if (this.squares[x][y].explored && this.squares[x][y].visible) {
        return;
      }
      this.squares[x][y].explored = true;
      this.squares[x][y].visible = true;
      if (refreshFogImage) {
        if (this.squares[x][y].mapEdge()) {
          this.fog_dimg.colorGrid(Constants.color_transparent, x, y);
        }
        else {
          this.fog_dimg.colorGrid(this.squares[x][y].getColor(Constants.color_transparent), x, y);
        }
      }
    }
    catch(IndexOutOfBoundsException e) {}
  }
  void setTerrainVisible(boolean visible, int x, int y) {
    this.setTerrainVisible(visible, x, y, true);
  }
  void setTerrainVisible(boolean visible, int x, int y, boolean refreshFogImage) {
    try {
      if (this.squares[x][y].visible == visible) {
        return;
      }
      this.squares[x][y].visible = visible;
      if (refreshFogImage) {
        if (!this.squares[x][y].explored) {
        }
        else if (this.squares[x][y].mapEdge()) {
          this.fog_dimg.colorGrid(Constants.color_transparent, x, y);
        }
        else if (this.squares[x][y].visible) {
          this.fog_dimg.colorGrid(this.squares[x][y].getColor(Constants.color_transparent), x, y);
        }
        else {
          this.fog_dimg.colorGrid(this.squares[x][y].getColor(this.fogColor), x, y);
        }
      }
    }
    catch(IndexOutOfBoundsException e) {}
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
    if (!f.inMap(this.mapWidth, this.mapHeight)) {
      return;
    }
    for (int i = int(floor(f.x)); i < int(floor(f.x + f.sizeX)); i++) {
      for (int j = int(floor(f.y)); j < int(floor(f.y + f.sizeY)); j++) {
        this.squares[i][j].addedFeature(f);
      }
    }
    if (this.terrain_dimg != null && f.displaysImage()) {
      this.terrain_dimg.addImageGrid(f.getImage(), int(floor(f.x)), int(floor(f.y)), f.sizeX, f.sizeY);
    }
    if (refreshImage) {
      this.refreshTerrainImage();
    }
    this.features.put(code, f);
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
  }
  // remove feature
  void removeFeature(int code) {
    if (!this.features.containsKey(code)) {
      return;
    }
    Feature f = this.features.get(code);
    this.features.get(code).remove = true;
    if (!f.inMap(this.mapWidth, this.mapHeight)) {
      return;
    }
    for (int i = int(floor(f.x)); i < int(floor(f.x + f.sizeX)); i++) {
      for (int j = int(floor(f.y)); j < int(floor(f.y + f.sizeY)); j++) {
        this.squares[i][j].removedFeature(f);
      }
    }
    if (!f.displaysImage()) {
      return;
    }
    this.terrain_dimg.colorGrid(color(1, 0), int(round(f.x)), int(round(f.y)), f.sizeX, f.sizeY);
    for (int i = int(round(f.xi())); i < int(round(f.xf())); i++) {
      for (int j = int(round(f.yi())); j < int(round(f.yf())); j++) {
        this.terrain_dimg.addImageGrid(this.squares[i][j].terrainImage(), i, j);
      }
    }
    for (Map.Entry<Integer, Feature> entry : this.features.entrySet()) {
      if (entry.getKey() == code) {
        continue;
      }
      Feature f2 = entry.getValue();
      if (f2.x < f.x + f.sizeX && f2.y < f.y + f.sizeY && f2.x + f2.sizeX > f.x && f2.y + f2.sizeY > f.y) {
        DImg dimg = new DImg(f2.getImage());
        dimg.setGrid(f2.sizeX, f2.sizeY);
        int xi_overlap = int(round(max(f.x, f2.x)));
        int yi_overlap = int(round(max(f.y, f2.y)));
        int w_overlap = int(round(min(f.xf() - xi_overlap, f2.xf() - xi_overlap)));
        int h_overlap = int(round(min(f.yf() - yi_overlap, f2.yf() - yi_overlap)));
        PImage imagePiece = dimg.getImageGridPiece(xi_overlap - int(round(f2.x)),
          yi_overlap - int(round(f2.y)), w_overlap, h_overlap);
        this.terrain_dimg.addImageGrid(imagePiece, xi_overlap, yi_overlap, w_overlap, h_overlap);
      }
    }
    this.refreshTerrainImage();
  }
  // refresh feature image (remove then add)
  void refreshFeature(int code) {
    if (!this.features.containsKey(code)) {
      return;
    }
    Feature f = this.features.get(code);
    f.refresh_map_image = false;
    if (!f.inMap(this.mapWidth, this.mapHeight)) {
      return;
    }
    if (!f.displaysImage()) {
      return;
    }
    this.terrain_dimg.colorGrid(color(1, 0), int(round(f.x)), int(round(f.y)), f.sizeX, f.sizeY);
    for (int i = int(round(f.xi())); i < int(round(f.xf())); i++) {
      for (int j = int(round(f.yi())); j < int(round(f.yf())); j++) {
        this.terrain_dimg.addImageGrid(this.squares[i][j].terrainImage(), i, j);
      }
    }
    for (Map.Entry<Integer, Feature> entry : this.features.entrySet()) {
      if (entry.getKey() == code) {
        continue;
      }
      Feature f2 = entry.getValue();
      if (f2.x < f.x + f.sizeX && f2.y < f.y + f.sizeY && f2.x + f2.sizeX > f.x && f2.y + f2.sizeY > f.y) {
        DImg dimg = new DImg(f2.getImage());
        dimg.setGrid(f2.sizeX, f2.sizeY);
        int xi_overlap = int(round(max(f.x, f2.x)));
        int yi_overlap = int(round(max(f.y, f2.y)));
        int w_overlap = int(round(min(f.xf() - xi_overlap, f2.xf() - xi_overlap)));
        int h_overlap = int(round(min(f.yf() - yi_overlap, f2.yf() - yi_overlap)));
        PImage imagePiece = dimg.getImageGridPiece(xi_overlap - int(round(f2.x)),
          yi_overlap - int(round(f2.y)), w_overlap, h_overlap);
        this.terrain_dimg.addImageGrid(imagePiece, xi_overlap, yi_overlap, w_overlap, h_overlap);
      }
    }
    this.terrain_dimg.addImageGrid(f.getImage(), int(floor(f.x)), int(floor(f.y)), f.sizeX, f.sizeY);
    this.refreshTerrainImage();
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
    if (u.x - u.size - Constants.small_number < 0) {
      u.x = u.size + Constants.small_number;
    }
    else if (u.x + u.size + Constants.small_number > this.mapWidth) {
      u.x = this.mapWidth - u.size - Constants.small_number;
    }
    if (u.y - u.size - Constants.small_number < 0) {
      u.y = u.size + Constants.small_number;
    }
    else if (u.y + u.size + Constants.small_number > this.mapHeight) {
      u.y = this.mapHeight - u.size - Constants.small_number;
    }
    u.curr_squares_on = u.getSquaresOn();
    u.resolveFloorHeight(this);
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
    if (i.x - i.size - Constants.small_number < 0) {
      i.x = i.size + Constants.small_number;
    }
    else if (i.x + i.size + Constants.small_number > this.mapWidth) {
      i.x = this.mapWidth - i.size - Constants.small_number;
    }
    if (i.y - i.size - Constants.small_number < 0) {
      i.y = i.size + Constants.small_number;
    }
    else if (i.y + i.size + Constants.small_number > this.mapHeight) {
      i.y = this.mapHeight - i.size - Constants.small_number;
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
        nameDisplayed = this.squares[int(floor(this.mX))][int(floor(this.mY))].terrainName();
      } catch(ArrayIndexOutOfBoundsException e) {}
    }
    imageMode(CORNER);
    for (int i = int(ceil(this.startSquareX_old)); i < int(floor(this.startSquareX_old + this.visSquareX_old)); i++) {
      for (int j = int(ceil(this.startSquareY_old)); j < int(floor(this.startSquareY_old + this.visSquareY_old)); j++) {
        if (this.squares[i][j].terrain_id == 191) {
          image(this.squares[i][j].terrainImage(), this.xi_map_old + (i - this.startSquareX_old) *
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
      if (entry.getKey() == 0) {
        display_player = true;
        continue;
      }
      if (this.draw_fog && !this.squares[int(floor(u.x))][int(floor(u.y))].visible) {
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
      if (this.draw_fog && !this.squares[int(floor(i.x))][int(floor(i.y))].visible) {
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
      if (this.draw_fog && !this.squares[int(floor(p.x))][int(floor(p.y))].visible) {
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
    if (this.hovered_object != null) {
      nameDisplayed = this.hovered_object.display_name();
      float ellipseX = this.xi_map_old + this.zoom_old * (this.hovered_object.xCenter() - this.startSquareX_old);
      float ellipseY = this.yi_map_old + this.zoom_old * (this.hovered_object.yCenter() - this.startSquareY_old);
      float ellipseDiameterX = this.zoom_old * this.hovered_object.width();
      float ellipseDiameterY = this.zoom_old * this.hovered_object.height();
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

  void displayNerdStats() {
    fill(255);
    textSize(14);
    textAlign(LEFT, TOP);
    float y_stats = this.yi + 31;
    float line_height = textAscent() + textDescent() + 2;
    text("Map Location: " + this.code.display_name(), this.xi + 1, y_stats);
    y_stats += line_height;
    text("FPS: " + int(global.lastFPS), this.xi + 1, y_stats);
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
        GameMapSquare square = this.squares[int(floor(this.units.get(0).x))][int(floor(this.units.get(0).y))];
        y_stats += line_height;
        text("Terrain: (" + square.terrainName() + ", " + int(10.0 * square.light_level)/10.0 + ")", this.xi + 1, y_stats);
      } catch(ArrayIndexOutOfBoundsException e) {}
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
            break;
          case 108: // Nelson Glare II
            ellipseMode(RADIUS);
            fill(170, 200);
            noStroke();
            img_width = Constants.ability_108_range * (1 - a.timer_other / Constants.ability_108_castTime);
            arc(0, 0, img_width * this.zoom_old, img_width * this.zoom_old, -Constants.
              ability_103_coneAngle, Constants.ability_103_coneAngle, PIE);
            break;
          case 112: // Tongue Lash
            img_width = Constants.ability_112_distance * (1 - a.timer_other / Constants.ability_112_castTime);
            img_height = u.size;
            image(global.images.getImage("abilities/tongue.png"), 0.5 * img_width * this.zoom_old,
              0.5 * img_height * this.zoom_old, img_width * this.zoom_old, img_height * this.zoom_old);
            break;
          case 117: // Tongue Lash II
            img_width = Constants.ability_117_distance * (1 - a.timer_other / Constants.ability_112_castTime);
            img_height = u.size;
            image(global.images.getImage("abilities/tongue.png"), 0.5 * img_width * this.zoom_old,
              0.5 * img_height * this.zoom_old, img_width * this.zoom_old, img_height * this.zoom_old);
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
    // if (player unlocked it in AchievementTree) {
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
    //}
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
      for (int i = max(int(floor(this.startSquareX)) - 8, 0); i <= min(int(ceil(
        this.startSquareX + this.visSquareX)) + 8, this.mapWidth); i++) {
        for (int j = max(int(floor(this.startSquareY)) - 8, 0); j <= min(int(ceil(
          this.startSquareY + this.visSquareY)) + 8, this.mapHeight); j++) {
          try {
            if (k == 0) {
              this.squares[i][j].original_light = this.squares[i][j].light_level;
            }
            this.squares[i][j].updateLightLevel(this, i, j);
            if (k == Constants.map_lightUpdateIterations - 1) {
              this.squares[i][j].light_source = false;
              if (abs(this.squares[i][j].light_level - this.squares[i][j].original_light) < Constants.small_number) {
                continue;
              }
              if (this.squares[i][j].mapEdge()) {
                this.fog_dimg.colorGrid(Constants.color_transparent, i, j);
              }
              else if (this.squares[i][j].visible) {
                this.fog_dimg.colorGrid(this.squares[i][j].getColor(Constants.color_transparent), i, j);
              }
              else if (this.squares[i][j].explored) {
                this.fog_dimg.colorGrid(this.squares[i][j].getColor(this.fogColor), i, j);
              }
              else {
                this.fog_dimg.colorGrid(this.squares[i][j].getColor(Constants.color_black), i, j);
              }
            }
          } catch(ArrayIndexOutOfBoundsException e) {}
        }
      }
    }
    if (this.units.containsKey(0)) {
      this.units.get(0).refreshPlayerSight(this);
    }
  }


  void updateMap(int timeElapsed) {
    // Update features
    Iterator feature_iterator = this.features.entrySet().iterator();
    while(feature_iterator.hasNext()) {
      Map.Entry<Integer, Feature> entry = (Map.Entry<Integer, Feature>)feature_iterator.next();
      Feature f = entry.getValue();
      if (f.remove) {
        this.removeFeature(entry.getKey());
        feature_iterator.remove();
        continue;
      }
      f.update(timeElapsed, this);
      if (f.refresh_map_image) {
        this.refreshFeature(entry.getKey());
      }
      if (f.remove) {
        this.removeFeature(entry.getKey());
        feature_iterator.remove();
      }
    }
    // Update units
    Iterator unit_iterator = this.units.entrySet().iterator();
    while(unit_iterator.hasNext()) {
      Map.Entry<Integer, Unit> entry = (Map.Entry<Integer, Unit>)unit_iterator.next();
      Unit u = entry.getValue();
      if (u.remove) {
        u.destroy(this);
        unit_iterator.remove();
        continue;
      }
      u.update(timeElapsed, this);
      if (u.remove) {
        u.destroy(this);
        unit_iterator.remove();
      }
    }
    this.updatePlayerUnit(timeElapsed);
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
      try {
        if (this.squares[int(floor(i.x))][int(floor(i.y))].terrain_id == 191) {
          i.remove = true;
        }
      } catch(ArrayIndexOutOfBoundsException e) {
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
      this.projectiles.get(i).update(timeElapsed, this);
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
      this.visualEffects.get(i).update(timeElapsed);
      if (this.visualEffects.get(i).remove) {
        this.removeVisualEffect(i);
        i--;
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
      u.damage(source, u.calculateDamageFrom(net_power,
        damageType, element, piercing, penetration));
    }
  }


  // return max height from list of map squares
  int maxHeightOfSquares(ArrayList<IntegerCoordinate> coordinates, boolean moving_onto) {
    int max_height = -100;
    for (IntegerCoordinate coordinate : coordinates) {
      try {
        int square_elevation = this.squares[coordinate.x][coordinate.y].elevation(moving_onto);
        if (square_elevation > max_height) {
          max_height = square_elevation;
        }
      } catch(ArrayIndexOutOfBoundsException e) {}
    }
    return max_height;
  }

  int heightOfSquare(IntegerCoordinate coordinate, boolean moving_onto) {
    int square_height = -100;
    try {
      square_height = this.squares[coordinate.x][coordinate.y].elevation(moving_onto);
    } catch(ArrayIndexOutOfBoundsException e) {}
    return square_height;
  }


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
    Iterator feature_iterator = this.features.entrySet().iterator();
    while(feature_iterator.hasNext()) {
      Map.Entry<Integer, Feature> entry = (Map.Entry<Integer, Feature>)feature_iterator.next();
      if (entry.getValue().remove) {
        this.removeFeature(entry.getKey());
        feature_iterator.remove();
      }
    }
    // Check units
    Iterator unit_iterator = this.units.entrySet().iterator();
    while(unit_iterator.hasNext()) {
      Map.Entry<Integer, Unit> entry = (Map.Entry<Integer, Unit>)unit_iterator.next();
      if (entry.getValue().remove) {
        entry.getValue().destroy(this);
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


  void update(int millis) {
    int timeElapsed = millis - this.lastUpdateTime;
    this.updateMap(timeElapsed); // map and mapObject logic
    this.updateView(timeElapsed); // if moving or zooming, check refresh_fog
    this.drawMap(); // everything visual
    this.lastUpdateTime = millis;
  }

  void mouseMove(float mX, float mY) {
    this.last_x = mX;
    this.last_y = mY;
    if (this.mouse_move_thread != null && this.mouse_move_thread.isAlive()) {
      this.restart_mouseMoveThread = true;
    }
    else {
      this.startMouseMoveThread();
    }
  }

  void startMouseMoveThread() {
    this.mouse_move_thread = new MouseMoveThread(this.last_x, this.last_y);
    this.mouse_move_thread.start();
  }

  void updateCursorPosition() {
    this.updateCursorPosition(this.last_x, this.last_y);
  }
  void updateCursorPosition(float mouse_x, float mouse_y) {
    this.mX = this.startSquareX + (this.last_x - this.xi_map) / this.zoom;
    this.mY = this.startSquareY + (this.last_y - this.yi_map) / this.zoom;
  }

  void selectHoveredObject() {
    if (this.hovered_area && !this.hovered_border) {
      this.selected_object = this.hovered_object;
    }
  }

  void mousePress() {
    for (HeaderMessage message : this.headerMessages) {
      message.mousePress();
    }
    if (this.selected_object != null && this.selected_object_textbox != null) {
      this.selected_object_textbox.mousePress();
    }
    switch(mouseButton) {
      case LEFT:
        this.selectHoveredObject();
        break;
      case RIGHT:
        if (!this.hovered_area) {
          break;
        }
        boolean viewing_inventory = false;
        if (this.units.containsKey(0) && Hero.class.isInstance(this.units.get(0))) {
          viewing_inventory = ((Hero)this.units.get(0)).inventory.viewing;
        }
        if (this.units.containsKey(0) && this.in_control && !viewing_inventory) {
          Unit player = this.units.get(0);
          if (player.curr_action_unhaltable) {
            break;
          }
          if (player.weapon() != null && player.weapon().shootable() && global.holding_ctrl) {
            player.aim(this.mX, this.mY);
          }
          else if (this.hovered_object == null || !this.hovered_object.targetable(player)) {
            player.moveTo(this.mX, this.mY);
            this.addVisualEffect(4001, this.mX, this.mY);
          }
          else {
            player.target(this.hovered_object, global.holding_ctrl);
          }
        }
        break;
      case CENTER:
        break;
    }
  }

  void mouseRelease(float mX, float mY) {
    if (this.selected_object != null && this.selected_object_textbox != null) {
      this.selected_object_textbox.mouseRelease(mX, mY);
    }
  }

  void scroll(int amount) {
    if (this.selected_object != null && this.selected_object_textbox != null) {
      this.selected_object_textbox.scroll(amount);
    }
    if (this.hovered_area && global.holding_ctrl) {
      this.changeZoom(Constants.map_scrollZoomFactor * amount);
    }
  }

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
        case ' ':
          if (this.units.containsKey(0) && !global.holding_ctrl) {
            this.selected_object = this.units.get(0);
          }
          break;
        case 'q':
        case 'Q':
          if (this.units.containsKey(0) && !global.holding_ctrl && this.in_control) {
            this.units.get(0).dropWeapon(this);
          }
          break;
        case 'a':
        case 'A':
          if (this.units.containsKey(0) && !global.holding_ctrl && this.in_control) {
            this.units.get(0).cast(1, this, this.hovered_object, true);
          }
          break;
        case 's':
        case 'S':
          if (this.units.containsKey(0) && !global.holding_ctrl && this.in_control) {
            this.units.get(0).cast(2, this, this.hovered_object, true);
          }
          break;
        case 'd':
        case 'D':
          if (this.units.containsKey(0) && !global.holding_ctrl && this.in_control) {
            this.units.get(0).cast(3, this, this.hovered_object, true);
          }
          break;
        case 'f':
        case 'F':
          if (this.units.containsKey(0) && !global.holding_ctrl && this.in_control) {
            this.units.get(0).cast(4, this, this.hovered_object, true);
          }
          break;
        case 'v':
        case 'V':
          if (this.units.containsKey(0) && !global.holding_ctrl && this.in_control) {
            this.units.get(0).jump(this);
          }
          break;
        case 'y':
        case 'Y':
          if (this.units.containsKey(0) && !global.holding_ctrl && this.in_control) {
            this.units.get(0).stopAction();
          }
          break;
      }
    }
  }

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


  void loseFocus() {
  }

  void gainFocus() {
  }


  void save(String folderPath) {
    PrintWriter file;
    file = createWriter(folderPath + "/" + this.mapName + ".map.lnz");
    file.println("new: Map");
    file.println("code: " + this.code.file_name());
    file.println("mapName: " + this.mapName);
    file.println("dimensions: " + this.mapWidth + ", " + this.mapHeight);
    file.println("maxHeight: " + this.maxHeight);
    file.println("outside_map: " + this.outside_map);
    file.println("color_tint: " + this.color_tint);
    file.println("show_tint: " + this.show_tint);
    for (int i = 0; i < this.mapWidth; i++) {
      for (int j = 0; j < this.mapHeight; j++) {
        file.println("terrain: " + i + ", " + j + ": " + this.squares[i][j].terrain_id +
          ", " + this.squares[i][j].base_elevation + ", " + this.squares[i][j].explored);
      }
    }
    // add feature data
    for (Map.Entry<Integer, Feature> entry : this.features.entrySet()) {
      file.println("nextFeatureKey: " + entry.getKey());
      file.println(entry.getValue().fileString());
    }
    // add unit data
    for (Map.Entry<Integer, Unit> entry : this.units.entrySet()) {
      if (entry.getKey() == 0) {
        continue;
      }
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
    global.profile.save(); // for ender chest
  }


  void open(String folderPath) {
    this.open2Data(this.open1File(folderPath));
    this.initializeTerrain();
  }


  String[] open1File(String folderPath) {
    String[] lines;
    String path;
    path = folderPath + "/" + this.mapName + ".map.lnz";
    lines = loadStrings(path);
    if (lines == null) {
      global.errorMessage("ERROR: Reading map at path " + path + " but no file exists.");
      this.nullify = true;
    }
    return lines;
  }


  void open2Data(String[] lines) {
    Stack<ReadFileObject> object_queue = new Stack<ReadFileObject>();

    int max_feature_key = 0;
    Feature curr_feature = null;
    int max_unit_key = 0;
    Unit curr_unit = null;
    int max_item_key = 0;
    Item curr_item = null;
    Item curr_item_internal = null; // for item inventories
    Projectile curr_projectile = null;
    StatusEffectCode curr_status_code = StatusEffectCode.ERROR;
    StatusEffect curr_status = null;
    Ability curr_ability = null;

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
              global.errorMessage("ERROR: Feature ID missing in Feature constructor.");
              break;
            }
            object_queue.push(type);
            curr_feature = new Feature(toInt(trim(parameters[2])));
            break;
          case UNIT:
            if (parameters.length < 3) {
              global.errorMessage("ERROR: Unit ID missing in Unit constructor.");
              break;
            }
            object_queue.push(type);
            curr_unit = new Unit(toInt(trim(parameters[2])));
            break;
          case ITEM:
            if (parameters.length < 3) {
              global.errorMessage("ERROR: Item ID missing in Item constructor.");
              break;
            }
            object_queue.push(type);
            if (curr_item == null) {
              curr_item = new Item(toInt(trim(parameters[2])));
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
              curr_item_internal = new Item(toInt(trim(parameters[2])));
            }
            break;
          case PROJECTILE:
            if (parameters.length < 3) {
              global.errorMessage("ERROR: Projectile ID missing in Projectile constructor.");
              break;
            }
            object_queue.push(type);
            curr_projectile = new Projectile(toInt(trim(parameters[2])));
            break;
          case STATUS_EFFECT:
            object_queue.push(type);
            curr_status = new StatusEffect();
            break;
          case ABILITY:
            if (parameters.length < 3) {
              global.errorMessage("ERROR: Ability ID missing in Projectile constructor.");
              break;
            }
            object_queue.push(type);
            curr_ability = new Ability(toInt(trim(parameters[2])));
            break;
          default:
            global.errorMessage("ERROR: Can't add a " + type + " type to GameMap data.");
            break;
        }
      }
      else if (dataname.equals("end")) {
        ReadFileObject type = ReadFileObject.objectType(trim(parameters[1]));
        if (object_queue.empty()) {
          global.errorMessage("ERROR: Tring to end a " + type.name + " object but not inside any object.");
        }
        else if (type.name.equals(object_queue.peek().name)) {
          switch(object_queue.pop()) {
            case MAP:
              return;
            case FEATURE:
              if (curr_feature == null) {
                global.errorMessage("ERROR: Trying to end a null feature.");
                break;
              }
              if (object_queue.empty()) {
                global.errorMessage("ERROR: Trying to end a feature not inside any other object.");
                break;
              }
              if (this.nextFeatureKey > max_feature_key) {
                max_feature_key = this.nextFeatureKey;
              }
              this.addFeature(curr_feature, false);
              curr_feature = null;
              break;
            case UNIT:
              if (curr_unit == null) {
                global.errorMessage("ERROR: Trying to end a null unit.");
                break;
              }
              if (object_queue.empty()) {
                global.errorMessage("ERROR: Trying to end a unit not inside any other object.");
                break;
              }
              if (this.nextUnitKey > max_unit_key) {
                max_unit_key = this.nextUnitKey;
              }
              this.addUnit(curr_unit);
              curr_unit = null;
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
                case MAP:
                  if (this.nextItemKey > max_item_key) {
                    max_item_key = this.nextItemKey;
                  }
                  this.addItemAsIs(curr_item);
                  break;
                case FEATURE:
                  if (parameters.length < 3) {
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
                  if (trim(parameters[1]).equals("item_array")) {
                    if (curr_feature.items == null) {
                      global.errorMessage("ERROR: Trying to add item to feature " +
                        "item array but curr_feature has no item array.");
                      break;
                    }
                    curr_feature.items.add(curr_item);
                    break;
                  }
                  if (!isInt(trim(parameters[2]))) {
                    global.errorMessage("ERROR: Ending item in feature inventory " +
                      "but no slot information given.");
                    break;
                  }
                  int slot_number = toInt(trim(parameters[2]));
                  if (slot_number < 0 || slot_number >= curr_feature.inventory.slots.size()) {
                    global.errorMessage("ERROR: Trying to add item to feature " +
                      "inventory but slot number " + slot_number + " out of range.");
                    break;
                  }
                  curr_feature.inventory.slots.get(slot_number).item = curr_item;
                  break;
                case UNIT:
                  if (parameters.length < 3) {
                    global.errorMessage("ERROR: GearSlot code missing in Item constructor.");
                    break;
                  }
                  GearSlot code = GearSlot.gearSlot(trim(parameters[2]));
                  if (curr_unit == null) {
                    global.errorMessage("ERROR: Trying to add gear to null unit.");
                    break;
                  }
                  curr_unit.gear.put(code, curr_item);
                  break;
                case ITEM:
                  if (curr_item_internal == null) {
                    global.errorMessage("ERROR: Trying to end a null internal item.");
                    break;
                  }
                  if (parameters.length < 3 || !isInt(trim(parameters[2]))) {
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
                  int item_slot_number = toInt(trim(parameters[2]));
                  if (item_slot_number < 0 || item_slot_number >= curr_item.inventory.slots.size()) {
                    global.errorMessage("ERROR: Trying to add item to feature " +
                      "inventory but slot number " + item_slot_number + " out of range.");
                    break;
                  }
                  curr_item.inventory.slots.get(item_slot_number).item = curr_item_internal;
                  break;
                default:
                  global.errorMessage("ERROR: Trying to end an item inside a " + object_queue.peek().name + ".");
                  break;
              }
              if (curr_item_internal == null) {
                curr_item = null;
              }
              else {
                curr_item_internal = null;
              }
              break;
            case PROJECTILE:
              if (curr_projectile == null) {
                global.errorMessage("ERROR: Trying to end a null projectile.");
                break;
              }
              if (object_queue.empty()) {
                global.errorMessage("ERROR: Trying to end a projectile not inside any other object.");
                break;
              }
              curr_projectile.refreshFacing();
              this.addProjectile(curr_projectile);
              curr_projectile = null;
              break;
            case STATUS_EFFECT:
              if (curr_status == null) {
                global.errorMessage("ERROR: Trying to end a null status effect.");
                break;
              }
              if (object_queue.empty()) {
                global.errorMessage("ERROR: Trying to end a status effect not inside any other object.");
                break;
              }
              if (object_queue.peek() != ReadFileObject.UNIT) {
                global.errorMessage("ERROR: Trying to end a status effect not inside a unit.");
                break;
              }
              if (curr_unit == null) {
                global.errorMessage("ERROR: Trying to end a status effect inside a null unit.");
                break;
              }
              curr_unit.statuses.put(curr_status_code, curr_status);
              curr_status = null;
              break;
            case ABILITY:
              if (curr_ability == null) {
                global.errorMessage("ERROR: Trying to end a null ability.");
                break;
              }
              if (object_queue.empty()) {
                global.errorMessage("ERROR: Trying to end an ability not inside any other object.");
                break;
              }
              if (object_queue.peek() != ReadFileObject.UNIT) {
                global.errorMessage("ERROR: Trying to end an ability not inside a unit.");
                break;
              }
              if (curr_unit == null) {
                global.errorMessage("ERROR: Trying to end an ability inside a null unit.");
                break;
              }
              curr_unit.abilities.add(curr_ability);
              curr_ability = null;
              break;
            default:
              break;
          }
        }
        else {
          global.errorMessage("ERROR: Tring to end a " + type.name + " object but current object is a " + object_queue.peek().name + ".");
        }
      }
      else {
        switch(object_queue.peek()) {
          case MAP:
            this.addData(dataname, data);
            break;
          case FEATURE:
            if (curr_feature == null) {
              global.errorMessage("ERROR: Trying to add feature data to a null feature.");
              break;
            }
            curr_feature.addData(dataname, data);
            break;
          case UNIT:
            if (curr_unit == null) {
              global.errorMessage("ERROR: Trying to add unit data to a null unit.");
              break;
            }
            if (dataname.equals("next_status_code")) {
              curr_status_code = StatusEffectCode.code(data);
            }
            else {
              curr_unit.addData(dataname, data);
            }
            break;
          case ITEM:
            if (curr_item == null) {
              global.errorMessage("ERROR: Trying to add item data to a null item.");
              break;
            }
            if (curr_item_internal != null) {
              curr_item_internal.addData(dataname, data);
            }
            else {
              curr_item.addData(dataname, data);
            }
            break;
          case PROJECTILE:
            if (curr_projectile == null) {
              global.errorMessage("ERROR: Trying to add projectile data to a null projectile.");
              break;
            }
            curr_projectile.addData(dataname, data);
            break;
          case STATUS_EFFECT:
            if (curr_status == null) {
              global.errorMessage("ERROR: Trying to add status effect data to a null status effect.");
              break;
            }
            curr_status.addData(dataname, data);
            break;
          case ABILITY:
            if (curr_ability == null) {
              global.errorMessage("ERROR: Trying to add ability data to a null ability.");
              break;
            }
            curr_status.addData(dataname, data);
            break;
          default:
            break;
        }
      }
    }

    // Refresh ability target units
    for (Map.Entry<Integer, Unit> entry : this.units.entrySet()) {
      for (Ability a : entry.getValue().abilities) {
        if (a == null) {
          continue;
        }
        if (this.units.containsKey(a.target_key)) {
          a.target_unit = this.units.get(a.target_key);
        }
      }
    }

    // Refresh hashmap keys
    this.nextFeatureKey = max_feature_key + 1;
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
        this.fogHandling = MapFogHandling.fogHandling(data);
        break;
      case "color_tint":
        this.color_tint = toInt(data);
        break;
      case "show_tint":
        this.show_tint = toBoolean(data);
        break;
      case "outside_map":
        this.outside_map = toBoolean(data);
        break;
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
      case "maxHeight":
        this.maxHeight = toInt(data);
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
        this.setTerrain(terrain_id, terrain_x, terrain_y, false);
        this.setTerrainBaseElevation(terrain_height, terrain_x, terrain_y);
        if (toBoolean(trim(terrain_values[2]))) {
          this.exploreTerrain(terrain_x, terrain_y, false);
        }
        break;
      case "nextFeatureKey":
        this.nextFeatureKey  = toInt(data);
        break;
      case "nextUnitKey":
        this.nextUnitKey = toInt(data);
        break;
      case "nextItemKey":
        this.nextItemKey = toInt(data);
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not recognized for GameMap object.");
        break;
    }
  }
}



class GameMapEditor extends GameMap {
  class ConfirmDeleteForm extends ConfirmForm {
    ConfirmDeleteForm() {
      super("Confirm Delete", "Are you sure you want to delete all the map " +
        "objects (features, units, items) in the rectangle?");
    }
    @Override
    void submit() {
      if (GameMapEditor.this.rectangle_dropping != null) {
        // Delete features
        for (Feature f : GameMapEditor.this.features.values()) {
          if (GameMapEditor.this.rectangle_dropping.contains(f)) {
            f.remove = true;
          }
        }
        // Delete units
        Iterator unit_iterator = GameMapEditor.this.units.entrySet().iterator();
        while(unit_iterator.hasNext()) {
          Map.Entry<Integer, Unit> entry = (Map.Entry<Integer, Unit>)unit_iterator.next();
          if (GameMapEditor.this.rectangle_dropping.contains(entry.getValue())) {
            entry.getValue().remove = true;
          }
        }
        // Delete items
        Iterator item_iterator = GameMapEditor.this.items.entrySet().iterator();
        while(item_iterator.hasNext()) {
          Map.Entry<Integer, Item> entry = (Map.Entry<Integer, Item>)item_iterator.next();
          if (GameMapEditor.this.rectangle_dropping.contains(entry.getValue())) {
            entry.getValue().remove = true;
          }
        }
      }
      GameMapEditor.this.rectangle_dropping = null;
      this.canceled = true;
    }
  }


  protected boolean dropping_terrain = false;
  protected boolean dragging_terrain = false;
  protected int terrain_id = 0;
  protected MapObject dropping_object;
  protected MapObject prev_dropping_object;
  protected boolean draw_grid = true;
  protected boolean rectangle_mode = false;
  protected Rectangle rectangle_dropping = null;
  protected boolean drawing_rectangle = false;
  protected boolean square_mode = false;
  protected ConfirmForm confirm_form;
  protected EditMapObjectForm map_object_form;

  GameMapEditor() {
    super();
    this.draw_fog = false;
    this.force_all_hoverable = true;
  }
  GameMapEditor(GameMapCode code, String folderPath) {
    super(code, folderPath);
    this.draw_fog = false;
    this.force_all_hoverable = true;
  }
  GameMapEditor(String mapName, String folderPath) {
    super(mapName, folderPath);
    this.draw_fog = false;
    this.force_all_hoverable = true;
  }
  GameMapEditor(String mapName, int mapWidth, int mapHeight) {
    super(mapName, mapWidth, mapHeight);
    this.draw_fog = false;
    this.force_all_hoverable = true;
  }


  void dropTerrain(int id) {
    this.dropping_terrain = true;
    this.terrain_id = id;
  }


  void update_super(int millis) {
    super.update(millis);
  }


  @Override
  void setZoom(float zoom) {
    if (zoom > 500) {
      zoom = 500;
    }
    else if (zoom < 15) {
      zoom = 15;
    }
    this.zoom = zoom;
    this.refreshDisplayMapParameters();
  }


  @Override
  void update(int millis) {
    if (this.confirm_form != null) {
      this.confirm_form.update(millis);
      if (this.confirm_form.canceled) {
        this.confirm_form = null;
      }
      return;
    }
    else if (this.map_object_form != null) {
      this.map_object_form.update(millis);
      if (this.map_object_form.canceled) {
        this.map_object_form = null;
      }
      return;
    }
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
    // draw rectangle dropping
    if (this.rectangle_mode && this.rectangle_dropping != null) {
      fill(170, 100);
      rectMode(CORNERS);
      noStroke();
      float rect_xi = max(this.startSquareX, this.rectangle_dropping.xi);
      float rect_yi = max(this.startSquareY, this.rectangle_dropping.yi);
      float rect_xf = min(this.startSquareX + this.visSquareX, this.rectangle_dropping.xf);
      float rect_yf = min(this.startSquareY + this.visSquareY, this.rectangle_dropping.yf);
      rect(this.xi_map + (rect_xi - this.startSquareX) * this.zoom,
        this.yi_map + (rect_yi - this.startSquareY) * this.zoom,
        this.xi_map + (rect_xf - this.startSquareX) * this.zoom,
        this.yi_map + (rect_yf - this.startSquareY) * this.zoom);
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

  void mouseMove_super(float mX, float mY) {
    super.mouseMove(mX, mY);
  }

  @Override
  void mouseMove(float mX, float mY) {
    if (this.confirm_form != null) {
      this.confirm_form.mouseMove(mX, mY);
      return;
    }
    else if (this.map_object_form != null) {
      this.map_object_form.mouseMove(mX, mY);
      return;
    }
    super.mouseMove(mX, mY);
    if (this.drawing_rectangle) {
      if (this.square_mode) {
        this.rectangle_dropping.xf = ceil(this.mX);
        this.rectangle_dropping.yf = ceil(this.mY);
      }
      else {
        this.rectangle_dropping.xf = this.mX;
        this.rectangle_dropping.yf = this.mY;
      }
    }
    if (this.dragging_terrain) {
      this.setTerrain(this.terrain_id, int(floor(this.mX)), int(floor(this.mY)));
    }
  }

  void mousePress_super() {
    super.mousePress();
  }

  @Override
  void mousePress() {
    for (HeaderMessage message : this.headerMessages) {
      message.mousePress();
    }
    if (this.confirm_form != null) {
      this.confirm_form.mousePress();
      return;
    }
    else if (this.map_object_form != null) {
      this.map_object_form.mousePress();
      return;
    }
    if (this.selected_object != null && this.selected_object_textbox != null) {
      this.selected_object_textbox.mousePress();
    }
    switch(mouseButton) {
      case LEFT:
        this.selectHoveredObject();
        break;
      case RIGHT:
        if (this.rectangle_mode) {
          if (this.square_mode) {
            this.rectangle_dropping = new Rectangle(this.mapName, floor(this.mX),
              floor(this.mY), floor(this.mX), floor(this.mY));
          }
          else {
            this.rectangle_dropping = new Rectangle(this.mapName, this.mX, this.mY, this.mX, this.mY);
          }
          this.drawing_rectangle = true;
          break;
        }
        if (this.dropping_terrain) {
          this.setTerrain(this.terrain_id, int(floor(this.mX)), int(floor(this.mY)));
          this.dragging_terrain = true;
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
            if (!global.holding_ctrl && Feature.class.isInstance(this.hovered_object)) {
              Feature hovered_object_feature = (Feature)this.hovered_object;
              if (hovered_object_feature.inventory != null) {
                hovered_object_feature.inventory.stashInDrawers(new Item(this.dropping_object.ID));
                break;
              }
            }
            else if (!global.holding_ctrl && Unit.class.isInstance(this.hovered_object)) {
              Unit hovered_object_unit = (Unit)this.hovered_object;
              if (hovered_object_unit.canPickup()) {
                hovered_object_unit.pickup(new Item(this.dropping_object.ID));
                break;
              }
            }
            this.dropping_object.setLocation(this.mX, this.mY);
            this.addItem((Item)this.dropping_object, false);
            this.dropping_object = new Item(this.dropping_object.ID);
          }
        }
        break;
      case CENTER:
        if (this.dropping_terrain) {
          this.dragging_terrain = false;
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
  }

  void mouseRelease_super(float mX, float mY) {
    super.mouseRelease(mX, mY);
  }

  @Override
  void mouseRelease(float mX, float mY) {
    if (this.confirm_form != null) {
      this.confirm_form.mouseRelease(mX, mY);
      return;
    }
    else if (this.map_object_form != null) {
      this.map_object_form.mouseRelease(mX, mY);
      return;
    }
    super.mouseRelease(mX, mY);
    switch(mouseButton) {
      case LEFT:
        break;
      case RIGHT:
        this.dragging_terrain = false;
        this.drawing_rectangle = false;
        if (this.rectangle_mode && this.rectangle_dropping != null) {
          if (this.dropping_terrain) {
            for (int i = int(floor(this.rectangle_dropping.xi)); i < int(ceil(this.rectangle_dropping.xf)); i++) {
              for (int j = int(floor(this.rectangle_dropping.yi)); j < int(ceil(this.rectangle_dropping.yf)); j++) {
                this.setTerrain(this.terrain_id, i, j);
              }
            }
            this.rectangle_dropping = null;
          }
          else if (this.dropping_object != null) {
            if (Feature.class.isInstance(this.dropping_object)) {
              for (int i = int(floor(this.rectangle_dropping.xi)); i < int(ceil(this.rectangle_dropping.xf)); i += this.dropping_object.width()) {
                for (int j = int(floor(this.rectangle_dropping.yi)); j < int(ceil(this.rectangle_dropping.yf)); j += this.dropping_object.height()) {
                  this.dropping_object.setLocation(i, j);
                  this.addFeature((Feature)this.dropping_object);
                  this.dropping_object = new Feature(this.dropping_object.ID);
                }
              }
            }
            else if (Unit.class.isInstance(this.dropping_object)) {
              // no support for unit rectangle adding
            }
            else if (Item.class.isInstance(this.dropping_object)) {
              // no support for item rectangle adding
            }
            this.rectangle_dropping = null;
          }
          else {
            this.confirm_form = new ConfirmDeleteForm();
          }
        }
        break;
      case CENTER:
        break;
    }
  }

  void scroll_super(int amount) {
    super.scroll(amount);
  }

  @Override
  void scroll(int amount) {
    if (this.confirm_form != null) {
      this.confirm_form.scroll(amount);
      return;
    }
    else if (this.map_object_form != null) {
      this.map_object_form.scroll(amount);
      return;
    }
    super.scroll(amount);
  }

  void keyPress_super() {
    super.keyPress();
  }

  @Override
  void keyPress() {
    if (this.confirm_form != null) {
      this.confirm_form.keyPress();
      return;
    }
    else if (this.map_object_form != null) {
      this.map_object_form.keyPress();
      return;
    }
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
        case 'p':
          this.terrain_dimg.img.save("data/maps/terrain.png");
          this.fog_dimg.img.save("data/maps/fog.png");
          this.terrain_display.save("data/maps/terrain_display.png");
          this.fog_display.save("data/maps/fog_display.png");
          break;
        case 'z':
          this.draw_grid = !this.draw_grid;
          if (this.draw_grid) {
            this.addHeaderMessage("Showing Grid");
          }
          else {
            this.addHeaderMessage("Hiding Grid");
          }
          break;
        case 'x':
          this.draw_fog = !this.draw_fog;
          if (this.draw_fog) {
            this.addHeaderMessage("Showing Fog");
          }
          else {
            this.addHeaderMessage("Hiding Fog");
          }
          break;
        case 'c':
          this.rectangle_mode = !this.rectangle_mode;
          this.drawing_rectangle = false;
          if (this.rectangle_mode) {
            this.addHeaderMessage("Rectangle Mode on");
          }
          else {
            this.addHeaderMessage("Rectangle Mode off");
          }
          break;
        case 'v':
          this.square_mode = !this.square_mode;
          if (this.square_mode) {
            this.addHeaderMessage("Square Mode on");
          }
          else {
            this.addHeaderMessage("Square Mode off");
          }
          break;
        case 'b':
          if (this.selected_object != null) {
            if (Feature.class.isInstance(this.selected_object)) {
              this.map_object_form = new EditFeatureForm((Feature)this.selected_object);
              global.defaultCursor();
            }
            else if (Unit.class.isInstance(this.selected_object)) {
              this.map_object_form = new EditUnitForm((Unit)this.selected_object);
              global.defaultCursor();
            }
            else if (Item.class.isInstance(this.selected_object)) {
              this.map_object_form = new EditItemForm((Item)this.selected_object);
              global.defaultCursor();
            }
          }
          break;
      }
    }
  }

  void keyRelease_super() {
    super.keyRelease();
  }

  @Override
  void keyRelease() {
    if (this.confirm_form != null) {
      this.confirm_form.keyRelease();
      return;
    }
    else if (this.map_object_form != null) {
      this.map_object_form.keyRelease();
      return;
    }
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



class GameMapLevelEditor extends GameMapEditor {
  GameMapLevelEditor(String mapName, String folderPath) {
    super(mapName, folderPath);
    this.rectangle_mode = true;
    this.square_mode = true;
  }

  @Override
  void update(int millis) {
    if (this.confirm_form != null) {
      this.confirm_form.update(millis);
      if (this.confirm_form.canceled) {
        this.confirm_form = null;
      }
      return;
    }
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
    // draw rectangle dropping
    if (this.rectangle_mode && this.rectangle_dropping != null) {
      fill(170, 100);
      rectMode(CORNERS);
      noStroke();
      float rect_xi = max(this.startSquareX, this.rectangle_dropping.xi);
      float rect_yi = max(this.startSquareY, this.rectangle_dropping.yi);
      float rect_xf = min(this.startSquareX + this.visSquareX, this.rectangle_dropping.xf);
      float rect_yf = min(this.startSquareY + this.visSquareY, this.rectangle_dropping.yf);
      rect(this.xi_map + (rect_xi - this.startSquareX) * this.zoom,
        this.yi_map + (rect_yi - this.startSquareY) * this.zoom,
        this.xi_map + (rect_xf - this.startSquareX) * this.zoom,
        this.yi_map + (rect_yf - this.startSquareY) * this.zoom);
    }
    this.lastUpdateTime = millis;
  }

  @Override
  void mouseMove(float mX, float mY) {
    if (this.confirm_form != null) {
      this.confirm_form.mouseMove(mX, mY);
      return;
    }
    this.mouseMove_super(mX, mY);
    if (this.drawing_rectangle) {
      if (this.square_mode) {
        this.rectangle_dropping.xf = ceil(this.mX);
        this.rectangle_dropping.yf = ceil(this.mY);
      }
      else {
        this.rectangle_dropping.xf = this.mX;
        this.rectangle_dropping.yf = this.mY;
      }
    }
  }

  @Override
  void mousePress() {
    for (HeaderMessage message : this.headerMessages) {
      message.mousePress();
    }
    if (this.confirm_form != null) {
      this.confirm_form.mousePress();
      return;
    }
    if (this.selected_object != null && this.selected_object_textbox != null) {
      this.selected_object_textbox.mousePress();
    }
    switch(mouseButton) {
      case LEFT:
        this.selectHoveredObject();
        break;
      case RIGHT:
        if (this.rectangle_mode) {
          if (this.square_mode) {
            this.rectangle_dropping = new Rectangle(this.mapName, floor(this.mX),
              floor(this.mY), floor(this.mX), floor(this.mY));
          }
          else {
            this.rectangle_dropping = new Rectangle(this.mapName, this.mX, this.mY, this.mX, this.mY);
          }
          this.drawing_rectangle = true;
          break;
        }
        break;
      case CENTER:
        break;
    }
  }

  @Override
  void mouseRelease(float mX, float mY) {
    if (this.confirm_form != null) {
      this.confirm_form.mouseRelease(mX, mY);
      return;
    }
    this.mouseRelease_super(mX, mY);
    switch(mouseButton) {
      case LEFT:
        break;
      case RIGHT:
        this.drawing_rectangle = false;
        break;
      case CENTER:
        break;
    }
  }

  @Override
  void scroll(int amount) {
    if (this.confirm_form != null) {
      this.confirm_form.scroll(amount);
      return;
    }
    this.scroll_super(amount);
  }

  @Override
  void keyPress() {
    if (this.confirm_form != null) {
      this.confirm_form.keyPress();
      return;
    }
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
            this.addHeaderMessage("Showing Grid");
          }
          else {
            this.addHeaderMessage("Hiding Grid");
          }
          break;
        case 'x':
          this.draw_fog = !this.draw_fog;
          if (this.draw_fog) {
            this.addHeaderMessage("Showing Fog");
          }
          else {
            this.addHeaderMessage("Hiding Fog");
          }
          break;
        case 'c':
          this.rectangle_mode = !this.rectangle_mode;
          this.drawing_rectangle = false;
          if (this.rectangle_mode) {
            this.addHeaderMessage("Rectangle Mode on");
          }
          else {
            this.addHeaderMessage("Rectangle Mode off");
          }
          break;
        case 'v':
          this.square_mode = !this.square_mode;
          if (this.square_mode) {
            this.addHeaderMessage("Square Mode on");
          }
          else {
            this.addHeaderMessage("Square Mode off");
          }
          break;
      }
    }
  }

  @Override
  void keyRelease() {
    if (this.confirm_form != null) {
      this.confirm_form.keyRelease();
      return;
    }
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
