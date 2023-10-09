class GameScene extends Scene {
  Map map;
  MapDisplay mapDisplay = new MapDisplay();
  //Car player;

  Player player;
  Ghost ghost;
  int dvx, dvy;

  boolean win = false;

  void Update() {
    if (map.tiles[player.x][player.y] == map.finish) {
      win = true;
      sceneManager.SwitchSceneTo(HIGHSCORE_SCENE_INDEX, false, false);
    }
    player.Update();
    ghost.Update();
  }

  void Display() {
    background(0);
    DisplayMap();

    DisplayNextMove();

    if (player == null)
      return;

    textSize(30);
    textAlign(LEFT);
    DisplaySteps();
    DisplayVelocity();
    DisplayGear();
    DisplayEngine();
    DisplayPlayer();
  }

  void DisplaySteps() {
    fill(255, 0, 255);
    text("steps: " + player.stepsTaken, 30, 30);
  }

  void DisplayVelocity() {
    fill(255, 255, 255);
    text("v: " + player.Velocity(), 30, 70);
  }

  void DisplayGear() {
    color col = player.IsValidVelocity(player.vx, player.vy) ? color(255, 255, 255) : color(255, 0, 0);
    fill(col);
    String plusMinus = player.Velocity() == 2 * player.gear - 1 ? "-" : player.Velocity() == 2 * player.gear + 1 ? "+" : "";
    text("gear: " + player.gear + plusMinus, 30, 110);
  }

  void DisplayEngine() {
    String onOff = player.engineRunning ? "On" : "Off";
    color col = player.engineRunning ? color(0, 255, 0) : color (255, 0, 0);
    fill(col);
    text("engine: " + onOff, 30, 150);
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


    fill(0, 0, 255);
    square(ghost.x * scale, ghost.y * scale, scale);

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

    if (key == '-' && player.gear > 0)
      move = new GearDown();

    if (key == '+' && player.gear < 6)
      move = new GearUp();

    if (keyCode == ENTER)
      move = new SwitchBrake();

    if (key == ' ')
      move = new Steer(dvx, dvy);


    if (move != null) {
      player.DoMove(move);
      ghost.NextStep();
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
      win = false;
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
    println(map.Hash());
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

    ghost = new Ghost("e1+004+115588888+77-66633+6330301110221122---e514");
    ghost.x = start[0];
    ghost.y = start[1];
    ghost.vx = 0;
    ghost.vy = 0;
    ghost.stepsTaken = 0;
    ghost.nextPositions = new ArrayList<PVector>();
  }

  void Load() {
  }

  void Unload() {
  }
}
