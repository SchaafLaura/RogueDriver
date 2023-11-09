class EditorScene extends Scene {
  Map map;
  int brushSize = 2;
  int brush = 1;
  float editorTileSize = 10;

  float xOff, yOff;

  ArrayList<MaterialButton> materialButtons;
  Slider brushSizeSlider;
  InputField nameInput;

  public void mouseEvent(MouseEvent e) {
    if (materialButtons!= null) {
      for (int i = 0; i < materialButtons.size(); i++)
        if (materialButtons.get(i).extents.IsInside(mouseX, mouseY))
          return;
    }

    if (nameInput.extents.IsInside(mouseX, mouseY))
      return;

    if (brushSizeSlider.extents.IsInside(mouseX, mouseY) || brushSizeSlider.handleExtents.IsInside(mouseX, mouseY))
      return;

    if (e.getCount() != 0 && e.getAction() == MouseEvent.WHEEL   ) {
      HandleMouseWheel(e.getCount());
      return;
    }

    HandleMousepress();
  }
  public void keyEvent(KeyEvent e) {
    if (e.getAction() != KeyEvent.PRESS)
      return;

    if (nameInput.GetCaptured())
      return;

    var keypressed = e.getKey();

    if (keypressed == '0')
      brush = 0;
    if (keypressed == '1')
      brush = 1;
    if (keypressed == '2')
      brush = 2;
    if (keypressed == '3')
      brush = 3;
    if (keypressed == '4')
      brush = 4;
    if (keypressed == '5')
      brush = 5;
    if (keypressed == '+')
      brushSizeSlider.value++;
    if (keypressed == '-')
      brushSizeSlider.value--;
    if (brushSize < 1)
      brushSize = 1;

    if (keypressed == 'u')
      UploadMap(map);

    if (escDown)
      sceneManager.Load(MAINMENU_SCENE_INDEX, false, false);
  }


  void Update() {
    brushSize = (int) brushSizeSlider.value;
  }
  void Display() {
    background(0);
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

  void Load() {
    var editorUI = new TLMUI();
    materialButtons = new ArrayList<MaterialButton>();

    for (int i = 0; i < mapColors.length; i++) {
      int mat = i;

      float w = tileSize*2;
      float h = tileSize*2;

      float x = 10;
      float y = 10 + (w+5)*i;

      Rectangle rect = new Rectangle(x, y, w, h);

      var pb = new MaterialButton(
        materialNames[i],
        i,
        rect,
        () -> {
        brush = mat;
      }
      );
      editorUI.AddChild(pb);
      materialButtons.add(pb);
    }

    brushSizeSlider = new Slider(
      new Rectangle(10 + tileSize*2 + 30, 10, 200, 30),
      1,
      64,
      2);

    editorUI.AddChild(brushSizeSlider);

    nameInput = new InputField(
      "",
      "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789ß-_#+~*?()%$§!@€µ<>|²³{[]}",
      new Rectangle(width/2 - 150, 5, 300, 40));
    nameInput.SetMaximumCharacters(16);


    editorUI.AddChild(nameInput);



    SetUI(editorUI);


    brushSize = 2;
    brush = 1;
    editorTileSize = 10;

    xOff = width/4;
    yOff = 50;
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

class MaterialButton extends Button {
  int material = -1;

  public MaterialButton(String label, int material, Rectangle extents, Runnable function) {
    super(label, extents, function);
    this.material = material;
  }

  public void DisplaySelf(float x, float y) {
    if (extents == null)
      return;

    var theme = (GetRoot()).theme;

    Boolean mouseInside = false;
    float xOff = 0;
    float yOff = 0;
    if (GetParent() != null) {
      xOff = GetParent().PosX();
      yOff = GetParent().PosY();
    }
    if (extents.IsInside(mouseX - xOff, mouseY - yOff))
      mouseInside = true;

    boolean selected = false;
    if (((EditorScene)sceneManager.scenes[EDITOR_SCENE_INDEX]).brush == this.material)
      selected = true;

    strokeWeight((mouseInside||selected) ? 5 : 1);
    stroke((mouseInside||selected) ? color(255, 0, 255) : theme.buttonOutlineColor);
    fill(mapColors[material]);
    rect(x, y, extents.w, extents.h);
    textAlign(CENTER, CENTER);
    fill(theme.buttonLabelColor);
    text(label, x + extents.w/2, y + extents.h/2);
  }
}
