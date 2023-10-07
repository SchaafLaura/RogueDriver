class Button {
  String label;
  Rectangle boundingBox;
  Runnable function;
  
  color normalColor = color(50, 50, 50);
  color highlightColor = color(100, 100, 100);
  
  color normalTextColor = color(100, 100, 100);
  color highlightTextColor = color(200, 200, 200);

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
