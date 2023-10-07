class MainMenuScene extends Scene {
  Button levelSelect;
  Button editor;
  Button quit;

  Button[] buttons;

  MainMenuScene() {
    buttons = new Button[3];

    Button levelSelect = new Button(
      "Select Level",
      new Rectangle(width/2-100, height/2, 200, 50),
      () -> {  // switch Scene to LevelSelect
    }
    );


    Button editor = new Button(
      "Editor",
      new Rectangle(width/2-100, height/2 + 100, 200, 50),
      () -> {    // switch Scene to Editor
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
    background(0);
    for (var b : buttons)
      b.Display();
  }
  void HandleInput() {
  }
  void Load() {
  }
  void Unload() {
  }
}
