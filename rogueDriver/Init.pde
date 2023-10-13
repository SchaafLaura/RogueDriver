SceneManager sceneManager;
GameManager gameManager;
float scale;
float tileSize;
float tileSize_half;
void Init() {
  scale = 0.5*float(width) / resXNative;
  tileSize = tileSizeNative * scale;
  tileSize_half = tileSize * 0.5;

  sceneManager = new SceneManager(new MainMenuScene(), new GameScene(), new EditorScene(), new HighscoreScene());
  gameManager = new GameManager();
}
