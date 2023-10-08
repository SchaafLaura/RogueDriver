class Button {
  String label;
  Rectangle boundingBox;
  Runnable function;

  color normalColor = color(50, 50, 50);
  color highlightColor = color(100, 100, 100);

  color normalTextColor = color(100, 100, 100);
  color highlightTextColor = color(200, 200, 200);

  int frameLastClicked = -1;

  Button(String label, Rectangle boundingBox, Runnable function) {
    this.label = label;
    this.boundingBox = boundingBox;
    this.function = function;
  }

  void Display() {
    noStroke();
    boolean isMouseOver = boundingBox.IsPointInside(mouseX, mouseY);
    fill(isMouseOver ? highlightColor : normalColor);
    rect(boundingBox.x, boundingBox.y, boundingBox.w, boundingBox.h);
    fill(isMouseOver ? highlightTextColor : normalTextColor);
    textAlign(CENTER, CENTER);
    text(label, boundingBox.x + boundingBox.w/2.0, boundingBox.y+boundingBox.h/2.0);
  }

  void OnClick() {
    frameLastClicked = frameCount;
    function.run();
    mouseButton = 0;
  }

  void TryClick() {
    if (!mousePressed)
      return;
    if (mouseButton != 37)
      return;
    if (frameCount <= frameLastClicked+1)
      return;
    if (!boundingBox.IsPointInside(mouseX, mouseY))
      return;
    OnClick();
  }
}
