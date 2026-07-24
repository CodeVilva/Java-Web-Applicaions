package controller; // Change this to match your actual package name

import dao.TicketCheckerDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.TicketChecker;
// Import your DAO class package here, for example:
// import dao.TicketCheckerDAO; 

public class FetchTicketCheckerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("checkerId");
        
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                // 1. Convert the String ID from the URL into an int
                int id = Integer.parseInt(idStr.trim());
                
                // 2. Initialize your database class and call your method
                // (Replace TicketCheckerDAO with your actual DAO class name if different)
                TicketCheckerDAO dao = new TicketCheckerDAO(); 
                TicketChecker checker = dao.getTicketCheckerById(id);
                
                if (checker != null) {
                    // 3. Save the database object into the request scope
                    request.setAttribute("checker", checker);
                    
                    // 4. Forward to your presentation file
                    request.getRequestDispatcher("/admin/edit-ticket-checker.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid ID format received: " + idStr);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        // If anything goes wrong, safely redirect them back to the list
        response.sendRedirect(request.getContextPath() + "/TicketCheckerListServlet");
    }
}
