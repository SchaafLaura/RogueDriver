void setup() {
  fullScreen();
  smooth(0);
  gameManager = new GameManager();
  sceneManager = new SceneManager(new MainMenuScene(), new EditorScene(), new GameScene(), new HighscoreScene());
  sceneManager.SwitchSceneTo(MAINMENU_SCENE_INDEX, false, false);
}

void draw() {
  sceneManager.Display();
  sceneManager.Update();
  if (mousePressed)
    sceneManager.HandleInput();
  text(frameRate, width-100, 100);
}
