import java.util.*;
import java.io.*;
import processing.javafx.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

Global global;

void setup() {
  fullScreen(FX2D);
  surface.setSize(Constants.initialInterface_size, Constants.initialInterface_size);
  surface.setLocation(int(0.5 * (displayWidth - Constants.initialInterface_size)),
    int(0.5 * (displayHeight - Constants.initialInterface_size)));
  frameRate(Constants.maxFPS);
  global = new Global(this);
  background(global.color_background);
  global.menu = new InitialInterface();
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
  if (global.menu != null) {
    global.menu.update();
  }
  switch(global.state) {
    case INITIAL_INTERFACE:
      break;
    case ENTERING_MAINMENU:
      global.state = ProgramState.MAINMENU_INTERFACE;
      global.menu = new MainMenuInterface();
      break;
    case MAINMENU_INTERFACE:
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
  if (global.menu != null) {
    global.menu.mouseMove(mouseX, mouseY);
  }
}
void mouseMoved() {
  if (global.menu != null) {
    global.menu.mouseMove(mouseX, mouseY);
  }
}

void mousePressed() {
  if (global.menu != null) {
    global.menu.mousePress();
  }
}

void mouseReleased() {
  if (global.menu != null) {
    global.menu.mouseRelease();
  }
}
