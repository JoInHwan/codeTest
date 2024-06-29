<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>결제 요청 폼</title>
    <script src="https://js.tosspayments.com/v1"></script>
    <script>
        function requestPayment() {
            const clientKey = "${clientKey}";
            const tossPayments = TossPayments(clientKey);
            
            tossPayments.requestPayment({
                amount: document.getElementById('amount').value,
                orderId: document.getElementById('orderId').value,
                orderName: document.getElementById('orderName').value,
                customerName: document.getElementById('customerName').value,
                successUrl: document.getElementById('successUrl').value,
                failUrl: document.getElementById('failUrl').value
            });
        }
    </script>
</head>
<body>
    <h1>결제 요청</h1>
    <form onsubmit="event.preventDefault(); requestPayment();">
        <label for="amount">Amount:</label>
        <input type="text" id="amount" name="amount"><br><br>
        <label for="orderId">Order ID:</label>
        <input type="text" id="orderId" name="orderId"><br><br>
        <label for="orderName">Order Name:</label>
        <input type="text" id="orderName" name="orderName"><br><br>
        <label for="customerName">Customer Name:</label>
        <input type="text" id="customerName" name="customerName"><br><br>
        <label for="successUrl">Success URL:</label>
        <input type="text" id="successUrl" name="successUrl"><br><br>
        <label for="failUrl">Fail URL:</label>
        <input type="text" id="failUrl" name="failUrl"><br><br>
        <button type="submit">결제 요청</button>
    </form>
</body>
</html>
