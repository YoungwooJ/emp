<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%	
	// 1. 요청 분석(Controller)
	
	
	// 2. 업무 처리(Model) -> 모델데이터(단일값 or 자료구조형태(배열, 리스트, ...))
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sql = "SELECT dept_no deptNo, dept_name deptName FROM departments ORDER BY dept_no ASC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery();
	// <-- 모델데이터로서 ResultSet은 일반적인 타입이 아니고 독립적인 타입도 아니다.
	// Result 타입은 마리아db가 들어올 때만 사용가능, 그러면 일반적인 타입은?
	// Result rs라는 모델자료구조를 좀더 일반적이고 독립적인 자료규조로 변경을 하자
	ArrayList<Department> list = new ArrayList<Department>();
	while(rs.next()) { // ResultSet의 API(사용방법)를 모른다면 사용할 수 없는 반복문
		Department d = new Department();
		d.deptNo = rs.getString("deptNo");
		d.deptName = rs.getString("deptName");
		list.add(d);
	}
	// 3. 출력(View) -> 모델데이터를 고객이 원하는 형태로 출력 -> 뷰(리포트)
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
	</style>
</head>
<body class="container text-center">
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<h2 style="float:left">부서 목록</h2>
	<div class="containerr border">
		<!-- 부서목록출력(부서번호 내림차순으로) -->
		<table class ="table table-bordered">
			<thead class="mt-1 p-3 bg-success text-white">
				<tr>
					<th>부서 번호</th>
					<th>부서 이름</th>
					<th>수정</th>
					<th>삭제</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(Department d : list) { // 자바문법에서 제공하는 foreach문
				%>
						<tr>
							<td><%=d.deptNo%></td>
							<td><%=d.deptName%></td>
							<td><a class="btn btn-outline-warning" href="<%=request.getContextPath()%>/dept/updateDeptForm.jsp?deptNo=<%=d.deptNo%>">수정</a></td>
							<td><a class="btn btn-outline-danger" href="<%=request.getContextPath()%>/dept/deleteDept.jsp?deptNo=<%=d.deptNo%>">삭제</a></td>
						</tr>
				<%
					}
				%>
			</tbody>
		</table>
	</div>
	<div>
		<a style="float: right;" class="btn btn-outline-info" href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp">부서추가</a>
	</div>
</body>
</html>