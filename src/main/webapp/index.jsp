<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<title>index</title>
	<!-- 부트스트랩5 CDN -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- CSS -->
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/style.css">
	<style>
		.ol {
			font-weight: bold;
		}
	</style>
</head>
<body class="container text-center">
	<h1 class="p-3 text-white" align="left" style="background-color: #005000; width:100%;">INDEX</h1>
	<ol class="ol">
		<li><a class="title" style="text-decoration: none; float:left;" href="<%=request.getContextPath()%>/dept/deptList.jsp">부서 관리</a></li>
		<li><a class="title" style="text-decoration: none; float:left;" href="<%=request.getContextPath()%>/emp/empList.jsp">사원 관리</a></li>
	<!--<li><a class="title" style="text-decoration: none; float:left;" href="<%=request.getContextPath()%>/deptemp/deptEmpList.jsp">부서별사원관리</a></li>-->
		<li><a class="title" style="text-decoration: none; float:left;" href="<%=request.getContextPath()%>/salary/salaryList.jsp">연봉 관리</a></li>
		<li><a class="title" style="text-decoration: none; float:left;" href="<%=request.getContextPath()%>/board/boardList.jsp">게시판 관리</a></li>
	</ol>
</body>
</html>