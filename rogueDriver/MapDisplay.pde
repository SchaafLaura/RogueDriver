class MapDisplay {
  ArrayList<PVector> tracks = new ArrayList<PVector>();
  color trackColor = color(50, 50, 50, 100);

  PImage car = loadImage("car.png");
  PImage finish = loadImage("finish.png");
  PImage start = loadImage("start.png");
  PImage road = loadImage("road.png");
  PImage ice = loadImage("ice.png");
  PImage sand = loadImage("sand.png");
  PImage wall = loadImage("wall.png");

  PImage highlight = loadImage("highlight.png");

  PGraphics pg;
  color[] colors = new color[]{
    color(0, 0, 0),
    color(255, 255, 255),
    color(200, 200, 40),
    color(150, 150, 250),
    color(0, 255, 0),
    color(255, 0, 0)
  };

  void Display(Map map, Player p) {
    DisplayMap(map, p);
  }

  void DisplayLine(Line line, Player p) {
    int playerX = p.x;
    int playerY = p.y;
    float tileSize = 32 * float(width)/float(1280);
    for (var pos : line.indices) {
      int shiftedIndexX = int(pos.x) - (playerX-20);
      int shiftedIndexY = int(pos.y) - (playerY-11);
      float displayX = shiftedIndexX * tileSize;
      float displayY =  shiftedIndexY * tileSize;
      image(highlight, displayX, displayY, tileSize, tileSize);
    }
  }

  void SetupMapImage(Map map) {

    if (map == null)
      return;
    println("setting up");
    pg = createGraphics(map.NX * 32, map.NY * 32);
    pg.beginDraw();
    for (int i = 0; i < map.NX; i++) {
      for (int j = 0; j < map.NY; j++) {

        switch(map.tiles[i][j]) {
        case 1:
          pg.image(road, i*32, j*32);
          break;
        case 2:
          pg.image(sand, i*32, j*32);
          break;
        case 3:
          pg.image(ice, i*32, j*32);
          break;
        case 4:
          pg.image(start, i*32, j*32);
          break;
        case 5:
          pg.image(finish, i*32, j*32);
          break;
        default:
          pg.image(wall, i*32, j*32);
          break;
        }
      }
    }
    pg.endDraw();
  }

  void DisplayMap(Map map, Player p) {
    if (map == null)
      return;

    if (pg == null)
      SetupMapImage(map);

    float scale = float(width)/float(1280);

    pushMatrix();
    translate(-(p.x-20)*32*scale, -(p.y-11)*32*scale);
    image(pg, 0, 0, pg.width * scale, pg.height * scale);
    popMatrix();

    PVector v = new PVector(p.vx, p.vy);

    float dpx = 20 * 32 * scale;
    float dpy = 11 * 32 * scale;

    pushMatrix();
    translate(dpx + 16*scale, dpy+16*scale);
    rotate(v.heading() + radians(90));
    image(car, -16*scale, -16*scale, 32 * scale, 32 * scale);
    popMatrix();
  }
}
