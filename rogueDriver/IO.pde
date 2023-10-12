void LoadTrack(File fileSelected) {
  if (fileSelected == null) {
    println("Window was closed or the user hit cancel.");
    loop();
    return;
  } else {
    println("User selected " + fileSelected.getAbsolutePath());
  }
  PImage img = loadImage(fileSelected.getAbsolutePath());
  String name = fileSelected.getName();
  name = name.substring(0, name.length() - 4);

  if (sceneManager.activeScene == EDITOR_SCENE_INDEX) {
    ((EditorScene)sceneManager.scenes[EDITOR_SCENE_INDEX]).map.tiles = ImgToData(img);
    ((EditorScene)sceneManager.scenes[EDITOR_SCENE_INDEX]).map.absolutePath = fileSelected.getAbsolutePath();
    ((EditorScene)sceneManager.scenes[EDITOR_SCENE_INDEX]).map.name = name;
    ((EditorScene)sceneManager.scenes[EDITOR_SCENE_INDEX]).map.NX = img.width;
    ((EditorScene)sceneManager.scenes[EDITOR_SCENE_INDEX]).map.NY = img.height;
  }
  if (sceneManager.activeScene == GAME_SCENE_INDEX) {
    ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).LoadMap(new Map(ImgToData(img)));
    ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).map.absolutePath = fileSelected.getAbsolutePath();
    ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).map.name = name;
    ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).map.NX = img.width;
    ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).map.NY = img.height;
  }

  loop();
}

int[][] ImgToData(PImage img) {
  color[] colors = ((EditorScene)sceneManager.scenes[EDITOR_SCENE_INDEX]).mapDisplay.colors;
  HashMap<Integer, Integer> colorsToIndices = new HashMap<Integer, Integer>();
  for (int i = 0; i < colors.length; i++) {
    colorsToIndices.put(colors[i], i);
  }

  int[][] ret = new int[img.width][img.height];
  for (int i = 0; i < img.width; i++) {
    for (int j = 0; j < img.height; j++) {
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

  color[] colors = ((EditorScene)sceneManager.scenes[EDITOR_SCENE_INDEX]).mapDisplay.colors;

  ret.loadPixels();
  for (int i = 0; i < data.length; i++) {
    for (int j = 0; j < data[0].length; j++) {
      ret.pixels[i + j * data.length] = colors[data[i][j]];
    }
  }

  ret.updatePixels();
  return ret;
}
