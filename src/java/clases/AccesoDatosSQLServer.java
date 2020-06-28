package clases;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AccesoDatosSQLServer extends PlantillaAccesoDatos {
    

    private static final String DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String URL_CONEXION = "jdbc:sqlserver://localhost\\MSSQLServer;databaseName=dbprotocolo;user=sa;password=root";
    private Connection con;
    
    public void obtenerConexion(){
        try{
            Class.forName(DRIVER);
            con = DriverManager.getConnection(URL_CONEXION);
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
            stmt = con.prepareCall("{call " + procedimiento + "}");
            rs = stmt.executeQuery();
        } catch (SQLException ex) {
            Logger.getLogger(AccesoDatosSQLServer.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rs;
    }
    
    public void cerrarConexion(){
        try {
            con.close();
        } catch (SQLException ex) {
            Logger.getLogger(AccesoDatosSQLServer.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void retrocederSentencia(){
        try {
            con.rollback();
        } catch (SQLException ex) {
            Logger.getLogger(AccesoDatosMariaDB.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void guardarCambios(){
        try {
            con.commit();
        } catch (SQLException ex) {
            Logger.getLogger(AccesoDatosMariaDB.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
