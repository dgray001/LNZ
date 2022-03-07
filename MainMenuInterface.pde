
class MainMenuInterface extends InterfaceLNZ {

  abstract class MainMenuGrowButton extends RippleRectangleButton {
    protected float xf_grow;
    protected float ratio; // ratio when shrunk (can have it be > 1 to make it shrink when hovered)
    protected float grow_speed = 0.7; // pixels / ms
    protected PImage icon;
    protected boolean collapsing = false;

    MainMenuGrowButton(float xi, float yi, float xf, float yf, float ratio) {
      super(xi, yi, xf * ratio, yf);
      this.xf_grow = xf;
      this.ratio = ratio;
      this.maxRippleDistance = xf - xi;
      this.icon = this.getIcon();
      this.text_size = 24;
      this.noStroke();
      this.setColors(color(170), color(1, 0), color(150, 90, 90, 150), color(240, 180, 180), color(255));
      this.refreshColor();
    }

    abstract PImage getIcon();

    @Override
    void update(int millis) {
      int timeElapsed = millis - this.lastUpdateTime;
      float pixelsMoved = timeElapsed * this.grow_speed;
      super.update(millis);
      float pixelsLeft = 0;
      int pixelsToMove = 0;
      if (this.collapsing) {
        if (this.hovered) {
          pixelsLeft = this.xf_grow - this.xf;
          pixelsToMove = int(ceil(min(pixelsLeft, pixelsMoved)));
          if (pixelsToMove > 0) {
            this.stretchButton(pixelsToMove, RIGHT);
          }
          else {
            this.collapsing = false;
            this.refreshColor();
          }
        }
        else {
          pixelsLeft = this.xf_grow * this.ratio - this.xf;
          pixelsToMove = int(floor(max(pixelsLeft, -pixelsMoved)));
          if (pixelsToMove < 0) {
            this.stretchButton(pixelsToMove, RIGHT);
          }
          else {
            this.collapsing = false;
            this.refreshColor();
          }
        }
      }
      if (!this.hovered && !this.collapsing) {
        imageMode(CENTER);
        image(this.icon, this.xCenter(), this.yCenter(), this.button_width(), this.button_height());
      }
    }

    void reset() {
      this.stretchButton(this.xf_grow * this.ratio - this.xf, RIGHT);
      this.collapsing = false;
      this.clicked = false;
      this.hovered = false;
      this.show_message = false;
      this.refreshColor();
    }

    @Override
    color fillColor() {
      if (this.collapsing) {
        if (this.clicked) {
          return this.color_click;
        }
        else {
          return this.color_hover;
        }
      }
      return super.fillColor();
    }

    void hover() {
      this.collapsing = true;
      super.hover();
      this.show_message = true;
    }

    void dehover() {
      this.collapsing = true;
      super.dehover();
      this.show_message = false;
      this.clicked = false;
      this.color_text = color(255);
    }

    void click() {
      super.click();
      this.color_text = color(0);
    }

    void release() {
      super.release();
      this.color_text = color(255);
      this.reset();
    }
  }


  class MainMenuGrowButton1 extends MainMenuGrowButton {
    MainMenuGrowButton1() {
      super(0, height - 60, 200, height, 0.3);
      this.message = "Exit";
    }
    PImage getIcon() {
      return global.images.getImage("icons/power.png");
    }

    @Override
    void release() {
      super.release();
      global.exit();
    }
  }

  class MainMenuGrowButton2 extends MainMenuGrowButton {
    MainMenuGrowButton2() {
      super(0, height - 160, 200, height - 100, 0.3);
      this.message = "Options";
    }
    PImage getIcon() {
      return global.images.getImage("icons/gear.png");
    }

    @Override
    void release() {
      super.release();
      MainMenuInterface.this.form = new OptionsForm();
    }
  }

  class MainMenuGrowButton3 extends MainMenuGrowButton {
    MainMenuGrowButton3() {
      super(0, height - 260, 200, height - 200, 0.3);
      this.message = "Achievements";
    }
    PImage getIcon() {
      return global.images.getImage("icons/achievements.png");
    }

    @Override
    void release() {
      super.release();
      MainMenuInterface.this.form = new AchievementsForm();
    }
  }

  class MainMenuGrowButton4 extends MainMenuGrowButton {
    MainMenuGrowButton4() {
      super(0, height - 360, 200, height - 300, 0.3);
      this.message = "Map Editor";
    }
    PImage getIcon() {
      return global.images.getImage("icons/map.png");
    }

    @Override
    void update(int millis) {
      super.update(millis);
    }

    @Override
    void release() {
      super.release();
    }
  }


  class NewProfileForm extends FormLNZ {
    NewProfileForm() {
      super(0.5 * (width - Constants.newProfileForm_width), 0.5 * (height - Constants.newProfileForm_height),
        0.5 * (width + Constants.newProfileForm_width), 0.5 * (height + Constants.newProfileForm_height));
      this.setTitleText("New Profile");
      this.setTitleSize(18);
      this.setFieldCushion(0);
      this.color_background = color(250, 180, 180);
      this.color_header = color(180, 50, 50);

      StringFormField input = new StringFormField("", "Enter profile name");
      input.input.typing = true;
      MessageFormField error = new MessageFormField("");
      error.text_color = color(150, 20, 20);
      error.setTextSize(18);
      CheckboxFormField checkbox = new CheckboxFormField("Save as default profile  ");
      checkbox.setTextSize(16);

      this.addField(new SpacerFormField(20));
      this.addField(input);
      this.addField(error);
      this.addField(new SpacerFormField(20));
      this.addField(checkbox);
      this.addField(new SpacerFormField(8));
      this.addField(new SubmitFormField("Create New Profile"));
    }

    void submit() {
      String possibleProfileName = this.fields.get(1).getValue();
      int errorcode = isValidProfileName(possibleProfileName);
      switch(errorcode) {
        case 0:
          Profile p = new Profile(possibleProfileName);
          p.save();
          global.profile = p;
          this.canceled = true;
          if (this.fields.get(4).getValue().equals("true")) {
            global.options.default_profile_name = possibleProfileName;
            global.options.save();
          }
          break;
        case 1:
          this.fields.get(2).setValue("Enter a profile name.");
          break;
        case 2:
          this.fields.get(2).setValue("Profile name must start with a letter.");
          break;
        case 3:
          this.fields.get(2).setValue("Profile name must be alphanumeric.");
          break;
        case 4:
          this.fields.get(2).setValue("That profile already exists.");
          break;
        default:
          this.fields.get(2).setValue("An unknown error occured.");
          break;
      }
    }

    @Override
    void cancel() {
      this.fields.get(2).setValue("You must create a profile");
    }
  }


  class AchievementsForm extends FormLNZ {
    AchievementsForm() {
      super(Constants.AchievementsForm_widthOffset, Constants.AchievementsForm_heightOffset,
        width - Constants.AchievementsForm_widthOffset, height - Constants.AchievementsForm_heightOffset);
      this.setTitleText("Achievements");
      this.setTitleSize(20);
      this.color_background = color(180, 250, 250);
      this.color_header = color(50, 180, 180);
      if (global.profile == null) {
        this.canceled = true;
        return;
      }
      // add fields for profile achievements
    }

    void submit() {
    }
  }


  class backgroundImageThread extends Thread {
    private PImage img = createImage(width, height, ARGB);
    private float distance_threshhold = 150;
    private float mX = mouseX;
    private float mY = mouseY;

    backgroundImageThread() {
      super("backgroundImageThread");
    }

    @Override
    void run() {
      DImg dimg = new DImg(this.img);
      dimg.makeTransparent(255);
      dimg.addImagePercent(global.images.getImage("hillary.png"), 0, 0, 1, 1);
      dimg.brightenGradient(0.02, this.distance_threshhold, this.mX, this.mY);
      this.img = dimg.img;
    }
  }


  private MainMenuGrowButton[] growButtons = new MainMenuGrowButton[4];
  private PImage backgroundImage;
  backgroundImageThread thread = new backgroundImageThread();

  MainMenuInterface() {
    super();
    this.backgroundImage = createImage(width, height, RGB);
    this.growButtons[0] = new MainMenuGrowButton1();
    this.growButtons[1] = new MainMenuGrowButton2();
    this.growButtons[2] = new MainMenuGrowButton3();
    this.growButtons[3] = new MainMenuGrowButton4();
    this.loadProfile();
  }

  void loadProfile() {
    if (!this.loadProfile(global.options.default_profile_name)) {
      this.form = new NewProfileForm();
    }
  }
  // returns true if profile loaded
  boolean loadProfile(String profile_name) {
    mkdir("data/profiles", false, true);
    if (!folderExists("data/profiles/" + profile_name.toLowerCase())) {
      println("Profile: No profile folder exists with name " + profile_name + ".");
      return false;
    }
    if (!fileExists("data/profiles/" + profile_name.toLowerCase() + "/profile.lnz")) {
      println("ERROR: Profile file missing for " + profile_name + ".");
      return false;
    }
    global.profile = readProfile(sketchPath("data/profiles/" + profile_name.toLowerCase() + "/profile.lnz"));
    global.profile.display_name = profile_name;
    return true;
  }

  void update(int millis) {
    // draw background
    imageMode(CORNER);
    image(this.backgroundImage, 0, 0);
    // update elements
    for (MainMenuGrowButton button : this.growButtons) {
      button.update(millis);
    }
    // restart thread
    if (!this.thread.isAlive()) {
      this.backgroundImage = this.thread.img;
      this.thread = new backgroundImageThread();
      this.thread.start();
    }
  }

  void mouseMove(float mX, float mY) {
    for (MainMenuGrowButton button : this.growButtons) {
      button.mouseMove(mX, mY);
    }
  }

  void mousePress() {
    for (MainMenuGrowButton button : this.growButtons) {
      button.mousePress();
    }
  }

  void mouseRelease() {
    for (MainMenuGrowButton button : this.growButtons) {
      button.mouseRelease();
    }
  }

  void scroll(int amount) {}
  void keyPress() {}
  void keyRelease() {}
}
