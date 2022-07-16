import java.util.*;
import java.util.concurrent.*;
import java.io.*;
import java.nio.file.*;
import java.awt.event.KeyEvent;
import java.awt.image.BufferedImage;
import processing.javafx.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

Global global;

void setup() {
  fullScreen(FX2D);
  //pixelDensity(displayDensity());
  surface.setSize(Constants.initialInterface_size, Constants.initialInterface_size);
  surface.setLocation(int(0.5 * (displayWidth - Constants.initialInterface_size)),
    int(0.5 * (displayHeight - Constants.initialInterface_size)));
  frameRate(Constants.maxFPS);
  global = new Global(this);
  Profile p = new Profile();
  p.options.setVolumes(); // sets default volumes for initial interface
  background(global.color_background);
  global.menu = new InitialInterface();
  noCursor();
  mouseX = -50;
  mouseY = -50;
}

void draw() {
  int time_elapsed = millis() - global.lastFrameTime;
  if (time_elapsed < 5) { // hard throttle to keep framerate < 200
    return;
  }
  actuallyDraw();
}

void actuallyDraw() {
  int timeElapsed = global.frame();
  // FPS counter
  global.timer_FPS -= timeElapsed;
  if (global.timer_FPS < 0) {
    global.timer_FPS = Constants.frameUpdateTime;
    global.lastFPS = (Constants.frameAverageCache * global.lastFPS + float(frameCount - global.frameCounter) *
      (1000.0 / Constants.frameUpdateTime)) / (Constants.frameAverageCache + 1);
    global.frameCounter = frameCount + 1;
  }
  // Player unit ellipse
  if (global.player_blinks_left > 0) {
    global.player_blink_time -= timeElapsed;
    if (global.player_blink_time < 0) {
      global.player_blink_time += Constants.level_questBlinkTime;
      global.player_blinks_left--;
      global.player_blinking = !global.player_blinking;
    }
  }
  // Program
  if (global.menu != null) {
    global.menu.LNZ_update(millis());
  }
  switch(global.state) {
    case INITIAL_INTERFACE:
      break;
    case ENTERING_MAINMENU:
      global.timer_exiting -= timeElapsed;
      background(30, 0, 0);
      if (global.timer_exiting < 0) {
        global.timer_exiting = Constants.exit_delay;
        global.state = ProgramState.MAINMENU_INTERFACE;
        global.menu = new MainMenuInterface();
        global.sounds.play_background("main");
        global.defaultCursor();
      }
      break;
    case MAINMENU_INTERFACE:
      break;
    case ENTERING_MAPEDITOR:
      background(60);
      global.state = ProgramState.MAPEDITOR_INTERFACE;
      global.menu = new MapEditorInterface();
      global.sounds.play_background("aoc");
      global.defaultCursor();
      break;
    case MAPEDITOR_INTERFACE:
      break;
    case ENTERING_TUTORIAL:
      background(60);
      global.state = ProgramState.TUTORIAL;
      global.menu = new TutorialInterface();
      global.sounds.play_background("none");
      global.defaultCursor();
      break;
    case TUTORIAL:
      break;
    case ENTERING_PLAYING:
      background(60);
      global.state = ProgramState.PLAYING;
      global.menu = new PlayingInterface();
      global.defaultCursor();
      break;
    case PLAYING:
      break;
    case ENTERING_MINIGAMES:
      background(60);
      global.state = ProgramState.MINIGAMES;
      global.menu = new MinigameInterface();
      global.defaultCursor();
      break;
    case MINIGAMES:
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
  // global notification
  if (global.notification.peek() != null) {
    global.notification.peek().update(timeElapsed);
    if (global.notification.peek().finished) {
      global.notification.remove();
    }
  }
  // background music go to next track
  global.sounds.update();
  // cursor
  imageMode(CENTER);
  image(global.cursor, mouseX, mouseY, global.configuration.cursor_size, global.configuration.cursor_size);
  // check focused
  if (!focused && global.focused_last_frame) {
    global.loseFocus();
  }
  else if (focused && !global.focused_last_frame) {
    global.gainFocus();
  }
  global.focused_last_frame = focused;
  // check error message
  global.checkErrorMessge();
}

void mouseDragged() {
  if (global.menu != null) {
    global.menu.LNZ_mouseMove(mouseX, mouseY);
  }
  if (global.notification.peek() != null) {
    global.notification.peek().mouseMove(mouseX, mouseY);
  }
}
void mouseMoved() {
  if (global.menu != null) {
    global.menu.LNZ_mouseMove(mouseX, mouseY);
  }
  if (global.notification.peek() != null) {
    global.notification.peek().mouseMove(mouseX, mouseY);
  }
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    global.holding_rightclick = true;
  }
  if (global.menu != null) {
    global.menu.LNZ_mousePress();
  }
  if (global.notification.peek() != null) {
    global.notification.peek().mousePress();
  }
}

void mouseReleased() {
  if (mouseButton == RIGHT) {
    global.holding_rightclick = false;
  }
  if (global.menu != null) {
    global.menu.LNZ_mouseRelease(mouseX, mouseY);
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
    key = 0;
  }
}

void keyReleased() {
  global.keyReleaseFX2D();
  if (global.menu != null) {
    global.menu.LNZ_keyRelease();
  }
}
