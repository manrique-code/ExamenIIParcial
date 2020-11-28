package backend.lib.modules;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBManager {
    public static Connection conn;

    public static void inti_db(){
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://192.168.0.15:3306/idea", "app", "movil1");
            System.out.println("Conectado a la base de datos");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

    }
}
