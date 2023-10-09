class Map {
  int[][] tiles;
  int NX, NY;
  int wall = 0;
  int road = 1;
  int sand = 2;
  int ice = 3;
  int start = 4;
  int finish = 5;
  
  String absolutePath;

  Map(int NX, int NY) {
    this.NX = NX;
    this.NY = NY;
    tiles = new int[NX][NY];
    for (int i = 0; i < NX; i++)
      for (int j = 0; j < NY; j++)
        tiles[i][j] = wall;
  }

  Map(int[][] tiles) {
    this.NX = tiles.length;
    this.NY = tiles[0].length;
    this.tiles = tiles;
  }

  int[] GetStart() {
    if (tiles == null)
      return null;
    for (int i = 0; i < NX; i++)
      for (int j = 0; j < NY; j++)
        if (tiles[i][j] == start)
          return new int[]{i, j};
    return null;
  }
}
