<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 1. 요청 분석(Controller)
	
	// session 유효성 검증 코드 후 필요하다면 redirect!
	if(session.getAttribute("loginEmp") == null){
		// 로그인이 안 된 상태
		response.sendRedirect(request.getContextPath()+"/member/loginForm.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<title>insertDeptForm</title>
	<!-- 부트스트랩5 CDN -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
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
		.box:hover {
		outline: none !important;
		border-color: rgb(60, 179, 113);
		box-shadow: 0 0 10px rgb(60, 179, 113);
		}
		input, textarea{
		 	display: inline-block;
			font-size: 15px;
			border: 0;
			border-radius: 15px;
			outline: none;
			padding-left: 10px;
			background-color: rgb(233, 233, 233);
			float: left;
			width:100%
		}
	</style>
</head>
<body class="container text-center">
		<!-- 메뉴 partial jsp 구성 -->
		<!-- jsp: include에서는 절대 주소를 request.getContextPath()로 쓰지 않음 -->
		<!-- 왜냐하면 html이 요청하는 게 아니고 이 jsp파일 내에서 호출하는 것이기 때문이다. -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<h2 class="p-3 bg-success text-white rounded">부서를 추가합니다</h2>
	<!-- msg 파라메타값이 있으면 출력 -->
	<%
		String msg = request.getParameter("msg");
		if(request.getParameter("msg") != null) {
	%>
			<div class="text-danger"><%=msg%></div>
	<%		
		}
	%>
	<form method="post" action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp">
		<table class ="table table-bordered">
			<tr>
				<td class="bg-success text-white">부서 번호</td>
				<td>
					<input type="text" name="deptNo" value="" placeholder="부서 번호를 입력해주세요.">
				</td>
			</tr>
			<tr>
				<td class="bg-success text-white">부서 이름</td>
				<td>
					<input type="text" name="deptName" value="" placeholder="부서 이름을 입력해주세요.">
				</td>
			</tr>
		</table>
		<a href="<%=request.getContextPath()%>/dept/deptList.jsp" type="button" style="float: left;" class="btn btn-white btn-outline-secondary" >이전</a>
		<button class="btn btn-outline-info" type="submit" style="float: right;">추가</button>
	</form>
</body>
</html>