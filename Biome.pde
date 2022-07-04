enum AreaLocation {
  FERNWOOD_FOREST;
}

class BiomeReturn {
}

enum Biome {
  MAPLE_FOREST1, MAPLE_FOREST2, MAPLE_FOREST3, GRASS;

  public int terrainCode(float noise_value) {
    return Biome.terrainCode(this, noise_value);
  }
  public static int terrainCode(Biome biome, float noise_value) {
    switch(biome) {
      case MAPLE_FOREST1:
        return Biome.mapleForestTerrainCode(1, noise_value);
      case MAPLE_FOREST2:
        return Biome.mapleForestTerrainCode(2, noise_value);
      case MAPLE_FOREST3:
        return Biome.mapleForestTerrainCode(3, noise_value);
      case GRASS:
        return Biome.grassTerrainCode(noise_value);
    }
    return 0;
  }

  private static int mapleForestTerrainCode(int forest_density, float noise_value) {
  }

  private static int grassTerrainCode(float noise_value) {
    if (noise_value > 0.8) {
      return 151;
    }
    else {
      return 152;
    }
  }
}
