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
    return;
  } else {
    println("User selected " + selection.getAbsolutePath());
  }

  // get current map
  int[][] mapData = ((EditorScene)sceneManager.scenes[sceneManager.activeScene]).map.tiles;

  // create Picture from mapData
  PImage mapImg = DataToImage(mapData);
  mapImg.save(selection.getAbsolutePath() + ".png");
}

PImage DataToImage(int[][] data) {
  PImage ret = createImage(data.length, data[0].length, RGB);

  color[] colors = ((EditorScene)sceneManager.scenes[sceneManager.activeScene]).map.colors;

  ret.loadPixels();
  for (int i = 0; i < data.length; i++) {
    for (int j = 0; j < data[0].length; j++) {
      ret.pixels[i + j * data.length] = colors[data[i][j]];
    }
  }

  ret.updatePixels();
  return ret;
}
