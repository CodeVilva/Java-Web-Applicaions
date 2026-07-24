<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // ✅ Invalidate the session
    session.invalidate();

    // ✅ Optional: clear cache so browser back button doesn’t reopen session pages
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies

    // ✅ Redirect to home or login page after logout
    response.sendRedirect("index.jsp?msg=loggedOut");
%>