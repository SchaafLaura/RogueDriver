import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;
import java.util.*;

void setup() {
  fullScreen();
  smooth(0);
  Init();
  sceneManager.SwitchSceneTo(MAINMENU_SCENE_INDEX, false, false);
}

void draw() {
  background(0);

  sceneManager.Update();

  sceneManager.Display();

  if (mousePressed)
    sceneManager.HandleInput();


  fill(255, 0, 0);
  text(frameRate, width-100, 100);
}

int wall = 0;
int road = 1;
int sand = 2;
int ice = 3;
int start = 4;
int finish = 5;

color[] mapColors = new color[]{
  color(0, 0, 0), // wall
  color(255, 255, 255), // road
  color(200, 200, 40), // sand
  color(150, 150, 250), // ice
  color(0, 255, 0), // start
  color(255, 0, 0) // finish
};

int MAINMENU_SCENE_INDEX = 0;
int GAME_SCENE_INDEX = 1;
int EDITOR_SCENE_INDEX = 2;
int HIGHSCORE_SCENE_INDEX = 3;
char ESC_CHAR = (char) -1;
float tileSizeNative = 32;
float resXNative = 1280;
float resYNative = 720;
