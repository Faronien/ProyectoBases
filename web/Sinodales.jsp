<%@page import="java.sql.ResultSet"%>
<%@page import="clases.AccesoDatos"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
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
                
                AccesoDatos ad = new AccesoDatos();
                String procedimiento = "call getidProf('"+usuario+"')";;
                ResultSet rs;
                ad.obtenerConexion();
                
                if(tipo==2){
                    rs = ad.llamarProcedimiento(procedimiento);
                    if(rs.next()){
                        idProfesor = rs.getInt("id_profesor");
                    }
                    procedimiento = "call rol_profesor("+idProfesor+")";
                    rs = ad.llamarProcedimiento(procedimiento);
                    if(rs.next()){
                        rolProfesor = rs.getString("rol");
                    }
                }
                
                if(tipo!=2 || !rolProfesor.equals("presidente") || request.getParameter("nreg")==null || request.getParameter("nreg").isEmpty()){
                    response.sendRedirect("index.jsp");
                }
                
                procedimiento = "call academia_profesor("+idProfesor+")";
                String nombreAcademia = "";
                int idAcademia = 0;
                rs = ad.llamarProcedimiento(procedimiento);
                if(rs.next()){
                    nombreAcademia = rs.getString("a.nombre");
                    idAcademia = rs.getInt("a.id_academia");
                }
                String nreg = request.getParameter("nreg");
                procedimiento = "call existe_protocolo('"+nreg+"')";
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
        <h1>Asignación de sinodales de la academia <%=nombreAcademia%> para el TT no. <%=nreg%></h1>
        <%if(!msj.isEmpty()){%>
        <div id="divNotificacion"><%=msj%></div>
        <%}%>
        <h2>Sinodales Asignados</h2>
        <table  class="table">
            <thead>
                <tr>
                    <th scope="col">idProfesor</th>
                    <th scope="col">Nombre</th>
                </tr>
            </thead>
            <tbody>
                <%
                    procedimiento = "call sinodales_protocolo('" + nreg + "')";
                    rs = ad.llamarProcedimiento(procedimiento);
                    while (rs.next()){
                %>
                <tr>
                    <td><%=rs.getString("p.id_profesor")%></td>
                    <td><%=rs.getString("p.nombre")%></td>
                <% } %>
                </tr>
            </tbody>
        </table>
        <h2>Asignar Sinodales</h2>
        <form name="asignarSinodales" id="asignarSinodales" method="post" action="AsignarSinodal">
            <input type="hidden" value="<%=nreg%>" id="nreg" name="nreg" />
            <select name="idProfesor" id="idProfesor" required>
                <option value="">Selecciona un profesor</option>
                <%
                    procedimiento = "call profesores_academia(" + idAcademia + ")";
                    rs = ad.llamarProcedimiento(procedimiento);
                    while (rs.next()){
                %>
                <option value='<%=rs.getString("p.id_profesor")%>'><%=rs.getString("p.nombre")%></option>
                <%}%>
            </select>
            <input class="btn btn-primary" type="submit" value="Asignar" name="btnAsignar" id="btnAsignar"/>  
        </form>
    </body>
</html>
