class GameManager {
  Map GetMap() {
    if (sceneManager.activeScene == GAME_SCENE_INDEX)
      return ((GameScene)sceneManager.scenes[GAME_SCENE_INDEX]).map;
    else if (sceneManager.activeScene == EDITOR_SCENE_INDEX)
      return ((EditorScene)sceneManager.scenes[ EDITOR_SCENE_INDEX]).map;
    return null;
  }

  Move GetMoveFromCurrentKey(Player p, int dvx, int dvy) {
    Move move = null;

    if (key == '#')
      move = new SwitchEngine();

    if (key == '-' && p.gear > 0)
      move = new GearDown();

    if (key == '+' && p.gear < 6)
      move = new GearUp();

    if (keyCode == ENTER)
      move = new SwitchBrake();

    if (key == ' ')
      move = new Steer(dvx, dvy);
    return move;
  }
}
