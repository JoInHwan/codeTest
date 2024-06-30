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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<title>쪽지함</title>
<style>
    .modal-content {
        background-color: #fff3cd; /* 노란색 배경 */
    }
</style>
<c:set var="loginInfo" value="${sessionScope.loginInfo}"/>
</head>
<body class="container">
<h1>휴지통</h1>
	<a href="logout">로그아웃</a>	
	<a href="/test/main" class="btn btn-warning btn-sm">메인</a>	
	<table class="table tabled">
		<tr>
			<td>체크</td>
			<td>보낸이</td>
			<td>받는이</td>
			<td>제목</td>
			<td>내용</td>
			<td>보낸날짜</td>
			<td>읽은시간</td>
			<td>삭제상태 발신자 / 수신자</td>				
		</tr>	
		<c:forEach var="m" items="${list}">
			<tr>
				<td><input type="checkbox" name="msgNum" value="${m.msgNum}"></td>		
				<td>${m.sender}</td>
				<td>${m.receiver}</td>
				<td>${m.title}</td>
				<td>${m.content}</td>
				<td>${m.sendTime}</td>
				<td>${m.readTime}</td>
				<td>${m.sendDel}/${m.receiveDel}</td>
			</tr>
		</c:forEach>		
	</table>
	
	
	<a href="/test/msgList/0" class="btn btn-success btn-sm">받은쪽지함</a>		
	<a href="/test/msgList/1" class="btn btn-info btn-sm">보낸쪽지함</a>
	<button type="button" id="deleteButton">삭제하기</button>
	<script>
		$(document).ready(function(){
		    	
		    // "삭제하기" 버튼 클릭 시 선택된 항목 삭제
		    $('#deleteButton').click(function(){
		        let checkedItems = $('input[name="msgNum"]:checked');
		        let count = checkedItems.length;
		        let loginId = "${loginInfo.id}";
		        if(count > 0){
		            if(confirm(count + '개 항목을 삭제하시겠습니까?')){
		                let ids = [];
		                checkedItems.each(function(){
		                    ids.push($(this).val());
		                });
		                
		                $.ajax({
		                    url: '/test/deleteMessages', // 서버에 삭제 요청을 보낼 URL
		                    type: 'POST',
		                    traditional: true, // 배열을 전송할 수 있도록 설정
		                    data: { 
		                        msgNums: ids,
		                        loginId: loginId 
		                    },
		                    success: function(response){
		                        alert('선택된 항목이 삭제되었습니다.');
		                        location.reload(); // 페이지 새로 고침
		                    },
		                    error: function(){
		                        alert('항목 삭제에 실패했습니다.');
		                    }
		                });
		            }
		        } else {
		            alert('삭제할 항목을 선택하세요.');
		        }
		    });
		});

	</script>
</body>
</html>
