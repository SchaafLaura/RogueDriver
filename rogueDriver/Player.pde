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

class Steer extends Move {
  int dx, dy;
  Steer(int dx, int dy) {
    this.dx = dx;
    this.dy = dy;
  }

  char Hash() {
    int num = (dx+1) + (dy+1)*3;  // unique 1D number from 2D (dx,dy)
    char c = (char) (num+48);     // converts integers from 0 to 9 to characters from '0' to '9'
    return c;
  }

  void Do(Player p) {
    p.vx += dx;
    p.vy += dy;
  }
}

class GearDown extends Move {
  char Hash() {
    return '-';
  }
  void Do(Player p) {
    p.gear--;
  }
}

class GearUp extends Move {
  char Hash() {
    return '+';
  }
  void Do(Player p) {
    p.gear += 1;
  }
}

class SwitchEngine extends Move {
  char Hash() {
    return 'e';
  }
  void Do(Player p) {
    p.engineRunning = !p.engineRunning;
  }
}

class SwitchBreak extends Move {
  char Hash() {
    return 'b';
  }
  void Do(Player p) {
    p.handbrake = !p.handbrake;
  }
}

// TODO: put this in its own file, just here for now to :3
abstract class Move {
  Player before;
  abstract void Do(Player p);
  abstract char Hash();
  void Undo(Player p) {
    p.Restore(before);
  }
  void SavePlayerState(Player p) {
    before = p;
  }
}
