package se.artcomputer.edu.chat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;
import java.util.List;

@RequestMapping("${api.base.path}/channels")
@RestController
public class ChannelController {
    private static final Logger LOG = LoggerFactory.getLogger(ChannelController.class);

    @GetMapping
    public ResponseEntity<List<String>> listChannels() {
        return new ResponseEntity<>(chatList(), HttpStatus.OK);
    }

    private List<String> chatList() {
        return Arrays.asList(
                "general",
                "jobs",
                "news-and-links"
        );
    }

}

