package se.artcomputer.edu.chat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.springframework.web.util.HtmlUtils;

import java.io.IOException;
import java.time.LocalTime;

@Component
public class WebSocketHandler extends TextWebSocketHandler {
    private static final Logger LOG = LoggerFactory.getLogger(WebSocketHandler.class);

    @Autowired
    private SessionManager sessionManager;

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        LOG.info("Server connection opened");
        sessionManager.addSession(session);

        var message = new TextMessage("one-time message from server");
        LOG.info("Server sends: {}", message);
        session.sendMessage(message);
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        LOG.info("Server connection closed: {}", status);
        sessionManager.removeSession(session);
    }

    @Scheduled(fixedRate = 1000)
    void sendPeriodicMessages() throws IOException {
        for (WebSocketSession session : sessionManager.getAllSessions()) {
            if (session.isOpen()) {
                String broadcast = "server periodic message " + LocalTime.now();
                LOG.info("Server sends: {}", broadcast);
                session.sendMessage(new TextMessage(broadcast));
            }
        }
    }

    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String request = message.getPayload();
        LOG.info("Server received: {}", request);

        var response = String.format("response from server to '%s'", HtmlUtils.htmlEscape(request));
        LOG.info("Server sends: {}", response);
        session.sendMessage(new TextMessage(response));
    }

    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) {
        LOG.info("Server transport error: {}", exception.getMessage());
    }
}