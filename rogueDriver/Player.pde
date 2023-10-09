class Player {
  boolean engineRunning = false;  // engine state
  boolean handbrake = false;      // brake engaged?
  int gear = 0;                   // gear the egine is in: 0 .. 6
  int x, y;                       // position: 0 .. mapSize
  int vx, vy;                     // abs(velocity): 2*gear-1 .. 2*gear+1

  void makeMove(Move move) {
    move.SavePlayerState(this.Copy());
    move.Do(this);
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

class SwitchBreak extends Move {
  void Do(Player p) {
    p.handbrake = !p.handbrake;
  }
}

// TODO: put this in its own file, just here for now to :3
abstract class Move {
  Player before;
  abstract void Do(Player p);
  void Undo(Player p) {
    p.Restore(before);
  }
  void SavePlayerState(Player p) {
    before = p;
  }
}
