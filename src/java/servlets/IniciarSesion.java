package servlets;

import clases.AccesoDatosMariaDB;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class IniciarSesion extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException{
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {

            // Obteniendo variables del formulario
            String usuario = request.getParameter("txtUsuario");
            String pswd = request.getParameter("txtPswd");
            String usuarioBase = "";
            int iniciado = -1;
            int tipo = -1;
            // Creando procedimiento de la forma procedimiento = call registrar_alumno(usuario,pswd,boleta,nombre,correo)
            String procedimiento = "iniciar_sesion('" + usuario + "',"+ "'" + pswd + "')";
            
            // Ejecutando procedimiento
            try {
                AccesoDatosMariaDB ad = new AccesoDatosMariaDB();
                ad.obtenerConexion();
                ResultSet rs = ad.llamarProcedimiento(procedimiento);
                while(rs.next()){
                    iniciado = rs.getInt("var_iniciado"); // Obteniendo respuesta que indica si el registro fue exitoso o no
                    if(iniciado == 1){
                        usuarioBase = rs.getString("var_usuario");
                        tipo = rs.getInt("var_tipo");
                    }
                }   
            } catch (SQLException ex) {
                Logger.getLogger(IniciarSesion.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            
            // Regresando a página de bienvenida si se logró iniciar sesión
            
            String mensaje = "";
            if(iniciado == 1){
                mensaje = "Se ha iniciado sesión exitosamente.";
                HttpSession ses = request.getSession();
                ses.setAttribute("usuario", usuarioBase);
                ses.setAttribute("tipo", "" + tipo);
                response.sendRedirect("index.jsp");
            }
            
            // Regresando a página de inicio de sesión con mensaje de error si no se logró iniciar sesión
            else{
                mensaje = "El usuario o password son incorrectos.";
                response.sendRedirect("InicioSesion.jsp?mensaje=" + mensaje);
            }
            
            // Formateando para enviar en un mensaje con método Get
            // mensaje = URLEncoder.encode(mensaje, "UTF-8");
            
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
