<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%	
	//1. mariadb 드라이버 로딩(mariadb와 관련된 API를 사용할 수 있도록)
	Class.forName("org.mariadb.jdbc.Driver"); 
	System.out.println("드라이버 로딩 성공");
	// 2. 연결 (접속)
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn + "<--conn");
	// 접속한 데이터베이스에 쿼리를 만들 때 사용하는 메서드
	PreparedStatement stmt = conn.prepareStatement("select dept_no, dept_name from departments order by dept_no desc");
	// 쿼리를 실행 사용하는 메서드, select 쿼리의 결과물
	ResultSet rs = stmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<title>deptList.jsp</title>
	<!-- 부트스트랩5 CDN -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<h1 class="mt-4 p-5 bg-success text-white rounded">DEPT LIST</h1>
	<div>
		<a href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp">부서추가</a>
	</div>
	<div class="containerr p-5 my-5 border">
		<!-- 부서목록출력(부서번호 내림차순으로) -->
		<table class =" table table-bordered">
			<thead>
				<tr>
					<th>부서 번호</th>
					<th>부서 이름</th>
				</tr>
			</thead>
			<tbody>
				<%
					while(rs.next()) {
				%>
						<tr>
							<td><%=rs.getString("dept_no")%></td>
							<td><%=rs.getString("dept_name")%></td>
						</tr>
				<%		
					}
				%>
			</tbody>
		</table>
	</div>
</body>
</html>