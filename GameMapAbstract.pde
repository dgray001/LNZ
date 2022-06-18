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
}
