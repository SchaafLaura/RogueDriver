class MapDisplay {
  ArrayList<PVector> tracks = new ArrayList<PVector>();
  color trackColor = color(50, 50, 50, 100);
  color[] colors = new color[]{
    color(0, 0, 0),
    color(255, 255, 255),
    color(200, 200, 40),
    color(150, 150, 250),
    color(0, 255, 0),
    color(255, 0, 0)
  };

  void Display(Map map, float x, float y, float scale) {
    DisplayMap(map, x, y, scale);
    DisplayTracks(scale);
  }

  void DisplayTracks(float scale) {
    if (tracks == null)
      return;
    fill(trackColor);
    for (var t : tracks)
      square(t.x*scale, t.y*scale, scale);
  }

  void DisplayMap(Map map, float x, float y, float scale) {
    if (map == null)
      return;
    for (int i = 0; i < map.NX; i++) {
      for (int j = 0; j < map.NY; j++) {
        fill(colors[map.tiles[i][j]]);
        square(x + i * scale, y + j * scale, scale);
      }
    }
  }
}
