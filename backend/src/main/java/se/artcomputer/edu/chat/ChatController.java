package se.artcomputer.edu.chat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Controller;

import java.util.Map;

@Controller
public class ChatController {
    private static final Logger LOG = LoggerFactory.getLogger(ChatController.class);

    @MessageMapping("/chat.sendMessage")
    @SendTo("/topic/public")
    public ChatMessage sendMessage(@Payload ChatMessage chatMessage) {
        LOG.info("New message from {}.", chatMessage.getSender());
        return chatMessage;
    }

    @MessageMapping("/chat.addUser")
    @SendTo("/topic/public")
    public ChatMessage addUser(@Payload ChatMessage chatMessage, 
                               SimpMessageHeaderAccessor headerAccessor) {
        LOG.info("Add user {}.", chatMessage.getSender());
        // Add username in web socket session
        Map<String, Object> sessionAttributes = headerAccessor.getSessionAttributes();
        if(sessionAttributes != null) {
            sessionAttributes.put("username", chatMessage.getSender());
        }
        return chatMessage;
    }

}
