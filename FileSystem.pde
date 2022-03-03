// default to if file does not exist create file
void mkFile(String path) {
  mkFile(path, false);
}
void mkFile(String path, boolean replace) {
  Path p = Paths.get(sketchPath(path));
  if (!Files.exists(p)) {
    try {
      Files.createFile(p);
    } catch (IOException e) {
      println("ERROR: IOException at mkFile(" + path + ")");
    }
  }
  else if (replace && !Files.isDirectory(p)) {
    deleteFile(path);
    try {
      Files.createFile(p);
    } catch (IOException e) {
      println("ERROR: IOException at mkFile(" + path + ")");
    }
  }
}

// delete file
void deleteFile(String path) {
  deleteFile(Paths.get(sketchPath(path)));
}
void deleteFile(Path p) {
  try {
    Files.deleteIfExists(p);
  } catch(IOException e) {
    println("ERROR: IOException at deleteFile(" + p + ")");
  }
}

// list all entries in directory
ArrayList<Path> listEntries(String path) {
  return listEntries(Paths.get(sketchPath(path)));
}
ArrayList<Path> listEntries(Path p) {
  ArrayList<Path> entries = new ArrayList<Path>();
  try {
    if (Files.isDirectory(p)) {
      Files.list(p).forEach(entry -> entries.add(entry));
    }
    else {
      println("ERROR: Not a directory at listEntries(" + p + ")");
    }
  } catch(IOException e) {
    println("ERROR: IOException at listEntries(" + p + ")");
  }
  return entries;
}

// list all files in directory
ArrayList<Path> listFiles(String path) {
  return listFiles(Paths.get(sketchPath(path)));
}
ArrayList<Path> listFiles(Path p) {
  ArrayList<Path> files = listEntries(p);
  for (int i = 0; i < files.size(); i++) {
    if (Files.isDirectory(files.get(i))) {
      files.remove(i);
      i--;
    }
  }
  return files;
}

// list all folder in directory
ArrayList<Path> listFolders(String path) {
  return listFolders(Paths.get(sketchPath(path)));
}
ArrayList<Path> listFolders(Path p) {
  ArrayList<Path> folders = listEntries(p);
  for (int i = 0; i < folders.size(); i++) {
    if (!Files.isDirectory(folders.get(i))) {
      folders.remove(i);
      i--;
    }
  }
  return folders;
}

// default to if folder does not exist create folder
void mkdir(String path) {
  mkdir(path, false);
}
void mkdir(String path, boolean replace) {
  Path p = Paths.get(sketchPath(path));
  if (!Files.exists(p)) {
    try {
      Files.createDirectory(p);
    } catch (IOException e) {
      println("ERROR: IOException at mkdir(" + path + ")");
    }
  }
  else if (replace && Files.isDirectory(p)) {
    deleteFolder(path);
    try {
      Files.createDirectory(p);
    } catch (IOException e) {
      println("ERROR: IOException at mkdir(" + path + ")");
    }
  }
}

// recursively deletes folder
void deleteFolder(String path) {
  deleteFolder(Paths.get(sketchPath(path)));
}
void deleteFolder(Path p) {
  if (Files.isDirectory(p)) {
    for (Path filePath : listFiles(p)) {
      deleteFile(filePath);
    }
    for (Path folderPath : listFolders(p)) {
      deleteFolder(folderPath);
    }
    try {
      Files.delete(p);
    } catch(IOException e) {
      println("ERROR: IOException at deleteFolder(" + p + ")");
    }
  }
  else {
    deleteFile(p);
  }
}
