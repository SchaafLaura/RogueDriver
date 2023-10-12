import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;
import java.util.*;

int MAINMENU_SCENE_INDEX = 0;
int EDITOR_SCENE_INDEX = 1;
int GAME_SCENE_INDEX = 2;
int HIGHSCORE_SCENE_INDEX = 3;
char ESC_CHAR = (char) -1;
float tileSizeNative = 32;
float resXNative = 1280;
float resYNative = 720;

void setup() {
  fullScreen();
  smooth(0);
  Init();
}

void draw() {
  background(0);

  sceneManager.Update();

  sceneManager.Display();

  sceneManager.HandleInput();

  text(frameRate, width-100, 100);
}
