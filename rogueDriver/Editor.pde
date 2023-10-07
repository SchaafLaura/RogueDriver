class EditorScene extends Scene {
  
  Map map;
  
  EditorScene(){
    map = new Map(100, 100);
    
  }
  
  
  
  void Update() {
    HandleInput();
  }
  void Display() {
    background(0);
    map.Display(0, 0, width/map.NX);
  }
  void HandleInput() {
  }
  void Load() {
  }
  void Unload() {
  }
}
