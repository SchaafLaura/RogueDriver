void UploadMap(Map map) {
  String map_data = map.toString();
  Integer map_width = map.NX;
  Integer map_height = map.NY;
  Integer map_hash = map.Hash();
  println(map_data);
  try {
    Connection con = DriverManager.getConnection("jdbc:mysql://playerAcc:Play3rp4s$123!@containers-us-west-39.railway.app:6917/railway");
    String query = "INSERT INTO maps (map_width, map_height, map_data, map_hash) VALUES(" + map_width + "," + map_height + ",'" + map_data + "'," + map_hash +")";
    Statement stmt = con.createStatement();
    stmt.execute(query);
  }
  catch(Exception e) {
    println(e);
  }
}

void TestConnection() {
  try {
    Connection con = DriverManager.getConnection("jdbc:mysql://playerAcc:Play3rp4s$123!@containers-us-west-39.railway.app:6917/railway");
    String query = "SELECT * FROM records";
    Statement stmt = con.createStatement();

    try {
      ResultSet rs = stmt.executeQuery(query);
      while (rs.next()) {
        println("ID: " + rs.getInt("id"));
        println("uid: " + rs.getInt("user_id"));
        println("map: " + rs.getInt("map_id"));
        println("replay: " + rs.getString("replay"));
      }
    }
    catch(java.sql.SQLIntegrityConstraintViolationException icve) {
      println(icve);
    }
    con.close();
  }
  catch(Exception e) {
    println(e);
  }
}
