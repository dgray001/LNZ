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
    else if (noise_value > 0.5) {
      return Biome.MAPLE_FOREST2;
    }
    else if (noise_value > 0.32) {
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

  public BiomeReturn processPerlinNoise(float noise_value) {
    return Biome.processPerlinNoise(this, noise_value);
  }
  private static BiomeReturn processPerlinNoise(Biome biome, float noise_value) {
    switch(biome) {
      case MAPLE_FOREST1:
        return Biome.mapleForestProcessPerlinNoise(1, noise_value);
      case MAPLE_FOREST2:
        return Biome.mapleForestProcessPerlinNoise(2, noise_value);
      case MAPLE_FOREST3:
        return Biome.mapleForestProcessPerlinNoise(3, noise_value);
      case CLEARING:
        return Biome.clearingPerlinNoise(noise_value);
      case GRASS:
        return Biome.grassProcessPerlinNoise(noise_value);
    }
    return new BiomeReturn();
  }

  private static BiomeReturn mapleForestProcessPerlinNoise(int forest_density, float noise_value) {
    BiomeReturn biome_return = new BiomeReturn();
    switch(forest_density) {
      case 1:
        biome_return.terrain_code = 161;
        break;
      case 2:
        biome_return.terrain_code = 152;
        break;
      case 3:
        biome_return.terrain_code = 173;
        break;
    }
    return biome_return;
  }

  private static BiomeReturn clearingPerlinNoise(float noise_value) {
    BiomeReturn biome_return = new BiomeReturn();
    biome_return.terrain_code = 151;
    return biome_return;
  }

  private static BiomeReturn grassProcessPerlinNoise(float noise_value) {
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
}
