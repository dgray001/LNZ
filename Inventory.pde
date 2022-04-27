class Inventory {

  class InventorySlot {

    class InventoryButton extends RectangleButton {
      InventoryButton() {
        this(0);
      }
      InventoryButton(float button_size) {
        super(0, 0, 0, 0);
        this.setColors(color(0, 120), color(1, 0), color(220, 70), color(220, 140), color(0));
        this.setStroke(color(142, 75, 50), 3);
        this.setSize(button_size);
        this.roundness = 0;
        this.use_time_elapsed = true;
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
    protected boolean deactivated = false;

    InventorySlot() {
      this(0);
    }
    InventorySlot(float button_size) {
      this.button = new InventoryButton(button_size);
    }

    float width() {
      return this.button.button_width();
    }
    void setWidth(float new_width) {
      this.button.xf = new_width;
      this.button.yf = new_width;
    }

    void update(int timeElapsed) {
      if (this.deactivated) {
        return;
      }
      if (this.item != null) {
        image(this.item.getImage(), this.button.xi, this.button.yi, this.button.xf, this.button.yf);
      }
      this.button.update(timeElapsed);
      if (this.item != null && this.item.remove) {
        this.item = null;
      }
    }

    void mouseMove(float mX, float mY) {
      if (this.deactivated) {
        return;
      }
      this.button.mouseMove(mX, mY);
    }

    void mousePress() {
      if (this.deactivated) {
        return;
      }
      this.button.mousePress();
    }

    void mouseRelease(float mX, float mY) {
      if (this.deactivated) {
        return;
      }
      this.button.mouseRelease(mX, mY);
    }
  }


  protected int max_rows = 0;
  protected int max_cols = 0;
  protected ArrayList<InventorySlot> slots = new ArrayList<InventorySlot>();
  protected float button_size = 0;

  protected color color_background = global.color_inventoryBackground;

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


  Item stash(Item i) {
    for (InventorySlot slot : this.slots) {
      if (slot.item == null) {
        slot.item = new Item(i);
        return null;
      }
    }
    return i;
  }

  Item placeAt(Item i, int index) {
    return this.placeAt(i, index, false);
  }
  Item placeAt(Item i, int index, boolean replace) {
    if (index < 0 || index >= this.slots.size()) {
      return i;
    }
    if (i != null && i.remove) {
      i = null;
    }
    if (this.slots.get(index).item == null) {
      this.slots.get(index).item = new Item(i);
      if (this.slots.get(index).item.remove) {
        this.slots.get(index).item = null;
      }
      return null;
    }
    else if (replace) {
      Item replaced = new Item(this.slots.get(index).item);
      if (replaced.remove) {
        replaced = null;
      }
      this.slots.get(index).item = new Item(i);
      if (this.slots.get(index).item.remove) {
        this.slots.get(index).item = null;
      }
      return replaced;
    }
    return i;
  }

  ArrayList<Item> items() {
    ArrayList<Item> items = new ArrayList<Item>();
    for (InventorySlot slot : this.slots) {
      if (slot.item != null) {
        items.add(slot.item);
      }
    }
    return items;
  }


  void update(int timeElapsed) {
    rectMode(CORNER);
    fill(this.color_background);
    noStroke();
    rect(0, 0, this.display_width, this.display_height);
    imageMode(CORNERS);
    for (int x = 0; x < this.max_cols; x++) {
      for (int y = 0; y < this.max_rows; y++) {
        int i = y * this.max_cols + x;
        if (i >= this.slots.size()) {
          break;
        }
        translate(2 + x * this.button_size, 2 + y * this.button_size);
        this.slots.get(i).update(timeElapsed);
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

  String internalFileString() {
    String fileString = "";
    for (int i = 0; i < this.slots.size(); i++) {
      if (this.slots.get(i).item != null) {
        fileString += this.slots.get(i).item.fileString() + ": " + i;
      }
    }
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


class DeskInventory extends Inventory {
  DeskInventory() {
    super(3, 3, true);
    this.slots.get(2).deactivated = true;
    this.slots.get(3).deactivated = true;
    this.slots.get(4).deactivated = true;
    this.slots.get(6).deactivated = true;
    this.slots.get(7).deactivated = true;
  }
}


class StoveInventory extends Inventory {
  StoveInventory() {
    super(5, 2, true);
    this.slots.get(4).deactivated = true;
    this.slots.get(5).deactivated = true;
  }

  // add on/off switch for inside oven and knobs for burners
}


Inventory getKhalilInventory(int khalil_code) {
  Inventory inv = null;
  switch(khalil_code) {
    case 0:
      inv = new Inventory(1, 2, true);
      Item i = new Item(2106);
      i.stack = 4;
      inv.stash(i);
      inv.stash(new Item(2461));
      break;
    default:
      global.errorMessage("ERROR: Khalil code " + khalil_code + " not found.");
      break;
  }
  return inv;
}

ArrayList<Float> getKhalilInventoryCosts(int khalil_code) {
  ArrayList<Float> costs = new ArrayList<Float>();
  switch(khalil_code) {
    case 0:
      costs.add(1.0);
      costs.add(2.12);
      break;
    default:
      global.errorMessage("ERROR: Khalil code " + khalil_code + " not found.");
      break;
  }
  return costs;
}
