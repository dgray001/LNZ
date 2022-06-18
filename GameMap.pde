class GameMap extends AbstractGameMap {
  class TerrainDimgThread extends AbstractTerrainDimgThread {
    TerrainDimgThread() {
      super("TerrainDimgThread");
    }

    void runThread() {
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


  class MouseMoveThread extends AbstractMouseMoveThread {
    private float mX = 0;
    private float mY = 0;

    MouseMoveThread(float mX, float mY) {
      super("MouseMoveThread");
      this.mX = mX;
      this.mY = mY;
    }

    void runThread() {
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
          else if (!GameMap.this.draw_fog || GameMap.this.mapSquare(int(
            GameMap.this.mX), int(GameMap.this.mY)).explored) {
            GameMap.this.hovered_explored = true;
          }
        } catch(NullPointerException e) {}
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
            GameMap.this.units.get(0).moveTo(GameMap.this.mX, GameMap.this.mY, GameMap.this);
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

  protected int mapWidth = 0;
  protected int mapHeight = 0;
  protected GameMapSquare[][] squares;

  protected DImg terrain_dimg;
  protected DImg fog_dimg;

  protected HashMap<Integer, Feature> features = new HashMap<Integer, Feature>();

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
    for (int i = 0; i < this.mapWidth; i++) {
      for (int j = 0; j < this.mapHeight; j++) {
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
      Feature f = entry.getValue();
      if (f.remove) {
        this.removeFeature(entry.getKey());
        feature_iterator.remove();
        continue;
      }
      f.update(time_elapsed, this);
      if (f.refresh_map_image) {
        this.refreshFeature(entry.getKey());
      }
      if (f.remove) {
        this.removeFeature(entry.getKey());
        feature_iterator.remove();
      }
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
            player.moveTo(this.mX, this.mY, this);
            this.addVisualEffect(4001, this.mX, this.mY);
          }
          else {
            player.target(this.hovered_object, this, global.holding_ctrl);
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
            if (this.units.get(0).abilities.size() < 2 || this.units.get(0).abilities.get(1) == null) {
              break;
            }
            else if (this.units.get(0).silenced()) {
              this.addHeaderMessage("You are silenced");
            }
            else {
              this.units.get(0).cast(1, this, this.hovered_object, true);
            }
          }
          break;
        case 's':
        case 'S':
          if (this.units.containsKey(0) && !global.holding_ctrl && this.in_control) {
            if (this.units.get(0).abilities.size() < 3 || this.units.get(0).abilities.get(2) == null) {
              break;
            }
            else if (this.units.get(0).silenced()) {
              this.addHeaderMessage("You are silenced");
            }
            else {
              this.units.get(0).cast(2, this, this.hovered_object, true);
            }
          }
          break;
        case 'd':
        case 'D':
          if (this.units.containsKey(0) && !global.holding_ctrl && this.in_control) {
            if (this.units.get(0).abilities.size() < 4 || this.units.get(0).abilities.get(3) == null) {
              break;
            }
            else if (this.units.get(0).silenced()) {
              this.addHeaderMessage("You are silenced");
            }
            else {
              this.units.get(0).cast(3, this, this.hovered_object, true);
            }
          }
          break;
        case 'f':
        case 'F':
          if (this.units.containsKey(0) && !global.holding_ctrl && this.in_control) {
            if (this.units.get(0).abilities.size() < 5 || this.units.get(0).abilities.get(4) == null) {
              break;
            }
            else if (this.units.get(0).silenced()) {
              this.addHeaderMessage("You are silenced");
            }
            else {
              this.units.get(0).cast(4, this, this.hovered_object, true);
            }
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
        file.println("terrain: " + i + ", " + j + ": " + this.mapSquare(i, j).terrain_id +
          ", " + this.mapSquare(i, j).base_elevation + ", " + this.mapSquare(i, j).explored);
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
              if (object_queue.peek() != ReadFileObject.UNIT && object_queue.peek() != ReadFileObject.HERO) {
                global.errorMessage("ERROR: Trying to end a status effect inside a " + object_queue.peek().name + ".");
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
              if (object_queue.peek() != ReadFileObject.UNIT && object_queue.peek() != ReadFileObject.HERO) {
                global.errorMessage("ERROR: Trying to end an ability inside a " + object_queue.peek().name + ".");
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
