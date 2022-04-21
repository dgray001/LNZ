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



enum LeftPanelMenuPage {
  NONE, PLAYER; // others in future as game becomes more complex
}



enum InventoryLocation {
  INVENTORY, GEAR, FEATURE, CRAFTING;
  private static final List<InventoryLocation> VALUES = Collections.unmodifiableList(Arrays.asList(values()));
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
    void update(int timeElapsed) {
      rectMode(CORNER);
      fill(this.color_background);
      noStroke();
      rect(0, 0, this.display_width, this.display_height);
      imageMode(CORNERS);
      for (Map.Entry<GearSlot, Item> entry : Hero.this.gear.entrySet()) {
        switch(entry.getKey()) {
          case WEAPON:
            this.updateSlot(timeElapsed, 3, entry.getValue());
            break;
          case HEAD:
            this.updateSlot(timeElapsed, 1, entry.getValue());
            break;
          case CHEST:
            this.updateSlot(timeElapsed, 4, entry.getValue());
            break;
          case LEGS:
            this.updateSlot(timeElapsed, 7, entry.getValue());
            break;
          case FEET:
            this.updateSlot(timeElapsed, 10, entry.getValue());
            break;
        }
      }
    }

    void updateSlot(int timeElapsed, int index, Item i) {
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
      this.slots.get(index).update(timeElapsed);
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

  class InventoryKey {
    private InventoryLocation location;
    private int index;
    InventoryKey(InventoryLocation location, int index) {
      this.location = location;
      this.index = index;
    }
  }

  class HeroInventory extends Inventory {
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


    InventoryKey itemLocation(int item_id) {
      InventoryKey location = null;
      for (InventoryLocation invLocation : InventoryLocation.VALUES) {
        location = this.itemLocation(item_id, invLocation);
        if (location != null) {
          break;
        }
      }
      return location;
    }
    InventoryKey itemLocation(int item_id, InventoryLocation invLocation) {
      switch(invLocation) {
        case INVENTORY:
          for (int i = 0; i < this.slots.size(); i++) {
            if (this.slots.get(i).item != null && this.slots.get(i).item.ID == item_id) {
              return new InventoryKey(InventoryLocation.INVENTORY, i);
            }
          }
          break;
        case GEAR:
          for (int i = 0; i < this.gear_inventory.slots.size(); i++) {
            if (this.gear_inventory.slots.get(i).item != null
              && this.gear_inventory.slots.get(i).item.ID == item_id) {
              return new InventoryKey(InventoryLocation.GEAR, i);
            }
          }
          break;
        case FEATURE:
          if (this.feature_inventory == null) {
            break;
          }
          for (int i = 0; i < this.feature_inventory.slots.size(); i++) {
            if (this.feature_inventory.slots.get(i).item != null &&
              this.feature_inventory.slots.get(i).item.ID == item_id) {
              return new InventoryKey(InventoryLocation.FEATURE, i);
            }
          }
          break;
        case CRAFTING:
          break;
      }
      return null;
    }


    void featureInventory(Inventory feature_inventory) {
      this.feature_inventory = feature_inventory;
      this.setButtonSize(this.button_size);
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
    void update(int timeElapsed) {
      // main inventory
      super.update(timeElapsed);
      // gear
      float gearInventoryTranslateX = - this.gear_inventory.display_width - 2;
      float gearInventoryTranslateY = 0.5 * (this.display_height - this.gear_inventory.display_height);
      translate(gearInventoryTranslateX, gearInventoryTranslateY);
      this.gear_inventory.update(timeElapsed);
      translate(-gearInventoryTranslateX, -gearInventoryTranslateY);
      // feature
      if (this.feature_inventory != null) {
        float featureInventoryTranslateX = 0.5 * (this.display_width - this.feature_inventory.display_width);
        float featureInventoryTranslateY = - this.feature_inventory.display_height - 2;
        translate(featureInventoryTranslateX, featureInventoryTranslateY);
        this.feature_inventory.update(timeElapsed);
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


  class InventoryBar {
    class StatusEffectTextBox extends TextBox {
      private boolean display = false;
      StatusEffectTextBox() {
        super(0, 0, 0, 0);
        this.setTitleSize(15);
        this.setTextSize(13);
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

    private float xi_border = 0;
    private float yi = 0;
    private float xf_border = 0;
    private float yf = 0;
    private float xi_bar = 0;
    private float xf_bar = 0;
    private float xi_picture = 0;
    private float yi_picture = 0;
    private float xf_picture = 0;
    private float yf_picture = 0;
    private float radius_picture = 0;
    private float ability_width = 0;
    private float slot_width = 0;
    private float status_width = 0;
    private float yi_status = 0;

    private float last_mX = 0;
    private float last_mY = 0;
    private StatusEffectCode code_hovered = null;
    private StatusEffectTextBox code_description = new StatusEffectTextBox();

    private boolean portrait_hovered = false;
    private boolean portrait_clicked = false;

    protected color color_background = color(210, 153, 108);
    protected color color_ability_border = color(120, 70, 40);

    InventoryBar() {
      this.setHeight(Constants.hero_defaultInventoryBarHeight);
    }

    void setHeight(float new_height) {
      this.yf = height - Constants.hero_inventoryBarGap;
      this.yi = this.yf - new_height;
      this.xf_bar = 0.5 * (width + 3.333 * new_height);
      this.xi_bar = 0.5 * (width - 3.333 * new_height);
      this.xf_border = this.xi_bar - Constants.hero_inventoryBarGap;
      this.xi_border = this.xf_border - new_height;
      float border_thickness = 0.04166667 * new_height;
      this.xi_picture = this.xi_border + border_thickness;
      this.yi_picture = this.yi + border_thickness;
      this.xf_picture = this.xf_border - border_thickness;
      this.yf_picture = this.yf - border_thickness;
      this.radius_picture = 0.5 * (this.xf_picture - this.xi_picture);
      this.ability_width = 0.2 * (this.xf_bar - this.xi_bar) - 4;
      this.status_width = 0.08 * (this.xf_bar - this.xi_bar);
      this.yi_status = this.yi - 2 - this.status_width;
    }

    PImage getBorderImage() {
      String imageName = "icons/border";
      switch(Hero.this.code) {
        case BEN:
          imageName += "_gray.png";
          break;
        default:
          imageName += "_template.png";
          break;
      }
      return global.images.getImage(imageName);
    }

    PImage getHeroImage() {
      String imageName = "units/";
      switch(Hero.this.code) {
        case BEN:
          imageName += "ben_circle.png";
          break;
        default:
          imageName += "default.png";
          break;
      }
      return global.images.getImage(imageName);
    }

    void update(int timeElapsed) {
      rectMode(CORNERS);
      noStroke();
      fill(this.color_background);
      rect(this.xi_bar, this.yi, this.xf_bar, this.yf, 12);
      imageMode(CORNERS);
      image(this.getBorderImage(), this.xi_border, this.yi, this.xf_border, this.yf);
      if (this.portrait_clicked) {
        tint(150);
      }
      image(this.getHeroImage(), this.xi_picture, this.yi_picture, this.xf_picture, this.yf_picture);
      if (this.portrait_clicked) {
        g.removeCache(this.getHeroImage());
        noTint();
      }
      float xi = this.xi_bar + 2;
      float yi = this.yf - this.ability_width - 4;
      imageMode(CORNER);
      ellipseMode(CENTER);
      for (int i = 0; i < Constants.hero_abilityNumber; i++, xi += this.ability_width + 4) {
        rectMode(CORNER);
        fill(0);
        strokeWeight(2);
        stroke(this.color_ability_border);
        rect(xi, yi, this.ability_width, this.ability_width, 10);
        //image(ability border)
        if (Hero.this.abilities.get(i) != null) {
          Ability a = Hero.this.abilities.get(i);
          image(a.getImage(), xi, yi, this.ability_width, this.ability_width);
          if (a.timer_cooldown > 0) {
            fill(100, 100, 255, 140);
            noStroke();
            try {
              float angle = -HALF_PI + 2 * PI * a.timer_cooldown / a.timer_cooldown();
              arc(xi + 0.5 * this.ability_width, yi + 0.5 * this.ability_width,
                this.ability_width, this.ability_width, -HALF_PI, angle, PIE);
            } catch(Exception e) {}
          }
        }
      }
      xi = this.xi_bar;
      this.code_hovered = null;
      for (Map.Entry<StatusEffectCode, StatusEffect> entry : Hero.this.statuses.entrySet()) {
        imageMode(CORNER);
        rectMode(CORNER);
        ellipseMode(CENTER);
        fill(255, 150);
        stroke(0);
        strokeWeight(1);
        rect(xi, this.yi_status, this.status_width, this.status_width);
        image(global.images.getImage(entry.getKey().getImageString()), xi, this.yi_status, this.status_width, this.status_width);
        if (!entry.getValue().permanent) {
          fill(100, 100, 255, 140);
          noStroke();
          try {
            float angle = -HALF_PI + 2 * PI * entry.getValue().timer_gone / entry.getValue().timer_gone_start;
            arc(xi + 0.5 * this.status_width, this.yi_status + 0.5 * this.status_width,
              this.status_width, this.status_width, -HALF_PI, angle, PIE);
          } catch(Exception e) {}
        }
        if (this.last_mX > xi && this.last_mX < xi + this.status_width &&
          this.last_mY > this.yi_status && this.last_mY < this.yi_status + this.status_width) {
          if (!this.code_description.display) {
            noStroke();
            fill(global.color_nameDisplayed_background);
            textSize(14);
            float rect_height = textAscent() + textDescent() + 2;
            float rect_width = textWidth(entry.getKey().code_name()) + 2;
            rect(this.last_mX - rect_width - 1, this.last_mY - rect_height - 1, rect_width, rect_height);
            fill(255);
            textAlign(LEFT, TOP);
            text(entry.getKey().code_name(), this.last_mX - rect_width - 1, this.last_mY - rect_height - 1);
          }
          this.code_hovered = entry.getKey();
        }
        if (this.code_description.display) {
          this.code_description.update(timeElapsed);
        }
        xi += this.status_width + 2;
      }
    }

    void mouseMove(float mX, float mY) {
      this.last_mX = mX;
      this.last_mY = mY;
      if (this.code_description.display) {
        this.code_description.mouseMove(mX, mY);
      }
      if ((this.code_hovered == null || !this.code_hovered.code_name().equals(
        this.code_description.text_title)) && !this.code_description.hovered) {
        this.code_description.display = false;
      }
      float portrait_distance_x = mX - this.xi_picture - this.radius_picture;
      float portrait_distance_y = mY - this.yi_picture - this.radius_picture;
      if (sqrt(portrait_distance_x * portrait_distance_x + portrait_distance_y * portrait_distance_y) < this.radius_picture) {
        this.portrait_hovered = true;
      }
      else {
        this.portrait_hovered = false;
      }
    }

    void mousePress() {
      if (this.code_description.display) {
        this.code_description.mousePress();
      }
      if (this.code_hovered == null && !this.code_description.hovered) {
        this.code_description.display = false;
      }
      else if (code_hovered != null) {
        this.code_description.display = true;
        this.code_description.setLocation(this.last_mX - Constants.hero_statusDescription_width,
          this.last_mY - Constants.hero_statusDescription_height, this.last_mX, this.last_mY);
        this.code_description.setTitleText(this.code_hovered.code_name());
        this.code_description.setText(this.code_hovered.description());
      }
      if (this.portrait_hovered) {
        this.portrait_clicked = true;
      }
      // click ability for more info
      // click item to select (in left panel)
    }

    void mouseRelease(float mX, float mY) {
      if (this.code_description.display) {
        this.code_description.mouseRelease(mX, mY);
      }
      if (this.portrait_hovered && this.portrait_clicked) {
        Hero.this.openLeftPanelMenu(LeftPanelMenuPage.PLAYER);
      }
      this.portrait_clicked = false;
    }

    void scroll(int amount) {
      if (this.code_description.display) {
        this.code_description.scroll(amount);
      }
    }
  }


  abstract class LeftPanelMenu {
    LeftPanelMenu() {
    }
    Hero hero() {
      return Hero.this;
    }
    abstract void drawPanel(int timeElapsed, float panel_width);
    abstract void mouseMove(float mX, float mY);
    abstract void mousePress();
    abstract void mouseRelease(float mX, float mY);
  }


  class PlayerLeftPanelMenu extends LeftPanelMenu {
    abstract class LeftPanelButton extends RectangleButton {
      protected float hover_timer = Constants.hero_leftPanelButtonHoverTimer;
      protected boolean show_hover_message = false;
      protected String hover_message = "";
      protected float hover_message_text_size = 15;
      protected float hover_message_offset = 0;

      LeftPanelButton(float xi, float yi, float xf, float yf) {
        super(xi, yi, xf, yf);
        textSize(15);
        this.hover_message_offset = 0.5 * (textAscent() + textDescent()) + 2;
      }

      @Override
      void update(int millis) {
        int time_elapsed = millis - this.lastUpdateTime;
        super.update(millis);
        if (this.show_hover_message) {
          fill(global.color_nameDisplayed_background);
          stroke(1, 0);
          rectMode(CENTER);
          textSize(this.hover_message_text_size);
          float xCenter = mouseX + 0.5 * textWidth(this.hover_message + 2);
          float yCenter = mouseY - this.hover_message_offset;
          rect(xCenter, yCenter, textWidth(this.hover_message + 2), textAscent() + textDescent());
          textAlign(CENTER, CENTER);
          fill(255);
          text(this.hover_message, xCenter, yCenter);
          stroke(0);
        }
        else if (this.hovered) {
          this.hover_timer -= time_elapsed;
          if (this.hover_timer < 0) {
            this.show_hover_message = true;
          }
        }
      }

      void hover() {
        this.updateHoverMessage();
      }
      void dehover() {
        this.hover_timer = Constants.hero_leftPanelButtonHoverTimer;
        this.show_hover_message = false;
      }
      void click() {
        this.updateHoverMessage();
        this.show_hover_message = true;
      }
      void release() {}

      abstract void updateHoverMessage();
    }

    class LevelButton extends LeftPanelButton {
      LevelButton(float yi, float yf) {
        super(0, yi, 0, yf);
        this.setColors(color(100, 100), color(1, 0), color(1, 0), color(1, 0), color(0));
        this.text_size = 18;
        this.show_message = true;
        this.noStroke();
      }

      void updateHoverMessage() {
        this.hover_message = "Tier: " + PlayerLeftPanelMenu.this.hero().tier();
      }
    }


    class ExperienceButton extends LeftPanelButton {
      ExperienceButton(float yi, float yf) {
        super(0, yi, 0, yf);
        this.setColors(color(1, 0), color(1, 0), color(1, 0), color(1, 0), color(1, 0));
        this.setStroke(color(0), 1.5);
        this.roundness = 0;
      }

      @Override
      void drawButton() {
        super.drawButton();
        rectMode(CORNER);
        float xp_ratio = PlayerLeftPanelMenu.this.hero().experience /
          PlayerLeftPanelMenu.this.hero().experience_next_level;
        fill(0);
        rect(this.xi, this.yi, xp_ratio * this.button_width(), Constants.hero_leftPanelBarHeight);
      }

      void updateHoverMessage() {
        this.hover_message = "Experience: " + PlayerLeftPanelMenu.this.hero().experience +
          "/" + PlayerLeftPanelMenu.this.hero().experience_next_level;
      }
    }


    class HungerButton extends LeftPanelButton {
      protected float bar_xi = 0;
      protected float bar_yi = 0;
      protected float bar_yf = 0;

      HungerButton(float yi, float yf) {
        super(0, yi, 0, yf);
        this.setColors(color(1, 0), color(1, 0), color(1, 0), color(1, 0), color(1, 0));
        this.noStroke();
        this.roundness = 0;
        this.bar_xi = 4 + 2 * Constants.hero_leftPanelBarHeight;
        this.bar_yi = yi + 0.25 * (yf - yi);
        this.bar_yf = yi + 0.75 * (yf - yi);
      }

      @Override
      void drawButton() {
        super.drawButton();
        imageMode(CORNERS);
        image(global.images.getImage("icons/hunger.png"), this.xi, this.yi,
          this.bar_xi - 2, this.yf);
        rectMode(CORNERS);
        fill(255, 0, 0);
        noStroke();
        rect(this.bar_xi, this.bar_yi, this.xf, this.bar_yf);
        rectMode(CORNER);
        float hunger_ratio = PlayerLeftPanelMenu.this.hero().hunger / float(Constants.hero_maxHunger);
        fill(0, 255, 0);
        rect(this.bar_xi, this.bar_yi, hunger_ratio * (this.xf - this.bar_xi), Constants.hero_leftPanelBarHeight);
      }

      void updateHoverMessage() {
        this.hover_message = "Hunger: " + int(100 * PlayerLeftPanelMenu.this.hero().hunger /
          float(Constants.hero_maxHunger)) + "%";
      }
    }


    class ThirstButton extends LeftPanelButton {
      protected float bar_xi = 0;
      protected float bar_yi = 0;
      protected float bar_yf = 0;

      ThirstButton(float yi, float yf) {
        super(0, yi, 0, yf);
        this.setColors(color(1, 0), color(1, 0), color(1, 0), color(1, 0), color(1, 0));
        this.noStroke();
        this.roundness = 0;
        this.bar_xi = 4 + 2 * Constants.hero_leftPanelBarHeight;
        this.bar_yi = yi + 0.25 * (yf - yi);
        this.bar_yf = yi + 0.75 * (yf - yi);
      }

      @Override
      void drawButton() {
        super.drawButton();
        imageMode(CORNERS);
        image(global.images.getImage("icons/thirst.png"), this.xi, this.yi,
          this.bar_xi - 2, this.yf);
        rectMode(CORNERS);
        fill(255, 0, 0);
        noStroke();
        rect(this.bar_xi, this.bar_yi, this.xf, this.bar_yf);
        rectMode(CORNER);
        float thirst_ratio = PlayerLeftPanelMenu.this.hero().thirst / float(Constants.hero_maxThirst);
        fill(0, 255, 0);
        rect(this.bar_xi, this.bar_yi, thirst_ratio * (this.xf - this.bar_xi), Constants.hero_leftPanelBarHeight);
      }

      void updateHoverMessage() {
        this.hover_message = "Thirst: " + int(100 * PlayerLeftPanelMenu.this.hero().thirst /
          float(Constants.hero_maxThirst)) + "%";
      }
    }


    protected float yi;
    protected float image_yi;
    protected float image_size;
    protected LevelButton level;
    protected ExperienceButton experience;
    protected HungerButton hunger;
    protected ThirstButton thirst;

    PlayerLeftPanelMenu() {
      this.yi = 0.5 * height + Constants.map_selectedObjectPanelGap;
      textSize(Constants.map_selectedObjectTitleTextSize);
      float currY = this.yi + textAscent() + textDescent() + Constants.map_selectedObjectPanelGap;
      this.image_yi = currY;
      this.image_size = 0.1 * height;
      currY += image_size + Constants.map_selectedObjectPanelGap;
      textSize(18);
      this.level = new LevelButton(currY, currY + textAscent() + textDescent() + Constants.map_selectedObjectPanelGap);
      currY += textAscent() + textDescent() + Constants.map_selectedObjectPanelGap;
      this.experience = new ExperienceButton(currY, currY + Constants.hero_leftPanelBarHeight);
      currY += 2 * Constants.hero_leftPanelBarHeight + Constants.map_selectedObjectPanelGap;
      this.hunger = new HungerButton(currY, currY + 2 * Constants.hero_leftPanelBarHeight);
      currY += 2 * Constants.hero_leftPanelBarHeight + Constants.map_selectedObjectPanelGap;
      this.thirst = new ThirstButton(currY, currY + 2 * Constants.hero_leftPanelBarHeight);
      currY += Constants.hero_leftPanelBarHeight + Constants.map_selectedObjectPanelGap;
    }

    void drawPanel(int millis, float panel_width) {
      // name
      fill(255);
      textSize(Constants.map_selectedObjectTitleTextSize);
      textAlign(CENTER, TOP);
      text(Hero.this.display_name(), 0.5 * panel_width, this.yi);
      // picture
      imageMode(CORNER);
      image(Hero.this.getImage(), 1, this.image_yi, this.image_size, this.image_size);
      // level
      this.level.message = "Level " + Hero.this.level;
      this.level.setXLocation(2, panel_width - 2);
      this.level.update(millis);
      // experience
      this.experience.setXLocation(2, panel_width - 2);
      this.experience.update(millis);
      // hunger
      this.hunger.setXLocation(2, panel_width - 2);
      this.hunger.update(millis);
      // thirst
      this.thirst.setXLocation(2, panel_width - 2);
      this.thirst.update(millis);
    }

    void mouseMove(float mX, float mY) {
      this.level.mouseMove(mX, mY);
      this.experience.mouseMove(mX, mY);
      this.hunger.mouseMove(mX, mY);
      this.thirst.mouseMove(mX, mY);
    }

    void mousePress() {
      this.level.mousePress();
      this.experience.mousePress();
      this.hunger.mousePress();
      this.thirst.mousePress();
    }

    void mouseRelease(float mX, float mY) {
      this.level.mouseRelease(mX, mY);
      this.experience.mouseRelease(mX, mY);
      this.hunger.mouseRelease(mX, mY);
      this.thirst.mouseRelease(mX, mY);
    }
  }


  protected HeroCode code;

  protected Location location = Location.ERROR;

  protected int level_tokens = 0;
  protected float experience = 0;
  protected int experience_next_level = 1;
  protected float money = 20;
  protected float base_mana = 0;
  protected float curr_mana = 0;
  protected int hunger = 100;
  protected int thirst = 100;
  protected int hunger_timer = Constants.hero_hungerTimer;
  protected int thirst_timer = Constants.hero_thirstTimer;

  protected LeftPanelMenu left_panel_menu = new PlayerLeftPanelMenu();
  protected HeroInventory inventory = new HeroInventory();
  protected InventoryBar inventory_bar = new InventoryBar();

  protected Queue<String> messages = new LinkedList<String>();

  Hero(int ID) {
    super(ID);
    this.code = HeroCode.heroCodeFromId(ID);
    this.addAbilities();
  }
  Hero(HeroCode code) {
    super(HeroCode.unit_id(code));
    this.code = code;
    this.addAbilities();
    this.level = 100;
  }


  void openLeftPanelMenu(LeftPanelMenuPage menu) {
    switch(menu) {
      case PLAYER:
        this.left_panel_menu = new PlayerLeftPanelMenu();
        break;
      default:
        this.left_panel_menu = null;
        break;
    }
  }


  void addAbilities() {
    this.addAbilities(false);
  }
  void addAbilities(boolean powerful_version) {
    for (int i = 0; i < Constants.hero_abilityNumber; i++) {
      this.abilities.add(null);
    }
  }

  void activateAbility(int index) {
    if (index < 0 || index >= this.abilities.size()) {
      global.log("WARNING: Trying to activate ability index " + index + " but it doesn't exist.");
      return;
    }
    int ability_id = 2 * Constants.hero_abilityNumber * (this.ID - 1101) + index + 101;
    this.abilities.set(index, new Ability(ability_id));
  }

  void updgradeAbility(int index) {
    if (index < 0 || index >= this.abilities.size()) {
      global.log("WARNING: Trying to upgrade ability index " + index + " but it doesn't exist.");
      return;
    }
    Ability a = this.abilities.get(index);
    if (a == null) {
      global.log("WARNING: Trying to upgrade a null ability.");
      return;
    }
    if (a.ID % 10 > 5) {
      global.log("WARNING: Trying to upgrade a tier II ability.");
      return;
    }
    int upgraded_ability_id = a.ID + 5;
    a = new Ability(upgraded_ability_id);
  }


  void refreshExperienceNextLevel() {
    if (this.level == Constants.hero_maxLevel) {
      this.experience_next_level = 0;
      return;
    }
    this.experience_next_level = int(ceil(pow(
      this.level * Constants.hero_experienceNextLevel_level *
      (1 + (this.tier() - 1) * Constants.hero_experienceNextLevel_tier),
    Constants.hero_experienceNextLevel_power) + 1));
  }


  String manaDisplayName() {
    switch(this.code) {
      case BEN:
        return "% Rage";
      default:
        return "Error";
    }
  }


  @Override
  float currMana() {
    return this.curr_mana;
  }

  float mana() {
    switch(this.code) {
      case BEN:
        return 100;
      default:
        break;
    }
    float mana = this.base_mana;
    return mana;
  }


  int inventoryStartSlots() {
    return Constants.hero_inventoryDefaultStartSlots;
  }


  void addExperience(int amount) {
    if (this.level == Constants.hero_maxLevel) {
      return;
    }
    this.experience += amount;
    while(this.experience > this.experience_next_level) {
      this.experience -= this.experience_next_level;
      this.levelup();
      if (this.level == Constants.hero_maxLevel) {
        break;
      }
    }
  }


  void levelup() {
    this.level++;
    this.refreshExperienceNextLevel();
    this.level_tokens += this.level;
  }


  @Override
  void killed(Unit u) {
    super.killed(u);
    this.addExperience(int(ceil(1 + pow(u.level, Constants.hero_killExponent))));
  }


  @Override
  void useItem(GameMap map) {
    if (this.weapon() == null || !this.weapon().usable()) {
      return;
    }
    if (this.weapon().consumable()) {
      this.heal(this.weapon().curr_health);
      this.increaseHunger(this.weapon().hunger);
      this.increaseThirst(this.weapon().thirst);
      this.money += this.weapon().money;
      this.weapon().consumed();
      return;
    }
    if (this.weapon().reloadable()) {
      while(this.weapon().maximumAmmo() - this.weapon().availableAmmo() > 0) {
        ArrayList<Integer> possible_ammo = this.weapon().possibleAmmo();
        boolean noAmmo = true;
        for (int id : possible_ammo) {
          InventoryKey ammoLocation = this.inventory.itemLocation(id, InventoryLocation.INVENTORY);
          if (ammoLocation != null) {
            Item ammo = this.inventory.slots.get(ammoLocation.index).item;
            int ammoLoaded = min(this.weapon().maximumAmmo() - this.weapon().availableAmmo(), ammo.stack);
            ammo.removeStack(ammoLoaded);
            this.weapon().ammo += ammoLoaded;
            noAmmo = false;
            break;
          }
        }
        if (noAmmo) {
          break;
        }
      }
      return;
    }
    if (this.weapon().money()) {
      // deposit if can
      return;
    }
    if (this.weapon().utility()) {
      switch(this.weapon().ID) {
        case 2924: // water bottles
        case 2925:
        case 2926:
        case 2927:
          int thirst_quenched = min(100 - this.thirst, this.weapon().ammo);
          this.weapon().ammo -= thirst_quenched;
          this.increaseThirst(thirst_quenched);
          break;
      }
      return;
    }
    global.log("WARNING: Trying to use item " + this.weapon().display_name() + " but no logic exists to use it.");
  }


  @Override
  ArrayList<Item> drops() {
    ArrayList<Item> drops = super.drops();
    for (Item i : this.inventory.items()) {
      drops.add(i);
    }
    return drops;
  }


  void drawLeftPanel(int timeElapsed, float panel_width) {
    if (this.left_panel_menu != null) {
      this.left_panel_menu.drawPanel(timeElapsed, panel_width);
    }
  }


  void hungerTick() {
    this.decreaseHunger(1);
    this.hunger_timer = Constants.hero_hungerTimer;
  }

  void thirstTick() {
    this.decreaseThirst(1);
    this.thirst_timer = Constants.hero_thirstTimer;
  }

  void increaseHunger(int amount) {
    this.changeHunger(amount);
  }

  void decreaseHunger(int amount) {
    this.changeHunger(-amount);
  }

  void changeHunger(int amount) {
    this.hunger += amount;
    if (this.hunger > 100) {
      this.hunger = 100;
    }
    else if (this.hunger < 0) {
      this.hunger = 0;
    }
  }

  void increaseThirst(int amount) {
    this.changeThirst(amount);
  }

  void decreaseThirst(int amount) {
    this.changeThirst(-amount);
  }

  void changeThirst(int amount) {
    this.thirst += amount;
    if (this.thirst > 100) {
      this.thirst = 100;
    }
    else if (this.thirst < 0) {
      this.thirst = 0;
    }
  }

  @Override
  void increaseMana(int amount) {
    this.changeMana(amount);
  }

  @Override
  void decreaseMana(int amount) {
    this.changeMana(-amount);
  }

  void changeMana(int amount) {
    this.curr_mana += amount;
    if (this.curr_mana < 0) {
      this.curr_mana = 0;
    }
    else if (this.curr_mana > this.mana()) {
      this.curr_mana = this.mana();
    }
  }


  void update_hero(int timeElapsed) {
    this.hunger_timer -= timeElapsed;
    if (this.hunger_timer < 0) {
      this.hungerTick();
    }
    this.thirst_timer -= timeElapsed;
    if (this.thirst_timer < 0) {
      this.thirstTick();
    }
    this.inventory_bar.update(timeElapsed);
    if (this.inventory.viewing) {
      float inventoryTranslateX = 0.5 * (width - this.inventory.display_width);
      float inventoryTranslateY = 0.5 * (height - this.inventory.display_height);
      translate(inventoryTranslateX, inventoryTranslateY);
      this.inventory.update(timeElapsed);
      translate(-inventoryTranslateX, -inventoryTranslateY);
    }
    if (this.hunger < Constants.hero_hungerThreshhold) {
      this.refreshStatusEffect(StatusEffectCode.HUNGRY, 3000);
    }
    if (this.thirst < Constants.hero_thirstThreshhold) {
      this.refreshStatusEffect(StatusEffectCode.THIRSTY, 3000);
    }
  }

  void mouseMove_hero(float mX, float mY) {
    this.inventory_bar.mouseMove(mX, mY);
    if (this.inventory.viewing) {
      float inventoryTranslateX = 0.5 * (width - this.inventory.display_width);
      float inventoryTranslateY = 0.5 * (height - this.inventory.display_height);
      this.inventory.mouseMove(mX - inventoryTranslateX, mY - inventoryTranslateY);
    }
    if (this.left_panel_menu != null) {
      this.left_panel_menu.mouseMove(mX, mY);
    }
  }

  void mousePress_hero() {
    this.inventory_bar.mousePress();
    if (this.inventory.viewing) {
      this.inventory.mousePress();
    }
    if (this.left_panel_menu != null) {
      this.left_panel_menu.mousePress();
    }
  }

  void mouseRelease_hero(float mX, float mY) {
    this.inventory_bar.mouseRelease(mX, mY);
    if (this.inventory.viewing) {
      float inventoryTranslateX = 0.5 * (width - this.inventory.display_width);
      float inventoryTranslateY = 0.5 * (height - this.inventory.display_height);
      this.inventory.mouseRelease(mX - inventoryTranslateX, mY - inventoryTranslateY);
    }
    if (this.left_panel_menu != null) {
      this.left_panel_menu.mouseRelease(mX, mY);
    }
  }

  void scroll_hero(int amount) {
    this.inventory_bar.scroll(amount);
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
            this.inventory.feature_inventory = null;
            this.inventory.dropItemHolding();
          }
          break;
        case 'r':
        case 'R':
          if (this.weapon() != null && this.weapon().usable()) {
            if (this.weapon().reloadable()) {
              ArrayList<Integer> possible_ammo = this.weapon().possibleAmmo();
              boolean noAmmo = true;
              for (int id : possible_ammo) {
                if (this.inventory.itemLocation(id, InventoryLocation.INVENTORY) != null) {
                  noAmmo = false;
                  break;
                }
              }
              if (noAmmo) {
                this.messages.add("Out of ammo");
                break;
              }
            }
            this.curr_action = UnitAction.USING_ITEM;
            this.timer_actionTime = this.weapon().useTime();
          }
          break;
        case 't':
          this.activateAbility(0);
          this.activateAbility(1);
          this.activateAbility(2);
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
