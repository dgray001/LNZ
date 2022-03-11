enum MapEditorPage {
  MAPS, LEVELS, TERRAIN, FEATURES, UNITS, ITEMS; // add level pages later
}


class MapEditorInterface extends InterfaceLNZ {

  abstract class MapEditorButton extends RectangleButton {
    MapEditorButton(float xi, float yi, float xf, float yf) {
      super(xi, yi, xf, yf);
    }
  }

  class MapEditorButton1 extends MapEditorButton {
    MapEditorButton1() {
    }
  }

  class MapEditorButton2 extends MapEditorButton {
    MapEditorButton2() {
    }
  }

  class MapEditorButton3 extends MapEditorButton {
    MapEditorButton3() {
    }
  }

  class MapEditorButton4 extends MapEditorButton {
    MapEditorButton4() {
    }
  }

  class MapEditorButton5 extends MapEditorButton {
    MapEditorButton5() {
    }
  }

  class MapEditorButton6 extends MapEditorButton {
    MapEditorButton6() {
    }
  }


  class MapEditorListTextBox extends ListTextBox {
    MapEditorListTextBox() {
    }
  }


  class LevelEditorListTextBox extends ListTextBox {
    LevelEditorListTextBox() {
    }
  }


  class NewMapForm extends FormLNZ {
  }


  class NewLevelForm extends FormLNZ {
  }


  class TriggerEditorForm extends Form {
    TriggerEditorForm() {
    }
  }


  private MapEditorPage page = MapEditorPage.MAPS;

  private MapEditorButton[] buttons = new MapEditorButton[6];
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
    this.buttons[5] = new MapEditorButton6();
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


  void update(int millis) {
    this.leftPanel.update(millis);
    this.rightPanel.update(millis);
    if (this.rightPanel.open) {
      for (MapEditorButton button : this.buttons) {
        button.update(millis);
      }
    }
  }

  void mouseMove(float mX, float mY) {
    this.leftPanel.mouseMove(mX, mY);
    this.rightPanel.mouseMove(mX, mY);
    if (this.rightPanel.open) {
      for (MapEditorButton button : this.buttons) {
        button.mouseMove(mX, mY);
      }
    }
  }

  void mousePress() {
    this.leftPanel.mousePress();
    this.rightPanel.mousePress();
    if (this.rightPanel.open) {
      for (MapEditorButton button : this.buttons) {
        button.mousePress();
      }
    }
  }

  void mouseRelease() {
    this.leftPanel.mouseRelease();
    this.rightPanel.mouseRelease();
    if (this.rightPanel.open) {
      for (MapEditorButton button : this.buttons) {
        button.mouseRelease();
      }
    }
  }

  void scroll(int amount) {
    if (this.rightPanel.open) {
      for (MapEditorButton button : this.buttons) {
        button.scroll(amount);
      }
    }
  }

  void keyPress() {
    if (this.rightPanel.open) {
      for (MapEditorButton button : this.buttons) {
        button.keyPress();
      }
    }
  }

  void keyRelease() {
    if (this.rightPanel.open) {
      for (MapEditorButton button : this.buttons) {
        button.keyRelease();
      }
    }
  }
}
