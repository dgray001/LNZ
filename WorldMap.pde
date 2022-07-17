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

    private float distance_from_cursor = 0;
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


  class LeftPanelForm extends Form {
    class HeroListFormField extends MessageFormField {
      class HeroCodeButton extends ImageButton {
        protected HeroCode code;
        HeroCodeButton(HeroCode code) {
          super(global.images.getImage("units/" + code.imagePathHeader() + ".png"), 0, 0, 0, 0);
          this.code = code;
          this.overshadow_colors = true;
          this.setColors(ccolor(200, 100), ccolor(1, 0), ccolor(220, 80), ccolor(180, 140), ccolor(0));
        }
        void hover() {}
        void dehover() {}
        void click() {}
        void release() {
          if (!this.hovered) {
            return;
          }
          HeroListFormField.this.switchToHero(this.code);
        }
      }
      protected ArrayList<HeroCodeButton> heroes = new ArrayList<HeroCodeButton>();
      protected float default_hero_image_height = 70;
      protected float hero_image_height = 0;
      protected float button_gap = 3;
      HeroListFormField() {
        super("Heroes at this location:");
        this.setTextSize(20);
      }
      void addHeroCode(HeroCode code) {
        this.heroes.add(new HeroCodeButton(code));
        this.updateWidthDependencies();
      }
      void switchToHero(HeroCode code) {
        LeftPanelForm.this.switchToHero(code);
      }
      @Override
      void updateWidthDependencies() {
        super.updateWidthDependencies();
        if (this.heroes.size() == 0) {
          this.hero_image_height = 0;
          return;
        }
        this.hero_image_height = min(this.default_hero_image_height,
          (this.field_width - this.button_gap * this.heroes.size() + this.button_gap) / this.heroes.size());
        float x_curr = 0;
        float y_start = super.getHeight() + this.button_gap;
        for (HeroCodeButton button : this.heroes) {
          button.setLocation(x_curr, y_start, x_curr + this.hero_image_height, y_start + this.hero_image_height);
          x_curr += this.hero_image_height + this.button_gap;
        }
      }
      @Override
      float getHeight() {
        return super.getHeight() + this.hero_image_height + this.button_gap;
      }
      @Override
      FormFieldSubmit update(int millis) {
        for (HeroCodeButton button : this.heroes) {
          button.update(millis);
        }
        if (this.heroes.size() == 0) {
          return FormFieldSubmit.NONE;
        }
        return super.update(millis);
      }
      @Override
      void mouseMove(float mX, float mY) {
        for (HeroCodeButton button : this.heroes) {
          button.mouseMove(mX, mY);
        }
      }
      @Override
      void mousePress() {
        for (HeroCodeButton button : this.heroes) {
          button.mousePress();
        }
      }
      @Override
      void mouseRelease(float mX, float mY) {
        for (HeroCodeButton button : this.heroes) {
          button.mouseRelease(mX, mY);
        }
      }
    }

    protected Location location;

    LeftPanelForm(Location location, float xi, float yi, float xf, float yf) {
      super(xi, yi, xf, yf);
      this.location = location;
      this.color_background = ccolor(250, 190, 140);
      this.scrollbar.setButtonColors(ccolor(220), ccolor(220, 160, 110), ccolor(
        240, 180, 130), ccolor(200, 140, 90), ccolor(0));
      this.scrollbar.button_upspace.setColors(ccolor(170), ccolor(255, 200, 150),
        ccolor(255, 200, 150), ccolor(60, 30, 0), ccolor(0));
      this.scrollbar.button_downspace.setColors(ccolor(170), ccolor(255, 200, 150),
        ccolor(255, 200, 150), ccolor(60, 30, 0), ccolor(0));

      MessageFormField title = new MessageFormField(location.getCampaignName());
      title.text_align = CENTER;
      title.setTextSize(26);
      MessageFormField subtitle = new MessageFormField(location.getCampaignSubtitle());
      subtitle.text_align = CENTER;
      subtitle.setTextSize(20);
      TextBoxFormField description = new TextBoxFormField(location.campaignDescription(), 250);
      description.textbox.color_background = this.color_background;
      description.textbox.scrollbar.setButtonColors(ccolor(220), ccolor(220, 160, 110), ccolor(
        240, 180, 130), ccolor(200, 140, 90), ccolor(0));
      description.textbox.scrollbar.button_upspace.setColors(ccolor(170), ccolor(255, 200, 150),
        ccolor(255, 200, 150), ccolor(60, 30, 0), ccolor(0));
      description.textbox.scrollbar.button_downspace.setColors(ccolor(170), ccolor(255, 200, 150),
        ccolor(255, 200, 150), ccolor(60, 30, 0), ccolor(0));
      HeroListFormField heroes = new HeroListFormField();
      for (Hero hero : global.profile.heroes.values()) {
        if (hero.location != location) {
          continue;
        }
        heroes.addHeroCode(hero.code);
      }

      this.addField(title);
      this.addField(subtitle);
      this.addField(new ImageFormField(global.images.getImage(location.campaignImagePath()), 90));
      this.addField(description);
      this.addField(heroes);
      // unlocked / how to unlock
    }

    void switchToHero(HeroCode code) {
      WorldMap.this.switchToHero(code);
    }

    void submit() {}
    void cancel() {}
    void buttonPress(int i) {}
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

  private boolean hovered = false;
  private boolean dragging = false;
  private LocationCircle location_hovered = null;
  private Location location_clicked = null;
  private LeftPanelForm left_panel_form = null;

  private HashMap<Location, LocationCircle> location_circles = new HashMap<Location, LocationCircle>();

  private int last_update_time = 0;

  private PlayingInterface playing_interface;

  WorldMap(PlayingInterface playing_interface) {
    this.playing_interface = playing_interface;
    this.map_dimg = new DImg(global.images.getImage("world_map.jpg"));
    for (Location location : Location.VALUES) {
      if (location.isArea() || location.isCampaignStart()) {
        this.location_circles.put(location, new LocationCircle(location));
      }
    }
    Hero curr_hero = global.profile.heroes.get(global.profile.curr_hero);
    if (curr_hero == null) {
      return;
    }
    Location curr_location = curr_hero.location;
    if (curr_location != null && curr_location != Location.ERROR) {
      if (!curr_location.isArea()) {
        curr_location = Location.getCampaignStart(curr_location);
      }
      this.setViewLocation(curr_location.worldMapLocationX(), curr_location.worldMapLocationY(), false);
    }
  }


  void switchToHero(HeroCode code) {
    this.playing_interface.switchHero(code, true);
  }


  void setLocation(float xi, float yi, float xf, float yf) {
    this.xi = xi;
    this.yi = yi;
    this.xf = xf;
    this.yf = yf;
    if (this.left_panel_form != null) {
      this.left_panel_form.setLocation(1, yi + 1, xi - 1, yf - 1);
    }
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


  void drawLeftPanel(int millis) {
    if (this.left_panel_form != null) {
      this.left_panel_form.update(millis);
    }
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
    for (LocationCircle location : this.location_circles.values()) {
      if (location.outsideView(this.start_percent_x_old, this.start_percent_y_old,
        this.vis_percent_x_old, this.vis_percent_y_old, this.zoom_old)) {
        continue;
      }
      float translate_x = this.xi_map_old + this.xi_map_dif + (location.x_percent -
        this.start_percent_x_old) * this.map_dimg.img.width / this.zoom_old;
      float translate_y = this.yi_map_old + this.yi_map_dif + (location.y_percent -
        this.start_percent_y_old) * this.map_dimg.img.height / this.zoom_old;
      translate(translate_x, translate_y);
      if (location.hovered) {
        fill(ccolor(255, 255, 0));
      }
      else {
        noFill();
      }
      stroke(ccolor(255, 255, 0));
      strokeWeight(2);
      circle(0, 0, this.circleRadius);
      if (location.hovered) { // hovered info
        fill(global.color_nameDisplayed_background);
        stroke(global.color_nameDisplayed_background);
        strokeWeight(0.01);
        triangle(0, 0, -2 * this.circleRadius, -3.5 * this.circleRadius,
          2 * this.circleRadius, -3.5 * this.circleRadius);
        String location_name = location.location.getCampaignName();
        textSize(24);
        float name_width = textWidth(location_name) + 2;
        float name_height = textAscent() + textDescent() + 2;
        float name_xi = -2 * this.circleRadius;
        float name_yi = -3.5 * this.circleRadius - name_height;
        fill(global.color_nameDisplayed_background);
        rectMode(CORNER);
        noStroke();
        rect(name_xi, name_yi, name_width, name_height);
        fill(global.color_nameDisplayed_text);
        textAlign(LEFT, TOP);
        text(location_name, name_xi + 1, name_yi + 1);
      }
      translate(-translate_x, -translate_y);
    }
    this.last_update_time = millis;
  }

  void mouseMove(float mX, float mY) {
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
    if (this.dragging) {
      this.moveView((this.last_x - mX) * this.zoom_old / this.map_dimg.img.width,
        (this.last_y - mY) * this.zoom_old / this.map_dimg.img.height);
    }
    this.last_x = mX;
    this.last_y = mY;
    if (mX < this.xi || mY < this.yi || mX > this.xf || mY > this.yf) {
      this.hovered = false;
    }
    else {
      this.hovered = true;
    }
    if (this.left_panel_form != null) {
      this.left_panel_form.mouseMove(mX, mY);
    }
    this.location_hovered = null;
    for (LocationCircle location : this.location_circles.values()) {
      location.hovered = false;
      if (!this.hovered) {
        continue;
      }
      float translate_x = this.xi_map_old + this.xi_map_dif + (location.x_percent -
        this.start_percent_x_old) * this.map_dimg.img.width / this.zoom_old;
      float translate_y = this.yi_map_old + this.yi_map_dif + (location.y_percent -
        this.start_percent_y_old) * this.map_dimg.img.height / this.zoom_old;
      float x_dist = mX - translate_x;
      float y_dist = mY - translate_y;
      float dist = sqrt(x_dist * x_dist + y_dist * y_dist);
      location.distance_from_cursor = dist;
      if (dist > this.circleRadius) {
        continue;
      }
      if (this.location_hovered == null) {
        this.location_hovered = location;
        location.hovered = true;
        continue;
      }
      if (dist >= this.location_hovered.distance_from_cursor) {
        continue;
      }
      this.location_hovered.hovered = false;
      this.location_hovered = location;
      location.hovered = true;
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
    if (this.left_panel_form != null) {
      this.left_panel_form.mousePress();
    }
    if (!this.hovered) {
      return;
    }
    if (this.location_hovered == null) {
      if (mouseButton == LEFT) {
        this.dragging = true;
      }
    }
    else {
      this.location_hovered.clicked = true;
    }
  }

  void mouseRelease(float mX, float mY) {
    if (this.left_panel_form != null) {
      this.left_panel_form.mouseRelease(mX, mY);
    }
    if (mouseButton == LEFT) {
      this.dragging = false;
    }
    for (LocationCircle location : this.location_circles.values()) {
      if (!this.hovered || !location.hovered) {
        location.clicked = false;
        continue;
      }
      if (location.clicked) {
        location.clicked = false;
        this.location_clicked = location.location;
      }
    }
    if (this.location_clicked == null) {
      this.left_panel_form = null;
    }
    else if (this.left_panel_form == null || this.left_panel_form.location != this.location_clicked) {
      this.left_panel_form = new LeftPanelForm(this.location_clicked, Constants.mapEditor_listBoxGap,
        this.yi + Constants.mapEditor_listBoxGap, this.xi - Constants.mapEditor_listBoxGap,
        this.yi + 0.5 * (this.yf - this.yi) - 1);
    }
  }

  void scroll(int amount) {
    if (this.left_panel_form != null) {
      this.left_panel_form.scroll(amount);
    }
    if (this.hovered) {
      float x = log(this.zoom) + Constants.playing_scrollZoomFactor * amount;
      this.setZoom(exp(x));
    }
  }
}
