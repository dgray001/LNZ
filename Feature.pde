class EditFeatureForm extends EditMapObjectForm {
  protected Feature feature;

  EditFeatureForm(Feature feature) {
    super(feature);
    this.feature = feature;
    this.addField(new IntegerFormField("Number: ", "number", Integer.MIN_VALUE + 1, Integer.MAX_VALUE - 1));
    this.addField(new CheckboxFormField("Toggle:  "));
    this.addField(new SubmitFormField("Finished", false));
    this.updateForm();
  }

  void updateObject() {
    this.feature.number = toInt(this.fields.get(1).getValue());
    this.feature.toggle = toBoolean(this.fields.get(2).getValue());
  }

  void updateForm() {
    this.fields.get(1).setValueIfNotFocused(Integer.toString(this.feature.number));
    this.fields.get(2).setValueIfNotFocused(Boolean.toString(this.feature.toggle));
  }
}




class Feature extends MapObject {
  protected int sizeX = 0;
  protected int sizeY = 0;
  protected int sizeZ = 0;

  protected int number = 0;
  protected boolean toggle = false;
  protected Inventory inventory = null;

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
        this.inventory = global.profile.ender_chest;
        break;

      // Furniture
      case 101:
        this.setStrings("Wooden Table", "Furniture", "");
        this.setSize(2, 2, 3);
        this.number = Constants.feature_woodenTableHealth;
        break;
      case 102:
        this.setStrings("Wooden Desk", "Furniture", "");
        this.setSize(2, 1, 4);
        this.inventory = new DeskInventory();
        this.number = Constants.feature_woodenDeskHealth;
        break;
      case 103:
        this.setStrings("Wooden Desk", "Furniture", "");
        this.setSize(1, 2, 4);
        this.inventory = new DeskInventory();
        this.number = Constants.feature_woodenDeskHealth;
        break;
      case 111:
      case 112:
      case 113:
      case 114:
        this.setStrings("Wooden Chair", "Furniture", "");
        this.setSize(1, 1, 2);
        this.number = Constants.feature_woodenChairHealth;
        break;
      case 115:
        this.setStrings("Coordinator Chair", "Furniture", "");
        this.setSize(1, 1, 2);
        this.toggle = true;
        this.number = Constants.feature_couchHealth;
        break;
      case 121:
      case 122:
        this.setStrings("Couch", "Furniture", "");
        this.setSize(3, 1, 2);
        this.toggle = true;
        this.number = Constants.feature_couchHealth;
        break;
      case 123:
      case 124:
        this.setStrings("Couch", "Furniture", "");
        this.setSize(1, 3, 2);
        this.toggle = true;
        this.number = Constants.feature_couchHealth;
        break;
      case 125:
        this.setStrings("Bench", "Furniture", "");
        this.setSize(2, 1, 2);
        this.number = Constants.feature_woodenBenchSmallHealth;
        break;
      case 126:
        this.setStrings("Bench", "Furniture", "");
        this.setSize(1, 2, 2);
        this.number = Constants.feature_woodenBenchSmallHealth;
        break;
      case 127:
        this.setStrings("Bench", "Furniture", "");
        this.setSize(2, 3, 3);
        this.number = Constants.feature_woodenBenchLargeHealth;
        break;
      case 128:
        this.setStrings("Bench", "Furniture", "");
        this.setSize(3, 2, 3);
        this.number = Constants.feature_woodenBenchLargeHealth;
        break;
      case 129:
        this.setStrings("Bench", "Furniture", "");
        this.setSize(2, 1, 2);
        this.number = Constants.feature_woodenBenchSmallHealth;
        break;
      case 130:
        this.setStrings("Bench", "Furniture", "");
        this.setSize(1, 2, 2);
        this.number = Constants.feature_woodenBenchSmallHealth;
        break;
      case 131:
      case 132:
        this.setStrings("Bed", "Furniture", "");
        this.setSize(2, 3, 3);
        this.toggle = true;
        this.number = Constants.feature_bedHealth;
        break;
      case 133:
      case 134:
        this.setStrings("Bed", "Furniture", "");
        this.setSize(3, 2, 3);
        this.toggle = true;
        this.number = Constants.feature_woodenTableHealth;
        break;
      case 141:
        this.setStrings("Wardrobe", "Furniture", "");
        this.setSize(2, 1, 9);
        this.toggle = true;
        this.number = Constants.feature_wardrobeHealth;
        break;
      case 142:
        this.setStrings("Wardrobe", "Furniture", "");
        this.setSize(1, 2, 9);
        this.toggle = true;
        this.number = Constants.feature_wardrobeHealth;
        break;
      case 151:
      case 152:
      case 153:
      case 154:
      case 155:
      case 156:
      case 157:
      case 158:
        this.setStrings("Sign", "Sign", Constants.feature_signDescriptionDelimiter);
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
        this.inventory = new StoveInventory();
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
        this.inventory = new MinifridgeInventory();
        break;
      case 175:
        this.setStrings("Refridgerator", "Appliance", "");
        this.setSize(1, 1, 7);
        this.inventory = new RefridgeratorInventory();
        break;
      case 176:
        this.setStrings("Washer", "Appliance", "");
        this.setSize(1, 1, 4);
        this.inventory = new WasherInventory();
        break;
      case 177:
        this.setStrings("Dryer", "Appliance", "");
        this.setSize(1, 1, 4);
        this.inventory = new DryerInventory();
        break;
      case 181:
        this.setStrings("Garbage Can", "Furniture", "");
        this.setSize(1, 1, 4);
        this.inventory = new GarbageInventory();
        break;
      case 182:
        this.setStrings("Recycle Can", "Furniture", "");
        this.setSize(1, 1, 4);
        this.inventory = new RecycleInventory();
        break;
      case 183:
        this.setStrings("Crate", "Furniture", "");
        this.setSize(1, 1, 2);
        this.inventory = new CrateInventory();
        break;
      case 184:
        this.setStrings("Cardboard Box", "Furniture", "");
        this.setSize(1, 1, 2);
        this.inventory = new CardboardBoxInventory();
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
        this.number = int(ceil(random(Constants.feature_gravelMaxNumberRocks)));
        break;
      case 421:
      case 422:
      case 423:
      case 424:
        this.setStrings("Tree", "Nature", "");
        this.setSize(2, 2, 20);
        this.toggle = true;
        this.number = Constants.feature_treeHealth;
        break;
      case 425:
        this.setStrings("Tree", "Nature", "");
        this.setSize(3, 3, 35);
        this.toggle = true;
        this.number = Constants.feature_treeBigHealth;
        break;
      case 426:
        this.setStrings("Tree", "Nature", "");
        this.setSize(2, 2, 20);
        this.toggle = true;
        this.number = Constants.feature_treeHealth;
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
        this.number = Constants.feature_bushHealth;
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
        global.errorMessage("ERROR: Feature ID " + ID + " not found.");
        break;
    }
  }
  Feature(int ID, float x, float y) {
    this(ID);
    this.x = x;
    this.y = y;
  }
  Feature(int ID, float x, float y, boolean toggle) {
    this(ID);
    this.x = x;
    this.y = y;
    this.toggle = toggle;
  }

  String display_name() {
    return this.display_name;
  }
  String type() {
    return this.type;
  }
  String description() {
    switch(this.ID) {
      case 151: // sign
      case 152:
      case 153:
      case 154:
      case 155:
      case 156:
      case 157:
      case 158:
        return trim(split(this.description, Constants.feature_signDescriptionDelimiter)[0]);
      default:
        return this.description;
    }
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
      case 129:
        path += "bench_small_down.png";
        break;
      case 130:
        path += "bench_small_right.png";
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
      case 426:
        path += "tree_pine.png";
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
        global.errorMessage("ERROR: Feature ID " + ID + " not found.");
        path += "default.png";
        break;
    }
    return global.images.getImage(path);
  }


  boolean targetable(Unit u) {
    if (this.targetableByUnit()) {
      return true;
    }
    else if (this.targetableByHeroOnly() && Hero.class.isInstance(u)) {
      return true;
    }
    return false;
  }

  boolean targetableByUnit() {
    switch(this.ID) {
      case 101: // wooden table
      case 102: // desk
      case 103:
      case 111: // wooden chair
      case 112:
      case 113:
      case 114:
      case 115: // coordinator chair
      case 121: // couch
      case 122:
      case 123:
      case 124:
      case 125: // wooden bench
      case 126:
      case 127:
      case 128:
      case 129:
      case 130:
      case 131: // bed
      case 132:
      case 133:
      case 134:
      case 141: // wardrobe
      case 142:
      case 161: // water fountain
      case 162: // sink
      case 163: // shower stall
      case 164: // urinal
      case 165: // toilet
      case 185: // pickle jar
      case 211: // wire fence
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
      case 231: // barbed wire fence
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
      case 321: // window (open)
      case 322: // window (closed)
      case 323: // window (locked)
      case 331: // wooden door (open)
      case 332:
      case 333:
      case 334:
      case 335:
      case 336:
      case 337:
      case 338:
      case 339: // wooden door (closed)
      case 340:
      case 341:
      case 342:
      case 343: // wooden door (locked)
      case 344:
      case 345:
      case 346:
      case 401: // dandelion
      case 411: // gravel
      case 412:
      case 421: // tree
      case 422:
      case 423:
      case 424:
      case 425:
      case 426:
      case 441: // bush
      case 442:
      case 443:
        return true;
      default:
        return false;
    }
  }

  boolean targetableByHeroOnly() {
    switch(this.ID) {
      case 11: // khalil
      case 12: // chuck quizmo
      case 22: // ender chest
      case 151: // sign
      case 152:
      case 153:
      case 154:
      case 155:
      case 156:
      case 157:
      case 158:
      case 171: // stove
      case 172: // vending machine
      case 173:
      case 174: // minifridge
      case 175: // refridgerator
      case 176: // washer
      case 177: // dryer
      case 181: // garbage can
      case 182: // recycle can
      case 183: // crate
      case 184: // cardboard box
      case 301: // movable brick wall
      case 302:
      case 303:
      case 304:
      case 305:
      case 306:
      case 307:
        return true;
      default:
        return false;
    }
  }


  float interactionDistance() {
    switch(this.ID) {
      default:
        return Constants.feature_defaultInteractionDistance;
    }
  }


  boolean onInteractionCooldown() {
    switch(this.ID) {
      case 151: // sign
      case 152:
      case 153:
      case 154:
      case 155:
      case 156:
      case 157:
      case 158:
      case 163: // shower stall
      case 164: // urinal
      case 165: // toilet
      case 185: // pickle jar
        if (this.number > 0) {
          return true;
        }
        break;
      default:
        return false;
    }
    return false;
  }


  float interactionTime() {
    switch(this.ID) {
      case 101: // wooden table
      case 111: // wooden chair
      case 112:
      case 113:
      case 114:
      case 115: // coordinator chair
      case 121: // couch
      case 122:
      case 123:
      case 124:
      case 131: // bed
      case 132:
      case 133:
      case 134:
      case 141: // wardrobe
      case 142:
        return Constants.feature_furnitureInteractionTime;
      case 211: // wire fence
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
      case 231: // barbed wire fence
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
        return Constants.feature_wireFenceInteractionTime;
      case 301: // movable brick wall
      case 302:
      case 303:
      case 304:
      case 305:
      case 306:
      case 307:
        return Constants.feature_movableBrickWallInteractionTime;
      case 411: // gravel
      case 412:
        return Constants.feature_gravelInteractionTime;
      case 421: // tree
      case 422:
      case 423:
      case 424:
      case 425:
      case 426:
        return Constants.feature_treeInteractionTime;
      case 441: // bush
      case 442:
      case 443:
        return Constants.feature_bushInteractionTime;
      default:
        return 0;
    }
  }


  ArrayList<Integer> drops() {
    ArrayList<Integer> id_list = new ArrayList<Integer>();
    switch(this.ID) {
      case 101: // wooden table
      case 102: // desk
      case 103:
      case 111: // wooden chair
      case 112:
      case 113:
      case 114:
      case 125: // wooden bench
      case 126:
      case 127:
      case 128:
      case 129:
      case 130:
      case 115: // coordinator chair
      case 121: // couch
      case 122:
      case 123:
      case 124:
      case 131: // bed
      case 132:
      case 133:
      case 134:
      case 141: // wardrobe
      case 142:
        // wooden board, maybe nails / screws / wooden "piece" (small piece)
        break;
      case 185: // pickle jar
        id_list.add(2805);
        break;
      case 211: // wire fence
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
        id_list.add(2806);
        break;
      case 321: // window
      case 322:
      case 323:
        id_list.add(2805);
        id_list.add(2805);
        break;
      case 331: // wooden door
      case 332:
      case 333:
      case 334:
      case 335:
      case 336:
      case 337:
      case 338:
      case 339:
      case 340:
      case 341:
      case 342:
      case 343:
      case 344:
      case 345:
      case 346:
        // wooden board, maybe nails / screws / wooden "piece" (small piece)
        break;
      case 421: // tree
      case 422:
      case 423:
      case 424:
      case 425:
      case 426:
        // wooden logs
        break;
      default:
        break;
    }
    return id_list;
  }


  void destroy(GameMap map) {
    this.remove = true;
    for (int id : this.drops()) {
      map.addItem(new Item(id, this.x + 0.2 + random(0.6 + this.sizeX - 1),
        this.y + 0.2 + random(0.6 + this.sizeY - 1)));
    }
    if (this.inventory != null) {
      for (Item i : this.inventory.items()) {
        map.addItem(new Item(i, this.x + 0.2 + random(0.6 + this.sizeX - 1),
          this.y + 0.2 + random(0.6 + this.sizeY - 1)));
      }
    }
    // visual effects
    switch(this.ID) {
      case 12: // chuck quizmo
        map.addVisualEffect(4002, this.xCenter(), this.yCenter());
        break;
    }
  }


  void interact(Unit u, GameMap map) {
    this.interact(u, map, false);
  }
  void interact(Unit u, GameMap map, boolean use_item) {
    if (Hero.class.isInstance(u)) {
      if (use_item) {
        u.curr_action = UnitAction.HERO_INTERACTING_WITH_FEATURE_WITH_ITEM;
      }
      else {
        u.curr_action = UnitAction.HERO_INTERACTING_WITH_FEATURE;
      }
      return;
    }
    if (u.weapon() == null) {
      use_item = false;
    }
    Item new_i;
    // Non-hero interaction with feature
    switch(this.ID) {
      case 101: // wooden table
      case 102: // wooden desk
      case 103:
      case 111: // wooden chair
      case 112:
      case 113:
      case 114:
      case 115: // coordinator chair
      case 121: // couch
      case 122:
      case 123:
      case 124:
      case 125: // wooden bench
      case 126:
      case 127:
      case 128:
      case 129:
      case 130:
      case 131: // Bed
      case 132:
      case 141: // Wardrobe
      case 142:
        if (!u.holding(2977, 2979, 2980, 2981, 2983)) {
          break;
        }
        switch(u.weapon().ID) {
          case 2977: // Ax
            this.number -= 3;
            global.sounds.trigger_units("items/melee/ax",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 2979: // Saw
            this.number -= 1;
            global.sounds.trigger_units("items/saw_cut_wood",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 2980: // Drill
            this.number -= 1;
            global.sounds.trigger_units("items/melee/drill" + randomInt(1, 3),
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 2981: // Roundsaw
            this.number -= 2;
            global.sounds.trigger_units("items/roundsaw_cut_wood",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 2983: // Chainsaw
            this.number -= 2;
            global.sounds.trigger_units("items/chainsaw_long",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
        }
        if (this.number < 1) {
          this.destroy(map);
        }
        break;
      case 161: // Water Fountain
        global.sounds.trigger_environment("features/water_fountain",
          this.xCenter() - map.viewX, this.yCenter() - map.viewY);
        break;
      case 162: // Sink
        global.sounds.trigger_environment("features/sink",
          this.xCenter() - map.viewX, this.yCenter() - map.viewY);
        break;
      case 163: // Shower Stall
        this.number = Constants.feature_showerStallCooldown;
        global.sounds.trigger_environment("features/shower_stall",
          this.xCenter() - map.viewX, this.yCenter() - map.viewY);
        break;
      case 164: // urinal
        this.number = Constants.feature_urinalCooldown;
        global.sounds.trigger_environment("features/urinal",
          this.xCenter() - map.viewX, this.yCenter() - map.viewY);
        break;
      case 165: // toilet
        this.number = Constants.feature_toiletCooldown;
        global.sounds.trigger_environment("features/toilet",
          this.xCenter() - map.viewX, this.yCenter() - map.viewY);
        break;
      case 185: // pickle jar
        if (use_item && u.holding(2975)) {
          this.destroy(map);
          global.sounds.trigger_environment("items/glass_bottle_hit",
            this.xCenter() - map.viewX, this.yCenter() - map.viewY);
          break;
        }
        if (u.canPickup()) {
          this.number = Constants.feature_pickleJarCooldown;
          new_i = new Item(2106);
          u.pickup(new_i);
          new_i.pickupSound();
        }
        break;
      case 211: // wire fence
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
        if (use_item && u.holding(2978)) {
          this.destroy(map);
          global.sounds.trigger_environment("items/wire_clipper",
            this.xCenter() - map.viewX, this.yCenter() - map.viewY);
          break;
        }
        else if (u.agility() >= 2) {
          u.setLocation(this.xCenter(), this.yCenter());
          global.sounds.trigger_units("features/climb_fence",
            this.xCenter() - map.viewX, this.yCenter() - map.viewY);
          if (randomChance(0.3)) {
            u.addStatusEffect(StatusEffectCode.BLEEDING, 2000);
          }
        }
        break;
      case 231: // barbed wire fence
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
        if (u.agility() >= 3) {
          u.setLocation(this.xCenter(), this.yCenter());
          global.sounds.trigger_units("features/climb_fence",
            this.xCenter() - map.viewX, this.yCenter() - map.viewY);
          if (randomChance(0.8)) {
            u.addStatusEffect(StatusEffectCode.BLEEDING, 2500);
          }
        }
        break;
      case 321: // window (open)
        if (use_item && u.holding(2976)) {
          this.destroy(map);
          global.sounds.trigger_environment("items/window_break",
            this.xCenter() - map.viewX, this.yCenter() - map.viewY);
          break;
        }
        this.remove = true;
        map.addFeature(new Feature(322, this.x, this.y));
        global.sounds.trigger_environment("features/window_close",
          this.xCenter() - map.viewX, this.yCenter() - map.viewY);
        break;
      case 322: // window (closed)
        if (use_item && u.holding(2976)) {
          this.destroy(map);
          global.sounds.trigger_environment("items/window_break",
            this.xCenter() - map.viewX, this.yCenter() - map.viewY);
          break;
        }
        this.remove = true;
        map.addFeature(new Feature(321, this.x, this.y));
        global.sounds.trigger_environment("features/window_open",
          this.xCenter() - map.viewX, this.yCenter() - map.viewY);
        break;
      case 323: // window (locked)
        if (!u.holding(2976)) {
          break;
        }
        this.destroy(map);
        global.sounds.trigger_environment("items/window_break",
            this.xCenter() - map.viewX, this.yCenter() - map.viewY);
        break;
      case 331: // wooden door (open)
      case 332:
      case 333:
      case 334:
      case 335:
      case 336:
      case 337:
      case 338:
      case 339: // wooden door (closed)
      case 340:
      case 341:
      case 342:
      case 343: // wooden door (locked)
      case 344:
      case 345:
      case 346:
        if (use_item && u.holding(2977, 2979, 2983)) {
          this.destroy(map);
          break;
        }
        switch(this.ID) {
          case 331: // door open (up)
            this.remove = true;
            map.addFeature(new Feature(339, this.x, this.y, false));
            global.sounds.trigger_environment("features/wooden_door_close",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 332:
            this.remove = true;
            map.addFeature(new Feature(339, this.x, this.y, true));
            global.sounds.trigger_environment("features/wooden_door_close",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 333: // door open (left)
            this.remove = true;
            map.addFeature(new Feature(340, this.x, this.y, false));
            global.sounds.trigger_environment("features/wooden_door_close",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 334:
            this.remove = true;
            map.addFeature(new Feature(340, this.x, this.y, true));
            global.sounds.trigger_environment("features/wooden_door_close",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 335: // door open (diagonal left)
            this.remove = true;
            map.addFeature(new Feature(341, this.x, this.y, false));
            global.sounds.trigger_environment("features/wooden_door_close",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 336:
            this.remove = true;
            map.addFeature(new Feature(341, this.x, this.y, true));
            global.sounds.trigger_environment("features/wooden_door_close",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 337: // door open (diagonal right)
            this.remove = true;
            map.addFeature(new Feature(342, this.x, this.y, false));
            global.sounds.trigger_environment("features/wooden_door_close",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 338:
            this.remove = true;
            map.addFeature(new Feature(342, this.x, this.y, true));
            global.sounds.trigger_environment("features/wooden_door_close",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 339: // door closed (up)
            this.remove = true;
            if (this.toggle) {
              map.addFeature(new Feature(332, this.x, this.y));
            }
            else {
              map.addFeature(new Feature(331, this.x, this.y));
            }
            global.sounds.trigger_environment("features/wooden_door_open",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 340: // door closed (left)
            this.remove = true;
            if (this.toggle) {
              map.addFeature(new Feature(334, this.x, this.y));
            }
            else {
              map.addFeature(new Feature(333, this.x, this.y));
            }
            global.sounds.trigger_environment("features/wooden_door_open",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 341: // door closed (diagonal left)
            this.remove = true;
            if (this.toggle) {
              map.addFeature(new Feature(336, this.x, this.y));
            }
            else {
              map.addFeature(new Feature(335, this.x, this.y));
            }
            global.sounds.trigger_environment("features/wooden_door_open",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 342: // door closed (diagonal right)
            this.remove = true;
            if (this.toggle) {
              map.addFeature(new Feature(338, this.x, this.y));
            }
            else {
              map.addFeature(new Feature(337, this.x, this.y));
            }
            global.sounds.trigger_environment("features/wooden_door_open",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 343: // door locked (up)
            if (u.weapon() == null || !u.weapon().unlocks(this.number)) {
              break;
            }
            this.remove = true;
            map.addFeature(new Feature(339, this.x, this.y, this.toggle));
            global.sounds.trigger_environment("features/wooden_door_unlock",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 344: // door locked (left)
            if (u.weapon() == null || !u.weapon().unlocks(this.number)) {
              break;
            }
            this.remove = true;
            map.addFeature(new Feature(340, this.x, this.y, this.toggle));
            global.sounds.trigger_environment("features/wooden_door_unlock",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 345: // door locked (diagonal left)
            if (u.weapon() == null || !u.weapon().unlocks(this.number)) {
              break;
            }
            this.remove = true;
            map.addFeature(new Feature(341, this.x, this.y, this.toggle));
            global.sounds.trigger_environment("features/wooden_door_unlock",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
          case 346: // door locked (diagonal right)
            if (u.weapon() == null || !u.weapon().unlocks(this.number)) {
              break;
            }
            this.remove = true;
            map.addFeature(new Feature(342, this.x, this.y, this.toggle));
            global.sounds.trigger_environment("features/wooden_door_unlock",
              this.xCenter() - map.viewX, this.yCenter() - map.viewY);
            break;
        }
        break;
      case 401: // dandelion
        if (u.canPickup()) {
          this.remove = true;
          new_i = new Item(2961);
          u.pickup(new_i);
          new_i.pickupSound();
        }
        break;
      case 411: // gravel (pebbles)
        if (u.canPickup()) {
          new_i = new Item(2933);
          u.pickup(new_i);
          new_i.pickupSound();
          this.number--;
          if (this.number < 1) {
            this.remove = true;
            map.setTerrain(134, int(floor(this.x)), int(floor(this.y)));
          }
        }
        break;
      case 412: // gravel (rocks)
        if (u.canPickup()) {
          new_i = new Item(2931);
          u.pickup(new_i);
          new_i.pickupSound();
          this.number--;
          if (this.number < 1) {
            this.remove = true;
            map.addFeature(new Feature(411, this.x, this.y));
          }
        }
        break;
      case 421: // Tree (maple)
      case 422: // Tree (unknown)
      case 423: // Tree (cedar)
      case 424: // Tree (dead)
      case 425: // Tree (large)
      case 426: // Tree (pine)
        int branch_id = 0;
        switch(this.ID) {
          case 421:
            branch_id = 2965;
            break;
          case 422:
            branch_id = 2966;
            break;
          case 423:
            branch_id = 2967;
            break;
          case 424:
            branch_id = 2963;
            break;
          case 425:
            branch_id = 2965;
            break;
          case 426:
            branch_id = 2968;
            break;
        }
        if (!use_item || !u.holding(2977, 2979, 2981, 2983)) {
          if (this.toggle) {
            map.addItem(new Item(branch_id, u.frontX(), u.frontY()));
            if (randomChance(Constants.feature_treeChanceEndBranches)) {
              this.toggle = false;
            }
          }
        }
        else {
          switch(u.weapon().ID) {
            case 2977: // Ax
              this.number -= 2;
              global.sounds.trigger_units("items/melee/ax",
                this.xCenter() - map.viewX, this.yCenter() - map.viewY);
              break;
            case 2979: // Saw
              this.number -= 1;
              global.sounds.trigger_units("items/saw_cut_wood",
                this.xCenter() - map.viewX, this.yCenter() - map.viewY);
              break;
            case 2981: // Roundsaw
              this.number -= 2;
              global.sounds.trigger_units("items/roundsaw_cut_wood",
                this.xCenter() - map.viewX, this.yCenter() - map.viewY);
              break;
            case 2983: // Chainsaw
              this.number -= 4;
              global.sounds.trigger_units("items/chainsaw_long",
                this.xCenter() - map.viewX, this.yCenter() - map.viewY);
              break;
          }
          if (randomChance(Constants.feature_treeDropChance)) {
            map.addItem(new Item(branch_id, u.frontX(), u.frontY()));
          }
          if (this.number < 1) {
            this.destroy(map);
          }
        }
        break;
      case 441: // Bush
      case 442:
      case 443:
        if (u.holding(2204, 2211)) {
          this.number--;
          if (randomChance(Constants.feature_bushDropChance)) {
            map.addItem(new Item(2964, this.x + 0.2 + random(0.6), this.y + 0.2 + random(0.6)));
          }
          if (this.number < 1) {
            this.remove = true;
          }
          global.sounds.trigger_units("features/sword_bush",
            this.xCenter() - map.viewX, this.yCenter() - map.viewY);
        }
        break;
      default:
        global.errorMessage("ERROR: Unit " + u.display_name() + " trying to " +
          "interact with feature " + this.display_name() + " but no interaction logic found.");
        break;
    }
  }


  void update(int timeElapsed) {
    switch(this.ID) {
      case 163: // shower stall
      case 164: // urinal
      case 165: // toilet
      case 185: // pickle jar
        if (this.number < 0) {
          break;
        }
        this.number -= timeElapsed;
        break;
      default:
        break;
    }
  }


  void createKhalilInventory() {
    if (this.ID != 11 || this.inventory != null) {
      return;
    }
    this.inventory = getKhalilInventory(this.number);
  }


  String fileString() {
    String fileString = "\nnew: Feature: " + this.ID;
    fileString += this.objectFileString();
    fileString += "\nnumber: " + this.number;
    fileString += "\ntoggle: " + this.toggle;
    if (this.inventory != null && this.ID != 22) {
      fileString += this.inventory.internalFileString();
    }
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
        global.errorMessage("ERROR: Datakey " + datakey + " not found for feature data.");
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
