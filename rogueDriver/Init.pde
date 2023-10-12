SceneManager sceneManager;

float scale;
float tileSize;
void Init() {
  scale = float(width) / resXNative;
  tileSize = tileSizeNative * scale;

  sceneManager = new SceneManager();
}
