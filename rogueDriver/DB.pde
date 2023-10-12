void GetHighScoresFromDB(int mapHash) {
  try {
    Connection con = DriverManager.getConnection("jdbc:mysql://playerAcc:Play3rp4s$123!@containers-us-west-39.railway.app:6917/railway");
    //String query = "INSERT INTO records (user_name, map_hash, replay) VALUES('" + name + "'," + mapHash + ",'" + replay + "')";
    String query = "SELECT * FROM records WHERE map_hash = " + mapHash;
    Statement stmt = con.createStatement();
    ResultSet result = stmt.executeQuery(query);
    
    ((HighscoreScene)sceneManager.scenes[HIGHSCORE_SCENE_INDEX]).highscores = new ArrayList<HighscoreEntry>();
    
    while(result.next()){
      String name = result.getString("user_name");
      String replay = result.getString("replay");
      HighscoreEntry entry = new HighscoreEntry(name, replay);
      ((HighscoreScene)sceneManager.scenes[HIGHSCORE_SCENE_INDEX]).highscores.add(entry);
    }
    con.close();
  }
  catch(Exception e) {
    println(e);
  }
}

void WriteHighScoreToDB(String name, String replay, int mapHash) {
  try {
    Connection con = DriverManager.getConnection("jdbc:mysql://playerAcc:Play3rp4s$123!@containers-us-west-39.railway.app:6917/railway");
    String query = "INSERT INTO records (user_name, map_hash, replay) VALUES('" + name + "'," + mapHash + ",'" + replay + "')";
    Statement stmt = con.createStatement();
    stmt.execute(query);
    con.close();
  }
  catch(Exception e) {
    println(e);
  }
}

void UploadMap(Map map) {
  String map_data = map.toString();
  Integer map_width = map.NX;
  Integer map_height = map.NY;
  Integer map_hash = map.Hash();
  String name = map.name;
  try {
    Connection con = DriverManager.getConnection("jdbc:mysql://playerAcc:Play3rp4s$123!@containers-us-west-39.railway.app:6917/railway");
    String query = "INSERT INTO maps (map_width, map_height, map_data, map_hash, map_name) VALUES(" +
      map_width + "," + map_height + ",'" + map_data + "'," + map_hash + ",'" + name + "')";
    Statement stmt = con.createStatement();
    stmt.execute(query);
  }
  catch(Exception e) {
    println(e);
  }
}
