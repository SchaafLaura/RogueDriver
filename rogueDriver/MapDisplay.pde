class MapDisplay {
  PImage car = loadImage("car.png");
  PImage finish = loadImage("finish.png");
  PImage start = loadImage("start.png");
  PImage road = loadImage("road.png");
  PImage ice = loadImage("ice.png");
  PImage sand = loadImage("sand.png");
  PImage wall = loadImage("wall.png");
  PImage highlight = loadImage("highlight.png");

  MapDisplay() {
    car.resize((int)tileSize, (int)tileSize);
    finish.resize((int)tileSize, (int)tileSize);
    start.resize((int)tileSize, (int)tileSize);
    road.resize((int)tileSize, (int)tileSize);
    ice.resize((int)tileSize, (int)tileSize);
    sand.resize((int)tileSize, (int)tileSize);
    wall.resize((int)tileSize, (int)tileSize);
    highlight.resize((int)tileSize, (int)tileSize);
  }

  PGraphics mapImage;

  void DisplayLine(Line line, Player p) {
    int playerX = p.x;
    int playerY = p.y;
    for (var pos : line.indices) {
      int shiftedIndexX = int(pos.x) - (playerX-20);
      int shiftedIndexY = int(pos.y) - (playerY-11);
      float displayX = shiftedIndexX * tileSize;
      float displayY =  shiftedIndexY * tileSize;
      image(highlight, displayX, displayY);
    }
  }

  void DisplayMap(Map map, Player p, ArrayList<Ghost> ghosts) {
    if (map == null)
      return;
    if (mapImage == null)
      SetupMapImage(map);


    pushMatrix();
    translate(-(p.x-20)*tileSize, -(p.y-11)*tileSize);
    image(mapImage, 0, 0);
    popMatrix();

    PVector v = new PVector(p.vx, p.vy);

    float dpx = 20 * tileSize;
    float dpy = 11 * tileSize;

    pushMatrix();
    translate(dpx + tileSize_half, dpy + tileSize_half);
    rotate(v.heading() + radians(90));
    image(car, -tileSize_half, -tileSize_half);
    popMatrix();

    tint(80, 80, 200, 100);
    for (var g : ghosts) {
      PVector ghostV = new PVector(g.vx, g.vy);
      int ghostOffsetX = -g.x + p.x;
      int ghostOffsetY = -g.y + p.y;
      float gdpx = (20 - ghostOffsetX) * tileSize;
      float gdpy = (12 - ghostOffsetY) * tileSize;

      pushMatrix();
      translate(gdpx + tileSize_half, gdpy - tileSize_half);
      rotate(ghostV.heading() + radians(90));
      image(car, -tileSize_half, -tileSize_half);
      popMatrix();
    }
    noTint();
  }

  void SetupMapImage(Map map) {
    if (map == null)
      return;
    println("setting up");
    mapImage = createGraphics(int(map.NX * tileSize), int(map.NY * tileSize));
    mapImage.beginDraw();
    for (int i = 0; i < map.NX; i++) {
      for (int j = 0; j < map.NY; j++) {

        switch(map.tiles[i][j]) {
        case 1:
          mapImage.image(road, i*tileSize, j*tileSize);
          break;
        case 2:
          mapImage.image(sand, i*tileSize, j*tileSize);
          break;
        case 3:
          mapImage.image(ice, i*tileSize, j*tileSize);
          break;
        case 4:
          mapImage.image(start, i*tileSize, j*tileSize);
          break;
        case 5:
          mapImage.image(finish, i*tileSize, j*tileSize);
          break;
        default:
          mapImage.image(wall, i*tileSize, j*tileSize);
          break;
        }
      }
    }
    mapImage.endDraw();
  }
}
