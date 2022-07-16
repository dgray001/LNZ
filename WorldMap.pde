PImage bufferedImageToPImage(BufferedImage bimg) {
  PImage pimg = new PImage(bimg.getWidth(), bimg.getHeight(), ARGB);
  pimg.loadPixels();
  bimg.getRGB(0, 0, pimg.width, pimg.height, pimg.pixels, 0, pimg.width);
  pimg.updatePixels();
  return pimg;
}


class WorldMap {
  class MapDimgThread extends Thread {
    protected float start_percent_x = 0;
    protected float start_percent_y = 0;
    protected float vis_percent_x = 0;
    protected float vis_percent_y = 0;
    protected float xi_map = 0;
    protected float yi_map = 0;
    protected float xf_map = 0;
    protected float yf_map = 0;
    protected float zoom = 0;
    MapDimgThread() {
      super("MapDimgThread");
      this.setDaemon(true);
    }
    @Override
    void run() {
      if (WorldMap.this.map_dimg == null) {
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
      PImage next_image = WorldMap.this.map_dimg.getImagePercent(
        this.start_percent_x, this.start_percent_y, this.vis_percent_x, this.vis_percent_y);
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


  public static final float circleRadius = 10;

  class LocationCircle {
    private Location location;
    private float x_percent = 0;
    private float y_percent = 0;

    private boolean hovered = false;
    private boolean clicked = false;

    LocationCircle(Location a) {
      this.location = a;
      this.x_percent = a.worldMapLocationX();
      this.y_percent = a.worldMapLocationY();
    }

    boolean outsideView(float start_x, float start_y, float vis_x, float vis_y, float zoom) {
      float circleRadiusX = zoom * WorldMap.this.circleRadius / WorldMap.this.map_dimg.img.width;
      float circleRadiusY = zoom * WorldMap.this.circleRadius / WorldMap.this.map_dimg.img.height;
      if (this.x_percent - circleRadiusX < start_x || this.y_percent - circleRadiusY < start_y ||
        this.x_percent + circleRadiusX < start_x || this.y_percent + circleRadiusY < start_y) {
        return true;
      }
      return false;
    }
  }


  private DImg map_dimg = null;
  private PImage display_img = null;
  private MapDimgThread map_dimg_thread = null;
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

  private ArrayList<LocationCircle> location_circles = new ArrayList<LocationCircle>();

  private int last_update_time = 0;

  WorldMap() {
    this.map_dimg = new DImg(global.images.getImage("world_map.jpg"));
    for (Location location : Location.VALUES) {
      if (location.isArea() || location.isCampaignStart()) {
        this.location_circles.add(new LocationCircle(location));
      }
    }
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
    this.start_percent_x = max(0, this.viewX - (0.5 * width - this.xi) * this.zoom / this.map_dimg.img.width);
    this.start_percent_y = max(0, this.viewY - (0.5 * height - this.yi) * this.zoom / this.map_dimg.img.height);
    this.xi_map = 0.5 * width - (this.viewX - this.start_percent_x) * this.map_dimg.img.width / this.zoom;
    this.yi_map = 0.5 * height - (this.viewY - this.start_percent_y) * this.map_dimg.img.height / this.zoom;
    this.vis_percent_x = min(1.0 - this.start_percent_x, (this.xf - this.xi_map) * this.zoom / this.map_dimg.img.width);
    this.vis_percent_y = min(1.0 - this.start_percent_y, (this.yf - this.yi_map) * this.zoom / this.map_dimg.img.height);
    this.xf_map = this.xi_map + this.vis_percent_x * this.map_dimg.img.width / this.zoom;
    this.yf_map = this.yi_map + this.vis_percent_y * this.map_dimg.img.height / this.zoom;
    this.xi_map_dif = this.start_percent_x - this.start_percent_x_old;
    this.yi_map_dif = this.start_percent_y - this.start_percent_y_old;
    this.xf_map_dif = xi_map_dif + this.vis_percent_x - this.vis_percent_x_old;
    this.yf_map_dif = yi_map_dif + this.vis_percent_y - this.vis_percent_y_old;
    this.refreshDisplayImage();
  }

  void refreshDisplayImage() {
    if (this.map_dimg_thread != null && this.map_dimg_thread.isAlive()) {
      this.update_display = true;
    }
    else {
      this.update_display = false;
      this.startMapThread();
    }
  }
  void startMapThread() {
    this.map_dimg_thread = new MapDimgThread();
    this.map_dimg_thread.start();
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
        this.map_dimg.img.width / this.map_dimg.img.height, false);
      refreshView = true;
    }
    if (this.view_moving_down) {
      this.moveView(0, time_elapsed * Constants.playing_viewMoveSpeedFactor *
        this.map_dimg.img.width / this.map_dimg.img.height, false);
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
    // display location circles
    for (LocationCircle location : this.location_circles) {
      if (location.outsideView(this.start_percent_x_old, this.start_percent_y_old,
        this.vis_percent_x_old, this.vis_percent_y_old, this.zoom_old)) {
        continue;
      }
      float translate_x = this.xi_map_old + this.xi_map_dif + (location.x_percent -
        this.start_percent_x_old) * this.map_dimg.img.width / this.zoom_old;
      float translate_y = this.yi_map_old + this.yi_map_dif + (location.y_percent -
        this.start_percent_y_old) * this.map_dimg.img.height / this.zoom_old;
      translate(translate_x, translate_y);
      noFill();
      stroke(ccolor(255, 255, 0));
      strokeWeight(2);
      circle(0, 0, this.circleRadius);
      translate(-translate_x, -translate_y);
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
      this.setZoom(exp(x));
    //}
  }
}
