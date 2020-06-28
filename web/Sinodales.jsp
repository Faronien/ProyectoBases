<%@page import="java.sql.ResultSet"%>
<%@page import="clases.AccesoAleatorioDatos"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Sinodales</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" href="css/css-proyectobases.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    </head>
    <body>
            <%
                HttpSession ses = request.getSession();
                String usuario = "";
                int tipo = 0;
                int idProfesor = 0;
                String rolProfesor = "";
                if((ses.getAttribute("tipo") != null && Integer.parseInt((String) ses.getAttribute("tipo")) !=0)){   
                    if(ses.getAttribute("usuario") != null){
                        usuario = ses.getAttribute("usuario")+"";
                        tipo = Integer.parseInt((String) ses.getAttribute("tipo"));
                    }
                }else{
                    response.sendRedirect("InicioSesion.jsp");
                }
                
                AccesoAleatorioDatos ad = new AccesoAleatorioDatos();
                String procedimiento = "getidProf('"+usuario+"')";;
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
                <h1>Sinodales</h1>
            </div>
            <div class="form-group">
            <%  if(tipo==2){
                    rs = ad.llamarProcedimiento(procedimiento);
                    if(rs.next()){
                        idProfesor = rs.getInt("id_profesor");
                    }
                    procedimiento = "rol_profesor("+idProfesor+")";
                    rs = ad.llamarProcedimiento(procedimiento);
                    if(rs.next()){
                        rolProfesor = rs.getString("rol");
                    }
                }
                
                if(tipo!=2 || !rolProfesor.equals("presidente") || request.getParameter("nreg")==null || request.getParameter("nreg").isEmpty()){
                    response.sendRedirect("index.jsp");
                }
                
                procedimiento = "academia_profesor("+idProfesor+")";
                String nombreAcademia = "";
                int idAcademia = 0;
                rs = ad.llamarProcedimiento(procedimiento);
                if(rs.next()){
                    nombreAcademia = rs.getString("nombre");
                    idAcademia = rs.getInt("id_academia");
                }
                String nreg = request.getParameter("nreg");
                procedimiento = "existe_protocolo('"+nreg+"')";
                rs = ad.llamarProcedimiento(procedimiento);
                String existeProtocolo = "";
                if(rs.next()){
                    existeProtocolo = rs.getString("msj");
                }
                
                if(existeProtocolo.equals("Inexistente")){
                    response.sendRedirect("index.jsp");
                }
                
                String msj = "";
                if(request.getParameter("msj")!=null){
                    msj = request.getParameter("msj");
                    if(msj.equals("Asignado"))msj = "El profesor fue asignado correctamente";
                    else if(msj.equals("c1"))msj = "El profesor ya fue asignado a ese protocolo";
                    else if(msj.equals("c2"))msj = "El protocolo ya tiene 3 sinodales";
                    else if(msj.equals("c3"))msj = "El profesor ya es sinodal de 3 protocolos";
                }
                
            %>
        <h3>Asignación de sinodales de la academia <%=nombreAcademia%> para el TT no. <%=nreg%></h3>
        <%if(!msj.isEmpty()){%>
        <div id="divNotificacion"><%=msj%></div>
        <%}%>
        <h4>Sinodales Asignados</h4>
        <table  class="table">
            <thead>
                <tr>
                    <th scope="col">idProfesor</th>
                    <th scope="col">Nombre</th>
                </tr>
            </thead>
            <tbody>
                <%
                    procedimiento = "sinodales_protocolo('" + nreg + "')";
                    rs = ad.llamarProcedimiento(procedimiento);
                    while (rs.next()){
                %>
                <tr>
                    <td><%=rs.getString("id_profesor")%></td>
                    <td><%=rs.getString("nombre")%></td>
                <% } %>
                </tr>
            </tbody>
        </table>
        <h4>Asignar Sinodales</h4>
        <form name="asignarSinodales" id="asignarSinodales" method="post" action="AsignarSinodal">
            <input type="hidden" value="<%=nreg%>" id="nreg" name="nreg" />
            <select name="idProfesor" id="idProfesor" required>
                <option value="">Selecciona un profesor</option>
                <%
                    procedimiento = "profesores_academia(" + idAcademia + ")";
                    rs = ad.llamarProcedimiento(procedimiento);
                    while (rs.next()){
                %>
                <option value='<%=rs.getString("id_profesor")%>'><%=rs.getString("nombre")%></option>
                <%}%>
            </select>
            <input class="btn btn-primary" type="submit" value="Asignar" name="btnAsignar" id="btnAsignar"/>  
        </form>
    </body>
</html>
