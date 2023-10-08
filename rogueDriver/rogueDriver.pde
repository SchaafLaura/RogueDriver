SceneManager sceneManager;
int MAINMENU_SCENE_INDEX = 0;
int EDITOR_SCENE_INDEX = 1;
void setup() {
  size(1000, 1000);
  sceneManager = new SceneManager(new MainMenuScene(), new EditorScene());
  sceneManager.SwitchSceneTo(MAINMENU_SCENE_INDEX, false, false);
}

void draw() {

  sceneManager.Display();
  sceneManager.Update();
}

void keyReleased() {
}

void keyPressed() {

  sceneManager.HandleInput();
  // gotta do this here for some reason :shrug:
  if (sceneManager.activeScene == EDITOR_SCENE_INDEX && key == 's') {
    selectOutput("Select a file to write to:", "SaveMap");
  }
  if (sceneManager.activeScene == EDITOR_SCENE_INDEX && key == 'l') {
    selectInput("Select a track to edit:", "LoadTrack");
  }
}

void LoadTrack(File fileSelected) {
  if (fileSelected == null) {
    println("Window was closed or the user hit cancel.");
    loop();
    return;
  } else {
    println("User selected " + fileSelected.getAbsolutePath());
  }
  PImage img = loadImage(fileSelected.getAbsolutePath());
  ((EditorScene)sceneManager.scenes[EDITOR_SCENE_INDEX]).map.tiles = ImgToData(img);
  loop();
}

int[][] ImgToData(PImage img) {
  color[] colors = ((EditorScene)sceneManager.scenes[sceneManager.activeScene]).map.colors;
  HashMap<Integer, Integer> colorsToIndices = new HashMap<Integer, Integer>();
  for (int i = 0; i < colors.length; i++) {
    colorsToIndices.put(colors[i], i);
  }

  int[][] ret = new int[img.width][img.height];
  for (int i = 0; i < img.width; i++) {
    for (int j = 0; j < img.height; j++) {
      //println(img.get(i, j));
      ret[i][j] = colorsToIndices.get(img.get(i, j));
    }
  }
  return ret;
}

void SaveMap(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    loop();
    return;
  } else {
    println("User selected " + selection.getAbsolutePath());
  }

  // get current map
  int[][] mapData = ((EditorScene)sceneManager.scenes[EDITOR_SCENE_INDEX]).map.tiles;

  // create Picture from mapData
  PImage mapImg = DataToImage(mapData);
  mapImg.save(selection.getAbsolutePath() + ".png");
  loop();
}

PImage DataToImage(int[][] data) {
  PImage ret = createImage(data.length, data[0].length, RGB);

  color[] colors = ((EditorScene)sceneManager.scenes[EDITOR_SCENE_INDEX]).map.colors;

  ret.loadPixels();
  for (int i = 0; i < data.length; i++) {
    for (int j = 0; j < data[0].length; j++) {
      ret.pixels[i + j * data.length] = colors[data[i][j]];
    }
  }

  ret.updatePixels();
  return ret;
}
