SceneManager sceneManager;
int MAINMENU_SCENE_INDEX = 0;
int EDITOR_SCENE_INDEX = 1;
void setup() {
  fullScreen();
  sceneManager = new SceneManager(new MainMenuScene(), new EditorScene());
  sceneManager.SwitchSceneTo(MAINMENU_SCENE_INDEX, false, false);
}

void draw() {
  sceneManager.Display();
  sceneManager.Update();
}
