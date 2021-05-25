package se.artcomputer.edu.chat;

public class NewChatMessage {
    Payload newChatMessage;

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

    }

}
