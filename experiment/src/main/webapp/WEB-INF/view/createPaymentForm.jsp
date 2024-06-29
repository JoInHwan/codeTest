<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Payment</title>
</head>
<body>
    <h1>Create Payment</h1>
    
    <form action="/processPayment" method="post">
        <label for="orderNo">Order No:</label>
        <input type="text" id="orderNo" name="orderNo" value="${orderNo}" readonly><br><br>
        
        <label for="amount">Amount:</label>
        <input type="text" id="amount" name="amount" value="${amount}" readonly><br><br>
        
        <button type="submit">Create Payment</button>
    </form>
    
</body>
</html>
