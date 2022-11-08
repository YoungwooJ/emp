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
	<h2 class="mt-4 p-5 bg-success text-white rounded">부서를 추가합니다</h2>
	<form method="post" action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp">
		<table class ="table table-bordered">
			<tr>
				<td>부서 번호</td>
				<td>
					<input type="text" name="deptNo" value="">
				</td>
			</tr>
			<tr>
				<td>부서 이름</td>
				<td>
					<input type="text" name="deptName" value="">
				</td>
			</tr>
		</table>
		<button class="btn btn-warning btn-outline-dark" type="submit">추가</button>
	</form>
</body>
</html>