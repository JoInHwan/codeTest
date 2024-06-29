package com.gd.experiment.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.gd.experiment.dto.MsgDto;


@Mapper
public interface MsgMapper {
	
	
		// 쪽지 리스트
		List<MsgDto> selectMsgList(String id);	
		// 받은 쪽지 수 
		int msgReceive(String id);
		
		// 쪽지 읽기처리  (미완)
		int updateMsgToRead(String id);
		
		
		
		// int selectCount();
		
		// 쪽지상세
		// MsgDto selectMsgOne(MsgDto m);
		// 쪽지 추가
		int insertMsg(Map<String,Object>m);
		// 쪽지 삭제
		int deleteMsg(MsgDto m);
		
	
}
