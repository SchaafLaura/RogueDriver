class GameScene extends Scene {
  Map map;
  MapDisplay mapDisplay = new MapDisplay();
  Car player;

  void Update() {
  }
  void Display() {
    background(0);
    if (map == null)
      return;
      
    float scale = float(width)/map.NX;
    mapDisplay.Display(map, 0, 0, scale);
  }
  void HandleInput() {
  }
  void Load() {
  }
  void Unload() {
  }
}
