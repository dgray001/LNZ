class WorldMap {
  class MapDimgThread extends Thread {
    MapDimgThread() {
      super("MapDimgThread");
      this.setDaemon(true);
    }
    @Override
    void run() {
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

  protected float mX = 0;
  protected float mY = 0;
  protected float last_x = 0;
  protected float last_y = 0;

  WorldMap() {
    this.map_dimg = new DImg(global.images.getImage("world_map.jpg"));
  }


  void setLocation(float xi, float yi, float xf, float yf) {
    this.xi = xi;
    this.yi = yi;
    this.xf = xf;
    this.yf = yf;
    this.refreshDisplayMapParameters();
  }

  void setZoom(float zoom) {
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
    if (viewX < 0) {
      viewX = 0;
    }
    else if (viewX > 1) {
      viewX = 1;
    }
    if (viewY < 0) {
      viewY = 0;
    }
    else if (viewY > 1) {
      viewY = 1;
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
    this.start_percent_x = max(0, this.viewX - (0.5 * width - this.xi) / this.zoom);
    this.start_percent_y = max(0, this.viewY - (0.5 * height - this.yi) / this.zoom);
    this.xi_map = 0.5 * width - (this.viewX - this.start_percent_x) * this.zoom;
    this.yi_map = 0.5 * height - (this.viewY - this.start_percent_y) * this.zoom;
    this.vis_percent_x = min(1 - this.start_percent_x, (this.xf - this.xi_map) / this.zoom);
    this.vis_percent_y = min(1 - this.start_percent_y, (this.yf - this.yi_map) / this.zoom);
    this.xf_map = this.xi_map + this.vis_percent_x * this.zoom;
    this.yf_map = this.yi_map + this.vis_percent_y * this.zoom;
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
      this.startDimgThread();
    }
  }
  void startDimgThread() {
  }


  void update(int millis) {
    // display map
    if (this.display_img != null) {
      imageMode(CORNERS);
      image(this.display_img, this.xi_map_old + this.xi_map_dif, this.yi_map_old +
        this.yi_map_dif, this.xf_map_old + this.xf_map_dif, this.yf_map_old + this.yf_map_dif);
    }
  }

  void mouseMove(float mX, float mY) {
  }

  void updateCursorPosition() {
    this.updateCursorPosition(this.last_x, this.last_y);
  }
  void updateCursorPosition(float mouse_x, float mouse_y) {
    this.mX = this.start_percent_x + (this.last_x - this.xi_map) / this.zoom;
    this.mY = this.start_percent_y + (this.last_y - this.yi_map) / this.zoom;
  }

  void mousePress() {
  }

  void mouseRelease(float mX, float mY) {
  }

  void scroll(int amount) {
  }
}
