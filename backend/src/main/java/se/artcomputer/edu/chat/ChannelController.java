package se.artcomputer.edu.chat;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RequestMapping("${api.base.path}/channels")
@RestController
public class ChannelController {

    private final ChannelService channelService;

    public ChannelController(ChannelService channelService) {
        this.channelService = channelService;
    }

    @GetMapping
    public ResponseEntity<List<String>> listChannels() {
        return new ResponseEntity<>(channelService.listChannels(), HttpStatus.OK);
    }

    @GetMapping("/{channel}/messages")
    public ResponseEntity<List<Message>> listChannelMessages(@PathVariable String channel) {
        return new ResponseEntity<>(channelService.listChannelMessages(channel), HttpStatus.OK);
    }

}

