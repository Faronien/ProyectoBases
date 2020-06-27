package servlets;

import clases.AccesoAleatorioDatos;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/docs/evaluaciones/*")
public class FiltroEvaluaciones implements Filter {
    
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
        throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession();
        
        //PARA QUE NO SE OBTENGAN DOCUMENTOS A TRAVÉS DE CACHÉ
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
        response.setDateHeader("Expires", 0); // Proxies.
        
        if((session.getAttribute("tipo") != null && Integer.parseInt((String) session.getAttribute("tipo")) !=0)){
            try {
                String usuario = (String) session.getAttribute("usuario");    
                int valido = 0;
                String procedimiento = "ver_evaluaciones('" + usuario + "')";
                System.out.println("Se intenta acceder a: "+request.getRequestURI().substring(15));
                AccesoAleatorioDatos ad = new AccesoAleatorioDatos();
                ad.obtenerConexion();
                ResultSet rs = ad.llamarProcedimiento(procedimiento);
                while(rs.next()){
                    if(rs.getString("dir_pdf").equals(request.getRequestURI().substring(15)))valido = 1;
                }
                if(valido == 1){
                    chain.doFilter(req,res);
                }else{
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                }
            } catch (SQLException ex) {
                Logger.getLogger(FiltroEvaluaciones.class.getName()).log(Level.SEVERE, null, ex);
            }
        }else{
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void destroy() {

    }
}
