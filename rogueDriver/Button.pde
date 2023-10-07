class Button {
  String label;
  Rectangle boundingBox;
  Runnable function;

  Button(String label, Rectangle boundingBox, Runnable function) {
    this.label = label;
    this.boundingBox = boundingBox;
    this.function = function;
  }

  void Display() {
    noStroke();
    boolean isMouseOver = boundingBox.IsPointInside(mouseX, mouseY);
    fill(isMouseOver ? 100 : 50);
    rect(boundingBox.x, boundingBox.y, boundingBox.w, boundingBox.h);
    fill(isMouseOver ? 200 : 100);
    textAlign(CENTER, CENTER);
    text(label, boundingBox.x + boundingBox.w/2.0, boundingBox.y+boundingBox.h/2.0);
  }

  void OnClick() {
    function.run();
  }

  void TryClick() {
    if (!mousePressed)
      return;
    if (!boundingBox.IsPointInside(mouseX, mouseY))
      return;
    OnClick();
  }
}
