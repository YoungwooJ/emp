<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청 분석(Controller)
	// 페이지 알고리즘
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2. 업무 처리(Model)
	int rowPerPage = 10;
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	// lastPage 처리
	String countSql = "SELECT COUNT(*) FROM employees";
	PreparedStatement countStmt = conn.prepareStatement(countSql);
	ResultSet countRs = countStmt.executeQuery();
	int count = 0;
	if(countRs.next()){
		count = countRs.getInt("COUNT(*)");
	}
	
	int lastPage = count / rowPerPage;
	if(count % rowPerPage != 0) {
		lastPage = lastPage + 1; // lastPage++, lastPage+=1
	}
	
	// 한페이지당 출력할 emp목록
	String empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC Limit ?, ?";
	PreparedStatement empStmt = conn.prepareStatement(empSql);
	empStmt.setInt(1, rowPerPage*(currentPage-1));
	empStmt.setInt(2, rowPerPage);
	ResultSet empRs = empStmt.executeQuery();
	
	ArrayList<Employee> empList = new ArrayList<Employee>();
	while(empRs.next()){
		Employee e = new Employee();
		e.empNo = empRs.getInt("empNo");
		e.firstName = empRs.getString("firstName");
		e.lastName = empRs.getString("lastName");
		empList.add(e);
	}
	// 3. 출력(View)
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<title>deptList.jsp</title>
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
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<h1 class="mt-1 p-3 bg-success text-white rounded">사원 목록</h1>
	
	<!-- 부서별 사원 목록 출력 -->
	<table class ="table table-bordered">
		<thead class="mt-1 p-3 bg-success text-white">
		<tr>
			<th>사원번호</th>
			<th>이름</th>
			<th>성</th>
		</tr>
		</thead>
		<tbody>
		<%
			for(Employee e : empList) {
		%>
				<tr>
					<td><%=e.empNo%></td>
					<td><a href=""><%=e.firstName%></a></td>
					<td><%=e.lastName%></td>
				</tr>
		<%
			}
		%>
		</tbody>
	</table>
	
	<!-- 페이징 코드 -->
	<div>현재 페이지 : <%=currentPage%></div>
	<div>
		<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">&lt;처음</a>
		<% 
			if(currentPage > 1) {
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-10%>">이전</a>
		<%
			} 
			for(int i=currentPage; i<currentPage+10; i++) {
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=i%>"><%=i%></a>
		<%
			}
			if(currentPage < lastPage) {
		%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+10%>">다음</a>
		<%
			}
		%>
		<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막&gt;</a>
	</div>
</body>
</html>