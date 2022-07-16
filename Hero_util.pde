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
        return "Dan Gray";
      case JF:
        return "JIF";
      case SPINNY:
        return "Mark Spinny";
      case MATTUS:
        return "Mad Dog Mattus";
      case PATRICK:
        return "Jeremiah";
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
        return "The Scourge of Sinners";
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
        return "According to legend, Ben simply glared at the nurse who " +
          "delivered him and she went rave starking mad. Like the kind of mad " +
          "where she quit her job and moved to Canada. But not like the mad " +
          "where she has to suppress the desire to kill everything that moves. " +
          "No, that second type of mad is more descriptive of Ben, whose " +
          "suppressed rage has been slowing taking ground from his sanity for " +
          "years. Don't be fooled by the slow, lazy, dorky-looking kid he " +
          "seems, Ben exists with a wild, raging nature which will never stop " +
          "trying to tear you to pieces once he finds the idea. Evidence of " +
          "this is found when you realize he plays Dark Souls.";
      case DAN:
        return "Once a socially-awkward, yo-yoing little boy, Dan Gray used " +
          "his knowledge of chemisty to concoct a concentrated frog serum. " +
          "He is now a terrifying human-frog hybrid with great thunder " +
          "thighs and a voracious appetite. He knows when to hide from an " +
          "enemy and when to pounce with frog-like fury. If his enemies try " +
          "running, Dan will easily catch them with his enormous (and most " +
          "certainly underbrushed) blood-red tongue.";
      case JF:
        return "Hide your husbands; hide your wives, because the one and only " +
          "heart breaking, love taking, tool making lean and mean country boy " +
          "is here. The epitome of modern American nationalism, JIF doesn't " +
          "need a mandate, minute, or man barking orders to defend his country " +
          "from danger. Soon after zombies overran continental United States, " +
          "JIF became head of the nation's finest paramilitary force. If he's " +
          "not chopping off the head of a normie zombie with an ax he hand-" +
          "crafted in his backyard, you can find him cracking a cold one with " +
          "the BOIZ while smokin' these meats.";
      case SPINNY:
        return "The incarnation of Catholic guilt in the flesh, Spinny roams " +
          "Earth looking for his next victim to cleanse. Any who stand in " +
          "his way find themselves engulfed in the fires of Hell. Even Pope " +
          "Francis, after trying to excommunicate Spinny, was charred to holy " +
          "toast before Spinny declared Francis an anti-pope and himself the " +
          "true Pope. Ever since, the entire Catholic Church has supported " +
          "Spinny, since Right of Conquest is no less than a Biblical mandate.";
      case MATTUS:
        return "Some say he is the rebirth of General Lee, others realize Lee " +
          "was less on the loud stuff and more on the proud stuff. Regardless, " +
          "Mad Dog Mattus became the overall commander of the New People's Freedon " +
          "Confederacy of American Workers and also States, which Mattus " +
          "believes is exactly like the Confederacy Lee once commanded. " +
          "Mattus obtained this position after falling into Georgia's largest " +
          "nuclear reactor, and emerging a tall-but-still-a-little-chubby " +
          "nuclear-emitting being with great insight in leading armies.";
      case PATRICK:
        return "Jeremiah has always had a bit of an identity crisis, at least " +
          "in the eyes of his beholders. Sometimes he even claims his name " +
          "isn't Jeremiah. Most of his hobbies involve things only gay trans " +
          "1/8 latinx half-American men are into, but if you dare try making " +
          "fun of him for any of it he'll mop the floor with your ass (since " +
          "he doesn't have one) without breaking a sweat. Although if you make " +
          "fun of him in a normal voice he probably won't hear you since " +
          "he has to keep pretending he's deaf as part of his identity.";
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

  public String imagePathHeader() {
    return HeroCode.imagePathHeader(this);
  }
  static public String imagePathHeader(HeroCode code) {
    switch(code) {
      case BEN:
        return "ben";
      case DAN:
        return "dan";
      case JF:
        return "jf";
      case SPINNY:
        return "spinny";
      case MATTUS:
        return "mattus";
      case PATRICK:
        return "patrick";
      default:
        return "default";
    }
  }

  public String getImagePath() {
    return HeroCode.getImagePath(this);
  }
  public String getImagePath(boolean ben_has_eyes) {
    return HeroCode.getImagePath(this, ben_has_eyes);
  }
  public String getImagePath(boolean ben_has_eyes, boolean circle_image) {
    return HeroCode.getImagePath(this, ben_has_eyes, circle_image);
  }
  static public String getImagePath(HeroCode code) {
    return HeroCode.getImagePath(code, true);
  }
  static public String getImagePath(HeroCode code, boolean ben_has_eyes) {
    return HeroCode.getImagePath(code, ben_has_eyes, true);
  }
  static public String getImagePath(HeroCode code, boolean ben_has_eyes, boolean circle_image) {
    String file_path = "units/" + HeroCode.imagePathHeader(code);
    if (circle_image) {
      file_path += "_circle";
    }
    if (code == HeroCode.BEN && !ben_has_eyes) {
      file_path += "_noeyes";
    }
    return file_path + ".png";
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
  CRAFTI, CRAFTII_ROW, CRAFTII_COL, CRAFTIII_ROW, CRAFTIII_COL,
  FOLLOWERI,
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
      case CRAFTI:
        return "CraftI";
      case CRAFTII_ROW:
        return "CraftII_row";
      case CRAFTII_COL:
        return "CraftII_col";
      case CRAFTIII_ROW:
        return "CraftIII_row";
      case CRAFTIII_COL:
        return "CraftIII_col";
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
      case 41:
        return HeroTreeCode.CRAFTI;
      case 42:
        return HeroTreeCode.CRAFTII_ROW;
      case 43:
        return HeroTreeCode.CRAFTII_COL;
      case 44:
        return HeroTreeCode.CRAFTIII_ROW;
      case 45:
        return HeroTreeCode.CRAFTIII_COL;
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
