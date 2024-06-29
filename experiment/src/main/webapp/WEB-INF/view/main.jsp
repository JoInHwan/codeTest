<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- jQuery 포함 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<title>Insert title here</title>
<c:set var="loginInfo" value="${sessionScope.loginInfo}"/>

<style>
    .date{
        font-size: 45px;   
    }
    .time{
        font-size: 100px;
        font-weight: bold;
        color: purple;
    }
</style>
</head>
<body class="container"><br>
    <h2>메인페이지</h2>
    <h1></h1>
    
    <h2>${loginInfo.name}님 환영합니다</h2>
    <span id="msgAlert">입력</span> <br>

    <a href="logout" class="btn btn-danger">로그아웃</a>    
    <a href="msgList" class="btn btn-info">쪽지함 가기</a>
    
    <div id="date" class="date"></div>
    <div id="time" class="time"></div>
    
    <div>
        <div>출근시간: <span id="checkInTime"> </span></div>
        <div>퇴근시간: <span id="checkOutTime"> </span></div>        
        <button type="button" id="checkInBtn" class="btn btn-outline-success">출근하기</button>
        <button type="button" id="checkOutBtn" class="btn btn-outline-danger">퇴근하기</button>
    </div>

    <!-- 공통 모달 -->
    <div class="modal fade" id="confirmationModal" tabindex="-1" aria-labelledby="confirmationModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="confirmationModalLabel"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    현재시간은 '<span id="currentTime"></span>' 입니다. <span id="actionText"></span>하시겠습니까?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" id="confirmActionBtn">확인</button>
                </div>
            </div>
        </div>
    </div>
        
</body>
<script>    
$(document).ready(function(){ 
    loadList();
    setClock();
    setInterval(setClock, 1000); // 1초마다 setClock 함수 실행
    commuteCheck(); // 페이지 로드 시 출퇴근 상태 확인

    // 출근하기 버튼 클릭 이벤트 핸들러
    $("#checkInBtn").click(function() {
        showConfirmationModal("출근 확인", "출근");
    });

    // 퇴근하기 버튼 클릭 이벤트 핸들러
    $("#checkOutBtn").click(function() {
        showConfirmationModal("퇴근 확인", "퇴근");
    });

    // 모달 확인 버튼 클릭 이벤트 핸들러
    $("#confirmActionBtn").click(function() {  
        var action = $("#actionText").text();
        if(action === "출근") {
            attend();
        } else if(action === "퇴근") {
            checkOut();
        }          
    });       
});

function showConfirmationModal(title, action) {
    var currentTime = $("#time").text();
    $("#confirmationModalLabel").text(title);
    $("#currentTime").text(currentTime);
    $("#actionText").text(action);
    $("#confirmationModal").modal('show');
}

function loadList(){
    $.ajax({
        url: "/test/msgReceive", // 데이터를 가져올 URL
        type: "get", // GET 메서드를 사용
        data: {'id': '${loginInfo.id}'}, // id 값을 문자열로 전달
        dataType: "json", // 데이터 타입은 JSON
        success: function(data){ // 요청이 성공하면 실행
            console.log('data: ', data);
            // 서버에서 반환된 JSON 데이터에서 messageCount를 읽어와서 msgAlert 요소에 표시
            $("#msgAlert").text("읽지 않은 쪽지 개수: " + data.messageCount);
        },
        error: function(){ // 요청이 실패하면 실행
            alert("error"); // 에러 메시지 출력
        }
    });        
}

function commuteCheck(){
    $.ajax({
        url: "/test/commuteCheck", // 데이터를 가져올 URL
        type: "get", // GET 메서드를 사용
        data: {'id': '${loginInfo.id}'}, // id 값을 문자열로 전달
        dataType: "json", // 데이터 타입은 JSON
        success: function(data){ // 요청이 성공하면 실행
        	console.log('CommuteData: ', data);           
            if(data.inTime == null) {				// 출근을 아직 안찍은상테
            	console.log('11 CommuteData: ', data); 
                $("#checkOutBtn").prop("disabled", true);  // 출근버튼 비활성화
                $("#checkInBtn").prop("disabled", false);
                
            } else if(data.outTime == null ) {				// 퇴근을 아직 안했으면 (출근만찍은상태)
            	console.log('22 CommuteData: ', data); 
                $("#checkOutBtn").prop("disabled", false);
                $("#checkInBtn").prop("disabled", true);
                
                $("#checkInTime").text(data.inTime);
            } else {
            	console.log('33 CommuteData: ', data); 
                $("#checkOutBtn").prop("disabled", true);
                $("#checkInBtn").prop("disabled", true);
                
                $("#checkInTime").text(data.inTime);
                $("#checkOutTime").text(data.outTime);
            }
        },
        error: function(jqXHR, textStatus, errorThrown){ // 요청이 실패하면 실행
            console.error("에러 발생s: ", textStatus, errorThrown); // 에러 메시지 출력
            alert("출퇴근 상태를 확인하는 중 에러가 발생했습니다."); // 에러 메시지 출력
        }
    });
}


function attend(){
	  $.ajax({
	        url: "/test/attend", // 데이터를 가져올 URL
	        type: "get", // GET 메서드를 사용
	        data: {'id': '${loginInfo.id}'}, // id 값을 문자열로 전달
	        dataType: "json", // 데이터 타입은 JSON
	        success: function(attendTime){ // 요청이 성공하면 실행
	            console.log('attendTime: ', attendTime);
	            alert("출근 처리가 완료되었습니다.");
	            $('#confirmationModal').modal('hide');
	            commuteCheck(); // 출근 후 버튼 상태 업데이트
	        },
        error: function(jqXHR, textStatus, errorThrown){ // 요청이 실패하면 실행
          //  console.error("에러 발생: ", textStatus, errorThrown); // 에러 메시지 출력
            alert("출근 처리 중 에러가 발생했습니다."); // 에러 메시지 출력
        }
    });   
}


function checkOut(){
    $.ajax({
        url: "/test/getOff", // 데이터를 가져올 URL
        type: "get", // GET 메서드를 사용
        data: {'id': '${loginInfo.id}'}, // id 값을 문자열로 전달
        dataType: "json", // 데이터 타입을 text로 변경
        success: function(getOffTime){ // 요청이 성공하면 실행
            console.log('getOffTime: ', getOffTime);
         //    $("#checkOutTime").text(getOffTime); // checkOutTime의 아이디를 가진 span태그에 시간 입력
        
            alert("퇴근 처리가 완료되었습니다.");
            $('#confirmationModal').modal('hide');
            commuteCheck(); // 퇴근 후 버튼 상태 업데이트
        },
        error: function(jqXHR, textStatus, errorThrown){ // 요청이 실패하면 실행
        //    console.error("에러 발생: ", textStatus, errorThrown); // 에러 메시지 출력
            alert("퇴근 처리 중 에러가 발생했습니다."); // 에러 메시지 출력
        }
    });   
}


function setClock() {
    var dateInfo = new Date();
    var hour = modifyNumber(dateInfo.getHours());
    var min = modifyNumber(dateInfo.getMinutes());
    var sec = modifyNumber(dateInfo.getSeconds());
    var year = dateInfo.getFullYear();
    var month = dateInfo.getMonth() + 1; // monthIndex를 반환해주기 때문에 1을 더해준다.
    var date = dateInfo.getDate();
    
    $("#time").text(hour + ":" + min + ":" + sec);
    $("#date").text(year + "년 " + month + "월 " + date + "일");
}

function modifyNumber(time) {
    return (parseInt(time) < 10) ? "0" + time : time;
}
    
</script>
</html>


