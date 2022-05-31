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
        this.force_left_button = false;
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
    protected float last_mX = 0;
    protected float last_mY = 0;

    InventorySlot() {
      this(0);
    }
    InventorySlot(float button_size) {
      this.button = new InventoryButton(button_size);
    }

    void removeStack() {
      if (this.item != null) {
        this.item.removeStack();
      }
    }

    float width() {
      return this.button.button_width();
    }
    void setWidth(float new_width) {
      this.button.xf = new_width;
      this.button.yf = new_width;
    }

    void update(int timeElapsed) {
      this.update(timeElapsed, true);
    }
    void update(int timeElapsed, boolean show_slot_hovered_message) {
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
      if (this.button.hovered && this.item != null && show_slot_hovered_message) {
        textSize(20);
        float rect_height = textAscent() + textDescent() + 2;
        float rect_width = textWidth(this.item.display_name()) + 2;
        rectMode(CORNER);
        fill(global.color_nameDisplayed_background);
        stroke(1, 0);
        strokeWeight(0.1);
        rect(this.last_mX - rect_width - 1, this.last_mY - rect_height - 1, rect_width, rect_height);
        fill(255);
        textAlign(LEFT, TOP);
        text(this.item.display_name(), this.last_mX - rect_width - 1, this.last_mY - rect_height - 1);
      }
    }

    void mouseMove(float mX, float mY) {
      this.last_mX = mX;
      this.last_mY = mY;
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

  protected boolean hovered = false;

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

  void clear() {
    for (InventorySlot slot : this.slots) {
      slot.item = null;
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

  void activateSlots() {
    for (InventorySlot slot : this.slots) {
      slot.deactivated = false;
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


  // stashes in open drawers for specialized inventories
  void stashInDrawers(Item i) {
    this.stash(i);
  }

  void stash(Item i, int ... slots) {
    for (int slot : slots) {
      if (i == null) {
        break;
      }
      i = this.placeAt(i, slot, false, true);
    }
  }

  Item stash(Item i) {
    if (i == null || i.remove) {
      return null;
    }
    for (InventorySlot slot : this.slots) {
      if (slot.deactivated) {
        continue;
      }
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
      if (slot.deactivated) {
        continue;
      }
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
    return this.placeAt(i, index, replace, false);
  }
  Item placeAt(Item i, int index, boolean replace, boolean ignore_deactivate) {
    if (index < 0 || index >= this.slots.size()) {
      return i;
    }
    if (!ignore_deactivate && this.slots.get(index).deactivated) {
      return i;
    }
    if (i == null || i.remove) {
      return null;
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


  // default 0 means default inventories can't craft anything
  int getCraftingHashCode() {
    return 0;
  }


  void drawBackground() {
    rectMode(CORNER);
    fill(this.color_background);
    noStroke();
    rect(0, 0, this.display_width, this.display_height);
  }

  void update(int timeElapsed) {
    this.update(timeElapsed, true);
  }
  void update(int timeElapsed, boolean draw_background) {
    if (draw_background) {
      this.drawBackground();
    }
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
    if (mX + 5 < 0 || mY + 5 < 0 || mX - 5 > this.display_width || mY - 5 > this.display_height) {
      this.hovered = false;
    }
    else {
      this.hovered = true;
    }
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
      super(global.images.getImage("features/desk_drawer1_closed.png"), 0, 0, 0, 0);
      this.force_left_button = false;
    }

    void hover() {}
    void click() {
      if (this.opened) {
        this.opened = false;
        DeskInventory.this.slots.get(0).deactivated = true;
        DeskInventory.this.slots.get(1).deactivated = true;
        this.moveButton(0, -DeskInventory.this.button_size);
        global.sounds.trigger_environment("features/desk_drawer1_close");
        this.img = global.images.getImage("features/desk_drawer1_closed.png");
      }
      else {
        this.opened = true;
        DeskInventory.this.slots.get(0).deactivated = false;
        DeskInventory.this.slots.get(1).deactivated = false;
        this.moveButton(0, DeskInventory.this.button_size);
        global.sounds.trigger_environment("features/desk_drawer1_open");
        this.img = global.images.getImage("features/desk_drawer1_opened.png");
      }
    }
    void dehover() {}
    void release() {}
  }

  class DrawerButton2 extends ImageButton {
    protected boolean opened = false;
    DrawerButton2() {
      super(global.images.getImage("features/desk_drawer2_closed.png"), 0, 0, 0, 0);
      this.force_left_button = false;
    }

    void hover() {}
    void click() {
      if (this.opened) {
        this.opened = false;
        DeskInventory.this.slots.get(2).deactivated = true;
        this.moveButton(-DeskInventory.this.button_size, -0.3 * DeskInventory.this.button_size);
        global.sounds.trigger_environment("features/desk_drawer2_close");
        this.img = global.images.getImage("features/desk_drawer2_closed.png");
      }
      else {
        this.opened = true;
        DeskInventory.this.slots.get(2).deactivated = false;
        this.moveButton(DeskInventory.this.button_size, 0.3 * DeskInventory.this.button_size);
        global.sounds.trigger_environment("features/desk_drawer2_open");
        this.img = global.images.getImage("features/desk_drawer2_opened.png");
      }
    }
    void dehover() {}
    void release() {}
  }

  class DrawerButton3 extends ImageButton {
    protected boolean opened = false;
    DrawerButton3() {
      super(global.images.getImage("features/desk_drawer3_closed.png"), 0, 0, 0, 0);
      this.force_left_button = false;
    }

    void hover() {}
    void click() {
      if (this.opened) {
        this.opened = false;
        DeskInventory.this.slots.get(5).deactivated = true;
        this.moveButton(-DeskInventory.this.button_size, -0.3 * DeskInventory.this.button_size);
        global.sounds.trigger_environment("features/desk_drawer2_close");
        this.img = global.images.getImage("features/desk_drawer3_closed.png");
      }
      else {
        this.opened = true;
        DeskInventory.this.slots.get(5).deactivated = false;
        this.moveButton(DeskInventory.this.button_size, 0.3 * DeskInventory.this.button_size);
        global.sounds.trigger_environment("features/desk_drawer2_open");
        this.img = global.images.getImage("features/desk_drawer2_opened.png");
      }
    }
    void dehover() {}
    void release() {}
  }

  class DrawerButton4 extends ImageButton {
    protected boolean opened = false;
    DrawerButton4() {
      super(global.images.getImage("features/desk_drawer4_closed.png"), 0, 0, 0, 0);
      this.force_left_button = false;
    }

    void hover() {}
    void click() {
      if (this.opened) {
        this.opened = false;
        DeskInventory.this.slots.get(8).deactivated = true;
        this.moveButton(-DeskInventory.this.button_size, -0.3 * DeskInventory.this.button_size);
        global.sounds.trigger_environment("features/desk_drawer2_close");
        this.img = global.images.getImage("features/desk_drawer4_closed.png");
      }
      else {
        this.opened = true;
        DeskInventory.this.slots.get(8).deactivated = false;
        this.moveButton(DeskInventory.this.button_size, 0.3 * DeskInventory.this.button_size);
        global.sounds.trigger_environment("features/desk_drawer2_open");
        this.img = global.images.getImage("features/desk_drawer2_opened.png");
      }
    }
    void dehover() {}
    void release() {}
  }

  protected DrawerButton1 top_drawer = new DrawerButton1();
  protected DrawerButton2 mid_drawer = new DrawerButton2();
  protected DrawerButton3 mid_drawer2 = new DrawerButton3();
  protected DrawerButton4 bottom_drawer = new DrawerButton4();

  DeskInventory() {
    super(3, 3, true);
    this.deactivateSlots();
    this.setButtonSize(this.button_size);
  }


  // stashes in closed drawers for specialized inventories
  void stashInDrawers(Item i) {
    this.stash(i, 0, 1, 2, 5, 8);
  }

  void closeDrawers() {
    this.top_drawer.opened = false;
    this.mid_drawer.opened = false;
    this.bottom_drawer.opened = false;
    this.top_drawer.img = global.images.getImage("features/desk_drawer1_closed.png");
    this.mid_drawer.img = global.images.getImage("features/desk_drawer2_closed.png");
    this.mid_drawer2.img = global.images.getImage("features/desk_drawer3_closed.png");
    this.bottom_drawer.img = global.images.getImage("features/desk_drawer4_closed.png");
    this.deactivateSlots();
  }

  @Override
  void setButtonSize(float button_size) {
    super.setButtonSize(button_size);
    this.top_drawer.setLocation(2, 2, 2 + 2 * button_size, 2 + this.button_size);
    if (this.top_drawer.opened) {
      this.top_drawer.moveButton(0, DeskInventory.this.button_size);
    }
    this.mid_drawer.setLocation(2 + 2 * button_size, 2, 2 + 3 * button_size, 2 + this.button_size);
    if (this.mid_drawer.opened) {
      this.mid_drawer.moveButton(DeskInventory.this.button_size, 0.3 * DeskInventory.this.button_size);
    }
    this.mid_drawer2.setLocation(2 + 2 * button_size, 2 + button_size, 2 + 3 * button_size, 2 + 2 * this.button_size);
    if (this.mid_drawer2.opened) {
      this.mid_drawer2.moveButton(DeskInventory.this.button_size, 0.3 * DeskInventory.this.button_size);
    }
    this.bottom_drawer.setLocation(2 + 2 * button_size, 2 + 2 * button_size, 2 + 3 * button_size, 2 + 3 * this.button_size);
    if (this.bottom_drawer.opened) {
      this.bottom_drawer.moveButton(DeskInventory.this.button_size, 0.3 * DeskInventory.this.button_size);
    }
  }

  @Override
  void update(int millis) {
    this.drawBackground();
    imageMode(CORNERS);
    image(global.images.getImage("features/desk_inventory.png"), 0, 0, this.display_width, this.display_height);
    if (top_drawer.opened) {
      this.top_drawer.update(millis);
    }
    if (mid_drawer.opened) {
      this.mid_drawer.update(millis);
    }
    if (mid_drawer2.opened) {
      this.mid_drawer2.update(millis);
    }
    if (bottom_drawer.opened) {
      this.bottom_drawer.update(millis);
    }
    super.update(millis, false);
    if (!top_drawer.opened) {
      this.top_drawer.update(millis);
    }
    if (!mid_drawer.opened) {
      this.mid_drawer.update(millis);
    }
    if (!mid_drawer2.opened) {
      this.mid_drawer2.update(millis);
    }
    if (!bottom_drawer.opened) {
      this.bottom_drawer.update(millis);
    }
  }

  @Override
  void mouseMove(float mX, float mY) {
    super.mouseMove(mX, mY);
    this.top_drawer.mouseMove(mX, mY);
    this.mid_drawer.mouseMove(mX, mY);
    this.mid_drawer2.mouseMove(mX, mY);
    this.bottom_drawer.mouseMove(mX, mY);
  }

  @Override
  void mousePress() {
    super.mousePress();
    this.top_drawer.mousePress();
    this.mid_drawer.mousePress();
    this.mid_drawer2.mousePress();
    this.bottom_drawer.mousePress();
  }

  @Override
  void mouseRelease(float mX, float mY) {
    super.mouseRelease(mX, mY);
    this.top_drawer.mouseRelease(mX, mY);
    this.mid_drawer.mouseRelease(mX, mY);
    this.mid_drawer2.mouseRelease(mX, mY);
    this.bottom_drawer.mouseRelease(mX, mY);
  }
}


class StoveInventory extends Inventory {
  class StoveDoor extends ImageButton {
    protected boolean opened = false;
    StoveDoor() {
      super(global.images.getImage("features/default.png"), 0, 0, 0, 0);
      this.force_left_button = false;
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
      this.force_left_button = false;
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
  class MinifridgeButton extends RectangleButton {
    protected boolean opened = false;
    MinifridgeButton() {
      super(0, 0, 0, 0);
      this.setColors(color(1, 0), color(1, 0), color(120, 30), color(120, 30), color(1, 0));
      this.noStroke();
      this.force_left_button = false;
    }

    void hover() {}
    void click() {
      if (this.opened) {
        this.opened = false;
        MinifridgeInventory.this.deactivateSlots();
        this.moveButton(-2 * MinifridgeInventory.this.button_size, 0);
        global.sounds.trigger_environment("features/minifridge_close");
      }
      else {
        this.opened = true;
        MinifridgeInventory.this.activateSlots();
        this.moveButton(2 * MinifridgeInventory.this.button_size, 0);
        global.sounds.trigger_environment("features/minifridge_open");
      }
      this.hovered = false;
      this.clicked = false;
    }
    void dehover() {}
    void release() {}
  }

  protected MinifridgeButton button = new MinifridgeButton();

  MinifridgeInventory() {
    super(2, 2, true);
    this.deactivateSlots();
    this.setButtonSize(this.button_size);
  }

  @Override
  void setButtonSize(float button_size) {
    super.setButtonSize(button_size);
    this.button.setLocation(2, 2, 2 + 2 * button_size, 2 + 2 * button_size);
    if (this.button.opened) {
      this.button.moveButton(2 * button_size, 0);
    }
  }

  @Override
  void update(int millis) {
    PImage closed_img = global.images.getImage("features/minifridge_closed.png");
    float display_w = this.display_height * float(closed_img.width) / closed_img.height;
    if (button.opened) {
      imageMode(CORNER);
      PImage open_img = global.images.getImage("features/minifridge_opened.png");
      float left_side = 0.5 * (this.display_width - display_w);
      float open_display_w = this.display_height * float(open_img.width) / open_img.height;
      image(open_img, left_side, 0, open_display_w, this.display_height);
    }
    super.update(millis, false);
    if (!button.opened) {
      imageMode(CENTER);
      image(closed_img, 0.5 * this.display_width, 0.5 * this.display_height, display_w, this.display_height);
    }
    this.button.update(millis);
  }

  @Override
  void mouseMove(float mX, float mY) {
    super.mouseMove(mX, mY);
    this.button.mouseMove(mX, mY);
  }

  @Override
  void mousePress() {
    super.mousePress();
    this.button.mousePress();
  }

  @Override
  void mouseRelease(float mX, float mY) {
    super.mouseRelease(mX, mY);
    this.button.mouseRelease(mX, mY);
  }
}


class RefridgeratorInventory extends Inventory {
  class FridgeButton extends RectangleButton {
    protected boolean opened = false;
    FridgeButton() {
      super(0, 0, 0, 0);
      this.setColors(color(1, 0), color(1, 0), color(120, 30), color(120, 30), color(1, 0));
      this.noStroke();
      this.force_left_button = false;
    }

    void hover() {}
    void click() {
      if (this.opened) {
        this.opened = false;
        RefridgeratorInventory.this.slots.get(4).deactivated = true;
        RefridgeratorInventory.this.slots.get(5).deactivated = true;
        RefridgeratorInventory.this.slots.get(6).deactivated = true;
        RefridgeratorInventory.this.slots.get(7).deactivated = true;
        RefridgeratorInventory.this.slots.get(8).deactivated = true;
        RefridgeratorInventory.this.slots.get(9).deactivated = true;
        this.moveButton(-2 * RefridgeratorInventory.this.button_size, 0);
        global.sounds.trigger_environment("features/fridge_close");
      }
      else {
        this.opened = true;
        RefridgeratorInventory.this.slots.get(4).deactivated = false;
        RefridgeratorInventory.this.slots.get(5).deactivated = false;
        RefridgeratorInventory.this.slots.get(6).deactivated = false;
        RefridgeratorInventory.this.slots.get(7).deactivated = false;
        RefridgeratorInventory.this.slots.get(8).deactivated = false;
        RefridgeratorInventory.this.slots.get(9).deactivated = false;
        this.moveButton(2 * RefridgeratorInventory.this.button_size, 0);
        global.sounds.trigger_environment("features/fridge_open");
      }
      this.hovered = false;
      this.clicked = false;
    }
    void dehover() {}
    void release() {}
  }


  class FreezerButton extends RectangleButton {
    protected boolean opened = false;
    FreezerButton() {
      super(0, 0, 0, 0);
      this.setColors(color(1, 0), color(1, 0), color(120, 30), color(120, 30), color(1, 0));
      this.noStroke();
      this.force_left_button = false;
    }

    void hover() {}
    void click() {
      if (this.opened) {
        this.opened = false;
        RefridgeratorInventory.this.slots.get(0).deactivated = true;
        RefridgeratorInventory.this.slots.get(1).deactivated = true;
        RefridgeratorInventory.this.slots.get(2).deactivated = true;
        RefridgeratorInventory.this.slots.get(3).deactivated = true;
        this.moveButton(-2 * RefridgeratorInventory.this.button_size, 0);
        global.sounds.trigger_environment("features/freezer_close");
      }
      else {
        this.opened = true;
        RefridgeratorInventory.this.slots.get(0).deactivated = false;
        RefridgeratorInventory.this.slots.get(1).deactivated = false;
        RefridgeratorInventory.this.slots.get(2).deactivated = false;
        RefridgeratorInventory.this.slots.get(3).deactivated = false;
        this.moveButton(2 * RefridgeratorInventory.this.button_size, 0);
        global.sounds.trigger_environment("features/freezer_open");
      }
      this.hovered = false;
      this.clicked = false;
    }
    void dehover() {}
    void release() {}
  }

  protected FridgeButton fridge = new FridgeButton();
  protected FreezerButton freezer = new FreezerButton();
  protected int freezer_sound_left = 0;
  protected float offset = 0;

  RefridgeratorInventory() {
    super(5, 2, true);
    this.deactivateSlots();
    this.setButtonSize(this.button_size);
  }

  @Override
  void setButtonSize(float button_size) {
    super.setButtonSize(button_size);
    this.fridge.setLocation(2, 2 + 2 * button_size, 2 + 2 * button_size, 2 + 5 * button_size);
    this.freezer.setLocation(2, 2, 2 + 2 * button_size, 2 + 2 * button_size);
    if (this.fridge.opened) {
      this.fridge.moveButton(2 * button_size, 0);
    }
    if (this.freezer.opened) {
      this.freezer.moveButton(2 * button_size, 0);
    }
  }

  @Override
  void update(int time_elapsed) {
    PImage freezer_closed_img = global.images.getImage("features/freezer_closed.png");
    float display_w = 0.4 * this.display_height * float(freezer_closed_img.width) / freezer_closed_img.height;
    PImage fridge_closed_img = global.images.getImage("features/fridge_closed.png");
    float fridge_display_h = display_w * float(fridge_closed_img.height) / fridge_closed_img.width;
    this.offset = min(0, 0.6 * this.display_height - fridge_display_h);
    translate(0, this.offset);
    if (fridge.opened) {
      imageMode(CORNER);
      float left_side = 0.5 * (this.display_width - display_w);
      PImage open_img = global.images.getImage("features/fridge_opened.png");
      float open_display_w = 1.1285 * fridge_display_h * float(open_img.width) / open_img.height;
      image(open_img, left_side, 0.4 * this.display_height, open_display_w, 1.1285 * fridge_display_h);
    }
    if (freezer.opened) {
      imageMode(CORNER);
      float left_side = 0.5 * (this.display_width - display_w);
      PImage open_img = global.images.getImage("features/freezer_opened.png");
      float open_display_w = 1.14935 * 0.4 * this.display_height * float(open_img.width) / open_img.height;
      image(open_img, left_side, - 0.14935 * 0.4 * this.display_height, open_display_w, 1.14935 * 0.4 * this.display_height);
      this.freezer_sound_left -= time_elapsed;
      if (this.freezer_sound_left < 10) {
        global.sounds.trigger_environment("features/freezer_ambience");
        this.freezer_sound_left = 3250;
      }
    }
    super.update(time_elapsed, false);
    if (!fridge.opened) {
      imageMode(CORNER);
      image(fridge_closed_img, 0.5 * (this.display_width - display_w), 0.4 * this.display_height, display_w, fridge_display_h);
    }
    if (!freezer.opened) {
      imageMode(CORNER);
      image(freezer_closed_img, 0.5 * (this.display_width - display_w), 0, display_w, 0.4 * this.display_height);
      global.sounds.silence_environment("features/freezer_ambience");
      this.freezer_sound_left = 0;
    }
    this.fridge.update(time_elapsed);
    this.freezer.update(time_elapsed);
    translate(0, -this.offset);
  }

  @Override
  void mouseMove(float mX, float mY) {
    mY -= this.offset;
    super.mouseMove(mX, mY);
    this.fridge.mouseMove(mX, mY);
    this.freezer.mouseMove(mX, mY);
  }

  @Override
  void mousePress() {
    super.mousePress();
    this.fridge.mousePress();
    this.freezer.mousePress();
  }

  @Override
  void mouseRelease(float mX, float mY) {
    super.mouseRelease(mX, mY);
    this.fridge.mouseRelease(mX, mY);
    this.freezer.mouseRelease(mX, mY);
  }
}


class WasherInventory extends Inventory {
  class WasherButton extends RectangleButton {
    protected boolean opened = false;
    WasherButton() {
      super(0, 0, 0, 0);
      this.setColors(color(1, 0), color(1, 0), color(120, 30), color(120, 30), color(1, 0));
      this.noStroke();
      this.force_left_button = false;
    }

    void hover() {}
    void click() {
      if (this.opened) {
        this.opened = false;
        WasherInventory.this.slots.get(5).deactivated = true;
        WasherInventory.this.slots.get(6).deactivated = true;
        WasherInventory.this.slots.get(9).deactivated = true;
        WasherInventory.this.slots.get(10).deactivated = true;
        this.moveButton(2 * WasherInventory.this.button_size, 0);
        global.sounds.trigger_environment("features/washer_close");
      }
      else {
        this.opened = true;
        WasherInventory.this.slots.get(5).deactivated = false;
        WasherInventory.this.slots.get(6).deactivated = false;
        WasherInventory.this.slots.get(9).deactivated = false;
        WasherInventory.this.slots.get(10).deactivated = false;
        this.moveButton(-2 * WasherInventory.this.button_size, 0);
        global.sounds.trigger_environment("features/washer_open");
      }
      this.hovered = false;
      this.clicked = false;
    }
    void dehover() {}
    void release() {}
  }

  protected WasherButton button = new WasherButton();

  WasherInventory() {
    super(4, 4, true);
    this.deactivateSlots();
    this.setButtonSize(this.button_size);
  }

  @Override
  void setButtonSize(float button_size) {
    super.setButtonSize(button_size);
    this.button.setLocation(2 + button_size, 2 + button_size, 2 + 3 * button_size, 2 + 3 * button_size);
    if (this.button.opened) {
      this.button.moveButton(-2 * button_size, 0);
    }
  }

  @Override
  void update(int millis) {
    if (button.opened) {
      imageMode(CORNER);
      PImage open_img = global.images.getImage("features/washer_opened.png");
      PImage closed_img = global.images.getImage("features/washer_closed.png");
      float right_side = 0.5 * this.display_height * (1 + float(closed_img.width) / closed_img.height);
      float display_w = this.display_width * float(open_img.width) / open_img.height;
      image(open_img, right_side - display_w, 0, display_w, this.display_height);
    }
    super.update(millis, false);
    if (!button.opened) {
      imageMode(CENTER);
      PImage closed_img = global.images.getImage("features/washer_closed.png");
      float display_w = this.display_height * float(closed_img.width) / closed_img.height;
      image(closed_img, 0.5 * this.display_width, 0.5 * this.display_height, display_w, this.display_height);
    }
    this.button.update(millis);
  }

  @Override
  void mouseMove(float mX, float mY) {
    super.mouseMove(mX, mY);
    this.button.mouseMove(mX, mY);
  }

  @Override
  void mousePress() {
    super.mousePress();
    this.button.mousePress();
  }

  @Override
  void mouseRelease(float mX, float mY) {
    super.mouseRelease(mX, mY);
    this.button.mouseRelease(mX, mY);
  }
}


class DryerInventory extends Inventory {
  class DryerButton extends RectangleButton {
    protected boolean opened = false;
    DryerButton() {
      super(0, 0, 0, 0);
      this.setColors(color(1, 0), color(1, 0), color(120, 30), color(120, 30), color(1, 0));
      this.noStroke();
      this.force_left_button = false;
    }

    void hover() {}
    void click() {
      if (this.opened) {
        this.opened = false;
        DryerInventory.this.slots.get(5).deactivated = true;
        DryerInventory.this.slots.get(6).deactivated = true;
        DryerInventory.this.slots.get(9).deactivated = true;
        DryerInventory.this.slots.get(10).deactivated = true;
        this.moveButton(-2 * DryerInventory.this.button_size, 0);
        global.sounds.trigger_environment("features/dryer_close");
      }
      else {
        this.opened = true;
        DryerInventory.this.slots.get(5).deactivated = false;
        DryerInventory.this.slots.get(6).deactivated = false;
        DryerInventory.this.slots.get(9).deactivated = false;
        DryerInventory.this.slots.get(10).deactivated = false;
        this.moveButton(2 * DryerInventory.this.button_size, 0);
        global.sounds.trigger_environment("features/dryer_open");
      }
      this.hovered = false;
      this.clicked = false;
    }
    void dehover() {}
    void release() {}
  }

  protected DryerButton button = new DryerButton();

  DryerInventory() {
    super(4, 4, true);
    this.deactivateSlots();
    this.setButtonSize(this.button_size);
  }

  @Override
  void setButtonSize(float button_size) {
    super.setButtonSize(button_size);
    this.button.setLocation(2 + button_size, 2 + button_size, 2 + 3 * button_size, 2 + 3 * button_size);
    if (this.button.opened) {
      this.button.moveButton(2 * button_size, 0);
    }
  }

  @Override
  void update(int millis) {
    PImage closed_img = global.images.getImage("features/dryer_closed.png");
    float display_w = this.display_height * float(closed_img.width) / closed_img.height;
    if (button.opened) {
      imageMode(CORNER);
      PImage open_img = global.images.getImage("features/dryer_opened.png");
      float left_side = 0.5 * (this.display_width - display_w);
      float open_display_w = this.display_width * float(open_img.width) / open_img.height;
      image(open_img, left_side, 0, open_display_w, this.display_height);
    }
    super.update(millis, false);
    if (!button.opened) {
      imageMode(CENTER);
      image(closed_img, 0.5 * this.display_width, 0.5 * this.display_height, display_w, this.display_height);
    }
    this.button.update(millis);
  }

  @Override
  void mouseMove(float mX, float mY) {
    super.mouseMove(mX, mY);
    this.button.mouseMove(mX, mY);
  }

  @Override
  void mousePress() {
    super.mousePress();
    this.button.mousePress();
  }

  @Override
  void mouseRelease(float mX, float mY) {
    super.mouseRelease(mX, mY);
    this.button.mouseRelease(mX, mY);
  }
}


class MicrowaveInventory extends Inventory {
  class MicrowaveButton extends RectangleButton {
    protected boolean opened = false;
    MicrowaveButton() {
      super(0, 0, 0, 0);
      this.setColors(color(1, 0), color(1, 0), color(120, 30), color(120, 30), color(1, 0));
      this.noStroke();
      this.force_left_button = false;
    }

    void hover() {}
    void click() {
      if (this.opened) {
        this.opened = false;
        MicrowaveInventory.this.slots.get(4).deactivated = true;
        this.setXLocation(-MicrowaveInventory.this.button_size + MicrowaveInventory.
          this.image_offset, 2 + 2 * MicrowaveInventory.this.button_size +
          MicrowaveInventory.this.image_offset);
        global.sounds.trigger_environment("features/microwave_close");
      }
      else {
        this.opened = true;
        MicrowaveInventory.this.slots.get(4).deactivated = false;
        this.setXLocation(-1.5 * MicrowaveInventory.this.button_size +
          MicrowaveInventory.this.image_offset, -0.5 * MicrowaveInventory.
          this.button_size + MicrowaveInventory.this.image_offset);
        global.sounds.trigger_environment("features/microwave_open");
      }
      this.hovered = false;
      this.clicked = false;
    }
    void dehover() {}
    void release() {}
  }

  protected MicrowaveButton button = new MicrowaveButton();
  protected float image_offset = 0;

  MicrowaveInventory() {
    super(3, 3, true);
    this.deactivateSlots();
    this.setButtonSize(this.button_size);
  }

  @Override
  void setButtonSize(float button_size) {
    super.setButtonSize(button_size);
    this.image_offset = 0.5 * button_size;
    this.button.setLocation(-button_size + this.image_offset, 2, 2 + 2 *
      button_size + this.image_offset, 2 + 3 * button_size);
    if (this.button.opened) {
      this.button.setLocation(-1.5 * button_size + this.image_offset, 2, -0.5 *
        button_size + this.image_offset, 2 + 3 * button_size);
    }
  }

  @Override
  void update(int millis) {
    PImage opened_img = global.images.getImage("features/microwave_opened.png");
    PImage closed_img = global.images.getImage("features/microwave_closed.png");
    float closed_display_w = this.display_height * float(closed_img.width) / closed_img.height;
    float opened_display_w = closed_display_w * float(opened_img.width) / closed_img.width;
    float right_side = 0.5 * (this.display_width + closed_display_w);
    if (button.opened) {
      imageMode(CORNERS);
      float display_h = this.display_height * float(opened_img.height) / closed_img.height;
      image(opened_img, right_side - opened_display_w + this.image_offset, 0,
        right_side + this.image_offset, display_h);
    }
    super.update(millis, false);
    if (!button.opened) {
      imageMode(CORNERS);
      image(closed_img, right_side - closed_display_w + this.image_offset, 0,
        right_side + this.image_offset, this.display_height);
    }
    this.button.update(millis);
  }

  @Override
  void mouseMove(float mX, float mY) {
    super.mouseMove(mX, mY);
    this.button.mouseMove(mX, mY);
  }

  @Override
  void mousePress() {
    super.mousePress();
    this.button.mousePress();
  }

  @Override
  void mouseRelease(float mX, float mY) {
    super.mouseRelease(mX, mY);
    this.button.mouseRelease(mX, mY);
  }
}


class GarbageInventory extends Inventory {
  protected int drop_time = 100;
  GarbageInventory() {
    super(4, 1, true);
  }

  @Override
  void update(int timeElapsed) {
    super.update(timeElapsed);
    this.drop_time -= timeElapsed;
    if (this.drop_time < 0) {
      this.drop_time += 100;
      this.makeItemsFall();
    }
  }

  @Override
  void mouseMove(float mX, float mY) {
    super.mouseMove(mX, mY);
    this.dehoverBottomItems();
  }

  @Override
  void mouseRelease(float mX, float mY) {
    super.mouseRelease(mX, mY);
    this.dehoverBottomItems();
  }

  void makeItemsFall() {
    for (int i = 0; i < this.slots.size() - 1; i++) {
      if (this.slots.get(i).item != null && this.slots.get(i+1).item == null) {
        this.slots.get(i+1).item = this.slots.get(i).item;
        this.slots.get(i).item = null;
        i++;
      }
    }
  }

  void dehoverBottomItems() {
    boolean found_item = false;
    for (int i = 0; i < this.slots.size(); i++) {
      if (found_item) {
        this.slots.get(i).button.hovered = false;
      }
      else if (this.slots.get(i).item != null) {
        found_item = true;
      }
    }
  }
}


class RecycleInventory extends GarbageInventory {
  RecycleInventory() {
    super();
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


class WorkbenchInventory extends Inventory {
  class CraftButton extends RectangleButton {
    protected int craft_timer = 0;

    CraftButton() {
      super(0, 0, 0, 0);
      this.disabled = true;
      this.show_message = true;
      this.force_left_button = false;
      this.message = "Craft";
      this.use_time_elapsed = true;
      this.noStroke();
      this.setColors(color(170, 170), color(1, 0), color(200, 100), color(200,
        200), color(0));
    }

    @Override
    void update(int timeElapsed) {
      super.update(timeElapsed);
      if (this.clicked && mouseButton == RIGHT) {
        this.craft_timer -= timeElapsed;
        if (this.craft_timer < 0) {
          this.craft_timer = Constants.hero_multicraftTimer;
          this.release();
        }
      }
    }

    void dehover() {}
    void hover() {}
    void click() {
      this.craft_timer = Constants.hero_multicraftTimer;
    }
    void release() {
      if (!this.hovered) {
        return;
      }
      if (WorkbenchInventory.this.craftable_item == null) {
        return;
      }
      WorkbenchInventory.this.craft();
    }
  }


  class ToolsButton extends RectangleButton {
    class ToolsButtonTextBox extends TextBox {
      ToolsButtonTextBox() {
        super(0, 0, 0, 0);
        this.setTitleSize(19);
        this.setTextSize(17);
        this.color_background = global.color_nameDisplayed_background;
        this.color_header = global.color_nameDisplayed_background;
        this.color_stroke = color(1, 0);
        this.color_text = color(255);
        this.color_title = color(255);
        this.scrollbar.setButtonColors(color(170),
          adjust_color_brightness(global.color_nameDisplayed_background, 1.1),
          adjust_color_brightness(global.color_nameDisplayed_background, 1.2),
          adjust_color_brightness(global.color_nameDisplayed_background, 0.95), color(0));
        this.scrollbar.button_upspace.setColors(color(1, 0), color(1, 0),
          color(1, 0), color(0), color(0));
        this.scrollbar.button_downspace.setColors(color(1, 0), color(1, 0),
          color(1, 0), color(0), color(0));
        this.useElapsedTime();
      }
    }

    protected ToolsButtonTextBox description = new ToolsButtonTextBox();

    ToolsButton() {
      super(0, 0, 0, 0);
      this.show_message = true;
      this.force_left_button = false;
      this.message = "Tools";
      this.use_time_elapsed = true;
      this.noStroke();
      this.setColors(color(170, 170), color(1, 0), color(200, 100), color(200, 200), color(0));
    }

    void update(int timeElapsed) {
      super.update(timeElapsed);
      if (this.hovered) {
        String message_text = "";
        if (WorkbenchInventory.this.slots.get(4).item != null) {
          message_text += WorkbenchInventory.this.slots.get(4).item.display_name() + " Will Add:";
          for (ToolCode code : ToolCode.toolCodesFrom(WorkbenchInventory.this.slots.get(4).item)) {
            message_text += "\n - " + code.displayName();
          }
          message_text += "\n\n";
        }
        if (WorkbenchInventory.this.crafting_recipe != null) {
          message_text += "Tools Needed:";
          for (ToolCode code : WorkbenchInventory.this.crafting_recipe.tools) {
            message_text += "\n - " + code.displayName();
          }
          message_text += "\n\n";
        }
        message_text += "Tools Have:";
        for (ToolCode code : WorkbenchInventory.this.tool_list) {
          message_text += "\n - " + code.displayName();
        }
        String title_text = "Workbench";
        if (WorkbenchInventory.this.craftable_item != null) {
          title_text = WorkbenchInventory.this.craftable_item.display_name();
        }
        textSize(this.description.text_size);
        float description_width = max(Constants.feature_workbenchMinimumToolsButtonWidth, textWidth(title_text) + 2);
        this.description.setXLocation(this.xf - description_width, this.xf);
        float description_height = textAscent() + textDescent() + 6;
        this.description.setTitleText(title_text);
        this.description.setText(message_text);
        description_height += (2 + this.description.text_lines.size()) *
          (textAscent() + textDescent() + this.description.text_leading);
        this.description.setYLocation(this.yi - description_height, this.yi);
        this.description.update(timeElapsed);
      }
    }

    void dehover() {
      this.message = "Tools";
    }
    void hover() {
      if (WorkbenchInventory.this.slots.get(4).item != null) {
        this.message = "Add\nTool";
      }
    }
    void click() {}
    void release() {
      if (!this.hovered) {
        return;
      }
      Item i = WorkbenchInventory.this.slots.get(4).item;
      if (i == null || i.remove) {
        return;
      }
      ArrayList<ToolCode> codes = ToolCode.toolCodesFrom(i);
      boolean has_all = true;
      for (ToolCode code : codes) {
        if (!WorkbenchInventory.this.tool_list.contains(code)) {
          has_all = false;
          WorkbenchInventory.this.tool_list.add(code);
          break;
        }
      }
      if (has_all) {
        return;
      }
      WorkbenchInventory.this.setDescriptionFromTools();
      WorkbenchInventory.this.slots.get(4).item = null;
      i.remove = true;
    }
  }


  private int curr_crafting_hash_code = 0;
  private Item craftable_item = null;
  private CraftingRecipe crafting_recipe = null;
  private boolean craftable_item_hovered = false;
  protected float last_mX = 0;
  protected float last_mY = 0;
  private CraftButton craft = new CraftButton();
  private ToolsButton tools = new ToolsButton();
  private ArrayList<ToolCode> tool_list = new ArrayList<ToolCode>();
  private Feature f = null;

  WorkbenchInventory(Feature f) {
    super(3, 6, true);
    this.f = f;
    this.deactivateSlots();
    this.slots.get(0).deactivated = false;
    this.slots.get(1).deactivated = false;
    this.slots.get(2).deactivated = false;
    this.slots.get(4).deactivated = false;
    this.slots.get(6).deactivated = false;
    this.slots.get(7).deactivated = false;
    this.slots.get(8).deactivated = false;
    this.slots.get(12).deactivated = false;
    this.slots.get(13).deactivated = false;
    this.slots.get(14).deactivated = false;
  }


  void setToolsFromDescription(String description) {
    this.tool_list.clear();
    for (String s : split(description, ',')) {
      ToolCode code = ToolCode.toolCodeFrom(trim(s));
      if (code != null) {
        this.tool_list.add(code);
      }
    }
  }

  void setDescriptionFromTools() {
    String description = "Tools Available: ";
    boolean first = true;
    for (ToolCode code : this.tool_list) {
      if (first) {
        first = false;
      }
      else {
        description += ", ";
      }
      description += code.displayName();
    }
    this.f.setDescription(description);
  }


  void craft() {
    if (this.craftable_item == null) {
      return;
    }
    if (this.slots.get(11).item != null && (this.slots.get(11).item.ID !=
      this.craftable_item.ID || this.slots.get(11).item.maxStack() - this.
      slots.get(11).item.stack < this.craftable_item.stack)) {
      return;
    }
    if (!this.crafting_recipe.hasTools(this.tool_list)) {
      return;
    }
    this.slots.get(0).removeStack();
    this.slots.get(1).removeStack();
    this.slots.get(2).removeStack();
    this.slots.get(6).removeStack();
    this.slots.get(7).removeStack();
    this.slots.get(8).removeStack();
    this.slots.get(12).removeStack();
    this.slots.get(13).removeStack();
    this.slots.get(14).removeStack();
    if (this.slots.get(11).item == null) {
      this.slots.get(11).item = new Item(this.craftable_item);
    }
    else {
      this.slots.get(11).item.addStack(this.craftable_item.stack);
    }
    this.slots.get(11).deactivated = false;
    this.craftable_item = null;
  }


  @Override
  void setButtonSize(float button_size) {
    super.setButtonSize(button_size);
    this.slots.get(4).button.moveButton(0.5 * button_size, 0);
    this.craft.setLocation(2 + 3.5 * button_size, 2 + 2.1 * button_size,
      2 + 5 * button_size, 2 + 2.9 * button_size);
    this.craft.text_size = button_size * 0.35;
    this.tools.setLocation(2 + 3.5 * button_size, 2, 2 + 4.5 * button_size, 2 + button_size);
    this.tools.text_size = button_size * 0.35;
  }

  @Override
  void update(int timeElapsed) {
    if (!this.slots.get(11).deactivated && this.slots.get(11).item == null) {
      this.slots.get(11).deactivated = true;
      this.slots.get(11).button.hovered = false;
      this.slots.get(11).button.clicked = false;
    }
    super.update(timeElapsed);
    this.curr_crafting_hash_code = this.getCraftingHashCode();
    imageMode(CORNER);
    if (this.slots.get(4).item == null) {
      image(global.images.getImage("icons/tool.png"), 2 + 4.5 * this.button_size,
        2, this.button_size, this.button_size);
    }
    if (global.crafting_recipes.containsKey(this.curr_crafting_hash_code)) {
      this.crafting_recipe = global.crafting_recipes.get(this.curr_crafting_hash_code);
      this.craftable_item = new Item(this.crafting_recipe.output);
      this.craftable_item.stack = this.crafting_recipe.amount;
      this.craft.disabled = !this.crafting_recipe.hasTools(this.tool_list);
      if (this.craft.disabled) {
        image(global.images.getImage("icons/crafting_arrow_red.png"), 2 + 3.5 * this.button_size,
          2 + 1 * this.button_size, this.button_size, this.button_size);
      }
      else {
        image(global.images.getImage("icons/crafting_arrow_green.png"), 2 + 3.5 * this.button_size,
          2 + 1 * this.button_size, this.button_size, this.button_size);
      }
      image(this.craftable_item.getImage(), 2 + 5 * this.button_size,
        2 + 1 * this.button_size, this.button_size, this.button_size);
      if (this.craftable_item.stack > 1) {
        fill(255);
        textSize(14);
        textAlign(RIGHT, BOTTOM);
        text(this.craftable_item.stack, 6 * this.button_size, 2 * this.button_size);
      }
      if (this.craftable_item_hovered) {
        textSize(20);
        float rect_height = textAscent() + textDescent() + 2;
        float rect_width = textWidth(this.craftable_item.display_name()) + 2;
        rectMode(CORNER);
        fill(global.color_nameDisplayed_background);
        stroke(1, 0);
        strokeWeight(0.1);
        rect(this.last_mX - rect_width - 1, this.last_mY - rect_height - 1, rect_width, rect_height);
        fill(255);
        textAlign(LEFT, TOP);
        text(this.craftable_item.display_name(), this.last_mX - rect_width - 1, this.last_mY - rect_height - 1);
      }
    }
    else {
      this.craftable_item = null;
      this.crafting_recipe = null;
      this.craft.disable();
      image(global.images.getImage("icons/crafting_arrow.png"), 2 + 3.5 * this.button_size,
        2 + 1 * this.button_size, this.button_size, this.button_size);
    }
    this.craft.update(timeElapsed);
    this.tools.update(timeElapsed);
  }

  @Override
  void mouseMove(float mX, float mY) {
    this.last_mX = mX;
    this.last_mY = mY;
    super.mouseMove(mX, mY);
    this.craft.mouseMove(mX, mY);
    this.tools.mouseMove(mX, mY);
    if (this.craftable_item == null) {
      this.craftable_item_hovered = false;
    }
    else {
      if (mX > 2 + 5 * this.button_size && mY > 2 + 1 * this.button_size &&
        mX < 2 + 6 * this.button_size && mY < 2 + 2 * this.button_size) {
        this.craftable_item_hovered = true;
      }
      else {
        this.craftable_item_hovered = false;
      }
    }
  }

  @Override
  void mousePress() {
    super.mousePress();
    this.craft.mousePress();
    this.tools.mousePress();
  }

  @Override
  void mouseRelease(float mX, float mY) {
    super.mouseRelease(mX, mY);
    this.craft.mouseRelease(mX, mY);
    this.tools.mouseRelease(mX, mY);
  }

  @Override
  int getCraftingHashCode() {
    int[][] item_grid = new int[3][3];
    if (this.slots.get(0).item != null) {
      item_grid[0][0] = this.slots.get(0).item.ID;
    }
    if (this.slots.get(1).item != null) {
      item_grid[0][1] = this.slots.get(1).item.ID;
    }
    if (this.slots.get(2).item != null) {
      item_grid[0][2] = this.slots.get(2).item.ID;
    }
    if (this.slots.get(6).item != null) {
      item_grid[1][0] = this.slots.get(6).item.ID;
    }
    if (this.slots.get(7).item != null) {
      item_grid[1][1] = this.slots.get(7).item.ID;
    }
    if (this.slots.get(8).item != null) {
      item_grid[1][2] = this.slots.get(8).item.ID;
    }
    if (this.slots.get(12).item != null) {
      item_grid[2][0] = this.slots.get(12).item.ID;
    }
    if (this.slots.get(13).item != null) {
      item_grid[2][1] = this.slots.get(13).item.ID;
    }
    if (this.slots.get(14).item != null) {
      item_grid[2][2] = this.slots.get(14).item.ID;
    }
    return Arrays.deepHashCode(reduceItemGrid(item_grid));
  }
}


class EnderChestInventory extends Inventory {
  EnderChestInventory() {
    super(3, 4, true);
  }
}


class SmallKeyringInventory extends Inventory {
  SmallKeyringInventory() {
    super(3, 3, true);
    this.slots.get(4).deactivated = true;
  }

  @Override
  Item stash(Item i) {
    if (!i.key()) {
      return i;
    }
    return super.stash(i);
  }

  @Override
  Item placeAt(Item i, int index, boolean replace, boolean ignore_deactivate) {
    if (!i.key()) {
      return i;
    }
    return super.placeAt(i, index, replace, ignore_deactivate);
  }

  @Override
  void drawBackground() {
    super.drawBackground();
    imageMode(CORNER);
    image(global.images.getImage("items/small_keyring.png"), 2, 2, 3 * this.button_size, 3 * this.button_size);
  }
}


class LargeKeyringInventory extends Inventory {
  LargeKeyringInventory() {
    super(6, 6, true);
    this.slots.get(0).deactivated = true;
    this.slots.get(5).deactivated = true;
    this.slots.get(9).deactivated = true;
    this.slots.get(10).deactivated = true;
    this.slots.get(14).deactivated = true;
    this.slots.get(15).deactivated = true;
    this.slots.get(16).deactivated = true;
    this.slots.get(20).deactivated = true;
    this.slots.get(21).deactivated = true;
    this.slots.get(22).deactivated = true;
    this.slots.get(30).deactivated = true;
    this.slots.get(35).deactivated = true;
  }

  @Override
  Item stash(Item i) {
    if (!i.key()) {
      return i;
    }
    return super.stash(i);
  }

  @Override
  Item placeAt(Item i, int index, boolean replace, boolean ignore_deactivate) {
    if (!i.key()) {
      return i;
    }
    return super.placeAt(i, index, replace, ignore_deactivate);
  }

  @Override
  void drawBackground() {
    super.drawBackground();
    imageMode(CORNER);
    image(global.images.getImage("items/large_keyring.png"), 2, 2, 6 * this.button_size, 6 * this.button_size);
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
