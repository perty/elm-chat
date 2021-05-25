package se.artcomputer.edu.chat;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collection;

@RequestMapping("${api.base.path}/channels")
@RestController
public class ChannelController {

    private final ChannelService channelService;

    public ChannelController(ChannelService channelService) {
        this.channelService = channelService;
    }

    @GetMapping
    public ResponseEntity<Collection<String>> listChannels() {
        return new ResponseEntity<>(channelService.listChannels(), HttpStatus.OK);
    }

    @GetMapping("/{channel}/messages")
    public ResponseEntity<Collection<Message>> listChannelMessages(@PathVariable String channel) {
        return new ResponseEntity<>(channelService.listChannelMessages(channel), HttpStatus.OK);
    }

    @PostMapping("/{channel}/messages")
    public ResponseEntity<String> postMessage(@PathVariable String channel, @RequestBody String message) {
        return new ResponseEntity<>(channelService.postMessage(channel, message), HttpStatus.OK);
    }

}

