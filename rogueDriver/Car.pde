class Car {
  int x, y;
  int vx, vy;
  int stepsTaken = 0;

  ArrayList<PVector> nextMoves = new ArrayList<PVector>();

  void Steer(int dvx, int dvy) {
    Line moves = new Line(x, y, x + vx + dvx, y + vy + dvy);
    nextMoves.addAll(moves.indices);
    vx += dvx;
    vy += dvy;
    stepsTaken++;
  }

  boolean IsDriving() {
    return nextMoves.size() > 0;
  }

  void Update() {
    if (!IsDriving())
      return;

    int newX = (int)nextMoves.get(0).x;
    int newY = (int)nextMoves.get(0).y;

    Map map = ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).map;

    // walls, sandbanks and finish set your velocity to 0
    if (map.tiles[newX][newY] == map.wall || map.tiles[newX][newY] == map.sand || map.tiles[newX][newY] == map.finish) {
      vx = 0;
      vy = 0;
    }

    // bonk. Don't go through walls
    if (map.tiles[newX][newY] == map.wall) {
      nextMoves = new ArrayList<PVector>();
      return;
    }

    x = newX;
    y = newY;
    ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).mapDisplay.tracks.add(new PVector(x, y));

    if (map.tiles[newX][newY] == map.finish) {
      nextMoves = new ArrayList<PVector>();
      return;
    }
    nextMoves.remove(0);

    if (map.tiles[x][y] == map.ice)
      Steer(0, 0);
  }
}
