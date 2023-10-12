class GameScene extends Scene {
  Map map;
  void Update() {
  }
  void Display() {
    if (map == null)
      return;
    image(map.img, 0, 0);
  }
  void HandleInput() {
  }
  void Load() {
  }
  void Unload() {
  }

  void HandleMouseWheel(float turn) {
  }

  void LoadMapFromTileData(int[][] tileData) {
    this.map = new Map(tileData);
  }

  void SetupPlayerOnCurrentMap() {
    var mapStartingPoint = map.GetStart();
  }
}
