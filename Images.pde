class Images {
  private HashMap<String, PImage> imgs = new HashMap<String, PImage>();
  private String basePath = sketchPath("data/images/");

  Images() {}

  PImage getImage(String filePath) {
    if (this.imgs.containsKey(filePath)) {
      return this.imgs.get(filePath);
    }
    else {
      PImage img = loadImage(this.basePath + filePath);
      if (img == null) {
        println("ERROR: Missing image " + filePath + ".");
        return this.getBlackPixel();
      }
      else {
        this.imgs.put(filePath, img);
        return img;
      }
    }
  }

  PImage getBlackPixel() {
    PImage img = new PImage(1, 1, RGB);
    img.loadPixels();
    img.pixels[0] = color(0);
    img.updatePixels();
    return img;
  }

  PImage getTransparentPixel() {
    PImage img = new PImage(1, 1, RGB);
    img.loadPixels();
    img.pixels[0] = color(255, 1);
    img.updatePixels();
    return img;
  }
}
