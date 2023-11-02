SceneManager sceneManager;
GameManager gameManager;
float scale;
float tileSize;
float tileSize_half;
void Init() {
  scale = zoomLevel * float(width) / resXNative;
  tileSize = tileSizeNative * scale;
  tileSize_half = tileSize * 0.5;

  sceneManager = new SceneManager(this,
    new MainMenuScene(),
    new GameScene(),
    new EditorScene(),
    new HighscoreScene(),
    new MapSelectionLocalScene(),
    new MapSelectionOnlineScene()
    );
  gameManager = new GameManager();
}
