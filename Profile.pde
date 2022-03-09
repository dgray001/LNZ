class Profile {
  private String display_name = "";
  private HashMap<Achievement, Boolean> achievements = new HashMap<Achievement, Boolean>();
  private int achievement_tokens = 0;

  Profile() {
    this("");
  }
  Profile(String s) {
    this.display_name = s;
    for (Achievement a : Achievement.VALUES) {
      this.achievements.put(a, false);
    }
  }

  void save() {
    PrintWriter file = createWriter(sketchPath("data/profiles/" + this.display_name.toLowerCase() + "/profile.lnz"));
    file.println("display_name: " + this.display_name);
    for (Achievement a : Achievement.VALUES) {
      if (this.achievements.get(a)) {
        file.println("achievement: " + a.display_name());
      }
    }
    file.println("achievement_tokens: " + this.achievement_tokens);
    file.flush();
    file.close();
  }
}


Profile readProfile(String path) {
  String[] lines = loadStrings(path);
  Profile p = new Profile();
  if (lines == null) {
    println("ERROR: Reading profile file but path " + path + " doesn't exist.");
    return p;
  }
  for (String line : lines) {
    String[] data = split(line, ':');
    if (data.length < 2) {
      continue;
    }
    switch(data[0]) {
      case "display_name":
        p.display_name = trim(data[1]);
        break;
      case "achievement":
        for (Achievement a : Achievement.VALUES) {
          if (a.display_name().equals(trim(data[1]))) {
            p.achievements.put(a, true);
            break;
          }
        }
        break;
      case "achievement_tokens":
        if (isInt(trim(data[1]))) {
          p.achievement_tokens = toInt(trim(data[1]));
        }
        break;
      default:
        break;
    }
  }
  return p;
}


int isValidProfileName(String s) {
  if (s == null) {
    return 1;
  }
  else if (s.equals("")) {
    return 1;
  }
  for (int i = 0; i < s.length(); i++) {
    char c = s.charAt(i);
    if (i == 0 && !Character.isLetter(c)) {
      return 2;
    }
    else if (!Character.isLetterOrDigit(c)) {
      return 3;
    }
  }
  for (Path p : listEntries(sketchPath("data/profiles/"))) {
    String filename = p.getFileName().toString().toLowerCase();
    if (filename.equals(s.toLowerCase())) {
      return 4;
    }
  }
  return 0;
}
