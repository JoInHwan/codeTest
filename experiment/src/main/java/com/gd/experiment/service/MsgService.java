package com.gd.experiment.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
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
	
	// 안읽은 쪽지수
		public int msgReceive(String id){
			log.debug(RED + "id: " + id + " 행수 : "+ msgMapper.msgReceive(id) + RESET );
			return msgMapper.msgReceive(id);
		}
	

		// MsgDto msgDto = new MsgDto();
		// List<MsgDto>s = s.;
		
//		for(MsgDto m : msgMapper.selectReceiveMsgList(id)) {
//			log.debug(RED + "확인: " + m + RESET );			
//			if(m.getSendDel().equals("N") ) { // 삭제하지 않은것만 처리
//				
//			}
//			 
//		}
		
	// 쪽지리스트
	public List<MsgDto> getMsgList(String id, int request){		
		
		Map<String,Object>m = new HashMap<>();
		m.put("id", id);
		m.put("request", request);
		// 1 받은거 3 보낸거 4 삭제한거
		
		return msgMapper.selectMsgList(m);
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
	
	
	// 쪽지 상태 처리
	public int modifyMsgState(Map<String,Object>m) {
		msgMapper.updateMsgState(m);
		return 1;
	}
	
	
	
	// 자동삭제
	@Scheduled(cron = "0 59 17 * * *")
	void deleteMsg() {
		int success = msgMapper.deleteMsgBySchedule();
		log.debug(RED + "삭제처리완료 : " + success + RESET );
	}
	
}
