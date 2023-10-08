class EditorScene extends Scene {
  Map map;
  int material;
  int r = 2;

  MapDisplay mapDisplay;

  EditorScene() {
    map = new Map(100, 100);
    material = map.wall;
    mapDisplay = new MapDisplay();
  }

  void Display() {
    background(0);
    if (map != null)
      mapDisplay.Display(map, 0, 0, width/map.NX);
  }

  void HandleInput() {
    if (keyPressed)
      HandleKeypress();

    if (mousePressed)
      HandleMousepress();
  }

  void HandleMousepress() {
    int x = int(mouseX/(float(width)/map.NX));
    int y = int(mouseY/(float(width)/map.NX));
    for (int i = -r; i <= r; i++) {
      for (int j = -r; j <= r; j++) {
        int ix = i + x;
        int jy = j + y;
        if (ix >= 0 && jy >= 0 && ix < map.NX && jy < map.NY)
          map.tiles[ix][jy] = material;
      }
    }
  }

  void HandleKeypress() {
    if (key == '0')
      material = 0;
    if (key == '1')
      material = 1;
    if (key == '2')
      material = 2;
    if (key == '3')
      material = 3;
    if (key == '4')
      material = 4;
    if (key == '+')
      r++;
    if (key == '-')
      r--;
    if (r < 0)
      r = 0;

    if (escDown)
      sceneManager.SwitchSceneTo(MAINMENU_SCENE_INDEX, false, false);
  }

  void Update() {
  }

  void Load() {
  }
  void Unload() {
  }
}
