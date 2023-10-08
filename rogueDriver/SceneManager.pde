class SceneManager {
  Scene[] scenes;
  int activeScene = -1;

  SceneManager(Scene... scenes) {
    this.scenes = new Scene[scenes.length];
    for (int i = 0; i < scenes.length; i++)
      this.scenes[i] = scenes[i];
  }

  public void SwitchSceneTo(int newScene, boolean unloadOldScene, boolean reloadNewScene) {
    if (unloadOldScene)
      scenes[activeScene].Unload();

    if (reloadNewScene)
      scenes[newScene].Load();

    activeScene = newScene;
  }
  
  public void HandleInput() {
    if (activeScene == -1)
      return;
    scenes[activeScene].HandleInput();
  }

  public void Update() {
    if (activeScene == -1)
      return;
    scenes[activeScene].Update();
  }

  public void Display() {
    if (activeScene == -1)
      return;
    scenes[activeScene].Display();
  }
}

abstract class Scene {
  abstract void Update();
  abstract void Display();
  abstract void HandleInput();
  abstract void Load();
  abstract void Unload();
}
