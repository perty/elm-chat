package se.artcomputer.edu.chat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
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

    List<Message> listChannelMessages(String channel) {
        LOG.info("List messages for channel {}", channel);
        Message message = new Message();
        message.setAuthor("Anna Bot");
        message.setContent("This is the only message of the '" + channel + "' channel.");
        message.setCreated(new Date().getTime());
        return Collections.singletonList(message);
    }
}

