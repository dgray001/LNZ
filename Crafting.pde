// Every crafting table is 3x3 at least in the background for the array hash to work properly

class CraftingRecipe {
  private final int[][] ingredients;
  private final int output;
  CraftingRecipe(int[][] ingredients, int output) {
    this.ingredients = ingredients;
    this.output = output;
  }
}

HashMap<Integer, CraftingRecipe> getAllCraftingRecipes() {
  HashMap<Integer, CraftingRecipe> all_recipes = new HashMap<Integer, CraftingRecipe>();
  int[][] ingredients;
  ingredients = new int[][]{{2913}};
  all_recipes.put(Arrays.deepHashCode(ingredients), new CraftingRecipe(ingredients, 2916));
  ingredients = new int[][]{{2162}, {2163}};
  all_recipes.put(Arrays.deepHashCode(ingredients), new CraftingRecipe(ingredients, 2164));
  return all_recipes;
}
