class Inventory {

  class InventorySlot {

    class InventoryButton extends RectangleButton {
      InventoryButton() {
        this(0);
      }
      InventoryButton(float button_size) {
        super(0, 0, 0, 0);
        this.setColors(color(0, 120), color(1, 0), color(180, 80), color(180, 160), color(0));
        this.setStroke(color(250, 200, 160), 2);
        this.setSize(button_size);
      }

      void setSize(float size) {
        this.setLocation(0, 0, size, size);
      }

      void hover() {}
      void dehover() {}
      void click() {
        if (InventorySlot.this.item == null) {
          this.clicked = false;
        }
      }
      void release() {}
    }


    protected InventoryButton button = new InventoryButton();
    protected Item item = null;

    InventorySlot() {
      this(0);
    }
    InventorySlot(float button_size) {
      this.button = new InventoryButton(button_size);
    }

    void update(int millis) {
      this.button.update(millis);
      if (this.item != null && this.item.remove) {
        this.item = null;
      }
    }
  }


  protected int max_rows = 0;
  protected int max_cols = 0;
  protected ArrayList<InventorySlot> slots = new ArrayList<InventorySlot>();
  protected float button_size = Constants.hero_defaultInventoryButtonSize;

  protected color color_background = color(220, 180, 130);

  protected float display_width = 0;
  protected float display_height = 0;

  Inventory(int rows, int cols) {
    this(rows, cols, true);
  }
  Inventory(int rows, int cols, boolean fillup) {
    this.max_rows = rows;
    this.max_cols = cols;
    if (fillup) {
      this.fillMaxCapacity();
    }
    this.refreshDisplayParameters();
  }

  int maxCapacity() {
    return this.max_rows * this.max_cols;
  }

  void addSlot() {
    if (this.slots.size() < this.maxCapacity()) {
      this.slots.add(new InventorySlot(this.button_size));
    }
  }

  void fillMaxCapacity() {
    for (int i = this.slots.size(); i < this.maxCapacity; i++) {
      this.slots.add(new InventorySlot(this.button_size));
    }
  }

  void setButtonSize(float button_size) {
    this.button_size = button_size;
    for (InventorySlot slot : this.slots) {
      slot.button.setButtonSize(button_size);
    }
    this.refreshDisplayParameters();
  }

  void refreshDisplayParameters() {
    this.display_width = this.button_size * this.max_cols + 2;
    this.display_height = this.button_size * this.max_rows + 2;
  }


  void update(int millis) {
    rectMode(CORNER);
    fill(this.color_background);
    noStroke();
    rect(0, 0, this.display_width, this.display_height);
    pushMatrix();
    for (int x = 0; x < this.max_cols; x++) {
      for (int y = 0; y < this.max_rows; y++) {
        int i = x * this.max_cols + y;
        if (i >= this.slots.size()) {
          break;
        }
        translate(1 + x * this.button_size, 1 + y * this.button_size);
        this.slots.get(i).update(millis);
        popMatrix();
      }
    }
  }


  String fileString() {
    String fileString = "\nnew: Inventory: " + this.max_rows + ", " + this.max_cols;
    for (int i = 0; i < this.slots.size(); i++) {
      fileString += "\naddSlot:";
      if (slot.item != null) {
        fileString += slot.item.fileString() + ": " + i;
      }
    }
    fileString += "\nend: Inventory";
    return fileString;
  }

  void addData(String datakey, String data) {
    switch(dataKey) {
      case "addSlot":
        this.addSlot();
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not found for inventory data.");
        break;
    }
  }
}
