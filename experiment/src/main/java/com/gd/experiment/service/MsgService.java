package com.gd.experiment.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gd.experiment.dto.MsgDto;
import com.gd.experiment.mapper.MsgMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MsgService {
	final String RED = "\u001B[31m\n";
	final String YELLOW = "\u001B[33m\n";	
	final String RESET = "\u001B[0m\n";
	
	@Autowired MsgMapper msgMapper;
	
	// 쪽지리스트
	public List<MsgDto> getMsgList(String id){
		
		return msgMapper.selectMsgList(id);
	}
	
	// 안읽은 쪽지수
	public int msgReceive(String id){
		log.debug(RED + "id: " + id + " 행수 : "+ msgMapper.msgReceive(id) + RESET );
		return msgMapper.msgReceive(id);
	}
	
	// 쪽지쓰기
	
	public int addMsg(String sender,String receiver,String title,String content) {
		
		Map<String,Object>paramMap = new HashMap<>();
		paramMap.put("sender", sender);
		paramMap.put("receiver", receiver);
		paramMap.put("title", title);
		paramMap.put("content", content);
		
		log.debug(YELLOW + "paramMap: " + paramMap + RESET );
		
		int success = msgMapper.insertMsg(paramMap); 		
		log.debug(RED + "입력성공여부: " + success + RESET );
		
		return 1;
	}
}
