<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<% 
	//1. 요청 분석(Controller)
	request.setCharacterEncoding("utf-8");
	Department dept = new Department();
	dept.deptNo = request.getParameter("deptNo");
	
	// 2. 업무 처리(Model) -> 모델데이터(단일값 or 자료구조형태(배열, 리스트, ...))
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	String sql = "DELETE FROM departments where dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, dept.deptNo);
	// 디버깅 코드
	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("삭제성공");
	} else {
		System.out.println("삭제실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
	// 3. 출력(View) -> 모델데이터를 고객이 원하는 형태로 출력 -> 뷰(리포트)
%>