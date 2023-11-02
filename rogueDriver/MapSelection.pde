class MapSelectionOnlineScene extends Scene {
  //ArrayList<PictureButton> mapButtons;
  ArrayList<Map> maps;
  
  public void mouseEvent(MouseEvent e){}
  public void keyEvent(KeyEvent e){}
  
  void Update() {
  }
  void Display() {
    /*if (mapButtons == null)
      return;
    for (var b : mapButtons)
      b.Display();*/
  }
  
  /*
  void HandleInput() {
    for (var b : mapButtons)
      b.TryClick();
    if (escDown)
      sceneManager.Load(MAINMENU_SCENE_INDEX, false, false);
  }
  */
  
  /*
  void HandleMouseWheel(float turn) {
    for (var b : mapButtons)
      b.boundingBox.y -= turn * 15;
  }
  */
  
  void Load() {
/*
    maps = GetAllMapsFromDatabase();

    mapButtons = new ArrayList<PictureButton>();

    float x = 10;
    float y = 10;
    float w = 200;
    float h = 200;
    for (var m : maps) {
      PImage pic = m.img;
      Rectangle rect = new Rectangle(x, y, w, h);
      PictureButton pb = new PictureButton(
        pic,
        m.name,
        rect,
        () -> {
        var gameScene = (GameScene)sceneManager.scenes[GAME_SCENE_INDEX];
        gameScene.map = m;
        gameScene.mapDisplay = new MapDisplay();
        gameScene.SetupPlayerOnCurrentMap();
        sceneManager.Load(GAME_SCENE_INDEX, false, false);
      }

      );
      mapButtons.add(pb);

      x += w + 10;
      if (x+w > width) {
        x = 10;
        y += h + 10;
      }
    }
    
    */
  }
  void Unload() {
  }
}


class MapSelectionLocalScene extends Scene {
  //ArrayList<PictureButton> mapButtons;
  public void mouseEvent(MouseEvent e){}
  public void keyEvent(KeyEvent e){}
  
  void Update() {
  }
  void Display() {
    /*if (mapButtons == null)
      return;
    for (var b : mapButtons)
      b.Display();*/
  }
  
  /*
  void HandleInput() {
    for (var b : mapButtons)
      b.TryClick();
    if (escDown)
      sceneManager.Load(MAINMENU_SCENE_INDEX, false, false);
  }*/
  
  /*
  void HandleMouseWheel(float turn) {
    for (var b : mapButtons)
      b.boundingBox.y -= turn * 15;
  }*/
  
  
  void Load() {
    /*
    String pathToTracks = dataPath("../tracks");
    File folder = new File(pathToTracks);
    FilenameFilter fF = new FilenameFilter() {
      public boolean accept(File dir, String name) {
        return name.toLowerCase().endsWith(".png");
      }
    };
    String[] filenames = folder.list(fF);
    mapButtons = new ArrayList<PictureButton>();

    float x = 10;
    float y = 10;
    float w = 200;
    float h = 200;
    for (var fileName : filenames) {
      String dataPath = sketchPath("tracks\\") + fileName;
      PImage pic = loadImage(dataPath);
      Rectangle rect = new Rectangle(x, y, w, h);
      File track = new File(dataPath);
      PictureButton pb = new PictureButton(
        pic,
        fileName,
        rect,
        () -> {
        LoadTrackToLevelAndSwitchScene(track);
      }

      );
      mapButtons.add(pb);

      x += w + 10;
      if (x+w > width) {
        x = 10;
        y += h + 10;
      }
    }
    */
  }
  void Unload() {
  }
}
