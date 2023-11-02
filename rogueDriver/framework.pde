class Button extends UIElement implements IMouseInteractable {
  private Rectangle extents;
  Runnable function;

  public Button(String label, Rectangle extents, Runnable function) {
    this.label = label;
    this.extents = extents;
    this.function = function;
    SetPos(extents.x, extents.y);
  }

  Boolean OnMouseEvent(MouseEvent e) {
    if (!(/*e.getAction() == MouseEvent.CLICK || */e.getAction() == MouseEvent.RELEASE))
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

    stroke(theme.buttonOutlineColor);
    fill(mouseInside ? theme.buttonHighlightColor : theme.buttonFillColor);
    rect(x, y, extents.w, extents.h);
    textAlign(CENTER, CENTER);
    fill(theme.buttonLabelColor);
    text(label, x + extents.w/2, y + extents.h/2);
  }

  public void UpdateSelf() {
  }

  // GETTERS AND SETTERS
}


class Checkbox extends UIElement implements IMouseInteractable {
  private Rectangle extents;
  private Boolean active = false;

  public Checkbox(Rectangle extents) {
    this.extents = extents;
    SetPos(extents.x, extents.y);
  }

  Boolean OnMouseEvent(MouseEvent e) {
    /*if (e.getAction() != MouseEvent.CLICK)
     return false;*/

    if (e.getAction() != MouseEvent.RELEASE)
      return false;



    float xOff = 0;
    float yOff = 0;
    if (GetParent() != null) {
      xOff = GetParent().PosX();
      yOff = GetParent().PosY();
    }
    if (!extents.IsInside(e.getX() - xOff, e.getY() - yOff))
      return false;

    active = !active;
    return true;
  }

  void DisplaySelf(float x, float y) {
    if (extents == null)
      return;

    var theme = (GetRoot()).theme;

    stroke(theme.checkboxOutlineColor);
    fill(theme.checkboxFillColor);
    rect(x, y, extents.w, extents.h);
    if (!active)
      return;
    stroke(theme.checkboxCheckColor);
    line(x + 2, y + 2, x + 2 + (extents.w-4), y + 2 + (extents.h-4));
    line(x + 2, y + 2 + (extents.h-4), x + 2 + (extents.w-4), y + 2);
  }
  void UpdateSelf() {
  }

  // GETTERS AND SETTERS
  Boolean IsActive() {
    return active;
  }

  public void SetActive(Boolean value) {
    active = value;
  }
}


class Dropdown<T> extends UIElement implements IMouseInteractable {
  private ArrayList<T> items;
  private IObjectDisplayer<T> itemDisplayer;
  private IObjectSelecter<T> itemSelecter;
  private Rectangle extentsSelf;
  private Rectangle extentsItem;

  private T selectedItem;

  private Boolean dropped = false;

  public Dropdown(ArrayList<T> items, Rectangle extentsSelf, Rectangle extentsItem, IObjectDisplayer<T> itemDisplayer, IObjectSelecter<T> itemSelecter) {
    this.items = items;
    this.itemDisplayer = itemDisplayer;
    this.itemSelecter = itemSelecter;
    this.extentsSelf = extentsSelf;
    this.extentsItem = extentsItem;

    SetPos(extentsSelf.x, extentsSelf.y);
  }

  public Boolean OnMouseEvent(MouseEvent e) {
    float xOff = 0;
    float yOff = 0;
    if (GetParent() != null) {
      xOff = GetParent().PosX();
      yOff = GetParent().PosY();
    }

    if (e.getAction() == MouseEvent.RELEASE && extentsSelf.IsInside(e.getX() - xOff, e.getY() - yOff)) {
      dropped = !dropped;
      if (dropped)
        GetParent().MoveToTop(this);
      return true;
    }

    int optionMouseIsOver = OptionFromPosition(e.getX() - xOff, e.getY() - yOff);

    if (dropped && !extentsSelf.IsInside(e.getX() - xOff, e.getY() - yOff) && (optionMouseIsOver==-1)) {
      dropped = false;
      return true;
    }

    if (dropped && e.getAction() == MouseEvent.RELEASE && optionMouseIsOver != -1) {
      selectedItem = items.get(optionMouseIsOver);
      OnItemSelected();
      dropped = false;
      return true;
    }




    return false;
  }

  public void UpdateSelf() {
  }

  private int OptionFromPosition(float posx, float posy) {
    for (int i = 1; i < items.size() + 1; i++) {
      Rectangle displayRect = new Rectangle(extentsSelf.x, extentsSelf.y + i * extentsItem.h, extentsItem.w, extentsItem.h);
      if (displayRect.IsInside(posx, posy))
        return i-1;
    }
    return -1;
  }

  public void DisplaySelf(float x, float y) {
    var theme = (GetRoot()).theme;


    fill(theme.dropdownSelfFillColor);
    stroke(theme.dropdownSelfOutlineColor);
    rect(x, y, extentsSelf.w, extentsSelf.h);
    Rectangle selectedItemPosition = new Rectangle(x, y, extentsSelf.w, extentsSelf.h);
    itemDisplayer.Display(selectedItem, selectedItemPosition);


    float triangleSidelength = extentsSelf.h/2;
    float triangleHeight = 0.5*sqrt(3)*triangleSidelength;
    float margin = 3;
    float x1 = x + extentsSelf.w - margin - triangleSidelength;
    float x2 = x1 + triangleSidelength;
    float x3 = x1 + triangleSidelength/2;
    float y1 = y + margin + triangleHeight/2;
    float y2 = y1;
    float y3 = y1 + triangleHeight;

    fill(theme.dropdownTriangleFillColor);
    stroke(theme.dropdownTriangleOutlineColor);
    triangle(x1, y1, x2, y2, x3, y3);


    if (!dropped)
      return;

    int i = 0;
    for (T item : items) {
      Rectangle displayRect = new Rectangle(x, y + (++i) * extentsItem.h, extentsItem.w, extentsItem.h);
      fill(theme.dropdownItemFillColor);
      stroke(theme.dropdownItemOutlineColor);
      rect(displayRect.x, displayRect.y, displayRect.w, displayRect.h);
      itemDisplayer.Display(item, displayRect);
    }
  }

  private void OnItemSelected() {
    itemSelecter.OnSelect(selectedItem);
  }
}


class InputField extends UIElement implements ICapturesKeyboardOnClick {
  private Rectangle extents;
  private String value;
  private String allowedCharacters = "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789ß-.,;:_#+~*?=()/&%$§!@€µ<>|²³{[]}\\";
  private Boolean captured = false;

  public InputField(String defaultValue, String allowedCharacters, Rectangle extents) {
    this.extents = extents;
    if (allowedCharacters != null)
      this.allowedCharacters = allowedCharacters;
    this.value = defaultValue;
    SetPos(extents.x, extents.y);
  }

  public void SetCaptured(Boolean val) {
    captured = val;
  }

  public Boolean OnMouseEvent(MouseEvent e) {
    if (e.getAction() != MouseEvent.CLICK)
      return false;

    float xOff = 0;
    float yOff = 0;
    if (GetParent() != null) {
      xOff = GetParent().PosX();
      yOff = GetParent().PosY();
    }
    if (!extents.IsInside(e.getX() - xOff, e.getY() - yOff)) {
      UnCapture();
      return false;
    }
    return true;
  }

  public Boolean OnKeyEvent(KeyEvent e) {
    if (!captured)
      return false;
    if (e.getAction() != KeyEvent.TYPE)
      return false;

    if (e.getKey() == BACKSPACE && value.length() > 0) {
      value = value.substring(0, value.length()-1);
      return true;
    }

    if (allowedCharacters.indexOf(e.getKey()) == -1)
      return false;
    value += e.getKey();
    return true;
  }

  public void UpdateSelf() {
    if ((!GetVisible() || !GetParent().GetVisible()) &&
      GetRoot().keyboardCapturingElement != null &&
      GetRoot().keyboardCapturingElement == this) {
      UnCapture();
    }
  }

  public void UnCapture() {
    GetRoot().keyboardCapturingElement = null;
    captured = false;
  }

  public void DisplaySelf(float x, float y) {
    if (extents == null)
      return;

    var theme = (GetRoot()).theme;
    fill(theme.inputfieldFillColor);
    stroke(theme.inputfieldOutlineColor);
    rect(x, y, extents.w, extents.h);
    fill(theme.inputfieldTextColor);
    textAlign(LEFT, CENTER);
    String blinkingLine = captured ? "|" : "";
    if (frameCount % 30 < 15)
      blinkingLine = "";
    text(value + blinkingLine, x + 5, y + extents.h/2);
  }
}


interface IObjectSelecter<T> {
  public void OnSelect(T objectToUse);
}
interface IObjectDisplayer<T> {
  public void Display(T displayObject, Rectangle displayRect);
}
interface IDisplayable {
  public void Display();
}
interface IUpdateable {
  public void Update();
}
interface IMouseInteractable {
  public Boolean OnMouseEvent(MouseEvent e);
}
interface IKeyInteractable {
  public Boolean OnKeyEvent(KeyEvent e);
}
interface ICapturesKeyboardOnClick extends IKeyInteractable, IMouseInteractable {
  public void SetCaptured(Boolean val);
  public void UnCapture();
}

public class SceneManager {
  Scene[] scenes;
  int activeScene = -1;
  LoadingScene loadingScene = new LoadingScene(0, false, false);
  private PApplet p;

  SceneManager(PApplet p, Scene... scenes) {
    this.p = p;
    this.scenes = new Scene[scenes.length];

    for (int i = 0; i < scenes.length; i++) {
      scenes[i].SetManager(this);
      this.scenes[i] = scenes[i];
    }
    loadingScene.SetManager(this);

    RegisterMouse();
    RegisterKeyboard();
  }

  private void RegisterMouse() {
    p.registerMethod("mouseEvent", this);
  }

  private void RegisterKeyboard() {
    p.registerMethod("keyEvent", this);
  }

  public void Load(int newScene, boolean unloadOldScene, boolean reloadNewScene) {
    loadingScene.Reset();
    loadingScene.newScene = newScene;
    loadingScene.unloadOldScene = unloadOldScene;
    loadingScene.reloadNewScene = reloadNewScene;
    activeScene = -1;
  }

  private void SwitchSceneTo(int newScene, boolean unloadOldScene, boolean reloadNewScene) {
    if (unloadOldScene)
      scenes[activeScene].Unload();

    if (reloadNewScene)
      scenes[newScene].Load();

    activeScene = newScene;
  }

  public void mouseEvent(MouseEvent e) {
    if (activeScene == -1)
      return;
    scenes[activeScene].mouseEvent(e);
    if (scenes[activeScene].ui != null)
      scenes[activeScene].ui.mouseEvent(e);
  }

  public void keyEvent(KeyEvent e) {
    if (activeScene == -1)
      return;
    scenes[activeScene].keyEvent(e);
    if (scenes[activeScene].ui != null)
      scenes[activeScene].ui.keyEvent(e);
  }

  public void Update() {
    if (activeScene == -1) {
      loadingScene.Update();
      return;
    }
    scenes[activeScene].Update();
    if (scenes[activeScene].ui != null)
      scenes[activeScene].ui.Update();
  }

  public void Display() {
    if (activeScene == -1) {
      loadingScene.Display();
      return;
    }
    scenes[activeScene].Display();
    if (scenes[activeScene].ui != null)
      scenes[activeScene].ui.Display();
  }
}

final class EmptyScene extends Scene {
  void Update() {
  }
  void Display() {
  }
  void Load() {
  }
  void Unload() {
  }
  void mouseEvent(MouseEvent e) {
  }
  void keyEvent(KeyEvent e) {
  }
}

abstract class Scene {
  protected TLMUI ui;
  protected SceneManager managerReference;
  public final void SetManager(SceneManager mngr) {
    this.managerReference = mngr;
  }
  public final void SetUI(TLMUI ui) {
    this.ui = ui;
  }
  abstract void Update();
  abstract void Display();
  abstract void Load();
  abstract void Unload();
  abstract void mouseEvent(MouseEvent e);
  abstract void keyEvent(KeyEvent e);
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

  public void Reset() {
    waitedOneFrame = false;
  }

  void Update() {
    if (!waitedOneFrame) {
      waitedOneFrame = true;
      return;
    }

    managerReference.SwitchSceneTo(newScene, unloadOldScene, reloadNewScene);
  }
  void Display() {
    background(0);
    fill(255);
    text("LOADING... UwU", width/2, height/2);
  }
  public void mouseEvent(MouseEvent e) {
    return;
  }
  public void keyEvent(KeyEvent e) {
    return;
  }
  void Load() {
  }
  void Unload() {
  }
}


class Slider extends UIElement implements IMouseInteractable {
  private Rectangle extents;
  private Rectangle handleExtents;

  private float valueMin, valueMax;
  private float value;

  public Slider(Rectangle extents, float valueMin, float valueMax, float value) {
    this.extents = extents;
    this.valueMin = valueMin;
    this.valueMax = valueMax;
    this.value = value;
    this.handleExtents = new Rectangle(0, 0, extents.h * 1.25, extents.h * 1.25);
    SetPos(extents.x, extents.y);
  }

  public void UpdateSelf() {
    float x = map(value, valueMin, valueMax, extents.x, extents.x + extents.w);
    float y = extents.y;

    handleExtents.x = x;
    handleExtents.y = y;
    return;
  }

  public float GetValue() {
    return value;
  }

  public void DisplaySelf(float x, float y) {
    if (extents == null)
      return;
    if (handleExtents == null)
      return;

    var theme = (GetRoot()).theme;

    stroke(theme.sliderOutlineColor);
    fill(theme.sliderFillColor);
    rect(extents.x, extents.y, extents.w, extents.h);

    stroke(theme.sliderHandleOutlineColor);
    fill(theme.sliderHandleFillColor);
    rect(handleExtents.x-handleExtents.h/2, handleExtents.y-handleExtents.h/2+extents.h/2 + 0.5, handleExtents.w, handleExtents.h);
    return;
  }

  Boolean OnMouseEvent(MouseEvent e) {
    float xOff = 0;
    float yOff = 0;
    if (GetParent() != null) {
      xOff = GetParent().PosX();
      yOff = GetParent().PosY();
    }

    Boolean handled = false;
    float inSliderX = e.getX() - xOff;
    float inSliderY = e.getY() - yOff;

    if (extents.IsInside(inSliderX, inSliderY)) {
      if ((e.getAction() == MouseEvent.CLICK || e.getAction() == MouseEvent.PRESS || e.getAction() == MouseEvent.DRAG)) {
        float newValue = map(inSliderX, extents.x, extents.x + extents.w, valueMin, valueMax);
        value = newValue;
        handled = true;
      }
    }
    return handled;
  }
}

final public class TLMUI {
  private UIContainer root;

  public TLMUI() {
    root = new UIContainer();
    root.label = "root";
  }

  public void SetTheme(UITheme theme) {
    root.theme = theme;
  }

  public void mouseEvent(MouseEvent e) {
    root.OnMouseEvent(e);
  }

  public void keyEvent(KeyEvent e) {
    root.OnKeyEvent(e);
  }

  public void AddChild(UIElement child) {
    root.AddChild(child);
  }

  public void Display() {
    root.Display();
  }

  public void Update() {
    root.Update();
  }
}

class UIContainer extends UIElement {
  public UITheme theme = new UITheme();
  public ICapturesKeyboardOnClick keyboardCapturingElement;

  public UIContainer() {
    SetSuppressChildren(true);
    SetVisible(false);
    SetSuppressChildren(false);
  }

  public Boolean OnKeyEvent(KeyEvent e) {
    var children = GetChildren();
    if (children == null)
      return false;

    if (keyboardCapturingElement != null) {
      if (keyboardCapturingElement.OnKeyEvent(e))
        return true;
    }

    for (int i = children.size() - 1; i >= 0; i--) {
      var child = children.get(i);
      if (child.GetVisible() && child instanceof IKeyInteractable)
        if (((IKeyInteractable)child).OnKeyEvent(e))
          return true;
    }
    return false;
  }

  public Boolean OnMouseEvent(MouseEvent e) {
    var children = GetChildren();
    if (children == null)
      return false;

    if (keyboardCapturingElement != null) {
      if (keyboardCapturingElement.OnMouseEvent(e))
        return true;
    }


    for (int i = children.size() - 1; i >= 0; i--) {
      var child = children.get(i);
      if (child.GetVisible() && child instanceof IMouseInteractable) {
        Boolean mouseHandled = ((IMouseInteractable)child).OnMouseEvent(e);
        if (mouseHandled) {
          if (e.getAction() == MouseEvent.CLICK && child instanceof ICapturesKeyboardOnClick) {
            child.GetRoot().keyboardCapturingElement = (ICapturesKeyboardOnClick) child;
            ((ICapturesKeyboardOnClick)child).SetCaptured(true);
          }
          return true;
        }
      }
    }

    if (e.getAction() == MouseEvent.CLICK) {
      if (GetParent() != null && GetRoot().keyboardCapturingElement != null) {
        GetRoot().keyboardCapturingElement.SetCaptured(false);
        GetRoot().keyboardCapturingElement = null;
        return true;
      } else if (GetParent() == null && keyboardCapturingElement != null) {
        keyboardCapturingElement.SetCaptured(false);
        keyboardCapturingElement = null;
        return true;
      }
    }
    return false;
  }

  public void UpdateSelf() {
    return;
  }
  public void DisplaySelf(float x, float y) {
    return;
  }
}


abstract class UIElement implements IUpdateable, IDisplayable {
  private float posX, posY;
  public String label;
  private ArrayList<UIElement> children;
  private UIElement parent;
  private Boolean suppressChildren = false;
  private Boolean isVisible = true;

  abstract public void UpdateSelf();
  abstract public void DisplaySelf(float x, float y);

  final public void Update() {
    UpdateSelf();
    if (!HasChildren() || GetSuppressChildren())
      return;

    for (var child : children)
      child.Update();
  }

  final public void Display() {
    if (isVisible)
      DisplaySelf(PosX(), PosY());
    if (!HasChildren() || GetSuppressChildren())
      return;
    for (var child : GetChildren())
      child.Display();
  }


  final public void MoveToTop(UIElement ele) {
    if (!children.contains(ele))
      return;
    children.remove(ele);
    children.add(ele);
  }

  final public void RemoveChild(UIElement toDelete) {
    if (children == null)
      return;
    if (toDelete == null)
      return;
    children.remove(toDelete);
  }

  final public void AddChild(UIElement newChild) {
    if (newChild == null)
      return;
    newChild.SetParent(this);
    if (children == null)
      children = new ArrayList<UIElement>();
    children.add(newChild);
  }

  final public UIContainer GetRoot() {
    var p = this.parent;
    while (p.parent != null)
      p = p.parent;
    return (UIContainer) p;
  }

  // PROPERTY-LIKE THINGS
  final public Boolean HasChildren() {
    return (children != null);
  }

  public void SetPos(float x, float y) {
    posX = x;
    posY = y;
  }

  final public Float PosY() {
    if (parent == null)
      return posY;
    return parent.PosY() + posY;
  }

  final public Float PosX() {
    if (parent == null)
      return posX;
    return parent.PosX() + posX;
  }

  // GETTERS AND SETTERS
  final public Boolean GetVisible() {
    return isVisible;
  }

  final public void SetVisible(Boolean value) {
    isVisible = value;
    if (!HasChildren() || GetSuppressChildren())
      return;
    for (var child : GetChildren())
      child.SetVisible(value);
  }

  final public void SetParent(UIElement newParent) {
    parent = newParent;
  }

  final public UIElement GetParent() {
    return parent;
  }

  final public ArrayList<UIElement> GetChildren() {
    return children;
  }

  final public Boolean GetSuppressChildren() {
    return suppressChildren;
  }

  final public void SetSuppressChildrenBypassChildSuppression(Boolean value) {
    suppressChildren = value;
    if (!HasChildren() || GetSuppressChildren())
      return;
    for (var child : children)
      child.SetSuppressChildrenBypassChildSuppression(value);
  }
  final public void SetSuppressChildren(Boolean value) {
    suppressChildren = value;
  }
}

final public class UITheme {
  color buttonOutlineColor = color(200, 220, 255);
  color buttonFillColor = color(100, 140, 200);
  color buttonLabelColor = color(20, 40, 70);
  color buttonHighlightColor = color(120, 155, 210);

  color windowFillColor = color(40, 80, 90);
  color windowOutlineColor = color(80, 160, 180);
  color windowLabelColor = color(20, 40, 70);

  color sliderFillColor = color(100, 140, 200);
  color sliderOutlineColor = color(200, 220, 255);
  color sliderHandleFillColor = color(200, 220, 255);
  color sliderHandleOutlineColor = color(100, 140, 200);

  color inputfieldFillColor = color(200, 220, 255);
  color inputfieldOutlineColor = color(40, 80, 90);
  color inputfieldTextColor = color(20, 40, 70);

  color checkboxFillColor = color(200, 220, 255);
  color checkboxOutlineColor = color(40, 80, 90);
  color checkboxCheckColor = color(20, 40, 70);

  color dropdownSelfFillColor = color(100, 140, 200);
  color dropdownSelfOutlineColor = color(200, 220, 255);
  color dropdownItemFillColor = color(100, 140, 200);
  color dropdownItemOutlineColor = color(200, 220, 255);
  color dropdownTriangleFillColor = color(40, 80, 90);
  color dropdownTriangleOutlineColor = color(80, 160, 180);
}


class Window extends UIContainer implements IMouseInteractable {
  Rectangle extents;
  Rectangle titleBar;

  Boolean isDragging = false;

  public Window(Rectangle extents) {
    SetVisible(true);
    this.extents = extents;

    float tH = min(extents.h * 0.3, 20); // title-bar height

    titleBar = new Rectangle(extents.x, extents.y, extents.w, tH);

    SetPos(extents.x, extents.y);

    Button close = new Button(
      "X",
      new Rectangle(extents.w - tH, 0, tH, tH),
      () -> {
      this.SetVisible(false);
    }
    );
    AddChild(close);
  }

  public Boolean OnMouseEvent(MouseEvent e) {
    if (super.OnMouseEvent(e))
      return true;

    float xOff = 0;
    float yOff = 0;
    if (GetParent() != null) {
      xOff = GetParent().PosX();
      yOff = GetParent().PosY();
    }

    Boolean handled = false;

    if (extents.IsInside(e.getX() - xOff, e.getY() - yOff)) {
      if ((e.getAction() == MouseEvent.CLICK || e.getAction() == MouseEvent.PRESS) && GetParent() != null) {
        GetParent().MoveToTop(this);
        handled = true;
      }
    }

    if (titleBar.IsInside(e.getX() - xOff, e.getY() - yOff)) {
      if (e.getAction() == MouseEvent.CLICK || e.getAction() == MouseEvent.PRESS) {
        isDragging = true;
        handled = true;
      }
    } else {
      isDragging = false;
    }
    if (isDragging && e.getAction() == MouseEvent.DRAG) {
      SetPos(constrain(PosX() + (mouseX-pmouseX), 0, width - extents.w), constrain(PosY() + (mouseY-pmouseY), 0, height-extents.h));
      handled = true;
    }
    return handled;
  }

  public void DisplaySelf(float x, float y) {
    if (extents == null)
      return;
    var theme = (GetRoot()).theme;
    stroke(theme.windowOutlineColor);
    fill(theme.windowFillColor);
    rect(x, y, extents.w, extents.h);
    rect(x, y, titleBar.w, titleBar.h);
    fill(theme.windowLabelColor);
    textAlign(LEFT, CENTER);
    text(label, x + titleBar.w/2 - textWidth(label)/2, y + titleBar.h/2);
  }

  public void UpdateSelf() {
  }

  final public void SetPos(float x, float y) {
    super.SetPos(x, y);
    extents.x = x;
    extents.y = y;
    titleBar.x = x;
    titleBar.y = y;
  }
}

// axis aligned rect
class Rectangle {
  float x, y;
  float w, h;

  Rectangle(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  Boolean IsInside(float px, float py) {
    if (px < x)
      return false;
    if (py < y)
      return false;
    if (px > x+w)
      return false;
    if (py > y+h)
      return false;
    return true;
  }
}
