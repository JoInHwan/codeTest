package com.gd.experiment.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
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
	
	@GetMapping("/msgList/{request}") 
	public String msg(	
					@PathVariable(name= "request", required = false) Integer request,
					HttpSession session,
					Model model		) { 
		log.debug(YELLOW + "확인" + request + RESET );	
		if( request == null) {
			request = 0;
		}
		Map<String,Object> loginInfo = (Map<String,Object>)(session.getAttribute("loginInfo"));
		
		List<MsgDto>list = msgService.getMsgList((String)loginInfo.get("id"),request);
		
		// log.debug(YELLOW + "Msg loginInfo: " + loginInfo + RESET );	
		
		model.addAttribute("list",list);
		if(request == 1) {
			return "msgSendList";
		}else if (request==2){
			return "msgWasteBasket";
		}
		return "msgList";
	}
		

	@PostMapping("/sendMessage")
	@ResponseBody
	public int sendMsg( 	
			@RequestParam(name = "sender") String sender,
			@RequestParam(name = "receiver") String receiver,
			@RequestParam(name = "title") String title,
			@RequestParam(name = "content") String content) {
		
		log.debug(YELLOW + "(컨)sender: " + sender + " receiver: " + 
						receiver + " title: " + title + " content: " + content +  RESET );	
		
		
		msgService.addMsg(sender, receiver, title, content);
		
		return 1;
	}
	
	@PostMapping("/deleteMessages")
	@ResponseBody
	public int deleteMessages(
	            @RequestParam(name="loginId") String id,
	            @RequestParam(name="request") String request,
	            @RequestParam(name="msgNums", required=false) String[] msgNums) {
	    // 배열의 내용을 보기 위해 Arrays.toString()을 사용합니다.
	    log.debug(YELLOW + "(컨)번호: " + Arrays.toString(msgNums) + " request: " + request + RESET); 
	    log.debug(YELLOW + "개수 " + msgNums.length + RESET); 
	    
	    int result = 0;
	    Map<String, Object> deleteMsgMap = new HashMap<>();
	    for (String no : msgNums) {
	        deleteMsgMap.put("id", id);
	        deleteMsgMap.put("request", request);
	        deleteMsgMap.put("msgNum", no); // 여기서 msgNum을 각각의 no로 수정합니다.
	         log.debug(YELLOW + "(컨)삭제 결과: " + deleteMsgMap + RESET); 
	        result = result + msgService.modifyMsgState(deleteMsgMap);
	    }
	    
	    log.debug(RED + "result: " + result + RESET );
	    if(msgNums.length == result ) {
	    	return 1;
	    }else {
	    	return 0;
	    }
	    
	}

	
}
