<%-- 
    Document   : RegistroAlumnos
    Created on : 17/02/2020, 07:05:39 PM
    Author     : USUARIO
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Registro de Alumnos</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" href="css/css-proyectobases.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    </head>
    <body>
        <div class="contenido">
            <div class="titulo">
                <h1>Registro de Alumnos</h1>
            </div>
            <div class="form-group">
                <%
                    // Regresando al usuario al inicio si su sesión no es la correspondiente a esta página
                    // En este caso ni los alumnos ni los profesores deben registrar alumnos, solo los invitados.
                    HttpSession ses = request.getSession();
                    if(ses.getAttribute("tipo") != null && Integer.parseInt((String) ses.getAttribute("tipo")) !=0){
                        response.sendRedirect("index.jsp");
                    }
                    
                    String mensaje = "";
                    // Recibiendo respuesta del servlet RegistrarAlumno. Si el mensaje es nulo, no muestra nada.
                    if(request.getParameter("mensaje") != null){
                        mensaje = (String) request.getParameter("mensaje");
                    }
                %>
                <%= mensaje %>
                <form name="formaAlumnos" id="formaAlumnos" method="get" action="RegistrarAlumno">
                    <table>
                        <tr>
                            <th>
                                Boleta
                            </th>
                            <td>
                                <input class="form-control" type="text" name="txtBoleta" id="txtBoleta" placeholder="2015090231" required="required"/>
                            </td>
                        </tr>
                        <tr>    
                            <th>
                                Nombre Completo
                            </th>
                            <td>
                                <input class="form-control" type="text" name="txtNombre" id="txtNombreArticulo" placeholder="Nombre Completo" required="required"/>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Correo
                            </th>
                            <td>
                                <input class="form-control" type="text" name="txtCorreo" id="txtCorreo" placeholder="correo@mail.com" required="required"/>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Nombre de Usuario
                            </th>
                            <td>
                                <input class="form-control" type="text" name="txtUsuario" id="txtUsuario" placeholder="Usuario" required="required"/>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Contraseña
                            </th>
                            <td>
                                <input class="form-control" type="password" name="txtPswd" id="txtPswd" placeholder="Contraseña" required="required"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input class="btn btn-primary" type="submit" value="Enviar" name="btnEnviar" id="btnEnviar"/>
                            </td>
                        </tr>
                    </table><br/>
                </form>
                <a href="InicioSesion.jsp">Iniciar Sesión</a>
            </div>
        </div>
    </body>
</html>
