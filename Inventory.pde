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
        if (this.item.stack > 1) {
          fill(255);
          textSize(14);
          textAlign(RIGHT, BOTTOM);
          text(this.item.stack, this.button.xf - 2, this.button.yf - 2);
        }
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

  void deactivateSlots() {
    for (InventorySlot slot : this.slots) {
      slot.deactivated = true;
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
    if (i == null || i.remove) {
      return null;
    }
    for (InventorySlot slot : this.slots) {
      if (slot.item != null && slot.item.ID == i.ID) {
        int stack_left = slot.item.maxStack() - slot.item.stack;
        if (stack_left < 1) {
          continue;
        }
        if (i.stack > stack_left) {
          slot.item.addStack(stack_left);
          i.removeStack(stack_left);
        }
        else {
          slot.item.addStack(i.stack);
          return null;
        }
      }
    }
    for (InventorySlot slot : this.slots) {
      if (slot.item == null) {
        slot.item = new Item(i);
        if (slot.item.remove) {
          slot.item = null;
        }
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
    else if (this.slots.get(index).item.ID == i.ID) {
      int stack_left = this.slots.get(index).item.maxStack() - this.slots.get(index).item.stack;
      if (i.stack > stack_left) {
        this.slots.get(index).item.addStack(stack_left);
        i.removeStack(stack_left);
      }
      else {
        this.slots.get(index).item.addStack(i.stack);
        return null;
      }
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
  class DrawerButton1 extends ImageButton {
    protected boolean opened = false;
    DrawerButton1() {
      super(global.images.getImage("features/default.png"), 0, 0, 0, 0);
    }

    void hover() {}
    void click() {
      if (this.opened) {
        return;
      }
      this.opened = true;
      DeskInventory.this.slots.get(0).deactivated = false;
      DeskInventory.this.slots.get(1).deactivated = false;
      this.img = global.images.getTransparentPixel();
    }
    void dehover() {}
    void release() {}
  }

  class DrawerButton2 extends ImageButton {
    protected boolean opened = false;
    DrawerButton2() {
      super(global.images.getImage("features/default.png"), 0, 0, 0, 0);
    }

    void hover() {}
    void click() {
      if (this.opened) {
        return;
      }
      this.opened = true;
      DeskInventory.this.slots.get(5).deactivated = false;
      this.img = global.images.getTransparentPixel();
    }
    void dehover() {}
    void release() {}
  }

  class DrawerButton3 extends ImageButton {
    protected boolean opened = false;
    DrawerButton3() {
      super(global.images.getImage("features/default.png"), 0, 0, 0, 0);
    }

    void hover() {}
    void click() {
      if (this.opened) {
        return;
      }
      this.opened = true;
      DeskInventory.this.slots.get(8).deactivated = false;
      this.img = global.images.getTransparentPixel();
    }
    void dehover() {}
    void release() {}
  }

  protected DrawerButton1 top_drawer = new DrawerButton1();
  protected DrawerButton2 mid_drawer = new DrawerButton2();
  protected DrawerButton3 bottom_drawer = new DrawerButton3();

  DeskInventory() {
    super(3, 3, true);
    this.deactivateSlots();
    this.setButtonSize(this.button_size);
  }

  void closeDrawers() {
    this.top_drawer.opened = false;
    this.mid_drawer.opened = false;
    this.bottom_drawer.opened = false;
    this.top_drawer.img = global.images.getImage("features/default.png");
    this.mid_drawer.img = global.images.getImage("features/default.png");
    this.bottom_drawer.img = global.images.getImage("features/default.png");
    this.deactivateSlots();
  }

  @Override
  void setButtonSize(float button_size) {
    super.setButtonSize(button_size);
    this.top_drawer.setLocation(2, 2, 2 + 2 * button_size, 2 + this.button_size);
    this.mid_drawer.setLocation(2 + 2 * button_size, 2 + button_size, 2 + 3 * button_size, 2 + 2 * this.button_size);
    this.bottom_drawer.setLocation(2 + 2 * button_size, 2 + 2 * button_size, 2 + 3 * button_size, 2 + 3 * this.button_size);
  }

  @Override
  void update(int millis) {
    super.update(millis);
    this.top_drawer.update(millis);
    this.mid_drawer.update(millis);
    this.bottom_drawer.update(millis);
  }

  @Override
  void mouseMove(float mX, float mY) {
    super.mouseMove(mX, mY);
    this.top_drawer.mouseMove(mX, mY);
    this.mid_drawer.mouseMove(mX, mY);
    this.bottom_drawer.mouseMove(mX, mY);
  }

  @Override
  void mousePress() {
    super.mousePress();
    this.top_drawer.mousePress();
    this.mid_drawer.mousePress();
    this.bottom_drawer.mousePress();
  }

  @Override
  void mouseRelease(float mX, float mY) {
    super.mouseRelease(mX, mY);
    this.top_drawer.mouseRelease(mX, mY);
    this.mid_drawer.mouseRelease(mX, mY);
    this.bottom_drawer.mouseRelease(mX, mY);
  }
}


class StoveInventory extends Inventory {
  class StoveDoor extends ImageButton {
    protected boolean opened = false;
    StoveDoor() {
      super(global.images.getImage("features/default.png"), 0, 0, 0, 0);
    }

    void hover() {}
    void click() {
      if (this.opened) {
        return;
      }
      this.opened = true;
      StoveInventory.this.slots.get(26).deactivated = false;
      StoveInventory.this.slots.get(27).deactivated = false;
      StoveInventory.this.slots.get(28).deactivated = false;
      StoveInventory.this.slots.get(31).deactivated = false;
      StoveInventory.this.slots.get(32).deactivated = false;
      StoveInventory.this.slots.get(33).deactivated = false;
      this.img = global.images.getTransparentPixel();
    }
    void dehover() {}
    void release() {}
  }

  abstract class KnobButton extends ImageButton {
    protected int value = 0;
    protected int max_value = 0;
    KnobButton(PImage img, int max_value) {
      super(img, 0, 0, 0, 0);
      this.max_value = max_value;
    }

    @Override
    void drawButton() {
      super.drawButton();
      imageMode(CENTER);
      translate(this.xCenter(), this.yCenter());
      float curr_rotation = this.knobRotation();
      rotate(curr_rotation);
      image(global.images.getImage("features/stove_knob.png"), 0, 0,
        0.7 * this.button_width(), 0.7 * this.button_height());
      rotate(-curr_rotation);
      translate(-this.xCenter(), -this.yCenter());
    }

    @Override
    void mouseMove(float mX, float mY) {
      super.mouseMove(mX, mY);
      if (this.clicked) {
        // rotate (??)
      }
    }

    abstract float knobRotation();

    void hover() {}
    void click() {}
    void dehover() {}
    void release() {}
  }

  abstract class KnobButtonBurner extends KnobButton {
    KnobButtonBurner() {
      super(global.images.getImage("features/stove_knob_burner.png"), 6);
    }

    float knobRotation() {
      switch(this.value) {
        case 0:
          return 0;
        case 1:
          return 0;
        case 2:
          return 0;
        case 3:
          return 0;
        case 4:
          return 0;
        case 5:
          return 0;
        case 6:
          return 0;
        default:
          global.errorMessage("ERROR: Knob value " + this.value +" invalid for BurnerKnob.");
          return 0;
      }
    }
  }

  class Burner1 extends KnobButtonBurner {
    Burner1() {
      super();
    }
  }

  class Burner2 extends KnobButtonBurner {
    Burner2() {
      super();
    }
  }

  class Burner3 extends KnobButtonBurner {
    Burner3() {
      super();
    }
  }

  class Burner4 extends KnobButtonBurner {
    Burner4() {
      super();
    }
  }

  class OvenKnob extends KnobButton {
    OvenKnob() {
      super(global.images.getImage("features/stove_knob_oven.png"), 9);
    }

    float knobRotation() {
      switch(this.value) {
        case 0:
          return 0;
        case 1:
          return 0;
        case 2:
          return 0;
        case 3:
          return 0;
        case 4:
          return 0;
        case 5:
          return 0;
        case 6:
          return 0;
        case 7:
          return 0;
        case 8:
          return 0;
        case 9:
          return 0;
        default:
          global.errorMessage("ERROR: Knob value " + this.value + " invalid for OvenKnob.");
          return 0;
      }
    }
  }

  protected StoveDoor door = new StoveDoor();
  protected KnobButton[] knobs = new KnobButton[5];

  StoveInventory() {
    super(8, 5, true);
    this.deactivateSlots();
    this.slots.get(1).deactivated = false;
    this.slots.get(3).deactivated = false;
    this.slots.get(11).deactivated = false;
    this.slots.get(13).deactivated = false;
    this.knobs[0] = new Burner1();
    this.knobs[1] = new Burner2();
    this.knobs[2] = new OvenKnob();
    this.knobs[3] = new Burner3();
    this.knobs[4] = new Burner4();
    this.setButtonSize(this.button_size);
  }

  void closeDrawers() {
    this.door.opened = false;
    this.slots.get(26).deactivated = true;
    this.slots.get(27).deactivated = true;
    this.slots.get(28).deactivated = true;
    this.slots.get(31).deactivated = true;
    this.slots.get(32).deactivated = true;
    this.slots.get(33).deactivated = true;
    this.door.img = global.images.getImage("features/default.png");
  }

  @Override
  void setButtonSize(float button_size) {
    super.setButtonSize(button_size);
    this.door.setLocation(2 + button_size, 2 + 5 * button_size,
      2 + 4 * button_size, 2 + 7 * this.button_size);
    for (int i = 0; i < this.knobs.length; i++) {
      this.knobs[i].setLocation(2 + i * button_size, 2 + 3.5 * button_size,
        2 + (i + 1) * button_size, 2 + 4.5 * button_size);
    }
  }

  @Override
  void update(int millis) {
    super.update(millis);
    this.door.update(millis);
    for (KnobButton knob : this.knobs) {
      knob.update(millis);
    }
  }

  @Override
  void mouseMove(float mX, float mY) {
    super.mouseMove(mX, mY);
    this.door.mouseMove(mX, mY);
    for (KnobButton knob : this.knobs) {
      knob.mouseMove(mX, mY);
    }
  }

  @Override
  void mousePress() {
    super.mousePress();
    this.door.mousePress();
    for (KnobButton knob : this.knobs) {
      knob.mousePress();
    }
  }

  @Override
  void mouseRelease(float mX, float mY) {
    super.mouseRelease(mX, mY);
    this.door.mouseRelease(mX, mY);
    for (KnobButton knob : this.knobs) {
      knob.mouseRelease(mX, mY);
    }
  }
}


class MinifridgeInventory extends Inventory {
  MinifridgeInventory() {
    super(2, 2, true);
  }
}


class RefridgeratorInventory extends Inventory {
  RefridgeratorInventory() {
    super(4, 2, true);
  }
}


class WasherInventory extends Inventory {
  WasherInventory() {
    super(3, 3, true);
  }
}


class DryerInventory extends Inventory {
  DryerInventory() {
    super(3, 3, true);
  }
}


class GarbageInventory extends Inventory {
  GarbageInventory() {
    super(3, 1, true);
  }
}


class RecycleInventory extends Inventory {
  RecycleInventory() {
    super(3, 1, true);
  }
}


class CrateInventory extends Inventory {
  CrateInventory() {
    super(2, 2, true);
  }
}


class CardboardBoxInventory extends Inventory {
  CardboardBoxInventory() {
    super(2, 2, true);
  }
}


class EnderChestInventory extends Inventory {
  EnderChestInventory() {
    super(3, 4, true);
  }
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
