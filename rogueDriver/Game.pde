class GameScene extends Scene {
  Map map;
  MapDisplay mapDisplay = new MapDisplay();
  //Car player;

  Player player;
  int dvx, dvy;

  void Update() {
    player.Update();
  }

  void Display() {
    background(0);
    DisplayMap();

    DisplayNextMove();

    if (player == null)
      return;
    fill(255, 0, 255);
    textSize(30);
    textAlign(LEFT);
    DisplaySteps();
    DisplayVelocity();
    DisplayGear();
    DisplayEngine();
    DisplayPlayer();
  }

  void DisplaySteps() {
    text("steps: " + player.stepsTaken, 30, 30);
  }

  void DisplayVelocity() {
    text("v: " + player.Velocity(), 30, 70);
  }

  void DisplayGear() {
    text("gear: " + player.gear, 30, 110);
  }

  void DisplayEngine() {
    text("engine: " + player.engineRunning, 30, 150);
  }

  void DisplayNextMove() {
    if (map == null || player == null)
      return;


    float scale = float(width)/map.NX;

    int nextX;
    int nextY;

    if (player.handbrake) {
      nextX = player.x + player.vx;
      nextY = player.y + player.vy;
    } else {
      nextX = player.x + player.vx + dvx;
      nextY = player.y + player.vy + dvy;
    }


    Line line = new Line(player.x, player.y, nextX, nextY);

    if (player.IsValidVelocity(player.vx + dvx, player.vy + dvy))
      fill(190, 190, 0);
    else
      fill(200, 80, 0);



    for (var pos : line.indices)
      square(pos.x * scale, pos.y * scale, scale);
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

    TryGoToMainMenu();
    TryReset();

    if (mousePressed)
      return;

    if (player.IsDriving())
      return;

    TrySteer();

    Move move = null;

    if (key == '#')
      move = new SwitchEngine();

    if (key == '-')
      move = new GearDown();

    if (key == '+')
      move = new GearUp();

    if (keyCode == ENTER)
      move = new SwitchBrake();

    if (key == ' ')
      move = new Steer(dvx, dvy);


    if (move != null) {
      player.DoMove(move);
      dvx = 0;
      dvy = 0;
    }
  }

  void TrySteer() {
    int prevDVX = dvx;
    int prevDVY = dvy;

    int prevVelocity = max(abs(player.vx), abs(player.vy));

    if (keyCode == RIGHT && dvx < 1)
      dvx++;
    if (keyCode == LEFT && dvx > -1)
      dvx--;
    if (keyCode == DOWN && dvy < 1)
      dvy++;
    if (keyCode == UP && dvy > -1)
      dvy--;

    int newVelocity = max(abs(player.vx + dvx), abs(player.vy + dvy));
    if (!player.engineRunning && newVelocity > prevVelocity) {
      dvx = prevDVX;
      dvy = prevDVY;
    }
  }

  void TryReset() {
    if (key == 'r') {
      ResetPlayerOnCurrentMap();
      mapDisplay.tracks = new ArrayList<PVector>();
    }
  }

  void TryGoToMainMenu() {
    if (escDown) {
      sceneManager.SwitchSceneTo(MAINMENU_SCENE_INDEX, false, false);
      return;
    }
  }

  void LoadMap(Map toLoad) {
    map = toLoad;
    ResetPlayerOnCurrentMap();
  }

  void ResetPlayerOnCurrentMap() {
    var start = map.GetStart();

    player = new Player();
    player.x = start[0];
    player.y = start[1];
    player.vx = 0;
    player.vy = 0;
    player.stepsTaken = 0;
    player.nextPositions = new ArrayList<PVector>();
  }

  void Load() {
  }

  void Unload() {
  }
}
