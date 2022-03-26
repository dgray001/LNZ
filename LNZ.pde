import java.util.*;
import java.io.*;
import java.nio.file.*;
import java.awt.event.KeyEvent;
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
  noCursor();
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
    println(int(global.lastFPS) + " FPS");
  }
  // Program
  if (global.menu != null) {
    global.menu.LNZ_update(millis());
  }
  switch(global.state) {
    case INITIAL_INTERFACE:
      break;
    case ENTERING_MAINMENU:
      background(30, 0, 0);
      global.state = ProgramState.MAINMENU_INTERFACE;
      global.menu = new MainMenuInterface();
      global.sounds.play_background("main");
      break;
    case MAINMENU_INTERFACE:
      break;
    case ENTERING_MAPEDITOR:
      background(60);
      global.state = ProgramState.MAPEDITOR_INTERFACE;
      global.menu = new MapEditorInterface();
      global.sounds.play_background("aoc");
      break;
    case MAPEDITOR_INTERFACE:
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
  // background music go to next track
  global.sounds.update();
  // cursor
  imageMode(CENTER);
  image(global.cursor, mouseX, mouseY, global.configuration.cursor_size, global.configuration.cursor_size);
}

void mouseDragged() {
  if (global.menu != null) {
    global.menu.LNZ_mouseMove(mouseX, mouseY);
  }
}
void mouseMoved() {
  if (global.menu != null) {
    global.menu.LNZ_mouseMove(mouseX, mouseY);
  }
}

void mousePressed() {
  if (global.menu != null) {
    global.menu.LNZ_mousePress();
  }
}

void mouseReleased() {
  if (global.menu != null) {
    global.menu.LNZ_mouseRelease();
  }
}

void mouseWheel(MouseEvent e) {
  if (global.menu != null) {
    global.menu.LNZ_scroll(e.getCount());
  }
}

void keyPressed() {
  global.keyPressFX2D();
  if (global.menu != null) {
    global.menu.LNZ_keyPress();
  }
  // Prevent sketch from exiting on ESC
  if (key == ESC) {
    //key = 0;
  }
}

void keyReleased() {
  global.keyReleaseFX2D();
  if (global.menu != null) {
    global.menu.LNZ_keyRelease();
  }
}
