class Player {
  boolean engineRunning = false;  // engine state
  boolean handbrake = false;      // brake engaged?
  int gear = 0;                   // gear the engine is in: 0 .. 6
  int x, y;                       // position: 0 .. mapSize
  int vx, vy;                     // abs(velocity): 2*gear-1 .. 2*gear+1
  int stepsTaken = 0;             // number of moves made

  ArrayList<PVector> nextPositions = new ArrayList<PVector>();

  void Update() {
    if (nextPositions.size() == 0)
      return;

    GoToNextPosition();
  }

  void GoToNextPosition() {
    var map = ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).map;
    int newX = (int) nextPositions.get(0).x;
    int newY = (int) nextPositions.get(0).y;

    if (map.tiles[x][y] == map.finish) {
      vx = 0;
      vy = 0;
      engineRunning = false;
      handbrake = true;
      nextPositions = new ArrayList<PVector>();
      return;
    }

    if (map.tiles[newX][newY] == map.wall) {
      engineRunning = false;
      vx = 0;
      vy = 0;
      nextPositions = new ArrayList<PVector>();
      return;
    }

    if (map.tiles[newX][newY] == map.sand) {
      vx = 0;
      vy = 0;
    }

    x = newX;
    y = newY;
    nextPositions.remove(0);

    if (nextPositions.size() == 0 && map.tiles[x][y] == map.ice && (vx != 0 || vy != 0))
      Drive();
  }


  void Drive() {
    Line moves = new Line(x, y, x + vx, y + vy);
    nextPositions.addAll(moves.indices);
  }

  boolean IsValidVelocity(int vx_, int vy_) {
    int v = max(abs(vx_), abs(vy_));
    if (gear == 0)
      return v <= 1;
    return (v >= 2*gear - 1 && v <= 2*gear + 1);
  }

  int Velocity() {
    return max(abs(vx), abs(vy));
  }

  boolean IsDriving() {
    return nextPositions.size() > 0;
  }

  void UpdateStats() {
    if (IsValidVelocity(vx, vy))
      return;
    engineRunning = false;
  }

  void DoMove(Move move) {
    move.SavePlayerState(this.Copy());
    move.Do(this);
    UpdateStats();
    Drive();
    stepsTaken++;
  }

  void UndoMove(Move move) {
    move.Undo(this);
    stepsTaken--;
  }

  void Restore(Player p) {
    this.engineRunning = p.engineRunning;
    this.handbrake = p.handbrake;
    this.gear = p.gear;
    this.x = p.x;
    this.y = p.y;
    this.vx = p.vx;
    this.vy = p.vy;
    // TODO: update this incase player stats changed
  }

  Player Copy() {
    Player ret = new Player();
    ret.engineRunning = this.engineRunning;
    ret.handbrake = this.handbrake;
    ret.gear = this.gear;
    ret.x = this.x;
    ret.y = this.y;
    ret.vx = this.vx;
    ret.vy = this.vy;
    // TODO: update this incase player stats changed
    return ret;
  }
}
