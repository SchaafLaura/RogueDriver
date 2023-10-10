class MainMenuScene extends Scene {
  Button levelSelect;
  Button editor;
  Button quit;

  PImage bg = loadImage("bg.png");
  PImage test = loadImage("car.png");

  Button[] buttons;

  MainMenuScene() {
    buttons = new Button[3];

    Button levelSelect = new Button(
      "Select Level",
      new Rectangle(width/2-100, height/2, 200, 50),
      () -> {  // switch Scene to LevelSelect
      noLoop();
      selectInput("Select a track to edit:", "LoadTrack");
      sceneManager.SwitchSceneTo(GAME_SCENE_INDEX, false, true);
    }
    );


    Button editor = new Button(
      "Editor",
      new Rectangle(width/2-100, height/2 + 100, 200, 50),
      () -> {    // switch Scene to Editor
      sceneManager.SwitchSceneTo(EDITOR_SCENE_INDEX, false, false);
    }
    );

    Button quit = new Button(
      "Quit",
      new Rectangle(width/2-100, height/2 + 200, 200, 50),
      () -> {
      exit();
    }
    );

    buttons[0] = levelSelect;
    buttons[1] = editor;
    buttons[2] = quit;
  }

  void Update() {
    for (var b : buttons)
      b.TryClick();
  }
  void Display() {
    image(bg, 0, 0);
    for (var b : buttons)
      b.Display();
    colorMode(HSB);
    tint(frameCount%255, 255,255);
    image(test,10,10,64,64);
    noTint();
    
    colorMode(RGB);
  }
  void HandleInput() {
  }
  void Load() {
  }
  void Unload() {
  }
}
