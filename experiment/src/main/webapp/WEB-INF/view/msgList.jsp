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
<h1>쪽지함</h1>
	<a href="logout">로그아웃</a>	
	
	<table class="table tabled">
		<tr>
			<td>쪽지번호</td>
			<td>보낸이</td>
			<td>받는이</td>
			<td>제목</td>
			<td>내용</td>
			<td>보낸날짜</td>
			<td>받은날짜</td>
			<td>삭제상태</td>			
		</tr>	
		<c:forEach var="m" items="${list}">
			<tr>
				<td>${m.msgNum}</td>
				<td>${m.sender}</td>
				<td>${m.receiver}</td>
				<td>${m.title}</td>
				<td>${m.content}</td>
				<td>${m.sendTime}</td>
				<td>${m.readTime}</td>
				<td>${m.sendDel} / ${m.receiveDel}</td>		
			</tr>
		</c:forEach>		
	</table>
	
	<!-- 모달 추가 -->
	<div class="modal fade" id="messageModal" tabindex="-1" aria-labelledby="messageModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="messageModalLabel">쪽지쓰기</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form id="messageForm">
							<input type="hidden" name="sender" value="${loginInfo.id}">
						<div class="mb-3">
							<label for="receiver" class="form-label">받는이</label>
							<input type="text" class="form-control" id="receiver" name="receiver" required>
						</div>
						<div class="mb-3">
							<label for="title" class="form-label">제목</label>
							<input type="text" class="form-control" id="title" name="title" required>
						</div>
						<div class="mb-3">
<!-- 							<label for="title" class="form-label">첨부파일</label> -->
<!-- 							<input type="file" class="form-control" id="file" name="file" required> -->
						</div>
						<div class="mb-3">
							<label for="content" class="form-label">내용</label>
							<textarea class="form-control" id="content" name="content" rows="3" required></textarea>
						</div>
						<button type="submit" class="btn btn-primary">보내기</button>
					</form>
				</div>
			</div>
		</div>
	</div>
	
	<a href="#" class="btn btn-primary" id="writeMessageBtn">쪽지쓰기</a>
	<a href="main" class="btn btn-warning">메인</a>	

	<script>
		$(document).ready(function(){
			// "쪽지쓰기" 버튼 클릭 시 모달 표시
			$('#writeMessageBtn').click(function(){
				$('#messageModal').modal('show');
			});

			// 폼 제출 시 AJAX 요청으로 쪽지 보내기
			$('#messageForm').submit(function(event){
				event.preventDefault();
				let formData = $(this).serialize();
				
				$.ajax({
					url: '/test/sendMessage', // 서버에 쪽지를 보낼 URL
					type: 'POST',
					data: formData,
					success: function(response){
						alert('쪽지가 성공적으로 보내졌습니다.');
						$('#messageModal').modal('hide');
						$('#messageForm')[0].reset(); // 폼 초기화
						location.reload(); // 페이지 새로 고침
					},
					error: function(){
						alert('쪽지 보내기에 실패했습니다.');
					}
				});
			});
		});
	</script>
</body>
</html>
