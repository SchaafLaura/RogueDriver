class EditorScene extends Scene {

  Map map;

  int material;
  int r = 2;

  EditorScene() {
    map = new Map(100, 100);
    material = map.road;
  }



  void Update() {
    HandleMouse();
  }
  void Display() {
    background(0);
    map.Display(0, 0, width/map.NX);
  }

  void HandleMouse() {
    if (!mousePressed)
      return;
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

  void HandleKeyboard() {
    if (!keyPressed)
      return;

    if (key == '1')
      material = 0;
    if (key == '2')
      material = 1;
    if (key == '3')
      material = 2;
    if (key == '4')
      material = 3;


    if (key == '+')
      r++;
    if (key == '-')
      r--;
    if (r < 0)
      r = 0;
  }

  void HandleInput() {
    HandleKeyboard();
  }
  void Load() {
  }
  void Unload() {
  }
}
