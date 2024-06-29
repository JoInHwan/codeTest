package com.gd.experiment.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gd.experiment.dto.CommuteDto;
import com.gd.experiment.service.CommuteService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CommuteController {	
	final String RED = "\u001B[31m\n";
	final String YELLOW = "\u001B[33m\n";	
	final String RESET = "\u001B[0m\n";
	
	@Autowired CommuteService commuteService;
	
	
	@GetMapping("/main") // 로그인 폼
	public String main(HttpSession session,Model model) { 
		Map<String, Object> loginInfo =(Map<String, Object>) session.getAttribute("loginInfo");
		String id = (String)(loginInfo.get("id"));
		
		
		List<CommuteDto>list = commuteService.selectMyCommuteHistory(id);
		
		
		model.addAttribute(list);
		return "/main";
	}
	
	// 출근등록
	@GetMapping("/attend")
	public @ResponseBody int attend( 
						@RequestParam(name = "id") String id) {		
		
		int success = commuteService.commuteIntime(id);
		log.debug(YELLOW + "출근시간: " + success + RESET );
		
		return success;
	}
	
	// 퇴근등록
	@GetMapping("/getOff")
	public @ResponseBody int getOff( 
						@RequestParam(name = "id") String id) {		
		
		int success = commuteService.commuteOutTime(id);
		log.debug(RED + "퇴근시간: " + success + RESET );
		
		return success;
	}
	
	// 출퇴근여부
	@GetMapping("/commuteCheck")	
	public @ResponseBody Map<String,Object> commuteCheck(@RequestParam String id) {
		
		// 출퇴근한적이 없으면 null값이 반환되어서 json형태로 받을 때 에럭가 뜸
		
		return commuteService.checkCommute(id);
	}
	
	
}
