class Player {
  boolean engineRunning = false;  // engine state
  int gear = 0;                   // gear the engine is in: 0 .. 6
  int x, y;                       // position: 0 .. mapSize
  int vx, vy;                     // abs(velocity): 2*gear-1 .. 2*gear+1
  int stepsTaken = 0;             // number of moves made

  ArrayList<PVector> nextPositions = new ArrayList<PVector>();
  String history = "";

  void Update() {
    if (nextPositions.size() == 0)
      return;

    GoToNextPosition();
  }

  void GoToNextPosition() {
    var map = gameManager.GetMap();
    int newX = (int) nextPositions.get(0).x;
    int newY = (int) nextPositions.get(0).y;

    if (map.tiles[x][y] == finish) {
      vx = 0;
      vy = 0;
      engineRunning = false;
      nextPositions = new ArrayList<PVector>();
      return;
    }

    if (map.tiles[newX][newY] == wall) {
      engineRunning = false;
      vx = 0;
      vy = 0;
      nextPositions = new ArrayList<PVector>();
      return;
    }

    if (map.tiles[newX][newY] == sand) {
      vx = 0;
      vy = 0;
    }

    x = newX;
    y = newY;
    nextPositions.remove(0);

    if (nextPositions.size() == 0 && map.tiles[x][y] == ice && (vx != 0 || vy != 0))
      Drive();
  }

  void DoMove(Move move) {
    history += move.Hash();
    move.SavePlayerState(this.Copy());
    move.Do(this);
    UpdateStats();
    Drive();
    stepsTaken++;
  }

  int Velocity() {
    return max(abs(vx), abs(vy));
  }

  boolean IsDriving() {
    return nextPositions.size() > 0;
  }

  void Drive() {
    Line moves = new Line(x, y, x + vx, y + vy);
    nextPositions.addAll(moves.indices);
  }

  boolean IsValidVelocity(int vx_, int vy_) {
    int v = max(abs(vx_), abs(vy_));
    if (gear == 0)
      return v <= 1;
    return (v >= gear && v <= gear + 2);
  }

  void UpdateStats() {
    if (IsValidVelocity(vx, vy))
      return;
    engineRunning = false;
  }

  void UndoMove(Move move) {
    move.Undo(this);
    stepsTaken--;
    history = history.substring(0, history.length() - 1);
  }

  void Restore(Player p) {
    this.engineRunning = p.engineRunning;
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
    ret.gear = this.gear;
    ret.x = this.x;
    ret.y = this.y;
    ret.vx = this.vx;
    ret.vy = this.vy;
    // TODO: update this incase player stats changed
    return ret;
  }
}

class Ghost extends Player {
  String moveHashes;
  int moveIndex = -1;
  Ghost(String moveHashes) {
    this.moveHashes = new StringBuilder(moveHashes).reverse().toString();
    moveIndex = moveHashes.length() - 1;
  }
  void NextStep() {
    if (moveHashes == "")
      return;
    if (moveIndex < 0)
      return;
    char nextStepHash = moveHashes.charAt(moveIndex--);
    DoMove(MoveFromHash(nextStepHash));
  }
}
