class HighscoreScene extends Scene {
  int playerScore = -1;
  String playerReplay;
  boolean writtenToDatabase = false;

  ArrayList<HighscoreEntry> highscores;
  UIContainer buttongroup;
  InputField nameInput;
  Button uploadButton;


  public void mouseEvent(MouseEvent e) {
  }
  public void keyEvent(KeyEvent e) {
    if (e.getAction() != KeyEvent.PRESS)
      return;

    if (keyCode == ENTER && nameInput.value.length() > 0 && !writtenToDatabase) {
      WriteHighScoreToDB(nameInput.value, playerReplay, ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).map.Hash());
      highscores = GetHighScoresFromDB(((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).map.Hash());
      Collections.sort(highscores);
      Collections.reverse(highscores);
      MakeDriveAgainstButtons();
      writtenToDatabase = true;
      nameInput.SetVisible(false);
      uploadButton.SetVisible(false);
    }

    if (escDown && nameInput.value != "" && highscores != null) {
      nameInput.value = "";
      playerScore = -1;
      highscores = null;
      sceneManager.Load(MAINMENU_SCENE_INDEX, false, false);
      writtenToDatabase = false;
      return;
    }
  }

  void Display() {
    background(0);
    if (highscores != null)
      DisplayHighScores();
  }

  void DisplayHighScores() {
    int i = 0;
    for (var h : highscores) {
      textAlign(LEFT, CENTER);
      text(h.score + " - " + h.name, width/3, (i+1) * 50);
      i++;
    }
  }


  void Update() {
    if (playerScore != -1)
      return;
    else {
      GetPlayerHighScoreAndReplay();
    }
  }

  void GetPlayerHighScoreAndReplay() {
    playerScore = ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).player.stepsTaken;
    playerReplay = ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).player.history;
  }

  void MakeDriveAgainstButtons() {

    buttongroup = new UIContainer();

    for (int i = 0; i < highscores.size(); i++) {
      String replayToPlayAgainst = highscores.get(i).replay;
      Button b = new Button("Match", new Rectangle(width/3 + 300, (i) * 50 + 25, 100, 40), ()-> {
        MatchAgainst(replayToPlayAgainst);
      }
      );
      buttongroup.AddChild(b);
    }
    ui.AddChild(buttongroup);
  }

  void MatchAgainst(String matchReplay) {
    ArrayList<String> replays = new ArrayList<String>();
    replays.add(matchReplay);

    for (var h : highscores) {
      replays.add(h.replay);
    }

    ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).SetupMatchAgainst(replays);
    sceneManager.Load(GAME_SCENE_INDEX, false, false);

    nameInput.value = "";
    playerScore = -1;
    playerReplay = "";
    highscores = null;
    ui.root.RemoveChild(buttongroup);
    buttongroup = null;
    writtenToDatabase = false;
  }



  void Load() {
    var highscoreUI = new TLMUI();
    nameInput = new InputField(
      "yourNameHere",
      "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789ß-_#+~*?()%$§!@€µ<>|²³{[]}",
      new Rectangle(width/2-150, height/2, 300, 60));



    uploadButton = new Button(
      "Upload Highscore",
      new Rectangle(width/2-150, height/2+100, 300, 60),
      ()-> {
      WriteHighScoreToDB(nameInput.value, playerReplay, ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).map.Hash());
      highscores = GetHighScoresFromDB(((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).map.Hash());
      Collections.sort(highscores);
      Collections.reverse(highscores);
      MakeDriveAgainstButtons();
      writtenToDatabase = true;
      nameInput.SetVisible(false);
      uploadButton.SetVisible(false);
    }
    );


    highscoreUI.AddChild(nameInput);
    highscoreUI.AddChild(uploadButton);
    SetUI(highscoreUI);
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
