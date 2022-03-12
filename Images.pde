int ccolor(int gray) {
  return ccolor(gray, gray, gray, 255);
}
int ccolor(int gray, int a) {
  return ccolor(gray, gray, gray, a);
}
int ccolor(int r, int g, int b) {
  return ccolor(r, g, b, 255);
}
int ccolor(int r, int g, int b, int a) {
  int max = 256;
  return max*max*max*a + max*max*r + max*g + b;
  //return ((255 - a) << 32) | (r << 16) | (g << 8) | b;
}


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
    PImage img = new PImage(1, 1, ARGB);
    img.loadPixels();
    img.pixels[0] = color(255, 0);
    img.updatePixels();
    return img;
  }
}



PImage getCurrImage() {
  PImage img = createImage(width, height, ARGB);
  img.loadPixels();
  loadPixels();
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      int index = i + j * width;
      img.pixels[index] = pixels[index];
    }
  }
  img.updatePixels();
  return img;
}

PImage getCurrImage(int xi, int yi, int xf, int yf) {
  PImage img = createImage(xf - xi, yf - yi, ARGB);
  img.loadPixels();
  loadPixels();
  for (int i = xi; i <= xf; i++) {
    for (int j = yi; j <= yf; j++) {
      int index = i + j * width;
      if (index < 0 || index >= pixels.length) {
        continue;
      }
      int img_index = (i - xi) + (j - yi) * img.width;
      if (img_index >= img.pixels.length) {
        continue;
      }
      img.pixels[img_index] = pixels[index];
    }
  }
  img.updatePixels();
  return img;
}
