enum AreaLocation {
  NONE, FERNWOOD_FOREST;

  public Biome getBiome(float noise_value) {
    return AreaLocation.getBiome(this, noise_value);
  }
  private static Biome getBiome(AreaLocation location, float noise_value) {
    switch(location) {
      case FERNWOOD_FOREST:
        return AreaLocation.fernwoodForestBiome(noise_value);
    }
    return Biome.NONE;
  }

  private static Biome fernwoodForestBiome(float noise_value) {
    if (noise_value > 0.7) {
      return Biome.MAPLE_FOREST3;
    }
    else if (noise_value > 0.45) {
      return Biome.MAPLE_FOREST2;
    }
    else if (noise_value > 0.33) {
      return Biome.MAPLE_FOREST1;
    }
    else {
      return Biome.CLEARING;
    }
  }
}


static class BiomeReturn {
  int terrain_code = 0;
  boolean spawn_feature = false;
  int feature_id = 0;

  BiomeReturn() {}
}


enum Biome {
  NONE, MAPLE_FOREST1, MAPLE_FOREST2, MAPLE_FOREST3, CLEARING, GRASS;

  private static final List<Biome> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  public String displayName() {
    return Biome.displayName(this);
  }
  public static String displayName(Biome biome) {
    switch(biome) {
      case MAPLE_FOREST1:
        return "Maple Forest, open";
      case MAPLE_FOREST2:
        return "Maple Forest";
      case MAPLE_FOREST3:
        return "Maple Forest, dense";
      case CLEARING:
        return "Clearing";
      case GRASS:
        return "GRASS";
      default:
        return "Error";
    }
  }

  public String fileName() {
    return Biome.fileName(this);
  }
  public static String fileName(Biome biome) {
    switch(biome) {
      case MAPLE_FOREST1:
        return "MAPLE_FOREST1";
      case MAPLE_FOREST2:
        return "MAPLE_FOREST2";
      case MAPLE_FOREST3:
        return "MAPLE_FOREST3";
      case CLEARING:
        return "CLEARING";
      case GRASS:
        return "GRASS";
      default:
        return "";
    }
  }

  public static Biome biome(String biome_name) {
    for (Biome biome : Biome.VALUES) {
      if (biome == Biome.NONE) {
        continue;
      }
      if (Biome.displayName(biome).equals(biome_name) ||
        Biome.fileName(biome).equals(biome_name)) {
        return biome;
      }
    }
    return Biome.NONE;
  }
}


BiomeReturn processPerlinNoise(Biome biome, float noise_value) {
  switch(biome) {
    case MAPLE_FOREST1:
      return mapleForestProcessPerlinNoise(1, noise_value);
    case MAPLE_FOREST2:
      return mapleForestProcessPerlinNoise(2, noise_value);
    case MAPLE_FOREST3:
      return mapleForestProcessPerlinNoise(3, noise_value);
    case CLEARING:
      return clearingProcessPerlinNoise(noise_value);
    case GRASS:
      return grassProcessPerlinNoise(noise_value);
  }
  return new BiomeReturn();
}

private BiomeReturn mapleForestProcessPerlinNoise(int forest_density, float noise_value) {
  BiomeReturn biome_return = new BiomeReturn();
  switch(forest_density) {
    case 1: // low density forest
      if (noise_value > 0.85) { // dark dirt
        if (randomChance(noise_value)) {
          biome_return.terrain_code = 163; // dark dirt
        }
        else {
          biome_return.terrain_code = 162; // gray dirt
        }
      }
      else if (noise_value > 0.55) { // dirty
        if (randomChance(noise_value)) {
          biome_return.terrain_code = 162; // gray dirt
        }
        else if (randomChance(noise_value)) {
          biome_return.terrain_code = 161; // light dirt
        }
        else {
          biome_return.terrain_code = 154; // dead grass
        }
      }
      else { // grassy
        if (randomChance(map(noise_value, 0.25, 0.45, 0.1, 0.9))) {
          biome_return.terrain_code = 154; // dead grass
        }
        else if (randomChance(1 - noise_value)) {
          biome_return.terrain_code = 153; // dark grass
        }
        else {
          biome_return.terrain_code = 161; // light dirt
        }
      }
      break;
    case 2: // medium density forest
      if (noise_value > 0.78) { // dark dirt
        if (randomChance(noise_value)) {
          biome_return.terrain_code = 163; // dark dirt
        }
        else {
          biome_return.terrain_code = 162; // gray dirt
        }
      }
      else if (noise_value > 0.45) { // dirty
        if (randomChance(noise_value)) {
          biome_return.terrain_code = 162; // gray dirt
        }
        else if (randomChance(noise_value)) {
          biome_return.terrain_code = 161; // light dirt
        }
        else {
          biome_return.terrain_code = 154; // dead grass
        }
      }
      else { // grassy
        if (randomChance(map(noise_value, 0.25, 0.45, 0.1, 0.9))) {
          biome_return.terrain_code = 154; // dead grass
        }
        else if (randomChance(1 - noise_value)) {
          biome_return.terrain_code = 153; // dark grass
        }
        else {
          biome_return.terrain_code = 161; // light dirt
        }
      }
      break;
    case 3: // high density forest
      if (noise_value > 0.66) { // dark dirt
        if (randomChance(noise_value)) {
          biome_return.terrain_code = 163; // dark dirt
        }
        else {
          biome_return.terrain_code = 162; // gray dirt
        }
      }
      else if (noise_value > 0.35) { // dirty
        if (randomChance(noise_value)) {
          biome_return.terrain_code = 162; // gray dirt
        }
        else if (randomChance(noise_value)) {
          biome_return.terrain_code = 161; // light dirt
        }
        else {
          biome_return.terrain_code = 154; // dead grass
        }
      }
      else { // grassy
        if (randomChance(map(noise_value, 0.25, 0.45, 0.1, 0.9))) {
          biome_return.terrain_code = 154; // dead grass
        }
        else if (randomChance(1 - noise_value)) {
          biome_return.terrain_code = 153; // dark grass
        }
        else {
          biome_return.terrain_code = 161; // light dirt
        }
      }
      break;
  }
  float feature_spawn_chance = 0;
  switch(biome_return.terrain_code) {
    case 153: // Grass, dark
      feature_spawn_chance = 0.04;
      break;
    case 154: // Grass, dead
      feature_spawn_chance = 0.08;
      break;
    case 161: // Dirt, light
      feature_spawn_chance = 0.12;
      break;
    case 162: // Dirt, gray
      feature_spawn_chance = 0.16;
      break;
    case 163: // Dirt, dark
      feature_spawn_chance = 0.2;
      break;
  }
  if (randomChance(feature_spawn_chance)) {
    biome_return.spawn_feature = true;
    float random_num = random(1.0);
    // random tree / bush (favoring maple trees, light bushes)
    if (random_num > 0.8) {
      biome_return.feature_id = 441;
    }
    else if (random_num > 0.75) {
      biome_return.feature_id = 442;
    }
    else if (random_num > 0.5) {
      biome_return.feature_id = 421;
    }
    else if (random_num > 0.2) {
      biome_return.feature_id = 444;
    }
    else if (random_num > 0.13) {
      biome_return.feature_id = 447;
    }
    else if (random_num > 0.1) {
      biome_return.feature_id = 424;
    }
    else if (random_num > 0.08) {
      biome_return.feature_id = 422;
    }
    else if (random_num > 0.06) {
      biome_return.feature_id = 423;
    }
    else if (random_num > 0.03) {
      biome_return.feature_id = 445;
    }
    else {
      biome_return.feature_id = 446;
    }
  }
  return biome_return;
}


private BiomeReturn clearingProcessPerlinNoise(float noise_value) {
  BiomeReturn biome_return = new BiomeReturn();
  if (noise_value > 0.8) { // dirty
    if (randomChance(1 - noise_value)) {
      biome_return.terrain_code = 162; // gray dirt
    }
    else {
      biome_return.terrain_code = 161; // light dirt
    }
  }
  else if (noise_value > 0.5) { // dirt to grass
    if (randomChance(noise_value - 0.5)) {
      biome_return.terrain_code = 161; // light dirt
    }
    else if (randomChance(noise_value - 0.35)) {
      biome_return.terrain_code = 153; // dark grass
      if (randomChance(0.25)) {
        biome_return.terrain_code = 154; // dead grass
      }
    }
    else {
      biome_return.terrain_code = 151; // light grass
      if (randomChance(0.25)) {
        biome_return.terrain_code = 154; // dead grass
      }
    }
  }
  else { // grassy
    if (randomChance(noise_value - 0.35)) {
      biome_return.terrain_code = 153; // dark grass
      if (randomChance(0.25)) {
        biome_return.terrain_code = 154; // dead grass
      }
    }
    else if (randomChance(noise_value - 0.15)) {
      biome_return.terrain_code = 151; // light grass
      if (randomChance(0.25)) {
        biome_return.terrain_code = 154; // dead grass
      }
    }
    else {
      biome_return.terrain_code = 152; // green grass
      if (randomChance(0.25)) {
        biome_return.terrain_code = 154; // dead grass
      }
    }
  }
  float tree_bush_spawn_chance = 0;
  switch(biome_return.terrain_code) {
    case 153: // Grass, dark
      tree_bush_spawn_chance = 0.02;
      break;
    case 154: // Grass, dead
      tree_bush_spawn_chance = 0.04;
      break;
    case 161: // Dirt, light
      tree_bush_spawn_chance = 0.06;
      break;
    case 162: // Dirt, gray
      tree_bush_spawn_chance = 0.08;
      break;
  }
  if (randomChance(tree_bush_spawn_chance)) {
    biome_return.spawn_feature = true;
    float random_num = random(1.0);
    // random tree / bush (favoring maple trees, light bushes)
    if (random_num > 0.7) {
      biome_return.feature_id = 441;
    }
    else if (random_num > 0.6) {
      biome_return.feature_id = 442;
    }
    else if (random_num > 0.4) {
      biome_return.feature_id = 421;
    }
    else if (random_num > 0.15) {
      biome_return.feature_id = 444;
    }
    else if (random_num > 0.11) {
      biome_return.feature_id = 447;
    }
    else if (random_num > 0.08) {
      biome_return.feature_id = 424;
    }
    else if (random_num > 0.06) {
      biome_return.feature_id = 422;
    }
    else if (random_num > 0.04) {
      biome_return.feature_id = 423;
    }
    else if (random_num > 0.02) {
      biome_return.feature_id = 445;
    }
    else {
      biome_return.feature_id = 446;
    }
    return biome_return;
  }
  switch(biome_return.terrain_code) {
    case 151: // Grass, light
    case 153: // Grass, dark
      if (randomChance(0.57 - noise_value)) { // dandelions
        biome_return.spawn_feature = true;
        biome_return.feature_id = 401;
      }
      break;
    case 152: // Grass, green
      if (randomChance(0.63 - noise_value)) { // dandelions
        biome_return.spawn_feature = true;
        biome_return.feature_id = 401;
      }
      break;
  }
  return biome_return;
}


private BiomeReturn grassProcessPerlinNoise(float noise_value) {
  BiomeReturn biome_return = new BiomeReturn();
  if (noise_value > 0.8) {
    biome_return.terrain_code = 154;
  }
  else if (noise_value > 0.6) {
    biome_return.terrain_code = 151;
  }
  else {
    biome_return.terrain_code = 152;
  }
  return biome_return;
}
