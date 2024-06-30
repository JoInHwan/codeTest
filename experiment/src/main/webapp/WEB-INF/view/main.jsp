<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- Bootstrap CSS 및 JavaScript, jQuery 포함 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<title>메인페이지</title>

<!-- 세션에서 로그인 정보를 가져와서 loginInfo 변수에 저장 -->
<c:set var="loginInfo" value="${sessionScope.loginInfo}"/>

<style>
    .date {
        font-size: 45px;
    }
    .time {
        font-size: 100px;
        font-weight: bold;
        color: purple;
    }
</style>
</head>
<body class="container"><br>
    <h2>메인페이지</h2>
    <h1></h1>
    
    <!-- 로그인한 사용자 이름 표시 -->
    <h2>${loginInfo.name}님 환영합니다</h2>
    <span id="msgAlert">입력</span> <br>

    <!-- 로그아웃 및 쪽지함 이동 버튼 -->
    <a href="logout" class="btn btn-danger">로그아웃</a>    
    <a href="msgList/0" class="btn btn-info">쪽지함 가기</a>
    
    <!-- 현재 날짜 및 시간 표시 -->
    <div id="date" class="date"></div>
    <div id="time" class="time"></div>
    
    <div>
        <!-- 출퇴근 시간 및 버튼 -->
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
    $(document).ready(function() { 
        // 페이지 로드 시 초기 설정
        checkNotReadMsg(); // 읽지 않은 메시지 개수 로드
        setClock(); // 시계 설정
        setInterval(setClock, 1000); // 1초마다 시계 업데이트
        commuteCheck(); // 출퇴근 상태 확인
    
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
            let action = $("#actionText").text();
            if(action === "출근") {
                attend();
            } else if(action === "퇴근") {
                checkOut();
            }          
        });       
    });
    
    // 확인 모달을 표시하는 함수
    function showConfirmationModal(title, action) {
        let currentTime = $("#time").text();
        $("#confirmationModalLabel").text(title);
        $("#currentTime").text(currentTime);
        $("#actionText").text(action);
        $("#confirmationModal").modal('show');
    }
    
    // 읽지 않은 메시지 개수를 로드하는 함수
    function checkNotReadMsg() {
        $.ajax({
            url: "/test/msgReceive", // 데이터를 가져올 URL
            type: "get", // GET 메서드를 사용
            data: {'id': '${loginInfo.id}'}, // id 값을 문자열로 전달
            dataType: "json", // 데이터 타입은 JSON
            success: function(data) { // 요청이 성공하면 실행
                console.log('data: ', data);
                // 서버에서 반환된 JSON 데이터에서 messageCount를 읽어와서 msgAlert 요소에 표시
                $("#msgAlert").text("읽지 않은 쪽지 개수: " + data.messageCount);
            },
            error: function() { // 요청이 실패하면 실행
                alert("error"); // 에러 메시지 출력
            }
        });        
    }
    
    // 출퇴근 상태를 확인하는 함수
    function commuteCheck() {
        $.ajax({
            url: "/test/commuteCheck", // 데이터를 가져올 URL
            type: "get", // GET 메서드를 사용
            data: {'id': '${loginInfo.id}'}, // id 값을 문자열로 전달
            dataType: "json", // 데이터 타입은 JSON
            success: function(data) { // 요청이 성공하면 실행
                console.log('CommuteData: ', data);           
                if(data.inTime == null) { // 출근을 아직 안한 상태
                    console.log('11 CommuteData: ', data); 
                    $("#checkOutBtn").prop("disabled", true); // 퇴근 버튼 비활성화
                    $("#checkInBtn").prop("disabled", false); // 출근 버튼 활성화
                    
                } else if(data.outTime == null) { // 퇴근을 아직 안한 상태
                    console.log('22 CommuteData: ', data); 
                    $("#checkOutBtn").prop("disabled", false); // 퇴근 버튼 활성화
                    $("#checkInBtn").prop("disabled", true); // 출근 버튼 비활성화
                    
                    $("#checkInTime").text(data.inTime); // 출근 시간 표시
                } else { // 이미 출근 및 퇴근을 모두 완료한 상태
                    console.log('33 CommuteData: ', data); 
                    $("#checkOutBtn").prop("disabled", true); // 퇴근 버튼 비활성화
                    $("#checkInBtn").prop("disabled", true); // 출근 버튼 비활성화
                    
                    $("#checkInTime").text(data.inTime); // 출근 시간 표시
                    $("#checkOutTime").text(data.outTime); // 퇴근 시간 표시
                }
            },
            error: function(jqXHR, textStatus, errorThrown) { // 요청이 실패하면 실행
                console.error("에러 발생: ", textStatus, errorThrown); // 에러 메시지 출력
                alert("출퇴근 상태를 확인하는 중 에러가 발생했습니다."); // 에러 메시지 출력
            }
        });
    }
    
    // 출근을 처리하는 함수
    function attend() {
        $.ajax({
            url: "/test/attend", // 데이터를 가져올 URL
            type: "get", // GET 메서드를 사용
            data: {'id': '${loginInfo.id}'}, // id 값을 문자열로 전달
            dataType: "json", // 데이터 타입은 JSON
            success: function(attendTime) { // 요청이 성공하면 실행
                console.log('attendTime: ', attendTime);
                alert("출근 처리가 완료되었습니다.");
                $('#confirmationModal').modal('hide'); // 모달 닫기
                commuteCheck(); // 출근 후 버튼 상태 업데이트
            },
            error: function(jqXHR, textStatus, errorThrown) { // 요청이 실패하면 실행
                console.error("에러 발생: ", textStatus, errorThrown); // 에러 메시지 출력
                alert("출근 처리 중 에러가 발생했습니다."); // 에러 메시지 출력
            }
        });   
    }
    
    // 퇴근을 처리하는 함수
    function checkOut() {
        $.ajax({
            url: "/test/getOff", // 데이터를 가져올 URL
            type: "get", // GET 메서드를 사용
            data: {'id': '${loginInfo.id}'}, // id 값을 문자열로 전달
            dataType: "json", // 데이터 타입은 JSON
            success: function(getOffTime) { // 요청이 성공하면 실행
                console.log('getOffTime: ', getOffTime);
                alert("퇴근 처리가 완료되었습니다.");
                $('#confirmationModal').modal('hide'); // 모달 닫기
                commuteCheck(); // 퇴근 후 버튼 상태 업데이트
            },
            error: function(jqXHR, textStatus, errorThrown) { // 요청이 실패하면 실행
                console.error("에러 발생: ", textStatus, errorThrown); // 에러 메시지 출력
                alert("퇴근 처리 중 에러가 발생했습니다."); // 에러 메시지 출력
            }
        });   
    }
    
    // 현재 시간을 설정하는 함수
    function setClock() {
        var dateInfo = new Date();
        var hour = modifyNumber(dateInfo.getHours());
        var min = modifyNumber(dateInfo.getMinutes());
        var sec = modifyNumber(dateInfo.getSeconds());
        var year = dateInfo.getFullYear();
        var month = dateInfo.getMonth() + 1; // monthIndex를 반환해주기 때문에 1을 더해준다.
        var date = dateInfo.getDate();
        
        // 시간 및 날짜 표시 업데이트
        $("#time").text(hour + ":" + min + ":" + sec);
        $("#date").text(year + "년 " + month + "월 " + date + "일");
    }
    
    // 숫자가 한 자리일 경우 앞에 0을 추가하는 함수
    function modifyNumber(time) {
        return (parseInt(time) < 10) ? "0" + time : time;
    }
    
</script>
</html>
