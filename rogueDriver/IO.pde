void LoadTrackToEditorAndSwitchScene(File fileSelected) {
  if (fileSelected == null) {
    println("Window was closed or the user hit cancel.");
    loop();
    return;
  } else {
    println("Loading map to edit: " + fileSelected.getAbsolutePath());
  }

  PImage img = loadImage(fileSelected.getAbsolutePath());
  String name = fileSelected.getName();
  name = name.substring(0, name.length() - 4);
  var editorScene = (EditorScene)sceneManager.scenes[EDITOR_SCENE_INDEX];
  editorScene.LoadMapFromTileData(ImgToTileData(img));
  editorScene.map.absolutePath = fileSelected.getAbsolutePath();
  editorScene.map.name = name;
  sceneManager.SwitchSceneTo(EDITOR_SCENE_INDEX, false, false);
  loop();
}


void LoadTrackToLevelAndSwitchScene(File fileSelected) {
  if (fileSelected == null) {
    println("Window was closed or the user hit cancel.");
    loop();
    return;
  } else {
    println("Loading map to play: " + fileSelected.getAbsolutePath());
  }

  PImage img = loadImage(fileSelected.getAbsolutePath());
  String name = fileSelected.getName();
  name = name.substring(0, name.length() - 4);
  var gameScene = (GameScene)sceneManager.scenes[GAME_SCENE_INDEX];
  gameScene.LoadMapFromTileData(ImgToTileData(img));
  gameScene.map.absolutePath = fileSelected.getAbsolutePath();
  gameScene.map.name = name;
  gameScene.SetupPlayerOnCurrentMap();
  sceneManager.SwitchSceneTo(GAME_SCENE_INDEX, false, false);
  loop();
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
  PImage mapImg = TileDataToImg(mapData);
  mapImg.save(selection.getAbsolutePath() + ".png");
  loop();
}
