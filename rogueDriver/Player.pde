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
    x = (int) nextPositions.get(0).x;
    y = (int) nextPositions.get(0).y;
    nextPositions.remove(0);
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

  void DoMove(Move move) {
    move.SavePlayerState(this.Copy());
    move.Do(this);
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
