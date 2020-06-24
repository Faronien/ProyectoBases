package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.ResultSet;
import clases.AccesoDatos;

public final class VerProtocolos_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html>\n");
      out.write("    <head>\n");
      out.write("        <title>Consulta de Protocolos</title>\n");
      out.write("        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n");
      out.write("        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n");
      out.write("        <link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css\">\n");
      out.write("        <link rel=\"stylesheet\" href=\"css/css-proyectobases.css\">\n");
      out.write("        <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js\"></script>\n");
      out.write("        <script src=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js\"></script>\n");
      out.write("    </head>\n");
      out.write("    <body>\n");
      out.write("        ");

                    // Regresando al usuario al inicio si su sesión no es la correspondiente a esta página
                    HttpSession ses = request.getSession();
                    String mensaje = "¡Bienvenido!";
                    String usuario = "";
                    int tipo = 0;
                    if((ses.getAttribute("tipo") != null && Integer.parseInt((String) ses.getAttribute("tipo")) !=0)){   
                        if(ses.getAttribute("usuario") != null){
                            mensaje = ses.getAttribute("usuario")+"";
                            usuario = ses.getAttribute("usuario")+"";
                            tipo = Integer.parseInt((String) ses.getAttribute("tipo"));
                        }
                    }
                    else{
                        response.sendRedirect("InicioSesion.jsp");
                    }
        
      out.write("\n");
      out.write("        <div class=\"contenido\">\n");
      out.write("            <div class=\"form-group\">\n");
      out.write("                <div class=\"titulo\">\n");
      out.write("                    <h1>Protocolos</h1>\n");
      out.write("                </div>\n");
      out.write("                <table  class=\"table\">\n");
      out.write("                ");
 if(tipo==1){ 
      out.write("    \n");
      out.write("                    <thead>\n");
      out.write("                    <tr>\n");
      out.write("                        <th scope=\"col\">No. Registro</th>\n");
      out.write("                        <th scope=\"col\">Profesor</th>\n");
      out.write("                        <th scope=\"col\">Protocolo</th>\n");
      out.write("                    </tr>\n");
      out.write("                    </thead>\n");
      out.write("                    <tbody>\n");
      out.write("                    ");
 
                        String procedimiento = "call ver_protocolos('"+usuario+"')";
                        AccesoDatos ad = new AccesoDatos();
                        ad.obtenerConexion();
                        ResultSet rs = ad.llamarProcedimiento(procedimiento);
                        while(rs.next()){
                    
      out.write("\n");
      out.write("                    <tr>\n");
      out.write("                        <td>");
      out.print(rs.getString("protocolo.num_registro"));
      out.write("</td>\n");
      out.write("                        <td>");
      out.print(rs.getString("profesor.nombre"));
      out.write("</td>\n");
      out.write("                        <td><a href='");
      out.print(rs.getString("protocolo.dir_pdf"));
      out.write('\'');
      out.write('>');
      out.print(rs.getString("protocolo.nombre"));
      out.write("</a></td>\n");
      out.write("                    </tr>\n");
      out.write("                    </tbody>\n");
      out.write("                        ");
 } 
      out.write("\n");
      out.write("                ");
 }else 
      out.write("\n");
      out.write("\n");
      out.write("                ");
 if(tipo==2){ 
      out.write("\n");
      out.write("                <form name=\"elegirProt\" id=\"elegirProt\" method=\"get\" action=\"RegistroEvaluacion.jsp\">\n");
      out.write("                    <thead>\n");
      out.write("                    <tr>\n");
      out.write("                        <th scope=\"col\"></th>\n");
      out.write("                        <th scope=\"col\">Numero Registro</th>\n");
      out.write("                        <th scope=\"col\">Alumno</th>\n");
      out.write("                        <th scope=\"col\">Protocolo</th>\n");
      out.write("                    </tr>\n");
      out.write("                    </thead>\n");
      out.write("                    <tbody>\n");
      out.write("                    ");
 
                        String procedimiento = "call ver_protocolos('"+usuario+"')";
                        AccesoDatos ad = new AccesoDatos();
                        ad.obtenerConexion();
                        ResultSet rs = ad.llamarProcedimiento(procedimiento);
                        while(rs.next()){
                    
      out.write("\n");
      out.write("                    <tr>\n");
      out.write("                        <td><input type=\"radio\" name=\"rdprotocolo\" value='");
      out.print(rs.getInt("protocolo.num_registro"));
      out.write("'></td>\n");
      out.write("                        <td>");
      out.print(rs.getString("protocolo.num_registro"));
      out.write("</td>\n");
      out.write("                        <td>");
      out.print(rs.getString("alumno.nombre"));
      out.write("</td>\n");
      out.write("                        <td><a href='");
      out.print(rs.getString("protocolo.dir_pdf"));
      out.write('\'');
      out.write('>');
      out.print(rs.getString("protocolo.nombre"));
      out.write("</a></td>\n");
      out.write("                    </tr>\n");
      out.write("                    </tbody>\n");
      out.write("                        ");
 } 
      out.write("\n");
      out.write("                        <tr>\n");
      out.write("                            <td colspan=\"2\">\n");
      out.write("                        <input class=\"btn btn-primary\" type=\"submit\" value=\"Evaluar\" name=\"btnEvaluar\" id=\"btnEv\"/>  \n");
      out.write("                            </td>\n");
      out.write("                </tr>\n");
      out.write("                ");
 } 
      out.write("\n");
      out.write("\n");
      out.write("                </table>\n");
      out.write("            </form>\n");
      out.write("                <a href=\"CerrarSesion\">Cerrar Sesión</a>\n");
      out.write("            </div>\n");
      out.write("        </div>\n");
      out.write("    </body>\n");
      out.write("</html>\n");
      out.write("\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
