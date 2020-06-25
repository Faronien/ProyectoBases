package clases;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AccesoDatos {
    
    // Constantes para establecer conexion
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String URL_CONEXION = "jdbc:mysql://localhost:3306/dbprotocolo?serverTimezone=America/Mexico_City&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&useSSL=false";
    private static final String USUARIO = "root";
    private static final String PASSWORD = "root";
    private Connection con;
    
    public void obtenerConexion(){
        try{
            Class.forName(DRIVER);
            con = DriverManager.getConnection(URL_CONEXION, USUARIO, PASSWORD);
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public ResultSet llamarProcedimiento(String procedimiento){ // Ejemplo de valor: procedimiento = call registrar_alumno(usuario,pswd,boleta,nombre,correo) 
        String resultado = "";
        ResultSet rs = null;
        CallableStatement stmt;
        try {
            stmt = con.prepareCall("{" + procedimiento + "}");
            rs = stmt.executeQuery();
        } catch (SQLException ex) {
            Logger.getLogger(AccesoDatos.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rs;
    }
    
    public void cerrarConexion(){
        try {
            con.close();
        } catch (SQLException ex) {
            Logger.getLogger(AccesoDatos.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
