class DImg {

  PImage img = null;
  int imgMode = CORNERS;
  int gridX = 0;
  int gridY = 0;

  // Constructor for blank image
  DImg(int x, int y) {
    this.img = createImage(x, y, RGB);
  }
  DImg(PImage img) {
    this.img = img;
  }

  void mode(int imgMode) {
    switch(imgMode) {
      case CORNERS:
      case CORNER:
      case CENTER:
        this.imgMode = imgMode;
        break;
      default:
        print("ERROR: imgMode invalid");
        break;
    }
  }

  void setGrid(int x, int y) {
    this.gridX = x;
    this.gridY = y;
  }

  // Display functions
  void display(float x, float y) {
    imageMode(this.imgMode);
    image(this.img, x, y);
  }
  void display(float xi, float yi, float xf, float yf) {
    imageMode(this.imgMode);
    image(this.img, xi, yi, xf, yf);
  }

  // Return part of an image
  PImage getImageSection(PImage img, int x, int y, int w, int h) {
    return img.get(x, y, w, h);
  }

  // Add image to part of this using width / height
  void addImage(PImage newImg, int x, int y, int w, int h) {
   this.img.copy(newImg, 0, 0, newImg.width, newImg.height, x, y, w, h);
  }
  // Add image to part of this using percent of width / height
  void addImagePercent(PImage newImg, float xP, float yP, float wP, float hP) {
    if (xP < 0.0 || yP < 0.0 || wP < 0.0 || hP < 0.0 || xP > 1.0 || yP > 1.0 || wP > 1.0 || hP > 1.0) {
      println("ERROR: addImagePercent coordinates out of range");
      return;
    }
    this.img.copy(newImg, 0, 0, newImg.width, newImg.height,
      round(this.img.width * xP), round(this.img.height * yP),
      round(this.img.width * wP), round(this.img.height * hP));
  }
  // Add image to grid square
  void addImageGrid(PImage newImg, int x, int y) {
    if (x < 0 || y < 0 || x >= this.gridX || y >= this.gridY) {
      println("ERROR: addImageGrid coordinate out of range");
      return;
    }
    this.img.copy(newImg, 0, 0, newImg.width, newImg.height,
      round(this.img.width * (float(x) / this.gridX)),
      round(this.img.height * (float(y) / this.gridY)),
      this.img.width / this.gridX, this.img.height / this.gridY);
  }
  void addImageGrid(PImage newImg, int x, int y, int w, int h) {
    if (x < 0 || y < 0 || x >= this.gridX || y >= this.gridY) {
      println("ERROR: addImageGrid coordinate out of range");
      return;
    }
    if (w < 1 || h < 1 || x + w >= this.gridX || y + h >= this.gridY) {
      print("ERROR: addImageGrid coordinate our of range");
      return;
    }
    this.img.copy(newImg, 0, 0, newImg.width, newImg.height,
      round(this.img.width * (float(x) / this.gridX)),
      round(this.img.height * (float(y) / this.gridY)),
      w * (this.img.width / this.gridX), h * (this.img.height / this.gridY));
  }

  // color pixels
  void colorPixels(color c) {
    /*float ref_r = c >> 16 & 0xFF;
    float ref_g = c >> 8 & 0xFF;
    float ref_b = c & 0xFF;
    float ref_a = alpha(c);*/
    this.img.loadPixels();
    for (int i = 0; i < this.img.height; i++) {
      for (int j = 0; j < this.img.width; j++) {
        int index = i + this.img.width * j;
        this.img.pixels[index] = c;//color(ref_r, ref_g, ref_b, ref_a);
      }
    }
    this.img.updatePixels();
  }

  void colorPixel(int x, int y, color c) {
    this.img.loadPixels();
    int index = x + y * this.img.width;
    if (index < 0 || index >= this.img.pixels.length) {
      return;
    }
    this.img.pixels[index] = c;
    this.img.updatePixels();
  }
}
