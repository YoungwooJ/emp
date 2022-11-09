<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<title>insertDeptForm</title>
	<!-- 부트스트랩5 CDN -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		table {
			font-weight: bold;
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
	<h2 class="mt-1 p-3 bg-success text-white rounded">부서를 추가합니다</h2>
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
					<input type="text" name="deptNo" value="">
				</td>
			</tr>
			<tr>
				<td class="bg-success text-white">부서 이름</td>
				<td>
					<input type="text" name="deptName" value="">
				</td>
			</tr>
		</table>
		<button class="btn btn-warning btn-outline-dark" type="submit">추가</button>
	</form>
</body>
</html>