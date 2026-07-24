package filter;

import constant.AppConstants;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * ============================================================
 * LoginFilter
 * ============================================================
 * Protects all user pages.
 *
 * NOTE:
 * Configure this filter in web.xml
 * ============================================================
 */
public class LoginFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig)
            throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req =
                (HttpServletRequest) request;

        HttpServletResponse res =
                (HttpServletResponse) response;

        HttpSession session =
                req.getSession(false);

        boolean loggedIn = false;

        if (session != null) {

            loggedIn =
                    session.getAttribute(
                            AppConstants.SESSION_USER)
                    != null;

        }

        if (loggedIn) {

            chain.doFilter(request, response);

        } else {

            res.sendRedirect(
                    req.getContextPath()
                    + "/user/login.jsp");

        }

    }

    @Override
    public void destroy() {

    }

}