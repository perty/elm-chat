package se.artcomputer.edu.chat;

import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class ChannelRepository {
    private static final Map<String, List<Message>> channels = new HashMap<>();

    public  Collection<String> getChannels() {
        return channels.keySet();
    }

    public  Collection<Message> getMessages(String channel) {
        return channels.get(channel);
    }

    public  Message save(String channel, Message message) {
        List<Message> messages = new ArrayList<>(channels.get(channel));
        messages.add(message);
        channels.put(channel, messages);
        return message;
    }

    static {
        channels.put("news-and-links", lotsOfMessages());
        channels.put("general", singleMessage("general"));
        channels.put("jobs", singleMessage("jobs"));
    }

    private static List<Message> singleMessage(String channel) {
        var message = new Message();
        message.setAuthor("Anna Bot");
        message.setContent("This is the only message of the '" + channel + "' channel.");
        message.setCreated(new Date().getTime());
        return Collections.singletonList(message);
    }

    private static List<Message> lotsOfMessages() {
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
}
