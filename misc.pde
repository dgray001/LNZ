// Java mod with negative numbers
float negMod(float a, float b) {
  return (a % b + b) % b;
}

// Element to color
color elementalColor(Element e) {
  switch(e) {
    case GRAY:
      return ccolor(170);
    case BLUE:
      return ccolor(0, 0, 255);
    case RED:
      return ccolor(255, 0, 0);
    case CYAN:
      return ccolor(0, 255, 255);
    case ORANGE:
      return ccolor(255, 165, 0);
    case BROWN:
      return ccolor(51, 45, 26);
    case PURPLE:
      return ccolor(125, 0, 125);
    case YELLOW:
      return ccolor(255, 255, 0);
    case MAGENTA:
      return ccolor(255, 0, 255);
    default:
      global.errorMessage("ERROR: Element " + e.element_name() + " doesn't have a color.");
      return ccolor(0);
  }
}
color elementalColorDark(Element e) {
  switch(e) {
    case GRAY:
      return ccolor(145);
    case BLUE:
      return ccolor(0, 0, 200);
    case RED:
      return ccolor(200, 0, 0);
    case CYAN:
      return ccolor(0, 200, 200);
    case ORANGE:
      return ccolor(200, 140, 0);
    case BROWN:
      return ccolor(20, 15, 10);
    case PURPLE:
      return ccolor(100, 0, 100);
    case YELLOW:
      return ccolor(200, 200, 0);
    case MAGENTA:
      return ccolor(200, 0, 200);
    default:
      global.errorMessage("ERROR: Element " + e.element_name() + " doesn't have a color.");
      return ccolor(0);
  }
}
color elementalColorLight(Element e) {
  switch(e) {
    case GRAY:
      return ccolor(195);
    case BLUE:
      return ccolor(25, 25, 255);
    case RED:
      return ccolor(255, 25, 25);
    case CYAN:
      return ccolor(25, 255, 255);
    case ORANGE:
      return ccolor(255, 190, 25);
    case BROWN:
      return ccolor(70, 65, 45);
    case PURPLE:
      return ccolor(150, 0, 150);
    case YELLOW:
      return ccolor(255, 255, 40);
    case MAGENTA:
      return ccolor(255, 40, 255);
    default:
      global.errorMessage("ERROR: Element " + e.element_name() + " doesn't have a color.");
      return ccolor(0);
  }
}
color elementalColorText(Element e) {
  switch(e) {
    case GRAY:
    case BLUE:
    case RED:
    case CYAN:
    case ORANGE:
    case PURPLE:
    case YELLOW:
    case MAGENTA:
      return ccolor(0);
    case BROWN:
      return ccolor(255);
    default:
      global.errorMessage("ERROR: Element " + e.element_name() + " doesn't have a color.");
      return ccolor(0);
  }
}
color elementalColorLocked(Element e) {
  switch(e) {
    case GRAY:
      return ccolor(120);
    case BLUE:
      return ccolor(100, 100, 150);
    case RED:
      return ccolor(150, 100, 100);
    case CYAN:
      return ccolor(100, 150, 150);
    case ORANGE:
      return ccolor(160, 120, 100);
    case BROWN:
      return ccolor(80, 75, 70);
    case PURPLE:
      return ccolor(90, 50, 90);
    case YELLOW:
      return ccolor(150, 150, 100);
    case MAGENTA:
      return ccolor(150, 100, 150);
    default:
      global.errorMessage("ERROR: Element " + e.element_name() + " doesn't have a color.");
      return ccolor(0);
  }
}

// Random events
boolean randomChance(float percent) {
  if (random(1) < percent) {
    return true;
  }
  return false;
}
int randomInt(int min, int max) {
  if (max < min) {
    return randomInt(max, min);
  }
  return min + int(floor(random(1 + max - min)));
}
float randomFloat(float min, float max) {
  if (max < min) {
    return randomFloat(max, min);
  }
  return min + random(max - min);
}

// String to primitive casts
boolean isInt(String str) {
  try {
    int i = Integer.parseInt(str);
    return true;
  } catch(NumberFormatException e) {
    return false;
  }
}
int toInt(String str) {
  int i = -1;
  try {
    i = Integer.parseInt(str);
  } catch(NumberFormatException e) {}
  return i;
}

boolean isFloat(String str) {
  try {
    float i = Float.parseFloat(str);
    return true;
  } catch(NumberFormatException e) {
    return false;
  }
}
float toFloat(String str) {
  float i = -1;
  try {
    i = Float.parseFloat(str);
  } catch(NumberFormatException e) {}
  return i;
}

boolean isBoolean(String str) {
  if (str.equals(Boolean.toString(true)) || str.equals(Boolean.toString(false))) {
    return true;
  }
  else {
    return false;
  }
}
boolean toBoolean(String str) {
  if (str.equals(Boolean.toString(true))) {
    return true;
  }
  else {
    return false;
  }
}


// color functions
color brighten(color c) {
  return adjust_color_brightness(c, 1.05);
}
color darken(color c) {
  return adjust_color_brightness(c, 0.95);
}
color adjust_color_brightness(color c, float factor) {
  float r = constrain(factor * (c >> 16 & 0xFF), 0, 255);
  float g = constrain(factor * (c >> 8 & 0xFF), 0, 255);
  float b = constrain(factor * (c & 0xFF), 0, 255);
  return ccolor(r, g, b, alpha(c));
}
