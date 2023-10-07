SceneManager sceneManager;
int MAINMENU_SCENE_INDEX = 0;
void setup() {
  fullScreen();
  sceneManager = new SceneManager(new MainMenuScene());
  sceneManager.SwitchSceneTo(MAINMENU_SCENE_INDEX, false, false);
}

void draw() {
  sceneManager.Display();
  sceneManager.Update();
}
