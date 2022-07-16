PImage bufferedImageToPImage(BufferedImage bimg) {
  PImage pimg = new PImage(bimg.getWidth(), bimg.getHeight(), ARGB);
  pimg.loadPixels();
  bimg.getRGB(0, 0, pimg.width, pimg.height, pimg.pixels, 0, pimg.width);
  pimg.updatePixels();
  return pimg;
}


class WorldMap {
  class MapBimgThread extends Thread {
    protected float start_percent_x = 0;
    protected float start_percent_y = 0;
    protected float vis_percent_x = 0;
    protected float vis_percent_y = 0;
    protected float xi_map = 0;
    protected float yi_map = 0;
    protected float xf_map = 0;
    protected float yf_map = 0;
    protected float zoom = 0;
    MapBimgThread() {
      super("MapBimgThread");
      this.setDaemon(true);
    }
    @Override
    void run() {
      if (WorldMap.this.map_bimg == null) {
        return;
      }
      this.start_percent_x = WorldMap.this.start_percent_x;
      this.start_percent_y = WorldMap.this.start_percent_y;
      this.vis_percent_x = WorldMap.this.vis_percent_x;
      this.vis_percent_y = WorldMap.this.vis_percent_y;
      this.xi_map = WorldMap.this.xi_map;
      this.yi_map = WorldMap.this.yi_map;
      this.xf_map = WorldMap.this.xf_map;
      this.yf_map = WorldMap.this.yf_map;
      this.zoom = WorldMap.this.zoom;
      PImage next_image = bufferedImageToPImage(WorldMap.this.map_bimg.getSubimage(
        round(this.start_percent_x * WorldMap.this.map_bimg.getWidth()),
        round(this.start_percent_y * WorldMap.this.map_bimg.getHeight()),
        round(this.vis_percent_x * WorldMap.this.map_bimg.getWidth()),
        round(this.vis_percent_y * WorldMap.this.map_bimg.getHeight())));
      next_image = resizeImage(next_image,
        round(this.xf_map - this.xi_map), round(this.yf_map - this.yi_map));
      WorldMap.this.display_img = next_image;
      WorldMap.this.start_percent_x_old = this.start_percent_x;
      WorldMap.this.start_percent_y_old = this.start_percent_y;
      WorldMap.this.vis_percent_x_old = this.vis_percent_x;
      WorldMap.this.vis_percent_y_old = this.vis_percent_y;
      WorldMap.this.xi_map_old = this.xi_map;
      WorldMap.this.yi_map_old = this.yi_map;
      WorldMap.this.xf_map_old = this.xf_map;
      WorldMap.this.yf_map_old = this.yf_map;
      WorldMap.this.xi_map_dif = 0;
      WorldMap.this.yi_map_dif = 0;
      WorldMap.this.xf_map_dif = 0;
      WorldMap.this.yf_map_dif = 0;
      WorldMap.this.zoom_old = this.zoom;
    }
  }


  private BufferedImage map_bimg = null;
  private PImage display_img = null;
  private MapBimgThread map_bimg_thread = null;
  private boolean update_display = false;

  private float xi = 0;
  private float yi = 0;
  private float xf = 0;
  private float yf = 0;

  protected float viewX = 0;
  protected float viewY = 0;
  protected float zoom = Constants.playing_worldMapDefaultZoom;
  protected float zoom_old = Constants.playing_worldMapDefaultZoom;
  protected boolean view_moving_left = false;
  protected boolean view_moving_right = false;
  protected boolean view_moving_up = false;
  protected boolean view_moving_down = false;

  protected float start_percent_x = 0;
  protected float start_percent_y = 0;
  protected float vis_percent_x = 0;
  protected float vis_percent_y = 0;
  protected float start_percent_x_old = 0;
  protected float start_percent_y_old = 0;
  protected float vis_percent_x_old = 0;
  protected float vis_percent_y_old = 0;

  private float xi_map = 0;
  private float yi_map = 0;
  private float xf_map = 0;
  private float yf_map = 0;
  private float xi_map_old = 0;
  private float yi_map_old = 0;
  private float xf_map_old = 0;
  private float yf_map_old = 0;
  private float xi_map_dif = 0;
  private float yi_map_dif = 0;
  private float xf_map_dif = 0;
  private float yf_map_dif = 0;

  private float last_x = 0;
  private float last_y = 0;
  private float map_mX = 0;
  private float map_mY = 0;

  private int last_update_time = 0;

  WorldMap() {
    try {
      this.map_bimg = BigBufferedImage.create(new File(sketchPath("data/images/logo.png")), BufferedImage.TYPE_INT_ARGB);
    } catch(IOException e) {}
  }


  void setLocation(float xi, float yi, float xf, float yf) {
    this.xi = xi;
    this.yi = yi;
    this.xf = xf;
    this.yf = yf;
    this.refreshDisplayMapParameters();
  }

  void setZoom(float zoom) {
    if (Float.isNaN(zoom)) {
      return;
    }
    if (zoom > Constants.playing_worldMapMaxZoom) {
      zoom = Constants.playing_worldMapMaxZoom;
    }
    else if (zoom < Constants.playing_worldMapMinZoom) {
      zoom = Constants.playing_worldMapMinZoom;
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
    if (viewX < 0.0) {
      viewX = 0.0;
    }
    else if (viewX > 1.0) {
      viewX = 1.0;
    }
    if (viewY < 0.0) {
      viewY = 0.0;
    }
    else if (viewY > 1.0) {
      viewY = 1.0;
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

  void refreshDisplayMapParameters() {
    this.start_percent_x = max(0, this.viewX - (0.5 * width - this.xi) * this.zoom / this.map_bimg.getWidth());
    this.start_percent_y = max(0, this.viewY - (0.5 * height - this.yi) * this.zoom / this.map_bimg.getHeight());
    this.xi_map = 0.5 * width - (this.viewX - this.start_percent_x) * this.map_bimg.getWidth() / this.zoom;
    this.yi_map = 0.5 * height - (this.viewY - this.start_percent_y) * this.map_bimg.getHeight() / this.zoom;
    this.vis_percent_x = min(1.0 - this.start_percent_x, (this.xf - this.xi_map) * this.zoom / this.map_bimg.getWidth());
    this.vis_percent_y = min(1.0 - this.start_percent_y, (this.yf - this.yi_map) * this.zoom / this.map_bimg.getHeight());
    this.xf_map = this.xi_map + this.vis_percent_x * this.map_bimg.getWidth() / this.zoom;
    this.yf_map = this.yi_map + this.vis_percent_y * this.map_bimg.getHeight() / this.zoom;
    this.xi_map_dif = this.start_percent_x - this.start_percent_x_old;
    this.yi_map_dif = this.start_percent_y - this.start_percent_y_old;
    this.xf_map_dif = xi_map_dif + this.vis_percent_x - this.vis_percent_x_old;
    this.yf_map_dif = yi_map_dif + this.vis_percent_y - this.vis_percent_y_old;
    this.refreshDisplayImage();
  }

  void refreshDisplayImage() {
    if (this.map_bimg_thread != null && this.map_bimg_thread.isAlive()) {
      this.update_display = true;
    }
    else {
      this.update_display = false;
      this.startMapThread();
    }
  }
  void startMapThread() {
    this.map_bimg_thread = new MapBimgThread();
    this.map_bimg_thread.start();
  }


  void update(int millis) {
    int time_elapsed = millis - this.last_update_time;
    boolean refreshView = false;
    // moving view
    if (this.view_moving_left) {
      this.moveView(-time_elapsed * Constants.playing_viewMoveSpeedFactor, 0, false);
      refreshView = true;
    }
    if (this.view_moving_right) {
      this.moveView(time_elapsed * Constants.playing_viewMoveSpeedFactor, 0, false);
      refreshView = true;
    }
    if (this.view_moving_up) {
      this.moveView(0, -time_elapsed * Constants.playing_viewMoveSpeedFactor *
        this.map_bimg.getHeight() / this.map_bimg.getWidth(), false);
      refreshView = true;
    }
    if (this.view_moving_down) {
      this.moveView(0, time_elapsed * Constants.playing_viewMoveSpeedFactor *
        this.map_bimg.getHeight() / this.map_bimg.getWidth(), false);
      refreshView = true;
    }
    if (refreshView) {
      this.refreshDisplayMapParameters();
      this.updateCursorPosition();
    }
    // display map
    rectMode(CORNERS);
    noStroke();
    fill(ccolor(60));
    rect(this.xi, this.yi, this.xf, this.yf);
    if (this.display_img != null) {
      imageMode(CORNERS);
      image(this.display_img, this.xi_map_old + this.xi_map_dif, this.yi_map_old +
        this.yi_map_dif, this.xf_map_old + this.xf_map_dif, this.yf_map_old + this.yf_map_dif);
    }
    this.last_update_time = millis;
  }

  void mouseMove(float mX, float mY) {
    this.last_x = mX;
    this.last_y = mY;
    if (mX < Constants.small_number) {
      WorldMap.this.view_moving_left = true;
      if (!global.holding_right) {
        WorldMap.this.view_moving_right = false;
      }
    }
    else if (mX > width - 1 - Constants.small_number) {
      WorldMap.this.view_moving_right = true;
      if (!global.holding_left) {
        WorldMap.this.view_moving_left = false;
      }
    }
    else {
      if (!global.holding_right) {
        WorldMap.this.view_moving_right = false;
      }
      if (!global.holding_left) {
        WorldMap.this.view_moving_left = false;
      }
    }
    if (mY < Constants.small_number) {
      WorldMap.this.view_moving_up = true;
      if (!global.holding_down) {
        WorldMap.this.view_moving_down = false;
      }
    }
    else if (mY > height - 1 - Constants.small_number) {
      WorldMap.this.view_moving_down = true;
      if (!global.holding_up) {
        WorldMap.this.view_moving_up = false;
      }
    }
    else {
      if (!global.holding_down) {
        WorldMap.this.view_moving_down = false;
      }
      if (!global.holding_up) {
        WorldMap.this.view_moving_up = false;
      }
    }
  }

  void updateCursorPosition() {
    this.updateCursorPosition(this.last_x, this.last_y);
  }
  void updateCursorPosition(float mouse_x, float mouse_y) {
    this.map_mX = this.start_percent_x + (this.last_x - this.xi_map) / this.zoom;
    this.map_mY = this.start_percent_y + (this.last_y - this.yi_map) / this.zoom;
  }

  void mousePress() {
  }

  void mouseRelease(float mX, float mY) {
  }

  void scroll(int amount) {
    //if (this.hovered_area && global.holding_ctrl) {
      float x = log(this.zoom) + Constants.playing_scrollZoomFactor * amount;
      if (x < 0) {
        x = 0;
      }
      this.setZoom(exp(x));
    //}
  }
}
