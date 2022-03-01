import processing.javafx.*;

Global global = new Global();

void setup() {
  fullScreen();
  surface.setSize(Constants.initialInterfaceSize, Constants.initialInterfaceSize);
  surface.setLocation(int(0.5 * (displayWidth - Constants.initialInterfaceSize)),
    int(0.5 * (displayHeight - Constants.initialInterfaceSize)));
  frameRate(Constants.maxFPS);
}

void draw() {
  // FPS counter
  if (millis() - global.frameTimer > Constants.frameUpdateTime) {
    global.lastFPS = (Constants.frameAverageCache * global.lastFPS + float(frameCount - global.frameCounter) *
      (1000.0 / Constants.frameUpdateTime)) / (Constants.frameAverageCache + 1);
    global.frameCounter = frameCount + 1;
    global.frameTimer = millis();
    println(int(global.lastFPS) + " FPS");
  }
}
