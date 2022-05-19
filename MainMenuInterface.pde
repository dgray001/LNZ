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
      if (this.collapsing) {
        if (this.hovered) {
          pixelsLeft = this.xf_grow - this.xf;
          if (pixelsLeft < pixelsMoved) {
            this.collapsing = false;
            this.refreshColor();
            pixelsMoved = pixelsLeft;
          }
          this.stretchButton(pixelsMoved, RIGHT);
        }
        else {
          pixelsMoved *= -1;
          pixelsLeft = this.xf_grow * this.ratio - this.xf;
          if (pixelsLeft > pixelsMoved) {
            this.collapsing = false;
            this.refreshColor();
            pixelsMoved = pixelsLeft;
          }
          this.stretchButton(pixelsMoved, RIGHT);
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
      global.sounds.trigger_interface("interfaces/buttonOn4");
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
      global.sounds.trigger_interface("interfaces/buttonClick6");
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
      if (this.hovered) {
        global.exitDelay();
      }
      super.release();
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
      if (this.hovered) {
        MainMenuInterface.this.form = new OptionsForm();
      }
      super.release();
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
      if (this.hovered) {
        MainMenuInterface.this.form = new AchievementsForm();
      }
      super.release();
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
      if (this.hovered) {
        global.state = ProgramState.ENTERING_MAPEDITOR;
      }
      super.release();
    }
  }

  class MainMenuGrowButton5 extends MainMenuGrowButton {
    MainMenuGrowButton5() {
      super(0, height - 460, 200, height - 400, 0.3);
      this.message = "Tutorial";
    }
    PImage getIcon() {
      return global.images.getImage("icons/tutorial.png");
    }

    @Override
    void update(int millis) {
      super.update(millis);
    }

    @Override
    void release() {
      if (this.hovered) {
        global.state = ProgramState.ENTERING_TUTORIAL;
        global.profile.addHero(HeroCode.BEN);
      }
      super.release();
    }
  }


  class BannerButton extends ImageButton {
    BannerButton() {
      super(global.images.getImage("banner_default.png"), 0, 0, 0, 0);
      float banner_width = min(Constants.banner_maxWidthRatio * width, Constants.banner_maxHeightRatio * height * this.img.width / this.img.height);
      float banner_height = min(Constants.banner_maxHeightRatio * height, banner_width * this.img.height / this.img.width);
      banner_width = banner_height * this.img.width / this.img.height;
      float xi = 0.5 * (width - banner_width);
      float yi = -10;
      float xf = 0.5 * (width + banner_width) - 10;
      float yf = banner_height;
      this.setLocation(xi, yi, xf, yf);
    }

    @Override
    void drawButton() {
      imageMode(CORNERS);
      image(this.img, this.xi, this.yi, this.xf, this.yf);
    }

    void hover() {
      this.setImg(global.images.getImage("banner_hovered.png"));
    }

    void dehover() {
      this.setImg(global.images.getImage("banner_default.png"));
    }

    void click() {
      global.sounds.trigger_interface("interfaces/buttonClick1");
      this.setImg(global.images.getImage("banner_clicked.png"));
    }

    void release() {
      if (this.hovered) {
        this.setImg(global.images.getImage("banner_default.png"));
        MainMenuInterface.this.form = new CreditsForm();
        this.hovered = false;
        this.clicked = false;
      }
    }
  }


  class PlayButton extends LeagueButton {
    PlayButton() {
      super(0.5 * width, height - 10, 300 * Constants.playButton_scaleFactor,
        400 * Constants.playButton_scaleFactor, 0.2 * PI, 40 * Constants.playButton_scaleFactor,
        12 * Constants.playButton_scaleFactor);
      this.setColors(color(170), color(120, 200, 120), color(150, 250, 150), color(30, 120, 30), color(50, 10, 50));
      this.message = "Play Game";
      this.show_message = true;
      this.text_size = 22 * Constants.playButton_scaleFactor;
    }
    void hover() {
      global.sounds.trigger_interface("interfaces/buttonOn2");
    }
    void dehover() {}
    void click() {
      global.sounds.trigger_interface("interfaces/buttonClick2");
      this.color_text = color(255, 190, 255);
    }
    void release() {
      this.color_text = color(50, 10, 50);
      if (this.hovered) {
        if (global.profile.upgraded(PlayerTreeCode.CAN_PLAY)) {
          println("launch game");
        }
        else {
          println("complete tutorial first");
        }
      }
    }
  }


  class ProfileButton extends RippleCircleButton {
    protected float grow_speed = 0.9; // pixels / ms
    protected PImage icon = global.images.getImage("units/ben.png");
    protected boolean collapsing = false;

    ProfileButton() {
      super(width - Constants.profileButton_offset, height - Constants.profileButton_offset, 2 * Constants.profileButton_offset);
      this.message = "Profile";
      this.maxRippleDistance = (xf - xi) * Constants.profileButton_growfactor;
      this.text_size = 32;
      this.noStroke();
      this.setColors(color(170), color(1, 0), color(1, 0), color(60, 60, 20, 200), color(255));
      this.refreshColor();
    }

    @Override
    void update(int millis) {
      int timeElapsed = millis - this.lastUpdateTime;
      float pixelsMoved = timeElapsed * this.grow_speed;
      super.update(millis);
      float pixelsLeft = 0;
      if (this.collapsing) {
        if (this.hovered) {
          pixelsLeft = 4 * Constants.profileButton_offset * Constants.profileButton_growfactor - (this.xf - this.xi);
          if (pixelsLeft < pixelsMoved) {
            this.collapsing = false;
            this.refreshColor();
            pixelsMoved = pixelsLeft;
          }
          this.stretchButton(pixelsMoved, LEFT);
          this.stretchButton(pixelsMoved, UP);
        }
        else {
          pixelsMoved *= -1;
          pixelsLeft = 4 * Constants.profileButton_offset - (this.xf - this.xi);
          if (pixelsLeft > pixelsMoved) {
            this.collapsing = false;
            this.refreshColor();
            pixelsMoved = pixelsLeft;
          }
          this.stretchButton(pixelsMoved, LEFT);
          this.stretchButton(pixelsMoved, UP);
        }
      }
      imageMode(CENTER);
      image(this.icon, this.xCenter(), this.yCenter() - 0.2 * (this.yf - this.yi),
        0.4 * this.button_width(), 0.4 * this.button_height());
    }

    @Override
    void writeText() {
      if (this.show_message) {
        fill(this.color_text);
        textAlign(CENTER, TOP);
        textSize(this.text_size);
        if (this.adjust_for_text_descent) {
          text(this.message, this.xCenter(), this.yCenter() - textDescent());
        }
        else {
          text(this.message, this.xCenter(), this.yCenter());
        }
      }
    }

    void reset() {
      this.icon = global.images.getImage("units/ben.png");
      this.color_text = color(255);
      this.stretchButton(4 * Constants.profileButton_offset - (this.xf - this.xi), LEFT);
      this.stretchButton(4 * Constants.profileButton_offset - (this.yf - this.yi), UP);
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
      global.sounds.trigger_interface("interfaces/buttonOn3");
      this.icon = global.images.getImage("units/ben_whiteborder.png");
      this.collapsing = true;
      super.hover();
      this.show_message = true;
    }

    void dehover() {
      this.icon = global.images.getImage("units/ben.png");
      this.color_text = color(255);
      this.collapsing = true;
      super.dehover();
      this.show_message = false;
      this.clicked = false;
    }

    void click() {
      global.sounds.trigger_interface("interfaces/buttonClick5");
      this.icon = global.images.getImage("units/ben_blueborder.png");
      this.color_text = color(0, 0, 255);
      super.click();
    }

    void release() {
      this.icon = global.images.getImage("units/ben.png");
      this.color_text = color(255);
      super.release();
      if (this.hovered) {
        MainMenuInterface.this.viewProfile();
      }
      this.reset();
    }
  }


  class ProfileForm extends FormLNZ {
    ProfileForm() {
      super(0.5 * (width - Constants.profileForm_width), 0.5 * (height - Constants.profileForm_height),
        0.5 * (width + Constants.profileForm_width), 0.5 * (height + Constants.profileForm_height));
      this.setTitleText(global.profile.display_name);
      this.setTitleSize(18);
      this.setFieldCushion(0);
      this.color_background = color(180, 180, 250);
      this.color_header = color(90, 90, 200);

      SubmitFormField logout = new SubmitFormField("Logout");
      logout.button.setColors(color(180), color(190, 190, 240),
        color(140, 140, 190), color(90, 90, 140), color(0));

      this.addField(new SpacerFormField(20));
      this.addField(logout);
    }

    void submit() {
      MainMenuInterface.this.loadExistingProfile();
    }
  }


  class CreditsForm extends FormLNZ {
    CreditsForm() {
      super(0.5 * (width - Constants.creditsForm_width), 0.5 * (height - Constants.creditsForm_height),
        0.5 * (width + Constants.creditsForm_width), 0.5 * (height + Constants.creditsForm_height));
      this.setTitleText("Credits");
      this.setTitleSize(18);
      this.color_background = color(250, 180, 250);
      this.color_header = color(170, 30, 170);

      SubmitFormField submit = new SubmitFormField("  Ok  ");
      submit.button.setColors(color(220), color(240, 190, 240),
        color(190, 140, 190), color(140, 90, 140), color(0));
      this.addField(new SpacerFormField(0));
      this.addField(new TextBoxFormField(Constants.credits, 200));
      this.addField(submit);
    }
    void submit() {
      this.canceled = true;
    }
  }


  class LoadProfileForm extends FormLNZ {
    private ArrayList<Path> profiles;

    LoadProfileForm() {
      super(0.5 * (width - Constants.newProfileForm_width), 0.5 * (height - Constants.newProfileForm_height),
        0.5 * (width + Constants.newProfileForm_width), 0.5 * (height + Constants.newProfileForm_height));
      this.setTitleText("Load Profile");
      this.setTitleSize(18);
      this.setFieldCushion(0);
      this.color_background = color(250, 180, 180);
      this.color_header = color(180, 50, 50);

      RadiosFormField radios = new RadiosFormField("Choose a profile:");
      this.profiles = listFolders("data/profiles");
      if (this.profiles.size() == 0) {
        MainMenuInterface.this.createNewProfile();
      }
      for (Path p : this.profiles) {
        radios.addRadio(p.getFileName().toString() + "  ");
      }
      MessageFormField error = new MessageFormField("");
      error.text_color = color(150, 20, 20);
      error.setTextSize(18);
      CheckboxFormField checkbox = new CheckboxFormField("Save as default profile  ");
      checkbox.setTextSize(16);
      checkbox.checkbox.checked = true;
      SubmitFormField submit = new SubmitFormField("Play Profile");
      submit.button.setColors(color(180), color(240, 190, 190),
        color(190, 140, 140), color(140, 90, 90), color(0));
      ButtonFormField newProfileButton = new ButtonFormField("Create New Profile");
      newProfileButton.button.setColors(color(180), color(240, 190, 190),
        color(190, 140, 140), color(140, 90, 90), color(0));

      this.addField(new SpacerFormField(20));
      this.addField(radios);
      this.addField(error);
      this.addField(new SpacerFormField(20));
      this.addField(checkbox);
      this.addField(new SpacerFormField(8));
      this.addField(submit);
      this.addField(new SpacerFormField(20));
      this.addField(newProfileButton);
    }

    void submit() {
      String profileIndex = this.fields.get(1).getValue();
      if (!isInt(profileIndex)) {
        this.fields.get(2).setValue("Select a profile to play");
        return;
      }
      int index = toInt(profileIndex);
      if (index < 0 || index >= this.profiles.size()) {
        this.fields.get(2).setValue("Select a profile to play");
        return;
      }
      String profileName = this.profiles.get(index).getFileName().toString();
      if (MainMenuInterface.this.loadProfile(profileName)) {
        this.canceled = true;
        if (this.fields.get(4).getValue().equals("true")) {
          global.configuration.default_profile_name = profileName;
          global.configuration.save();
        }
      }
      else {
        this.fields.get(2).setValue("There was an error opening the profile");
      }
    }

    @Override
    void cancel() {
      this.fields.get(2).setValue("You must select a profile");
    }

    @Override
    void buttonPress(int i) {
      MainMenuInterface.this.createNewProfile();
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
      checkbox.checkbox.checked = true;
      SubmitFormField submit = new SubmitFormField("Create New Profile");
      submit.button.setColors(color(180), color(240, 190, 190),
        color(190, 140, 140), color(140, 90, 90), color(0));
      ButtonFormField loadProfileButton = new ButtonFormField("Load Existing Profile");
      loadProfileButton.button.setColors(color(180), color(240, 190, 190),
        color(190, 140, 140), color(140, 90, 90), color(0));
      ArrayList<Path> profiles = listFolders("data/profiles");
      if (profiles.size() == 0) {
        loadProfileButton.button.disabled = true;
      }

      this.addField(new SpacerFormField(20));
      this.addField(input);
      this.addField(error);
      this.addField(new SpacerFormField(20));
      this.addField(checkbox);
      this.addField(new SpacerFormField(8));
      this.addField(submit);
      this.addField(new SpacerFormField(20));
      this.addField(loadProfileButton);
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
            global.configuration.default_profile_name = possibleProfileName;
            global.configuration.save();
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

    @Override
    void buttonPress(int i) {
      MainMenuInterface.this.loadExistingProfile();
    }
  }


  class BackgroundImageThread extends Thread {
    private PImage img = createImage(width, height, ARGB);
    private float distance_threshhold = 150;
    private float mX = mouseX;
    private float mY = mouseY;

    BackgroundImageThread() {
      super("BackgroundImageThread");
    }

    @Override
    void run() {
      DImg dimg = new DImg(this.img);
      //dimg.brightenGradient(0.02, this.distance_threshhold, this.mX, this.mY);
      dimg.transparencyGradientFromPoint(this.mX, this.mY, this.distance_threshhold);
      this.img = dimg.img;
    }
  }


  private MainMenuGrowButton[] growButtons = new MainMenuGrowButton[5];
  private BannerButton banner = new BannerButton();
  private PlayButton play = new PlayButton();
  private ProfileButton profile = new ProfileButton();
  private PImage backgroundImagePicture;
  private PImage backgroundImage;
  private BackgroundImageThread thread = new BackgroundImageThread();

  MainMenuInterface() {
    super();
    this.backgroundImagePicture = resizeImage(global.images.getImage("hillary.png"), width, height);
    this.backgroundImage = createPImage(color(0), width, height);
    this.growButtons[0] = new MainMenuGrowButton1();
    this.growButtons[1] = new MainMenuGrowButton2();
    this.growButtons[2] = new MainMenuGrowButton3();
    this.growButtons[3] = new MainMenuGrowButton4();
    this.growButtons[4] = new MainMenuGrowButton5();
    if (global.profile == null) {
      this.loadProfile();
    }
    this.thread.start();
  }

  void loadProfile() {
    ArrayList<Path> profiles = listFolders("data/profiles");
    for (Path p : profiles) {
      if (global.configuration.default_profile_name.toLowerCase().equals(p.getFileName().toString().toLowerCase())) {
        if (!loadProfile(global.configuration.default_profile_name)) {
          break;
        }
        return;
      }
    }
    if (profiles.size() > 0) {
      this.form = new LoadProfileForm();
    }
    else {
      this.createNewProfile();
    }
  }
  // returns true if profile loaded
  boolean loadProfile(String profile_name) {
    mkdir("data/profiles", false, true);
    if (!folderExists("data/profiles/" + profile_name.toLowerCase())) {
      global.log("Profile: No profile folder exists with name " + profile_name + ".");
      return false;
    }
    if (!fileExists("data/profiles/" + profile_name.toLowerCase() + "/profile.lnz")) {
      global.errorMessage("ERROR: Profile file missing for " + profile_name + ".");
      return false;
    }
    global.profile = readProfile(sketchPath("data/profiles/" + profile_name.toLowerCase()));
    return true;
  }
  // create new profile
  void createNewProfile() {
    this.form = new NewProfileForm();
  }
  // load profile
  void loadExistingProfile() {
    this.form = new LoadProfileForm();
  }
  // Open profile
  void viewProfile() {
    this.form = new ProfileForm();
  }

  Hero getCurrentHeroIfExists() {
    return null;
  }

  void update(int millis) {
    // draw background
    imageMode(CORNER);
    image(this.backgroundImagePicture, 0, 0);
    image(this.backgroundImage, 0, 0);
    // update elements
    for (MainMenuGrowButton button : this.growButtons) {
      button.update(millis);
    }
    this.banner.update(millis);
    this.play.update(millis);
    this.profile.update(millis);
    // restart thread
    if (!this.thread.isAlive()) {
      this.backgroundImage = this.thread.img;
      this.thread = new BackgroundImageThread();
      this.thread.start();
    }
  }

  void showNerdStats() {
    fill(255);
    textSize(14);
    textAlign(LEFT, TOP);
    float y_stats = 1;
    float line_height = textAscent() + textDescent() + 2;
    text("FPS: " + int(global.lastFPS), 1, y_stats);
  }

  void mouseMove(float mX, float mY) {
    for (MainMenuGrowButton button : this.growButtons) {
      button.mouseMove(mX, mY);
    }
    this.banner.mouseMove(mX, mY);
    this.play.mouseMove(mX, mY);
    this.profile.mouseMove(mX, mY);
  }

  void mousePress() {
    for (MainMenuGrowButton button : this.growButtons) {
      button.mousePress();
    }
    this.banner.mousePress();
    this.play.mousePress();
    this.profile.mousePress();
  }

  void mouseRelease(float mX, float mY) {
    for (MainMenuGrowButton button : this.growButtons) {
      button.mouseRelease(mX, mY);
    }
    this.banner.mouseRelease(mX, mY);
    this.play.mouseRelease(mX, mY);
    this.profile.mouseRelease(mX, mY);
  }

  void scroll(int amount) {}
  void keyPress() {}
  void openEscForm() {}
  void keyRelease() {}


  void loseFocus() {}
  void gainFocus() {}
  void restartTimers() {}
  void saveAndExitToMainMenu() {}
}
