
class Line {
  ArrayList<PVector> indices;
  int x1_original;
  int y1_original;
  int x0_original;
  int y0_original;
  public Line(int x1_, int y1_, int x0_, int y0_) {
    this.x1_original = x1_;
    this.y1_original = y1_;
    this.x0_original = x0_;
    this.y0_original = y0_;
    indices = new ArrayList<PVector>();
    makeIndices(x1_, y1_, x0_, y0_);
    sortIndices();
  }

  void makeIndices(int x1, int y1, int x0, int y0) {
    int dx = abs(x1-x0);
    int dy = -abs(y1-y0);
    int sx = x0 < x1 ? 1 : -1;
    int sy = y0 < y1 ? 1 : -1;
    int err = dx+dy;
    while (true) {
      PVector p = new PVector(x0, y0);
      if (!indices.contains(p)) {
        indices.add(p);
      }
      if (x0 == x1 && y0 == y1) {
        break;
      }
      int e2 = 2 * err;
      if (e2 >= dy) {
        err += dy;
        x0 += sx;
      }
      if (e2 <= dx) {
        err += dx;
        y0 += sy;
      }
    }
  }

  void sortIndices() {
    ArrayList<PVector> newindices = new ArrayList<PVector>();
    newindices.add(new PVector(x1_original, y1_original));
    while (!indices.isEmpty()) {
      int lowestDistanceIndex = -1;
      float record = 100;
      for (int i = 0; i < indices.size(); i++) {
        if (newindices.get(newindices.size()-1).dist(indices.get(i)) < record) {
          record = newindices.get(newindices.size()-1).dist(indices.get(i));
          lowestDistanceIndex = i;
        }
      }
      if (newindices.size() == 0 || (indices.get(lowestDistanceIndex).x != newindices.get(newindices.size()-1).x || indices.get(lowestDistanceIndex).y != newindices.get(newindices.size()-1).y))
        newindices.add(indices.get(lowestDistanceIndex));
      indices.remove(lowestDistanceIndex);
    }

    indices = newindices;
  }

  void reduceRange(int r) {
    while (indices.get(0).dist(indices.get(indices.size()-1)) > r) {
      indices.remove(indices.size() - 1);
    }
  }
}

PImage TileDataToImg(int[][] tileData) {
  PImage ret = new PImage(tileData.length, tileData[0].length);
  HashMap<Integer, Integer> colorsToIndices = new HashMap<Integer, Integer>();
  for (int i = 0; i < mapColors.length; i++)
    colorsToIndices.put(i, mapColors[i]);

  ret.loadPixels();
  for (int i = 0; i < ret.width; i++) {
    for (int j = 0; j < ret.height; j++) {
      ret.pixels[i + j*ret.width] = colorsToIndices.get(tileData[i][j]);
    }
  }
  ret.updatePixels();
  return ret;
}

int[][] ImgToTileData(PImage img) {
  HashMap<Integer, Integer> colorsToIndices = new HashMap<Integer, Integer>();
  for (int i = 0; i < mapColors.length; i++)
    colorsToIndices.put(mapColors[i], i);
  int[][] ret = new int[img.width][img.height];
  for (int i = 0; i < img.width; i++) {
    for (int j = 0; j < img.height; j++) {
      ret[i][j] = colorsToIndices.get(img.get(i, j));
    }
  }
  return ret;
}
