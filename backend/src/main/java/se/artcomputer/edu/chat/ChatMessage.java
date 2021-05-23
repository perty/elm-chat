package se.artcomputer.edu.chat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ChatMessage {
    private static final Logger LOG = LoggerFactory.getLogger(ChatMessage.class);
    private String from;
    private String text;
    private String recipient;

    public ChatMessage(String from, String text, String recipient) {
        this.from = from;
        this.text = text;
        this.recipient = recipient;
    }

    public String getFrom() {
        return from;
    }

    public void setFrom(String from) {
        this.from = from;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getRecipient() {
        return recipient;
    }

    public void setRecipient(String recipient) {
        this.recipient = recipient;
    }
}

