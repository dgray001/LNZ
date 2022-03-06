class Profile {
  private String display_name = "";
  private String save_file_name = "";

  Profile() {
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
      default:
        break;
    }
  }
  return p;
}
