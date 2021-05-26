package se.artcomputer.edu.chat;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class NewChatMessage {
    private Payload newChatMessage;

    public Payload getNewChatMessage() {
        return newChatMessage;
    }

    public String asJSON() throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        return mapper.writeValueAsString(this) ;
    }

    public NewChatMessage() {

    }

    public NewChatMessage(String channel, Message message) {
        this.newChatMessage = new Payload(channel, message.content);
    }

    public static class Payload {
        String channel;
        String message;

        public Payload() {

        }

        public Payload(String channel, String message) {
            this.channel = channel;
            this.message = message;
        }

        public String getChannel() {
            return channel;
        }

        public String getMessage() {
            return message;
        }
    }

}
