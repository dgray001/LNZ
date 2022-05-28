class CraftingRecipe {
  private final int[][] ingredients;
  private final int output;
  CraftingRecipe(int[][] ingredients, int output) {
    this.ingredients = ingredients;
    this.output = output;
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
  ingredients = new int[][]{{2913}};
  all_recipes.put(Arrays.deepHashCode(ingredients), new CraftingRecipe(ingredients, 2916));
  ingredients = new int[][]{{2163}, {2162}};
  all_recipes.put(Arrays.deepHashCode(ingredients), new CraftingRecipe(ingredients, 2164));
  return all_recipes;
}
