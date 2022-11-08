<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<title>index</title>
	<!-- 부트스트랩5 CDN -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		.ol {
			font-weight: bold;
		}
	</style>
</head>
<body class="container text-center">
	<h1 class="mt-4 p-5 bg-success text-white rounded">INDEX</h1>
	<ol class="ol">
		<li><a class="btn btn-warning btn-outline-dark" href="<%=request.getContextPath()%>/dept/deptList.jsp">부서 관리</a></li>
	</ol>
</body>
</html>