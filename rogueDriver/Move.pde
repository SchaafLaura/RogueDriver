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

char Hash(Move move) {
  return move.Hash();
}

Move MoveFromHash(char hash) {
  switch(hash) {
  case 'e':
    return new SwitchEngine();
  case '+':
    return new GearUp();
  case '-':
    return new GearDown();
    // TODO: update with more commands when needed
  }
  // steer
  int r = (int) (hash - 48);
  int dx = (r % 3) - 1;
  int dy = (r / 3) - 1;
  return new Steer(dx, dy);
}
