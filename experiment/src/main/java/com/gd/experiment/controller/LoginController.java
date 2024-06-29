package com.gd.experiment.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.gd.experiment.mapper.LoginMapper;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class LoginController {
	@Autowired LoginMapper loginMapper;
	
	final String RED = "\u001B[31m\n";
	final String YELLOW = "\u001B[33m\n";	
	final String RESET = "\u001B[0m\n";
	
	
	@GetMapping("/login") // 로그인 폼
	public String login() { 
		
		return "login";
	}
	
	@PostMapping("/login") // 로그인 액션
	public String login(HttpSession session, 
						@RequestParam(name = "id") String id, 
						@RequestParam(name = "pw") String pw
			) {	
		
		log.debug(YELLOW + "paramId: " + id + "paramPw: " + pw + RESET );		
		
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("id", id);
		paramMap.put("pw", pw);
		
		Map<String, Object> loginInfo = loginMapper.login(paramMap);
		
		log.debug(YELLOW + "loginInfo: " + loginInfo + RESET );
		if( loginInfo != null) {			
			session.setAttribute("loginInfo", loginInfo);
			return "redirect:/main";
		}
		
		
		return "login";
		
	}
	
	@GetMapping("/logout") // 로그아웃
	public String logout(HttpSession session) {
		session.invalidate();
		log.debug(RED + "로그아웃 되었습니다" + RESET );
		return "redirect:/login";
	}
	
	
		
}
