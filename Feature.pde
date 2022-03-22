class Feature extends MapObject {
  protected int sizeX = 0;
  protected int sizeY = 0;
  protected int sizeZ = 0;

  protected int number = 0;
  protected boolean toggle = false;
  //protected Inventory inventory; // for items with inventory

  Feature(int ID) {
    super(ID);
    switch(ID) {
      // fog
      case 1:
        this.setStrings("Fog", "Fog", "");
        this.setSize(1, 1, 0);
        break;
      case 2:
        this.setStrings("Fog", "Fog", "");
        this.setSize(1, 1, 0);
        break;
      case 3:
        this.setStrings("Fog", "Fog", "");
        this.setSize(1, 1, 0);
        break;
      case 4:
        this.setStrings("Fog", "Fog", "");
        this.setSize(1, 1, 0);
        break;
      case 5:
        this.setStrings("Fog", "Fog", "");
        this.setSize(1, 1, 0);
        break;
      case 6:
        this.setStrings("Fog", "Fog", "");
        this.setSize(1, 1, 0);
        break;
      case 7:
        this.setStrings("Fog", "Fog", "");
        this.setSize(1, 1, 0);
        break;
      case 8:
        this.setStrings("Fog", "Fog", "");
        this.setSize(1, 1, 0);
        break;
      case 9:
        this.setStrings("Fog", "Fog", "");
        this.setSize(1, 1, 0);
        break;
      case 10:
        this.setStrings("Fog", "Fog", "");
        this.setSize(1, 1, 0);
        break;

      // Unique
      case 11:
        this.setStrings("Traveling Buddy", "NPC", "");
        this.setSize(3, 2, 6);
        break;
      case 12:
        this.setStrings("Chuck Quizmo", "NPC", "");
        this.setSize(1, 1, 5);
        break;
      case 21:
        this.setStrings("Workbench", "Tool", "");
        this.setSize(1, 1, 3);
        break;
      case 22:
        this.setStrings("Ender Chest", "Tool", "");
        this.setSize(1, 1, 3);
        break;

      // Furniture
      case 101:
        this.setStrings("Wooden Table", "Furniture", "");
        this.setSize(2, 2, 3);
        break;
      case 102:
        this.setStrings("Wooden Desk", "Furniture", "");
        this.setSize(2, 1, 4);
        break;
      case 103:
        this.setStrings("Wooden Desk", "Furniture", "");
        this.setSize(1, 2, 4);
        break;
      case 111:
      case 112:
      case 113:
      case 114:
        this.setStrings("Wooden Chair", "Furniture", "");
        this.setSize(1, 1, 2);
        break;
      case 115:
        this.setStrings("Coordinator Chair", "Furniture", "");
        this.setSize(1, 1, 2);
        break;
      case 121:
      case 122:
        this.setStrings("Couch", "Furniture", "");
        this.setSize(3, 1, 2);
        break;
      case 123:
      case 124:
        this.setStrings("Couch", "Furniture", "");
        this.setSize(1, 3, 2);
        break;
      case 125:
        this.setStrings("Bench", "Furniture", "");
        this.setSize(2, 1, 2);
        break;
      case 126:
        this.setStrings("Bench", "Furniture", "");
        this.setSize(1, 2, 2);
        break;
      case 127:
        this.setStrings("Bench", "Furniture", "");
        this.setSize(2, 3, 3);
        break;
      case 128:
        this.setStrings("Bench", "Furniture", "");
        this.setSize(3, 2, 3);
        break;
      case 131:
      case 132:
        this.setStrings("Bed", "Furniture", "");
        this.setSize(2, 3, 3);
        break;
      case 133:
      case 134:
        this.setStrings("Bed", "Furniture", "");
        this.setSize(3, 2, 3);
        break;
      case 141:
        this.setStrings("Wardrobe", "Furniture", "");
        this.setSize(2, 1, 9);
        break;
      case 142:
        this.setStrings("Wardrobe", "Furniture", "");
        this.setSize(1, 2, 9);
        break;
      case 151:
      case 152:
      case 153:
      case 154:
      case 155:
      case 156:
      case 157:
      case 158:
        this.setStrings("Sign", "Sign", "");
        this.setSize(1, 1, 2);
        break;
      case 161:
        this.setStrings("Water Fountain", "Furniture", "");
        this.setSize(1, 1, 4);
        break;
      case 162:
        this.setStrings("Sink", "Furniture", "");
        this.setSize(1, 1, 4);
        break;
      case 163:
        this.setStrings("Shower Stall", "Furniture", "");
        this.setSize(1, 1, -1);
        break;
      case 164:
        this.setStrings("Urinal", "Furniture", "");
        this.setSize(1, 1, 5);
        break;
      case 165:
        this.setStrings("Toilet", "Furniture", "");
        this.setSize(1, 1, 2);
        break;
      case 171:
        this.setStrings("Stove", "Appliance", "");
        this.setSize(1, 1, 4);
        break;
      case 172:
        this.setStrings("Vending Machine", "Appliance", "");
        this.setSize(1, 1, 7);
        break;
      case 173:
        this.setStrings("Vending Machine", "Appliance", "");
        this.setSize(1, 1, 7);
        break;
      case 174:
        this.setStrings("Minifridge", "Appliance", "");
        this.setSize(1, 1, 3);
        break;
      case 175:
        this.setStrings("Refridgerator", "Appliance", "");
        this.setSize(1, 1, 7);
        break;
      case 176:
        this.setStrings("Washer", "Appliance", "");
        this.setSize(1, 1, 4);
        break;
      case 177:
        this.setStrings("Dryer", "Appliance", "");
        this.setSize(1, 1, 4);
        break;
      case 181:
        this.setStrings("Garbage Can", "Furniture", "");
        this.setSize(1, 1, 4);
        break;
      case 182:
        this.setStrings("Recycle Can", "Furniture", "");
        this.setSize(1, 1, 4);
        break;
      case 183:
        this.setStrings("Crate", "Furniture", "");
        this.setSize(1, 1, 2);
        break;
      case 184:
        this.setStrings("Cardboard Box", "Furniture", "");
        this.setSize(1, 1, 2);
        break;
      case 185:
        this.setStrings("Pickle Jar", "Furniture", "");
        this.setSize(1, 1, 1);
        break;
      case 191:
      case 192:
      case 193:
      case 194:
        this.setStrings("Railing", "Furniture", "");
        this.setSize(1, 1, 5);
        break;
      case 201:
        this.setStrings("Steel Cross", "Statue", "");
        this.setSize(2, 2, 100);
        break;
      case 202:
        this.setStrings("Mary Statue", "Statue", "");
        this.setSize(1, 1, 6);
        break;
      case 211:
      case 212:
      case 213:
      case 214:
      case 215:
      case 216:
      case 217:
      case 218:
      case 219:
      case 220:
      case 221:
      case 222:
      case 223:
      case 224:
      case 225:
      case 226:
        this.setStrings("Wire Fence", "Fence", "");
        this.setSize(1, 1, 7);
        break;
      case 231:
      case 232:
      case 233:
      case 234:
      case 235:
      case 236:
      case 237:
      case 238:
      case 239:
      case 240:
      case 241:
      case 242:
      case 243:
      case 244:
      case 245:
      case 246:
        this.setStrings("Barbed Wire Fence", "Fence", "");
        this.setSize(1, 1, 9);
        break;
      case 251:
        this.setStrings("Parking Bumper", "Outdoors", "");
        this.setSize(3, 1, 1);
        break;
      case 252:
        this.setStrings("Parking Bumper", "Outdoors", "");
        this.setSize(1, 3, 1);
        break;

      // Walls
      case 301:
      case 302:
      case 303:
      case 304:
      case 305:
      case 306:
      case 307:
        this.setStrings("Brick Wall", "Wall", "");
        this.setSize(1, 1, 100);
        break;
      case 311:
      case 312:
        this.setStrings("Pillar", "Wall", "");
        this.setSize(1, 1, 100);
        break;
      case 321:
        this.setStrings("Window", "Window", "");
        this.setSize(1, 1, 0);
        break;
      case 322:
      case 323:
        this.setStrings("Window", "Window", "");
        this.setSize(1, 1, 100);
        break;
      case 331:
      case 332:
      case 333:
      case 334:
      case 335:
      case 336:
      case 337:
      case 338:
        this.setStrings("Wooden Door", "Door", "");
        this.setSize(1, 1, 0);
        break;
      case 339:
      case 340:
      case 341:
      case 342:
      case 343:
      case 344:
      case 345:
      case 346:
        this.setStrings("Wooden Door", "Door", "");
        this.setSize(1, 1, 100);
        break;

      // Nature
      case 401:
        this.setStrings("Dandelion", "Nature", "");
        this.setSize(1, 1, 0);
        break;
      case 411:
      case 412:
        this.setStrings("Gravel", "Nature", "");
        this.setSize(1, 1, 0);
        break;
      case 421:
      case 422:
      case 423:
      case 424:
        this.setStrings("Tree", "Nature", "");
        this.setSize(2, 2, 20);
        break;
      case 425:
        this.setStrings("Tree", "Nature", "");
        this.setSize(2, 2, 35);
        break;
      case 431:
        this.setStrings("Rock", "Nature", "");
        this.setSize(3, 2, 7);
        break;
      case 441:
      case 442:
      case 443:
        this.setStrings("Bush", "Nature", "");
        this.setSize(1, 1, 5);
        break;

      // Vehicles
      case 501:
        this.setStrings("Honda CR-V", "Car", "");
        this.setSize(5, 3, 5);
        break;
      case 502:
        this.setStrings("Ford F-150", "Car", "");
        this.setSize(5, 3, 5);
        break;
      case 503:
        this.setStrings("VW Jetta", "Car", "");
        this.setSize(5, 3, 5);
        break;
      case 504:
        this.setStrings("VW Bug", "Car", "");
        this.setSize(4, 3, 5);
        break;
      case 505:
        this.setStrings("Lamborghini", "Car", "");
        this.setSize(4, 4, 5);
        break;
      case 511:
        this.setStrings("Civilian Helicopter", "Helicopter", "");
        this.setSize(5, 5, 11);
        break;
      case 512:
        this.setStrings("Medical Helicopter", "Helicopter", "");
        this.setSize(5, 4, 11);
        break;
      case 513:
        this.setStrings("Military Helicopter", "Helicopter", "");
        this.setSize(5, 4, 11);
        break;

      default:
        println("ERROR: Feature ID " + ID + " not found.");
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
    this.x = floor(x);
    this.y = floor(y);
  }

  void setSize(int sizeX, int sizeY, int sizeZ) {
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.sizeZ = sizeZ;
  }

  float xi() {
    return this.x;
  }
  float yi() {
    return this.y;
  }
  float xf() {
    return this.x + this.sizeX;
  }
  float yf() {
    return this.y + this.sizeY;
  }
  float xCenter() {
    return this.x + 0.5 * this.sizeX;
  }
  float yCenter() {
    return this.y + 0.5 * this.sizeY;
  }
  float width() {
    return this.sizeX;
  }
  float height() {
    return this.sizeY;
  }
  float xRadius() {
    return 0.5 * this.sizeX;
  }
  float yRadius() {
    return 0.5 * this.sizeY;
  }

  PImage getImage() {
    String path = "features/";
    switch(this.ID) {
      case 1:
        path += "fog0.png";
        break;
      case 2:
        path += "fog1.png";
        break;
      case 3:
        path += "fog2.png";
        break;
      case 4:
        path += "fog3.png";
        break;
      case 5:
        path += "fog4.png";
        break;
      case 6:
        path += "fog5.png";
        break;
      case 7:
        path += "fog6.png";
        break;
      case 8:
        path += "fog7.png";
        break;
      case 9:
        path += "fog8.png";
        break;
      case 10:
        path += "fog9.png";
        break;
      case 101:
        path += "table.png";
        break;
      default:
        println("ERROR: Feature ID " + ID + " not found.");
        path += "default.png";
        break;
    }
    return global.images.getImage(path);
  }

  void update(int timeElapsed) {
    switch(this.ID) {
      default:
        break;
    }
  }

  String fileString() {
    String fileString = "\nnew: Feature: " + this.ID;
    fileString += this.objectFileString();
    fileString += "\nnumber: " + this.number;
    fileString += "\ntoggle: " + this.toggle;
    fileString += "\nend: Feature\n";
    return fileString;
  }

  void addData(String datakey, String data) {
    if (this.addObjectData(datakey, data)) {
      return;
    }
    switch(datakey) {
      case "number":
        this.number = toInt(data);
        break;
      case "toggle":
        this.toggle = toBoolean(data);
        break;
      default:
        println("ERROR: Datakey " + datakey + " not found for feature data.");
        break;
    }
  }


  boolean isFog() {
    switch(this.ID) {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
      case 10:
        return true;
      default:
        return false;
    }
  }
}
