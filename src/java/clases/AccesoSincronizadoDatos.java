package clases;

import java.lang.instrument.Instrumentation;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AccesoSincronizadoDatos {
    
    AccesoDatosMySQL admysql = new AccesoDatosMySQL();
    AccesoDatosMariaDB admdb = new AccesoDatosMariaDB();
    AccesoDatosSQLServer adsqls = new AccesoDatosSQLServer();
    
    public AccesoSincronizadoDatos(){

    }
    
    public void obtenerConexion(){
        try{
            admysql.obtenerConexion();
            admdb.obtenerConexion();
            adsqls.obtenerConexion();
        }
        catch(Exception ex){
            Logger.getLogger(AccesoSincronizadoDatos.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public ResultSet llamarProcedimiento(String procedimiento){ // Ejemplo de valor: procedimiento = call registrar_alumno(usuario,pswd,boleta,nombre,correo) 
        ResultSet rsFinal = null;
        
        try {
            ResultSet r1 = null;
            ResultSet r2 = null;
            ResultSet r3 = null;
            
            r1 = admysql.llamarProcedimiento(procedimiento);
            r2 = admdb.llamarProcedimiento(procedimiento);
            r3 = adsqls.llamarProcedimiento(procedimiento);
            
            admysql.guardarCambios();
            admdb.guardarCambios();
            adsqls.guardarCambios();
            
            // Como todo se ejecutó apropiadamente, es seguro asumir que los resultsets tienen los mismos resultados.
            rsFinal = r1;
            
        } catch (Exception ex) {
            Logger.getLogger(AccesoSincronizadoDatos.class.getName()).log(Level.SEVERE, null, ex);
            admysql.retrocederSentencia();
            admdb.retrocederSentencia();
            adsqls.retrocederSentencia();
        }
        return rsFinal;
    }
    
    public void cerrarConexion(){
        try {
            admysql.cerrarConexion();
            admdb.cerrarConexion();
            adsqls.cerrarConexion();
        } catch (Exception ex) {
            Logger.getLogger(AccesoSincronizadoDatos.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
