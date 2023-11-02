class MapSelectionOnlineScene extends Scene {
  //ArrayList<PictureButton> mapButtons;
  ArrayList<Map> maps;

  public void mouseEvent(MouseEvent e) {
  }
  public void keyEvent(KeyEvent e) {
  }

  void Update() {
  }
  void Display() {
    /*if (mapButtons == null)
     return;
     for (var b : mapButtons)
     b.Display();*/
  }

  /*
  void HandleInput() {
   for (var b : mapButtons)
   b.TryClick();
   if (escDown)
   sceneManager.Load(MAINMENU_SCENE_INDEX, false, false);
   }
   */

  /*
  void HandleMouseWheel(float turn) {
   for (var b : mapButtons)
   b.boundingBox.y -= turn * 15;
   }
   */

  void Load() {
    /*
    maps = GetAllMapsFromDatabase();
     
     mapButtons = new ArrayList<PictureButton>();
     
     float x = 10;
     float y = 10;
     float w = 200;
     float h = 200;
     for (var m : maps) {
     PImage pic = m.img;
     Rectangle rect = new Rectangle(x, y, w, h);
     PictureButton pb = new PictureButton(
     pic,
     m.name,
     rect,
     () -> {
     var gameScene = (GameScene)sceneManager.scenes[GAME_SCENE_INDEX];
     gameScene.map = m;
     gameScene.mapDisplay = new MapDisplay();
     gameScene.SetupPlayerOnCurrentMap();
     sceneManager.Load(GAME_SCENE_INDEX, false, false);
     }
     
     );
     mapButtons.add(pb);
     
     x += w + 10;
     if (x+w > width) {
     x = 10;
     y += h + 10;
     }
     }
     
     */
  }
  void Unload() {
  }
}


class MapSelectionLocalScene extends Scene {
  UIContainer buttongroup;
  public void mouseEvent(MouseEvent e) {
    if (e.getAction() != MouseEvent.WHEEL)
      return;
    buttongroup.SetPos(buttongroup.PosX(), buttongroup.PosY() - e.getCount() * 15);
  }
  public void keyEvent(KeyEvent e) {
  }

  void Update() {
  }
  void Display() {
    background(0);
  }


  /*
  void HandleMouseWheel(float turn) {
   for (var b : mapButtons)
   b.boundingBox.y -= turn * 15;
   }*/


  void Load() {
    var mapSelectionUI = new TLMUI();
    buttongroup = new UIContainer();


    String pathToTracks = dataPath("../tracks");
    File folder = new File(pathToTracks);
    FilenameFilter fF = new FilenameFilter() {
      public boolean accept(File dir, String name) {
        return name.toLowerCase().endsWith(".png");
      }
    };
    String[] filenames = folder.list(fF);
    //mapButtons = new ArrayList<PictureButton>();

    float x = 10;
    float y = 10;
    float w = 200;
    float h = 200;
    for (var fileName : filenames) {
      String dataPath = sketchPath("tracks\\") + fileName;
      PImage pic = loadImage(dataPath);
      Rectangle rect = new Rectangle(x, y, w, h);
      File track = new File(dataPath);
      PictureButton pb = new PictureButton(
        fileName,
        rect,
        pic,
        () -> {
        LoadTrackToLevelAndSwitchScene(track);
      }

      );
      buttongroup.AddChild(pb);

      x += w + 10;
      if (x+w > width) {
        x = 10;
        y += h + 10;
      }
    }
    mapSelectionUI.AddChild(buttongroup);
    
    SetUI(mapSelectionUI);
  }
  void Unload() {
  }
}

class PictureButton extends Button {
  PImage image;
  public PictureButton(String label, Rectangle extents, PImage image, Runnable function) {
    super(label, extents, function);
    this.image = image;
  }

  Boolean OnMouseEvent(MouseEvent e) {
    if (!(e.getAction() == MouseEvent.RELEASE))
      return false;

    float xOff = 0;
    float yOff = 0;
    if (GetParent() != null) {
      xOff = GetParent().PosX();
      yOff = GetParent().PosY();
    }
    if (!extents.IsInside(e.getX() - xOff, e.getY() - yOff))
      return false;


    if (function != null)
      function.run();
    return true;
  }

  public void DisplaySelf(float x, float y) {
    if (extents == null)
      return;

    var theme = (GetRoot()).theme;

    Boolean mouseInside = false;
    float xOff = 0;
    float yOff = 0;
    if (GetParent() != null) {
      xOff = GetParent().PosX();
      yOff = GetParent().PosY();
    }
    if (extents.IsInside(mouseX - xOff, mouseY - yOff))
      mouseInside = true;

    //stroke(theme.buttonOutlineColor);
    //fill(mouseInside ? theme.buttonHighlightColor : theme.buttonFillColor);
    //

    image(image, x, y, extents.w, extents.h);

    strokeWeight(mouseInside ? 5 : 1);
    stroke(mouseInside ? color(255, 0, 255) : 255);
    noFill();
    rect(x, y, extents.w, extents.h);


    textAlign(CENTER, CENTER);
    fill(theme.buttonLabelColor);
    text(label, x + extents.w/2, y + extents.h/2);
  }
}
