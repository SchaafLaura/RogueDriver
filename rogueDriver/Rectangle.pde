// axis aligned rect
class Rectangle {
  float x, y;
  float w, h;

  Rectangle(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  boolean IsPointInside(float px, float py) {
    if (px < x)
      return false;
    if (py < y)
      return false;
    if (px > x+w)
      return false;
    if (py > y+h)
      return false;
    return true;
  }

  void DebugDisplay() {
    var currentColorMode = rogueDriver.this.g.colorMode;
    colorMode(RGB);
    noFill();
    stroke(255, 0, 255);
    rect(x, y, w, h);
    colorMode(currentColorMode);
  }
}
