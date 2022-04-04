enum HeroCode {
  ERROR, BEN, DAN, JF, SPINNY, MATTUS, PATRICK;

  private static final List<HeroCode> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  public String display_name() {
    return HeroCode.display_name(this);
  }
  static public String display_name(HeroCode code) {
    switch(code) {
      case BEN:
        return "Ben Nelson";
      case DAN:
        return "Daniel Gray";
      case JF:
        return "John-Francis";
      case SPINNY:
        return "Mark Spinny";
      case MATTUS:
        return "Mad Dog Mattus";
      case PATRICK:
        return "Patrick Rolwes";
      default:
        return "-- Error --";
    }
  }

  public String file_name() {
    return HeroCode.file_name(this);
  }
  static public String file_name(HeroCode code) {
    switch(code) {
      case BEN:
        return "BEN";
      case DAN:
        return "DAN";
      case JF:
        return "JF";
      case SPINNY:
        return "SPINNY";
      case MATTUS:
        return "MATTUS";
      case PATRICK:
        return "PATRICK";
      default:
        return "ERROR";
    }
  }

  public int unit_id() {
    return HeroCode.unit_id(this);
  }
  static public int unit_id(HeroCode code) {
    switch(code) {
      case BEN:
        return 1101;
      case DAN:
        return 1102;
      case JF:
        return 1103;
      case SPINNY:
        return 1104;
      case MATTUS:
        return 1105;
      case PATRICK:
        return 1106;
      default:
        return 1100;
    }
  }

  static public HeroCode heroCode(String display_name) {
    for (HeroCode code : HeroCode.VALUES) {
      if (code == HeroCode.ERROR) {
        continue;
      }
      if (HeroCode.display_name(code).equals(display_name) ||
        HeroCode.file_name(code).equals(display_name)) {
        return code;
      }
    }
    return ERROR;
  }

  static public HeroCode heroCodeFromId(int id) {
    switch(id) {
      case 1101:
        return HeroCode.BEN;
      case 1102:
        return HeroCode.DAN;
      case 1103:
        return HeroCode.JF;
      case 1104:
        return HeroCode.SPINNY;
      case 1105:
        return HeroCode.MATTUS;
      case 1106:
        return HeroCode.PATRICK;
      default:
        return HeroCode.ERROR;
    }
  }
}



enum InventoryLocation {
  INVENTORY, GEAR, FEATURE, CRAFTING;
}



class Hero extends Unit {

  class GearInventory extends Inventory {
    GearInventory() {
      super(4, 3, true);
    }

    Item getItem(int index) {
      switch(index) {
        case 0:
          return Hero.this.gear.get(GearSlot.HAND_THIRD);
        case 1:
          return Hero.this.gear.get(GearSlot.HEAD);
        case 2:
          return Hero.this.gear.get(GearSlot.HAND_FOURTH);
        case 3:
          return Hero.this.gear.get(GearSlot.WEAPON);
        case 4:
          return Hero.this.gear.get(GearSlot.CHEST);
        case 5:
          return Hero.this.gear.get(GearSlot.OFFHAND);
        case 6:
          return Hero.this.gear.get(GearSlot.BELT_RIGHT);
        case 7:
          return Hero.this.gear.get(GearSlot.LEGS);
        case 8:
          return Hero.this.gear.get(GearSlot.BELT_LEFT);
        case 9:
          return Hero.this.gear.get(GearSlot.FEET_SECOND);
        case 10:
          return Hero.this.gear.get(GearSlot.FEET);
        case 11:
          return Hero.this.gear.get(GearSlot.FEET_THIRD);
        default:
          global.errorMessage("ERROR: Gear inventory index " + index + " out of range.");
          return null;
      }
    }

    void setItem(int index, Item i) {
      switch(index) {
        case 0:
          Hero.this.gear.put(GearSlot.HAND_THIRD, i);
          break;
        case 1:
          Hero.this.gear.put(GearSlot.HEAD, i);
          break;
        case 2:
          Hero.this.gear.put(GearSlot.HAND_FOURTH, i);
          break;
        case 3:
          Hero.this.gear.put(GearSlot.WEAPON, i);
          break;
        case 4:
          Hero.this.gear.put(GearSlot.CHEST, i);
          break;
        case 5:
          Hero.this.gear.put(GearSlot.OFFHAND, i);
          break;
        case 6:
          Hero.this.gear.put(GearSlot.BELT_RIGHT, i);
          break;
        case 7:
          Hero.this.gear.put(GearSlot.LEGS, i);
          break;
        case 8:
          Hero.this.gear.put(GearSlot.BELT_LEFT, i);
          break;
        case 9:
          Hero.this.gear.put(GearSlot.FEET_SECOND, i);
          break;
        case 10:
          Hero.this.gear.put(GearSlot.FEET, i);
          break;
        case 11:
          Hero.this.gear.put(GearSlot.FEET_THIRD, i);
          break;
        default:
          global.errorMessage("ERROR: Gear inventory index " + index + " out of range.");
          break;
      }
    }

    @Override
    Item placeAt(Item i, int index, boolean replace) {
      if (index < 0 || index >= this.slots.size()) {
        return i;
      }
      if (this.getItem(index) == null) {
        this.setItem(index, i);
        return null;
      }
      else if (replace) {
        Item replaced = new Item(this.getItem(index));
        this.setItem(index, i);
        return replaced;
      }
      return i;
    }

    @Override
    void update(int millis) {
      rectMode(CORNER);
      fill(this.color_background);
      noStroke();
      rect(0, 0, this.display_width, this.display_height);
      imageMode(CORNERS);
      for (Map.Entry<GearSlot, Item> entry : Hero.this.gear.entrySet()) {
        switch(entry.getKey()) {
          case WEAPON:
            this.updateSlot(millis, 3, entry.getValue());
            break;
          case HEAD:
            this.updateSlot(millis, 1, entry.getValue());
            break;
          case CHEST:
            this.updateSlot(millis, 4, entry.getValue());
            break;
          case LEGS:
            this.updateSlot(millis, 7, entry.getValue());
            break;
          case FEET:
            this.updateSlot(millis, 10, entry.getValue());
            break;
        }
      }
    }

    void updateSlot(int millis, int index, Item i) {
      int x = index % this.max_cols;
      if (x < 0 || x >= this.max_cols) {
        return;
      }
      int y = index / this.max_cols;
      if (y < 0 || y >= this.max_rows) {
        return;
      }
      this.slots.get(index).item = i;
      translate(2 + x * this.button_size, 2 + y * this.button_size);
      this.slots.get(index).update(millis);
      if (this.slots.get(index).item == null) {
        String iconName = "icons/";
        switch(index) {
          case 0:
            iconName += "";
            break;
          case 1:
            iconName += "head.png";
            break;
          case 2:
            iconName += "";
            break;
          case 3:
            iconName += "hand_inverted.png";
            break;
          case 4:
            iconName += "chest.png";
            break;
          case 5:
            iconName += "hand.png";
            break;
          case 6:
            iconName += "";
            break;
          case 7:
            iconName += "legs.png";
            break;
          case 8:
            iconName += "";
            break;
          case 9:
            iconName += "";
            break;
          case 10:
            iconName += "feet.png";
            break;
          case 11:
            iconName += "";
            break;
          default:
            global.errorMessage("ERROR: Gear inventory index " + index + " out of range.");
            break;
        }
        image(global.images.getImage(iconName), 0, 0, this.button_size, this.button_size);
      }
      translate(-2 - x * this.button_size, -2 - y * this.button_size);
    }

    @Override
    void mouseMove(float mX, float mY) {
      for (int x = 0; x < this.max_cols; x++) {
        for (int y = 0; y < this.max_rows; y++) {
          int i = y * this.max_cols + x;
          if (i >= this.slots.size()) {
            break;
          }
          if (!this.slotActive(i)) {
            continue;
          }
          this.slots.get(i).mouseMove(mX - 2 - x * this.button_size, mY - 2 - y * this.button_size);
        }
      }
    }

    boolean slotActive(int index) {
      switch(index) {
        case 0:
          return Hero.this.gear.containsKey(GearSlot.HAND_THIRD);
        case 1:
          return Hero.this.gear.containsKey(GearSlot.HEAD);
        case 2:
          return Hero.this.gear.containsKey(GearSlot.HAND_FOURTH);
        case 3:
          return Hero.this.gear.containsKey(GearSlot.WEAPON);
        case 4:
          return Hero.this.gear.containsKey(GearSlot.CHEST);
        case 5:
          return Hero.this.gear.containsKey(GearSlot.OFFHAND);
        case 6:
          return Hero.this.gear.containsKey(GearSlot.BELT_RIGHT);
        case 7:
          return Hero.this.gear.containsKey(GearSlot.LEGS);
        case 8:
          return Hero.this.gear.containsKey(GearSlot.BELT_LEFT);
        case 9:
          return Hero.this.gear.containsKey(GearSlot.FEET_SECOND);
        case 10:
          return Hero.this.gear.containsKey(GearSlot.FEET);
        case 11:
          return Hero.this.gear.containsKey(GearSlot.FEET_THIRD);
        default:
          return false;
      }
    }
  }

  class HeroInventory extends Inventory {

    class InventoryKey {
      private InventoryLocation location;
      private int index;
      InventoryKey(InventoryLocation location, int index) {
        this.location = location;
        this.index = index;
      }
    }

    protected Item item_holding = null;
    protected InventoryKey item_origin = null;
    protected Item item_dropping = null;

    protected GearInventory gear_inventory = new GearInventory();
    protected Inventory feature_inventory = null;
    // protected CraftingInventory crafting_inventory = new CraftingInventory(1, 1); // unlock 1,1 first then 1,2 (or 2,1) then 2,2

    protected float last_mX = 0;
    protected float last_mY = 0;
    protected boolean viewing = false;

    HeroInventory() {
      super(Constants.hero_inventoryMaxRows, Constants.hero_inventoryMaxCols, false);
      this.setSlots(Hero.this.inventoryStartSlots());
      this.setButtonSize(Constants.hero_defaultInventoryButtonSize);
    }


    void dropItemHolding() {
      if (this.item_holding == null) {
        return;
      }
      if (this.item_origin == null) {
        this.item_dropping = this.item_holding;
      }
      else {
        switch(this.item_origin.location) {
          case INVENTORY:
            this.item_dropping = this.placeAt(this.item_holding, this.item_origin.index);
            break;
          case GEAR:
            this.item_dropping = this.gear_inventory.placeAt(this.item_holding, this.item_origin.index);
            break;
          case FEATURE:
            if (this.feature_inventory == null) {
              this.item_dropping = this.item_holding;
            }
            else {
              this.item_dropping = this.feature_inventory.placeAt(this.item_holding, this.item_origin.index);
            }
            break;
          case CRAFTING:
            break;
        }
      }
      this.item_holding = null;
      this.item_origin = null;
    }


    @Override
    void setButtonSize(float button_size) {
      super.setButtonSize(button_size);
      if (this.gear_inventory != null) {
        this.gear_inventory.setButtonSize(button_size);
      }
      if (this.feature_inventory != null) {
        this.feature_inventory.setButtonSize(button_size);
      }
    }


    @Override
    void update(int millis) {
      // main inventory
      super.update(millis);
      // gear
      float gearInventoryTranslateX = - this.gear_inventory.display_width - 2;
      float gearInventoryTranslateY = 0.5 * (this.display_height - this.gear_inventory.display_height);
      translate(gearInventoryTranslateX, gearInventoryTranslateY);
      this.gear_inventory.update(millis);
      translate(-gearInventoryTranslateX, -gearInventoryTranslateY);
      // feature
      if (this.feature_inventory != null) {
        float featureInventoryTranslateX = 0.5 * (this.display_width - this.feature_inventory.display_width);
        float featureInventoryTranslateY = - this.feature_inventory.display_height - 2;
        translate(featureInventoryTranslateX, featureInventoryTranslateY);
        this.feature_inventory.update(millis);
        translate(-featureInventoryTranslateX, -featureInventoryTranslateY);
      }
      // item holding
      if (this.item_holding != null) {
        imageMode(CENTER);
        image(this.item_holding.getImage(), this.item_holding.x, this.item_holding.y,
          this.button_size, this.button_size);
      }
    }

    @Override
    void mouseMove(float mX, float mY) {
      // item holding
      if (this.item_holding != null) {
        this.item_holding.x += mX - this.last_mX;
        this.item_holding.y += mY - this.last_mY;
      }
      this.last_mX = mX;
      this.last_mY = mY;
      // main inventory
      super.mouseMove(mX, mY);
      // gear
      float gearInventoryTranslateX = - this.gear_inventory.display_width - 2;
      float gearInventoryTranslateY = 0.5 * (this.display_height - this.gear_inventory.display_height);
      this.gear_inventory.mouseMove(mX - gearInventoryTranslateX, mY - gearInventoryTranslateY);
      // feature
      if (this.feature_inventory != null) {
        float featureInventoryTranslateX = 0.5 * (this.display_width - this.feature_inventory.display_width);
        float featureInventoryTranslateY = - this.feature_inventory.display_height - 2;
        this.feature_inventory.mouseMove(mX - featureInventoryTranslateX, mY - featureInventoryTranslateY);
      }
    }

    @Override
    void mousePress() {
      super.mousePress();
      if (this.feature_inventory != null) {
        this.feature_inventory.mousePress();
      }
      switch(mouseButton) {
        case LEFT:
          break;
        case RIGHT:
          break;
        case CENTER:
          break;
      }
      // main inventory
      boolean found_clicked = false;
      for (int x = 0; x < this.max_cols; x++) {
        for (int y = 0; y < this.max_rows; y++) {
          int i = y * this.max_cols + x;
          if (i >= this.slots.size()) {
            break;
          }
          this.slots.get(i).mousePress();
          if (this.slots.get(i).button.clicked) {
            if (this.item_holding == null) {
              this.item_holding = new Item(this.slots.get(i).item);
              this.item_origin = new InventoryKey(InventoryLocation.INVENTORY, i);
              this.slots.get(i).item = null;
              if (this.item_holding != null) {
                this.item_holding.x = 2 + (x + 0.5) * this.button_size;
                this.item_holding.y = 2 + (y + 0.5) * this.button_size;
              }
            }
            else {
              // drop parts of item holding
            }
            found_clicked = true;
            break;
          }
        }
      }
      // gear
      if (found_clicked) {
        return;
      }
      for (int x = 0; x < this.gear_inventory.max_cols; x++) {
        for (int y = 0; y < this.gear_inventory.max_rows; y++) {
          int i = y * this.gear_inventory.max_cols + x;
          if (i >= this.gear_inventory.slots.size()) {
            break;
          }
          if (!this.gear_inventory.slotActive(i)) {
            continue;
          }
          this.gear_inventory.slots.get(i).mousePress();
          if (this.gear_inventory.slots.get(i).button.clicked) {
            if (this.item_holding == null) {
              this.item_holding = new Item(this.gear_inventory.getItem(i));
              this.item_origin = new InventoryKey(InventoryLocation.GEAR, i);
              this.gear_inventory.setItem(i, null);
              if (this.item_holding != null) {
                this.item_holding.x = (x + 0.5) * this.button_size - this.gear_inventory.display_width;
                this.item_holding.y = 0.5 * (this.display_height - this.
                  gear_inventory.display_height) + 2 + (y + 0.5) * this.button_size;
              }
            }
            else {
              // drop parts of item holding
            }
            found_clicked = true;
            break;
          }
        }
      }
      // feature
      if (found_clicked) {
        return;
      }
      if (this.feature_inventory != null) {
        for (int x = 0; x < this.feature_inventory.max_cols; x++) {
          for (int y = 0; y < this.feature_inventory.max_rows; y++) {
            int i = y * this.feature_inventory.max_cols + x;
            if (i >= this.feature_inventory.slots.size()) {
              break;
            }
            this.feature_inventory.slots.get(i).mousePress();
            if (this.feature_inventory.slots.get(i).button.clicked) {
              if (this.item_holding == null) {
                this.item_holding = new Item(this.feature_inventory.slots.get(i).item);
                this.item_origin = new InventoryKey(InventoryLocation.FEATURE, i);
                this.feature_inventory.slots.get(i).item = null;
                if (this.item_holding != null) {
                  this.item_holding.x = 0.5 * (this.display_width - this.
                    feature_inventory.display_width) + 2 + (x + 0.5) * this.button_size;
                  this.item_holding.y = (y + 0.5) * this.button_size - this.feature_inventory.display_height;
                }
              }
              else {
                // drop parts of item holding
              }
              found_clicked = true;
              break;
            }
          }
        }
      }
    }

    @Override
    void mouseRelease(float mX, float mY) {
      // process latest hovered information
      super.mouseRelease(mX, mY);
      float gearInventoryTranslateX = - this.gear_inventory.display_width - 2;
      float gearInventoryTranslateY = 0.5 * (this.display_height - this.gear_inventory.display_height);
      this.gear_inventory.mouseRelease(mX - gearInventoryTranslateX, mY - gearInventoryTranslateY);
      if (this.feature_inventory != null) {
        float featureInventoryTranslateX = 0.5 * (this.display_width - this.feature_inventory.display_width);
        float featureInventoryTranslateY = - this.feature_inventory.display_height - 2;
        this.feature_inventory.mouseRelease(mX - featureInventoryTranslateX, mY - featureInventoryTranslateY);
      }
      // process item holding
      if (this.item_holding == null) {
        return;
      }
      // main inventory
      boolean found_hovered = false;
      for (int i = 0; i < this.slots.size(); i++) {
        if (this.slots.get(i).button.hovered) {
          this.item_holding = this.placeAt(this.item_holding, i, true);
          found_hovered = true;
          this.dropItemHolding();
          break;
        }
      }
      // gear
      if (found_hovered) {
        return;
      }
      for (int i = 0; i < this.gear_inventory.slots.size(); i++) {
        if (!this.gear_inventory.slotActive(i)) {
          continue;
        }
        if (this.gear_inventory.slots.get(i).button.hovered) {
          this.item_holding = this.gear_inventory.placeAt(this.item_holding, i, true);
          found_hovered = true;
          this.dropItemHolding();
          break;
        }
      }
      // feature
      if (found_hovered) {
        return;
      }
      if (this.feature_inventory != null) {
        for (int i = 0; i < this.feature_inventory.slots.size(); i++) {
          if (this.feature_inventory.slots.get(i).button.hovered) {
            this.item_holding = this.feature_inventory.placeAt(this.item_holding, i, true);
            found_hovered = true;
            this.dropItemHolding();
            break;
          }
        }
      }
      if (!found_hovered) {
        this.dropItemHolding();
      }
    }
  }


  protected HeroCode code;

  protected Location location = Location.ERROR;

  protected int hunger = 100;
  protected int thirst = 100;

  protected HeroInventory inventory = new HeroInventory();

  Hero(int ID) {
    super(ID);
    this.code = HeroCode.heroCodeFromId(ID);
  }
  Hero(HeroCode code) {
    super(HeroCode.unit_id(code));
    this.code = code;
  }


  int inventoryStartSlots() {
    return Constants.hero_inventoryDefaultStartSlots;
  }


  void update_hero(int millis) {
    if (this.inventory.viewing) {
      float inventoryTranslateX = 0.5 * (width - this.inventory.display_width);
      float inventoryTranslateY = 0.5 * (height - this.inventory.display_height);
      translate(inventoryTranslateX, inventoryTranslateY);
      this.inventory.update(millis);
      translate(-inventoryTranslateX, -inventoryTranslateY);
    }
  }

  void mouseMove_hero(float mX, float mY) {
    if (this.inventory.viewing) {
      float inventoryTranslateX = 0.5 * (width - this.inventory.display_width);
      float inventoryTranslateY = 0.5 * (height - this.inventory.display_height);
      this.inventory.mouseMove(mX - inventoryTranslateX, mY - inventoryTranslateY);
    }
  }

  void mousePress_hero() {
    if (this.inventory.viewing) {
      this.inventory.mousePress();
    }
  }

  void mouseRelease_hero(float mX, float mY) {
    if (this.inventory.viewing) {
      float inventoryTranslateX = 0.5 * (width - this.inventory.display_width);
      float inventoryTranslateY = 0.5 * (height - this.inventory.display_height);
      this.inventory.mouseRelease(mX - inventoryTranslateX, mY - inventoryTranslateY);
    }
  }

  void scroll_hero(int amount) {
    // scroll through inventory bar if available
  }

  void keyPress_hero() {
    if (key == CODED) {
      switch(keyCode) {
        default:
          break;
      }
    }
    else {
      switch(key) {
        case 'w':
        case 'W':
          if (this.weapon() != null) {
            this.gear.put(GearSlot.WEAPON, this.inventory.stash(this.weapon()));
          }
          break;
        case 'e':
        case 'E':
          this.inventory.viewing = !this.inventory.viewing;
          if (!this.inventory.viewing) {
            // return item clicked item
          }
          break;
        default:
          break;
      }
    }
  }

  void keyRelease_hero() {
    if (key == CODED) {
      switch(keyCode) {
        default:
          break;
      }
    }
    else {
      switch(key) {
        default:
          break;
      }
    }
  }
}
