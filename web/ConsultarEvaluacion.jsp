<%@page import="java.sql.ResultSet"%>
<%@page import="clases.AccesoAleatorioDatos"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Consulta de Evaluaciones</title>
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
                <h1>Evaluaciones de <%=mensaje%></h1>
            </div>
            <div class="form-group">
                <table  class="table">
                <% if(tipo==1){ %>    
                    <thead>
                    <tr>
                        <th scope="col">No. Registro</th>
                        <th scope="col">Profesor</th>
                        <th scope="col">Estatus</th>
                        <th scope="col">Documento</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% 
                        String procedimiento = "ver_evaluaciones('"+usuario+"')";
                        AccesoAleatorioDatos ad = new AccesoAleatorioDatos();
                        ad.obtenerConexion();
                        ResultSet rs = ad.llamarProcedimiento(procedimiento);
                        while(rs.next()){
                    %>
                    <tr>
                        <td><%=rs.getString("num_registro")%></td>
                        <td><%=rs.getString("nombre")%></td>
                        <td><%=rs.getString("estatus")%></td>
                        <td><a href='<%=rs.getString("dir_pdf")%>'><%=rs.getString("dir_pdf")%></a></td>
                    </tr>
                    </tbody>
                        <% } %>
                <% }else %>

                <% if(tipo==2){ %>
                    <thead>
                    <tr>
                        <th scope="col">No. Registro</th>
                        <th scope="col">Alumno</th>
                        <th scope="col">Documento</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% 
                        String procedimiento = "ver_evaluaciones('"+usuario+"')";
                        AccesoAleatorioDatos ad = new AccesoAleatorioDatos();
                        ad.obtenerConexion();
                        ResultSet rs = ad.llamarProcedimiento(procedimiento);
                        while(rs.next()){
                    %>
                    <tr>
                        <td><%=rs.getString("num_registro")%></td>
                        <td><%=rs.getString("nombre")%></td>
                        <td><a href='<%=rs.getString("dir_pdf")%>'><%=rs.getString("dir_pdf")%></a></td>
                    </tr>
                    </tbody>
                        <% } %>
                <% } %>

                </table>


                    <a href="CerrarSesion">Cerrar Sesión</a>
            </div>
        </div>
    </body>
</html>

