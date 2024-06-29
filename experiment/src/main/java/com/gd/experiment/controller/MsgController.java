package com.gd.experiment.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gd.experiment.dto.MsgDto;
import com.gd.experiment.service.MsgService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MsgController {
	final String RED = "\u001B[31m\n";
	final String YELLOW = "\u001B[33m\n";	
	final String RESET = "\u001B[0m\n";
	
	@Autowired MsgService msgService;
	
	@GetMapping("/msgList") 
	public String msg(
					HttpSession session,
					Model model	) { 
		
		Map<String,Object> loginInfo = (Map<String,Object>)(session.getAttribute("loginInfo"));
		String id = (String)loginInfo.get("id");
		
		List<MsgDto>list = msgService.getMsgList(id);
		
		log.debug(YELLOW + "Msg loginInfo: " + loginInfo + RESET );	
		
		model.addAttribute("list",list);
		return "msgList";
	}

	@PostMapping("/sendMessage")
	@ResponseBody
	public int sendMsg( 	
			@RequestParam(name = "sender") String sender,
			@RequestParam(name = "receiver") String receiver,
			@RequestParam(name = "title") String title,
			@RequestParam(name = "content") String content) {
		
		log.debug(YELLOW + "(컨)sender: " + sender + " receiver: " + receiver + " title: " + title + " content: " + content +  RESET );	
		
		msgService.addMsg(sender, receiver, title, content);
		
		return 1;
	}
	
	
}
