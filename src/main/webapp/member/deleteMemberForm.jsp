<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import = "vo.*"%>
<%
	// 1. 요청 분석(Controller)
	
	// session 유효성 검증 코드 후 필요하다면 redirect!
	if(session.getAttribute("loginEmp") == null){
		// 로그인이 안 된 상태
		response.sendRedirect(request.getContextPath()+"/member/loginForm.jsp");
		return;
	}
	
	request.setCharacterEncoding("UTF-8");
	String memberId = request.getParameter("memberId");
	System.out.println(memberId);
	// 2. 업무 처리(Model)
	// 3. 출력 (View)
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>deleteMemberForm</title>
	<!-- 부트스트랩5 CDN -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<Style>
		body {
			padding:1.5em;
			background: #f5f5f5
		}
		table {
			border: 1px #BDBDBD solid;
			font-size: .9em;
			box-shadow: 0 2px 5px #BDBDBD;
			width: 100%;
			border-collapse: collapse;
			border-radius: 20px;
			overflow: hidden;
		}
		a {
			text-decoration: none;
		}
		input:hover {
			outline: none !important;
			border-color: rgb(60, 179, 113);
			box-shadow: 0 0 10px rgb(60, 179, 113);
		}
	</style>
</head>
<body class="container text-center">
	<!-- msg 파라메타값이 있으면 출력 -->
	<%
		String msg = request.getParameter("msg");
		if(msg != null) {
	%>
			<div class="text-danger"><%=msg%></div>
	<%		
		}
	%>
	<h2 class="p-3 bg-success text-white rounded">회원탈퇴</h2>
	<form method="post" action="<%=request.getContextPath()%>/member/deleteMemberAction.jsp">
		<input type="hidden" name="memberId" value="<%=memberId%>">
		<table class="table table-bordered">
			<tr>
				<td style="width: 100px;" class="bg-success text-white">아이디</td>
				<td><span style="float:left;"><%=memberId%></span></td>
			</tr>
			<tr>
				<td class="bg-success text-white">비밀번호</td>
				<td><input type="password" name="memberPw"></td>
			</tr>
		</table>
		<button style="float: right;" class="btn btn-white btn-outline-danger" type="submit">삭제</button>
	</form>
</body>
</html>