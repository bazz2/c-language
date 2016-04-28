package hello;
import org.apache.log4j.Logger;

public class HelloWorld {

    private static final Logger LOGGER = Logger.getLogger(HelloWorld.class);

    public static void main(String[] args) {
        MessageService service = new MessageService();

        String msg = service.getMessage();
        LOGGER.info("Received message: " + msg);
    }
}
