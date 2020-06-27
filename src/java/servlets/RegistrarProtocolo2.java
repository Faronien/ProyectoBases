package servlets;

import clases.AccesoSincronizadoDatos;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class RegistrarProtocolo2 extends HttpServlet {

    private boolean isMultipart;
    private String filePath;
    private int maxFileSize = 50 * 1024 * 1024 * 1024;
    private int maxMemSize = 4 * 1024;
    private File file;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            HttpSession ses = request.getSession();
            String titulo = request.getParameter("titulo");
            String keyw = request.getParameter("keyw");
            String pdf = request.getParameter("pdf");
            System.out.println(titulo + keyw + pdf);
            pdf = "docs/protocolos/" + pdf;
            String[] palabras = keyw.split(",");
            String boleta = "";
            String clave = "";
            String mensaje = "";
            AccesoSincronizadoDatos bd = new AccesoSincronizadoDatos();

            filePath = request.getRealPath("/") + "docs\\protocolos\\";
            isMultipart = ServletFileUpload.isMultipartContent(request);
            response.setContentType("text/html");

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

            // Parse the request to get file items.
            List fileItems;
            try {
                fileItems = upload.parseRequest(request);

                // Process the uploaded file items
                Iterator it = fileItems.iterator();

                out.println("<html>");
                out.println("<head>");
                out.println("<title>Servlet upload</title>");
                out.println("</head>");
                out.println("<body>");

                while (it.hasNext()) {
                    FileItem fi = (FileItem) it.next();
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
                        String dir = "docs/protocolos/" + fileName;
                    }

                    bd.obtenerConexion();

                    ResultSet rs2 = null;
                    rs2 = bd.llamarProcedimiento("sp_getBoleta('" + (String) ses.getAttribute("usuario") + "')");
                    while (rs2.next()) {
                        boleta = rs2.getString(1);
                    }
                    System.out.println("Boleta: " + boleta);
                    System.out.println((String) ses.getAttribute("usuario"));
                    System.out.println("sp_insertMyProt(" + boleta + ",'" + titulo + "','" + pdf + "')");
                    ResultSet rs = bd.llamarProcedimiento("sp_insertMyProt(" + boleta + ",'" + titulo + "','" + pdf + "')");

                    while (rs.next()) {
                        if (rs.getString(1).equals("1")) {
                            clave = rs.getString(3);
                            for (int i = 0; i < palabras.length; i++) {
                                rs = bd.llamarProcedimiento("sp_regKeyW('" + clave + "','" + palabras[i] + "')");
                            }
                            out.println("1");
                            mensaje = "Se ha registrado el protocolo.";

                        } else {
                            out.println("0");
                            mensaje = "Ya tienes un protocolo registrado";
                        }
                    }
                    response.sendRedirect("RegistroProtocolo.jsp?mensaje=" + mensaje);

                }
            } catch (Exception ex) {
                Logger.getLogger(RegistrarProtocolo2.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
