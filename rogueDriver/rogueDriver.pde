SceneManager sceneManager;
int MAINMENU_SCENE_INDEX = 0;
int EDITOR_SCENE_INDEX = 1;
void setup() {
  size(1000, 1000);
  sceneManager = new SceneManager(new MainMenuScene(), new EditorScene());
  sceneManager.SwitchSceneTo(MAINMENU_SCENE_INDEX, false, false);
}

void draw() {
  sceneManager.HandleInput();
  sceneManager.Display();
  sceneManager.Update();
}

void keyPressed() {
  // gotta do this here for some reason :shrug:
  if (sceneManager.activeScene == EDITOR_SCENE_INDEX && key == 's') {
    selectOutput("Select a file to write to:", "SaveMap");
  }
}

void SaveMap(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
  }
}
