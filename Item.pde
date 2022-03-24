class Item extends MapObject {
  protected float size = Constants.item_defaultSize; // radius

  protected int tier = 1;

  Item(int ID) {
    super(ID);
    switch(ID) {
      // Consumables
      case 2101:
        this.setStrings("Crumb", "Consumable", "");
        break;
      case 2102:
        this.setStrings("Unknown Food", "Consumable", "");
        break;
      case 2103:
        this.setStrings("Unknown Food", "Consumable", "");
        break;
      case 2104:
        this.setStrings("Unknown Food", "Consumable", "");
        break;
      case 2105:
        this.setStrings("Unknown Food", "Consumable", "");
        break;
      case 2106:
        this.setStrings("Pickle", "Consumable", "");
        break;
      case 2107:
        this.setStrings("Ketchup", "Consumable", "");
        break;
      case 2108:
        this.setStrings("Chicken Wing", "Consumable", "");
        break;
      case 2109:
        this.setStrings("Steak", "Consumable", "");
        break;
      case 2110:
        this.setStrings("Poptart", "Consumable", "");
        break;
      case 2111:
        this.setStrings("Donut", "Consumable", "");
        break;
      case 2112:
        this.setStrings("Chocolate", "Consumable", "");
        break;
      case 2113:
        this.setStrings("Chips", "Consumable", "");
        break;
      case 2114:
        this.setStrings("Cheese", "Consumable", "");
        break;
      case 2131:
        this.setStrings("Water Cup", "Consumable", "");
        break;
      case 2132:
        this.setStrings("Coke", "Consumable", "");
        break;
      case 2133:
        this.setStrings("Wine", "Consumable", "");
        break;
      case 2134:
        this.setStrings("Beer", "Consumable", "");
        break;
      case 2141:
        this.setStrings("Holy Water", "Consumable", "");
        this.tier = 2;
        break;
      case 2142:
        this.setStrings("Golden Apple", "Consumable", "");
        this.tier = 3;
        break;
      case 2151:
        this.setStrings("One Dollar", "Money", "");
        break;
      case 2152:
        this.setStrings("Five Dollars", "Money", "");
        break;
      case 2153:
        this.setStrings("Ten Dollars", "Money", "");
        break;
      case 2154:
        this.setStrings("Fifty Dollars", "Money", "");
        break;
      case 2155:
        this.setStrings("Zucc Bucc", "Money", "");
        this.tier = 2;
        break;
      case 2156:
        this.setStrings("Wad of 5s", "Money", "");
        this.tier = 2;
        break;
      case 2157:
        this.setStrings("Wad of 10s", "Money", "");
        this.tier = 2;
        break;
      case 2158:
        this.setStrings("Wad of 50s", "Money", "");
        this.tier = 2;
        break;
      case 2159:
        this.setStrings("Wad of Zuccs", "Money", "");
        this.tier = 3;
        break;

      // Melee Weapons
      case 2201:
        this.setStrings("Foam Sword", "Melee Weapon", "");
        break;
      case 2202:
        this.setStrings("Pan", "Melee Weapon", "");
        break;
      case 2203:
        this.setStrings("Knife", "Melee Weapon", "");
        break;
      case 2204:
        this.setStrings("Decoy", "Melee Weapon", "");
        break;
      case 2211:
        this.setStrings("The Thing", "Melee Weapon", "");
        this.tier = 2;
        break;
      case 2212:
        this.setStrings("Machete", "Melee Weapon", "");
        this.tier = 2;
        break;
      case 2213:
        this.setStrings("Spear", "Melee Weapon", "");
        this.tier = 2;
        break;

      // Ranged Weapons
      case 2301:
        this.setStrings("Foam Sword", "Melee Weapon", "");
        break;

      default:
        println("ERROR: Item ID " + ID + " not found.");
        break;
    }
  }

  String display_name() {
    return this.display_name;
  }
  String type() {
    return this.type;
  }
  String description() {
    return this.description;
  }

  void setLocation(float x, float y) {
    this.x = x;
    this.y = y;
  }

  float xi() {
    return this.x - this.size;
  }
  float yi() {
    return this.y - this.size;
  }
  float xf() {
    return this.x + this.size;
  }
  float yf() {
    return this.y + this.size;
  }
  float xCenter() {
    return this.x;
  }
  float yCenter() {
    return this.y;
  }
  float width() {
    return 2 * this.size;
  }
  float height() {
    return 2 * this.size;
  }
  float xRadius() {
    return this.size;
  }
  float yRadius() {
    return this.size;
  }

  PImage getImage() {
    String path = "items/";
    switch(this.ID) {
      case 2101:
        path += "crumb.png";
        break;
      default:
        println("ERROR: Item ID " + ID + " not found.");
        path += "default.png";
        break;
    }
    return global.images.getImage(path);
  }

  void update(int timeElapsed) {
    // remove timer if active
    // bounce int for graphics
  }

  String fileString() {
    String fileString = "\nnew: Item: " + this.ID;
    fileString += this.objectFileString();
    fileString += "\nsize: " + this.size;
    fileString += "\nend: Item\n";
    return fileString;
  }

  void addData(String datakey, String data) {
    if (this.addObjectData(datakey, data)) {
      return;
    }
    switch(datakey) {
      case "size":
        this.size = toFloat(data);
        break;
      default:
        println("ERROR: Datakey " + datakey + " not found for item data.");
        break;
    }
  }
}
