package se.artcomputer.edu.chat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import java.io.IOException;
import java.time.Instant;
import java.util.Collection;
import java.util.Date;

@Service
public class ChannelService {
    private static final Logger LOG = LoggerFactory.getLogger(ChannelService.class);
    private static final String OK = "\"ok\"";
    private final ChannelRepository channelRepository;
    private final SessionManager sessionManager;

    @Autowired
    public ChannelService(ChannelRepository channelRepository, SessionManager sessionManager) {
        this.channelRepository = channelRepository;
        this.sessionManager = sessionManager;
    }

    Collection<String> listChannels() {
        return channelRepository.getChannels();
    }

    Collection<Message> listChannelMessages(String channel) {
        LOG.info("List messages for channel {}", channel);
        return channelRepository.getMessages(channel);
    }

    public String postMessage(String channel, String messageText) throws IOException {
        LOG.info("Post in channel {}, message {}.", channel, messageText);
        Message message = new Message();
        message.author = "fake";
        message.content = messageText;
        message.created = Date.from(Instant.now()).getTime();
        channelRepository.save(channel, message);
        NewChatMessage newChatMessage = new NewChatMessage(channel, message);
        String asString = newChatMessage.asJSON();
        for (WebSocketSession session : sessionManager.getAllSessions()) {
            session.sendMessage(new TextMessage(asString));
        }
        return OK;
    }
}

