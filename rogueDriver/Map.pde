class Map {
  int[][] tiles;
  int NX, NY;

  int wall = 0;
  int road = 1;
  int start = 2;
  int finish = 3;

  color[] colors = new color[]{
    color(0, 0, 0),
    color(255, 255, 255),
    color(0, 255, 0),
    color(255, 0, 0)
  };


  Map(int NX, int NY) {
    this.NX = NX;
    this.NY = NY;
    tiles = new int[NX][NY];
    for (int i = 0; i < NX; i++)
      for (int j = 0; j < NY; j++)
        tiles[i][j] = wall;
  }

  void Display(float x, float y, float scale) {
    for (int i = 0; i < NX; i++) {
      for (int j = 0; j < NY; j++) {
        fill(colors[tiles[i][j]]);
        square(x + i * scale, y + j * scale, scale);
      }
    }
  }
}
