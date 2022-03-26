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
        this.setSize(2, 1, 6);
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
        this.setSize(3, 3, 35);
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
  String selectedObjectTextboxText() {
    String text = "-- " + this.type() + " --";
    return text + "\n\n" + this.description();
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
      case 11:
        path += "khalil.jpg";
        break;
      case 12:
        path += "chuck_quizmo.png";
        break;
      case 21:
        path += "workbench.jpg";
        break;
      case 22:
        path += "ender_chest_closed.png";
        break;
      case 101:
        path += "table.png";
        break;
      case 102:
        path += "desk_up.png";
        break;
      case 103:
        path += "desk_left.png";
        break;
      case 111:
        path += "chair_up.png";
        break;
      case 112:
        path += "chair_down.png";
        break;
      case 113:
        path += "chair_left.png";
        break;
      case 114:
        path += "chair_right.png";
        break;
      case 115:
        path += "chair_green.png";
        break;
      case 121:
        path += "couch_up.png";
        break;
      case 122:
        path += "couch_down.png";
        break;
      case 123:
        path += "couch_left.png";
        break;
      case 124:
        path += "couch_right.png";
        break;
      case 125:
        path += "bench_small_up.png";
        break;
      case 126:
        path += "bench_small_left.png";
        break;
      case 127:
        path += "bench_large_up.png";
        break;
      case 128:
        path += "bench_large_left.png";
        break;
      case 131:
        path += "bed_up.png";
        break;
      case 132:
        path += "bed_down.png";
        break;
      case 133:
        path += "bed_left.png";
        break;
      case 134:
        path += "bed_right.png";
        break;
      case 141:
        path += "wardrobe_up.png";
        break;
      case 142:
        path += "wardrobe_left.png";
        break;
      case 151:
        path += "sign_green_up.png";
        break;
      case 152:
        path += "sign_green_down.png";
        break;
      case 153:
        path += "sign_green_left.png";
        break;
      case 154:
        path += "sign_green_right.png";
        break;
      case 155:
        path += "sign_gray_up.png";
        break;
      case 156:
        path += "sign_gray_down.png";
        break;
      case 157:
        path += "sign_gray_left.png";
        break;
      case 158:
        path += "sign_gray_right.png";
        break;
      case 161:
        path += "water_fountain.png";
        break;
      case 162:
        path += "sink.png";
        break;
      case 163:
        path += "shower_stall.png";
        break;
      case 164:
        path += "urinal.png";
        break;
      case 165:
        path += "toilet.png";
        break;
      case 171:
        path += "stove.png";
        break;
      case 172:
        path += "vending_machine_food.png";
        break;
      case 173:
        path += "vending_machine_drink.png";
        break;
      case 174:
        path += "minifridge.png";
        break;
      case 175:
        path += "fridge.png";
        break;
      case 176:
        path += "washer.png";
        break;
      case 177:
        path += "dryer.png";
        break;
      case 181:
        path += "garbage_can.png";
        break;
      case 182:
        path += "recycle_can.png";
        break;
      case 183:
        path += "crate.png";
        break;
      case 184:
        path += "cardboard_box.png";
        break;
      case 185:
        path += "pickle_jar.png";
        break;
      case 191:
        path += "railing_green_up.png";
        break;
      case 192:
        path += "railing_green_left.png";
        break;
      case 193:
        path += "railing_red_up.png";
        break;
      case 194:
        path += "railing_red_left.png";
        break;
      case 201:
        path += "steel_cross.png";
        break;
      case 202:
        path += "mary_statue.png";
        break;
      case 211:
        path += "fence_gray_up.png";
        break;
      case 212:
        path += "fence_gray_left.png";
        break;
      case 213:
        path += "fence_gray_upleft.png";
        break;
      case 214:
        path += "fence_gray_leftdown.png";
        break;
      case 215:
        path += "fence_gray_downright.png";
        break;
      case 216:
        path += "fence_gray_rightup.png";
        break;
      case 217:
        path += "fence_gray_diagonal_upleft.png";
        break;
      case 218:
        path += "fence_gray_diagonal_upright.png";
        break;
      case 219:
        path += "fence_gray_up_downleft.png";
        break;
      case 220:
        path += "fence_gray_up_downright.png";
        break;
      case 221:
        path += "fence_gray_down_upleft.png";
        break;
      case 222:
        path += "fence_gray_down_upright.png";
        break;
      case 223:
        path += "fence_gray_left_rightup.png";
        break;
      case 224:
        path += "fence_gray_left_rightdown.png";
        break;
      case 225:
        path += "fence_gray_right_leftup.png";
        break;
      case 226:
        path += "fence_gray_right_leftdown.png";
        break;
      case 231:
        path += "fence_green_up.png";
        break;
      case 232:
        path += "fence_green_left.png";
        break;
      case 233:
        path += "fence_green_upleft.png";
        break;
      case 234:
        path += "fence_green_leftdown.png";
        break;
      case 235:
        path += "fence_green_downright.png";
        break;
      case 236:
        path += "fence_green_rightup.png";
        break;
      case 237:
        path += "fence_green_diagonal_upleft.png";
        break;
      case 238:
        path += "fence_green_diagonal_upright.png";
        break;
      case 239:
        path += "fence_green_up_downleft.png";
        break;
      case 240:
        path += "fence_green_up_downright.png";
        break;
      case 241:
        path += "fence_green_down_upleft.png";
        break;
      case 242:
        path += "fence_green_down_upright.png";
        break;
      case 243:
        path += "fence_green_left_rightup.png";
        break;
      case 244:
        path += "fence_green_left_rightdown.png";
        break;
      case 245:
        path += "fence_green_right_leftup.png";
        break;
      case 246:
        path += "fence_green_right_leftdown.png";
        break;
      case 251:
        path += "parking_bumper_up.png";
        break;
      case 252:
        path += "parking_bumper_left.png";
        break;
      case 301:
        path = "terrain/brickWall_blue.jpg";
        break;
      case 302:
        path = "terrain/brickWall_gray.jpg";
        break;
      case 303:
        path = "terrain/brickWall_green.jpg";
        break;
      case 304:
        path = "terrain/brickWall_pink.jpg";
        break;
      case 305:
        path = "terrain/brickWall_red.jpg";
        break;
      case 306:
        path = "terrain/brickWall_yellow.jpg";
        break;
      case 307:
        path = "terrain/brickWall_white.jpg";
        break;
      case 311:
        path += "pillar_gray.png";
        break;
      case 312:
        path += "pillar_red.jpg";
        break;
      case 321:
        path += "window_open.jpg";
        break;
      case 322:
        path += "window_closed.jpg";
        break;
      case 323:
        path += "window_locked.jpg";
        break;
      case 331:
        path += "door_open_up_lefthinges.png";
        break;
      case 332:
        path += "door_open_up_righthinges.png";
        break;
      case 333:
        path += "door_open_left_uphinges.png";
        break;
      case 334:
        path += "door_open_left_downhinges.png";
        break;
      case 335:
        path += "door_open_diagonalleft_uphinges.png";
        break;
      case 336:
        path += "door_open_diagonalleft_downhinges.png";
        break;
      case 337:
        path += "door_open_diagonalright_uphinges.png";
        break;
      case 338:
        path += "door_open_diagonalright_downhinges.png";
        break;
      case 339:
        path += "door_closed_up.png";
        break;
      case 340:
        path += "door_closed_left.png";
        break;
      case 341:
        path += "door_closed_diagonalleft.png";
        break;
      case 342:
        path += "door_closed_diagonalright.png";
        break;
      case 343:
        path += "door_locked_up.png";
        break;
      case 344:
        path += "door_locked_left.png";
        break;
      case 345:
        path += "door_locked_diagonalleft.png";
        break;
      case 346:
        path += "door_locked_diagonalright.png";
        break;
      case 401:
        path += "dandelion.png";
        break;
      case 411:
        path += "gravel_pebbles.jpg";
        break;
      case 412:
        path += "gravel_rocks.jpg";
        break;
      case 421:
        path += "tree_maple.png";
        break;
      case 422:
        path += "tree_unknown.png";
        break;
      case 423:
        path += "tree_cedar.png";
        break;
      case 424:
        path += "tree_dead.png";
        break;
      case 425:
        path += "tree_large.png";
        break;
      case 431:
        path += "rock.png";
        break;
      case 441:
        path += "bush_light.png";
        break;
      case 442:
        path += "bush_dark.png";
        break;
      case 443:
        path += "bush_evergreen.png";
        break;
      case 501:
        path += "car_hondacrv.png";
        break;
      case 502:
        path += "car_fordf150.png";
        break;
      case 503:
        path += "car_vwjetta.png";
        break;
      case 504:
        path += "car_vwbug.png";
        break;
      case 505:
        path += "car_lamborghini.png";
        break;
      case 511:
        path += "helicopter_civilian.png";
        break;
      case 512:
        path += "helicopter_medical.png";
        break;
      case 513:
        path += "helicopter_military.png";
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
