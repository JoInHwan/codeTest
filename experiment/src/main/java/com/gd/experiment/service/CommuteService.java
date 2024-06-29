package com.gd.experiment.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gd.experiment.controller.CommuteController;
import com.gd.experiment.dto.CommuteDto;
import com.gd.experiment.mapper.CommuteMapper;

import lombok.extern.slf4j.Slf4j;

import java.util.Date;
import java.util.HashMap;

@Transactional
@Service
@Slf4j
public class CommuteService {
	final String RED = "\u001B[31m\n";
	final String YELLOW = "\u001B[33m\n";	
	final String RESET = "\u001B[0m\n";
	
	@Autowired
	CommuteMapper commuteMapper;
	
	final Date today = new Date();
	
	// CommuteDto c = commuteMapper.checkCommute(id);
//	String time = c.getInTime();
//	return time;
	
	//출근 등록
	public int commuteIntime(String id) {	
		return commuteMapper.commuteInTime(id) ;
	}
	
	//퇴근 등록
	public int commuteOutTime(String id) {		
		return commuteMapper.commuteOutTime(id);		
	}
	
		
	// 출퇴근 여부
	public Map<String,Object> checkCommute(String id) {		
		System.out.println("테스트: " + id);		
		
		CommuteDto checkCommute = commuteMapper.checkCommute(id);			
		log.debug(RED + "서비스컨트롤 출퇴근정보: " + checkCommute + RESET );

		Map<String, Object> timeMap = new HashMap<>();
		timeMap.put("id", id ); 
		if(checkCommute != null ) {
			timeMap.put("inTime",  checkCommute.getInTime());		
			if(checkCommute.getOutTime() != null) {
				timeMap.put("outTime",  checkCommute.getOutTime());		
			}				
		}
		return timeMap;		
	}
	
	
	
	
	
	// 출퇴근이력
	public List<CommuteDto> selectMyCommuteHistory(String id){
		
		return commuteMapper.selectMyCommuteHistory(id);
	}
	
}
