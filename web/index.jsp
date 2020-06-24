<%-- 
    Document   : InicioSesion
    Created on : 17/02/2020, 07:05:39 PM
    Author     : USUARIO
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Inicio de Sesión</title>
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
                    // En este caso ni los alumnos ni los profesores deben registrar alumnos, solo los invitados.
                    HttpSession ses = request.getSession();
                    String mensaje = "¡Bienvenido!";
                    int tipo = -1;
                    if((ses.getAttribute("tipo") != null && Integer.parseInt((String) ses.getAttribute("tipo")) !=0)){
                        tipo = Integer.parseInt((String) ses.getAttribute("tipo"));
                        if(ses.getAttribute("usuario") != null){
                            mensaje = "¡Bienvenido " + ses.getAttribute("usuario") + "!";
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
                    <li><a class="navbar-element" href="RegistroEvaluacion.jsp">Registrar Evaluacion</a></li>
                    <% } %>
                    <li><a class="navbar-element" href="CerrarSesion">Cerrar Sesión</a></li>
                </ul>
            </div>
        </nav>
        <div class="contenido">
            <div class="titulo">
                <h1><%=mensaje%></h1>
            </div>
            <div class="form-group">
                <a href="VerProtocolos.jsp">Ver Protocolo(s)</a><br><br>
                
                <a href="CerrarSesion">Cerrar Sesión</a>
            </div>
        </div>
    </body>
</html>
