class Player {
  boolean engineRunning = false;  // engine state
  boolean handbrake = false;      // brake engaged?
  int gear = 0;                   // gear the egine is in: 0 .. 6
  int x, y;                       // position: 0 .. mapSize
  int vx, vy;                     // abs(velocity): 2*gear-1 .. 2*gear+1

  void Update() {
    x += vx;
    y += vy;
  }

  void UndoMove(Move move) {
    move.Undo(this);
  }

  void DoMove(Move move) {
    move.SavePlayerState(this.Copy());
    move.Do(this);
    Update();
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
