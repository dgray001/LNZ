enum MapEditorPage {
  MAPS, LEVELS, TERRAIN, FEATURES, UNITS, ITEMS; // add level pages later
}


class MapEditorInterface extends InterfaceLNZ {

  abstract class MapEditorButton extends RectangleButton {
    MapEditorButton() {
      super(0, 0.94 * height, 0, height - Constants.MapEditor_buttonGapSize);
      this.raised_border = true;
      this.roundness = 0;
      this.setColors(color(170), color(222, 184, 135), color(244, 164, 96), color(205, 133, 63), color(0));
      this.show_message = true;
    }
    void hover() {}
    void dehover() {
      this.clicked = false;
    }
    void click() {}
  }

  class MapEditorButton1 extends MapEditorButton {
    MapEditorButton1() {
      super();
      this.message = "Toggle\nDisplay";
    }
    void release() {
    }
  }

  class MapEditorButton2 extends MapEditorButton {
    MapEditorButton2() {
      super();
      this.message = "";
    }
    void release() {
      this.stayDehovered();
    }
  }

  class MapEditorButton3 extends MapEditorButton {
    MapEditorButton3() {
      super();
      this.message = "";
    }
    void release() {
      this.stayDehovered();
    }
  }

  class MapEditorButton4 extends MapEditorButton {
    MapEditorButton4() {
      super();
      this.message = "Main\nMenu";
    }
    void release() {
      this.stayDehovered();
      global.state = ProgramState.ENTERING_MAINMENU;
    }
  }

  class MapEditorButton5 extends MapEditorButton {
    MapEditorButton5() {
      super();
      this.message = "Help";
    }
    void release() {
      this.stayDehovered();
    }
  }


  class MapEditorListTextBox extends ListTextBox {
    MapEditorListTextBox() {
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
      super(0, 0, 0, 0);
    }

    void submit() {
    }
  }


  class NewLevelForm extends FormLNZ {
    NewLevelForm() {
      super(0, 0, 0, 0);
    }

    void submit() {
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


  private MapEditorPage page = MapEditorPage.MAPS;

  private MapEditorButton[] buttons = new MapEditorButton[5];
  private Panel leftPanel = new Panel(LEFT, Constants.MapEditor_panelMinWidth,
    Constants.MapEditor_panelMaxWidth, Constants.MapEditor_panelStartWidth);
  private Panel rightPanel = new Panel(RIGHT, Constants.MapEditor_panelMinWidth,
    Constants.MapEditor_panelMaxWidth, Constants.MapEditor_panelStartWidth);
  private MapEditorListTextBox listBox1;
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
    this.navigate();
  }


  void navigate(MapEditorPage page) {
    this.page = page;
    this.navigate();
  }
  void navigate() {
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

  void resizeButtons() {
    float buttonSize = (this.rightPanel.size_curr - 5 * Constants.MapEditor_buttonGapSize) / 4.0;
    float xi = width - this.rightPanel.size_curr + Constants.MapEditor_buttonGapSize;
    this.buttons[0].setXLocation(xi, xi + buttonSize);
    xi += buttonSize + Constants.MapEditor_buttonGapSize;
    this.buttons[1].setXLocation(xi, xi + buttonSize);
    xi += buttonSize + Constants.MapEditor_buttonGapSize;
    this.buttons[2].setXLocation(xi, xi + buttonSize);
    xi += buttonSize + Constants.MapEditor_buttonGapSize;
    this.buttons[3].setXLocation(xi, xi + buttonSize);
  }


  void update(int millis) {
    background(60);
    this.leftPanel.update(millis);
    this.rightPanel.update(millis);
    if (this.rightPanel.open && !this.rightPanel.collapsing) {
      this.resizeButtons();
      for (MapEditorButton button : this.buttons) {
        button.update(millis);
      }
    }
  }

  void mouseMove(float mX, float mY) {
    this.leftPanel.mouseMove(mX, mY);
    this.rightPanel.mouseMove(mX, mY);
    if (this.leftPanel.clicked || this.rightPanel.clicked) {
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
    }
  }

  void scroll(int amount) {
  }

  void keyPress() {
  }

  void keyRelease() {
  }
}
