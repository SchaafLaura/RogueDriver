boolean escDown = false;
void keyPressed() {
  if (keyCode == ESC) {
    key = 0;
    escDown = true;
  }
  /*
  if (sceneManager.activeScene == EDITOR_SCENE_INDEX && key == 's')
    selectOutput("Select a file to write to:", "SaveMap");
  */
  
  /*
  if (sceneManager.activeScene == EDITOR_SCENE_INDEX && key == 'l')
    selectInput("Select a track to edit:", "LoadTrackToEditorAndSwitchScene");
  */
}

void keyReleased() {
  if (keyCode == ESC) {
    key = 0;
    escDown = false;
  }
}
