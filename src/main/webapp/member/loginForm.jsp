<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// session 유효성 검증 코드 후 필요하다면 redirect!
	if(session.getAttribute("loginEmp") != null){
		// 로그인이 된 상태
		response.sendRedirect(request.getContextPath()+"/empList.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>loginForm</title>
	<!-- 부트스트랩5 CDN -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<Style>
		body {
			padding:1.5em;
			background: #f5f5f5;
		}
		/*
		table {
			border: 1px #BDBDBD solid;
			font-size: .9em;
			box-shadow: 0 2px 5px #BDBDBD;
			width: 100%;
			border-collapse: collapse;
			border-radius: 20px;
			overflow: hidden;
		}
		*/
		a {
			text-decoration: none;
		}
		input:hover {
			outline: none !important;
			border-color: rgb(60, 179, 113);
			box-shadow: 0 0 10px rgb(60, 179, 113);
		}
		#verticalMiddle{
		    position: absolute;
		    top: 40%;
		    left: 50%;
		    transform: translate(-50%, -50%);
		}
	</style>
</head>
<body class="container text-center">
	<div class="container w-50" id="verticalMiddle">
		<form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post" class="align_middle">
			<table class="table table-borderless table-light rounded-3 shadow p-4 bg-white">
				<tr>
					<td colspan="2" class="bg-success">
						<h3 class="text-white"><strong>EMP</strong></h3>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<h4 style="float:left;">&nbsp;&nbsp;&nbsp;로그인</h4>
					</td>
				</tr>
				<!-- msg 파라메타값이 있으면 출력 -->
				<%
					String msg = request.getParameter("msg");
					if(msg != null) {
				%>
						<tr> 
							<td colspan="2" class="text-danger">&#10069;<%=msg%></td>
						</tr>
				<%		
					}
				%>
				<tr>
					<td>회원아이디</td>
					<td><input type="text" name="memberId" value="admin" class="form-control w-75 mx-auto"></td>
				</tr>
				<tr>
					<td>회원패스워드</td>
					<td><input type="password" name="memberPw" value="1234" class="form-control w-75 mx-auto"></td>
				</tr>
			</table>
			<!-- id가 없는 경우 회원가입 부터 -->
			<a style="float: left;" type="button" class="btn btn-white btn-outline-info" href="<%=request.getContextPath()%>/member/insertMemberForm.jsp">회원가입</a>
			<button style="float: right;" type="submit" class="btn btn-outline-success float-end">로그인</button>
		</form>
	</div>
</body>
</html>