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
