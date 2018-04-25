package hello;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

import java.net.InetAddress;
import java.net.UnknownHostException;

@RestController
public class HelloController {

    @RequestMapping("/")
    public String index() {

        try {
            return "Greetings from " + InetAddress.getLocalHost().getHostName();
        } catch (UnknownHostException e) {
            return e.getMessage();
        }

    }

}
