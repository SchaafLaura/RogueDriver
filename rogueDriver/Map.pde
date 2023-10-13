class Map {
  PImage img;
  int[][] tiles;
  int NX, NY;
  String absolutePath = "";
  String name = "";

  Integer Hash() {
    int total = 0;
    for (int i = 0; i < NX; i++) {
      for (int j = 0; j < NY; j++) {
        total += tiles[i][j] * (i+1) * (j+1);
      }
    }
    return total;
  }

  String toString() {
    String ret = "";
    for (int i = 0; i < NY; i++)
      for (int j = 0; j < NX; j++)
        ret += str(tiles[j][i]);
    return ret;
  }

  Map(int NX, int NY) {
    this.NX = NX;
    this.NY = NY;
    tiles = new int[NX][NY];
    for (int i = 0; i < NX; i++)
      for (int j = 0; j < NY; j++)
        tiles[i][j] = wall;

    img = TileDataToImg(tiles);
  }

  Map(int[][] tiles) {
    this.NX = tiles.length;
    this.NY = tiles[0].length;
    this.tiles = tiles;
    img = TileDataToImg(tiles);
  }

  Map(int NX, int NY, String data) {
    this.NX = NX;
    this.NY = NY;
    tiles = new int[NX][NY];
    for (int i = 0; i < NX; i++)
      for (int j = 0; j < NY; j++)
        tiles[i][j] = Integer.parseInt(str(data.charAt(i + j * NX)));
    img = TileDataToImg(tiles);
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
