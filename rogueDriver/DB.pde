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
