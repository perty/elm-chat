package se.artcomputer.edu.chat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class ChannelService {
    private static final Logger LOG = LoggerFactory.getLogger(ChannelService.class);
    private static final String OK = "\"ok\"";

    List<String> listChannels() {
        List<String> result = new ArrayList<>();
        for (var n = 0; n < 10; n++) {
            result.addAll(Arrays.asList(
                    "general",
                    "jobs",
                    "news-and-links"
            ));
        }
        return result;
    }

    List<Message> listChannelMessages(String channel) {
        LOG.info("List messages for channel {}", channel);
        if (channel.equals("news-and-links")) {
            return lotsOfMessages();
        }
        var message = new Message();
        message.setAuthor("Anna Bot");
        message.setContent("This is the only message of the '" + channel + "' channel.");
        message.setCreated(new Date().getTime());
        return Collections.singletonList(message);
    }

    private List<Message> lotsOfMessages() {
        List<Message> messages = new ArrayList<>();
        for (var n = 0; n < 200; n++) {
            var message = new Message();
            message.setAuthor("Anna Bot");
            message.setContent("This a news message. It can be very boring. It may make you sleep. You can read more here.");
            message.setCreated(new Date().getTime());
            messages.add(message);
        }
        return messages;
    }

    public String postMessage(String channel, String message) {
        LOG.info("Post in channel {}, message {}.", channel, message);
        return OK;
    }
}

