<%-- 
    Document   : VerProtocolos
    Created on : 17/02/2020, 07:05:39 PM
    Author     : USUARIO
--%>
<%@page import="org.apache.catalina.tribes.util.Arrays"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="clases.AccesoDatos"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Registrar protocolo</title>
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
                    
                    String usuario = "";
                    int tipo = 0;
                    if((ses.getAttribute("tipo") != null && Integer.parseInt((String) ses.getAttribute("tipo")) !=0)){   
                        if(ses.getAttribute("usuario") != null){
                            
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
            <% if(tipo==2){    
                response.sendRedirect("index.jsp");
             }else %>
            <% if(tipo==1){ %>
            <form name="subirProtocolo" id="subirProtocolo" method="post" action="registrarProtocolo" enctype="multipart/form-data">
                <table>
                    
                    <tr>
                        <td>
                            <label for="titulo">Titulo</label>
                            <input type="text" name="titulo" id="titulo" class="form-control"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="keyw">Palabras clave</label>
                            <p>Introduzca las palabras separadas por comas sin espacios</p>
                            <textarea id="keyw" name="keyw"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="pdf">Archivo</label>
                            <input type="file" id="pdf" name="pdf" class="form-control" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <button class="btn btn-primary" id="sub">Enviar</button>
                        </td>
                    </tr>




                </table>
            </form>
                <p>
                    <% String mensaje = "";
                    // Recibiendo respuesta del servlet RegistrarAlumno. Si el mensaje es nulo, no muestra nada.
                    if(request.getParameter("mensaje") != null){
                        mensaje = (String) request.getParameter("mensaje");
                    }%>
                    <%=mensaje%>
                </p>
            
            <% }%>
            
            <p><a href="CerrarSesion">Cerrar Sesión</a></p>
            </div>
        </div>
</html>
