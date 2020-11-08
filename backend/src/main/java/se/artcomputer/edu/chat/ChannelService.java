package se.artcomputer.edu.chat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@Service
public class ChannelService {
    private static final Logger LOG = LoggerFactory.getLogger(ChannelService.class);

    List<String> listChannels() {
        return Arrays.asList(
                "general",
                "jobs",
                "news-and-links"
        );
    }

    List<Message> listChannelMessages() {
        return Collections.emptyList();
    }
}

