<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석(Controller)
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");
	
	// 1) word -> null 2) word -> '' or word -> '단어' 2가지 형태로 쿼리가 분기

	// 2. 업무처리(Model) -> 모델데이터(단일값 or 자료구조형태(배열, 리스트, ...))
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	String sql = null;
	PreparedStatement stmt = null;
	if(word==null){
		sql = "SELECT dept_no deptNo, dept_name deptName FROM departments ORDER BY dept_no ASC";
		stmt = conn.prepareStatement(sql);
	} else {
		/*
			SELECT *
			FROM departments
			WHERE dept_name LIKE ?
			ORDER BY dept_no ASC
		*/
		sql = "SELECT dept_no deptNo, dept_name deptName FROM departments WHERE dept_name LIKE ? ORDER BY dept_no ASC";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+word+"%");
	}
	
	ResultSet rs = stmt.executeQuery();
	// <- 모델데이터로서 ResultSet은 일반적인 타입이 아니고 독립적인 타입도 아니다
	// ResultSet rs라는 모델자료구조를 좀더 일반적이고 독립적인 자료구조 변경을 하자
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
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	
	<h1>DEPT LIST</h1>
	<div>
		<a href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp">부서추가</a>
	</div>
	
	<!-- 부서명 검색창 -->
	<form action="<%=request.getContextPath()%>/dept/deptList2.jsp" method="post">
		<label for="word">부서이름 검색 : </label>
		<input type="text" name="word" id="word">
		<button type="submit">검색</button>
	</form>
	<br>
	<table border="1">
		<tr>
			<th>부서번호</th>
			<th>부서이름</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>
		<%
			for(Department d : list) { // 자바문법에서 제공하는 foreach문
		%>
				<tr>
					<td><%=d.deptNo%></td>
					<td><%=d.deptName%></td>
					<td><a href="<%=request.getContextPath()%>/dept/updateDeptForm.jsp?deptNo=<%=d.deptNo%>">수정</a></td>
					<td><a href="">삭제</a></td>
				</tr>
		<%	
			}
		%>
	</table>
</body>
</html>