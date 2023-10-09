class HighscoreScene extends Scene {
  String name = "";
  int score = -1;

  IntDict highscoreDict;

  void Update() {
    if (score > 0)
      return;

    int s = ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).player.stepsTaken;
    score = s;
  }
  void Display() {
    background(0);
    if (highscoreDict != null)
      DisplayHighScores();
    else
      DisplayNameInput();
  }
  void DisplayHighScores() {
    var names = highscoreDict.keyArray();
    var scores = highscoreDict.valueArray();

    textAlign(CENTER, CENTER);
    for (int i = 0; i < names.length; i++) {
      text(names[i] + " - " + scores[i], width/2, (i+1) * 50);
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
    var names = highscoreDict.keyArray();
    var scores = highscoreDict.valueArray();

    for (int i = 0; i < names.length; i++) {
      pw.println(names[i] + " " + scores[i]);
    }
    pw.flush();
    pw.close();
  }

  void SetHighScoreTableFromStrings(String[] strings) {
    highscoreDict = new IntDict();
    if (strings != null) {
      for (var s : strings) {
        var split = s.split(" ");
        highscoreDict.set(split[0], Integer.parseInt(split[1]));
      }
    }
    highscoreDict.set(name, score);
    highscoreDict.sortValues();
  }


  void HandleInput() {
    if (keyCode == ENTER && name.length() > 0) {
      WriteHighScoreToFile();
    }

    if ((keyCode == BACKSPACE && name.length() == 1) || (keyCode == BACKSPACE && name.length() == 0)) {
      name = "";
    } else if (keyCode == BACKSPACE && name.length() > 0) {
      name = name.substring(0, name.length() - 1);
    } else if (keyPressed && ((key <= 'z' && key >= 'A'))) {
      name += (char)key;
    }

    if (escDown && name != "" && highscoreDict != null) {
      name = "";
      score = -1;
      highscoreDict = null;
      sceneManager.SwitchSceneTo(MAINMENU_SCENE_INDEX, false, false);
      return;
    }
  }
  void Load() {
  }
  void Unload() {
  }
}
