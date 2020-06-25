package servlets;

import clases.AccesoDatos;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AsignarSinodal", urlPatterns = {"/AsignarSinodal"})
public class AsignarSinodal extends HttpServlet {


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {

            // Obteniendo variables del formulario
            String idProfesor = request.getParameter("idProfesor");
            String nreg = request.getParameter("nreg");

            String procedimiento = "call asignar_sinodal('" + idProfesor + "',"+ "'" + nreg + "')";
            String msj = "";
            // Ejecutando procedimiento
            try {
                AccesoDatos ad = new AccesoDatos();
                ad.obtenerConexion();
                ResultSet rs = ad.llamarProcedimiento(procedimiento);
                if(rs.next()){
                    msj = rs.getString("msj");
                }
                
            } catch (SQLException ex) {
                Logger.getLogger(IniciarSesion.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            response.sendRedirect("Sinodales.jsp?nreg="+nreg+"&msj=" + msj);          
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
