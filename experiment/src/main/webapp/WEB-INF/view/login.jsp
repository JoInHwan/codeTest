<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>실험용 프로젝트-로그인페잊</title>

 <style>               
	.center{
		margin-top: 100px;
		display: flex;
	    flex-direction: column;
	    align-items: center;
	   	   }
</style>

</head>
<body>
<div class="center">
	<form action="login" method="post">
		<table border="1">
		
			<tr>
				<td>아이디 : </td>
				<td> <input type="text" name="id">  </td>
			</tr>
			<tr>
				<td>비밀번호 : </td>	
				<td> <input type="text" name="pw"> </td>
			</tr>
			<tr>	
				<td> <button type="submit">로그인</button> </td>
			</tr>
		</table>
	</form>
</div>	
</body>
<script>
	
	

</script>
</html>
