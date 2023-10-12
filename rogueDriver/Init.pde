SceneManager sceneManager;
GameManager gameManager;
float scale;
float tileSize;
void Init() {
  scale = float(width) / resXNative;
  tileSize = tileSizeNative * scale;

  sceneManager = new SceneManager(new MainMenuScene(), new GameScene(), new EditorScene());
  gameManager = new GameManager();
}
