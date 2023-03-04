<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//1. 요청 분석(Controller)

	// session 유효성 검증 코드 후 필요하다면 redirect!
	if(session.getAttribute("loginEmp") != null){
		// 로그인이 된 상태
		response.sendRedirect(request.getContextPath()+"/empList.jsp");
		return;
	}
	// 2. 업무 처리(Model)
	// 3. 출력 (View)
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>insertMemberForm</title>
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
	<div>
		<h2 class="p-3 bg-success text-white rounded">회원 가입</h2>
		<!-- msg 파라메타값이 있으면 출력 -->
		<%
			String msg = request.getParameter("msg");
			if(msg != null) {
		%>
				<div class="text-danger"><%=msg%></div>
		<%		
			}
		%>
		<form action="<%=request.getContextPath()%>/member/insertMemberAction.jsp" method="post">
			<table class="table">
				<tr>
					<td>회원아이디</td>
					<td><input type="text" name="memberId"></td>
				</tr>
				<tr>
					<td>회원패스워드</td>
					<td><input type="password" name="memberPw"></td> <!-- 비밀번호 확인 -->
				</tr>
				<tr>
					<td>이름</td>
					<td><input type="text" name="firstName"></td>
				</tr>
				<tr>
					<td>성</td>
					<td><input type="text" name="lastName"></td>
				</tr>
				<tr>
					<td>닉네임</td>
					<td><input type="text" name="memberName"></td>
				</tr>
				<tr>
					<td>출생일</td>
					<td><input type="date" name="birthDate"></td>
				</tr>
				<tr>
					<td>성별</td>
					<td>
						남 <input type="radio" name="gender" value="M">
						여 <input type="radio" name="gender" value="F">
					</td>
				</tr>
				<tr>
					<td>입사일</td>
					<td><input type="date" name="hireDate"></td>
				</tr>
			</table>
			<button style="float: left;" class="btn btn-white btn-outline-info" type="submit">회원가입</button>
		</form>
	</div>
</body>
</html>