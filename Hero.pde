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

  public Element element() {
    return HeroCode.element(this);
  }
  static public Element element(HeroCode code) {
    switch(code) {
      case BEN:
        return Element.GRAY;
      case DAN:
        return Element.BROWN;
      case JF:
        return Element.CYAN;
      case SPINNY:
        return Element.RED;
      case MATTUS:
        return Element.MAGENTA;
      case PATRICK:
        return Element.GRAY;
      default:
        return Element.GRAY;
    }
  }

  public String title() {
    return HeroCode.title(this);
  }
  static public String title(HeroCode code) {
    switch(code) {
      case BEN:
        return "The Rage of Wisconsin";
      case DAN:
        return "The Half-Frog of Hopedale";
      case JF:
        return "";
      case SPINNY:
        return "";
      case MATTUS:
        return "";
      case PATRICK:
        return "";
      default:
        return "-- Error --";
    }
  }

  public String description() {
    return HeroCode.description(this);
  }
  static public String description(HeroCode code) {
    switch(code) {
      case BEN:
        return "Ben description";
      case DAN:
        return "Dan description";
      case JF:
        return "";
      case SPINNY:
        return "";
      case MATTUS:
        return "";
      case PATRICK:
        return "";
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

  public String getImagePath() {
    return HeroCode.getImagePath(this);
  }
  static public String getImagePath(HeroCode code) {
    String file_path = "units/";
    switch(code) {
      case BEN:
        file_path += "ben_circle.png";
        break;
      case DAN:
        file_path += "dan_circle.png";
        break;
      case JF:
        file_path += "jf_circle.png";
        break;
      case SPINNY:
        file_path += "spinny_circle.png";
        break;
      case MATTUS:
        file_path += "mattus_circle.png";
        break;
      case PATRICK:
        file_path += "patrick_circle.png";
        break;
      default:
        file_path += "default.png";
        break;
    }
    return file_path;
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



enum HeroTreeCode {
  INVENTORYI, PASSIVEI, AI, SI, DI, FI, PASSIVEII, AII, SII, DII, FII,
  HEALTHI, ATTACKI, DEFENSEI, PIERCINGI, SPEEDI, SIGHTI, TENACITYI, AGILITYI, MAGICI,
    RESISTANCEI, PENETRATIONI, HEALTHII, ATTACKII, DEFENSEII, PIERCINGII, SPEEDII,
    SIGHTII, TENACITYII, AGILITYII, MAGICII, RESISTANCEII, PENETRATIONII, HEALTHIII,
  OFFHAND, BELTI, BELTII, INVENTORYII, INVENTORY_BARI, INVENTORY_BARII,
  FOLLOWERI
  ;
  private static final List<HeroTreeCode> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  public String file_name() {
    switch(this) {
      case INVENTORYI:
        return "Inventory";
      case PASSIVEI:
        return "Passive";
      case AI:
        return "A";
      case SI:
        return "S";
      case DI:
        return "D";
      case FI:
        return "F";
      case PASSIVEII:
        return "PassiveII";
      case AII:
        return "AII";
      case SII:
        return "SII";
      case DII:
        return "DII";
      case FII:
        return "FII";
      case HEALTHI:
        return "Health";
      case ATTACKI:
        return "Attack";
      case DEFENSEI:
        return "Defense";
      case PIERCINGI:
        return "Piercing";
      case SPEEDI:
        return "Speed";
      case SIGHTI:
        return "Sight";
      case TENACITYI:
        return "Tenacity";
      case AGILITYI:
        return "Agility";
      case MAGICI:
        return "Magic";
      case RESISTANCEI:
        return "Resistance";
      case PENETRATIONI:
        return "Penetration";
      case HEALTHII:
        return "HealthII";
      case ATTACKII:
        return "AttackII";
      case DEFENSEII:
        return "DefenseII";
      case PIERCINGII:
        return "PiercingII";
      case SPEEDII:
        return "SpeedII";
      case SIGHTII:
        return "SightII";
      case TENACITYII:
        return "TenacityII";
      case AGILITYII:
        return "AgilityII";
      case MAGICII:
        return "MagicII";
      case RESISTANCEII:
        return "ResistanceII";
      case PENETRATIONII:
        return "PenetrationII";
      case HEALTHIII:
        return "HealthIII";
      case OFFHAND:
        return "Offhand";
      case BELTI:
        return "Belt";
      case BELTII:
        return "BeltII";
      case INVENTORYII:
        return "InventoryII";
      case INVENTORY_BARI:
        return "InventoryBar";
      case INVENTORY_BARII:
        return "InventoryBarII";
      case FOLLOWERI:
        return "Follower";
      default:
        return "--Error--";
    }
  }

  public static HeroTreeCode codeFromId(int id) {
    switch(id) {
      case 0:
        return HeroTreeCode.INVENTORYI;
      case 1:
        return HeroTreeCode.PASSIVEI;
      case 2:
        return HeroTreeCode.AI;
      case 3:
        return HeroTreeCode.SI;
      case 4:
        return HeroTreeCode.DI;
      case 5:
        return HeroTreeCode.FI;
      case 6:
        return HeroTreeCode.PASSIVEII;
      case 7:
        return HeroTreeCode.AII;
      case 8:
        return HeroTreeCode.SII;
      case 9:
        return HeroTreeCode.DII;
      case 10:
        return HeroTreeCode.FII;
      case 11:
        return HeroTreeCode.HEALTHI;
      case 12:
        return HeroTreeCode.ATTACKI;
      case 13:
        return HeroTreeCode.DEFENSEI;
      case 14:
        return HeroTreeCode.PIERCINGI;
      case 15:
        return HeroTreeCode.SPEEDI;
      case 16:
        return HeroTreeCode.SIGHTI;
      case 17:
        return HeroTreeCode.TENACITYI;
      case 18:
        return HeroTreeCode.AGILITYI;
      case 19:
        return HeroTreeCode.MAGICI;
      case 20:
        return HeroTreeCode.RESISTANCEI;
      case 21:
        return HeroTreeCode.PENETRATIONI;
      case 22:
        return HeroTreeCode.HEALTHII;
      case 23:
        return HeroTreeCode.ATTACKII;
      case 24:
        return HeroTreeCode.DEFENSEII;
      case 25:
        return HeroTreeCode.PIERCINGII;
      case 26:
        return HeroTreeCode.SPEEDII;
      case 27:
        return HeroTreeCode.SIGHTII;
      case 28:
        return HeroTreeCode.TENACITYII;
      case 29:
        return HeroTreeCode.AGILITYII;
      case 30:
        return HeroTreeCode.MAGICII;
      case 31:
        return HeroTreeCode.RESISTANCEII;
      case 32:
        return HeroTreeCode.PENETRATIONII;
      case 33:
        return HeroTreeCode.HEALTHIII;
      case 34:
        return HeroTreeCode.OFFHAND;
      case 35:
        return HeroTreeCode.BELTI;
      case 36:
        return HeroTreeCode.BELTII;
      case 37:
        return HeroTreeCode.INVENTORYII;
      case 38:
        return HeroTreeCode.INVENTORY_BARI;
      case 39:
        return HeroTreeCode.INVENTORY_BARII;
      case 40:
        return HeroTreeCode.FOLLOWERI;
      default:
        return HeroTreeCode.INVENTORYI;
    }
  }

  public static HeroTreeCode code(String display_name) {
    for (HeroTreeCode code : HeroTreeCode.VALUES) {
      if (code.file_name().equals(display_name)) {
        return code;
      }
    }
    return null;
  }
}



class Hero extends Unit {

  class GearInventory extends Inventory {
    GearInventory() {
      super(4, 3, true);
    }

    GearSlot indexToGearSlot(int index) {
      switch(index) {
        case 0:
          return GearSlot.HAND_THIRD;
        case 1:
          return GearSlot.HEAD;
        case 2:
          return GearSlot.HAND_FOURTH;
        case 3:
          return GearSlot.WEAPON;
        case 4:
          return GearSlot.CHEST;
        case 5:
          return GearSlot.OFFHAND;
        case 6:
          return GearSlot.BELT_RIGHT;
        case 7:
          return GearSlot.LEGS;
        case 8:
          return GearSlot.BELT_LEFT;
        case 9:
          return GearSlot.FEET_SECOND;
        case 10:
          return GearSlot.FEET;
        case 11:
          return GearSlot.FEET_THIRD;
        default:
          global.errorMessage("ERROR: Gear inventory index " + index + " out of range.");
          return GearSlot.ERROR;
      }
    }

    Item getItem(int index) {
      return Hero.this.gear.get(this.indexToGearSlot(index));
    }

    void setItem(int index, Item i) {
      Hero.this.gear.put(this.indexToGearSlot(index), i);
    }

    @Override
    Item placeAt(Item i, int index, boolean replace) {
      if (!i.equippable(this.indexToGearSlot(index))) {
        return i;
      }
      if (index < 0 || index >= this.slots.size()) {
        return i;
      }
      if (this.getItem(index) == null) {
        this.setItem(index, i);
        return null;
      }
      else if (this.getItem(index).ID == i.ID) {
        int stack_left = this.getItem(index).maxStack() - this.getItem(index).stack;
        if (i.stack > stack_left) {
          this.getItem(index).addStack(stack_left);
          i.removeStack(stack_left);
        }
        else {
          this.getItem(index).addStack(i.stack);
          return null;
        }
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
          case OFFHAND:
            this.updateSlot(timeElapsed, 5, entry.getValue());
            break;
          case BELT_LEFT:
            this.updateSlot(timeElapsed, 6, entry.getValue());
            break;
          case BELT_RIGHT:
            this.updateSlot(timeElapsed, 8, entry.getValue());
            break;
        }
      }
    }

    void updateSlot(int timeElapsed, int index, Item i) {
      this.updateSlot(timeElapsed, index, i, true, 0, true);
    }
    void updateSlot(int timeElapsed, int index, Item i, boolean translate_first, float temp_slot_width, boolean show_slot_hovered_message) {
      int x = index % this.max_cols;
      if (x < 0 || x >= this.max_cols) {
        return;
      }
      int y = index / this.max_cols;
      if (y < 0 || y >= this.max_rows) {
        return;
      }
      this.slots.get(index).item = i;
      if (translate_first) {
        translate(2 + x * this.button_size, 2 + y * this.button_size);
      }
      else {
        this.slots.get(index).setWidth(temp_slot_width);
        if (index == 3) { // hand white border
          this.slots.get(index).button.setStroke(color(255), 4);
        }
      }
      this.slots.get(index).update(timeElapsed, show_slot_hovered_message);
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
            iconName += "belt_right.png";
            break;
          case 7:
            iconName += "legs.png";
            break;
          case 8:
            iconName += "belt_left.png";
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
        image(global.images.getImage(iconName), 0, 0, this.slots.get(index).width(), this.slots.get(index).width());
      }
      if (translate_first) {
        translate(-2 - x * this.button_size, -2 - y * this.button_size);
      }
      else {
        this.slots.get(index).setWidth(this.button_size);
        if (index == 3) { // hand white border
          this.slots.get(index).button.setStroke(color(142, 75, 50), 3);
        }
      }
    }

    @Override
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
          if (!this.slotActive(i)) {
            continue;
          }
          this.slots.get(i).mouseMove(mX - 2 - x * this.button_size, mY - 2 - y * this.button_size);
        }
      }
    }

    boolean slotActive(int index) {
      return Hero.this.gear.containsKey(this.indexToGearSlot(index));
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
    protected boolean any_hovered = false;

    HeroInventory() {
      super(Constants.hero_inventoryMaxRows, Constants.hero_inventoryMaxCols, false);
      this.setSlots(Hero.this.inventoryStartSlots());
      this.setButtonSize(Constants.hero_defaultInventoryButtonSize);
    }


    void dropItemHolding() {
      if (this.item_holding == null) {
        return;
      }
      if (this.item_origin == null || !this.any_hovered) {
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


    Item getItem(InventoryKey inventory_key) {
      if (inventory_key == null) {
        return null;
      }
      switch(inventory_key.location) {
        case INVENTORY:
          try {
            return this.slots.get(inventory_key.index).item;
          } catch(Exception e) {}
          break;
        case GEAR:
          try {
            return this.gear_inventory.slots.get(inventory_key.index).item;
          } catch(Exception e) {}
          break;
        case FEATURE:
          try {
            return this.feature_inventory.slots.get(inventory_key.index).item;
          } catch(Exception e) {}
          break;
        case CRAFTING:
          try {
            //return this.cafting_inventory.slots.get(inventory_key.index).item;
          } catch(Exception e) {}
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
    Item stash(Item i) {
      if (i == null || i.remove) {
        return null;
      }
      if (this.feature_inventory != null) {
        Item leftover = this.feature_inventory.stash(i);
        if (leftover == null || leftover.remove) {
          return null;
        }
        i = new Item(leftover);
      }
      for (int j = 0; j < this.gear_inventory.slots.size(); j++) {
        if (this.gear_inventory.indexToGearSlot(j) == GearSlot.WEAPON) {
          continue;
        }
        Item leftover = this.gear_inventory.placeAt(i, j, false);
        if (leftover == null || leftover.remove) {
          i.equipSound();
          return null;
        }
        i = new Item(leftover);
      }
      return super.stash(i);
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
        if (this.item_holding.stack > 1) {
          fill(255);
          textSize(14);
          textAlign(RIGHT, BOTTOM);
          text(this.item_holding.stack, this.item_holding.x + 0.5 * this.button_size -
            2, this.item_holding.y + 0.5 * this.button_size - 2);
        }
      }
    }

    @Override
    void mouseMove(float mX, float mY) {
      this.any_hovered = false;
      // item holding
      if (this.item_holding != null) {
        this.item_holding.x += mX - this.last_mX;
        this.item_holding.y += mY - this.last_mY;
      }
      this.last_mX = mX;
      this.last_mY = mY;
      // main inventory
      super.mouseMove(mX, mY);
      if (this.hovered) {
        this.any_hovered = true;
      }
      // gear
      float gearInventoryTranslateX = - this.gear_inventory.display_width - 2;
      float gearInventoryTranslateY = 0.5 * (this.display_height - this.gear_inventory.display_height);
      this.gear_inventory.mouseMove(mX - gearInventoryTranslateX, mY - gearInventoryTranslateY);
      if (this.gear_inventory.hovered) {
        this.any_hovered = true;
      }
      // feature
      if (this.feature_inventory != null) {
        float featureInventoryTranslateX = 0.5 * (this.display_width - this.feature_inventory.display_width);
        float featureInventoryTranslateY = - this.feature_inventory.display_height - 2;
        this.feature_inventory.mouseMove(mX - featureInventoryTranslateX, mY - featureInventoryTranslateY);
        if (this.feature_inventory.hovered) {
          this.any_hovered = true;
        }
      }
    }

    @Override
    void mousePress() {
      super.mousePress();
      if (this.feature_inventory != null) {
        this.feature_inventory.mousePress();
      }
      // main inventory
      boolean found_clicked = false;
      Item source_item = null;
      float item_holding_x = 0;
      float item_holding_y = 0;
      for (int x = 0; x < this.max_cols; x++) {
        for (int y = 0; y < this.max_rows; y++) {
          int i = y * this.max_cols + x;
          if (i >= this.slots.size()) {
            break;
          }
          this.slots.get(i).mousePress();
          if (this.slots.get(i).button.hovered) {
            source_item = this.slots.get(i).item;
            if (this.item_holding == null || this.item_holding.remove) {
              this.item_origin = new InventoryKey(InventoryLocation.INVENTORY, i);
              item_holding_x = 2 + (x + 0.5) * this.button_size;
              item_holding_y = 2 + (y + 0.5) * this.button_size;
            }
            else {
              // drop parts of item holding
              return;
            }
            found_clicked = true;
            break;
          }
        }
      }
      // gear
      if (!found_clicked) {
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
              source_item = this.gear_inventory.getItem(i);
              if (this.item_holding == null || this.item_holding.remove) {
                this.item_origin = new InventoryKey(InventoryLocation.GEAR, i);
                item_holding_x = (x + 0.5) * this.button_size - this.gear_inventory.display_width;
                item_holding_y = 0.5 * (this.display_height - this.gear_inventory.
                  display_height) + 2 + (y + 0.5) * this.button_size;
              }
              else {
                // drop parts of item holding
                return;
              }
              found_clicked = true;
              break;
            }
          }
        }
      }
      // feature
      if (!found_clicked) {
        if (this.feature_inventory != null) {
          for (int x = 0; x < this.feature_inventory.max_cols; x++) {
            for (int y = 0; y < this.feature_inventory.max_rows; y++) {
              int i = y * this.feature_inventory.max_cols + x;
              if (i >= this.feature_inventory.slots.size()) {
                break;
              }
              this.feature_inventory.slots.get(i).mousePress();
              if (this.feature_inventory.slots.get(i).button.clicked) {
                source_item = this.feature_inventory.slots.get(i).item;
                if (this.item_holding == null || this.item_holding.remove) {
                  this.item_origin = new InventoryKey(InventoryLocation.FEATURE, i);
                  item_holding_x = 0.5 * (this.display_width - this.
                    feature_inventory.display_width) + 2 + (x + 0.5) * this.button_size;
                  item_holding_y = (y + 0.5) * this.button_size - this.feature_inventory.display_height;
                }
                else {
                  // drop parts of item holding
                  return;
                }
                found_clicked = true;
                break;
              }
            }
          }
        }
      }
      if (found_clicked) {
        switch(mouseButton) {
          case LEFT:
            if (source_item == null) {
              break;
            }
            this.item_holding = new Item(source_item);
            source_item.remove = true;
            break;
          case RIGHT:
            if (source_item == null) {
              break;
            }
            this.item_holding = new Item(source_item);
            if (this.item_holding != null && !this.item_holding.remove) {
              this.item_holding.stack = 1;
            }
            source_item.removeStack(1);
            break;
          case CENTER:
            if (source_item == null) {
              break;
            }
            int stack_to_transfer = int(ceil(0.5 * source_item.stack));
            this.item_holding = new Item(source_item);
            if (this.item_holding != null && !this.item_holding.remove) {
              this.item_holding.stack = stack_to_transfer;
            }
            source_item.removeStack(stack_to_transfer);
            break;
        }
        if (this.item_holding != null) {
          this.item_holding.x = item_holding_x;
          this.item_holding.y = item_holding_y;
          if (global.holding_shift) {
            switch(this.item_origin.location) {
              case INVENTORY:
                if (this.feature_inventory == null) {
                  this.item_holding = this.gear_inventory.placeAt(this.item_holding, 3, false);
                }
                else {
                  this.item_holding = this.feature_inventory.stash(this.item_holding);
                }
                break;
              case GEAR:
                this.item_holding = this.stash(this.item_holding);
                break;
              case FEATURE:
                this.item_holding = super.stash(this.item_holding);
                if (this.item_holding != null && !this.item_holding.remove) {
                  this.item_holding = this.gear_inventory.placeAt(this.item_holding, 3, false);
                }
                break;
              case CRAFTING:
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

    class AbilityButton extends RectangleButton {
      class AbilityTextBox extends TextBox {
        private boolean display = false;
        AbilityTextBox(float xi, float yi, float xf, float yf) {
          super(xi, yi, xf, yf);
          this.setTitleSize(18);
          this.setTextSize(15);
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

      Ability a = null;
      AbilityTextBox description;

      AbilityButton(float xi, float yi, float xf, float yf, Ability a, String letter) {
        super(xi, yi, xf, yf);
        this.message = letter;
        this.roundness = 10;
        this.setColors(color(0), color(0), color(0), color(0), color(0));
        this.setStroke(InventoryBar.this.color_ability_border, 2);
        this.use_time_elapsed = true;
        this.description = new AbilityTextBox(xi, yi, xi, yi);
        this.setAbility(a);
      }

      void setAbility(Ability a) {
        this.a = a;
        if (a == null) {
          this.description.setTitleText("");
          this.description.setText("");
          this.description.setXLocation(this.xi, this.xi);
          this.description.setYLocation(this.yi, this.yi);
        }
        else {
          textSize(18);
          float description_width = max(Constants.hero_abilityDescriptionMinWidth, 4 + textWidth(a.displayName()));
          this.description.setXLocation(this.xi - 0.5 * description_width, this.xf + 0.5 * description_width);
          float description_height = textAscent() + textDescent() + 6;
          textSize(15);
          this.description.setTitleText(a.displayName());
          this.description.setText(a.description());
          description_height += (2 + this.description.text_lines.size()) * (textAscent() + textDescent() + this.description.text_leading);
          this.description.setYLocation(this.yi - description_height, this.yi);
        }
      }

      @Override
      void update(int timeElapsed) {
        super.update(timeElapsed);
        if (this.description.display) {
          this.description.update(timeElapsed);
        }
      }

      @Override
      void drawButton() {
        super.drawButton();
        if (this.a != null) {
          imageMode(CORNERS);
          ellipseMode(CENTER);
          image(this.a.getImage(), this.xi, this.yi, this.xf, this.yf);
          if (this.a.timer_cooldown > 0) {
            fill(100, 100, 255, 140);
            noStroke();
            try {
              float angle = -HALF_PI + 2 * PI * this.a.timer_cooldown / this.a.timer_cooldown();
              arc(this.xCenter(), this.yCenter(), this.button_width(),
                this.button_height(), -HALF_PI, angle, PIE);
            } catch(Exception e) {}
            fill(255);
            textSize(24);
            textAlign(CENTER, CENTER);
            text(int(ceil(0.001 * this.a.timer_cooldown)), this.xCenter(), this.yCenter());
          }
          if (this.a.checkMana()) {
            fill(255);
            textSize(18);
            textAlign(LEFT, BOTTOM);
            text(int(ceil(this.a.manaCost())), this.xi + 2, this.yf - 1);
          }
          fill(255);
          textSize(18);
          textAlign(LEFT, TOP);
          text(this.message, this.xi + 2, this.yi + 1);
        }
      }

      void hover() {
        if (this.a != null) {
          this.description.display = true;
          // show cast indicators
        }
      }
      void dehover() {
        this.description.display = false;
      }
      void click() {
        InventoryBar.this.tryCast(this.message);
      }
      void release() {}
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
    private float yi_slot = 0;

    private float last_mX = 0;
    private float last_mY = 0;
    private StatusEffectCode code_hovered = null;
    private StatusEffectTextBox code_description = new StatusEffectTextBox();
    private ArrayList<AbilityButton> ability_buttons = new ArrayList<AbilityButton>();
    private boolean portrait_hovered = false;
    private boolean portrait_clicked = false;
    private boolean hovered = false;

    protected color color_background = color(210, 153, 108);
    protected color color_ability_border = color(120, 70, 40);

    protected int equipped_index = 0;
    protected float equipped_text_size = 15;
    protected boolean unlocked_inventory_bar1 = false;
    protected boolean unlocked_inventory_bar2 = false;


    InventoryBar() {
      if (global.profile == null) {
        this.setHeight(Constants.hero_defaultInventoryBarHeight);
      }
      else {
        this.setHeight(global.profile.options.inventory_bar_size);
      }
    }


    void setHeight(float new_height) {
      this.yf = height - Constants.hero_inventoryBarGap;
      this.yi = this.yf - new_height;
      textSize(this.equipped_text_size);
      float new_height_buttons = new_height - textAscent() - textDescent() - 2;
      this.yi_slot = this.yi + textAscent() + textDescent() + 2;
      this.xf_bar = 0.5 * (width + 3.333 * new_height_buttons) + 2;
      this.xi_bar = 0.5 * (width - 3.333 * new_height_buttons) - 2;
      this.xf_border = this.xi_bar - Constants.hero_inventoryBarGap;
      this.xi_border = this.xf_border - new_height;
      float border_thickness = 0.04166667 * new_height;
      this.xi_picture = this.xi_border + border_thickness;
      this.yi_picture = this.yi + border_thickness;
      this.xf_picture = this.xf_border - border_thickness;
      this.yf_picture = this.yf - border_thickness;
      this.radius_picture = 0.5 * (this.xf_picture - this.xi_picture);
      this.ability_width = 0.2 * (this.xf_bar - this.xi_bar - 4) - 4;
      this.slot_width = 0.1 * (this.xf_bar - this.xi_bar - 4) - 2;
      this.status_width = 0.08 * (this.xf_bar - this.xi_bar);
      this.yi_status = this.yi - 2 - this.status_width;
      float xi = this.xi_bar + 4;
      float yi = this.yf - this.ability_width - 4;
      this.ability_buttons.clear();
      for (int i = 0; i < Constants.hero_abilityNumber; i++, xi += this.ability_width + 4) {
        String letter = "";
        switch(i) {
          case 0:
            letter = "P";
            break;
          case 1:
            letter = "A";
            break;
          case 2:
            letter = "S";
            break;
          case 3:
            letter = "D";
            break;
          case 4:
            letter = "F";
            break;
        }
        Ability a = null;
        try {
          a = Hero.this.abilities.get(i);
        } catch(Exception e) {}
        this.ability_buttons.add(new AbilityButton(xi, yi, xi + this.ability_width,
          yi + this.ability_width, a, letter));
      }
    }

    void tryCast(String letter) {
      switch(letter) {
        case "A":
          Hero.this.bufferCast(1);
          break;
        case "S":
          Hero.this.bufferCast(2);
          break;
        case "D":
          Hero.this.bufferCast(3);
          break;
        case "F":
          Hero.this.bufferCast(4);
          break;
      }
    }

    PImage getBorderImage() {
      String imageName = "icons/border";
      switch(Hero.this.code) {
        case BEN:
          imageName += "_gray.png";
          break;
        case DAN:
          imageName += "_brown.png";
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
        case DAN:
          imageName += "dan_circle.png";
          break;
        default:
          imageName += "default.png";
          break;
      }
      return global.images.getImage(imageName);
    }


    void setEquippedIndex(int new_index) {
      int max_equipped_index = 0;
      if (this.unlocked_inventory_bar2) {
        max_equipped_index = 9;
      }
      else if (this.unlocked_inventory_bar1) {
        max_equipped_index = 4;
      }
      else {
        return;
      }
      if (new_index < 0 || new_index > max_equipped_index) {
        return;
      }
      int last_index = this.equipped_index;
      this.equipped_index = new_index;
      if (new_index == last_index) {
        return;
      }
      Item prev_weapon = new Item(Hero.this.weapon());
      if (prev_weapon.remove) {
        prev_weapon = null;
      }
      if (last_index == 0) {
        Hero.this.pickup(Hero.this.inventory.placeAt(prev_weapon, new_index-1, true));
      }
      else if (new_index == 0) {
        Hero.this.pickup(Hero.this.inventory.placeAt(prev_weapon, last_index-1, true));
      }
      else {
        Item new_weapon = new Item(Hero.this.inventory.slots.get(new_index-1).item);
        Item intermediary = new Item(Hero.this.inventory.slots.get(last_index-1).item);
        if (new_weapon.remove) {
          new_weapon = null;
        }
        if (intermediary.remove) {
          intermediary = null;
        }
        Hero.this.pickup(new_weapon);
        Hero.this.inventory.slots.get(new_index-1).item = intermediary;
        Hero.this.inventory.slots.get(last_index-1).item = prev_weapon;
      }
    }


    void update(int timeElapsed) {
      if (global.profile.options.inventory_bar_hidden) {
        return;
      }
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
      float xi = this.xi_bar;
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
            rectMode(CORNER);
            float rect_height = textAscent() + textDescent() + 2;
            float rect_width = textWidth(entry.getKey().code_name()) + 2;
            rect(this.last_mX - rect_width - 1, this.last_mY - rect_height - 1, rect_width, rect_height);
            fill(255);
            textAlign(LEFT, TOP);
            text(entry.getKey().code_name(), this.last_mX - rect_width - 1, this.last_mY - rect_height - 1);
          }
          this.code_hovered = entry.getKey();
        }
        xi += this.status_width + 2;
      }
      textAlign(LEFT, TOP);
      textSize(this.equipped_text_size);
      fill(0);
      if (Hero.this.weapon() == null) {
        text("-- no weapon --", this.xi_bar + 1, this.yi + 1);
      }
      else {
        text(Hero.this.weapon().display_name(), this.xi_bar + 1, this.yi + 1);
      }
      translate(this.xi_bar + 3, this.yi_slot);
      float translate_x = this.equipped_index * (this.slot_width + 2);
      translate(translate_x, 0);
      Hero.this.inventory.gear_inventory.updateSlot(timeElapsed, 3, Hero.this.weapon(), false, this.slot_width, !Hero.this.inventory.viewing);
      translate(-translate_x, 0);
      int inventory_slots_to_show = 0;
      if (this.unlocked_inventory_bar2) {
        inventory_slots_to_show = 9;
      }
      else if (this.unlocked_inventory_bar1) {
        inventory_slots_to_show = 4;
      }
      for (int i = 0; i < inventory_slots_to_show; i++) {
        int translate_index = i + 1;
        if (translate_index == this.equipped_index) {
          translate_index = 0;
        }
        translate_x = translate_index * (this.slot_width + 2);
        translate(translate_x, 0);
        Hero.this.inventory.slots.get(i).setWidth(this.slot_width);
        Hero.this.inventory.slots.get(i).update(timeElapsed, !Hero.this.inventory.viewing);
        Hero.this.inventory.slots.get(i).setWidth(Hero.this.inventory.button_size);
        translate(-translate_x, 0);
      }
      translate(-this.xi_bar - 3, -this.yi_slot);
      for (AbilityButton ability : this.ability_buttons) {
        ability.update(timeElapsed);
      }
      if (this.code_description.display) {
        this.code_description.update(timeElapsed);
      }
    }

    void mouseMove(float mX, float mY) {
      this.hovered = false;
      if (global.profile.options.inventory_bar_hidden) {
        return;
      }
      this.last_mX = mX;
      this.last_mY = mY;
      for (AbilityButton ability : this.ability_buttons) {
        ability.mouseMove(mX, mY);
      }
      if (this.code_description.display) {
        this.code_description.mouseMove(mX, mY);
      }
      if (this.code_hovered != null || this.code_description.hovered) {
        this.hovered = true;
      }
      if ((this.code_hovered == null || !this.code_hovered.code_name().equals(
        this.code_description.text_title)) && !this.code_description.hovered) {
        this.code_description.display = false;
      }
      float portrait_distance_x = mX - this.xi_picture - this.radius_picture;
      float portrait_distance_y = mY - this.yi_picture - this.radius_picture;
      if (sqrt(portrait_distance_x * portrait_distance_x + portrait_distance_y * portrait_distance_y) < this.radius_picture) {
        this.portrait_hovered = true;
        this.hovered = true;
      }
      else {
        this.portrait_hovered = false;
      }
      if (!this.hovered) {
        if (mX > this.xi_bar && mY > this.yi && mX < this.xf_bar && mY < this.yf) {
          this.hovered = true;
        }
      }
      if (!Hero.this.inventory.viewing) {
        mX -= this.xi_bar + 3;
        mY -= this.yi_slot;
        float translate_x = this.equipped_index * (this.slot_width + 2);
        Hero.this.inventory.gear_inventory.slots.get(3).setWidth(this.slot_width);
        Hero.this.inventory.gear_inventory.slots.get(3).mouseMove(mX - translate_x, mY);
        Hero.this.inventory.gear_inventory.slots.get(3).setWidth(Hero.this.inventory.gear_inventory.button_size);
        int inventory_slots_to_show = 0;
        if (this.unlocked_inventory_bar2) {
          inventory_slots_to_show = 9;
        }
        else if (this.unlocked_inventory_bar1) {
          inventory_slots_to_show = 4;
        }
        for (int i = 0; i < inventory_slots_to_show; i++) {
          int translate_index = i + 1;
          if (translate_index == this.equipped_index) {
            translate_index = 0;
          }
          translate_x = translate_index * (this.slot_width + 2);
          Hero.this.inventory.slots.get(i).setWidth(this.slot_width);
          Hero.this.inventory.slots.get(i).mouseMove(mX - translate_x, mY);
          Hero.this.inventory.slots.get(i).setWidth(Hero.this.inventory.button_size);
        }
      }
    }

    void mousePress() {
      if (global.profile.options.inventory_bar_hidden) {
        return;
      }
      for (AbilityButton ability : this.ability_buttons) {
        ability.mousePress();
      }
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
      if (!Hero.this.inventory.viewing) {
        boolean use_item = false;
        if (this.unlocked_inventory_bar2 && global.holding_ctrl) {
          use_item = true;
        }
        if (Hero.this.inventory.gear_inventory.slots.get(3).button.hovered) {
          Hero.this.inventory.gear_inventory.slots.get(3).button.hovered = false;
          if (use_item) {
            Hero.this.useItem(null);
          }
        }
        int inventory_slots_to_show = 0;
        if (this.unlocked_inventory_bar2) {
          inventory_slots_to_show = 9;
        }
        else if (this.unlocked_inventory_bar1) {
          inventory_slots_to_show = 4;
        }
        for (int i = 0; i < inventory_slots_to_show; i++) {
          int translate_index = i + 1;
          if (translate_index == this.equipped_index) {
            translate_index = 0;
          }
          if (Hero.this.inventory.slots.get(i).button.hovered) {
            Hero.this.inventory.slots.get(i).button.hovered = false;
            if (use_item) {
              Hero.this.useItem(null, new InventoryKey(InventoryLocation.INVENTORY, i));
            }
            else {
              this.setEquippedIndex(translate_index);
            }
          }
        }
      }
    }

    void mouseRelease(float mX, float mY) {
      if (global.profile.options.inventory_bar_hidden) {
        return;
      }
      for (AbilityButton ability : this.ability_buttons) {
        ability.mouseRelease(mX, mY);
      }
      if (this.code_description.display) {
        this.code_description.mouseRelease(mX, mY);
      }
      if (this.portrait_hovered && this.portrait_clicked) {
        Hero.this.openLeftPanelMenu(LeftPanelMenuPage.PLAYER);
      }
      this.portrait_clicked = false;
    }

    void scroll(int amount) {
      if (global.profile.options.inventory_bar_hidden) {
        return;
      }
      if (this.code_description.display) {
        this.code_description.scroll(amount);
        return;
      }
      if (!Hero.this.inventory.viewing && !global.holding_ctrl) {
        int max_equipped_index = 0;
        if (this.unlocked_inventory_bar2) {
          max_equipped_index = 9;
        }
        else if (this.unlocked_inventory_bar1) {
          max_equipped_index = 4;
        }
        else {
          return;
        }
        int new_equipped_index = this.equipped_index + amount;
        while (new_equipped_index > max_equipped_index) {
          new_equipped_index -= max_equipped_index + 1;
        }
        while (new_equipped_index < 0) {
          new_equipped_index += max_equipped_index + 1;
        }
        this.setEquippedIndex(new_equipped_index);
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
      void release() {
        this.updateHoverMessage();
      }

      abstract void updateHoverMessage();
    }


    class LevelTokensButton extends LeftPanelButton {
      LevelTokensButton(float yi, float yf) {
        super(0, yi, 0, yf);
        this.setColors(color(170), color(1, 0), color(150, 100), color(150, 200), color(0));
        this.text_size = 18;
        this.show_message = true;
        this.roundness = 2;
        this.noStroke();
      }

      @Override
      void release() {
        if (!this.hovered) {
          return;
        }
        if (PlayerLeftPanelMenu.this.hero().heroTree.curr_viewing) {
          PlayerLeftPanelMenu.this.hero().heroTree.curr_viewing = false;
        }
        else {
          PlayerLeftPanelMenu.this.hero().heroTree.curr_viewing = true;
          PlayerLeftPanelMenu.this.hero().heroTree.set_screen_location = true;
        }
        super.release();
      }

      void updateHoverMessage() {
        if (PlayerLeftPanelMenu.this.hero().heroTree.curr_viewing) {
          this.hover_message = "Close Level Tree";
        }
        else {
          this.hover_message = "Open Level Tree";
        }
      }
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


    class HealthButton extends LeftPanelButton {
      protected float bar_xi = 0;
      protected float bar_yi = 0;
      protected float bar_yf = 0;

      HealthButton(float yi, float yf) {
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
        image(global.images.getImage("icons/health.png"), this.xi, this.yi,
          this.bar_xi - 2, this.yf);
        rectMode(CORNERS);
        fill(0);
        noStroke();
        rect(this.bar_xi, this.bar_yi, this.xf, this.bar_yf);
        rectMode(CORNER);
        float health_ratio = min(1.0, PlayerLeftPanelMenu.this.hero().curr_health
          / PlayerLeftPanelMenu.this.hero().health());
        fill(0, 255, 0);
        rect(this.bar_xi, this.bar_yi, health_ratio * (this.xf - this.bar_xi),
          Constants.hero_leftPanelBarHeight);
      }

      void updateHoverMessage() {
        this.hover_message = "Health: " + int(round(PlayerLeftPanelMenu.this.
          hero().curr_health * 10.0)) / 10.0 + "/" + int(round(PlayerLeftPanelMenu.
          this.hero().health() * 10.0)) / 10.0;
      }
    }


    class ManaButton extends LeftPanelButton {
      protected float bar_xi = 0;
      protected float bar_yi = 0;
      protected float bar_yf = 0;

      ManaButton(float yi, float yf) {
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
        image(global.images.getImage("icons/mana_" + PlayerLeftPanelMenu.
          this.hero().manaFileName() + ".png"), this.xi, this.yi, this.bar_xi - 2, this.yf);
        rectMode(CORNERS);
        fill(0);
        noStroke();
        rect(this.bar_xi, this.bar_yi, this.xf, this.bar_yf);
        rectMode(CORNER);
        float mana_ratio = min(1, PlayerLeftPanelMenu.this.hero().currMana() /
          PlayerLeftPanelMenu.this.hero().mana());
        fill(255, 255, 0);
        rect(this.bar_xi, this.bar_yi, mana_ratio * (this.xf - this.bar_xi),
          Constants.hero_leftPanelBarHeight);
      }

      void updateHoverMessage() {
        this.hover_message = PlayerLeftPanelMenu.this.hero().manaDisplayName() +
          ": " + int(round(PlayerLeftPanelMenu.this.hero().currMana())) + "/" +
          int(round(PlayerLeftPanelMenu.this.hero().mana()));
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
        fill(0);
        noStroke();
        rect(this.bar_xi, this.bar_yi, this.xf, this.bar_yf);
        rectMode(CORNER);
        float hunger_ratio = PlayerLeftPanelMenu.this.hero().hunger / float(Constants.hero_maxHunger);
        fill(140, 70, 20);
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
        fill(0);
        noStroke();
        rect(this.bar_xi, this.bar_yi, this.xf, this.bar_yf);
        rectMode(CORNER);
        float thirst_ratio = PlayerLeftPanelMenu.this.hero().thirst / float(Constants.hero_maxThirst);
        fill(0, 0, 255);
        rect(this.bar_xi, this.bar_yi, thirst_ratio * (this.xf - this.bar_xi), Constants.hero_leftPanelBarHeight);
      }

      void updateHoverMessage() {
        this.hover_message = "Thirst: " + int(100 * PlayerLeftPanelMenu.this.hero().thirst /
          float(Constants.hero_maxThirst)) + "%";
      }
    }


    abstract class StatButton extends LeftPanelButton {
      protected float icon_xf = 0;
      protected String icon_name = "";

      StatButton(float yi, float yf) {
        super(0, yi, 0, yf);
        this.show_message = true;
        this.updateMessage();
        this.setColors(color(1, 0), color(1, 0), color(1, 0), color(1, 0), color(0));
        this.noStroke();
        this.roundness = 0;
        this.icon_xf = yf - yi;
        this.text_size = 17;
      }

      @Override
      void setXLocation(float xi, float xf) {
        super.setXLocation(xi, xf);
        this.icon_xf = this.xi + this.yf - this.yi;
      }

      @Override
      void writeText() {
        if (this.show_message) {
          fill(this.color_text);
          textAlign(LEFT, CENTER);
          textSize(this.text_size);
          if (this.adjust_for_text_descent) {
            text(this.message, this.icon_xf + 6, this.yCenter() - textDescent());
          }
          else {
            text(this.message, this.icon_xf + 6, this.yCenter());
          }
        }
      }

      @Override
      void drawButton() {
        this.updateMessage();
        super.drawButton();
        imageMode(CORNERS);
        image(global.images.getImage("icons/" + this.icon_name + ".png"),
          this.xi, this.yi, this.icon_xf, this.yf);
      }

      abstract void updateMessage();
    }


    class AttackButton extends StatButton {
      AttackButton(float yi, float yf) {
        super(yi, yf);
        this.icon_name = "stat_attack";
      }

      void updateMessage() {
        this.message = Integer.toString(int(round(PlayerLeftPanelMenu.this.hero().attack())));
      }

      void updateHoverMessage() {
        this.hover_message = "Attack: " + PlayerLeftPanelMenu.this.hero().attack();
      }
    }


    class MagicButton extends StatButton {
      MagicButton(float yi, float yf) {
        super(yi, yf);
        this.icon_name = "stat_magic";
      }

      void updateMessage() {
        this.message = Integer.toString(int(round(PlayerLeftPanelMenu.this.hero().magic())));
      }

      void updateHoverMessage() {
        this.hover_message = "Magic: " + PlayerLeftPanelMenu.this.hero().magic();
      }
    }


    class DefenseButton extends StatButton {
      DefenseButton(float yi, float yf) {
        super(yi, yf);
        this.icon_name = "stat_defense";
      }

      void updateMessage() {
        this.message = Integer.toString(int(round(PlayerLeftPanelMenu.this.hero().defense())));
      }

      void updateHoverMessage() {
        this.hover_message = "Defense: " + PlayerLeftPanelMenu.this.hero().defense();
      }
    }


    class ResistanceButton extends StatButton {
      ResistanceButton(float yi, float yf) {
        super(yi, yf);
        this.icon_name = "stat_resistance";
      }

      void updateMessage() {
        this.message = Integer.toString(int(round(PlayerLeftPanelMenu.this.hero().resistance())));
      }

      void updateHoverMessage() {
        this.hover_message = "Resistance: " + PlayerLeftPanelMenu.this.hero().resistance();
      }
    }


    class PiercingButton extends StatButton {
      PiercingButton(float yi, float yf) {
        super(yi, yf);
        this.icon_name = "stat_piercing";
      }

      void updateMessage() {
        this.message = Integer.toString(int(round(100.0 * PlayerLeftPanelMenu.this.hero().piercing()))) + "%";
      }

      void updateHoverMessage() {
        this.hover_message = "Piercing: " + int(round(1000.0 * PlayerLeftPanelMenu.this.hero().piercing())) / 10.0 + "%";
      }
    }


    class PenetrationButton extends StatButton {
      PenetrationButton(float yi, float yf) {
        super(yi, yf);
        this.icon_name = "stat_penetration";
      }

      void updateMessage() {
        this.message = Integer.toString(int(round(100.0 * PlayerLeftPanelMenu.this.hero().penetration()))) + "%";
      }

      void updateHoverMessage() {
        this.hover_message = "Penetration: " + int(round(1000.0 * PlayerLeftPanelMenu.this.hero().penetration())) / 10.0 + "%";
      }
    }


    class RangeButton extends StatButton {
      RangeButton(float yi, float yf) {
        super(yi, yf);
        this.icon_name = "stat_range";
      }

      void updateMessage() {
        this.message = Float.toString(int(round(10 * PlayerLeftPanelMenu.this.hero().attackRange())) / 10.0);
      }

      void updateHoverMessage() {
        this.hover_message = "Attack Range: " + PlayerLeftPanelMenu.this.hero().attackRange() + " m";
      }
    }


    class SpeedButton extends StatButton {
      SpeedButton(float yi, float yf) {
        super(yi, yf);
        this.icon_name = "stat_speed";
      }

      void updateMessage() {
        this.message = Float.toString(int(round(10 * PlayerLeftPanelMenu.this.hero().speed())) / 10.0);
      }

      void updateHoverMessage() {
        this.hover_message = "Speed: " + PlayerLeftPanelMenu.this.hero().speed() + " m/s";
      }
    }


    class TenacityButton extends StatButton {
      TenacityButton(float yi, float yf) {
        super(yi, yf);
        this.icon_name = "stat_tenacity";
      }

      void updateMessage() {
        this.message = Integer.toString(int(round(100 * PlayerLeftPanelMenu.this.hero().tenacity()))) + "%";
      }

      void updateHoverMessage() {
        this.hover_message = "Tenacity: " + int(round(1000.0 * PlayerLeftPanelMenu.this.hero().tenacity())) / 10.0 + "%";
      }
    }


    class AgilityButton extends StatButton {
      AgilityButton(float yi, float yf) {
        super(yi, yf);
        this.icon_name = "stat_agility";
      }

      void updateMessage() {
        this.message = Integer.toString(int(round(PlayerLeftPanelMenu.this.hero().agility())));
      }

      void updateHoverMessage() {
        this.hover_message = "Agility: " + PlayerLeftPanelMenu.this.hero().agility();
      }
    }


    protected float yi;
    protected float image_yi;
    protected float image_size;
    protected LevelTokensButton level_tokens;
    protected LevelButton level;
    protected ExperienceButton experience;
    protected HealthButton health;
    protected ManaButton mana;
    protected HungerButton hunger;
    protected ThirstButton thirst;
    protected AttackButton attack;
    protected MagicButton magic;
    protected DefenseButton defense;
    protected ResistanceButton resistance;
    protected PiercingButton piercing;
    protected PenetrationButton penetration;
    protected RangeButton range;
    protected SpeedButton speed;
    protected TenacityButton tenacity;
    protected AgilityButton agility;

    PlayerLeftPanelMenu() {
      this.yi = 0.5 * height + Constants.map_selectedObjectPanelGap;
      textSize(Constants.map_selectedObjectTitleTextSize);
      float currY = this.yi + textAscent() + textDescent() + Constants.map_selectedObjectPanelGap;
      this.image_yi = currY;
      this.image_size = 0.1 * height;
      textSize(18);
      float button_text_height = textAscent() + textDescent() + Constants.map_selectedObjectPanelGap;
      this.level_tokens = new LevelTokensButton(currY + this.image_size - button_text_height, currY + this.image_size - Constants.map_selectedObjectPanelGap);
      currY += image_size + Constants.map_selectedObjectPanelGap;
      this.level = new LevelButton(currY, currY + textAscent() + textDescent() + Constants.map_selectedObjectPanelGap);
      currY += textAscent() + textDescent() + Constants.map_selectedObjectPanelGap + 2;
      this.experience = new ExperienceButton(currY, currY + Constants.hero_leftPanelBarHeight);
      currY += 2 * Constants.hero_leftPanelBarHeight + Constants.map_selectedObjectPanelGap;
      this.health = new HealthButton(currY, currY + 2 * Constants.hero_leftPanelBarHeight);
      currY += 2 * Constants.hero_leftPanelBarHeight + Constants.map_selectedObjectPanelGap;
      this.mana = new ManaButton(currY, currY + 2 * Constants.hero_leftPanelBarHeight);
      currY += 2 * Constants.hero_leftPanelBarHeight + Constants.map_selectedObjectPanelGap;
      this.hunger = new HungerButton(currY, currY + 2 * Constants.hero_leftPanelBarHeight);
      currY += 2 * Constants.hero_leftPanelBarHeight + Constants.map_selectedObjectPanelGap;
      this.thirst = new ThirstButton(currY, currY + 2 * Constants.hero_leftPanelBarHeight);
      currY += 2 * Constants.hero_leftPanelBarHeight + 4 * Constants.map_selectedObjectPanelGap;
      // Stats
      float stat_button_height = max(0, 0.2 * (height - currY - 6 * Constants.map_selectedObjectPanelGap));
      this.attack = new AttackButton(currY, currY + stat_button_height);
      this.magic = new MagicButton(currY, currY + stat_button_height);
      currY += stat_button_height + Constants.map_selectedObjectPanelGap;
      this.defense = new DefenseButton(currY, currY + stat_button_height);
      this.resistance = new ResistanceButton(currY, currY + stat_button_height);
      currY += stat_button_height + Constants.map_selectedObjectPanelGap;
      this.piercing = new PiercingButton(currY, currY + stat_button_height);
      this.penetration = new PenetrationButton(currY, currY + stat_button_height);
      currY += stat_button_height + Constants.map_selectedObjectPanelGap;
      this.range = new RangeButton(currY, currY + stat_button_height);
      this.speed = new SpeedButton(currY, currY + stat_button_height);
      currY += stat_button_height + Constants.map_selectedObjectPanelGap;
      this.tenacity = new TenacityButton(currY, currY + stat_button_height);
      this.agility = new AgilityButton(currY, currY + stat_button_height);
      currY += stat_button_height + Constants.map_selectedObjectPanelGap;
    }

    void drawPanel(int millis, float panel_width) {
      float half_panel_width = 0.5 * panel_width;
      // name
      fill(255);
      textSize(Constants.map_selectedObjectTitleTextSize);
      textAlign(CENTER, TOP);
      text(Hero.this.display_name(), half_panel_width, this.yi);
      // picture
      imageMode(CORNER);
      image(Hero.this.getImage(), 1, this.image_yi, this.image_size, this.image_size);
      // level tokens
      this.level_tokens.message = "Tokens: " + Hero.this.level_tokens;
      this.level_tokens.setXLocation(half_panel_width + 2, panel_width - 2);
      this.level_tokens.update(millis);
      // level
      this.level.message = "Level " + Hero.this.level;
      this.level.setXLocation(2, panel_width - 2);
      this.level.update(millis);
      // experience
      this.experience.setXLocation(2, panel_width - 2);
      this.experience.update(millis);
      // health
      this.health.setXLocation(2, panel_width - 2);
      this.health.update(millis);
      // mana
      this.mana.setXLocation(2, panel_width - 2);
      this.mana.update(millis);
      // hunger
      this.hunger.setXLocation(2, panel_width - 2);
      this.hunger.update(millis);
      // thirst
      this.thirst.setXLocation(2, panel_width - 2);
      this.thirst.update(millis);
      // stats
      this.magic.setXLocation(half_panel_width + 2, panel_width - 2);
      this.magic.update(millis);
      this.attack.setXLocation(2, half_panel_width);
      this.attack.update(millis);
      this.resistance.setXLocation(half_panel_width + 2, panel_width - 2);
      this.resistance.update(millis);
      this.defense.setXLocation(2, 0.5 * panel_width);
      this.defense.update(millis);
      this.penetration.setXLocation(half_panel_width + 2, panel_width - 2);
      this.penetration.update(millis);
      this.piercing.setXLocation(2, 0.5 * panel_width);
      this.piercing.update(millis);
      this.speed.setXLocation(half_panel_width + 2, panel_width - 2);
      this.speed.update(millis);
      this.range.setXLocation(2, 0.5 * panel_width);
      this.range.update(millis);
      this.agility.setXLocation(half_panel_width + 2, panel_width - 2);
      this.agility.update(millis);
      this.tenacity.setXLocation(2, 0.5 * panel_width);
      this.tenacity.update(millis);
    }

    void mouseMove(float mX, float mY) {
      this.level_tokens.mouseMove(mX, mY);
      this.level.mouseMove(mX, mY);
      this.experience.mouseMove(mX, mY);
      this.health.mouseMove(mX, mY);
      this.mana.mouseMove(mX, mY);
      this.hunger.mouseMove(mX, mY);
      this.thirst.mouseMove(mX, mY);
      this.attack.mouseMove(mX, mY);
      this.magic.mouseMove(mX, mY);
      this.defense.mouseMove(mX, mY);
      this.resistance.mouseMove(mX, mY);
      this.piercing.mouseMove(mX, mY);
      this.penetration.mouseMove(mX, mY);
      this.speed.mouseMove(mX, mY);
      this.range.mouseMove(mX, mY);
      this.tenacity.mouseMove(mX, mY);
      this.agility.mouseMove(mX, mY);
    }

    void mousePress() {
      this.level_tokens.mousePress();
      this.level.mousePress();
      this.experience.mousePress();
      this.health.mousePress();
      this.mana.mousePress();
      this.hunger.mousePress();
      this.thirst.mousePress();
      this.attack.mousePress();
      this.magic.mousePress();
      this.defense.mousePress();
      this.resistance.mousePress();
      this.piercing.mousePress();
      this.penetration.mousePress();
      this.speed.mousePress();
      this.range.mousePress();
      this.tenacity.mousePress();
      this.agility.mousePress();
    }

    void mouseRelease(float mX, float mY) {
      this.level_tokens.mouseRelease(mX, mY);
      this.level.mouseRelease(mX, mY);
      this.experience.mouseRelease(mX, mY);
      this.health.mouseRelease(mX, mY);
      this.mana.mouseRelease(mX, mY);
      this.hunger.mouseRelease(mX, mY);
      this.thirst.mouseRelease(mX, mY);
      this.attack.mouseRelease(mX, mY);
      this.magic.mouseRelease(mX, mY);
      this.defense.mouseRelease(mX, mY);
      this.resistance.mouseRelease(mX, mY);
      this.piercing.mouseRelease(mX, mY);
      this.penetration.mouseRelease(mX, mY);
      this.speed.mouseRelease(mX, mY);
      this.range.mouseRelease(mX, mY);
      this.tenacity.mouseRelease(mX, mY);
      this.agility.mouseRelease(mX, mY);
    }
  }


  class XpLeftPanelMenu extends LeftPanelMenu {
    XpLeftPanelMenu() {
    }

    void drawPanel(int timeElapsed, float panel_width) {
    }

    void mouseMove(float mX, float mY) {
    }

    void mousePress() {
    }

    void mouseRelease(float mX, float mY) {
    }
  }



  class HeroTree {
    class HeroTreeButton extends RippleCircleButton {
      protected HeroTreeCode code;
      protected ArrayList<HeroTreeCode> dependencies = new ArrayList<HeroTreeCode>();
      protected boolean in_view = false;
      protected boolean visible = false;
      protected boolean unlocked = false;

      HeroTreeButton(HeroTreeCode code, float xc, float yc, float r) {
        super(xc, yc, r);
        this.code = code;
        Element e = HeroTree.this.hero().element;
        this.setColors(elementalColorLocked(e), elementalColorLocked(e), elementalColorLocked(e),
          elementalColorDark(e), elementalColorText(e));
        this.setStroke(elementalColorDark(e), 6);
        this.message = HeroTree.this.shortMessage(code);
        this.use_time_elapsed = true;
        this.text_size = 16;
        this.setDependencies();
        this.refreshColor();
      }

      void setDependencies() {
        switch(this.code) {
          case INVENTORYI:
            break;
          case PASSIVEI:
            this.dependencies.add(HeroTreeCode.INVENTORYI);
            break;
          case AI:
            this.dependencies.add(HeroTreeCode.INVENTORYI);
            break;
          case SI:
            this.dependencies.add(HeroTreeCode.INVENTORYI);
            break;
          case DI:
            this.dependencies.add(HeroTreeCode.INVENTORYI);
            break;
          case FI:
            this.dependencies.add(HeroTreeCode.PASSIVEI);
            this.dependencies.add(HeroTreeCode.AI);
            this.dependencies.add(HeroTreeCode.SI);
            this.dependencies.add(HeroTreeCode.DI);
            break;
          case PASSIVEII:
            this.dependencies.add(HeroTreeCode.FI);
            break;
          case AII:
            this.dependencies.add(HeroTreeCode.FI);
            break;
          case SII:
            this.dependencies.add(HeroTreeCode.FI);
            break;
          case DII:
            this.dependencies.add(HeroTreeCode.FI);
            break;
          case FII:
            this.dependencies.add(HeroTreeCode.PASSIVEII);
            this.dependencies.add(HeroTreeCode.AII);
            this.dependencies.add(HeroTreeCode.SII);
            this.dependencies.add(HeroTreeCode.DII);
            break;
          case HEALTHI:
            this.dependencies.add(HeroTreeCode.INVENTORYI);
            break;
          case ATTACKI:
            this.dependencies.add(HeroTreeCode.HEALTHI);
            break;
          case DEFENSEI:
            this.dependencies.add(HeroTreeCode.HEALTHI);
            break;
          case PIERCINGI:
            this.dependencies.add(HeroTreeCode.HEALTHI);
            break;
          case SPEEDI:
            this.dependencies.add(HeroTreeCode.HEALTHI);
            break;
          case SIGHTI:
            this.dependencies.add(HeroTreeCode.HEALTHI);
            break;
          case TENACITYI:
            this.dependencies.add(HeroTreeCode.HEALTHI);
            break;
          case AGILITYI:
            this.dependencies.add(HeroTreeCode.HEALTHI);
            break;
          case MAGICI:
            this.dependencies.add(HeroTreeCode.HEALTHI);
            break;
          case RESISTANCEI:
            this.dependencies.add(HeroTreeCode.HEALTHI);
            break;
          case PENETRATIONI:
            this.dependencies.add(HeroTreeCode.HEALTHI);
            break;
          case HEALTHII:
            this.dependencies.add(HeroTreeCode.HEALTHI);
            break;
          case ATTACKII:
            this.dependencies.add(HeroTreeCode.ATTACKI);
            break;
          case DEFENSEII:
            this.dependencies.add(HeroTreeCode.DEFENSEI);
            break;
          case PIERCINGII:
            this.dependencies.add(HeroTreeCode.PIERCINGI);
            break;
          case SPEEDII:
            this.dependencies.add(HeroTreeCode.SPEEDI);
            break;
          case SIGHTII:
            this.dependencies.add(HeroTreeCode.SIGHTI);
            break;
          case TENACITYII:
            this.dependencies.add(HeroTreeCode.TENACITYI);
            break;
          case AGILITYII:
            this.dependencies.add(HeroTreeCode.AGILITYI);
            break;
          case MAGICII:
            this.dependencies.add(HeroTreeCode.MAGICI);
            break;
          case RESISTANCEII:
            this.dependencies.add(HeroTreeCode.RESISTANCEI);
            break;
          case PENETRATIONII:
            this.dependencies.add(HeroTreeCode.PENETRATIONI);
            break;
          case HEALTHIII:
            this.dependencies.add(HeroTreeCode.HEALTHII);
            break;
          case OFFHAND:
            this.dependencies.add(HeroTreeCode.INVENTORYII);
            break;
          case BELTI:
            this.dependencies.add(HeroTreeCode.INVENTORYII);
            break;
          case BELTII:
            this.dependencies.add(HeroTreeCode.BELTI);
            break;
          case INVENTORYII:
            this.dependencies.add(HeroTreeCode.INVENTORYI);
            break;
          case INVENTORY_BARI:
            this.dependencies.add(HeroTreeCode.INVENTORYII);
            break;
          case INVENTORY_BARII:
            this.dependencies.add(HeroTreeCode.INVENTORY_BARI);
            break;
          case FOLLOWERI:
            this.dependencies.add(HeroTreeCode.INVENTORYI);
            break;
          default:
            global.errorMessage("ERROR: HeroTreeCode " + this.code + " not recognized.");
            break;
        }
      }

      void visible() {
        this.visible = true;
        this.show_message = true;
        Element e = HeroTree.this.hero().element;
        this.setColors(elementalColorLocked(e), elementalColorDark(e), elementalColor(e),
          elementalColorLight(e), elementalColorText(e));
        this.setStroke(elementalColorLight(e), 9);
        this.refreshColor();
      }

      void unlock() {
        this.unlocked = true;
        Element e = HeroTree.this.hero().element;
        this.setColors(elementalColorLocked(e), elementalColorLight(e), elementalColorLight(e),
          elementalColorLight(e), elementalColorText(e));
        this.setStroke(elementalColorLight(e), 12);
        this.refreshColor();
      }

      @Override
      color fillColor() {
        if (this.disabled) {
          return this.color_disabled;
        }
        else if (this.clicked && this.visible) {
          return this.color_click;
        }
        else if (this.hovered) {
          return this.color_hover;
        }
        else {
          return this.color_default;
        }
      }

      @Override
      void drawButton() {
        super.drawButton();
        fill(1, 0);
        stroke(this.color_stroke);
        strokeWeight(this.stroke_weight);
        ellipseMode(CORNERS);
        ellipse(this.xi, this.yi, this.xf, this.yf);
      }

      @Override
      void hover() {
        super.hover();
        if (this.unlocked) {
          this.message = "Unlocked";
        }
        else {
          this.message = HeroTree.this.longMessage(code);
        }
      }

      @Override
      void dehover() {
        super.hover();
        this.message = HeroTree.this.shortMessage(code);
      }

      @Override
      void click() {
        if (this.unlocked || this.visible) {
          super.click();
        }
      }

      @Override
      void release() {
        super.release();
        if (this.hovered) {
          if (this.unlocked || this.visible) {
            HeroTree.this.showDetails(this.code);
          }
        }
      }
    }


    class NodeDetailsForm extends Form {
      protected boolean canceled = false;
      protected HeroTreeButton button;
      protected float shadow_distance = 10;
      protected PImage img;

      NodeDetailsForm(HeroTreeButton button) {
        super(0.5 * (width - Constants.hero_treeForm_width), 0.5 * (height - Constants.hero_treeForm_height),
          0.5 * (width + Constants.hero_treeForm_width), 0.5 * (height + Constants.hero_treeForm_height));
        this.img = getCurrImage();
        this.cancelButton();
        this.draggable = false;
        this.button = button;
        this.setTitleText(HeroTree.this.upgradeName(button.code));
        this.setTitleSize(20);
        this.setFieldCushion(0);
        Element e = HeroTree.this.hero().element;
        this.color_background = elementalColorLocked(e);
        this.color_header = elementalColorLight(e);
        this.color_stroke = elementalColorDark(e);
        this.color_title = elementalColorText(e);

        this.addField(new SpacerFormField(20));
        TextBoxFormField textbox = new TextBoxFormField(HeroTree.this.upgradeDescription(button.code), 200);
        textbox.textbox.scrollbar.setButtonColors(elementalColorLocked(e), elementalColor(e),
          elementalColorLight(e), elementalColorDark(e), elementalColorText(e));
        textbox.textbox.useElapsedTime();
        this.addField(textbox);
        this.addField(new SpacerFormField(20));
        boolean has_enough = HeroTree.this.hero().level_tokens >= HeroTree.this.upgradeCost(button.code);
        SubmitCancelFormField buttons = new SubmitCancelFormField(HeroTree.this.hero().
          level_tokens + "/" + HeroTree.this.upgradeCost(button.code), "Cancel");
        buttons.button1.setColors(elementalColorLocked(e), elementalColor(e),
          elementalColorLight(e), elementalColorDark(e), elementalColorText(e));
        buttons.button2.setColors(elementalColorLocked(e), elementalColor(e),
          elementalColorLight(e), elementalColorDark(e), elementalColorText(e));
        if (has_enough && button.visible && !button.unlocked) {
        }
        else {
          buttons.button1.disabled = true;
          if (button.unlocked) {
            buttons.button1.message = "Unlocked";
          }
        }
        this.addField(buttons);
      }

      @Override
      void update(int millis) {
        rectMode(CORNERS);
        fill(0);
        imageMode(CORNER);
        image(this.img, 0, 0);
        fill(0, 150);
        stroke(0, 1);
        translate(shadow_distance, shadow_distance);
        rect(this.xi, this.yi, this.xf, this.yf);
        translate(-shadow_distance, -shadow_distance);
        super.update(millis);
      }

      void cancel() {
        this.canceled = true;
      }

      void submit() {
        HeroTree.this.unlockNode(this.button.code);
        this.canceled = true;
      }

      void buttonPress(int index) {}
    }


    class BackButton extends RectangleButton {
      BackButton() {
        super(0, 0, 0, 0);
        this.setColors(color(170), color(1, 0), color(40, 120), color(20, 150), color(255));
        this.noStroke();
        this.show_message = true;
        this.message = "Back";
        this.use_time_elapsed = true;
        this.text_size = 18;
        this.adjust_for_text_descent = true;
      }

      void hover() {}
      void dehover() {}
      void click() {}
      void release() {
        if (this.hovered) {
          HeroTree.this.curr_viewing = false;
        }
      }
    }


    protected float xi = 0;
    protected float yi = 0;
    protected float xf = 0;
    protected float yf = 0;
    protected float xCenter = 0.5 * width;
    protected float yCenter = 0.5 * height;

    protected float tree_xi = 0;
    protected float tree_yi = 0;
    protected float tree_xf = 0;
    protected float tree_yf = 0;
    protected float translateX = 0;
    protected float translateY = 0;

    protected float viewX = 0;
    protected float viewY = 0;
    protected float zoom = 1.0;
    protected float inverse_zoom = 1.0;
    protected boolean curr_viewing = false;
    protected boolean set_screen_location = false;

    protected boolean dragging = false;
    protected float last_mX = mouseX;
    protected float last_mY = mouseY;
    protected boolean hovered = false;

    protected float lowestX = 0;
    protected float lowestY = 0;
    protected float highestX = 0;
    protected float highestY = 0;

    protected color color_background = color(50);
    protected color color_connectorStroke_locked = elementalColorDark(Hero.this.element);
    protected color color_connectorStroke_visible = elementalColor(Hero.this.element);
    protected color color_connectorStroke_unlocked = elementalColorLight(Hero.this.element);
    protected color color_connectorFill_locked = elementalColorLocked(Hero.this.element);
    protected color color_connectorFill_visible = elementalColorDark(Hero.this.element);
    protected color color_connectorFill_unlocked = elementalColor(Hero.this.element);

    protected HashMap<HeroTreeCode, HeroTreeButton> nodes = new HashMap<HeroTreeCode, HeroTreeButton>();
    protected NodeDetailsForm node_details = null;
    protected BackButton back_button = new BackButton();


    HeroTree() {
      this.initializeNodes();
      this.updateDependencies();
      this.setView(0, 0);
    }


    void showDetails(HeroTreeCode code) {
      if (!this.nodes.containsKey(code)) {
        return;
      }
      this.node_details = new NodeDetailsForm(this.nodes.get(code));
    }

    void unlockNode(HeroTreeCode code) {
      this.unlockNode(code, false);
    }
    void unlockNode(HeroTreeCode code, boolean force_unlock) {
      if (!this.nodes.containsKey(code)) {
        return;
      }
      if (this.nodes.get(code).unlocked || (!this.nodes.get(code).visible && !force_unlock)) {
        return;
      }
      if (!force_unlock && Hero.this.level_tokens < this.upgradeCost(code)) {
        return;
      }
      if (!force_unlock) {
        Hero.this.level_tokens -= this.upgradeCost(code);
      }
      this.nodes.get(code).unlock();
      this.updateDependencies();
      Hero.this.upgrade(code);
      global.sounds.trigger_player("player/unlock_node");
    }

    ArrayList<HeroTreeCode> unlockedCodes() {
      ArrayList<HeroTreeCode> codes = new ArrayList<HeroTreeCode>();
      for (Map.Entry<HeroTreeCode, HeroTreeButton> entry : this.nodes.entrySet()) {
        if (entry.getValue().unlocked) {
          codes.add(entry.getKey());
        }
      }
      return codes;
    }

    void updateDependencies() {
      for (Map.Entry<HeroTreeCode, HeroTreeButton> entry : this.nodes.entrySet()) {
        if (entry.getValue().visible) {
          continue;
        }
        boolean visible = true;
        for (HeroTreeCode code : entry.getValue().dependencies) {
          if (!this.nodes.get(code).unlocked) {
            visible = false;
            break;
          }
        }
        if (visible) {
          entry.getValue().visible();
        }
      }
    }


    void setLocation(float xi, float yi, float xf, float yf) {
      this.xi = xi;
      this.yi = yi;
      this.xf = xf;
      this.yf = yf;
      this.setView(this.viewX, this.viewY);
      this.back_button.setLocation(xf - 120, yf - 70, xf - 30, yf - 30);
    }

    void moveView(float moveX, float moveY) {
      this.setView(this.viewX + moveX, this.viewY + moveY);
    }
    void setView(float viewX, float viewY) {
      if (viewX < this.lowestX) {
        viewX = this.lowestX;
      }
      else if (viewX > this.highestX) {
        viewX = this.highestX;
      }
      if (viewY < this.lowestY) {
        viewY = this.lowestY;
      }
      else if (viewY > this.highestY) {
        viewY = this.highestY;
      }
      this.viewX = viewX;
      this.viewY = viewY;
      this.tree_xi = viewX - this.inverse_zoom * (this.xCenter - this.xi);
      this.tree_yi = viewY - this.inverse_zoom * (this.yCenter - this.yi);
      this.tree_xf = viewX - this.inverse_zoom * (this.xCenter - this.xf);
      this.tree_yf = viewY - this.inverse_zoom * (this.yCenter - this.yf);
      this.translateX = this.xCenter - this.zoom * viewX;
      this.translateY = this.yCenter - this.zoom * viewY;
      for (Map.Entry<HeroTreeCode, HeroTreeButton> entry : this.nodes.entrySet()) {
        if (entry.getValue().xi > this.tree_xi && entry.getValue().yi > this.tree_yi &&
          entry.getValue().xf < this.tree_xf && entry.getValue().yf < this.tree_yf) {
          entry.getValue().in_view = true;
        }
        else {
          entry.getValue().in_view = false;
        }
      }
    }


    void update(int timeElapsed) {
      if (this.node_details != null) {
        this.node_details.update(timeElapsed);
        if (this.node_details.canceled) {
          this.node_details = null;
        }
        return;
      }
      rectMode(CORNERS);
      fill(this.color_background);
      noStroke();
      rect(this.xi, this.yi, this.xf, this.yf);
      translate(this.translateX, this.translateY);
      scale(this.zoom, this.zoom);
      for (Map.Entry<HeroTreeCode, HeroTreeButton> entry : this.nodes.entrySet()) {
        rectMode(CORNERS);
        translate(entry.getValue().xCenter(), entry.getValue().yCenter());
        for (HeroTreeCode dependency : entry.getValue().dependencies) {
          HeroTreeButton dependent = this.nodes.get(dependency);
          if (!entry.getValue().in_view && !dependent.in_view) {
            continue;
          }
          strokeWeight(2);
          float connector_width = 6;
          if (entry.getValue().unlocked) {
            fill(this.color_connectorFill_unlocked);
            stroke(this.color_connectorStroke_unlocked);
            strokeWeight(4);
            connector_width = 10;
          }
          else if (entry.getValue().visible || dependent.unlocked) {
            fill(this.color_connectorFill_visible);
            stroke(this.color_connectorStroke_visible);
            strokeWeight(3);
            connector_width = 8;
          }
          else {
            fill(this.color_connectorFill_locked);
            stroke(this.color_connectorStroke_locked);
          }
          float xDif = dependent.xCenter() - entry.getValue().xCenter();
          float yDif = dependent.yCenter() - entry.getValue().yCenter();
          float rotation = (float)Math.atan2(yDif, xDif);
          float distance = sqrt(xDif * xDif + yDif * yDif);
          rotate(rotation);
          rect(0, -connector_width, distance, connector_width);
          rotate(-rotation);
        }
        translate(-entry.getValue().xCenter(), -entry.getValue().yCenter());
      }
      for (Map.Entry<HeroTreeCode, HeroTreeButton> entry : this.nodes.entrySet()) {
        if (entry.getValue().in_view) {
          entry.getValue().update(timeElapsed);
        }
      }
      scale(this.inverse_zoom, this.inverse_zoom);
      translate(-this.translateX, -this.translateY);
      this.back_button.update(timeElapsed);
      fill(255);
      textAlign(CENTER, TOP);
      textSize(30);
      text("Hero Tree", this.xCenter, this.yi + 5);
      text("Level Tokens: " + Hero.this.level_tokens, this.xCenter, textAscent() + textDescent() + 10);
    }

    void mouseMove(float mX, float mY) {
      if (this.node_details != null) {
        this.node_details.mouseMove(mX, mY);
        return;
      }
      this.back_button.mouseMove(mX, mY);
      if (this.dragging) {
        this.moveView(this.inverse_zoom * (this.last_mX - mX), this.inverse_zoom * (this.last_mY - mY));
      }
      this.last_mX = mX;
      this.last_mY = mY;
      if (mX > this.xi && mY > this.yi && mX < this.xf && mY < this.yf) {
        this.hovered = true;
      }
      else {
        this.hovered = false;
      }
      mX -= this.translateX;
      mY -= this.translateY;
      mX *= this.inverse_zoom;
      mY *= this.inverse_zoom;
      for (Map.Entry<HeroTreeCode, HeroTreeButton> entry : this.nodes.entrySet()) {
        if (entry.getValue().in_view) {
          entry.getValue().mouseMove(mX, mY);
        }
      }
    }

    void mousePress() {
      if (this.node_details != null) {
        this.node_details.mousePress();
        return;
      }
      this.back_button.mousePress();
      boolean button_hovered = false;
      if (this.back_button.hovered) {
        button_hovered = true;
      }
      for (Map.Entry<HeroTreeCode, HeroTreeButton> entry : this.nodes.entrySet()) {
        if (entry.getValue().in_view) {
          entry.getValue().mousePress();
          if (entry.getValue().hovered) {
            button_hovered = true;
          }
        }
      }
      if (!button_hovered && mouseButton == LEFT && this.hovered) {
        this.dragging = true;
      }
    }

    void mouseRelease(float mX, float mY) {
      if (this.node_details != null) {
        this.node_details.mouseRelease(mX, mY);
        return;
      }
      this.back_button.mouseRelease(mX, mY);
      if (mouseButton == LEFT) {
        this.dragging = false;
      }
      mX -= this.translateX;
      mY -= this.translateY;
      for (Map.Entry<HeroTreeCode, HeroTreeButton> entry : this.nodes.entrySet()) {
        if (entry.getValue().in_view) {
          entry.getValue().mouseRelease(mX, mY);
        }
      }
    }

    void scroll(int amount) {
      if (this.node_details != null) {
        this.node_details.scroll(amount);
        return;
      }
      this.zoom -= amount * 0.01;
      if (this.zoom < 0.5) {
        this.zoom = 0.5;
      }
      if (this.zoom > 1.5) {
        this.zoom = 1.5;
      }
      this.inverse_zoom = 1 / this.zoom;
      this.setView(this.viewX, this.viewY);
    }

    void keyPress() {
      if (this.node_details != null) {
        this.node_details.keyPress();
        return;
      }
      if (key == ESC) {
        this.curr_viewing = false;
      }
    }

    void keyRelease() {
      if (this.node_details != null) {
        this.node_details.keyRelease();
        return;
      }
    }


    void initializeNodes() {
      for (HeroTreeCode code : HeroTreeCode.VALUES) {
        float xc = 0;
        float yc = 0;
        float r = Constants.hero_treeButtonDefaultRadius;
        switch(code) {
          case INVENTORYI:
            r = Constants.hero_treeButtonCenterRadius;
            break;
          case PASSIVEI:
            xc = 3 * Constants.hero_treeButtonDefaultRadius + Constants.hero_treeButtonCenterRadius;
            yc = -3.45 * Constants.hero_treeButtonDefaultRadius;
            break;
          case AI:
            xc = 3 * Constants.hero_treeButtonDefaultRadius + Constants.hero_treeButtonCenterRadius;
            yc = -1.15 * Constants.hero_treeButtonDefaultRadius;
            break;
          case SI:
            xc = 3 * Constants.hero_treeButtonDefaultRadius + Constants.hero_treeButtonCenterRadius;
            yc = 1.15 * Constants.hero_treeButtonDefaultRadius;
            break;
          case DI:
            xc = 3 * Constants.hero_treeButtonDefaultRadius + Constants.hero_treeButtonCenterRadius;
            yc = 3.45 * Constants.hero_treeButtonDefaultRadius;
            break;
          case FI:
            xc = 7 * Constants.hero_treeButtonDefaultRadius + Constants.hero_treeButtonCenterRadius;
            yc = 0;
            break;
          case PASSIVEII:
            xc = 11 * Constants.hero_treeButtonDefaultRadius + Constants.hero_treeButtonCenterRadius;
            yc = -3.45 * Constants.hero_treeButtonDefaultRadius;
            break;
          case AII:
            xc = 11 * Constants.hero_treeButtonDefaultRadius + Constants.hero_treeButtonCenterRadius;
            yc = -1.15 * Constants.hero_treeButtonDefaultRadius;
            break;
          case SII:
            xc = 11 * Constants.hero_treeButtonDefaultRadius + Constants.hero_treeButtonCenterRadius;
            yc = 1.15 * Constants.hero_treeButtonDefaultRadius;
            break;
          case DII:
            xc = 11 * Constants.hero_treeButtonDefaultRadius + Constants.hero_treeButtonCenterRadius;
            yc = 3.45 * Constants.hero_treeButtonDefaultRadius;
            break;
          case FII:
            xc = 15 * Constants.hero_treeButtonDefaultRadius + Constants.hero_treeButtonCenterRadius;
            yc = 0;
            break;
          case HEALTHI:
            xc = 0;
            yc = -3 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case ATTACKI:
            xc = 2.3 * Constants.hero_treeButtonDefaultRadius;
            yc = -8 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case DEFENSEI:
            xc = 4.6 * Constants.hero_treeButtonDefaultRadius;
            yc = -8 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case PIERCINGI:
            xc = 6.9 * Constants.hero_treeButtonDefaultRadius;
            yc = -8 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case SPEEDI:
            xc = 9.2 * Constants.hero_treeButtonDefaultRadius;
            yc = -8 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case SIGHTI:
            xc = 11.5 * Constants.hero_treeButtonDefaultRadius;
            yc = -8 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case TENACITYI:
            xc = 13.8 * Constants.hero_treeButtonDefaultRadius;
            yc = -8 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case AGILITYI:
            xc = 16.1 * Constants.hero_treeButtonDefaultRadius;
            yc = -8 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case MAGICI:
            xc = -2.3 * Constants.hero_treeButtonDefaultRadius;
            yc = -8 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case RESISTANCEI:
            xc = -4.6 * Constants.hero_treeButtonDefaultRadius;
            yc = -8 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case PENETRATIONI:
            xc = -6.9 * Constants.hero_treeButtonDefaultRadius;
            yc = -8 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case HEALTHII:
            xc = 0;
            yc = -8 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case ATTACKII:
            xc = 2.3 * Constants.hero_treeButtonDefaultRadius;
            yc = -13 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case DEFENSEII:
            xc = 4.6 * Constants.hero_treeButtonDefaultRadius;
            yc = -13 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case PIERCINGII:
            xc = 6.9 * Constants.hero_treeButtonDefaultRadius;
            yc = -13 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case SPEEDII:
            xc = 9.2 * Constants.hero_treeButtonDefaultRadius;
            yc = -13 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case SIGHTII:
            xc = 11.5 * Constants.hero_treeButtonDefaultRadius;
            yc = -13 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case TENACITYII:
            xc = 13.8 * Constants.hero_treeButtonDefaultRadius;
            yc = -13 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case AGILITYII:
            xc = 16.1 * Constants.hero_treeButtonDefaultRadius;
            yc = -13 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case MAGICII:
            xc = -2.3 * Constants.hero_treeButtonDefaultRadius;
            yc = -13 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case RESISTANCEII:
            xc = -4.6 * Constants.hero_treeButtonDefaultRadius;
            yc = -13 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case PENETRATIONII:
            xc = -6.9 * Constants.hero_treeButtonDefaultRadius;
            yc = -13 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case HEALTHIII:
            xc = 0;
            yc = -13 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            break;
          case OFFHAND:
            xc = 1.15 * Constants.hero_treeButtonDefaultRadius;
            yc = 7 * Constants.hero_treeButtonDefaultRadius + Constants.hero_treeButtonCenterRadius;
            break;
          case BELTI:
            xc = 3.45 * Constants.hero_treeButtonDefaultRadius;
            yc = 7 * Constants.hero_treeButtonDefaultRadius + Constants.hero_treeButtonCenterRadius;
            break;
          case BELTII:
            xc = 3.45 * Constants.hero_treeButtonDefaultRadius;
            yc = 11 * Constants.hero_treeButtonDefaultRadius + Constants.hero_treeButtonCenterRadius;
            break;
          case INVENTORYII:
            xc = 0;
            yc = 3 * Constants.hero_treeButtonDefaultRadius + Constants.hero_treeButtonCenterRadius;
            break;
          case INVENTORY_BARI:
            xc = -1.15 * Constants.hero_treeButtonDefaultRadius;
            yc = 7 * Constants.hero_treeButtonDefaultRadius + Constants.hero_treeButtonCenterRadius;
            break;
          case INVENTORY_BARII:
            xc = -1.15 * Constants.hero_treeButtonDefaultRadius;
            yc = 11 * Constants.hero_treeButtonDefaultRadius + Constants.hero_treeButtonCenterRadius;
            break;
          case FOLLOWERI:
            xc = -3 * Constants.hero_treeButtonDefaultRadius - Constants.hero_treeButtonCenterRadius;
            yc = 0;
            break;
          default:
            global.errorMessage("ERROR: No place to put " + code + " in HeroTree.");
            break;
        }
        this.nodes.put(code, new HeroTreeButton(code, xc, yc, r));
        if (xc - r < this.lowestX) {
          this.lowestX = xc - r;
        }
        else if (xc + r > this.highestX) {
          this.highestX = xc + r;
        }
        if (yc - r < this.lowestY) {
          this.lowestY = yc - r;
        }
        else if (yc + r > this.highestY) {
          this.highestY = yc + r;
        }
      }
    }

    Hero hero() {
      return Hero.this;
    }

    String upgradeName(HeroTreeCode code) {
      switch(code) {
        case INVENTORYI:
          return "Unlock Inventory";
        case PASSIVEI:
          return (new Ability(Hero.this.abilityId(0))).displayName();
        case AI:
          return (new Ability(Hero.this.abilityId(1))).displayName();
        case SI:
          return (new Ability(Hero.this.abilityId(2))).displayName();
        case DI:
          return (new Ability(Hero.this.abilityId(3))).displayName();
        case FI:
          return (new Ability(Hero.this.abilityId(4))).displayName();
        case PASSIVEII:
          return (new Ability(Hero.this.upgradedAbilityId(0))).displayName();
        case AII:
          return (new Ability(Hero.this.upgradedAbilityId(1))).displayName();
        case SII:
          return (new Ability(Hero.this.upgradedAbilityId(2))).displayName();
        case DII:
          return (new Ability(Hero.this.upgradedAbilityId(3))).displayName();
        case FII:
          return (new Ability(Hero.this.upgradedAbilityId(4))).displayName();
        case HEALTHI:
          return "Increase Health";
        case ATTACKI:
          return "Increase Attack";
        case DEFENSEI:
          return "Increase Defense";
        case PIERCINGI:
          return "Increase Piercing";
        case SPEEDI:
          return "Increase Speed";
        case SIGHTI:
          return "Increase Sight";
        case TENACITYI:
          return "Increase Tenacity";
        case AGILITYI:
          return "Increase Agility";
        case MAGICI:
          return "Increase Magic";
        case RESISTANCEI:
          return "Increase Resistance";
        case PENETRATIONI:
          return "Increase Penetration";
        case HEALTHII:
          return "Increase Health II";
        case ATTACKII:
          return "Increase Attack II";
        case DEFENSEII:
          return "Increase Defense II";
        case PIERCINGII:
          return "Increase Piercing II";
        case SPEEDII:
          return "Increase Speed II";
        case SIGHTII:
          return "Increase Sight II";
        case TENACITYII:
          return "Increase Tenacity II";
        case AGILITYII:
          return "Increase Agility II";
        case MAGICII:
          return "Increase Magic II";
        case RESISTANCEII:
          return "Increase Resistance II";
        case PENETRATIONII:
          return "Increase Penetration II";
        case HEALTHIII:
          return "Increase Health III";
        case OFFHAND:
          return "Offhand Gear Slot";
        case BELTI:
          return "Belt Gear Slot";
        case BELTII:
          return "Belt Gear Slot II";
        case INVENTORYII:
          return "Inventory Slots";
        case INVENTORY_BARI:
          return "Inventory Bar";
        case INVENTORY_BARII:
          return "Inventory Bar II";
        case FOLLOWERI:
          return "Unlock Follower";
        default:
          return "-- Error --";
      }
    }

    String shortMessage(HeroTreeCode code) {
      switch(code) {
        case INVENTORYI:
          return "Inventory";
        case PASSIVEI:
          return "Passive";
        case AI:
          return "A";
        case SI:
          return "S";
        case DI:
          return "D";
        case FI:
          return "F";
        case PASSIVEII:
          return "Passive II";
        case AII:
          return "A II";
        case SII:
          return "S II";
        case DII:
          return "D II";
        case FII:
          return "F II";
        case HEALTHI:
          return "Health";
        case ATTACKI:
          return "Attack";
        case DEFENSEI:
          return "Defense";
        case PIERCINGI:
          return "Piercing";
        case SPEEDI:
          return "Speed";
        case SIGHTI:
          return "Sight";
        case TENACITYI:
          return "Tenacity";
        case AGILITYI:
          return "Agility";
        case MAGICI:
          return "Magic";
        case RESISTANCEI:
          return "Resistance";
        case PENETRATIONI:
          return "Penetration";
        case HEALTHII:
          return "Health II";
        case ATTACKII:
          return "Attack II";
        case DEFENSEII:
          return "Defense II";
        case PIERCINGII:
          return "Piercing II";
        case SPEEDII:
          return "Speed II";
        case SIGHTII:
          return "Sight II";
        case TENACITYII:
          return "Tenacity II";
        case AGILITYII:
          return "Agility II";
        case MAGICII:
          return "Magic II";
        case RESISTANCEII:
          return "Resistance II";
        case PENETRATIONII:
          return "Penetration II";
        case HEALTHIII:
          return "Health III";
        case OFFHAND:
          return "Offhand";
        case BELTI:
          return "Belt";
        case BELTII:
          return "Belt II";
        case INVENTORYII:
          return "Inventory II";
        case INVENTORY_BARI:
          return "Inventory Bar";
        case INVENTORY_BARII:
          return "Inventory Bar II";
        case FOLLOWERI:
          return "Follower";
        default:
          return "-- Error --";
      }
    }

    String longMessage(HeroTreeCode code) {
      switch(code) {
        case INVENTORYI:
          return "Unlock\nInventory";
        case PASSIVEI:
          return "Unlock\nPassive\nAbility";
        case AI:
          return "Unlock\nA\nAbility";
        case SI:
          return "Unlock\nS\nAbility";
        case DI:
          return "Unlock\nD\nAbility";
        case FI:
          return "Unlock\nF\nAbility";
        case PASSIVEII:
          return "Upgrade\nPassive\nAbility";
        case AII:
          return "Upgrade\nA\nAbility";
        case SII:
          return "Upgrade\nS\nAbility";
        case DII:
          return "Upgrade\nD\nAbility";
        case FII:
          return "Upgrade\nF\nAbility";
        case HEALTHI:
          return "Increase\nHealth";
        case ATTACKI:
          return "Increase\nAttack";
        case DEFENSEI:
          return "Increase\nDefense";
        case PIERCINGI:
          return "Increase\nPiercing";
        case SPEEDI:
          return "Increase\nSpeed";
        case SIGHTI:
          return "Increase\nSight";
        case TENACITYI:
          return "Increase\nTenacity";
        case AGILITYI:
          return "Increase\nAgility";
        case MAGICI:
          return "Increase\nMagic";
        case RESISTANCEI:
          return "Increase\nResistance";
        case PENETRATIONI:
          return "Increase\nPenetration";
        case HEALTHII:
          return "Increase\nHealth";
        case ATTACKII:
          return "Increase\nAttack";
        case DEFENSEII:
          return "Increase\nDefense";
        case PIERCINGII:
          return "Increase\nPiercing";
        case SPEEDII:
          return "Increase\nSpeed";
        case SIGHTII:
          return "Increase\nSight";
        case TENACITYII:
          return "Increase\nTenacity";
        case AGILITYII:
          return "Increase\nAgility";
        case MAGICII:
          return "Increase\nMagic";
        case RESISTANCEII:
          return "Increase\nResistance";
        case PENETRATIONII:
          return "Increase\nPenetration";
        case HEALTHIII:
          return "Increase\nHealth";
        case OFFHAND:
          return "Unlock\nOffhand\nGear Slot";
        case BELTI:
          return "Unlock\nBelt\nGear Slot";
        case BELTII:
          return "Unlock\nBelt II\nGear Slot";
        case INVENTORYII:
          return "More\nInventory\nSlots";
        case INVENTORY_BARI:
          return "Unlock\nInventory Bar";
        case INVENTORY_BARII:
          return "Upgrade\nInventory Bar";
        case FOLLOWERI:
          return "Unlock\nFollower";
        default:
          return "-- Error --";
      }
    }

    String upgradeDescription(HeroTreeCode code) {
      switch(code) {
        case INVENTORYI:
          return "Unlock your inventory and increase your available slots by " +
            Constants.upgrade_inventoryI + ".";
        case PASSIVEI:
          return (new Ability(Hero.this.abilityId(0))).description();
        case AI:
          return (new Ability(Hero.this.abilityId(1))).description();
        case SI:
          return (new Ability(Hero.this.abilityId(2))).description();
        case DI:
          return (new Ability(Hero.this.abilityId(3))).description();
        case FI:
          return (new Ability(Hero.this.abilityId(4))).description();
        case PASSIVEII:
          return (new Ability(Hero.this.upgradedAbilityId(0))).description();
        case AII:
          return (new Ability(Hero.this.upgradedAbilityId(1))).description();
        case SII:
          return (new Ability(Hero.this.upgradedAbilityId(2))).description();
        case DII:
          return (new Ability(Hero.this.upgradedAbilityId(3))).description();
        case FII:
          return (new Ability(Hero.this.upgradedAbilityId(4))).description();
        case HEALTHI:
          return "Increase your base health by " + Constants.upgrade_healthI + ".";
        case ATTACKI:
          return "Increase your base attack by " + Constants.upgrade_attackI + ".";
        case DEFENSEI:
          return "Increase your base defense by " + Constants.upgrade_defenseI + ".";
        case PIERCINGI:
          return "Increase your base piercing by " + (100.0 * Constants.upgrade_piercingI) + "%.";
        case SPEEDI:
          return "Increase your base speed by " + Constants.upgrade_speedI + ".";
        case SIGHTI:
          return "Increase your base sight by " + Constants.upgrade_sightI + ".";
        case TENACITYI:
          return "Increase your base tenacity by " + (100.0 * Constants.upgrade_tenacityI) + "%.";
        case AGILITYI:
          return "Increase your base agility by " + Constants.upgrade_agilityI + ".";
        case MAGICI:
          return "Increase your base magic by " + Constants.upgrade_magicI + ".";
        case RESISTANCEI:
          return "Increase your base resistance by " + Constants.upgrade_resistanceI + ".";
        case PENETRATIONI:
          return "Increase your base penetration by " + (100.0 * Constants.upgrade_penetrationI) + "%.";
        case HEALTHII:
          return "Increase your base health by " + Constants.upgrade_healthII + ".";
        case ATTACKII:
          return "Increase your base attack by " + Constants.upgrade_attackII + ".";
        case DEFENSEII:
          return "Increase your base defense by " + Constants.upgrade_defenseII + ".";
        case PIERCINGII:
          return "Increase your base piercing by " + (100.0 * Constants.upgrade_piercingII) + "%.";
        case SPEEDII:
          return "Increase your base speed by " + Constants.upgrade_speedII + ".";
        case SIGHTII:
          return "Increase your base sight by " + Constants.upgrade_sightII + ".";
        case TENACITYII:
          return "Increase your base tenacity by " + (100.0 * Constants.upgrade_tenacityII) + "%.";
        case AGILITYII:
          return "Increase your base agility by " + Constants.upgrade_agilityII + ".";
        case MAGICII:
          return "Increase your base magic by " + Constants.upgrade_magicII + ".";
        case RESISTANCEII:
          return "Increase your base resistance by " + Constants.upgrade_resistanceII + ".";
        case PENETRATIONII:
          return "Increase your base penetration by " + (100.0 * Constants.upgrade_penetrationII) + "%.";
        case HEALTHIII:
          return "Increase your base health by " + Constants.upgrade_healthIII + ".";
        case OFFHAND:
          return "Unlock the Offhand gear slot, allowing you to wield offhand items.";
        case BELTI:
          return "Unlock the first Belt gear slot, allowing you to wield belt items.";
        case BELTII:
          return "Unlock the second Belt gear slot, allowing you to wield two belt items.";
        case INVENTORYII:
          return "Increase your available inventory slots by " + Constants.upgrade_inventoryII + ".";
        case INVENTORY_BARI:
          return "Unlock the inventory bar, which allows you to view and quickly " +
            "switch between active items using the number keys or by scrolling.";
        case INVENTORY_BARII:
          return "Upgrade the inventory bar, doubling its capacity and allowing " +
            "direct use of items in it without first switching to them.";
        case FOLLOWERI:
          return "Unlock your follower (will be released in future update).";
        default:
          return "-- Error --";
      }
    }

    int upgradeCost(HeroTreeCode code) {
      switch(code) {
        case INVENTORYI:
          return 1;
        case PASSIVEI:
          return 5;
        case AI:
          return 7;
        case SI:
          return 7;
        case DI:
          return 7;
        case FI:
          return 20;
        case PASSIVEII:
          return 100;
        case AII:
          return 100;
        case SII:
          return 100;
        case DII:
          return 100;
        case FII:
          return 300;
        case HEALTHI:
          return 2;
        case ATTACKI:
          return 3;
        case DEFENSEI:
          return 3;
        case PIERCINGI:
          return 3;
        case SPEEDI:
          return 3;
        case SIGHTI:
          return 3;
        case TENACITYI:
          return 3;
        case AGILITYI:
          return 3;
        case MAGICI:
          return 7;
        case RESISTANCEI:
          return 7;
        case PENETRATIONI:
          return 7;
        case HEALTHII:
          return 15;
        case ATTACKII:
          return 30;
        case DEFENSEII:
          return 30;
        case PIERCINGII:
          return 30;
        case SPEEDII:
          return 30;
        case SIGHTII:
          return 30;
        case TENACITYII:
          return 30;
        case AGILITYII:
          return 30;
        case MAGICII:
          return 35;
        case RESISTANCEII:
          return 35;
        case PENETRATIONII:
          return 35;
        case HEALTHIII:
          return 70;
        case OFFHAND:
          return 150;
        case BELTI:
          return 50;
        case BELTII:
          return 150;
        case INVENTORYII:
          return 12;
        case INVENTORY_BARI:
          return 40;
        case INVENTORY_BARII:
          return 75;
        case FOLLOWERI:
          return 25000;
        default:
          return 0;
      }
    }
  }



  protected HeroCode code;
  protected Location location = Location.ERROR;

  protected int level_tokens = 0;
  protected float experience = 0;
  protected int experience_next_level = 1;
  protected float money = 0;
  protected float curr_mana = 0;
  protected int hunger = 100;
  protected int thirst = 100;
  protected int hunger_timer = Constants.hero_hungerTimer;
  protected int thirst_timer = Constants.hero_thirstTimer;

  protected LeftPanelMenu left_panel_menu = new PlayerLeftPanelMenu();
  protected HeroInventory inventory = new HeroInventory();
  protected boolean can_view_inventory = false;
  protected InventoryBar inventory_bar = new InventoryBar();
  protected HeroTree heroTree = new HeroTree();

  protected Queue<String> messages = new LinkedList<String>();
  protected boolean in_control = true;

  Hero(int ID) {
    super(ID);
    this.code = HeroCode.heroCodeFromId(ID);
    this.addAbilities();
  }
  Hero(HeroCode code) {
    super(HeroCode.unit_id(code));
    this.code = code;
    this.addAbilities();
  }


  void upgrade(HeroTreeCode code) {
    switch(code) {
      case INVENTORYI:
        this.can_view_inventory = true;
        this.inventory.addSlots(Constants.upgrade_inventoryI);
        break;
      case PASSIVEI:
        this.activateAbility(0);
        break;
      case AI:
        this.activateAbility(1);
        break;
      case SI:
        this.activateAbility(2);
        break;
      case DI:
        this.activateAbility(3);
        break;
      case FI:
        this.activateAbility(4);
        break;
      case PASSIVEII:
        this.upgradeAbility(0);
        break;
      case AII:
        this.upgradeAbility(1);
        break;
      case SII:
        this.upgradeAbility(2);
        break;
      case DII:
        this.upgradeAbility(3);
        break;
      case FII:
        this.upgradeAbility(4);
        break;
      case HEALTHI:
        this.addBaseHealth(Constants.upgrade_healthI);
        break;
      case ATTACKI:
        this.base_attack += Constants.upgrade_attackI;
        break;
      case DEFENSEI:
        this.base_defense += Constants.upgrade_defenseI;
        break;
      case PIERCINGI:
        this.base_piercing += Constants.upgrade_piercingI;
        break;
      case SPEEDI:
        this.base_speed += Constants.upgrade_speedI;
        break;
      case SIGHTI:
        this.base_sight += Constants.upgrade_sightI;
        break;
      case TENACITYI:
        this.base_tenacity += Constants.upgrade_tenacityI;
        break;
      case AGILITYI:
        this.base_agility += Constants.upgrade_agilityI;
        break;
      case MAGICI:
        this.base_magic += Constants.upgrade_magicI;
        break;
      case RESISTANCEI:
        this.base_resistance += Constants.upgrade_resistanceI;
        break;
      case PENETRATIONI:
        this.base_penetration += Constants.upgrade_penetrationI;
        break;
      case HEALTHII:
        this.addBaseHealth(Constants.upgrade_healthII);
        break;
      case ATTACKII:
        this.base_attack += Constants.upgrade_attackII;
        break;
      case DEFENSEII:
        this.base_defense += Constants.upgrade_defenseII;
        break;
      case PIERCINGII:
        this.base_piercing += Constants.upgrade_piercingII;
        break;
      case SPEEDII:
        this.base_speed += Constants.upgrade_speedII;
        break;
      case SIGHTII:
        this.base_sight += Constants.upgrade_sightII;
        break;
      case TENACITYII:
        this.base_tenacity += Constants.upgrade_tenacityII;
        break;
      case AGILITYII:
        this.base_agility += Constants.upgrade_agilityII;
        break;
      case MAGICII:
        this.base_magic += Constants.upgrade_magicII;
        break;
      case RESISTANCEII:
        this.base_resistance += Constants.upgrade_resistanceII;
        break;
      case PENETRATIONII:
        this.base_penetration += Constants.upgrade_penetrationII;
        break;
      case HEALTHIII:
        this.addBaseHealth(Constants.upgrade_healthIII);
        break;
      case OFFHAND:
        this.gearSlots("Offhand");
        break;
      case BELTI:
        this.gearSlots("Belt (left)");
        break;
      case BELTII:
        this.gearSlots("Belt (right)");
        break;
      case INVENTORYII:
        this.inventory.addSlots(Constants.upgrade_inventoryII);
        break;
      case INVENTORY_BARI:
        this.inventory.addSlots(Constants.upgrade_inventory_bar_slots);
        this.inventory_bar.unlocked_inventory_bar1 = true;
        break;
      case INVENTORY_BARII:
        this.inventory.addSlots(Constants.upgrade_inventory_bar_slots);
        this.inventory_bar.unlocked_inventory_bar2 = true;
        break;
      case FOLLOWERI:
        // follower
        break;
      default:
        global.errorMessage("ERROR: Trying to upgrade but code " + code + " not found.");
        break;
    }
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

  int abilityId(int index) {
    return 2 * Constants.hero_abilityNumber * (this.ID - 1101) + index + 101;
  }
  int upgradedAbilityId(int index) {
    return 2 * Constants.hero_abilityNumber * (this.ID - 1101) + index + 101 + 5;
  }

  void activateAbility(int index) {
    if (index < 0 || index >= this.abilities.size()) {
      global.log("WARNING: Trying to activate ability index " + index + " but it doesn't exist.");
      return;
    }
    this.abilities.set(index, new Ability(this.abilityId(index)));
    this.inventory_bar.ability_buttons.get(index).setAbility(this.abilities.get(index));
  }

  void upgradeAbility(int index) {
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
    a = new Ability(this.upgradedAbilityId(index));
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
      case DAN:
        return "Frog Energy";
      default:
        return "Error";
    }
  }

  String manaFileName() {
    switch(this.code) {
      case BEN:
        return "rage";
      case DAN:
        return "frog";
      default:
        return "error";
    }
  }


  @Override
  float currMana() {
    return this.curr_mana;
  }

  @Override
  float mana() {
    float mana = 0;
    switch(this.code) {
      case BEN:
        return 100;
      case DAN:
        mana = 80;
        break;
      default:
        break;
    }
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
    global.sounds.trigger_player("player/levelup");
  }


  @Override
  void killed(Unit u) {
    super.killed(u);
    this.addExperience(int(ceil(1 + pow(u.level, Constants.hero_killExponent))));
  }


  boolean seesTime() {
    return false;
  }

  void startUseItemTimer() {
    if (this.weapon() == null) {
      return;
    }
    if (this.curr_action == UnitAction.MOVING || this.curr_action == UnitAction.MOVING_AND_USING_ITEM) {
      this.curr_action = UnitAction.MOVING_AND_USING_ITEM;
    }
    else {
      this.curr_action = UnitAction.USING_ITEM;
    }
    this.timer_actionTime = this.weapon().useTime();
    switch(this.weapon().ID) {
      case 2101: // crumb
      case 2102: // unknown food
      case 2103: // unknown food
      case 2104: // unknown food
      case 2105: // unknown food
      case 2106: // pickle
      case 2107: // ketchup
      case 2108: // chicken wing
      case 2109: // steak
      case 2110: // poptart
      case 2111: // donut
      case 2112: // chocolate
      case 2113: // chips
      case 2114: // cheese
      case 2115: // peanuts
      case 2116: // raw chicken
      case 2117: // cooked chicken
      case 2118: // chicken egg
      case 2119: // rotten flesh
        global.sounds.trigger_player("player/eat");
        break;
      case 2131: // water cup
      case 2132: // coke
      case 2133: // wine
      case 2134: // beer
      case 2141: // holy water
      case 2924: // Glass Bottle
      case 2925: // Water Bottle
      case 2926: // Canteen
      case 2927: // Water Jug
        global.sounds.trigger_player("player/drink");
        break;
      case 2301: // Slingshot
        global.sounds.trigger_player("items/slingshot_reload");
        break;
      case 2311: // Recurve Bow
        global.sounds.trigger_player("items/recurve_bow_reload");
        break;
      case 2312: // M1911
        global.sounds.trigger_player("items/m1911_reload");
        break;
      case 2321: // War Machine
        global.sounds.trigger_player("items/war_machine_reload");
        break;
      case 2322: // Five-Seven
      case 2343:
        global.sounds.trigger_player("items/five_seven_reload");
        break;
      case 2323: // Type25
      case 2344:
        global.sounds.trigger_player("items/type25_reload");
        break;
      case 2331: // Mustang and Sally
        global.sounds.trigger_player("items/mustang_and_sally_reload");
        break;
      case 2332: // FAL
      case 2352:
        global.sounds.trigger_player("items/FAL_reload");
        break;
      case 2333: // Python
      case 2354:
        global.sounds.trigger_player("items/python_reload");
      case 2341: // RPG
      case 2362:
        global.sounds.trigger_player("items/RPG_reload");
        break;
      case 2342: // Dystopic Demolisher
        global.sounds.trigger_player("items/dystopic_demolisher_reload");
        break;
      case 2345: // Executioner
      case 2364:
        global.sounds.trigger_player("items/executioner_reload");
        break;
      case 2351: // Galil
      case 2373:
        global.sounds.trigger_player("items/galil_reload");
        break;
      case 2353: // Ballistic Knife
      case 2374:
        global.sounds.trigger_player("items/ballistic_knife_reload");
        break;
      case 2355: // MTAR
      case 2375:
        global.sounds.trigger_player("items/MTAR_reload");
        break;
      case 2361: // RPD
      case 2381: // Relativistic Punishment Device
        global.sounds.trigger_player("items/RPD_reload");
        break;
      case 2363: // DSR-50
      case 2382:
        global.sounds.trigger_player("items/DSR50_reload");
        break;
      case 2371: // HAMR
      case 2391:
        global.sounds.trigger_player("items/HAMR_reload");
        break;
      case 2372: // Ray Gun
      case 2392: // Porter's X2 Ray Gun
        global.sounds.trigger_player("items/ray_gun_reload");
        break;
      case 2921: // Backpack
      case 2922: // Ben's Backpack
      case 2923: // Purse
        global.sounds.trigger_player("player/armor_cloth");
        break;
      default:
        break;
    }
  }

  @Override
  void useItem(GameMap map) {
    this.useItem(map, new InventoryKey(InventoryLocation.GEAR, 3));
  }
  void useItem(GameMap map, InventoryKey location) {
    Item i = this.inventory.getItem(location);
    if (i == null || !i.usable() || i.remove) {
      return;
    }
    if (i.consumable()) {
      this.heal(i.curr_health);
      this.increaseHunger(i.hunger);
      this.increaseThirst(i.thirst);
      this.money += i.money;
      switch(i.ID) {
        case 2116: // raw chicken
          if (randomChance(0.5)) {
            this.addStatusEffect(StatusEffectCode.SICK, 6000);
          }
          break;
        case 2118: // chicken egg
          if (randomChance(0.25)) {
            this.addStatusEffect(StatusEffectCode.SICK, 5000);
          }
          break;
        case 2119: // rotten flesh
          if (randomChance(0.8)) {
            this.addStatusEffect(StatusEffectCode.SICK, 8000);
          }
          break;
      }
      i.consumed();
      return;
    }
    if (i.reloadable()) {
      while(i.maximumAmmo() - i.availableAmmo() > 0) {
        ArrayList<Integer> possible_ammo = i.possibleAmmo();
        boolean noAmmo = true;
        for (int id : possible_ammo) {
          InventoryKey ammoLocation = this.inventory.itemLocation(id, InventoryLocation.INVENTORY);
          if (ammoLocation != null) {
            Item ammo = this.inventory.slots.get(ammoLocation.index).item;
            int ammoLoaded = min(i.maximumAmmo() - i.availableAmmo(), ammo.stack);
            ammo.removeStack(ammoLoaded);
            i.ammo += ammoLoaded;
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
    if (i.money()) {
      // deposit if can
      return;
    }
    if (i.utility()) {
      switch(i.ID) {
        case 2921: // backpack
          this.inventory.addSlots(2);
          i.remove = true;
          break;
        case 2922: // Ben's backpack
          this.inventory.addSlots(4);
          i.remove = true;
          break;
        case 2923: // purse
          this.inventory.addSlots(1);
          i.remove = true;
          break;
        case 2924: // water bottles
        case 2925:
        case 2926:
        case 2927:
          int thirst_quenched = min(100 - this.thirst, i.ammo);
          i.ammo -= thirst_quenched;
          this.increaseThirst(thirst_quenched);
          break;
      }
      return;
    }
    global.log("WARNING: Trying to use item " + i.display_name() + " but no logic exists to use it.");
  }


  @Override
  void destroy(GameMap map) {
    super.destroy(map);
    this.inventory.clear();
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
    this.setHunger(this.hunger + amount);
  }

  void setHunger(int amount) {
    this.hunger = amount;
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
    this.setThirst(this.thirst + amount);
  }

  void setThirst(int amount) {
    this.thirst = amount;
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

  void changeMana(float amount) {
    this.setMana(this.curr_mana + amount);
  }

  void setMana(float amount) {
    this.curr_mana = amount;
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
        case '1':
          if (global.holding_ctrl) {
            break;
          }
          this.inventory_bar.setEquippedIndex(0);
          break;
        case '2':
          if (global.holding_ctrl) {
            break;
          }
          this.inventory_bar.setEquippedIndex(1);
          break;
        case '3':
          if (global.holding_ctrl) {
            break;
          }
          this.inventory_bar.setEquippedIndex(2);
          break;
        case '4':
          if (global.holding_ctrl) {
            break;
          }
          this.inventory_bar.setEquippedIndex(3);
          break;
        case '5':
          if (global.holding_ctrl) {
            break;
          }
          this.inventory_bar.setEquippedIndex(4);
          break;
        case '6':
          if (global.holding_ctrl) {
            break;
          }
          this.inventory_bar.setEquippedIndex(5);
          break;
        case '7':
          if (global.holding_ctrl) {
            break;
          }
          this.inventory_bar.setEquippedIndex(6);
          break;
        case '8':
          if (global.holding_ctrl) {
            break;
          }
          this.inventory_bar.setEquippedIndex(7);
          break;
        case '9':
          if (global.holding_ctrl) {
            break;
          }
          this.inventory_bar.setEquippedIndex(8);
          break;
        case '0':
          if (global.holding_ctrl) {
            break;
          }
          this.inventory_bar.setEquippedIndex(9);
          break;
        case 'w':
        case 'W':
          if (global.holding_ctrl) {
            break;
          }
          if (this.weapon() != null) {
            this.gear.put(GearSlot.WEAPON, this.inventory.stash(this.weapon()));
          }
          break;
        case 'e':
        case 'E':
          if (global.holding_ctrl) {
            break;
          }
          this.inventory.viewing = !this.inventory.viewing;
          if (!this.inventory.viewing) {
            if (EnderChestInventory.class.isInstance(this.inventory.feature_inventory)) {
              global.notViewingEnderChest();
            }
            this.inventory.feature_inventory = null;
            this.inventory.dropItemHolding();
          }
          break;
        case 'r':
        case 'R':
          if (global.holding_ctrl || !this.in_control) {
            break;
          }
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
            this.startUseItemTimer();
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


  @Override
  String fileString() {
    String fileString = "\nnew: Hero: " + this.ID;
    fileString += super.fileString(false);
    fileString += "\nlevel_location: " + this.location.file_name();
    fileString += "\nlevel_tokens: " + this.level_tokens;
    fileString += "\nexperience: " + this.experience;
    fileString += "\nexperience_next_level: " + this.experience_next_level;
    fileString += "\nmoney: " + this.money;
    fileString += "\ncurr_mana: " + this.curr_mana;
    fileString += "\nhunger: " + this.hunger;
    fileString += "\nthirst: " + this.thirst;
    fileString += "\nhunger_timer: " + this.hunger_timer;
    fileString += "\nthirst_timer: " + this.thirst_timer;
    fileString += this.inventory.fileString();
    for (HeroTreeCode code : this.heroTree.unlockedCodes()) {
      fileString += "\nperk: " + code.file_name();
    }
    fileString += "\nend: Hero\n";
    return fileString;
  }


  @Override
  void addData(String datakey, String data) {
    switch(datakey) {
      case "level_location":
        this.location = Location.location(data);
        break;
      case "perk":
        HeroTreeCode tree_code = HeroTreeCode.code(data);
        if (tree_code != null) {
          this.heroTree.unlockNode(tree_code, true);
        }
        break;
      case "level_tokens":
        this.level_tokens = toInt(data);
        break;
      case "experience":
        this.experience = toFloat(data);
        break;
      case "experience_next_level":
        this.experience_next_level = toInt(data);
        break;
      case "money":
        this.money = toFloat(data);
        break;
      case "curr_mana":
        this.curr_mana = toFloat(data);
        break;
      case "hunger":
        this.hunger = toInt(data);
        break;
      case "thirst":
        this.thirst = toInt(data);
        break;
      case "hunger_timer":
        this.hunger_timer = toInt(data);
        break;
      case "thirst_timer":
        this.thirst_timer = toInt(data);
        break;
      default:
        super.addData(datakey, data);
        break;
    }
  }
}


Hero readHeroFile(String filePath) {
  Hero hero = null;
  String[] lines = loadStrings(filePath);
  if (lines == null) {
    global.errorMessage("ERROR: Reading hero at path " + filePath + " but no hero file exists.");
    return null;
  }
  Stack<ReadFileObject> object_queue = new Stack<ReadFileObject>();
  StatusEffectCode curr_status_code = StatusEffectCode.ERROR;
  StatusEffect curr_status = null;
  Ability curr_ability = null;
  Item curr_item = null;
  boolean ended_hero = false;
  for (String line : lines) {
    String[] parameters = split(line, ':');
    if (parameters.length < 2) {
      continue;
    }
    String dataname = trim(parameters[0]);
    String data = trim(parameters[1]);
    for (int i = 2; i < parameters.length; i++) {
      data += ":" + parameters[i];
    }
    if (dataname.equals("new")) {
      ReadFileObject type = ReadFileObject.objectType(trim(parameters[1]));
      switch(type) {
        case HERO:
          if (parameters.length < 3) {
            global.errorMessage("ERROR: Unit ID missing in Hero constructor.");
            break;
          }
          object_queue.push(type);
          hero = new Hero(toInt(trim(parameters[2])));
          hero.abilities.clear();
          break;
        case INVENTORY:
          if (hero == null) {
            global.errorMessage("ERROR: Trying to start an inventory in a null hero.");
          }
          object_queue.push(type);
          break;
        case ITEM:
          if (hero == null) {
            global.errorMessage("ERROR: Trying to start an item in a null hero.");
          }
          if (parameters.length < 3) {
            global.errorMessage("ERROR: Item ID missing in Item constructor.");
            break;
          }
          object_queue.push(type);
          curr_item = new Item(toInt(trim(parameters[2])));
          break;
        case STATUS_EFFECT:
          if (hero == null) {
            global.errorMessage("ERROR: Trying to start a status effect in a null hero.");
          }
          object_queue.push(type);
          curr_status = new StatusEffect();
          break;
        case ABILITY:
          if (hero == null) {
            global.errorMessage("ERROR: Trying to start an ability in a null hero.");
          }
          if (parameters.length < 3) {
            global.errorMessage("ERROR: Ability ID missing in Projectile constructor.");
            break;
          }
          object_queue.push(type);
          curr_ability = new Ability(toInt(trim(parameters[2])));
          break;
        default:
          global.errorMessage("ERROR: Can't add a " + type + " type to Heroes data.");
          break;
      }
    }
    else if (dataname.equals("end")) {
      ReadFileObject type = ReadFileObject.objectType(trim(parameters[1]));
      if (object_queue.empty()) {
        global.errorMessage("ERROR: Tring to end a " + type.name + " object but not inside any object.");
      }
      else if (type.name.equals(object_queue.peek().name)) {
        switch(object_queue.pop()) {
          case HERO:
            if (hero == null) {
              global.errorMessage("ERROR: Trying to end a null hero.");
              break;
            }
            if (!object_queue.empty()) {
              global.errorMessage("ERROR: Trying to end a hero but inside another object.");
              break;
            }
            if (hero.code == HeroCode.ERROR) {
              global.errorMessage("ERROR: Trying to end hero with errored code.");
              break;
            }
            ended_hero = true;
            break;
          case INVENTORY:
            if (hero == null) {
              global.errorMessage("ERROR: Trying to end an inventory in a null hero.");
              break;
            }
            break;
          case ITEM:
            if (curr_item == null) {
              global.errorMessage("ERROR: Trying to end a null item.");
              break;
            }
            if (object_queue.empty()) {
              global.errorMessage("ERROR: Trying to end an item not inside any other object.");
              break;
            }
            if (object_queue.peek() != ReadFileObject.HERO) {
              global.errorMessage("ERROR: Trying to end an ability not inside a hero.");
              break;
            }
            switch(object_queue.peek()) {
              case HERO:
                if (parameters.length < 3) {
                  global.errorMessage("ERROR: GearSlot code missing in Item constructor.");
                  break;
                }
                GearSlot code = GearSlot.gearSlot(trim(parameters[2]));
                if (hero == null) {
                  global.errorMessage("ERROR: Trying to add gear to null hero.");
                  break;
                }
                hero.gear.put(code, curr_item);
                break;
              case INVENTORY:
                if (parameters.length < 3) {
                  global.errorMessage("ERROR: No positional information for inventory item.");
                  break;
                }
                int index = toInt(trim(parameters[2]));
                if (hero == null) {
                  global.errorMessage("ERROR: Trying to add inventory item to null hero.");
                  break;
                }
                Item i = hero.inventory.placeAt(curr_item, index, true);
                if (i != null) {
                  global.errorMessage("ERROR: Item already exists at position " + index + ".");
                  break;
                }
                break;
              default:
                global.errorMessage("ERROR: Trying to end an item inside a " + object_queue.peek().name + ".");
                break;
            }
            curr_item = null;
            break;
          case STATUS_EFFECT:
            if (curr_status == null) {
              global.errorMessage("ERROR: Trying to end a null status effect.");
              break;
            }
            if (object_queue.empty()) {
              global.errorMessage("ERROR: Trying to end a status effect not inside any other object.");
              break;
            }
            if (object_queue.peek() != ReadFileObject.HERO) {
              global.errorMessage("ERROR: Trying to end a status effect not inside a hero.");
              break;
            }
            if (hero == null) {
              global.errorMessage("ERROR: Trying to end a status effect inside a null hero.");
              break;
            }
            hero.statuses.put(curr_status_code, curr_status);
            curr_status = null;
            break;
          case ABILITY:
            if (curr_ability == null) {
              global.errorMessage("ERROR: Trying to end a null ability.");
              break;
            }
            if (object_queue.empty()) {
              global.errorMessage("ERROR: Trying to end an ability not inside any other object.");
              break;
            }
            if (object_queue.peek() != ReadFileObject.HERO) {
              global.errorMessage("ERROR: Trying to end an ability not inside a hero.");
              break;
            }
            if (hero == null) {
              global.errorMessage("ERROR: Trying to end an ability inside a null hero.");
              break;
            }
            hero.abilities.add(curr_ability);
            curr_ability = null;
            break;
        }
      }
      else {
        global.errorMessage("ERROR: Tring to end a " + type.name + " object but current object is a " + object_queue.peek().name + ".");
      }
    }
    else {
      switch(object_queue.peek()) {
        case HERO:
          if (hero == null) {
            global.errorMessage("ERROR: Trying to add hero data to a null hero.");
            break;
          }
          if (dataname.equals("next_status_code")) {
            curr_status_code = StatusEffectCode.code(data);
          }
          else {
            hero.addData(dataname, data);
          }
          break;
        case INVENTORY:
          if (hero == null) {
            global.errorMessage("ERROR: Trying to add hero inventory data to a null hero.");
            break;
          }
          hero.inventory.addData(dataname, data);
          break;
        case ITEM:
          if (curr_item == null) {
            global.errorMessage("ERROR: Trying to add item data to a null item.");
            break;
          }
          curr_item.addData(dataname, data);
          break;
        case STATUS_EFFECT:
          if (curr_status == null) {
            global.errorMessage("ERROR: Trying to add status effect data to a null status effect.");
            break;
          }
          curr_status.addData(dataname, data);
          break;
        case ABILITY:
          if (curr_ability == null) {
            global.errorMessage("ERROR: Trying to add ability data to a null ability.");
            break;
          }
          curr_status.addData(dataname, data);
          break;
        default:
          break;
      }
    }
  }
  if (!ended_hero) {
    global.errorMessage("ERROR: Hero data never ended.");
    return null;
  }
  return hero;
}
