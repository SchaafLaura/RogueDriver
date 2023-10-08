class Map {
  int[][] tiles;
  int NX, NY;
  int wall = 0;
  int road = 1;
  int sand = 2;
  int start = 3;
  int finish = 4;
  
  Map(int NX, int NY) {
    this.NX = NX;
    this.NY = NY;
    tiles = new int[NX][NY];
    for (int i = 0; i < NX; i++)
      for (int j = 0; j < NY; j++)
        tiles[i][j] = wall;
  }
}
