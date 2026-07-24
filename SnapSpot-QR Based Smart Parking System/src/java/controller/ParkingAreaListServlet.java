package controller;

import dao.ParkingAreaDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Admin;
import model.ParkingArea;
import constant.AppConstants;

public class ParkingAreaListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

HttpSession session = request.getSession(false);

if (session == null || session.getAttribute(AppConstants.SESSION_ADMIN) == null) {
    response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
    return;
}

Admin admin = (Admin) session.getAttribute(AppConstants.SESSION_ADMIN);

request.setAttribute("admin", admin);

        ParkingAreaDAO parkingAreaDAO = new ParkingAreaDAO();
        List<ParkingArea> parkingAreaList = parkingAreaDAO.getAllParkingAreas();

        request.setAttribute("admin ", admin);
        request.setAttribute("parkingAreaList", parkingAreaList);

        request.getRequestDispatcher("/admin/parking-area-list.jsp")
               .forward(request, response);
    }
}