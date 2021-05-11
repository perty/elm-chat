package se.artcomputer.edu.chat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import java.util.Map;

@Component
public class WebSocketEventListener {

    private static final Logger LOG = LoggerFactory.getLogger(WebSocketEventListener.class);

    private final SimpMessageSendingOperations messagingTemplate;

    @Autowired
    public WebSocketEventListener(SimpMessageSendingOperations messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    @EventListener
    public void handleWebSocketConnectListener(SessionConnectedEvent event) {
        LOG.info("Received a new web socket connection {}.", event.getUser());
    }

    @EventListener
    public void handleWebSocketDisconnectListener(SessionDisconnectEvent event) {
        LOG.info("Disconnect event.");
        var headerAccessor = StompHeaderAccessor.wrap(event.getMessage());

        Map<String, Object> sessionAttributes = headerAccessor.getSessionAttributes();
        if (sessionAttributes != null) {
            String username = (String) sessionAttributes.get("username");
            if (username != null) {
                LOG.info("User Disconnected : {}", username);

                var chatMessage = new ChatMessage();
                chatMessage.setType(ChatMessage.MessageType.LEAVE);
                chatMessage.setSender(username);

                messagingTemplate.convertAndSend("/topic/public", chatMessage);
            }
        }
    }
}