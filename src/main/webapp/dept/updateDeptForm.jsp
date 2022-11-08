<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%
	// 1. 요청 분석(Controller)
	request.setCharacterEncoding("utf-8"); // 한글 처리
	Department dept = new Department();
	dept.deptNo = request.getParameter("dept_no");
	dept.deptName = null;
	
	// 2. 업무 처리(Model) -> 모델데이터(단일값 or 자료구조형태(배열, 리스트, ...))
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");	// DB와 연결
	String sql = "SELECT dept_name from departments where dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, dept.deptNo);
	ResultSet rs = stmt.executeQuery();
	if(rs.next()) {
		dept.deptName = rs.getString("dept_name");
	}
	// 3. 출력(View) -> 모델데이터를 고객이 원하는 형태로 출력 -> 뷰(리포트)
	// 디버깅 코드
	System.out.println(dept.deptNo);
	System.out.println(dept.deptName);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<title>updateDeptForm</title>
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
	<form method="post" action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp">
		<h2 class="mt-4 p-5 bg-success text-white rounded">부서를 수정합니다</h2>
		<table class ="table table-bordered">
			<tr>
				<td>부서 번호 </td>
				<td><input type="text" name="deptNo" value="<%=dept.deptNo%>" readonly = "readonly"></td>
			</tr>
			<tr>
				<td>부서 이름 </td>
				<td><input type="text" name="deptName" value="<%=dept.deptName%>"></td>
			</tr>
		</table>
		<button class="btn btn-warning btn-outline-dark" type="submit">수정</button>
	</form>
</body>
</html>