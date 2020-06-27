package clases;

import java.lang.instrument.Instrumentation;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AccesoAleatorioDatos {
    
    AccesoDatosMySQL admysql = new AccesoDatosMySQL();
    AccesoDatosMariaDB admdb = new AccesoDatosMariaDB();
    AccesoDatosSQLServer adsqls = new AccesoDatosSQLServer();
    int indice;
    PlantillaAccesoDatos[] accesos = {admysql,admdb,adsqls};
    
    public AccesoAleatorioDatos(){
        Random random = new Random();
        indice = random.nextInt(accesos.length);
    }
    
    public void obtenerConexion(){
        try{
            accesos[indice].obtenerConexion();
        }
        catch(Exception ex){
            Logger.getLogger(AccesoAleatorioDatos.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public ResultSet llamarProcedimiento(String procedimiento){ // Ejemplo de valor: procedimiento = call registrar_alumno(usuario,pswd,boleta,nombre,correo) 
        ResultSet rsFinal = null;
        try {
            rsFinal = accesos[indice].llamarProcedimiento(procedimiento);
            accesos[indice].guardarCambios();         
        } catch (Exception ex) {
            Logger.getLogger(AccesoAleatorioDatos.class.getName()).log(Level.SEVERE, null, ex);
            accesos[indice].retrocederSentencia();
        }
        return rsFinal;
    }
    
    public void cerrarConexion(){
        try {
            accesos[indice].cerrarConexion();
        } catch (Exception ex) {
            Logger.getLogger(AccesoAleatorioDatos.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public static void main(String args[]){
        AccesoAleatorioDatos asd = new AccesoAleatorioDatos();
        asd.obtenerConexion();
        ResultSet r = asd.llamarProcedimiento("iniciar_sesion('prof1','prof1')");
        try{
            while(r.next()){
                System.out.println(r.getInt("var_iniciado"));
            }
        }
        catch(Exception ex){
            Logger.getLogger(AccesoAleatorioDatos.class.getName()).log(Level.SEVERE, null, ex);
        }
        asd.cerrarConexion();
    }
}
