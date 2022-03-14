class DImg {

  PImage img = null;
  int imgMode = CORNERS;
  int gridX = 0;
  int gridY = 0;

  // Constructor for blank image
  DImg(int x, int y) {
    this.img = createImage(x, y, ARGB);
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

  // image piece
  PImage getImagePiece(int xi, int yi, int w, int h) {
    if (w < 0 || h < 0) {
      return createImage(1, 1, ARGB);
    }
    PImage return_image = createImage(w, h, ARGB);
    return_image.loadPixels();
    for (int i = 0; i < h; i++) {
      for (int j = 0; j < w; j++) {
        int index = (yi + i) * this.img.width + (xi + j);
        if (index < 0 || index >= this.img.pixels.length) {
          continue;
        }
        int return_index = i * w + j;
        return_image.pixels[return_index] = this.img.pixels[index];
      }
    }
    return_image.updatePixels();
    return return_image;
  }

  // convolution
  void convolution(float[][] matrix) {
    if (matrix.length % 2 != 1 || matrix[0].length % 2 != 1) {
      println("ERROR: convolution matrix invalid size.");
      return;
    }
    this.img.loadPixels();
    for (int i = 0; i < this.img.height; i++) {
      for (int j = 0; j < this.img.width; j++) {
        int index = i * this.img.width + j;
        float r_total = 0;
        float g_total = 0;
        float b_total = 0;
        for (int i_offset = 0; i_offset < matrix[0].length; i_offset++) {
          for (int j_offset = 0; j_offset < matrix.length; j_offset++) {
            int i_corrected = constrain(i + i_offset - matrix[0].length / 2, 0, this.img.height);
            int j_corrected = constrain(j + j_offset - matrix.length / 2, 0, this.img.width);
            int index_offset = constrain(i_corrected * this.img.width + j_corrected, 0, this.img.pixels.length - 1);
            float factor = matrix[i_offset][j_offset];
            r_total += factor * (this.img.pixels[index_offset] >> 16 & 0xFF);
            g_total += factor * (this.img.pixels[index_offset] >> 8 & 0xFF);
            b_total += factor * (this.img.pixels[index_offset] & 0xFF);
          }
        }
        r_total = constrain(r_total, 0, 255);
        g_total = constrain(g_total, 0, 255);
        b_total = constrain(b_total, 0, 255);
        this.img.pixels[index] = color(r_total, g_total, b_total);
      }
    }
    this.img.updatePixels();
  }
  void blur() {
    this.convolution(new float[][]{{1.0/9, 1.0/9, 1.0/9}, {1.0/9, 1.0/9, 1.0/9}, {1.0/9, 1.0/9, 1.0/9}});
  }
  void sharpen() {
    this.convolution(new float[][]{{-1, -1, -1}, {-1, 9, -1}, {-1, -1, -1}});
  }

  // Brighten
  void brighten(float factor) {
    this.img.loadPixels();
    for (int i = 0; i < this.img.height; i++) {
      for (int j = 0; j < this.img.width; j++) {
        int index = i * this.img.width + j;
        if (index == 0) {
          continue;
        }
        color c = this.img.pixels[index];
        float r = constrain((c >> 16 & 0xFF) * factor, 0, 255);
        float g = constrain((c >> 8 & 0xFF) * factor, 0, 255);
        float b = constrain((c & 0xFF) * factor, 0, 255);
        float a = alpha(c);
        this.img.pixels[index] = color(r, g, b, a);
      }
    }
    this.img.updatePixels();
  }

  void brightenGradient(float factor, float gradientDistance, float x, float y) {
    this.img.loadPixels();
    for (int i = 0; i < this.img.height; i++) {
      for (int j = 0; j < this.img.width; j++) {
        int index = i * this.img.width + j;
        float distance = sqrt((i - y) * (i - y) + (j - x) * (j - x));
        float curr_factor = factor;
        if (distance < gradientDistance) {
          curr_factor = 1 + (factor - 1) * distance / gradientDistance;
        }
        color c = this.img.pixels[index];
        float r = constrain((c >> 16 & 0xFF) * curr_factor, 0, 255);
        float g = constrain((c >> 8 & 0xFF) * curr_factor, 0, 255);
        float b = constrain((c & 0xFF) * curr_factor, 0, 255);
        int col = ccolor(int(r), int(g), int(b), 254);
        this.img.pixels[index] = col;
      }
    }
    this.img.updatePixels();
  }

  // transparent
  void makeTransparent() {
    this.makeTransparent(1);
  }
  void makeTransparent(int alpha) {
    this.img.loadPixels();
    for (int i = 0; i < this.img.height; i++) {
      for (int j = 0; j < this.img.width; j++) {
        int index = i * this.img.width + j;
        if (index == 0) {
          continue;
        }
        float r = this.img.pixels[index] >> 16 & 0xFF;
        float g = this.img.pixels[index] >> 8 & 0xFF;
        float b = this.img.pixels[index] & 0xFF;
        this.img.pixels[index] = ccolor(int(r), int(g), int(b), alpha);
      }
    }
    this.img.updatePixels();
  }
  void transparencyGradientFromPoint(float x, float y, float distance) {
    this.img.loadPixels();
    for (int i = 0; i < this.img.height; i++) {
      for (int j = 0; j < this.img.width; j++) {
        int index = i * this.img.width + j;
        if (index == 0) {
          continue;
        }
        float r = this.img.pixels[index] >> 16 & 0xFF;
        float g = this.img.pixels[index] >> 8 & 0xFF;
        float b = this.img.pixels[index] & 0xFF;
        float curr_distance = sqrt((i - y) * (i - y) + (j - x) * (j - x));
        float alpha = 0;
        if (curr_distance < distance) {
          alpha = 255 * (1 - curr_distance / distance);
        }
        this.img.pixels[index] = color(r, g, b, alpha);
      }
    }
    this.img.updatePixels();
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
        int index = i * this.img.width + j;
        if (index == 0) {
          continue;
        }
        this.img.pixels[index] = c; //color(ref_r, ref_g, ref_b, ref_a);
      }
    }
    this.img.updatePixels();
  }

  void colorPixel(int x, int y, color c) {
    this.img.loadPixels();
    int index = x + y * this.img.width;
    if (index < 1 || index >= this.img.pixels.length) {
      return;
    }
    this.img.pixels[index] = c;
    this.img.updatePixels();
  }
}


// resize image using nearest-neighbor interpolation
PImage resizeImage(PImage img, int w, int h) {
  if (w <= 0 || h <= 0) {
    return createImage(1, 1, ARGB);
  }
  float scaling_width = img.width / float(w);
  float scaling_height = img.height / float(h);
  PImage return_image = createImage(w, h, ARGB);
  return_image.loadPixels();
  for (int i = 0; i < h; i++) {
    int imgY = int(round(scaling_height * i + 0.5));
    for (int j = 0; j < w; j++) {
      int imgX = int(round(scaling_width * j + 0.5));

      int index = i * w + j;
      int img_index = imgY * img.width + imgX;
      try {
        return_image.pixels[index] = img.pixels[img_index];
      } catch(Exception e) {}
    }
  }
  return_image.updatePixels();
  return return_image;
}
