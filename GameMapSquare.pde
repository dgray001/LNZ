class GameMapSquare {
  private int base_elevation = 0;
  private int feature_elevation = 0;
  private int terrain_id = 0;
  private boolean explored = false;
  private boolean visible = false;
  private float light_level = 8; // [0, 10]
  private boolean light_source = false;
  private float original_light = 0;
  private float light_blocked_by_feature = 0;

  GameMapSquare() {
    this.setTerrain(1);
  }
  GameMapSquare(int terrain_id) {
    this.setTerrain(terrain_id);
  }

  void addedFeature(Feature f) {
    this.feature_elevation += f.sizeZ;
    this.light_blocked_by_feature += f.lightPercentageBlocked();
  }

  void removedFeature(Feature f) {
    this.feature_elevation -= f.sizeZ;
    this.light_blocked_by_feature -= f.lightPercentageBlocked();
  }

  void updateLightLevel(GameMap map, int x, int y) {
    if (this.terrain_id == 191) { // lava
      this.light_source = true;
      this.light_level = 9.2;
      return;
    }
    float light = this.light_level;
    if (!this.light_source) {
      light -= Constants.map_lightDecay;
    }
    if (map.outside_map && map.base_light_level > light) {
      light = map.base_light_level;
    }
    try {
      GameMapSquare square = map.squares[x+1][y];
      if (square.light_source || square.passesLight()) {
        float light_right = square.light_level - Constants.map_lightDecay;
        light_right *= 1 - square.light_blocked_by_feature;
        if (light_right > light) {
          light = light_right;
        }
      }
    } catch(ArrayIndexOutOfBoundsException e) {}
    try {
      GameMapSquare square = map.squares[x-1][y];
      if (square.light_source || square.passesLight()) {
        float light_left = square.light_level - Constants.map_lightDecay;
        light_left *= 1 - square.light_blocked_by_feature;
        if (light_left > light) {
          light = light_left;
        }
      }
    } catch(ArrayIndexOutOfBoundsException e) {}
    try {
      GameMapSquare square = map.squares[x][y+1];
      if (square.light_source || square.passesLight()) {
        float light_down = square.light_level - Constants.map_lightDecay;
        light_down *= 1 - square.light_blocked_by_feature;
        if (light_down > light) {
          light = light_down;
        }
      }
    } catch(ArrayIndexOutOfBoundsException e) {}
    try {
      GameMapSquare square = map.squares[x][y-1];
      if (square.light_source || square.passesLight()) {
        float light_up = square.light_level - Constants.map_lightDecay;
        light_up *= 1 - square.light_blocked_by_feature;
        if (light_up > light) {
          light = light_up;
        }
      }
    } catch(ArrayIndexOutOfBoundsException e) {}
    if (light < 0) {
      light = 0;
    }
    this.light_level = light;
  }

  color getColor(color fog_color) {
    float light_factor = 0.1 * this.light_level; // [0, 1]
    if (light_factor > 1) {
      light_factor = 1;
    }
    else if (light_factor < 0) {
      light_factor = 0;
    }
    float r = (fog_color >> 16 & 0xFF) * light_factor;
    float g = (fog_color >> 8 & 0xFF) * light_factor;
    float b = (fog_color & 0xFF) * light_factor;
    float a = alpha(fog_color) + (1 - light_factor) * (255 - alpha(fog_color));
    return ccolor(r, g, b, a);
  }

  void setTerrain(int id) {
    this.terrain_id = id;
    if (id > 300) { // stairs
      this.base_elevation = 3;
    }
    else if (id > 200) { // walls
      this.base_elevation = 100;
    }
    else if (id > 100) { // floors
      this.base_elevation = 0;
    }
    else if (id == 2) { // walkable map edge
      this.base_elevation = 0;
    }
    else if (id == 1) { // map edge
      this.base_elevation = 100;
    }
    else {
      global.errorMessage("ERROR: Terrain ID " + id + " not found.");
    }
  }

  boolean passesLight() {
    switch(this.terrain_id) {
      case 201:
      case 202:
      case 203:
      case 204:
      case 205:
      case 206:
      case 207:
      case 211:
      case 212:
      case 213:
        return false;
      default:
        if (this.light_blocked_by_feature < 1) {
          return true;
        }
        else {
          return false;
        }
    }
  }

  boolean mapEdge() {
    switch(this.terrain_id) {
      case 1:
      case 2:
        return true;
      default:
        return false;
    }
  }

  boolean isWall() {
    if (this.elevation(false) > Constants.map_maxHeight) {
      return true;
    }
    return false;
  }

  int elevation(boolean moving_onto) {
    int net_elevation = this.base_elevation + this.feature_elevation;
    switch(this.terrain_id) {
      case 301:
      case 302:
      case 303:
      case 304:
      case 305:
      case 306:
      case 307:
      case 308:
      case 309:
      case 310:
      case 311:
      case 312:
      case 313:
      case 314:
      case 315:
      case 316:
      case 317:
      case 318:
      case 319:
      case 320:
      case 321:
      case 322:
      case 323:
      case 324:
        if (moving_onto) {
          net_elevation -= 3;
        }
        break;
      default:
        break;
    }
    return net_elevation;
  }

  String terrainName() {
    switch(this.terrain_id) {
      case 101: // floors
      case 102:
      case 103:
      case 104:
        return "Carpet";
      case 111:
      case 112:
      case 113:
        return "Wood Floor";
      case 121:
      case 122:
      case 123:
        return "Tile Floor";
      case 131:
        return "Concrete Floor";
      case 132:
      case 133:
        return "Sidewalk";
      case 134:
        return "Gravel";
      case 141:
      case 142:
      case 143:
      case 144:
      case 145:
        return "Sand";
      case 151:
      case 152:
      case 153:
      case 154:
      case 155:
      case 156:
        return "Grass";
      case 161:
      case 162:
      case 163:
        return "Dirt";
      case 171:
      case 172:
      case 173:
      case 174:
      case 175:
      case 176:
      case 177:
      case 178:
      case 179:
        return "Road";
      case 181:
      case 182:
      case 183:
      case 184:
      case 185:
        return "Water";
      case 191:
        return "Lava";
      case 201:
      case 202:
      case 203:
      case 204:
      case 205:
      case 206:
      case 207:
        return "Brick Wall";
      case 211:
      case 212:
      case 213:
        return "Wooden Wall";
      case 301:
      case 302:
      case 303:
      case 304:
      case 305:
      case 306:
      case 307:
      case 308:
      case 309:
      case 310:
      case 311:
      case 312:
      case 313:
      case 314:
      case 315:
      case 316:
      case 317:
      case 318:
      case 319:
      case 320:
      case 321:
      case 322:
      case 323:
      case 324:
        return "Stairs";
      default:
        return null;
    }
  }

  PImage terrainImage() {
    String imageName = "terrain/";
    switch(this.terrain_id) {
      case 1:
      case 2:
        imageName += "default.jpg";
        break;
      case 101:
        imageName += "carpet_light.jpg";
        break;
      case 102:
        imageName += "carpet_gray.jpg";
        break;
      case 103:
        imageName += "carpet_dark.jpg";
        break;
      case 104:
        imageName += "carpet_green.jpg";
        break;
      case 111:
        imageName += "woodFloor_light.jpg";
        break;
      case 112:
        imageName += "woodFloor_brown.jpg";
        break;
      case 113:
        imageName += "woodFloor_dark.jpg";
        break;
      case 121:
        imageName += "tile_red.jpg";
        break;
      case 122:
        imageName += "tile_green.jpg";
        break;
      case 123:
        imageName += "tile_gray.jpg";
        break;
      case 131:
        imageName += "concrete.jpg";
        break;
      case 132:
        imageName += "sidewalk1.jpg";
        break;
      case 133:
        imageName += "sidewalk2.jpg";
        break;
      case 134:
        imageName += "gravel1.jpg";
        break;
      case 141:
        imageName += "sand1.jpg";
        break;
      case 142:
        imageName += "sand2.jpg";
        break;
      case 143:
        imageName += "sand3.jpg";
        break;
      case 144:
        imageName += "sand3_left.jpg";
        break;
      case 145:
        imageName += "sand3_up.jpg";
        break;
      case 151:
        imageName += "grass1.jpg";
        break;
      case 152:
        imageName += "grass2.jpg";
        break;
      case 153:
        imageName += "grass3.jpg";
        break;
      case 154:
        imageName += "grass4.jpg";
        break;
      case 155:
        imageName += "grass2_line_left.jpg";
        break;
      case 156:
        imageName += "grass2_line_up.jpg";
        break;
      case 161:
        imageName += "dirt1.jpg";
        break;
      case 162:
        imageName += "dirt2.jpg";
        break;
      case 163:
        imageName += "dirt3.jpg";
        break;
      case 171:
        imageName += "road1.jpg";
        break;
      case 172:
        imageName += "road2.jpg";
        break;
      case 173:
        imageName += "road3.jpg";
        break;
      case 174:
        imageName += "road1_left.jpg";
        break;
      case 175:
        imageName += "road1_up.jpg";
        break;
      case 176:
        imageName += "road2_left.jpg";
        break;
      case 177:
        imageName += "road2_up.jpg";
        break;
      case 178:
        imageName += "road2_left_double.jpg";
        break;
      case 179:
        imageName += "road2_up_double.jpg";
        break;
      case 181:
        imageName += "water1.png";
        break;
      case 182:
        imageName += "water2.png";
        break;
      case 183:
        imageName += "water3.jpg";
        break;
      case 184:
        imageName += "water4.jpg";
        break;
      case 185:
        imageName += "water5.png";
        break;
      case 191:
        int lava_frame = int(floor(Constants.gif_lava_frames * (millis() %
          Constants.gif_lava_time) / Constants.gif_lava_time));
        imageName = "gifs/lava/" + lava_frame + ".png";
        break;
      case 201:
        imageName += "brickWall_blue.jpg";
        break;
      case 202:
        imageName += "brickWall_gray.jpg";
        break;
      case 203:
        imageName += "brickWall_green.jpg";
        break;
      case 204:
        imageName += "brickWall_pink.jpg";
        break;
      case 205:
        imageName += "brickWall_red.jpg";
        break;
      case 206:
        imageName += "brickWall_yellow.jpg";
        break;
      case 207:
        imageName += "brickWall_white.jpg";
        break;
      case 211:
        imageName += "woodWall_light.jpg";
        break;
      case 212:
        imageName += "woodWall_brown.jpg";
        break;
      case 213:
        imageName += "woodWall_dark.jpg";
        break;
      case 301:
        imageName += "stairs_gray_up.jpg";
        break;
      case 302:
        imageName += "stairs_gray_down.jpg";
        break;
      case 303:
        imageName += "stairs_gray_left.jpg";
        break;
      case 304:
        imageName += "stairs_gray_right.jpg";
        break;
      case 305:
        imageName += "stairs_green_up.jpg";
        break;
      case 306:
        imageName += "stairs_green_down.jpg";
        break;
      case 307:
        imageName += "stairs_green_left.jpg";
        break;
      case 308:
        imageName += "stairs_green_right.jpg";
        break;
      case 309:
        imageName += "stairs_red_up.jpg";
        break;
      case 310:
        imageName += "stairs_red_down.jpg";
        break;
      case 311:
        imageName += "stairs_red_left.jpg";
        break;
      case 312:
        imageName += "stairs_red_right.jpg";
        break;
      case 313:
        imageName += "stairs_white_up.jpg";
        break;
      case 314:
        imageName += "stairs_white_down.jpg";
        break;
      case 315:
        imageName += "stairs_white_left.jpg";
        break;
      case 316:
        imageName += "stairs_white_right.jpg";
        break;
      case 317:
        imageName += "stairway_green_up.png";
        break;
      case 318:
        imageName += "stairway_green_down.png";
        break;
      case 319:
        imageName += "stairway_green_left.png";
        break;
      case 320:
        imageName += "stairway_green_right.png";
        break;
      case 321:
        imageName += "stairway_red_up.png";
        break;
      case 322:
        imageName += "stairway_red_down.png";
        break;
      case 323:
        imageName += "stairway_red_left.png";
        break;
      case 324:
        imageName += "stairway_red_right.png";
        break;

      default:
        imageName += "default.jpg";
        break;
    }
    return global.images.getImage(imageName);
  }
}
