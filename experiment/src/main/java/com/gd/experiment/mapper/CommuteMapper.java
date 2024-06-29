package com.gd.experiment.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.gd.experiment.dto.CommuteDto;

@Mapper
public interface CommuteMapper {
	
	// 출근등록
	int commuteInTime(String id);
	
	// 퇴근등록
	int commuteOutTime(String id);
	
	// 출근 체크
	CommuteDto checkCommute(String id);	
		
	// 통근이력
	List<CommuteDto> selectMyCommuteHistory(String s);
}
