class Item extends MapObject {
  protected float size = Constants.item_defaultSize; // radius

  protected int tier = 1;

  // graphics
  protected BounceInt bounce = new BounceInt(Constants.item_bounceConstant);

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
        this.setStrings("Slingshot", "Ranged Weapon", "");
        break;
      case 2311:
        this.setStrings("Bow", "Ranged Weapon", "");
        this.tier = 2;
        break;
      case 2312:
        this.setStrings("M1911", "Ranged Weapon", "");
        this.tier = 2;
        break;
      case 2321:
        this.setStrings("War Machine", "Ranged Weapon", "");
        this.tier = 3;
        break;
      case 2322:
        this.setStrings("Five-Seven", "Ranged Weapon", "");
        this.tier = 3;
        break;
      case 2323:
        this.setStrings("Type25", "Ranged Weapon", "");
        this.tier = 3;
        break;
      case 2331:
        this.setStrings("Mustang and Sally", "Ranged Weapon", "");
        this.tier = 4;
        break;
      case 2332:
        this.setStrings("FAL", "Ranged Weapon", "");
        this.tier = 4;
        break;
      case 2333:
        this.setStrings("Python", "Ranged Weapon", "");
        this.tier = 4;
        break;
      case 2341:
        this.setStrings("RPG", "Ranged Weapon", "");
        this.tier = 5;
        break;
      case 2342:
        this.setStrings("Dystopic Demolisher", "Ranged Weapon", "");
        this.tier = 5;
        break;
      case 2343:
        this.setStrings("Ultra", "Ranged Weapon", "");
        this.tier = 5;
        break;
      case 2344:
        this.setStrings("Strain25", "Ranged Weapon", "");
        this.tier = 5;
        break;
      case 2345:
        this.setStrings("Executioner", "Ranged Weapon", "");
        this.tier = 5;
        break;
      case 2351:
        this.setStrings("Galil", "Ranged Weapon", "");
        this.tier = 6;
        break;
      case 2352:
        this.setStrings("WN", "Ranged Weapon", "");
        this.tier = 6;
        break;
      case 2353:
        this.setStrings("Ballistic Knife", "Ranged Weapon", "");
        this.tier = 6;
        break;
      case 2354:
        this.setStrings("Cobra", "Ranged Weapon", "");
        this.tier = 6;
        break;
      case 2355:
        this.setStrings("MTAR", "Ranged Weapon", "");
        this.tier = 6;
        break;
      case 2361:
        this.setStrings("RPD", "Ranged Weapon", "");
        this.tier = 7;
        break;
      case 2362:
        this.setStrings("Rocket-Propelled Grievance", "Ranged Weapon", "");
        this.tier = 7;
        break;
      case 2363:
        this.setStrings("DSR-50", "Ranged Weapon", "");
        this.tier = 7;
        break;
      case 2364:
        this.setStrings("Vioce of Justice", "Ranged Weapon", "");
        this.tier = 7;
        break;
      case 2371:
        this.setStrings("HAMR", "Ranged Weapon", "");
        this.tier = 8;
        break;
      case 2372:
        this.setStrings("Ray Gun", "Ranged Weapon", "");
        this.tier = 8;
        break;
      case 2373:
        this.setStrings("Lamentation", "Ranged Weapon", "");
        this.tier = 8;
        break;
      case 2374:
        this.setStrings("The Krauss Refibrillator", "Ranged Weapon", "");
        this.tier = 8;
        break;
      case 2375:
        this.setStrings("Malevolent Taxonomic Anodized Redeemer", "Ranged Weapon", "");
        this.tier = 8;
        break;
      case 2381:
        this.setStrings("Relativistic Punishment Device", "Ranged Weapon", "");
        this.tier = 9;
        break;
      case 2382:
        this.setStrings("Dead Speciemen Reactor 5000", "Ranged Weapon", "");
        this.tier = 9;
        break;
      case 2391:
        this.setStrings("SLDG HAMR", "Ranged Weapon", "");
        this.tier = 10;
        break;
      case 2392:
        this.setStrings("Porter's X2 Ray Gun", "Ranged Weapon", "");
        this.tier = 10;
        break;

      // Headgear
      case 2401:
        this.setStrings("Talc Helmet", "Headgear", "");
        break;
      case 2402:
        this.setStrings("Cap", "Headgear", "");
        break;
      case 2403:
        this.setStrings("Bowl", "Headgear", "");
        break;
      case 2404:
        this.setStrings("Pot", "Headgear", "");
        break;
      case 2411:
        this.setStrings("Gypsum Helmet", "Headgear", "");
        this.tier = 2;
        break;
      case 2421:
        this.setStrings("Calcite Helmet", "Headgear", "");
        this.tier = 3;
        break;
      case 2431:
        this.setStrings("Fluorite Helmet", "Headgear", "");
        this.tier = 4;
        break;
      case 2441:
        this.setStrings("Apatite Helmet", "Headgear", "");
        this.tier = 5;
        break;
      case 2451:
        this.setStrings("Orthoclase Helmet", "Headgear", "");
        this.tier = 6;
        break;
      case 2461:
        this.setStrings("Quartz Helmet", "Headgear", "");
        this.tier = 7;
        break;
      case 2471:
        this.setStrings("Topaz Helmet", "Headgear", "");
        this.tier = 8;
        break;
      case 2481:
        this.setStrings("Corundum Helmet", "Headgear", "");
        this.tier = 9;
        break;
      case 2491:
        this.setStrings("Diamond Helmet", "Headgear", "");
        this.tier = 10;
        break;

      // Chestgear
      case 2501:
        this.setStrings("Talc Armor", "Chestgear", "");
        break;
      case 2502:
        this.setStrings("T-Shirt", "Chestgear", "");
        break;
      case 2503:
        this.setStrings("Bra", "Chestgear", "");
        break;
      case 2504:
        this.setStrings("Coat", "Chestgear", "");
        break;
      case 2511:
        this.setStrings("Gypsum Armor", "Chestgear", "");
        this.tier = 2;
        break;
      case 2512:
        this.setStrings("Ben's Coat", "Chestgear", "");
        this.tier = 2;
        break;
      case 2513:
        this.setStrings("Suit Jacket", "Chestgear", "");
        this.tier = 2;
        break;
      case 2521:
        this.setStrings("Calcite Armor", "Chestgear", "");
        this.tier = 3;
        break;
      case 2531:
        this.setStrings("Fluorite Armor", "Chestgear", "");
        this.tier = 4;
        break;
      case 2541:
        this.setStrings("Apatite Armor", "Chestgear", "");
        this.tier = 5;
        break;
      case 2551:
        this.setStrings("Orthoclase Armor", "Chestgear", "");
        this.tier = 6;
        break;
      case 2561:
        this.setStrings("Quartz Armor", "Chestgear", "");
        this.tier = 7;
        break;
      case 2571:
        this.setStrings("Topaz Armor", "Chestgear", "");
        this.tier = 8;
        break;
      case 2581:
        this.setStrings("Corundum Armor", "Chestgear", "");
        this.tier = 9;
        break;
      case 2591:
        this.setStrings("Diamond Armor", "Chestgear", "");
        this.tier = 10;
        break;

      // Leggear
      case 2601:
        this.setStrings("Talc Greaves", "Leggear", "");
        break;
      case 2602:
        this.setStrings("Boxers", "Leggear", "");
        break;
      case 2603:
        this.setStrings("Towel", "Leggear", "");
        break;
      case 2604:
        this.setStrings("Pants", "Leggear", "");
        break;
      case 2611:
        this.setStrings("Gypsum Greaves", "Leggear", "");
        this.tier = 2;
        break;
      case 2622:
        this.setStrings("Calcite Greaves", "Leggear", "");
        this.tier = 3;
        break;
      case 2631:
        this.setStrings("Fluorite Greaves", "Leggear", "");
        this.tier = 4;
        break;
      case 2641:
        this.setStrings("Apatite Greaves", "Leggear", "");
        this.tier = 5;
        break;
      case 2651:
        this.setStrings("Orthoclase Greaves", "Leggear", "");
        this.tier = 6;
        break;
      case 2661:
        this.setStrings("Quartz Greaves", "Leggear", "");
        this.tier = 7;
        break;
      case 2671:
        this.setStrings("Topaz Greaves", "Leggear", "");
        this.tier = 8;
        break;
      case 2681:
        this.setStrings("Corundum Greaves", "Leggear", "");
        this.tier = 9;
        break;
      case 2691:
        this.setStrings("Diamond Greaves", "Leggear", "");
        this.tier = 10;
        break;

      // Footgear
      case 2701:
        this.setStrings("Talc Boots", "Footgear", "");
        break;
      case 2702:
        this.setStrings("Socks", "Footgear", "");
        break;
      case 2703:
        this.setStrings("Sandals", "Footgear", "");
        break;
      case 2704:
        this.setStrings("Shoes", "Footgear", "");
        break;
      case 2705:
        this.setStrings("Boots", "Footgear", "");
        break;
      case 2711:
        this.setStrings("Gypsum Boots", "Footgear", "");
        this.tier = 2;
        break;
      case 2712:
        this.setStrings("Sneakers", "Footgear", "");
        this.tier = 2;
        break;
      case 2713:
        this.setStrings("Steel-Toed Boots", "Footgear", "");
        this.tier = 2;
        break;
      case 2714:
        this.setStrings("Cowboy Boots", "Footgear", "");
        this.tier = 2;
        break;
      case 2721:
        this.setStrings("Calcite Boots", "Footgear", "");
        this.tier = 3;
        break;
      case 2731:
        this.setStrings("Fluorite Boots", "Footgear", "");
        this.tier = 4;
        break;
      case 2741:
        this.setStrings("Apatite Boots", "Footgear", "");
        this.tier = 5;
        break;
      case 2751:
        this.setStrings("Orthoclase Boots", "Footgear", "");
        this.tier = 6;
        break;
      case 2761:
        this.setStrings("Quartz Boots", "Footgear", "");
        this.tier = 7;
        break;
      case 2771:
        this.setStrings("Topaz Boots", "Footgear", "");
        this.tier = 8;
        break;
      case 2781:
        this.setStrings("Corundum Boots", "Footgear", "");
        this.tier = 9;
        break;
      case 2791:
        this.setStrings("Diamond Boots", "Footgear", "");
        this.tier = 10;
        break;

      // Material
      case 2801:
        this.setStrings("Talc", "Material", "");
        break;
      case 2802:
        this.setStrings("Glass", "Material", "");
        break;
      case 2803:
        this.setStrings("Wire", "Material", "");
        break;
      case 2811:
        this.setStrings("Gypsum", "Material", "");
        this.tier = 2;
        break;
      case 2812:
        this.setStrings("Barbed Wire", "Material", "");
        this.tier = 2;
        break;
      case 2821:
        this.setStrings("Calcite", "Material", "");
        this.tier = 3;
        break;
      case 2822:
        this.setStrings("Star Piece", "Material", "");
        this.tier = 3;
        break;
      case 2831:
        this.setStrings("Fluorite", "Material", "");
        this.tier = 4;
        break;
      case 2841:
        this.setStrings("Apatite", "Material", "");
        this.tier = 5;
        break;
      case 2851:
        this.setStrings("Orthoclase", "Material", "");
        this.tier = 6;
        break;
      case 2861:
        this.setStrings("Quartz", "Material", "");
        this.tier = 7;
        break;
      case 2871:
        this.setStrings("Topaz", "Material", "");
        this.tier = 8;
        break;
      case 2881:
        this.setStrings("Corundum", "Material", "");
        this.tier = 9;
        break;
      case 2891:
        this.setStrings("Diamond", "Material", "");
        this.tier = 10;
        break;

      // Other
      case 2901:
        this.setStrings("Key", "Key", "");
        break;
      case 2902:
        this.setStrings("Master Key", "Key", "");
        this.tier = 2;
        break;
      case 2903:
        this.setStrings("Skeleton Key", "Key", "");
        this.tier = 3;
        break;
      case 2911:
        this.setStrings("Pen", "Office", "");
        break;
      case 2912:
        this.setStrings("Pencil", "Office", "");
        break;
      case 2913:
        this.setStrings("Paper", "Office", "");
        break;
      case 2914:
        this.setStrings("Document", "Office", "");
        break;
      case 2915:
        this.setStrings("Stapler", "Office", "");
        break;
      case 2916:
        this.setStrings("Crumpled Paper", "Office", "");
        break;
      case 2917:
        this.setStrings("Eraser", "Office", "");
        break;
      case 2921:
        this.setStrings("Backpack", "Utility", "");
        break;
      case 2922:
        this.setStrings("Ben's Backpack", "Utility", "");
        this.tier = 2;
        break;
      case 2923:
        this.setStrings("Purse", "Utility", "");
        break;
      case 2924:
        this.setStrings("Glass Bottle", "Utility", "");
        break;
      case 2925:
        this.setStrings("Water Bottle", "Utility", "");
        break;
      case 2926:
        this.setStrings("Canteen", "Utility", "");
        this.tier = 2;
        break;
      case 2927:
        this.setStrings("Water Jug", "Utility", "");
        this.tier = 3;
        break;
      case 2931:
        this.setStrings("Rock", "Ammo", "");
        break;
      case 2932:
        this.setStrings("Arrow", "Ammo", "");
        break;
      case 2933:
        this.setStrings("Pebble", "Ammo", "");
        break;
      case 2941:
        this.setStrings(".45 ACP", "Ammo", "");
        break;
      case 2942:
        this.setStrings("7.62x39mm", "Ammo", "");
        this.tier = 2;
        break;
      case 2943:
        this.setStrings("5.56x45mm", "Ammo", "");
        this.tier = 2;
        break;
      case 2944:
        this.setStrings("Grenade", "Ammo", "");
        this.tier = 2;
        break;
      case 2945:
        this.setStrings(".357 Magnum", "Ammo", "");
        this.tier = 2;
        break;
      case 2946:
        this.setStrings(".50 BMG", "Ammo", "");
        this.tier = 2;
        break;
      case 2947:
        this.setStrings("FN 5.7x28mm", "Ammo", "");
        this.tier = 2;
        break;
      case 2948:
        this.setStrings("28 Gauge", "Ammo", "");
        this.tier = 2;
        break;
      case 2961:
        this.setStrings("Dandelion", "Nature", "");
        break;
      case 2962:
        this.setStrings("Rose", "Nature", "");
        break;
      case 2963:
        this.setStrings("Stick", "Nature", "");
        break;
      case 2964:
        this.setStrings("Kindling", "Nature", "");
        break;
      case 2965:
        this.setStrings("Branch", "Nature", "");
        break;
      case 2966:
        this.setStrings("Branch", "Nature", "");
        break;
      case 2967:
        this.setStrings("Branch", "Nature", "");
        break;
      case 2971:
        this.setStrings("Ax", "Tool", "");
        this.tier = 2;
        break;
      case 2972:
        this.setStrings("Wire Clippers", "Tool", "");
        this.tier = 2;
        break;
      case 2973:
        this.setStrings("Window Breaker", "Tool", "");
        this.tier = 2;
        break;
      case 2974:
        this.setStrings("Rope", "Tool", "");
        this.tier = 2;
        break;
      case 2975:
        this.setStrings("Paintbrush", "Tool", "");
        break;
      case 2976:
        this.setStrings("Clamp", "Tool", "");
        break;
      case 2977:
        this.setStrings("Saw", "Tool", "");
        this.tier = 2;
        break;
      case 2978:
        this.setStrings("Roundsaw", "Tool", "");
        this.tier = 3;
        break;
      case 2979:
        this.setStrings("Beltsander", "Tool", "");
        this.tier = 3;
        break;
      case 2980:
        this.setStrings("Chainsaw", "Tool", "");
        this.tier = 3;
        break;
      case 2981:
        this.setStrings("Hammer", "Tool", "");
        this.tier = 2;
        break;
      case 2982:
        this.setStrings("Drill", "Tool", "");
        this.tier = 3;
        break;
      case 2983:
        this.setStrings("Wrench", "Tool", "");
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
    this.bounce.add(timeElapsed);
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
