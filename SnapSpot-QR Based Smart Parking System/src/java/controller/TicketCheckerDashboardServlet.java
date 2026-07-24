package controller;

import constant.AppConstants;
import dao.EntryExitLogDAO;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.TicketChecker;

public class TicketCheckerDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession(false);
            
            if (session == null) {
                
                response.sendRedirect(
                        request.getContextPath()
                                + "/ticket-checker/login.jsp");
                
                return;
                
            }
            
            TicketChecker checker =
                    (TicketChecker) session.getAttribute(
                            AppConstants.SESSION_TICKET_CHECKER);
            
            if (checker == null) {
                
                response.sendRedirect(
                        request.getContextPath()
                                + "/ticket-checker/login.jsp");
                
                return;
                
            }
            
            
            EntryExitLogDAO logDAO = new EntryExitLogDAO();
            
            int todayEntries = logDAO.getTodayEntryCount(checker.getCheckerId());
            int todayExits = logDAO.getTodayExitCount(checker.getCheckerId());
            int activeVehicles = logDAO.getActiveVehicleCount();
            
            request.setAttribute("todayEntries", todayEntries);
            request.setAttribute("todayExits", todayExits);
            request.setAttribute("activeVehicles", activeVehicles);
            
            request.setAttribute(
                    "ticketChecker",
                    checker);
            
            request.getRequestDispatcher(
                    "/ticket-checker/dashboard.jsp").forward(request,
                            response);
        } catch (SQLException ex) {
            Logger.getLogger(TicketCheckerDashboardServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

}