enum MapEditorPage {
  MAPS, LEVELS, TERRAIN, FEATURES, UNITS, ITEMS; // add level pages later
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
    protected boolean active = false;

    MapEditorListTextBox() {
      super(width, Constants.mapEditor_listBoxGap, width, 0.9 * height - Constants.mapEditor_listBoxGap);
      this.color_background = color(250, 190, 140);
      this.color_header = color(220, 180, 130);
    }

    void setList(MapEditorPage page) {
      this.clearText();
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
            for (Path p : listFolders("data/levels/")) {
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
          break;
        case FEATURES:
          this.setTitleText("Features");
          break;
        case UNITS:
          this.setTitleText("Units");
          break;
        case ITEMS:
          this.setTitleText("Items");
          break;
        default:
          println("ERROR: MapEditorPage " + page + " not found.");
          break;
      }
    }

    void refresh() {
      this.setList(MapEditorInterface.this.page);
    }

    void click() {
    }
    void doubleclick() {
    }
  }


  class LevelEditorListTextBox extends ListTextBox {
    LevelEditorListTextBox() {
    }

    void click() {
    }
    void doubleclick() {
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
      this.setFieldCushion(20);

      SubmitCancelFormField submit = new SubmitCancelFormField("  Ok  ", "Cancel");
      submit.button1.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      submit.button2.setColors(color(220), color(190, 240, 190),
        color(140, 190, 140), color(90, 140, 90), color(0));
      MessageFormField error1 = new MessageFormField("");
      error1.text_color = color(150, 20, 20);
      error1.setTextSize(18);
      MessageFormField error2 = new MessageFormField("");
      error2.text_color = color(150, 20, 20);
      error2.setTextSize(18);

      this.addField(new SpacerFormField(0));
      this.addField(new StringFormField("", "Map Name"));
      this.addField(new IntegerFormField("", "Map Width", 1, 3000));
      this.addField(new IntegerFormField("", "Map Height", 1, 3000));
      this.addField(submit);
    }

    void submit() {
      GameMap newMap = new GameMap(this.fields.get(1).getValue(),
        toInt(this.fields.get(2).getValue()), toInt(this.fields.get(3).getValue()));
      newMap.save(sketchPath("data/maps/"));
      this.canceled = true;
      MapEditorInterface.this.listBox1.refresh();
    }
  }


  class NewLevelForm extends FormLNZ {
    NewLevelForm() {
      super(0.5 * (width - Constants.mapEditor_formWidth), 0.5 * (height - Constants.mapEditor_formHeight),
        0.5 * (width - Constants.mapEditor_formWidth), 0.5 * (height - Constants.mapEditor_formHeight));
      this.setTitleText("New Level");
      this.setTitleSize(18);
      this.color_background = color(180, 250, 180);
      this.color_header = color(30, 170, 30);
    }

    void submit() {
    }
  }


  abstract class ConfirmForm extends FormLNZ {
    ConfirmForm(String title, String message) {
      super(0.5 * (width - Constants.mapEditor_formWidth), 0.5 * (height - Constants.mapEditor_formHeight),
        0.5 * (width - Constants.mapEditor_formWidth), 0.5 * (height - Constants.mapEditor_formHeight));
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


  class TriggerEditorForm extends Form {
    TriggerEditorForm() {
      super(0, 0, 0, 0);
    }

    void cancel() {
    }

    void submit() {
    }

    void buttonPress(int i) {
    }
  }


  private MapEditorPage page;

  private MapEditorButton[] buttons = new MapEditorButton[5];
  private Panel leftPanel = new Panel(LEFT, Constants.mapEditor_panelMinWidth,
    Constants.mapEditor_panelMaxWidth, Constants.mapEditor_panelStartWidth);
  private Panel rightPanel = new Panel(RIGHT, Constants.mapEditor_panelMinWidth,
    Constants.mapEditor_panelMaxWidth, Constants.mapEditor_panelStartWidth);
  private MapEditorListTextBox listBox1 = new MapEditorListTextBox();
  private LevelEditorListTextBox listBox2;
  private TriggerEditorForm triggerForm;

  MapEditorInterface() {
    this.buttons[0] = new MapEditorButton1();
    this.buttons[1] = new MapEditorButton2();
    this.buttons[2] = new MapEditorButton3();
    this.buttons[3] = new MapEditorButton4();
    this.buttons[4] = new MapEditorButton5();
    this.leftPanel.addIcon(global.images.getImage("icons/triangle.png"));
    this.rightPanel.addIcon(global.images.getImage("icons/triangle.png"));
    this.leftPanel.color_background = color(160, 82, 45);
    this.rightPanel.color_background = color(160, 82, 45);
    this.navigate(MapEditorPage.MAPS);
    this.resizeButtons();
  }


  void navigate(MapEditorPage page) {
    this.page = page;
    this.listBox1.setList(this.page);
    this.listBox1.active = true;
    switch(this.page) {
      case MAPS:
        this.buttons[0].message = "Toggle\nDisplay";
        this.buttons[1].message = "New\nMap";
        this.buttons[2].message = "Delete\nMap";
        break;
      case LEVELS:
        this.buttons[0].message = "Toggle\nDisplay";
        this.buttons[1].message = "New\nLevel";
        this.buttons[2].message = "Delete\nLevel";
        break;
      case TERRAIN:
      case FEATURES:
      case UNITS:
      case ITEMS:
        this.buttons[0].message = "Toggle\nDisplay";
        this.buttons[1].message = "Save\nMap";
        this.buttons[2].message = "Cancel\nMap";
        break;
      default:
        println("ERROR: MapEditorPage " + this.page + " not found.");
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
    //this.listBox2.setXLocation(width - this.rightPanel.size_curr + Constants.mapEditor_listBoxGap,
    //  width - Constants.mapEditor_listBoxGap);
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
        break;
      case FEATURES:
        break;
      case UNITS:
        break;
      case ITEMS:
        break;
      default:
        println("ERROR: MapEditorPage " + this.page + " not found.");
        break;
    }
  }

  void buttonClick2() {
    switch(this.page) {
      case MAPS:
        this.form = new NewMapForm();
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
      default:
        println("ERROR: MapEditorPage " + this.page + " not found.");
        break;
    }
  }

  void buttonClick3() {
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
      default:
        println("ERROR: MapEditorPage " + this.page + " not found.");
        break;
    }
  }

  void buttonClick4() {
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
      default:
        println("ERROR: MapEditorPage " + this.page + " not found.");
        break;
    }
  }


  void update(int millis) {
    background(60);
    this.leftPanel.update(millis);
    this.rightPanel.update(millis);
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (MapEditorButton button : this.buttons) {
        button.update(millis);
      }
      if (this.listBox1.active) {
        this.listBox1.update(millis);
      }
    }
  }

  void mouseMove(float mX, float mY) {
    this.leftPanel.mouseMove(mX, mY);
    this.rightPanel.mouseMove(mX, mY);
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
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (MapEditorButton button : this.buttons) {
        button.mouseMove(mX, mY);
      }
      if (this.listBox1.active) {
        this.listBox1.mouseMove(mX, mY);
      }
    }
  }

  void mousePress() {
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
    }
  }

  void mouseRelease() {
    this.leftPanel.mouseRelease();
    this.rightPanel.mouseRelease();
    if (this.leftPanel.hovered || this.rightPanel.hovered) {
      global.cursor = global.images.getImage("icons/cursor_resizeh.png");
    }
    else {
      global.cursor = global.images.getImage("icons/cursor_default.png");
    }
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      for (MapEditorButton button : this.buttons) {
        button.mouseRelease();
      }
      if (this.listBox1.active) {
        this.listBox1.mouseRelease();
      }
    }
  }

  void scroll(int amount) {
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      if (this.listBox1.active) {
        this.listBox1.scroll(amount);
      }
    }
  }

  void keyPress() {
  }

  void keyRelease() {
  }
}
