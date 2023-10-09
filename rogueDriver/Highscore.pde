class HighscoreScene extends Scene {
  String name = "";
  int score = -1;
  String replay;
  boolean written = false;

  ArrayList<HighscoreEntry> highscores;

  void Update() {
    if (score > 0)
      return;

    score = ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).player.stepsTaken;
    replay = ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).player.history;
  }
  void Display() {
    background(0);
    if (highscores != null)
      DisplayHighScores();
    else
      DisplayNameInput();
  }
  void DisplayHighScores() {
    textAlign(CENTER, CENTER);
    int i = 0;
    for (var h : highscores) {
      text(h.score + " - " + h.name, width/2, (i+1) * 50);
      i++;
    }
  }

  void DisplayNameInput() {
    background(0);
    textSize(30);
    fill(0, 255, 0);
    textAlign(CENTER, CENTER);
    text("SCORE: " + score, width/2, height/2 - 30);
    text("Sign your name:", width/2, height/2 + 30);
    text(name, width/2, height/2 + 60);
  }

  void WriteHighScoreToFile() {
    String path = ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).map.absolutePath;
    path = path.substring(0, path.length() - 3);
    path += "txt";
    String[] lines = loadStrings(path);
    if (lines == null) {
      println(path + " not found. creating...");
      PrintWriter pw = createWriter(path);
      pw.flush();
      pw.close();
      WriteHighScoreToFile();
    } else {
      println("found");
    }
    SetHighScoreTableFromStrings(lines);
    WriteTableToFile(path);
  }

  void WriteTableToFile(String path) {
    PrintWriter pw = createWriter(path);
    for (var h : highscores)
      pw.println(h.name + " " + h.replay);

    pw.flush();
    pw.close();
  }

  void SetHighScoreTableFromStrings(String[] strings) {
    highscores = new ArrayList<HighscoreEntry>();

    if (strings != null) {
      for (var s : strings) {
        var split = s.split(" ");
        highscores.add(new HighscoreEntry(split[0], split[1]));
      }
    }
    highscores.add(new HighscoreEntry(name, replay));

    Collections.sort(highscores);
    Collections.reverse(highscores);
  }


  void HandleInput() {
    if (keyCode == ENTER && name.length() > 0 && !written) {
      WriteHighScoreToFile();
      written = true;
    }

    if ((keyCode == BACKSPACE && name.length() == 1) || (keyCode == BACKSPACE && name.length() == 0)) {
      name = "";
    } else if (keyCode == BACKSPACE && name.length() > 0) {
      name = name.substring(0, name.length() - 1);
    } else if (keyPressed && ((key <= 'z' && key >= 'A'))) {
      name += (char)key;
    }

    if (escDown && name != "" && highscores != null) {
      name = "";
      score = -1;
      highscores = null;
      sceneManager.SwitchSceneTo(MAINMENU_SCENE_INDEX, false, false);
      written = false;
      return;
    }
  }
  void Load() {
  }
  void Unload() {
  }
}

class HighscoreEntry implements Comparable {
  String name;
  String replay;
  int score;

  int compareTo(Object other) {
    if (!(other instanceof HighscoreEntry))
      return 0;
    return ((HighscoreEntry)other).score > score ? 1 : -1;
  }

  HighscoreEntry(String name, String replay) {
    this.name = name;
    this.replay = replay;
    score = replay.length();
  }
}
