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
