import processing.javafx.*;

void setup() {
  fullScreen();
  surface.setSize(Constants.initialInterfaceSize, Constants.initialInterfaceSize);
  surface.setLocation(int(0.5 * (displayWidth - Constants.initialInterfaceSize)),
    int(0.5 * (displayHeight - Constants.initialInterfaceSize)));
}

void draw() {
}
