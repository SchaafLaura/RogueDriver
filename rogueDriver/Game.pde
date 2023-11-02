class GameScene extends Scene {
  Map map;
  Player player;
  MapDisplay mapDisplay = new MapDisplay();
  ArrayList<Ghost> ghosts = new ArrayList<Ghost>();
  int dvx, dvy;
  boolean win = false;
  
  public void mouseEvent(MouseEvent e) {
  }
  public void keyEvent(KeyEvent e) {
  }

  void Update() {
    if (map.tiles[player.x][player.y] == finish) {
      win = true;
      sceneManager.Load(HIGHSCORE_SCENE_INDEX, false, false);
    }
    player.Update();
    for (var g : ghosts)
      g.Update();
  }


  void Display() {
    if (map == null)
      return;
    DisplayMap();
    DisplayNextMove();

    if (player == null)
      return;

    textSize(30);
    textAlign(LEFT);
    fill(0);
    rect(0, 0, 200, 200);
    DisplaySteps();
    DisplayVelocity();
    DisplayGear();
    DisplayEngine();
    DisplayMiniMap();
  }

  void DisplayMiniMap() {
    var mm  = mapDisplay.GetMiniMap(map, player, ghosts);
    image(mm, width - mm.width*2, 0, mm.width*2, mm.height*2);
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
    String plusMinus = player.Velocity() == player.gear ? "-" : player.Velocity() == player.gear + 2 ? "+" : "";
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

    int nextX = player.x + player.vx + dvx;
    int nextY = player.y + player.vy + dvy;

    Line line = new Line(player.x, player.y, nextX, nextY);
    mapDisplay.DisplayLine(line, player);
  }

  void DisplayMap() {
    if (map == null)
      return;
    mapDisplay.DisplayMap(map, player, ghosts);
  }



  void HandleInput() {
    TryGoToMainMenu();
    TryReset();

    if (mousePressed)
      return;

    if (player.IsDriving())
      return;

    for (var g : ghosts)
      if (g.IsDriving())
        return;

    TrySteer();
    Move move = gameManager.GetMoveFromCurrentKey(player, dvx, dvy);
    if (move != null) {
      player.DoMove(move);
      for (var g : ghosts)
        g.NextStep();
      dvx = 0;
      dvy = 0;
    }
  }


  void TrySteer() {
    int prevDVX = dvx;
    int prevDVY = dvy;

    int prevVelocity = player.Velocity();

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

    if (newVelocity > prevVelocity && !player.IsValidVelocity(player.vx+dvx, player.vy+dvy)) {
      dvx = prevDVX;
      dvy = prevDVY;
    }
  }

  void TryReset() {
    if (key == 'r') {
      SetupPlayerOnCurrentMap();
      win = false;
    }
  }

  void TryGoToMainMenu() {
    if (escDown) {
      sceneManager.Load(MAINMENU_SCENE_INDEX, false, false);
      return;
    }
  }

  void Load() {
  }
  void Unload() {
  }

  void HandleMouseWheel(float turn) {
    zoomLevel *= turn > 0 ? 1.1 : 0.9;
    scale = zoomLevel * float(width) / resXNative;
    tileSize = tileSizeNative * scale;
    tileSize_half = tileSize * 0.5;
    mapDisplay = new MapDisplay();
  }

  void LoadMapFromTileData(int[][] tileData) {
    this.map = new Map(tileData);
  }

  void SetupMatchAgainst(ArrayList<String> ghostReplays) {
    var start = map.GetStart();

    player = new Player();

    player.x = start[0];
    player.y = start[1];
    player.vx = 0;
    player.vy = 0;
    player.stepsTaken = 0;
    player.nextPositions = new ArrayList<PVector>();

    ghosts = new ArrayList<Ghost>();
    for (var r : ghostReplays) {
      Ghost g = new Ghost(r);
      g.x = start[0];
      g.y = start[1];
      g.vx = 0;
      g.vy = 0;
      g.stepsTaken = 0;
      g.nextPositions = new ArrayList<PVector>();
      ghosts.add(g);
    }
  }

  void SetupPlayerOnCurrentMap() {
    var start = map.GetStart();

    player = new Player();

    player.x = start[0];
    player.y = start[1];
    player.vx = 0;
    player.vy = 0;
    player.stepsTaken = 0;
    player.nextPositions = new ArrayList<PVector>();

    for (var g : ghosts) {
      g.x = start[0];
      g.y = start[1];
      g.vx = 0;
      g.vy = 0;
      g.stepsTaken = 0;
      g.nextPositions = new ArrayList<PVector>();
      g.moveIndex = g.moveHashes.length() - 1;
    }
  }
}
