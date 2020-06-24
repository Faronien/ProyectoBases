package servlets;

import java.io.*;
import java.util.*;
import java.util.Properties;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import clases.AccesoDatos;
import java.sql.ResultSet;
import javax.mail.Session;
import javax.mail.Message;
import javax.mail.Transport;
import javax.mail.Authenticator;
import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.PasswordAuthentication;
import javax.mail.internet.MimeMessage;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import javax.servlet.http.HttpSession;

public class EvUploadServlet extends HttpServlet {

    private boolean isMultipart;
    private String filePath;
    private int maxFileSize = 50 * 1024 * 1024 * 1024;
    private int maxMemSize = 4 * 1024;
    private File file;

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        HttpSession ses = request.getSession();
        String resultado = "";
        String num = "";
        String usuario = "";
        if (ses.getAttribute("usuario") != null) {
            usuario = (String) ses.getAttribute("usuario");
        }
        String dir = "";
        // Check that we have a file upload request
        filePath = getServletContext().getRealPath("/") + "docs\\evaluaciones\\";
        isMultipart = ServletFileUpload.isMultipartContent(request);
        response.setContentType("text/html");
        java.io.PrintWriter out = response.getWriter();

        if (!isMultipart) {
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet upload</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<p>No se subio el archivo</p>");
            out.println("</body>");
            out.println("</html>");
            return;
        }

        DiskFileItemFactory factory = new DiskFileItemFactory();

        // maximum size that will be stored in memory
        factory.setSizeThreshold(maxMemSize);

        // Location to save data that is larger than maxMemSize.
        factory.setRepository(new File(filePath));

        // Create a new file upload handler
        ServletFileUpload upload = new ServletFileUpload(factory);

        // maximum file size to be uploaded.
        upload.setSizeMax(maxFileSize);

        try {
            // Parse the request to get file items.
            List fileItems = upload.parseRequest(request);

            // Process the uploaded file items
            Iterator i = fileItems.iterator();

            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet upload</title>");
            out.println("</head>");
            out.println("<body>");

            while (i.hasNext()) {
                FileItem fi = (FileItem) i.next();
                if (!fi.isFormField()) {
                    // Get the uploaded file parameters
                    String fieldName = fi.getFieldName();
                    String fileName = fi.getName();
                    String contentType = fi.getContentType();
                    boolean isInMemory = fi.isInMemory();
                    long sizeInBytes = fi.getSize();

                    // Write the file
                    if (fileName.lastIndexOf("\\") >= 0) {
                        file = new File(filePath + fileName.substring(fileName.lastIndexOf("\\")));
                    } else {
                        file = new File(filePath + fileName.substring(fileName.lastIndexOf("\\") + 1));
                    }
                    fi.write(file);
                    dir = "docs/evaluaciones/" + fileName;
                } else {
                    String nombre = fi.getFieldName();
                    String value = fi.getString();
                    if (nombre.equals("numRegistro")) {
                        num = value;
                    } else if (nombre.equals("evaluacionR")) {
                        resultado = value;
                    }
                }
            }
            String procedimiento = "call contarEv()";
            String procedimiento2 = "call getidProf('" + usuario + "')";
            int idEv = 0;
            String idProf = "";
            int evRegistrada = -1;
            AccesoDatos ad = new AccesoDatos();
            ad.obtenerConexion();
            ResultSet rs = ad.llamarProcedimiento(procedimiento);
            while (rs.next()) {
                idEv = rs.getInt("sigID");
            }
            ResultSet rs2 = ad.llamarProcedimiento(procedimiento2);
            while (rs2.next()) {
                idProf = rs2.getString("id_profesor");
            }
            String mail = "";
            out.println(dir);
            String procedimiento4 = "call getMailAlum('" + num + "')";
            ResultSet rs4 = ad.llamarProcedimiento(procedimiento4);
            while (rs4.next()) {
                mail = rs4.getString("correo");
            }
            String procedimiento3 = "call registrar_evaluacion('" + idEv + "',"
                    + "'" + idProf + "',"
                    + "'" + num + "',"
                    + "'" + resultado + "',"
                    + "'" + dir + "')";
            ResultSet rs3 = ad.llamarProcedimiento(procedimiento3);
            while (rs3.next()) {
                evRegistrada = rs3.getInt("ev_registrada");
            }

            String subject = "Evaluacion Protocolo";
            String message = "Su protocolo ha sido evaluado por el profesor sinodal correspondiente con el resultado de: " + resultado + " le recomendamos visitar la plataforma de protocolo para revisar el archivo de evaluacion correspondiente.";
            String user = "protocobas@gmail.com";
            String pass = "pr0t0c0l0";
            send(mail, subject, message, user, pass);

            out.println("</body>");
            out.println("</html>");
            if (evRegistrada == 1) {
                response.sendRedirect("./VerProtocolos.jsp");
            }

        } catch (Exception ex) {
            System.out.println(ex);
        }
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        throw new ServletException("GET method used with "
                + getClass().getName() + ": POST method required.");
    }

    public static void send(String to, String sub, String msg, final String user, final String pass) {
        Properties props = new Properties();

        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getDefaultInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, pass);
            }
        });

        try {
            Message message = new MimeMessage(session);

            message.setFrom(new InternetAddress(user));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(sub);
            message.setText(msg);

            Transport.send(message);

        } catch (MessagingException e) {

            throw new RuntimeException(e);
        }

    }
}
