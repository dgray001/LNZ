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
  INVENTORY, FEATURE, HEADGEAR, CHESTGEAR, LEGGEAR, FOOTGEAR, WEAPON;
}



class Hero extends Unit {

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

    protected Inventory feature_inventory = null;

    protected float last_mX = 0;
    protected float last_mY = 0;
    protected boolean viewing = false;

    HeroInventory() {
      super(Constants.hero_inventoryMaxRows, Constants.hero_inventoryMaxCols, false);
      this.setSlots(Hero.this.inventoryStartSlots());
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
          case FEATURE:
            if (this.feature_inventory == null) {
              this.item_dropping = this.item_holding;
            }
            else {
              this.item_dropping = this.feature_inventory.placeAt(this.item_holding, this.item_origin.index);
            }
            break;
          case HEADGEAR:
            break;
          case CHESTGEAR:
            break;
          case LEGGEAR:
            break;
          case FOOTGEAR:
            break;
          case WEAPON:
            break;
        }
      }
      this.item_holding = null;
      this.item_origin = null;
    }


    @Override
    void update(int millis) {
      super.update(millis);
      if (this.item_holding != null) {
        imageMode(CENTER);
        image(this.item_holding.getImage(), this.item_holding.x, this.item_holding.y,
          this.button_size, this.button_size);
      }
      if (this.feature_inventory != null) {
        float featureInventoryTranslateX = 0.5 * (this.display_width - this.feature_inventory.display_width);
        float featureInventoryTranslateY = -this.feature_inventory.display_height;
        translate(featureInventoryTranslateX, featureInventoryTranslateY);
        this.feature_inventory.update(millis);
        translate(-featureInventoryTranslateX, -featureInventoryTranslateY);
      }
    }

    @Override
    void mouseMove(float mX, float mY) {
      if (this.item_holding != null) {
        this.item_holding.x += mX - this.last_mX;
        this.item_holding.y += mY - this.last_mY;
      }
      this.last_mX = mX;
      this.last_mY = mY;
      super.mouseMove(mX, mY);
      if (this.feature_inventory != null) {
        float featureInventoryTranslateX = 0.5 * (this.display_width - this.feature_inventory.display_width);
        float featureInventoryTranslateY = -this.feature_inventory.display_height;
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
      if (found_clicked) {
        return;
      }
      if (this.feature_inventory != null) {
        for (int x = 0; x < this.feature_inventory.max_cols; x++) {
          for (int y = 0; y < this.feature_inventory.max_cols; y++) {
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
                  this.item_holding.y = 2 + (y + 0.5) * this.button_size - this.feature_inventory.display_height;
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
      if (found_clicked) {
        return;
      }
    }

    @Override
    void mouseRelease(float mX, float mY) {
      super.mouseRelease(mX, mY);
      if (this.feature_inventory != null) {
        this.feature_inventory.mouseRelease(mX, mY);
      }
      if (this.item_holding == null) {
        return;
      }
      boolean found_hovered = false;
      for (int i = 0; i < this.slots.size(); i++) {
        if (this.slots.get(i).button.hovered) {
          this.item_holding = this.placeAt(this.item_holding, i, true);
          found_hovered = true;
          this.dropItemHolding();
          break;
        }
      }
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
