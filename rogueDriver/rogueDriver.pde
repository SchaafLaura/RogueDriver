SceneManager sceneManager;
int MAINMENU_SCENE_INDEX = 0;
int EDITOR_SCENE_INDEX = 1;
int GAME_SCENE_INDEX = 2;

char ESC_CHAR = (char) -1;

void setup() {
  size(1000, 1000);
  sceneManager = new SceneManager(new MainMenuScene(), new EditorScene(), new GameScene());
  sceneManager.SwitchSceneTo(MAINMENU_SCENE_INDEX, false, false);
}

void draw() {
  sceneManager.HandleInput();
  sceneManager.Display();
  sceneManager.Update();
}
