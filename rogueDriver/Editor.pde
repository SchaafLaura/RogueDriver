class EditorScene extends Scene {
  Map map;
  int brushSize = 2;
  int brush = 1;
  float editorTileSize = 10;

  float xOff, yOff;
  void Update() {
  }
  void Display() {
    if (map == null)
      return;
    noStroke();
    for (int i = 0; i < map.NX; i++) {
      for (int j = 0; j < map.NY; j++) {
        fill(mapColors[map.tiles[i][j]]);
        square(xOff + i*editorTileSize, yOff + j*editorTileSize, editorTileSize);
      }
    }

    int x = int((mouseX-xOff)/editorTileSize);
    int y = int((mouseY-yOff)/editorTileSize);
    for (int i = -brushSize; i <= brushSize; i++) {
      for (int j = -brushSize; j <= brushSize; j++) {
        int ix = i + x;
        int jy = j + y;
        if (ix >= 0 && jy >= 0 && ix < map.NX && jy < map.NY) {
          if ((i*i+j*j) < brushSize) {
            color c = mapColors[brush];
            fill(red(c), green(c), blue(c), 150);
            stroke(255, 0, 255, 90);
            square(xOff + ix*editorTileSize, yOff + jy*editorTileSize, editorTileSize);
          }
        }
      }
    }
  }
  void HandleInput() {
    if (keyPressed)
      HandleKeypress();

    if (mousePressed)
      HandleMousepress();
  }

  void HandleMouseWheel(float turn) {
    float zoomAmount = -turn;

    float prevX = (mouseX-xOff)/editorTileSize;
    float prevY = (mouseY-yOff)/editorTileSize;

    editorTileSize = constrain(editorTileSize + zoomAmount, 1, 100);

    float newX = (mouseX-xOff)/editorTileSize;
    float newY = (mouseY-yOff)/editorTileSize;

    xOff -= editorTileSize*(prevX - newX);
    yOff -= editorTileSize*(prevY - newY);
  }


  void HandleMousepress() {
    if (mouseButton == RIGHT) {
      int x = int((mouseX-xOff)/editorTileSize);
      int y = int((mouseY-yOff)/editorTileSize);
      if (x >= 0 && y >= 0 && x < map.NX && y < map.NY)
        brush = map.tiles[x][y];
    }

    if (mouseButton == CENTER) {
      xOff += (mouseX - pmouseX);
      yOff += (mouseY - pmouseY);
      return;
    }

    if (mouseButton == LEFT) {
      int x = int((mouseX-xOff)/editorTileSize);
      int y = int((mouseY-yOff)/editorTileSize);

      for (int i = -brushSize; i <= brushSize; i++) {
        for (int j = -brushSize; j <= brushSize; j++) {
          int ix = i + x;
          int jy = j + y;
          if (ix >= 0 && jy >= 0 && ix < map.NX && jy < map.NY) {
            if ((i*i+j*j) < brushSize)
              map.tiles[ix][jy] = brush;
          }
        }
      }
    }
  }

  void HandleKeypress() {
    if (key == '0')
      brush = 0;
    if (key == '1')
      brush = 1;
    if (key == '2')
      brush = 2;
    if (key == '3')
      brush = 3;
    if (key == '4')
      brush = 4;
    if (key == '5')
      brush = 5;
    if (key == '+')
      brushSize++;
    if (key == '-')
      brushSize--;
    if (brushSize < 1)
      brushSize = 1;

    if (key == 'u')
      UploadMap(map);

    if (escDown)
      sceneManager.SwitchSceneTo(MAINMENU_SCENE_INDEX, false, false);
  }


  void Load() {
  }
  void Unload() {
  }

  void SetupDefaultMap() {
    this.map = new Map(100, 100);
    for (int i = 0; i < 100; i++) {
      map.tiles[i][0] = 1;
      map.tiles[i][99] = 1;
      map.tiles[0][i] = 1;
      map.tiles[99][i] = 1;
    }
  }

  void LoadMapFromTileData(int[][] tileData) {
    this.map = new Map(tileData);
  }
}
