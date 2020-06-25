<%@page import="java.sql.ResultSet"%>
<%@page import="clases.AccesoDatos"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Consulta de Protocolos</title>
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
                    AccesoDatos ad = new AccesoDatos();
                    String procedimiento;
                    ResultSet rs;
                    ad.obtenerConexion();
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
                
                <% if(tipo==1){ %>    
                    
                    <% 
                        procedimiento = "call ver_protocolos('"+usuario+"')";
                        System.out.println(usuario);
                        String ligaProtocolo = "";
                        String nombreProtocolo = "";
                        boolean hayAlgo = false;
                        
                        rs = ad.llamarProcedimiento(procedimiento);

                        while(rs.next()){
                            System.out.println("URL:" + ligaProtocolo);
                            ligaProtocolo = rs.getString("protocolo.dir_pdf");
                            nombreProtocolo = rs.getString("protocolo.nombre");
                            hayAlgo = true;
                        }
                    %>
<!--                    <p>
                        Tu protocolo evaluado por los profesores ya está disponible.
                    </p>-->
                    <% if(hayAlgo){%>
                        <a href='<%=ligaProtocolo%>'>Ver PDF del protocolo de "<%=nombreProtocolo%>"</a><br/>
                    <%} else{%>
                        Aún no tienes un protocolo registrado.<br/>
                    <%}%>
                <% }else %>

                <% if(tipo==2){
                    procedimiento = "call getidProf('"+usuario+"')";
                    rs = ad.llamarProcedimiento(procedimiento);
                    int idProfesor = 0;
                    if(rs.next()){
                        idProfesor = rs.getInt("id_profesor");
                    }
                    procedimiento = "call rol_profesor("+idProfesor+")";
                    rs = ad.llamarProcedimiento(procedimiento);
                    String rolProfesor = "";
                    if(rs.next()){
                        rolProfesor = rs.getString("rol");
                    }
                    %>
                <form name="elegirProt" id="elegirProt" method="get" action="RegistroEvaluacion.jsp">
                    <table  class="table">
                        <thead>
                            <tr>
                                <th scope="col">Evaluar</th>
                                <th scope="col">Numero Registro</th>
                                <th scope="col">Alumno</th>
                                <th scope="col">Protocolo</th>
                                <%if(rolProfesor.equals("presidente")){%>
                                <th scope="col">Acci&oacute;n</th>
                                <%}%>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                procedimiento = "call ver_protocolos('" + usuario + "')";
                                rs = ad.llamarProcedimiento(procedimiento);
                                while (rs.next()) {
                            %>
                            <tr>
                                <td><input type="radio" name="rdprotocolo" value='<%=rs.getString("protocolo.num_registro")%>'></td>
                                <td><%=rs.getString("protocolo.num_registro")%></td>
                                <td><%=rs.getString("alumno.nombre")%></td>
                                <td><a href='<%=rs.getString("protocolo.dir_pdf")%>'><%=rs.getString("protocolo.nombre")%></a></td>
                                <%if(rolProfesor.equals("presidente")){%>
                                <td><a href='Sinodales.jsp?nreg=<%=rs.getString("protocolo.num_registro")%>'>Ver Sinodales</td>
                                <%}%>
                            </tr>
                        </tbody>
                            <% } %>
                        <tr>
                            <td colspan="2">
                                <input class="btn btn-primary" type="submit" value="Evaluar" name="btnEvaluar" id="btnEv"/>  
                            </td>
                        </tr>
                <%}%>
                    </table>
                </form>
            </div>
        </div>
    </body>
</html>

