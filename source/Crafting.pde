enum ToolCode {
 SAW, MECHANICAL_SAW, WOOD_GLUE, PAINTBRUSH, CLAMP, FASTENER, DRIVER, MECHANICAL_FASTENER,
 MECHANICAL_DRIVER;

  private static final List<ToolCode> VALUES = Collections.unmodifiableList(Arrays.asList(values()));

  public String displayName() {
    return ToolCode.displayName(this);
  }
  public static String displayName(ToolCode code) {
    if (code == null) {
      return "Null";
    }
    switch(code) {
      case SAW:
        return "Saw";
      case MECHANICAL_SAW:
        return "Mechanical Saw";
      case WOOD_GLUE:
        return "Wood Glue";
      case PAINTBRUSH:
        return "Paintbrush";
      case CLAMP:
        return "Clamp";
      case FASTENER:
        return "Fastener";
      case DRIVER:
        return "Driver";
      case MECHANICAL_FASTENER:
        return "Mechanical Fastener";
      case MECHANICAL_DRIVER:
        return "Mechanical Driver";
      default:
        return "ERROR";
    }
  }

  public static ToolCode toolCodeFrom(String s) {
    for (ToolCode code : ToolCode.VALUES) {
      if (ToolCode.displayName(code).equals(s)) {
        return code;
      }
    }
    return null;
  }

  public static ArrayList<ToolCode> toolCodesFrom(Item i) {
    ArrayList<ToolCode> codes = new ArrayList<ToolCode>();
    if (i == null || i.remove) {
      return codes;
    }
    switch(i.ID) {
      case 2971: // paintbrush
        codes.add(ToolCode.PAINTBRUSH);
        break;
      case 2972: // clamp
        codes.add(ToolCode.CLAMP);
        break;
      case 2973: // wrench
        break;
      case 2974: // rope
        break;
      case 2975: // hammer
        codes.add(ToolCode.DRIVER);
        break;
      case 2976: // window breaker
        break;
      case 2977: // ax
        break;
      case 2978: // wire clippers
        break;
      case 2979: // saw
        codes.add(ToolCode.SAW);
        break;
      case 2980: // drill
        codes.add(ToolCode.DRIVER);
        codes.add(ToolCode.MECHANICAL_DRIVER);
        break;
      case 2981: // roundsaw
        codes.add(ToolCode.SAW);
        codes.add(ToolCode.MECHANICAL_SAW);
        break;
      case 2982: // beltsander
        break;
      case 2983: // chainsaw
        codes.add(ToolCode.SAW);
        codes.add(ToolCode.MECHANICAL_SAW);
        break;
      case 2984: // woodglue
        codes.add(ToolCode.WOOD_GLUE);
        break;
      case 2985: // nails
        codes.add(ToolCode.FASTENER);
        break;
      case 2986: // screws
        codes.add(ToolCode.FASTENER);
        codes.add(ToolCode.MECHANICAL_FASTENER);
        break;
      default:
        break;
    }
    return codes;
  }

  public static ArrayList<ToolCode> toolCodesFrom(Item ... items) {
    Set<ToolCode> codes = new HashSet<ToolCode>();
    for (Item i : items) {
      for (ToolCode code : ToolCode.toolCodesFrom(i)) {
        codes.add(code);
      }
    }
    return new ArrayList<ToolCode>(codes);
  }
}


class CraftingRecipe {
  private final int[][] ingredients;
  private final int output;
  private final int amount;
  private final ToolCode[] tools;
  CraftingRecipe(int[][] ingredients, int output, int amount, ToolCode[] tools) {
    this.ingredients = ingredients;
    this.output = output;
    this.amount = amount;
    this.tools = tools;
  }
  boolean hasTools(ArrayList<ToolCode> codes) {
    for (ToolCode code : this.tools) {
      if (!codes.contains(code)) {
        return false;
      }
    }
    return true;
  }
  void useTools(ArrayList<Item> tools_available) {
    for (ToolCode code : this.tools) {
      boolean no_tool = true;
      for (Item i : tools_available) {
        if (i == null || i.remove) {
          continue;
        }
        if (ToolCode.toolCodesFrom(i).contains(code)) {
          i.lowerDurability();
          no_tool = false;
          break;
        }
      }
      if (no_tool) {
        global.log("WARNING: No tool contained ToolCode " + code + " when crafting " + this.output + ".");
      }
    }
  }
}


int[][] reduceItemGrid(int[][] item_grid) {
  if (item_grid == null) {
    return null;
  }
  for (int i = 0; i < item_grid.length; i++) {
    boolean empty = true;
    for (int j = 0; j < item_grid[i].length; j++) {
      if (item_grid[i][j] != 0) {
        empty = false;
      }
    }
    if (empty) {
      item_grid = Arrays.copyOfRange(item_grid, 1, item_grid.length);
      i--;
    }
    else {
      break;
    }
  }
  for (int i = item_grid.length - 1; i >= 0; i--) {
    boolean empty = true;
    for (int j = 0; j < item_grid[i].length; j++) {
      if (item_grid[i][j] != 0) {
        empty = false;
      }
    }
    if (empty) {
      item_grid = Arrays.copyOfRange(item_grid, 0, item_grid.length - 1);
    }
    else {
      break;
    }
  }
  if (item_grid.length == 0) {
    return item_grid;
  }
  for (int i = 0; i < item_grid[0].length; i++) {
    boolean empty = true;
    try {
      for (int j = 0; j < item_grid.length; j++) {
        if (item_grid[j][i] != 0) {
          empty = false;
        }
      }
    } catch(ArrayIndexOutOfBoundsException e) {
      global.errorMessage("ERROR: Input item grid is corrupted: " + Arrays.deepToString(item_grid));
    }
    if (empty) {
      for (int j = 0; j < item_grid.length; j++) {
        item_grid[j] = Arrays.copyOfRange(item_grid[j], 1, item_grid[j].length);
      }
      i--;
    }
    else {
      break;
    }
  }
  if (item_grid.length == 0) {
    return item_grid;
  }
  for (int i = item_grid[0].length - 1; i >= 0; i--) {
    boolean empty = true;
    try {
      for (int j = 0; j < item_grid.length; j++) {
        if (item_grid[j][i] != 0) {
          empty = false;
        }
      }
    } catch(ArrayIndexOutOfBoundsException e) {
      global.errorMessage("ERROR: Input item grid is corrupted: " + Arrays.deepToString(item_grid));
    }
    if (empty) {
      for (int j = 0; j < item_grid.length; j++) {
        item_grid[j] = Arrays.copyOfRange(item_grid[j], 0, item_grid[j].length - 1);
      }
    }
    else {
      break;
    }
  }
  return item_grid;
}


HashMap<Integer, CraftingRecipe> getAllCraftingRecipes() {
  HashMap<Integer, CraftingRecipe> all_recipes = new HashMap<Integer, CraftingRecipe>();
  int[][] ingredients;

  // ### Household Crafting
  // Candlestick from broken candlestick
  ingredients = new int[][]{{2161}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2162, 1, new ToolCode[]{ToolCode.WOOD_GLUE, ToolCode.CLAMP}));
  // Candle
  ingredients = new int[][]{{0, 2809, 0}, {2810, 2809, 2810}, {2810, 2810, 2810}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2163, 1, new ToolCode[]{}));
  // lords day candle
  ingredients = new int[][]{{2163}, {2162}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2164, 1, new ToolCode[]{}));
  // Crumpled paper from paper
  ingredients = new int[][]{{2913}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2916, 1, new ToolCode[]{}));

  // ### Materials
  // wooden planks
  ingredients = new int[][]{{2969}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2816, 2, new ToolCode[]{ToolCode.MECHANICAL_SAW}));
  // wooden piece
  ingredients = new int[][]{{2816}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2818, 4, new ToolCode[]{ToolCode.SAW}));
  // wooden handle
  ingredients = new int[][]{{2818}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2817, 1, new ToolCode[]{ToolCode.SAW}));

  // ### Melee Weapons
  // wooden sword
  ingredients = new int[][]{{2818}, {2818}, {2817}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2205, 1, new ToolCode[]{ToolCode.WOOD_GLUE, ToolCode.CLAMP}));
  // wooden spear
  ingredients = new int[][]{{2818}, {2817}, {2817}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2207, 1, new ToolCode[]{ToolCode.WOOD_GLUE, ToolCode.CLAMP}));
  // talc sword
  ingredients = new int[][]{{2802}, {2802}, {2817}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2206, 1, new ToolCode[]{ToolCode.FASTENER, ToolCode.DRIVER}));
  // talc spear
  ingredients = new int[][]{{2802}, {2817}, {2817}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2208, 1, new ToolCode[]{ToolCode.FASTENER, ToolCode.DRIVER}));
  // gypsum sword
  ingredients = new int[][]{{2812}, {2812}, {2817}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2212, 1, new ToolCode[]{ToolCode.FASTENER, ToolCode.DRIVER}));
  // gypsum spear
  ingredients = new int[][]{{2812}, {2817}, {2817}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2213, 1, new ToolCode[]{ToolCode.FASTENER, ToolCode.DRIVER}));
  // calcite sword
  ingredients = new int[][]{{2822}, {2822}, {2817}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2221, 1, new ToolCode[]{ToolCode.FASTENER, ToolCode.DRIVER}));
  // calcite spear
  ingredients = new int[][]{{2822}, {2817}, {2817}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2222, 1, new ToolCode[]{ToolCode.FASTENER, ToolCode.DRIVER}));
  // fluorite sword
  ingredients = new int[][]{{2832}, {2832}, {2817}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2231, 1, new ToolCode[]{ToolCode.FASTENER, ToolCode.DRIVER}));
  // fluorite spear
  ingredients = new int[][]{{2832}, {2817}, {2817}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2232, 1, new ToolCode[]{ToolCode.FASTENER, ToolCode.DRIVER}));
  // apatite sword
  ingredients = new int[][]{{2842}, {2842}, {2817}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2241, 1, new ToolCode[]{ToolCode.FASTENER, ToolCode.DRIVER}));
  // apatite spear
  ingredients = new int[][]{{2842}, {2817}, {2817}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2242, 1, new ToolCode[]{ToolCode.FASTENER, ToolCode.DRIVER}));
  // orthoclase sword
  ingredients = new int[][]{{2852}, {2852}, {2843}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2251, 1, new ToolCode[]{ToolCode.MECHANICAL_FASTENER, ToolCode.MECHANICAL_DRIVER}));
  // orthoclase spear
  ingredients = new int[][]{{2852}, {2843}, {2843}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2252, 1, new ToolCode[]{ToolCode.MECHANICAL_FASTENER, ToolCode.MECHANICAL_DRIVER}));
  // quartz sword
  ingredients = new int[][]{{2862}, {2862}, {2843}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2261, 1, new ToolCode[]{ToolCode.MECHANICAL_FASTENER, ToolCode.MECHANICAL_DRIVER}));
  // quartz spear
  ingredients = new int[][]{{2862}, {2843}, {2843}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2262, 1, new ToolCode[]{ToolCode.MECHANICAL_FASTENER, ToolCode.MECHANICAL_DRIVER}));
  // topaz sword
  ingredients = new int[][]{{2872}, {2872}, {2843}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2271, 1, new ToolCode[]{ToolCode.MECHANICAL_FASTENER, ToolCode.MECHANICAL_DRIVER}));
  // topaz spear
  ingredients = new int[][]{{2872}, {2843}, {2843}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2272, 1, new ToolCode[]{ToolCode.MECHANICAL_FASTENER, ToolCode.MECHANICAL_DRIVER}));
  // corundum sword
  ingredients = new int[][]{{2882}, {2882}, {2843}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2281, 1, new ToolCode[]{ToolCode.MECHANICAL_FASTENER, ToolCode.MECHANICAL_DRIVER}));
  // corundum spear
  ingredients = new int[][]{{2882}, {2843}, {2843}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2282, 1, new ToolCode[]{ToolCode.MECHANICAL_FASTENER, ToolCode.MECHANICAL_DRIVER}));
  // diamond sword
  ingredients = new int[][]{{2892}, {2892}, {2843}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2291, 1, new ToolCode[]{ToolCode.MECHANICAL_FASTENER, ToolCode.MECHANICAL_DRIVER}));
  // diamond spear
  ingredients = new int[][]{{2892}, {2843}, {2843}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2292, 1, new ToolCode[]{ToolCode.MECHANICAL_FASTENER, ToolCode.MECHANICAL_DRIVER}));

  // ### Headgear
  // Talc Helmet
  ingredients = new int[][]{{2802, 2802, 2802}, {2802, 0, 2802}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2401, 1, new ToolCode[]{}));
  // Gypsum Helmet
  ingredients = new int[][]{{2812, 2812, 2812}, {2812, 0, 2812}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2411, 1, new ToolCode[]{}));
  // Calcite Helmet
  ingredients = new int[][]{{2822, 2822, 2822}, {2822, 0, 2822}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2421, 1, new ToolCode[]{}));
  // Fluorite Helmet
  ingredients = new int[][]{{2832, 2832, 2832}, {2832, 0, 2832}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2431, 1, new ToolCode[]{}));
  // Apatite Helmet
  ingredients = new int[][]{{2842, 2842, 2842}, {2842, 0, 2842}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2441, 1, new ToolCode[]{}));
  // Orthoclase Helmet
  ingredients = new int[][]{{2852, 2852, 2852}, {2852, 0, 2852}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2451, 1, new ToolCode[]{}));
  // Quartz Helmet
  ingredients = new int[][]{{2862, 2862, 2862}, {2862, 0, 2862}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2461, 1, new ToolCode[]{}));
  // Topaz Helmet
  ingredients = new int[][]{{2872, 2872, 2872}, {2872, 0, 2872}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2471, 1, new ToolCode[]{}));
  // Corundum Helmet
  ingredients = new int[][]{{2882, 2882, 2882}, {2882, 0, 2882}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2481, 1, new ToolCode[]{}));
  // Diamond Helmet
  ingredients = new int[][]{{2892, 2892, 2892}, {2892, 0, 2892}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2491, 1, new ToolCode[]{}));

  // ### Chestgear
  // Talc Chestplate
  ingredients = new int[][]{{2802, 0, 2802}, {2802, 2802, 2802}, {2802, 2802, 2802}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2501, 1, new ToolCode[]{}));
  // Gypsum Chestplate
  ingredients = new int[][]{{2812, 0, 2812}, {2812, 2812, 2812}, {2812, 2812, 2812}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2511, 1, new ToolCode[]{}));
  // Calcite Chestplate
  ingredients = new int[][]{{2822, 0, 2822}, {2822, 2822, 2822}, {2822, 2822, 2822}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2521, 1, new ToolCode[]{}));
  // Fluorite Chestplate
  ingredients = new int[][]{{2832, 0, 2832}, {2832, 2832, 2832}, {2832, 2832, 2832}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2531, 1, new ToolCode[]{}));
  // Apatite Chestplate
  ingredients = new int[][]{{2842, 0, 2842}, {2842, 2842, 2842}, {2842, 2842, 2842}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2541, 1, new ToolCode[]{}));
  // Orthoclase Chestplate
  ingredients = new int[][]{{2852, 0, 2852}, {2852, 2852, 2852}, {2852, 2852, 2852}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2551, 1, new ToolCode[]{}));
  // Quartz Chestplate
  ingredients = new int[][]{{2862, 0, 2862}, {2862, 2862, 2862}, {2862, 2862, 2862}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2561, 1, new ToolCode[]{}));
  // Topaz Chestplate
  ingredients = new int[][]{{2872, 0, 2872}, {2872, 2872, 2872}, {2872, 2872, 2872}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2571, 1, new ToolCode[]{}));
  // Corundum Chestplate
  ingredients = new int[][]{{2882, 0, 2882}, {2882, 2882, 2882}, {2882, 2882, 2882}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2581, 1, new ToolCode[]{}));
  // Diamond Chestplate
  ingredients = new int[][]{{2892, 0, 2892}, {2892, 2892, 2892}, {2892, 2892, 2892}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2591, 1, new ToolCode[]{}));

  // ### Leggear
  // Talc Greaves
  ingredients = new int[][]{{2802, 2802, 2802}, {2802, 0, 2802}, {2802, 0, 2802}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2601, 1, new ToolCode[]{}));
  // Gypsum Greaves
  ingredients = new int[][]{{2812, 2812, 2812}, {2812, 0, 2812}, {2812, 0, 2812}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2611, 1, new ToolCode[]{}));
  // Calcite Greaves
  ingredients = new int[][]{{2822, 2822, 2822}, {2822, 0, 2822}, {2822, 0, 2822}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2621, 1, new ToolCode[]{}));
  // Fluorite Greaves
  ingredients = new int[][]{{2832, 2832, 2832}, {2832, 0, 2832}, {2832, 0, 2832}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2631, 1, new ToolCode[]{}));
  // Apatite Greaves
  ingredients = new int[][]{{2842, 2842, 2842}, {2842, 0, 2842}, {2842, 0, 2842}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2641, 1, new ToolCode[]{}));
  // Orthoclase Greaves
  ingredients = new int[][]{{2852, 2852, 2852}, {2852, 0, 2852}, {2852, 0, 2852}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2651, 1, new ToolCode[]{}));
  // Quartz Greaves
  ingredients = new int[][]{{2862, 2862, 2862}, {2862, 0, 2862}, {2862, 0, 2862}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2661, 1, new ToolCode[]{}));
  // Topaz Greaves
  ingredients = new int[][]{{2872, 2872, 2872}, {2872, 0, 2872}, {2872, 0, 2872}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2671, 1, new ToolCode[]{}));
  // Corundum Greaves
  ingredients = new int[][]{{2882, 2882, 2882}, {2882, 0, 2882}, {2882, 0, 2882}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2681, 1, new ToolCode[]{}));
  // Diamond Greaves
  ingredients = new int[][]{{2892, 2892, 2892}, {2892, 0, 2892}, {2892, 0, 2892}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2691, 1, new ToolCode[]{}));

  // ### Footgear
  // Talc Boots
  ingredients = new int[][]{{2802, 0, 2802}, {2802, 0, 2802}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2701, 1, new ToolCode[]{}));
  // Gypsum Boots
  ingredients = new int[][]{{2812, 0, 2812}, {2812, 0, 2812}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2711, 1, new ToolCode[]{}));
  // Calcite Boots
  ingredients = new int[][]{{2822, 0, 2822}, {2822, 0, 2822}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2721, 1, new ToolCode[]{}));
  // Fluorite Boots
  ingredients = new int[][]{{2832, 0, 2832}, {2832, 0, 2832}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2731, 1, new ToolCode[]{}));
  // Apatite Boots
  ingredients = new int[][]{{2842, 0, 2842}, {2842, 0, 2842}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2741, 1, new ToolCode[]{}));
  // Orthoclase Boots
  ingredients = new int[][]{{2852, 0, 2852}, {2852, 0, 2852}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2751, 1, new ToolCode[]{}));
  // Quartz Boots
  ingredients = new int[][]{{2862, 0, 2862}, {2862, 0, 2862}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2761, 1, new ToolCode[]{}));
  // Topaz Boots
  ingredients = new int[][]{{2872, 0, 2872}, {2872, 0, 2872}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2771, 1, new ToolCode[]{}));
  // Corundum Boots
  ingredients = new int[][]{{2882, 0, 2882}, {2882, 0, 2882}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2781, 1, new ToolCode[]{}));
  // Diamond Boots
  ingredients = new int[][]{{2892, 0, 2892}, {2892, 0, 2892}};
  all_recipes.putIfAbsent(Arrays.deepHashCode(ingredients), new CraftingRecipe(
    ingredients, 2791, 1, new ToolCode[]{}));

  return all_recipes;
}
