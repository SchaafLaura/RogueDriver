class MainMenuScene extends Scene {
  PImage bg;

  MainMenuScene() {
    bg = loadImage("bg_mainmenu.png");
    bg.resize(width, height);
    var mainMenuUI = new TLMUI();

    Button levelSelectOnline = new Button(
      "Online Levels",
      new Rectangle(width/2-100, height/2, 200, 50),
      () -> {
      noLoop();
      sceneManager.Load(MAPSELECTIONONLINE_SCENE_INDEX, false, true);
      loop();
    }
    );

    Button levelSelectLocal = new Button(
      "Select Level",
      new Rectangle(width/2-100, height/2 + 100, 200, 50),
      () -> {  // switch Scene to LevelSelect
      noLoop();
      sceneManager.Load(MAPSELECTIONLOCAL_SCENE_INDEX, false, true);
      loop();
    }
    );

    Button editor = new Button(
      "Editor",
      new Rectangle(width/2-100, height/2 + 200, 200, 50),
      () -> {    // switch Scene to Editor
      ((EditorScene)sceneManager.scenes[EDITOR_SCENE_INDEX]).SetupDefaultMap();
      sceneManager.Load(EDITOR_SCENE_INDEX, false, true);
    }
    );

    Button quit = new Button(
      "Quit",
      new Rectangle(width/2-100, height/2 + 300, 200, 50),
      () -> {
      exit();
    }
    );

    mainMenuUI.AddChild(levelSelectOnline);
    mainMenuUI.AddChild(levelSelectLocal);
    mainMenuUI.AddChild(editor);
    mainMenuUI.AddChild(quit);

    this.SetUI(mainMenuUI);
  }

  public void mouseEvent(MouseEvent e) {
  }
  public void keyEvent(KeyEvent e) {
  }
  void Update() {
  }
  void Display() {
    image(bg, 0, 0);
  }
  void Load() {
  }
  void Unload() {
  }
}
