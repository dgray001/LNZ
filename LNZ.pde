import processing.javafx.*;

Global global = new Global();

InterfaceLNZ menu;

void setup() {
  fullScreen();
  surface.setSize(Constants.initialInterface_size, Constants.initialInterface_size);
  surface.setLocation(int(0.5 * (displayWidth - Constants.initialInterface_size)),
    int(0.5 * (displayHeight - Constants.initialInterface_size)));
  frameRate(Constants.maxFPS);
  menu = new InitialInterface();
}

void draw() {
  // FPS counter
  if (millis() - global.frameTimer > Constants.frameUpdateTime) {
    global.lastFPS = (Constants.frameAverageCache * global.lastFPS + float(frameCount - global.frameCounter) *
      (1000.0 / Constants.frameUpdateTime)) / (Constants.frameAverageCache + 1);
    global.frameCounter = frameCount + 1;
    global.frameTimer = millis();
    //println(int(global.lastFPS) + " FPS");
  }
  // Program
  menu.update();
}

void mouseDragged() {
  menu.mouseMove(mouseX, mouseY);
}
void mouseMoved() {
  menu.mouseMove(mouseX, mouseY);
}

void mousePressed() {
  menu.mousePress();
}

void mouseReleased() {
  menu.mouseRelease();
}
