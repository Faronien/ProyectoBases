<%@page import="org.apache.catalina.tribes.util.Arrays"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="clases.AccesoAleatorioDatos"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Registrar evaluación</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" href="css/css-proyectobases.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    </head>
    <body>
        <%
                    // Regresando al usuario al inicio si su sesión no es la correspondiente a esta página
                    HttpSession ses = request.getSession();
                    String stringRadio=request.getParameter("rdprotocolo");
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
        %>
        <nav class="navbar navbar-dark ">
            <div class="containers-fluid">
                <ul class="nav navbar-nav mr-auto">
                    
                    <%if(tipo == 1) {%>
                    <li><a class="navbar-element" href="VerProtocolos.jsp">Ver Protocolo</a></li>
                    <li><a class="navbar-element" href="RegistroProtocolo.jsp">Registrar Protocolo</a></li>
                    <li><a class="navbar-element" href="ConsultarEvaluacion.jsp">Consultar Evaluacion</a></li>
                    <% } else if(tipo == 2){ %>
                    <li><a class="navbar-element" href="VerProtocolos.jsp">Ver Protocolos</a></li>
                    <% } %>
                    <li><a class="navbar-element" href="CerrarSesion">Cerrar Sesión</a></li>
                </ul>
            </div>
        </nav>
        <div class="contenido">
            <div class="titulo">
                <h1>Protocolos</h1>
            </div>
            <div class="form-group">
                <% if (tipo == 1) {
                    response.sendRedirect("index.jsp");
                } else %>
                <% if (tipo == 2) { %>
                <form name="subirEval" id="subirEval" method="post" action="EvUploadServlet" enctype = "multipart/form-data">
                    <table  class="table">
                        <thead>
                            <tr>
                                <th scope="col">Numero de Registro</th>
                                <th scope="col">Alumno</th>
                                <th scope="col">Protocolo</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                
                                String procedimiento = "ver_protocolo_eleg('" + stringRadio + "')";
                                AccesoAleatorioDatos ad = new AccesoAleatorioDatos();
                                ad.obtenerConexion();
                                String num_registro = "";
                                String nombreAl = "";
                                String dirpdf = "";
                                String nombrePr = "";
                                ResultSet rs = ad.llamarProcedimiento(procedimiento);
                                while (rs.next()) {
                                    num_registro = rs.getString("num_registro");
                                    nombreAl = rs.getString("alumno");
                                    dirpdf = rs.getString("dir_pdf");
                                    nombrePr = rs.getString("nombre");
                                }
                            %>
                            <tr>
                                <td><input type="text" value='<%=num_registro%>' name="numRegistro" id="numRegistro" readonly="true"</td>
                                <td><%=nombreAl%></td>
                                <td><a href='<%=dirpdf%>'><%=nombrePr%></a></td>
                            </tr>
                        </tbody>
                        <tr>
                            <td>
                                Aprobado:<input type="radio"  id="evaluacionr" name="evaluacionR" value="ACEPTADO"/> Reprobado:<input type="radio" name="evaluacionR" value="RECHAZADO"/>
                            </td>
                            <td colspan="2">
                                <input type="file" name="fileEv" size="50"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input class="btn btn-primary" type="submit" value="Subir Evaluacion" name="btnSubirEv" id="btnUpEv"/>  
                            </td>
                        </tr>

                        <% }%>

                    </table>
                </form>

                <p><a href="CerrarSesion">Cerrar Sesión</a>
            </div>
        </div>
</html>
