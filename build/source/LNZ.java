/* autogenerated by Processing revision 1281 on 2022-03-01 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import processing.javafx.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class LNZ extends PApplet {



 public void setup() {
  /* size commented out by preprocessor */;
  surface.setSize(Constants.initialInterfaceSize, Constants.initialInterfaceSize);
  surface.setLocation(PApplet.parseInt(0.5f * (displayWidth - Constants.initialInterfaceSize)),
    PApplet.parseInt(0.5f * (displayHeight - Constants.initialInterfaceSize)));
}

 public void draw() {
}
static class Constants {

  // Program constants
  static final String credits =
  "Liberal Nazi Zombies v0.6.0a" +
  "Created by Daniel Gray" +
  "";
  static final int initialInterfaceSize = 400;
}


  public void settings() { fullScreen(); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "LNZ" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
