package se.artcomputer.edu.chat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.Collection;
import java.util.Date;

@Service
public class ChannelService {
    private static final Logger LOG = LoggerFactory.getLogger(ChannelService.class);
    private static final String OK = "\"ok\"";
    private ChannelRepository channelRepository;

    @Autowired
    public ChannelService(ChannelRepository channelRepository) {
        this.channelRepository = channelRepository;
    }

    Collection<String> listChannels() {
        return channelRepository.getChannels();
    }

    Collection<Message> listChannelMessages(String channel) {
        LOG.info("List messages for channel {}", channel);
        return channelRepository.getMessages(channel);
    }

    public String postMessage(String channel, String messageText) {
        LOG.info("Post in channel {}, message {}.", channel, messageText);
        Message message = new Message();
        message.author = "fake";
        message.content = messageText;
        message.created = Date.from(Instant.now()).getTime();
        channelRepository.save(channel, message);
        return OK;
    }
}

