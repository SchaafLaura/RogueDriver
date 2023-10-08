SceneManager sceneManager;
int MAINMENU_SCENE_INDEX = 0;
int EDITOR_SCENE_INDEX = 1;
int GAME_SCENE_INDEX = 2;

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


void keyPressed() {
  if (sceneManager.activeScene == EDITOR_SCENE_INDEX && key == 's')
    selectOutput("Select a file to write to:", "SaveMap");

  if (sceneManager.activeScene == EDITOR_SCENE_INDEX && key == 'l')
    selectInput("Select a track to edit:", "LoadTrack");
}
