class Inventory {

  class InventorySlot {

    class InventoryButton extends RectangleButton {
      InventoryButton() {
        this(0);
      }
      InventoryButton(float button_size) {
        super(0, 0, 0, 0);
        this.setColors(color(0, 120), color(1, 0), color(220, 80), color(220, 160), color(0));
        this.setStroke(color(220), 3);
        this.setSize(button_size);
        this.roundness = 0;
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

    void mouseMove(float mX, float mY) {
      this.button.mouseMove(mX, mY);
    }

    void mousePress() {
      this.button.mousePress();
    }

    void mouseRelease(float mX, float mY) {
      this.button.mouseRelease(mX, mY);
    }
  }


  protected int max_rows = 0;
  protected int max_cols = 0;
  protected ArrayList<InventorySlot> slots = new ArrayList<InventorySlot>();
  protected float button_size = 0;

  protected color color_background = color(170);

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
    this.setButtonSize(Constants.hero_defaultInventoryButtonSize);
  }

  int maxCapacity() {
    return this.max_rows * this.max_cols;
  }

  void addSlot() {
    if (this.slots.size() < this.maxCapacity()) {
      this.slots.add(new InventorySlot(this.button_size));
    }
  }

  void addSlots(int amount) {
    int slotsLeft = this.maxCapacity() - this.slots.size();
    for (int i = 0; i < min(amount, slotsLeft); i++) {
      this.slots.add(new InventorySlot(this.button_size));
    }
  }

  void setSlots(int amount) {
    if (amount < 0) {
      return;
    }
    if (amount > this.maxCapacity()) {
      amount = this.maxCapacity();
    }
    if (amount < this.slots.size()) {
      // remove slots
      global.errorMessage("ERROR: Can't reduce slots in inventory yet.");
    }
    else {
      this.addSlots(amount - this.slots.size());
    }
  }

  void fillMaxCapacity() {
    int currSize = this.slots.size();
    int maxSize = this.maxCapacity();
    for (int i = currSize; i < maxSize; i++) {
      this.slots.add(new InventorySlot(this.button_size));
    }
  }

  void setButtonSize(float button_size) {
    this.button_size = button_size;
    for (InventorySlot slot : this.slots) {
      slot.button.setSize(button_size);
    }
    this.refreshDisplayParameters();
  }

  void refreshDisplayParameters() {
    this.display_width = this.button_size * this.max_cols + 4;
    this.display_height = this.button_size * this.max_rows + 4;
  }


  void update(int millis) {
    rectMode(CORNER);
    fill(this.color_background);
    noStroke();
    rect(0, 0, this.display_width, this.display_height);
    for (int x = 0; x < this.max_cols; x++) {
      for (int y = 0; y < this.max_rows; y++) {
        int i = y * this.max_cols + x;
        if (i >= this.slots.size()) {
          break;
        }
        translate(2 + x * this.button_size, 2 + y * this.button_size);
        this.slots.get(i).update(millis);
        translate(-2 - x * this.button_size, -2 - y * this.button_size);
      }
    }
  }

  void mouseMove(float mX, float mY) {
    for (int x = 0; x < this.max_cols; x++) {
      for (int y = 0; y < this.max_rows; y++) {
        int i = y * this.max_cols + x;
        if (i >= this.slots.size()) {
          break;
        }
        this.slots.get(i).mouseMove(mX - 2 - x * this.button_size, mY - 2 - y * this.button_size);
      }
    }
  }

  void mousePress() {
    for (InventorySlot slot : this.slots) {
      slot.mousePress();
    }
  }

  void mouseRelease(float mX, float mY) {
    for (int x = 0; x < this.max_cols; x++) {
      for (int y = 0; y < this.max_rows; y++) {
        int i = y * this.max_cols + x;
        if (i >= this.slots.size()) {
          break;
        }
        this.slots.get(i).mouseRelease(mX - 2 - x * this.button_size, mY - 2 - y * this.button_size);
      }
    }
  }


  String fileString() {
    String fileString = "\nnew: Inventory: " + this.max_rows + ", " + this.max_cols;
    for (int i = 0; i < this.slots.size(); i++) {
      fileString += "\naddSlot:";
      if (this.slots.get(i).item != null) {
        fileString += this.slots.get(i).item.fileString() + ": " + i;
      }
    }
    fileString += "\nend: Inventory";
    return fileString;
  }

  void addData(String datakey, String data) {
    switch(datakey) {
      case "addSlot":
        this.addSlot();
        break;
      default:
        global.errorMessage("ERROR: Datakey " + datakey + " not found for inventory data.");
        break;
    }
  }
}
