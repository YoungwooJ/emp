<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<title>insertBoardForm</title>
	<!-- 부트스트랩5 CDN -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- CSS -->
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/style.css">
	<style>
		table {
			font-weight: bold;
		}
		.box:hover {
		outline: none !important;
		border-color: rgb(60, 179, 113);
		box-shadow: 0 0 10px rgb(60, 179, 113);
		}
	</style>
</head>
<body class="container text-center">
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<h2 class="mt-1 p-3 bg-success text-white rounded">게시물을 등록합니다</h2>
	<!-- msg 파라메타값이 있으면 출력 -->
	<%
		String msg = request.getParameter("msg");
		if(request.getParameter("msg") != null) {
	%>
			<div class="text-danger"><%=msg%></div>
	<%		
		}
	%>
	<form method="post" action="<%=request.getContextPath()%>/board/insertBoardAction.jsp">
		<table class ="table table-bordered">
			<tr>
				<td style="width: 100px;" class="bg-success text-white">작성자</td>
				<td>
					<input type="text" name="boardWriter" value="" class="box">
				</td>
			</tr>			
			<tr>
				<td class="bg-success text-white">제목</td>
				<td>
					<input type="text" name="boardTitle" value="" class="box">
				</td>
			</tr>
			<tr>
				<td class="bg-success text-white" class="box">내용</td>
				<td>
					<textarea rows="25" cols="60" name="boardContent" class="box"></textarea>
				</td>
			</tr>
			<tr>
				<td class="bg-success text-white">
					<div>비밀번호</div>
				</td>
				<td>
					<input type="number" name="boardPw" value="1234" readonly="readonly" class="box">
				</td>
			</tr>
		</table>
		<a href="<%=request.getContextPath()%>/board/boardList.jsp" type="button" style="float: left;" class="btn btn-white btn-outline-dark" >이전</a>
		<button style="float: right;" class="btn btn-warning btn-outline-dark" type="submit">등록</button>
	</form>
</body>
</html>