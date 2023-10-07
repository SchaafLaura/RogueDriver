SceneManager sceneManager;

void setup(){
  fullScreen();
  sceneManager = new SceneManager();
}

void draw(){
  sceneManager.Display();
  println("doing ok");
}
