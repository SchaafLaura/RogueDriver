class SceneManager {
  Scene[] scenes;
  int activeScene = -1;
  LoadingScene loadingScene = new LoadingScene(MAINMENU_SCENE_INDEX, false, false);

  SceneManager(Scene... scenes) {
    this.scenes = new Scene[scenes.length];
    for (int i = 0; i < scenes.length; i++)
      this.scenes[i] = scenes[i];
  }

  public void Load(int newScene, boolean unloadOldScene, boolean reloadNewScene) {
    loadingScene = new LoadingScene(newScene, unloadOldScene, reloadNewScene);
    activeScene = -1;
  }

  private void SwitchSceneTo(int newScene, boolean unloadOldScene, boolean reloadNewScene) {
    if (unloadOldScene)
      scenes[activeScene].Unload();

    if (reloadNewScene)
      scenes[newScene].Load();

    activeScene = newScene;
  }

  public void HandleInput() {
    if (activeScene == -1) {
      loadingScene.HandleInput();
      return;
    }
    scenes[activeScene].HandleInput();
  }

  public void HandleMouseWheel(float turn) {
    if (activeScene == -1) {
      loadingScene.HandleMouseWheel(turn);
      return;
    }
    scenes[activeScene].HandleMouseWheel(turn);
  }

  public void Update() {
    if (activeScene == -1) {
      loadingScene.Update();
      return;
    }
    scenes[activeScene].Update();
  }

  public void Display() {
    if (activeScene == -1) {
      loadingScene.Display();
      return;
    }
    scenes[activeScene].Display();
  }
}

abstract class Scene {
  abstract void Update();
  abstract void Display();
  abstract void HandleInput();
  abstract void HandleMouseWheel(float turn);
  abstract void Load();
  abstract void Unload();
}

class LoadingScene extends Scene {
  int newScene;
  boolean unloadOldScene;
  boolean reloadNewScene;

  boolean waitedOneFrame = false;

  LoadingScene(int newScene, boolean unloadOldScene, boolean reloadNewScene) {
    this.newScene = newScene;
    this.unloadOldScene = unloadOldScene;
    this.reloadNewScene = reloadNewScene;
  }
  void Update() {
    if (!waitedOneFrame) {
      waitedOneFrame = true;
      return;
    }
    sceneManager.SwitchSceneTo(newScene, unloadOldScene, reloadNewScene);
  }
  void Display() {
    background(0);
    fill(255);
    text("LOADING... UwU", width/2, height/2);
  }
  void HandleInput() {
  }
  void HandleMouseWheel(float turn) {
  }
  void Load() {
  }
  void Unload() {
  }
}
