ArrayList<Map> GetAllMapsFromDatabase() {
  ArrayList<Map> ret = new ArrayList<Map>();

  try {
    Connection con = DriverManager.getConnection("jdbc:mysql://playerAcc:Play3rp4s$123!@containers-us-west-39.railway.app:6917/railway");
    String query = "SELECT * FROM maps";
    Statement stmt = con.createStatement();
    ResultSet result = stmt.executeQuery(query);
    while (result.next()) {
      String map_name = result.getString("map_name");
      String map_data = result.getString("map_data");
      Integer map_width = result.getInt("map_width");
      Integer map_height = result.getInt("map_height");

      Map m = new Map(map_width, map_height, map_data);
      m.name = map_name;
      ret.add(m);
    }
    return ret;
  }
  catch(Exception e) {
    println(e);
    return null;
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

ArrayList<HighscoreEntry> GetHighScoresFromDB(int mapHash) {
  try {
    
    
    Connection con = DriverManager.getConnection("jdbc:mysql://playerAcc:Play3rp4s$123!@containers-us-west-39.railway.app:6917/railway");
    String query = "SELECT * FROM records WHERE map_hash = " + mapHash;
    Statement stmt = con.createStatement();
    ResultSet result = stmt.executeQuery(query);

    ((HighscoreScene)sceneManager.scenes[HIGHSCORE_SCENE_INDEX]).highscores = new ArrayList<HighscoreEntry>();

    ArrayList<HighscoreEntry> hs = new ArrayList<HighscoreEntry>();
    while (result.next()) {
      String name = result.getString("user_name");
      String replay = result.getString("replay");
      HighscoreEntry entry = new HighscoreEntry(name, replay);
      hs.add(entry);
    }
    con.close();
    return hs;
  }
  catch(Exception e) {
    println(e);
    return null;
  }
}
