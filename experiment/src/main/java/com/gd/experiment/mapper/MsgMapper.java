package com.gd.experiment.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.gd.experiment.dto.MsgDto;


@Mapper
public interface MsgMapper {
		
	// 받은 쪽지 수 
		int msgReceive(String id);
	
		
		// 수신 쪽지 리스트  
		List<MsgDto> selectMsgList(Map<String,Object>m);	
		
		// 발신 쪽지 리스트
		List<MsgDto> selectSendMsgList(String id);	
		
		// 수신자 휴지통
		List<MsgDto> selectReceiveMsgTrash(String id);
				
		// 발신자 휴지통
		List<MsgDto> selectSendMsgTrash(String id);
			
		/*  UPDATE 처리해야할 것   -> 모두 하나의 같은 ROW에 대한 처리
			// 수신자가 확인했을때     -> read_time 값 채우기
			
			// 발신자가 삭제했을떄 (휴지통이동)  -> send_Del 값 Y로변경
			
			// 수신자가 삭제했을때 (휴지통이동)  -> receive_Del 값 Y로 변경
			
			// 발신자가 휴지통에서 삭제했을떄    -> send_Del 값 D로변경
			
			// 수신자가 휴지통에서 삭제했을때 	-> receive_Del 값 Y로 변경
			
			// 발신자가 복원했을떄			-> send_Del 값 N으로변경
			
			// 수신자가 복원했을때			-> receive_Del 값 N으로 변경
		 */
		
		// 발신자,수신자가 모두 최종삭제햇을떄   -> 스케줄러를 통한 delete 
		int deleteMsgBySchedule();
		
		int updateMsgState(Map<String,Object>m);
		
		// 쪽지 읽기처리  (미완)
		int updateMsgToRead(String id);
		
		
		
		// int selectCount();
		
		// 쪽지상세
		// MsgDto selectMsgOne(MsgDto m);
		// 쪽지 추가
		int insertMsg(Map<String,Object>m);
	
		
	
}
