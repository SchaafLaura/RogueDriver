class HighscoreScene extends Scene {
  String name = "";
  int score = -1;
  String replay;
  boolean written = false;
  ArrayList<HighscoreEntry> highscores;
  ArrayList<Button> driveAgainstButtons;

  void Update() {
    if (driveAgainstButtons != null)
      for (var b : driveAgainstButtons)
        b.TryClick();

    if (score != -1)
      return;
    else
      GetPlayerHighScoreAndReplay();
  }

  void GetPlayerHighScoreAndReplay() {
    score = ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).player.stepsTaken;
    replay = ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).player.history;
  }

  void Display() {

    background(0);
    if (highscores == null)
      DisplayNameInput();
    else
      DisplayHighScores();
  }
  void DisplayHighScores() {



    int i = 0;
    for (var h : highscores) {
      driveAgainstButtons.get(i).Display();
      textAlign(LEFT, CENTER);
      text(h.score + " - " + h.name, width/3, (i+1) * 50);

      i++;
    }
  }

  void DisplayNameInput() {
    background(0);
    textSize(30);
    fill(0, 255, 0);
    textAlign(CENTER, CENTER);
    text("SCORE: " + score, width/2, height/2 - 30);

    textAlign(LEFT, CENTER);
    text("Sign your name:", width/2 - 100, height/2 + 30);

    boolean cursorActive = frameCount % 20 < 10;
    String cursor = cursorActive ? "|" : "";
    text(name+cursor, width/2 - 100, height/2 + 90);
  }

  void MatchAgainst(String matchReplay) {
    ArrayList<String> replays = new ArrayList<String>();
    replays.add(matchReplay);
    
    for(var h : highscores){
      replays.add(h.replay);
    }
    
    ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).SetupMatchAgainst(replays);
    sceneManager.SwitchSceneTo(GAME_SCENE_INDEX, false, false);

    name = "";
    score = -1;
    replay = "";
    highscores = new ArrayList<HighscoreEntry>();
    driveAgainstButtons = new ArrayList<Button>();
  }

  void MakeDriveAgainstButtons() {
    driveAgainstButtons = new ArrayList<Button>();
    for (int i = 0; i < highscores.size(); i++) {
      String replayToPlayAgainst = highscores.get(i).replay;
      Button b = new Button("Match", new Rectangle(width/3 + 300, (i) * 50 + 25, 100, 40), ()-> {
        MatchAgainst(replayToPlayAgainst);
      }
      );
      driveAgainstButtons.add(b);
    }
  }

  void HandleInput() {
    if (keyCode == ENTER && name.length() > 0 && !written) {
      WriteHighScoreToDB(name, replay, ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).map.Hash());
      GetHighScoresFromDB(((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).map.Hash());
      Collections.sort(highscores);
      Collections.reverse(highscores);
      MakeDriveAgainstButtons();
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
