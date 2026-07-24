import org.mindrot.jbcrypt.BCrypt;

public class GenerateCheckerHash {

    public static void main(String[] args) {

                String hash = BCrypt.hashpw(
                "checker123",
                BCrypt.gensalt());

        System.out.println(hash);
    }
}