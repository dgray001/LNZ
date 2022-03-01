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
  int timeElapsed = global.frame();
  // FPS counter
  global.timer_FPS -= timeElapsed;
  if (global.timer_FPS < 0) {
    global.timer_FPS = Constants.frameUpdateTime;
    global.lastFPS = (Constants.frameAverageCache * global.lastFPS + float(frameCount - global.frameCounter) *
      (1000.0 / Constants.frameUpdateTime)) / (Constants.frameAverageCache + 1);
    global.frameCounter = frameCount + 1;
    //println(int(global.lastFPS) + " FPS");
  }
  // Program
  if (menu != null) {
    menu.update();
  }
  switch(global.state) {
    case INITIAL_INTERFACE:
      break;
    case EXITING:
      global.timer_exiting -= timeElapsed;
      if (global.timer_exiting < 0) {
        exit();
      }
      break;
    default:
      break;
  }
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
