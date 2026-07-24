package securevault;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class AppContextListener implements ServletContextListener {

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        DBConnection.closeConnection();
        DBConnection.closeDriver();
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // optional: warm-up connection
        DBConnection.getConnection();
    }
}
