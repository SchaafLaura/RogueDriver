class HighscoreScene extends Scene {
  String playerName = "";
  int playerScore = -1;
  String playerReplay;
  boolean writtenToDatabase = false;

  ArrayList<HighscoreEntry> highscores;
  //ArrayList<Button> driveAgainstButtons;


  public void mouseEvent(MouseEvent e) {
  }
  public void keyEvent(KeyEvent e) {
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
     //      driveAgainstButtons.get(i).Display();
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
    text("SCORE: " + playerScore, width/2, height/2 - 30);

    textAlign(LEFT, CENTER);
    text("Sign your name:", width/2 - 100, height/2 + 30);

    boolean cursorActive = frameCount % 20 < 10;
    String cursor = cursorActive ? "|" : "";
    text(playerName+cursor, width/2 - 100, height/2 + 90);
  }


  void Update() {
    if (playerScore != -1)
      return;
    else
      GetPlayerHighScoreAndReplay();
  }

  void GetPlayerHighScoreAndReplay() {
    playerScore = ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).player.stepsTaken;
    playerReplay = ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).player.history;
  }

  void MakeDriveAgainstButtons() {
    /*
    driveAgainstButtons = new ArrayList<Button>();
    for (int i = 0; i < highscores.size(); i++) {
      String replayToPlayAgainst = highscores.get(i).replay;
      Button b = new Button("Match", new Rectangle(width/3 + 300, (i) * 50 + 25, 100, 40), ()-> {
        MatchAgainst(replayToPlayAgainst);
      }
      );
      driveAgainstButtons.add(b);
    }
    */
  }

  void MatchAgainst(String matchReplay) {
    ArrayList<String> replays = new ArrayList<String>();
    replays.add(matchReplay);

    for (var h : highscores) {
      replays.add(h.replay);
    }

    ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).SetupMatchAgainst(replays);
    sceneManager.Load(GAME_SCENE_INDEX, false, false);

    playerName = "";
    playerScore = -1;
    playerReplay = "";
    highscores = null;
    //     driveAgainstButtons = null;
    writtenToDatabase = false;
  }

/*
  void HandleInput() {
    
    if (driveAgainstButtons != null)
      for (var b : driveAgainstButtons)
        b.TryClick();



    if (keyCode == ENTER && playerName.length() > 0 && !writtenToDatabase) {
      WriteHighScoreToDB(playerName, playerReplay, ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).map.Hash());
      highscores = GetHighScoresFromDB(((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).map.Hash());
      Collections.sort(highscores);
      Collections.reverse(highscores);
      MakeDriveAgainstButtons();
      writtenToDatabase = true;
    }

    if ((keyCode == BACKSPACE && playerName.length() == 1) || (keyCode == BACKSPACE && playerName.length() == 0)) {
      playerName = "";
    } else if (keyCode == BACKSPACE && playerName.length() > 0) {
      playerName = playerName.substring(0, playerName.length() - 1);
    } else if (keyPressed && ((key <= 'z' && key >= 'A'))) {
      playerName += (char)key;
    }

    if (escDown && playerName != "" && highscores != null) {
      playerName = "";
      playerScore = -1;
      highscores = null;
      sceneManager.Load(MAINMENU_SCENE_INDEX, false, false);
      writtenToDatabase = false;
      return;
    }
  }
  */

  void Load() {
  }
  void Unload() {
  }
  /*
  void HandleMouseWheel(float turn) {
  }
  */
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
