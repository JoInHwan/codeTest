package com.gd.experiment.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.gd.experiment.service.MsgService;

import lombok.extern.slf4j.Slf4j;




@Slf4j


@org.springframework.web.bind.annotation.RestController
public class RestController {
    final String RED = "\u001B[31m\n";
    final String YELLOW = "\u001B[33m\n";    
    final String RESET = "\u001B[0m\n";
    
    @Autowired MsgService msgService;
    
    @GetMapping("/msgReceive")
    public Map<String, Integer> msgReceive(@RequestParam String id) {
        
        log.debug(RED + "id: " + id + RESET );
        int messageCount = msgService.msgReceive(id);

        Map<String, Integer> response = new HashMap<>();
        response.put("messageCount", messageCount);

        return response;
    }
}
