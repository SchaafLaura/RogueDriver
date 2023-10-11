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

  PGraphics pg = createGraphics(1280, 720);
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

  void DisplayLine(Line line) {
    int playerX = ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).player.x;
    int playerY = ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).player.y;
    pg.beginDraw();
    for (var p : line.indices) {
      int shiftedIndexX = int(p.x) - (playerX-20);
      int shiftedIndexY = int(p.y) - (playerY-11);

      float displayX = shiftedIndexX * 32;
      float displayY =  shiftedIndexY * 32;
      println(displayX);

      pg.image(highlight, displayX, displayY);
    }
    pg.endDraw();
  }

  void DisplayTracks(float scale) {
    /*
    if (tracks == null)
     return;
     fill(trackColor);
     for (var t : tracks)
     square(t.x*scale, t.y*scale, scale);*/
  }

  void DisplayMap(Map map, float x, float y, float scale) {
    if (map == null)
      return;

    pg.beginDraw();

    int playerX = ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).player.x;
    int playerY = ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).player.y;

    int playerVX = ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).player.vx;
    int playerVY = ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).player.vy;
    PVector pv = new PVector(playerVX, playerVY);


    for (int i = playerX - 20; i < playerX + 20; i++) {
      for (int j = playerY - 11; j < playerY + 12; j++) {
        int shiftedIndexX = i - (playerX-20);
        int shiftedIndexY = j - (playerY-11);

        float displayX = x + shiftedIndexX * 32;
        float displayY = y + shiftedIndexY * 32;



        if (i < 0 || i > map.NX - 1 || j < 0 || j > map.NY - 1) {
          pg.image(wall, displayX, displayY);
          continue;
        }

        switch(map.tiles[i][j]) {
        case 1:
          pg.image(road, displayX, displayY);
          break;
        case 2:
          pg.image(sand, displayX, displayY);
          break;
        case 3:
          pg.image(ice, displayX, displayY);
          break;
        case 4:
          pg.image(start, displayX, displayY);
          break;
        case 5:
          pg.image(finish, displayX, displayY);
          break;
        default:
          pg.image(wall, displayX, displayY);
          break;
        }
        if (i == playerX && j == playerY) {

          pg.pushMatrix();
          pg.translate(displayX + 16, displayY+16);
          pg.rotate(pv.heading() + radians(90));
          pg.image(car, -16, -16);

          pg.popMatrix();
        }
      }
    }
    pg.endDraw();
    
    /*
    if (map == null)
     return;
     for (int i = 0; i < map.NX; i++) {
     for (int j = 0; j < map.NY; j++) {
     fill(colors[map.tiles[i][j]]);
     square(x + i * scale, y + j * scale, scale);
     }
     }*/
  }
}
