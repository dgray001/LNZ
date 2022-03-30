enum MapEditorPage {
  MAPS, LEVELS, TERRAIN, FEATURES, UNITS, ITEMS, TESTMAP, OPENING_MAPEDITOR,
  CREATING_MAP, OPENING_TESTMAP, OPENING_TESTLEVEL, LEVEL_INFO, LEVEL_MAPS,
  LINKERS, TRIGGERS, TRIGGER_EDITOR, CONDITION_EDITOR, EFFECT_EDITOR, TESTLEVEL;
}


enum RightPanelElementLocation {
  BOTTOM, TOP, WHOLE;
}


class MapEditorInterface extends InterfaceLNZ {

  abstract class MapEditorButton extends RectangleButton {
    MapEditorButton() {
      super(0, 0.94 * height, 0, height - Constants.mapEditor_buttonGapSize);
      this.raised_border = true;
      this.roundness = 0;
      this.setColors(color(170), color(222, 184, 135), color(244, 164, 96), color(205, 133, 63), color(0));
      this.show_message = true;
    }
    void hover() {
      global.sounds.trigger_interface("interfaces/buttonOn2");
    }
    void dehover() {
      this.clicked = false;
    }
    void click() {
      global.sounds.trigger_interface("interfaces/buttonClick1");
    }
  }

  class MapEditorButton1 extends MapEditorButton {
    MapEditorButton1() {
      super();
      this.message = "Toggle\nDisplay";
    }
    void release() {
      MapEditorInterface.this.buttonClick1();
    }
  }

  class MapEditorButton2 extends MapEditorButton {
    MapEditorButton2() {
      super();
      this.message = "";
    }
    void release() {
      this.stayDehovered();
      MapEditorInterface.this.buttonClick2();
    }
  }

  class MapEditorButton3 extends MapEditorButton {
    MapEditorButton3() {
      super();
      this.message = "";
    }
    void release() {
      this.stayDehovered();
      MapEditorInterface.this.buttonClick3();
    }
  }

  class MapEditorButton4 extends MapEditorButton {
    MapEditorButton4() {
      super();
      this.message = "Main\nMenu";
    }
    void release() {
      this.stayDehovered();
      MapEditorInterface.this.buttonClick4();
    }
  }

  class MapEditorButton5 extends MapEditorButton {
    MapEditorButton5() {
      super();
      this.setLocation(0, 0.9 * height + Constants.mapEditor_buttonGapSize,
        0, 0.94 * height - Constants.mapEditor_buttonGapSize);
      this.message = "Help";
    }
    void release() {
      this.stayDehovered();
      MapEditorInterface.this.buttonClick5();
    }
  }


  class MapEditorListTextBox extends ListTextBox {
    class RightClickListTextBox extends MaxListTextBox {
      RightClickListTextBox(float mX, float mY, MapEditorPage page) {
        super(mX - Constants.mapEditor_rightClickBoxWidth, mY, mX, mY + Constants.mapEditor_rightClickBoxMaxHeight);
        switch(page) {
          case MAPS:
            this.setText("Open Map");
            this.addLine("Rename Map");
            this.addLine("Test Map");
            this.addLine("Delete Map");
            break;
          case LEVELS:
            this.setText("Open Level");
            this.addLine("Rename Level");
            this.addLine("Test Level");
            this.addLine("Delete Level");
            break;
        }
        this.highlight_color = color(1, 0);
        this.hover_color = color(200, 150, 140, 100);
      }

      void click() {
        MapEditorListTextBox.this.clickOption(this.line_clicked);
      }

      void doubleclick() {}
    }

    class RenameInputBox extends InputBox {
      RenameInputBox(int line_index) {
        super(MapEditorListTextBox.this.xi + 1, 0, MapEditorListTextBox.this.xf - 1, 0);
        this.setText(MapEditorListTextBox.this.text_lines_ref.get(line_index));
        this.hint_text = "Enter a filename";
        float currY = MapEditorListTextBox.this.yi + 1;
        if (MapEditorListTextBox.this.text_title_ref != null) {
          textSize(MapEditorListTextBox.this.title_size);
          currY += textAscent() + textDescent() + 2;
        }
        textSize(MapEditorListTextBox.this.text_size);
        float text_height = textAscent() + textDescent();
        float input_yi = currY + (line_index - floor(MapEditorListTextBox.this.
          scrollbar.value)) * (text_height + MapEditorListTextBox.this.text_leading);
        this.setYLocation(input_yi, input_yi + text_height);
        this.typing = true;
        this.location_cursor = this.text.length();
        this.location_display = this.text.length();
        this.updateDisplayText();
      }
    }

    protected boolean active = false;
    protected RightClickListTextBox rightClickMenu;
    protected RenameInputBox renameInputBox;

    MapEditorListTextBox() {
      super(width, Constants.mapEditor_listBoxGap, width, 0.9 * height - Constants.mapEditor_listBoxGap);
      this.color_background = color(250, 190, 140);
      this.color_header = color(220, 180, 130);
    }

    @Override
    void update(int millis) {
      super.update(millis);
      if (this.rightClickMenu != null) {
        this.rightClickMenu.update(millis);
      }
      else if (this.renameInputBox != null) {
        this.renameInputBox.update(millis);
      }
    }

    @Override
    void mouseMove(float mX, float mY) {
      if (this.rightClickMenu != null) {
        this.rightClickMenu.mouseMove(mX, mY);
      }
      else if (this.renameInputBox != null) {
        this.renameInputBox.mouseMove(mX, mY);
      }
      else {
        super.mouseMove(mX, mY);
      }
    }

    @Override
    void mousePress() {
      if (this.rightClickMenu != null) {
        if (this.rightClickMenu.hovered) {
          this.rightClickMenu.mousePress();
        }
        else {
          this.rightClickMenu = null;
        }
      }
      else if (this.renameInputBox != null) {
        if (this.renameInputBox.hovered) {
          this.renameInputBox.mousePress();
        }
        else {
          this.removeRenameInputBox();
        }
      }
      else {
        super.mousePress();
      }
    }

    @Override
    void mouseRelease(float mX, float mY) {
      if (this.rightClickMenu != null) {
        this.rightClickMenu.mouseRelease(mX, mY);
      }
      else if (this.renameInputBox != null) {
        this.renameInputBox.mouseRelease(mX, mY);
      }
      else {
        super.mouseRelease(mX, mY);
      }
    }

    @Override
    void scroll(int amount) {
      if (this.rightClickMenu != null) {
        this.rightClickMenu.scroll(amount);
      }
      else {
        super.scroll(amount);
      }
    }

    void keyPress() {
      if (this.renameInputBox != null) {
        this.renameInputBox.keyPress();
        if (key != CODED && (key == ENTER || key == RETURN)) {
          this.removeRenameInputBox();
        }
      }
    }

    void keyRelease() {
      if (this.renameInputBox != null) {
        this.renameInputBox.keyRelease();
      }
    }

    void removeRenameInputBox() {
      if (this.renameInputBox == null) {
        return;
      }
      if (this.line_clicked < 0 || this.line_clicked >= this.text_lines_ref.size()) {
        return;
      }
      switch(MapEditorInterface.this.page) {
        case MAPS:
          MapEditorInterface.this.renameMapFile(this.highlightedLine(), this.renameInputBox.text);
          break;
        case LEVELS:
          MapEditorInterface.this.renameLevelFolder(this.highlightedLine(), this.renameInputBox.text);
          break;
        default:
          break;
      }
      this.renameInputBox = null;
      this.refresh();
    }

    void clickOption(int option) {
      switch(MapEditorInterface.this.page) {
        case MAPS:
          switch(option) {
            case 0:
              MapEditorInterface.this.openMapEditor(this.highlightedLine());
              break;
            case 1:
              if (this.line_clicked < 0 || this.line_clicked >= this.text_lines_ref.size()) {
                break;
              }
              this.renameInputBox = new RenameInputBox(this.line_clicked);
              break;
            case 2:
              MapEditorInterface.this.testMap();
              break;
            case 3:
              MapEditorInterface.this.deleteMap();
              break;
            default:
              global.errorMessage("ERROR: Option index " + option + " not recognized.");
              break;
          }
          break;
        case LEVELS:
          switch(option) {
            case 0:
              MapEditorInterface.this.openLevelEditor(this.highlightedLine());
              break;
            case 1:
              if (this.line_clicked < 0 || this.line_clicked >= this.text_lines_ref.size()) {
                break;
              }
              this.renameInputBox = new RenameInputBox(this.line_clicked);
              break;
            case 2:
              MapEditorInterface.this.testLevel();
              break;
            case 3:
              MapEditorInterface.this.deleteLevel();
              break;
            default:
              global.errorMessage("ERROR: Option index " + option + " not recognized.");
              break;
          }
          break;
        default:
          break;
      }
      this.rightClickMenu = null;
    }

    void setPosition(RightPanelElementLocation position) {
      switch(position) {
        case TOP:
          this.setYLocation(Constants.mapEditor_listBoxGap, 0.45 * height - Constants.mapEditor_listBoxGap);
          break;
        case BOTTOM:
          this.setYLocation(0.45 * height + Constants.mapEditor_listBoxGap, 0.9 * height - Constants.mapEditor_listBoxGap);
          break;
        case WHOLE:
          this.setYLocation(Constants.mapEditor_listBoxGap, 0.9 * height - Constants.mapEditor_listBoxGap);
          break;
      }
    }

    void setList(MapEditorPage page) {
      this.clearText();
      this.line_hovered = -1;
      this.line_clicked = -1;
      this.active = true;
      switch(page) {
        case MAPS:
          this.setTitleText("Maps");
          if (folderExists("data/maps")) {
            boolean first = true;
            for (Path p : listFiles("data/maps/")) {
              String mapName = split(p.getFileName().toString(), '.')[0];
              if (first) {
                this.setText(mapName);
                first = false;
              }
              else {
                this.addLine(mapName);
              }
            }
          }
          else {
            mkdir("data/maps");
          }
          break;
        case LEVELS:
          this.setTitleText("Levels");
          if (folderExists("data/levels")) {
            boolean first = true;
            for (Path p : listFolders("data/levels")) {
              String levelName = p.getFileName().toString();
              if (first) {
                this.setText(levelName);
                first = false;
              }
              else {
                this.addLine(levelName);
              }
            }
          }
          else {
            mkdir("data/levels");
          }
          break;
        case TERRAIN:
          this.setTitleText("Terrain");
          boolean first_terrain = true;
          if (fileExists("data/terrains.lnz")) {
            for (String line : loadStrings(sketchPath("data/terrains.lnz"))) {
              if (first_terrain) {
                first_terrain = false;
                this.setText(line);
              }
              else {
                this.addLine(line);
              }
            }
          }
          break;
        case FEATURES:
          this.setTitleText("Features");
          boolean first_feature = true;
          if (fileExists("data/features.lnz")) {
            for (String line : loadStrings(sketchPath("data/features.lnz"))) {
              if (first_feature) {
                first_feature = false;
                this.setText(line);
              }
              else {
                this.addLine(line);
              }
            }
          }
          break;
        case UNITS:
          this.setTitleText("Units");
          boolean first_unit = true;
          if (fileExists("data/units.lnz")) {
            for (String line : loadStrings(sketchPath("data/units.lnz"))) {
              if (first_unit) {
                first_unit = false;
                this.setText(line);
              }
              else {
                this.addLine(line);
              }
            }
          }
          break;
        case ITEMS:
          this.setTitleText("Items");
          boolean first_item = true;
          if (fileExists("data/items.lnz")) {
            for (String line : loadStrings(sketchPath("data/items.lnz"))) {
              if (first_item) {
                first_item = false;
                this.setText(line);
              }
              else {
                this.addLine(line);
              }
            }
          }
          break;
        case LEVEL_MAPS:
          this.setTitleText("Saved Maps");
          if (folderExists("data/maps")) {
            boolean first = true;
            for (Path p : listFiles("data/maps/")) {
              String mapName = split(p.getFileName().toString(), '.')[0];
              if (first) {
                this.setText(mapName);
                first = false;
              }
              else {
                this.addLine(mapName);
              }
            }
          }
          else {
            mkdir("data/maps");
          }
          break;
        default:
          this.active = false;
          break;
      }
    }

    void refresh() {
      this.setList(MapEditorInterface.this.page);
    }

    void click() {
      switch(MapEditorInterface.this.page) {
        case MAPS:
          if (mouseButton == RIGHT) {
            this.rightClickMenu = new RightClickListTextBox(mouseX, mouseY, MapEditorInterface.this.page);
          }
          break;
        case LEVELS:
          if (mouseButton == RIGHT) {
            this.rightClickMenu = new RightClickListTextBox(mouseX, mouseY, MapEditorInterface.this.page);
          }
          break;
        case TERRAIN:
          break;
        case FEATURES:
          break;
        case UNITS:
          break;
        case ITEMS:
          break;
        case LEVEL_MAPS:
          break;
        default:
          global.errorMessage("ERROR: MapEditorPage " + page + " not found.");
          break;
      }
    }

    void doubleclick() {
      switch(MapEditorInterface.this.page) {
        case MAPS:
          if (mouseButton == LEFT) {
            MapEditorInterface.this.openMapEditor(this.highlightedLine());
          }
          break;
        case LEVELS:
          if (mouseButton == LEFT) {
            MapEditorInterface.this.openLevelEditor(this.highlightedLine());
          }
          break;
        case TERRAIN:
          if (mouseButton == LEFT) {
            MapEditorInterface.this.dropTerrain(this.highlightedLine());
          }
          break;
        case FEATURES:
          if (mouseButton == LEFT) {
            MapEditorInterface.this.dropFeature(this.highlightedLine());
          }
          break;
        case UNITS:
          if (mouseButton == LEFT) {
            MapEditorInterface.this.dropUnit(this.highlightedLine());
          }
          break;
        case ITEMS:
          if (mouseButton == LEFT) {
            MapEditorInterface.this.dropItem(this.highlightedLine());
          }
          break;
        case LEVEL_MAPS:
          if (mouseButton == LEFT) {
            MapEditorInterface.this.addMapToLevel(this.highlightedLine());
          }
          break;
        default:
          global.errorMessage("ERROR: MapEditorPage " + page + " not found.");
          break;
      }
    }
  }


  class LevelEditorListTextBox extends ListTextBox {
    protected boolean active = false;

    LevelEditorListTextBox() {
      super(width, Constants.mapEditor_listBoxGap, width, 0.9 * height - Constants.mapEditor_listBoxGap);
      this.color_background = color(250, 190, 140);
      this.color_header = color(220, 180, 130);
    }

    void setPosition(RightPanelElementLocation position) {
      switch(position) {
        case TOP:
          this.setYLocation(Constants.mapEditor_listBoxGap, 0.45 * height - Constants.mapEditor_listBoxGap);
          break;
        case BOTTOM:
          this.setYLocation(0.45 * height + Constants.mapEditor_listBoxGap, 0.9 * height - Constants.mapEditor_listBoxGap);
          break;
        case WHOLE:
          this.setYLocation(Constants.mapEditor_listBoxGap, 0.9 * height - Constants.mapEditor_listBoxGap);
          break;
      }
    }

    void setList(MapEditorPage page) {
      this.clearText();
      this.line_hovered = -1;
      this.line_clicked = -1;
      this.active = true;
      switch(page) {
        case LEVEL_INFO:
        case LEVEL_MAPS:
          this.setTitleText("Maps");
          if (MapEditorInterface.this.curr_level != null) {
            boolean first = true;
            for (String mapName : MapEditorInterface.this.curr_level.mapNames) {
              if (first) {
                this.setText(mapName);
                first = false;
              }
              else {
                this.addLine(mapName);
              }
            }
          }
          break;
        case LINKERS:
          this.setTitleText("Linkers");
          if (MapEditorInterface.this.curr_level != null) {
            boolean first = true;
            for (Linker linker : MapEditorInterface.this.curr_level.linkers) {
              if (first) {
                this.setText(linker.rect1.fileString());
                this.addLine(linker.rect2.fileString());
                first = false;
              }
              else {
                this.addLine("");
                this.addLine(linker.rect1.fileString());
                this.addLine(linker.rect2.fileString());
              }
            }
          }
          break;
        case TRIGGERS:
          this.setTitleText("Triggers");
          if (MapEditorInterface.this.curr_level != null) {
            boolean first = true;
            for (Map.Entry<Integer, Trigger> entry : MapEditorInterface.this.curr_level.triggers.entrySet()) {
              Trigger trigger = entry.getValue();
              if (first) {
                this.setText(trigger.triggerName);
                first = false;
              }
              else {
                this.addLine(trigger.triggerName);
              }
            }
          }
          break;
        case TRIGGER_EDITOR:
          break;
        case CONDITION_EDITOR:
          break;
        case EFFECT_EDITOR:
          break;
        default:
          this.active = false;
          break;
      }
    }

    void refresh() {
      this.setList(MapEditorInterface.this.page);
    }

    void keyPress() {
      if (key == CODED) {
      }
      else {
        switch(key) {
          case 'a':
            switch(MapEditorInterface.this.page) {
              default:
                break;
            }
            break;
          case 'd':
            switch(MapEditorInterface.this.page) {
              case LEVEL_MAPS:
                MapEditorInterface.this.removeMapFromLevel(this.highlightedLine());
                break;
              default:
                break;
            }
            break;
        }
      }
    }

    void keyRelease() {
    }

    void click() {
      switch(page) {
        case LEVEL_INFO:
          break;
        case LEVEL_MAPS:
          break;
        case LINKERS:
          break;
        case TRIGGERS:
          break;
        case TRIGGER_EDITOR:
          break;
        case CONDITION_EDITOR:
          break;
        case EFFECT_EDITOR:
          break;
        default:
          break;
      }
    }
    void doubleclick() {
      switch(page) {
        case LEVEL_INFO:
        case LEVEL_MAPS:
          if (MapEditorInterface.this.curr_level != null && this.highlightedLine() != null) {
            if (this.highlightedLine().equals(MapEditorInterface.this.curr_level.currMapName)) {
              MapEditorInterface.this.curr_level.closeMap();
            }
            else {
              MapEditorInterface.this.curr_level.openMap(this.highlightedLine());
            }
          }
          break;
        case LINKERS:
          // open linker form ?
          break;
        case TRIGGERS:
          // open trigger editor
          break;
        case TRIGGER_EDITOR:
          break;
        case CONDITION_EDITOR:
          break;
        case EFFECT_EDITOR:
          break;
        default:
          break;
      }
    }
  }


  class NewMapForm extends FormLNZ {
    NewMapForm() {
      super(0.5 * (width - Constants.mapEditor_formWidth), 0.5 * (height - Constants.mapEditor_formHeight),
        0.5 * (width + Constants.mapEditor_formWidth), 0.5 * (height + Constants.mapEditor_formHeight));
      this.setTitleText("New Map");
      this.setTitleSize(18);
      this.color_background = color(180, 250, 180);
      this.color_header = color(30, 170, 30);
      this.setFieldCushion(0);

      MessageFormField error = new MessageFormField("");
      error.text_color = color(150, 20, 20);
      error.setTextSize(16);
      SubmitCancelFormField submit = new SubmitCancelFormField("  Ok  ", "Cancel");
      submit.button1.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      submit.button2.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));

      this.addField(new SpacerFormField(20));
      this.addField(new StringFormField("", "Map Name"));
      this.addField(error);
      this.addField(new SpacerFormField(10));
      this.addField(new IntegerFormField("", "Map Width", 1, 3000));
      this.addField(new SpacerFormField(20));
      this.addField(new IntegerFormField("", "Map Height", 1, 3000));
      this.addField(new SpacerFormField(20));
      this.addField(submit);
    }

    void submit() {
      if (fileExists("data/maps/" + this.fields.get(1).getValue() + ".map.lnz")) {
        this.fields.get(2).setValue("A map with that name already exists");
        return;
      }
      MapEditorInterface.this.navigate(MapEditorPage.CREATING_MAP);
      MapEditorInterface.this.create_map_thread = new NewMapThread(this.fields.get(1).getValue(),
        toInt(this.fields.get(4).getValue()), toInt(this.fields.get(6).getValue()));
      MapEditorInterface.this.create_map_thread.start();
      this.canceled = true;
    }
  }


  class NewLevelForm extends FormLNZ {
    NewLevelForm() {
      super(0.5 * (width - Constants.mapEditor_formWidth), 0.5 * (height - Constants.mapEditor_formHeight),
        0.5 * (width + Constants.mapEditor_formWidth), 0.5 * (height + Constants.mapEditor_formHeight));
      this.setTitleText("New Level");
      this.setTitleSize(18);
      this.color_background = color(180, 250, 180);
      this.color_header = color(30, 170, 30);
      this.setFieldCushion(0);

      MessageFormField error = new MessageFormField("");
      error.text_color = color(150, 20, 20);
      error.setTextSize(16);
      SubmitCancelFormField submit = new SubmitCancelFormField("  Ok  ", "Cancel");
      submit.button1.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      submit.button2.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));

      this.addField(new SpacerFormField(20));
      this.addField(new StringFormField("", "Level Name"));
      this.addField(error);
      this.addField(new SpacerFormField(20));
      this.addField(submit);
    }

    void submit() {
      if (folderExists("data/levels/" + this.fields.get(1).getValue())) {
        this.fields.get(2).setValue("A level with that name already exists");
        return;
      }
      MapEditorInterface.this.newLevel(this.fields.get(1).getValue());
      this.canceled = true;
    }
  }


  class MessageForm extends FormLNZ {
    MessageForm(String title, String message) {
      super(0.5 * (width - Constants.mapEditor_formWidth_small), 0.5 * (height - Constants.mapEditor_formHeight_small),
        0.5 * (width + Constants.mapEditor_formWidth_small), 0.5 * (height + Constants.mapEditor_formHeight_small));
      this.setTitleText(title);
      this.setTitleSize(18);
      this.color_background = color(180, 250, 180);
      this.color_header = color(30, 170, 30);

      SubmitFormField submit = new SubmitFormField("  Ok  ");
      submit.button.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      this.addField(new SpacerFormField(0));
      this.addField(new TextBoxFormField(message, 120));
      this.addField(submit);
    }
    void submit() {
      this.canceled = true;
    }
  }


  abstract class ConfirmForm extends FormLNZ {
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
    }
  }


  class DeleteMapForm extends ConfirmForm {
    private String mapName;
    DeleteMapForm(String mapName) {
      super("Delete Map", "Are you sure you want to delete this map?\n" + mapName);
      this.mapName = mapName;
    }
    void submit() {
      deleteFile("data/maps/" + this.mapName + ".map.lnz");
      this.canceled = true;
      MapEditorInterface.this.listBox1.refresh();
    }
  }


  class DeleteLevelForm extends ConfirmForm {
    private String levelName;
    DeleteLevelForm(String levelName) {
      super("Delete Level", "Are you sure you want to delete this level?\n" + levelName);
      this.levelName = levelName;
    }
    void submit() {
      deleteFolder("data/levels/" + this.levelName);
      this.canceled = true;
      MapEditorInterface.this.listBox1.refresh();
    }
  }


  abstract class LevelEditorForm extends Form {
    LevelEditorForm() {
      super(0, 0, 0, 0);
    }

    void cancel() {
    }

    void submit() {
    }

    void buttonPress(int i) {
    }
  }


  class LevelInfoForm extends LevelEditorForm {}


  class TriggerEditorForm extends LevelEditorForm {}


  class ConditionEditorForm extends LevelEditorForm {}


  class EffectEditorForm extends LevelEditorForm {}


  class NewMapThread extends Thread {
    private GameMapEditor map_creating;
    private String curr_status = "";
    private String mapName = "";
    private int mapWidth = 1;
    private int mapHeight = 1;

    NewMapThread(String mapName, int mapWidth, int mapHeight) {
      this.mapName = mapName;
      this.mapWidth = mapWidth;
      this.mapHeight = mapHeight;
    }

    @Override
    void run () {
      this.curr_status = "Creating Map";
      this.map_creating = new GameMapEditor();
      this.map_creating.mapName = this.mapName;
      this.map_creating.mapWidth = this.mapWidth;
      this.map_creating.mapHeight = this.mapHeight;
      this.map_creating.initializeSquares();
      if (this.map_creating.nullify) {
        this.curr_status += " -> " + global.last_error_message();
        delay(2500);
        return;
      }
      this.curr_status += "\nSaving Map";
      this.map_creating.save(sketchPath("data/maps/"));
      if (this.map_creating.nullify) {
        this.curr_status += " -> " + global.last_error_message();
        delay(2500);
        return;
      }
      this.curr_status += "\nGenerating Images";
      global.images.loadMapGifs();
      this.map_creating.initializeTerrain();
      if (this.map_creating.nullify) {
        this.curr_status += " -> " + global.last_error_message();
        delay(2500);
        return;
      }
    }
  }


  class OpenMapEditorThread extends Thread {
    private String mapName;
    private String folderPath;
    private GameMapEditor map_opening;
    private String curr_status = "";

    OpenMapEditorThread(String mapName, String folderPath) {
      super("OpenMapEditorThread");
      this.mapName = mapName;
      this.folderPath = folderPath;
    }

    @Override
    void run() {
      this.curr_status = "Opening File";
      this.map_opening = new GameMapEditor();
      this.map_opening.mapName = this.mapName;
      String[] lines = this.map_opening.open1File(this.folderPath);
      if (this.map_opening.nullify) {
        this.curr_status += " -> " + global.last_error_message();
        delay(2500);
        return;
      }
      this.curr_status += "\nSetting Data";
      this.map_opening.open2Data(lines);
      if (this.map_opening.nullify) {
        this.curr_status += " -> " + global.last_error_message();
        delay(2500);
        return;
      }
      this.curr_status += "\nGenerating Images";
      global.images.loadMapGifs();
      this.map_opening.initializeTerrain();
      if (this.map_opening.nullify) {
        this.curr_status += " -> " + global.last_error_message();
        delay(2500);
        return;
      }
    }
  }


  class OpenTestMapThread extends Thread {
    private String mapName;
    private Level level_opening;
    private String curr_status = "";

    OpenTestMapThread(String mapName) {
      super("OpenTestMapThread");
      this.mapName = mapName;
    }

    @Override
    void run() {
      this.curr_status = "Opening File";
      GameMap map_testing = new GameMap();
      map_testing.mapName = this.mapName;
      String[] lines = map_testing.open1File("data/maps/");
      if (map_testing.nullify) {
        this.curr_status += " -> " + global.last_error_message();
        delay(2500);
        return;
      }
      this.curr_status += "\nSetting Data";
      map_testing.open2Data(lines);
      if (map_testing.nullify) {
        this.curr_status += " -> " + global.last_error_message();
        delay(2500);
        return;
      }
      this.curr_status += "\nGenerating Images";
      global.images.loadMapGifs();
      map_testing.initializeTerrain();
      if (map_testing.nullify) {
        this.curr_status += " -> " + global.last_error_message();
        delay(2500);
        return;
      }
      this.level_opening = new Level(map_testing);
    }
  }


  class OpenTestLevelThread extends Thread {
    private String levelName;
    private Level level_opening;
    private String curr_status = "";

    OpenTestLevelThread(String levelName) {
      super("OpenTestLevelThread");
      this.levelName = levelName;
    }

    @Override
    void run() {
      this.curr_status = "Opening File";
      this.level_opening = new Level("data/levels", this.levelName);
      if (this.level_opening.nullify) {
        this.curr_status += " -> " + global.last_error_message();
        delay(2500);
        return;
      }
      this.curr_status += "\nCopying Data";
      mkdir("data/profiles/" + global.profile.display_name.toLowerCase() + "/leveltester");
      copyFolder("data/levels/" + this.levelName, "data/profiles/" + global.
        profile.display_name.toLowerCase() + "/leveltester/" + this.levelName);
      this.level_opening.folderPath = "data/profiles/" + global.profile.display_name.toLowerCase() + "/leveltester";
      this.level_opening.save();
      if (this.level_opening.nullify) {
        this.curr_status += " -> " + global.last_error_message();
        delay(2500);
        return;
      }
      this.curr_status += "\nGenerating Images";
      global.images.loadMapGifs();
      this.level_opening.setPlayer(new Hero(HeroCode.BEN));
      if (this.level_opening.nullify) {
        this.curr_status += " -> " + global.last_error_message();
        delay(2500);
        return;
      }
    }
  }


  private MapEditorPage page;

  private MapEditorButton[] buttons = new MapEditorButton[5];
  private Panel leftPanel = new Panel(LEFT, Constants.mapEditor_panelMinWidth,
    Constants.mapEditor_panelMaxWidth, Constants.mapEditor_panelStartWidth);
  private Panel rightPanel = new Panel(RIGHT, Constants.mapEditor_panelMinWidth,
    Constants.mapEditor_panelMaxWidth, Constants.mapEditor_panelStartWidth);
  private MapEditorListTextBox listBox1 = new MapEditorListTextBox();
  private LevelEditorListTextBox listBox2 = new LevelEditorListTextBox();
  private LevelEditorForm levelForm;

  private GameMapEditor curr_map;
  private Level curr_level;

  private OpenMapEditorThread open_mapEditor_thread;
  private NewMapThread create_map_thread;
  private OpenTestMapThread open_testMap_thread;
  private OpenTestLevelThread open_testLevel_thread;

  MapEditorInterface() {
    this.buttons[0] = new MapEditorButton1();
    this.buttons[1] = new MapEditorButton2();
    this.buttons[2] = new MapEditorButton3();
    this.buttons[3] = new MapEditorButton4();
    this.buttons[4] = new MapEditorButton5();
    this.leftPanel.addIcon(global.images.getImage("icons/triangle.png"));
    this.rightPanel.addIcon(global.images.getImage("icons/triangle.png"));
    this.leftPanel.color_background = global.color_panelBackground;
    this.rightPanel.color_background = global.color_panelBackground;
    this.navigate(MapEditorPage.MAPS);
    this.resizeButtons();
  }


  void navigate(MapEditorPage page) {
    this.page = page;
    this.listBox1.setList(this.page);
    this.listBox2.setList(this.page);
    switch(this.page) {
      case MAPS:
        this.buttons[0].message = "Toggle\nDisplay";
        this.buttons[1].message = "New\nMap";
        this.buttons[2].message = "Test\nMap";
        this.listBox1.setPosition(RightPanelElementLocation.WHOLE);
        break;
      case LEVELS:
        this.buttons[0].message = "Toggle\nDisplay";
        this.buttons[1].message = "New\nLevel";
        this.buttons[2].message = "Test\nLevel";
        this.listBox1.setPosition(RightPanelElementLocation.WHOLE);
        break;
      case TERRAIN:
      case FEATURES:
      case UNITS:
      case ITEMS:
        this.buttons[0].message = "Toggle\nDisplay";
        this.buttons[1].message = "Save\nMap";
        this.buttons[2].message = "Cancel\nMap";
        this.listBox1.setPosition(RightPanelElementLocation.WHOLE);
        break;
      case TESTMAP:
        this.buttons[0].message = "";
        this.buttons[1].message = "Save\nMap";
        this.buttons[2].message = "Cancel\nMap";
        break;
      case OPENING_MAPEDITOR:
      case CREATING_MAP:
      case OPENING_TESTMAP:
      case OPENING_TESTLEVEL:
        this.buttons[0].message = "";
        this.buttons[1].message = "";
        this.buttons[2].message = "";
        break;
      case LEVEL_INFO:
        this.buttons[0].message = "Toggle\nDisplay";
        this.buttons[1].message = "Save\nLevel";
        this.buttons[2].message = "Cancel\nLevel";
        // levelForm = new LevelInfoForm(); // TOP
        this.listBox2.setPosition(RightPanelElementLocation.BOTTOM);
        break;
      case LEVEL_MAPS:
        this.buttons[0].message = "Toggle\nDisplay";
        this.buttons[1].message = "Save\nLevel";
        this.buttons[2].message = "Cancel\nLevel";
        this.listBox1.setPosition(RightPanelElementLocation.TOP);
        this.listBox2.setPosition(RightPanelElementLocation.BOTTOM);
        break;
      case LINKERS:
        this.buttons[0].message = "Toggle\nDisplay";
        this.buttons[1].message = "Save\nLevel";
        this.buttons[2].message = "Cancel\nLevel";
        this.listBox2.setPosition(RightPanelElementLocation.WHOLE);
        break;
      case TRIGGERS:
        this.buttons[0].message = "Toggle\nDisplay";
        this.buttons[1].message = "Save\nLevel";
        this.buttons[2].message = "Cancel\nLevel";
        this.listBox2.setPosition(RightPanelElementLocation.WHOLE);
        break;
      case TRIGGER_EDITOR:
        this.buttons[0].message = "";
        this.buttons[1].message = "";
        this.buttons[2].message = "";
        // levelForm = new TriggerEditorForm(); // TOP
        this.listBox2.setPosition(RightPanelElementLocation.BOTTOM);
        break;
      case CONDITION_EDITOR:
        this.buttons[0].message = "";
        this.buttons[1].message = "";
        this.buttons[2].message = "";
        // levelForm = new ConditionEditorForm(); // TOP
        this.listBox2.setPosition(RightPanelElementLocation.BOTTOM);
        break;
      case EFFECT_EDITOR:
        this.buttons[0].message = "";
        this.buttons[1].message = "";
        this.buttons[2].message = "";
        // levelForm = new EffectEditorForm(); // TOP
        this.listBox2.setPosition(RightPanelElementLocation.BOTTOM);
        break;
      case TESTLEVEL:
        this.buttons[0].message = "";
        this.buttons[1].message = "Save\nLevel";
        this.buttons[2].message = "Cancel\nLevel";
        break;
      default:
        global.errorMessage("ERROR: MapEditorPage " + this.page + " not found.");
        break;
    }
  }

  void resizeButtons() {
    float buttonSize = (this.rightPanel.size_curr - 5 * Constants.mapEditor_buttonGapSize) / 4.0;
    float xi = width - this.rightPanel.size_curr + Constants.mapEditor_buttonGapSize;
    this.buttons[0].setXLocation(xi, xi + buttonSize);
    xi += buttonSize + Constants.mapEditor_buttonGapSize;
    this.buttons[1].setXLocation(xi, xi + buttonSize);
    xi += buttonSize + Constants.mapEditor_buttonGapSize;
    this.buttons[2].setXLocation(xi, xi + buttonSize);
    xi += buttonSize + Constants.mapEditor_buttonGapSize;
    this.buttons[3].setXLocation(xi, xi + buttonSize);
    this.buttons[4].setXLocation(xi, xi + buttonSize);
    this.listBox1.setXLocation(width - this.rightPanel.size_curr + Constants.mapEditor_listBoxGap,
      width - Constants.mapEditor_listBoxGap);
    this.listBox2.setXLocation(width - this.rightPanel.size_curr + Constants.mapEditor_listBoxGap,
      width - Constants.mapEditor_listBoxGap);
  }

  void buttonClick1() {
    switch(this.page) {
      case MAPS:
        this.navigate(MapEditorPage.LEVELS);
        break;
      case LEVELS:
        this.navigate(MapEditorPage.MAPS);
        break;
      case TERRAIN:
        this.navigate(MapEditorPage.FEATURES);
        break;
      case FEATURES:
        this.navigate(MapEditorPage.UNITS);
        break;
      case UNITS:
        this.navigate(MapEditorPage.ITEMS);
        break;
      case ITEMS:
        this.navigate(MapEditorPage.TERRAIN);
        break;
      case TESTMAP:
        break;
      case OPENING_MAPEDITOR:
      case CREATING_MAP:
        break;
      case OPENING_TESTMAP:
      case OPENING_TESTLEVEL:
        break;
      case LEVEL_INFO:
        this.navigate(MapEditorPage.LEVEL_MAPS);
        break;
      case LEVEL_MAPS:
        this.navigate(MapEditorPage.LINKERS);
        break;
      case LINKERS:
        this.navigate(MapEditorPage.TRIGGERS);
        break;
      case TRIGGERS:
        this.navigate(MapEditorPage.LEVEL_INFO);
        break;
      case TRIGGER_EDITOR:
      case CONDITION_EDITOR:
      case EFFECT_EDITOR:
        break;
      case TESTLEVEL:
        break;
      default:
        global.errorMessage("ERROR: MapEditorPage " + this.page + " not found.");
        break;
    }
  }

  void buttonClick2() {
    switch(this.page) {
      case MAPS:
        this.form = new NewMapForm();
        break;
      case LEVELS:
        this.form = new NewLevelForm();
        break;
      case TERRAIN:
      case FEATURES:
      case UNITS:
      case ITEMS:
        this.saveMapEditor();
        break;
      case TESTMAP:
        this.saveMapTester();
        break;
      case OPENING_MAPEDITOR:
      case CREATING_MAP:
        break;
      case OPENING_TESTMAP:
      case OPENING_TESTLEVEL:
        break;
      case LEVEL_INFO:
      case LEVEL_MAPS:
      case LINKERS:
      case TRIGGERS:
        this.saveLevelEditor();
        break;
      case TRIGGER_EDITOR:
      case CONDITION_EDITOR:
      case EFFECT_EDITOR:
        break;
      case TESTLEVEL:
        this.saveLevelTester();
        break;
      default:
        global.errorMessage("ERROR: MapEditorPage " + this.page + " not found.");
        break;
    }
  }

  void buttonClick3() {
    switch(this.page) {
      case MAPS:
        this.testMap();
        break;
      case LEVELS:
        this.testLevel();
        break;
      case TERRAIN:
      case FEATURES:
      case UNITS:
      case ITEMS:
        this.closeMapEditor();
        break;
      case TESTMAP:
        this.closeMapTester();
        break;
      case OPENING_MAPEDITOR:
      case CREATING_MAP:
        break;
      case OPENING_TESTMAP:
      case OPENING_TESTLEVEL:
        break;
      case LEVEL_INFO:
      case LEVEL_MAPS:
      case LINKERS:
      case TRIGGERS:
        this.closeLevelEditor();
        break;
      case TRIGGER_EDITOR:
      case CONDITION_EDITOR:
      case EFFECT_EDITOR:
        break;
      case TESTLEVEL:
        this.closeLevelTester();
        break;
      default:
        global.errorMessage("ERROR: MapEditorPage " + this.page + " not found.");
        break;
    }
  }

  void buttonClick4() {
    // confirm form first
    this.curr_map = null;
    this.curr_level = null;
    global.state = ProgramState.ENTERING_MAINMENU;
  }

  void buttonClick5() {
    switch(this.page) {
      case MAPS:
        break;
      case LEVELS:
        break;
      case TERRAIN:
        break;
      case FEATURES:
        break;
      case UNITS:
        break;
      case ITEMS:
        break;
      case TESTMAP:
        break;
      case OPENING_MAPEDITOR:
      case CREATING_MAP:
        break;
      case OPENING_TESTMAP:
      case OPENING_TESTLEVEL:
      case LEVEL_INFO:
      case LEVEL_MAPS:
      case LINKERS:
      case TRIGGERS:
      case TRIGGER_EDITOR:
      case CONDITION_EDITOR:
      case EFFECT_EDITOR:
        break;
      case TESTLEVEL:
        break;
      default:
        global.errorMessage("ERROR: MapEditorPage " + this.page + " not found.");
        break;
    }
  }


  void testMap() {
    String mapName = this.listBox1.highlightedLine();
    if (mapName == null) {
      this.form = new MessageForm("Test Map", "No map selected to test.");
    }
    else {
      this.navigate(MapEditorPage.OPENING_TESTMAP);
      this.open_testMap_thread = new OpenTestMapThread(mapName);
      this.open_testMap_thread.start();
    }
  }

  void deleteMap() {
    String mapName = this.listBox1.highlightedLine();
    if (mapName == null) {
      this.form = new MessageForm("Delete Map", "No map selected to delete.");
    }
    else {
      this.form = new DeleteMapForm(mapName);
    }
  }

  void setCurrMap(GameMapEditor map) {
    this.curr_map = map;
    this.curr_map.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
    this.navigate(MapEditorPage.TERRAIN);
  }

  void renameMapFile(String mapName, String targetName) {
    if (!entryExists("data/maps/" + mapName + ".map.lnz")) {
      global.errorMessage("ERROR: Can't rename map file that doesn't exist.");
      return;
    }
    if (entryExists("data/maps/" + targetName + ".map.lnz")) {
      global.errorMessage("ERROR: Can't rename map file to a name that already exists.");
      return;
    }
    moveFile("data/maps/" + mapName + ".map.lnz", "data/maps/" + targetName + ".map.lnz");
    // rename in map file
  }

  void openMapEditor(String mapName) {
    this.navigate(MapEditorPage.OPENING_MAPEDITOR);
    this.open_mapEditor_thread = new OpenMapEditorThread(mapName, sketchPath("data/maps/"));
    this.open_mapEditor_thread.start();
  }

  void saveMapEditor() {
    if (this.curr_map != null) {
      this.curr_map.save(sketchPath("data/maps/"));
    }
    this.closeMapEditor();
  }

  void closeMapEditor() {
    this.curr_map = null;
    this.navigate(MapEditorPage.MAPS);
  }

  void saveMapTester() {
    if (this.curr_level != null) {
      if (this.curr_level.currMap != null) {
        this.curr_level.currMap.save(sketchPath("data/maps/"));
      }
    }
    this.closeMapTester();
  }

  void closeMapTester() {
    this.curr_level = null;
    this.navigate(MapEditorPage.MAPS);
  }


  void newLevel(String levelName) {
    Level new_level = new LevelEditor();
    new_level.folderPath = "data/levels/";
    new_level.levelName = levelName;
    new_level.save();
    this.curr_level = new_level;
    this.curr_level.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
    this.navigate(MapEditorPage.LEVEL_INFO);
  }

  void testLevel() {
    String levelName = this.listBox1.highlightedLine();
    if (levelName == null) {
      this.form = new MessageForm("Test Level", "No level selected to test.");
      return;
    }
    this.navigate(MapEditorPage.OPENING_TESTLEVEL);
    this.open_testLevel_thread = new OpenTestLevelThread(levelName);
    this.open_testLevel_thread.start();
  }

  void deleteLevel() {
    String levelName = this.listBox1.highlightedLine();
    if (levelName == null) {
      this.form = new MessageForm("Delete Level", "No level selected to delete.");
    }
    else {
      this.form = new DeleteLevelForm(levelName);
    }
  }

  void renameLevelFolder(String levelName, String targetName) {
    if (!entryExists("data/levels/" + levelName)) {
      global.errorMessage("ERROR: Can't rename level that doesn't exist.");
      return;
    }
    if (entryExists("data/levels/" + targetName)) {
      global.errorMessage("ERROR: Can't rename level to a name that already exists.");
      return;
    }
    moveFolder("data/levels/" + levelName, "data/levels/" + targetName);
    // rename in level.lnz file
  }

  void openLevelEditor(String levelName) {
    this.curr_level = new LevelEditor("data/levels", levelName);
    if (this.curr_level.nullify) {
      this.curr_level = null;
      this.navigate(MapEditorPage.LEVELS);
    }
    else {
      this.curr_level.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
      this.navigate(MapEditorPage.LEVEL_INFO);
    }
  }

  void addMapToLevel(String mapName) {
    if (mapName == null) {
      this.form = new MessageForm("Add Map", "No map selected to add to level.");
      return;
    }
    if (!fileExists("data/maps/" + mapName + ".map.lnz")) {
      this.form = new MessageForm("Add Map", "Map is missing from maps folder:\n" + mapName);
      return;
    }
    if (this.curr_level == null) {
      this.form = new MessageForm("Add Map", "No current level to add map to.");
      return;
    }
    if (this.curr_level.hasMap(mapName)) {
      return;
    }
    copyFile("data/maps/" + mapName + ".map.lnz", "data/levels/" +
      this.curr_level.levelName + "/" + mapName + ".map.lnz");
    this.curr_level.mapNames.add(mapName);
    this.curr_level.save(false);
    this.listBox2.refresh();
  }

  void removeMapFromLevel(String mapName) {
    if (mapName == null) {
      this.form = new MessageForm("Remove Map", "No map selected to remove from level.");
      return;
    }
    if (!fileExists("data/levels/" + this.curr_level.levelName + "/" + mapName + ".map.lnz")) {
      this.form = new MessageForm("Remove Map", "Map is missing from level folder:\n" + mapName);
      return;
    }
    if (this.curr_level == null) {
      this.form = new MessageForm("Remove Map", "No current level to remove map from.");
      return;
    }
    if (!this.curr_level.hasMap(mapName)) {
      return;
    }
    deleteFile("data/levels/" + this.curr_level.levelName + "/" + mapName + ".map.lnz");
    this.curr_level.removeMap(mapName);
    this.curr_level.save(false);
    this.listBox2.refresh();
  }

  void saveLevelEditor() {
    if (this.curr_level != null) {
      this.curr_level.save();
    }
    this.closeLevelEditor();
  }

  void closeLevelEditor() {
    this.curr_level = null;
    this.navigate(MapEditorPage.LEVELS);
  }

  void saveLevelTester() {
    if (this.curr_level != null) {
      this.curr_level.folderPath = "data/levels";
      this.curr_level.save();
    }
    this.closeLevelTester();
  }

  void closeLevelTester() {
    this.curr_level = null;
    deleteFolder("data/profiles/" + global.profile.display_name.toLowerCase() + "/leveltester");
    this.navigate(MapEditorPage.LEVELS);
  }


  void dropTerrain(String line) {
    if (this.curr_map == null) {
      return;
    }
    String[] line_split = split(line, ':');
    if (line_split.length < 2) {
      return;
    }
    String terrainID = trim(line_split[1]);
    if (isInt(terrainID)) {
      this.curr_map.dropTerrain(toInt(terrainID));
    }
  }

  void dropFeature(String line) {
    if (this.curr_map == null) {
      return;
    }
    String[] line_split = split(line, ':');
    if (line_split.length < 2) {
      return;
    }
    String featureID = trim(line_split[1]);
    if (isInt(featureID)) {
      this.curr_map.dropping_object = new Feature(toInt(featureID));
      this.curr_map.dropping_terrain = false;
    }
  }

  void dropUnit(String line) {
    if (this.curr_map == null) {
      return;
    }
    String[] line_split = split(line, ':');
    if (line_split.length < 2) {
      return;
    }
    String unitID = trim(line_split[1]);
    if (isInt(unitID)) {
      this.curr_map.dropping_object = new Unit(toInt(unitID));
      this.curr_map.dropping_terrain = false;
    }
  }

  void dropItem(String line) {
    if (this.curr_map == null) {
      return;
    }
    String[] line_split = split(line, ':');
    if (line_split.length < 2) {
      return;
    }
    String itemID = trim(line_split[1]);
    if (isInt(itemID)) {
      this.curr_map.dropping_object = new Item(toInt(itemID));
      this.curr_map.dropping_terrain = false;
    }
  }


  void update(int millis) {
    boolean refreshMapLocation = false;
    switch(this.page) {
      case CREATING_MAP:
        if (this.create_map_thread.isAlive()) {
          fill(global.color_mapBorder);
          noStroke();
          rectMode(CORNERS);
          rect(this.leftPanel.size, 0, width - this.rightPanel.size, height);
          fill(global.color_loadingScreenBackground);
          rect(this.leftPanel.size + Constants.map_borderSize, Constants.map_borderSize,
              width - this.rightPanel.size - Constants.map_borderSize, height - Constants.map_borderSize);
          fill(0);
          textSize(24);
          textAlign(LEFT, TOP);
          text(this.create_map_thread.curr_status + " ...", this.leftPanel.size +
            Constants.map_borderSize + 30, Constants.map_borderSize + 30);
        }
        else {
          if (this.create_map_thread.map_creating.nullify) {
            this.curr_map = null;
            this.navigate(MapEditorPage.MAPS);
          }
          else {
            this.curr_map = this.create_map_thread.map_creating;
            this.curr_map.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
            this.navigate(MapEditorPage.TERRAIN);
          }
        }
        break;
      case OPENING_MAPEDITOR:
        if (this.open_mapEditor_thread.isAlive()) {
          fill(global.color_mapBorder);
          noStroke();
          rectMode(CORNERS);
          rect(this.leftPanel.size, 0, width - this.rightPanel.size, height);
          fill(global.color_loadingScreenBackground);
          rect(this.leftPanel.size + Constants.map_borderSize, Constants.map_borderSize,
              width - this.rightPanel.size - Constants.map_borderSize, height - Constants.map_borderSize);
          fill(0);
          textSize(24);
          textAlign(LEFT, TOP);
          text(this.open_mapEditor_thread.curr_status + " ...", this.leftPanel.size +
            Constants.map_borderSize + 30, Constants.map_borderSize + 30);
        }
        else {
          if (this.open_mapEditor_thread.map_opening.nullify) {
            this.curr_map = null;
            this.navigate(MapEditorPage.MAPS);
          }
          else {
            this.curr_map = this.open_mapEditor_thread.map_opening;
            this.curr_map.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
            this.navigate(MapEditorPage.TERRAIN);
          }
        }
        break;
      case OPENING_TESTMAP:
        if (this.open_testMap_thread.isAlive()) {
          fill(global.color_mapBorder);
          noStroke();
          rectMode(CORNERS);
          rect(this.leftPanel.size, 0, width - this.rightPanel.size, height);
          fill(global.color_loadingScreenBackground);
          rect(this.leftPanel.size + Constants.map_borderSize, Constants.map_borderSize,
              width - this.rightPanel.size - Constants.map_borderSize, height - Constants.map_borderSize);
          fill(0);
          textSize(24);
          textAlign(LEFT, TOP);
          text(this.open_testMap_thread.curr_status + " ...", this.leftPanel.size +
            Constants.map_borderSize + 30, Constants.map_borderSize + 30);
        }
        else {
          if (this.open_testMap_thread.level_opening == null || this.open_testMap_thread.level_opening.nullify) {
            this.curr_level = null;
            this.navigate(MapEditorPage.MAPS);
          }
          else {
            this.curr_level = this.open_testMap_thread.level_opening;
            this.curr_level.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
            this.navigate(MapEditorPage.TESTMAP);
          }
        }
        break;
      case OPENING_TESTLEVEL:
        if (this.open_testLevel_thread.isAlive()) {
          fill(global.color_mapBorder);
          noStroke();
          rectMode(CORNERS);
          rect(this.leftPanel.size, 0, width - this.rightPanel.size, height);
          fill(global.color_loadingScreenBackground);
          rect(this.leftPanel.size + Constants.map_borderSize, Constants.map_borderSize,
              width - this.rightPanel.size - Constants.map_borderSize, height - Constants.map_borderSize);
          fill(0);
          textSize(24);
          textAlign(LEFT, TOP);
          text(this.open_testLevel_thread.curr_status + " ...", this.leftPanel.size +
            Constants.map_borderSize + 30, Constants.map_borderSize + 30);
        }
        else {
          if (this.open_testLevel_thread.level_opening == null || this.open_testLevel_thread.level_opening.nullify) {
            this.curr_level = null;
            this.navigate(MapEditorPage.LEVELS);
          }
          else {
            this.curr_level = this.open_testLevel_thread.level_opening;
            this.curr_level.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
            this.navigate(MapEditorPage.TESTLEVEL);
          }
        }
        break;
      default:
        if (this.curr_level != null) {
          this.curr_level.update(millis);
          if (this.leftPanel.collapsing || this.rightPanel.collapsing) {
            refreshMapLocation = true;
          }
        }
        else if (this.curr_map != null) {
          this.curr_map.update(millis);
          if (this.leftPanel.collapsing || this.rightPanel.collapsing) {
            refreshMapLocation = true;
          }
        }
        else {
          rectMode(CORNERS);
          noStroke();
          fill(color(60));
          rect(this.leftPanel.size, 0, width - this.rightPanel.size, height);
        }
        break;
    }
    this.leftPanel.update(millis);
    this.rightPanel.update(millis);
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (MapEditorButton button : this.buttons) {
        button.update(millis);
      }
      if (this.listBox1.active) {
        this.listBox1.update(millis);
      }
      if (this.listBox2.active) {
        this.listBox2.update(millis);
      }
      if (this.curr_level != null) {
        this.curr_level.drawRightPanel(millis);
      }
    }
    if (this.leftPanel.open && !this.leftPanel.collapsing) {
      if (this.curr_level != null) {
        this.curr_level.drawLeftPanel(millis);
      }
      else if (this.curr_map != null) {
        this.curr_map.drawLeftPanel(millis);
      }
    }
    if (refreshMapLocation) {
      if (this.curr_level != null) {
        this.curr_level.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
      }
      else {
        this.curr_map.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
      }
    }
  }

  void mouseMove(float mX, float mY) {
    boolean refreshMapLocation = false;
    // map / level mouse move
    if (this.curr_level != null) {
      this.curr_level.mouseMove(mX, mY);
      if (this.leftPanel.clicked || this.rightPanel.clicked) {
        refreshMapLocation = true;
      }
    }
    else if (this.curr_map != null) {
      this.curr_map.mouseMove(mX, mY);
      if (this.leftPanel.clicked || this.rightPanel.clicked) {
        refreshMapLocation = true;
      }
    }
    // left panel mouse move
    this.leftPanel.mouseMove(mX, mY);
    if (this.leftPanel.open && !this.leftPanel.collapsing) {
      if (this.curr_level != null) {
        if (this.curr_level.leftPanelElementsHovered()) {
          this.leftPanel.hovered = false;
        }
      }
      else if (this.curr_map != null) {
        if (this.curr_map.leftPanelElementsHovered()) {
          this.leftPanel.hovered = false;
        }
      }
    }
    // right panel mouse move
    this.rightPanel.mouseMove(mX, mY);
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (MapEditorButton button : this.buttons) {
        button.mouseMove(mX, mY);
      }
      if (this.listBox1.active) {
        this.listBox1.mouseMove(mX, mY);
        if (this.listBox1.rightClickMenu != null && this.listBox1.rightClickMenu.hovered) {
          this.rightPanel.hovered = false;
        }
      }
      if (this.listBox2.active) {
        this.listBox2.mouseMove(mX, mY);
      }
    }
    // refresh map location
    if (refreshMapLocation) {
      if (this.curr_level != null) {
        this.curr_level.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
      }
      else {
        this.curr_map.setLocation(this.leftPanel.size, 0, width - this.rightPanel.size, height);
      }
    }
    // cursor icon resolution
    if (this.leftPanel.clicked || this.rightPanel.clicked) {
      this.resizeButtons();
      global.cursor = global.images.getImage("icons/cursor_resizeh_white.png");
    }
    else if (this.leftPanel.hovered || this.rightPanel.hovered) {
      global.cursor = global.images.getImage("icons/cursor_resizeh.png");
    }
    else {
      global.cursor = global.images.getImage("icons/cursor_default.png");
    }
  }

  void mousePress() {
    if (this.curr_level != null) {
      this.curr_level.mousePress();
    }
    else if (this.curr_map != null) {
      this.curr_map.mousePress();
    }
    this.leftPanel.mousePress();
    this.rightPanel.mousePress();
    if (this.leftPanel.clicked || this.rightPanel.clicked) {
      global.cursor = global.images.getImage("icons/cursor_resizeh_white.png");
    }
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (MapEditorButton button : this.buttons) {
        button.mousePress();
      }
      if (this.listBox1.active) {
        this.listBox1.mousePress();
      }
      if (this.listBox2.active) {
        this.listBox2.mousePress();
      }
    }
  }

  void mouseRelease(float mX, float mY) {
    if (this.curr_level != null) {
      this.curr_level.mouseRelease(mX, mY);
    }
    else if (this.curr_map != null) {
      this.curr_map.mouseRelease(mX, mY);
    }
    this.leftPanel.mouseRelease(mX, mY);
    this.rightPanel.mouseRelease(mX, mY);
    if (this.leftPanel.hovered || this.rightPanel.hovered) {
      global.cursor = global.images.getImage("icons/cursor_resizeh.png");
    }
    else {
      global.cursor = global.images.getImage("icons/cursor_default.png");
    }
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (MapEditorButton button : this.buttons) {
        button.mouseRelease(mX, mY);
      }
      if (this.listBox1.active) {
        this.listBox1.mouseRelease(mX, mY);
      }
      if (this.listBox2.active) {
        this.listBox2.mouseRelease(mX, mY);
      }
    }
  }

  void scroll(int amount) {
    if (this.curr_level != null) {
      this.curr_level.scroll(amount);
    }
    else if (this.curr_map != null) {
      this.curr_map.scroll(amount);
    }
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      if (this.listBox1.active) {
        this.listBox1.scroll(amount);
      }
      if (this.listBox2.active) {
        this.listBox2.scroll(amount);
      }
    }
  }

  void keyPress() {
    if (this.curr_level != null) {
      this.curr_level.keyPress();
    }
    else if (this.curr_map != null) {
      this.curr_map.keyPress();
    }
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      if (this.listBox1.active) {
        this.listBox1.keyPress();
      }
      if (this.listBox2.active) {
        this.listBox2.keyPress();
      }
    }
  }

  void keyRelease() {
    if (this.curr_level != null) {
      this.curr_level.keyRelease();
    }
    else if (this.curr_map != null) {
      this.curr_map.keyRelease();
    }
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      if (this.listBox1.active) {
        this.listBox1.keyRelease();
      }
      if (this.listBox2.active) {
        this.listBox2.keyRelease();
      }
    }
  }
}
