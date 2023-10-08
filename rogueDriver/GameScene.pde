class GameScene extends Scene {
  int pX = -1;
  int pY = -1;

  int vX, vY;
  int prevVX, prevVY;

  ArrayList<PVector> tracks = new ArrayList<PVector>();

  Map map;
  void Update() {
    if (pX == -1 || pY == -1)
      FindStart();
  }

  void FindStart() {
    if (map == null)
      return;
    for (int i = 0; i < map.NX; i++) {
      for (int j = 0; j < map.NY; j++) {
        if (map.tiles[i][j] == map.start) {
          pX = i;
          pY = j;
          return;
        }
      }
    }
  }

  void Display() {
    float scale = float(width)/map.NX;
    background(0);
    if (map != null)
      map.Display(0, 0, scale);

    fill(255, 0, 255);
    square(pX * scale, pY * scale, scale);

    fill(255, 255, 0);
    square((pX+vX) * scale, (pY+vY) * scale, scale);

    fill(50, 50, 50, 128);
    for (var t : tracks)
      square(t.x*scale, t.y*scale, scale);
  }

  void Drive() {
    println("driving");
    Line line = new Line(pX, pY, pX + vX, pY + vY);
    for (int i = 0; i < line.indices.size(); i++)
      println(line.indices.get(i));

    for (int i = 0; i < line.indices.size(); i++) {
      int x = (int)line.indices.get(i).x;
      int y = (int)line.indices.get(i).y;
      pX = x;
      pY = y;
      tracks.add(new PVector(x, y));
      if (i == 0 || map.tiles[x][y] == map.road || map.tiles[x][y] == map.start)
        continue;
      vX = 0;
      vY = 0;
      prevVX = 0;
      prevVY = 0;
      break;
    }

    /*  pX += vX;
     pY += vY;
     */
    prevVX = vX;
    prevVY = vY;
  }


  void HandleInput() {
    if (keyCode == ENTER) {
      Drive();
    }


    int dx = 0;
    int dy = 0;

    if (keyCode == RIGHT)
      dx = 1;
    if (keyCode == LEFT)
      dx = -1;
    if (keyCode == UP)
      dy = -1;
    if (keyCode == DOWN)
      dy = 1;

    int deltaVX = abs(prevVX - (vX + dx));
    int deltaVY = abs(prevVY - (vY + dy));

    float delta = sqrt(deltaVX*deltaVX + deltaVY*deltaVY);
    if (delta > 1.5)
      return;
    vX += dx;
    vY += dy;
  }
  void Load() {
    map = ((EditorScene)sceneManager.scenes[EDITOR_SCENE_INDEX]).map;


    vX = 0;
    vY = 0;

    prevVX = vX;
    prevVY = vY;
  }
  void Unload() {
  }
}
