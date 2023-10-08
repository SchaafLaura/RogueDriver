class GameScene extends Scene {
  Map map;
  MapDisplay mapDisplay = new MapDisplay();
  Car player;

  int dvx, dvy;

  void Update() {
    player.Update();
  }

  void Display() {
    background(0);
    DisplayMap();

    DisplayNextMove();
    DisplaySteps();
    DisplayPlayer();
  }

  void DisplayNextMove() {
    if (map == null || player == null)
      return;

    float scale = float(width)/map.NX;


    int nextX = player.x + player.vx + dvx;
    int nextY = player.y + player.vy + dvy;

    Line line = new Line(player.x, player.y, nextX, nextY);
    fill(190, 190, 0);
    for (var pos : line.indices)
      square(pos.x * scale, pos.y * scale, scale);
  }

  void DisplaySteps() {
    if (player == null)
      return;

    textSize(30);
    fill(255, 0, 255);
    text(player.stepsTaken, 30, 30);
  }

  void DisplayPlayer() {
    if (player == null)
      return;
    float scale = float(width)/map.NX;
    fill(255, 0, 255);
    square(player.x * scale, player.y * scale, scale);
  }

  void DisplayMap() {
    if (map == null)
      return;
    float scale = float(width)/map.NX;
    mapDisplay.Display(map, 0, 0, scale);
  }

  void HandleInput() {
    if (escDown) {
      sceneManager.SwitchSceneTo(MAINMENU_SCENE_INDEX, false, false);
      return;
    }

    if (key == 'r') {
      ResetPlayerOnCurrentMap();
      mapDisplay.tracks = new ArrayList<PVector>();
    }

    if (keyCode == RIGHT && dvx < 1)
      dvx++;
    if (keyCode == LEFT && dvx > -1)
      dvx--;
    if (keyCode == DOWN && dvy < 1)
      dvy++;
    if (keyCode == UP && dvy > -1)
      dvy--;

    if (key == ' ' && !player.IsDriving()) {
      player.Steer(dvx, dvy);
      dvx = 0;
      dvy = 0;
    }
  }

  void LoadMap(Map toLoad) {
    map = toLoad;
    ResetPlayerOnCurrentMap();
  }

  void ResetPlayerOnCurrentMap() {
    var start = map.GetStart();

    player = new Car();
    player.x = start[0];
    player.y = start[1];
    player.vx = 0;
    player.vy = 0;
    player.stepsTaken = 0;
  }

  void Load() {
  }

  void Unload() {
  }
}
