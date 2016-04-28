package hello;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.assertEquals;

public class MessageServiceTest {
    private MessageService service;

    @Before
    public void setUp() {
        service = new MessageService();
    }

    @Test
    public void getMessage_ShouldReturnMessage() {
        assertEquals("nihao Hello world", service.getMessage());
    }
}
