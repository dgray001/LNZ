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
