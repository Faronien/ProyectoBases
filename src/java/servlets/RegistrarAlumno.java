package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import clases.AccesoSincronizadoDatos;
import java.net.URLEncoder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RegistrarAlumno extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException{
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {

            // Obteniendo variables del formulario
            String usuario = request.getParameter("txtUsuario");
            String pswd = request.getParameter("txtPswd");
            String boleta = request.getParameter("txtBoleta");
            String nombre = request.getParameter("txtNombre");
            String correo = request.getParameter("txtCorreo");
            int registrado = -1;
            // Creando procedimiento de la forma procedimiento = call registrar_alumno(usuario,pswd,boleta,nombre,correo)
            String procedimiento = "registrar_alumno('" + usuario + "',"
                    + "'" + pswd + "',"
                    + "'" + boleta + "',"
                    + "'" + nombre + "',"
                    + "'" + correo + "')";
            
            // Ejecutando procedimiento
            try {
                AccesoSincronizadoDatos ad = new AccesoSincronizadoDatos();
                ad.obtenerConexion();
                ResultSet rs = ad.llamarProcedimiento(procedimiento);
                while(rs.next()){
                    registrado = rs.getInt("var_registrado"); // Obteniendo respuesta que indica si el registro fue exitoso o no
                }
            } catch (SQLException ex) {
                Logger.getLogger(RegistrarAlumno.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            // Regresando a página de registro de alumnos, con mensaje de confirmación que se registró el alumno o no
            
            String mensaje = "";
            if(registrado == 1){
                mensaje = "Se ha registrado el alumno exitosamente.";
            }
            else{
                mensaje = "Ese usuario o boleta ya existe.";
            }
            
            // Formateando para enviar en un mensaje con método Get
//            mensaje = URLEncoder.encode(mensaje, "UTF-8");
            response.sendRedirect("RegistroAlumnos.jsp?mensaje=" + mensaje);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
