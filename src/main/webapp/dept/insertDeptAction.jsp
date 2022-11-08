<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%
	// 안전장치 코드
	if(request.getParameter("deptNo") == null || request.getParameter("deptName") == null) {
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp");
		return;
	}
	
	// 1. 요청 분석(Controller)
	request.setCharacterEncoding("utf-8"); // 한글 처리
	Department dept = new Department();
	dept.deptNo = request.getParameter("deptNo");
	dept.deptName = request.getParameter("deptName");
	
	// 2. 업무 처리(Model) -> 모델데이터(단일값 or 자료구조형태(배열, 리스트, ...))
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");	// DB와 연결
	String sql = "INSERT into departments(dept_no, dept_name) values(?, ?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, dept.deptNo);
	stmt.setString(2, dept.deptName);
	
	int row = stmt.executeUpdate();
	// 디버깅 코드
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	// 3. 출력(View) -> 모델데이터를 고객이 원하는 형태로 출력 -> 뷰(리포트)
	//디버깅 코드
	System.out.println(dept.deptNo+" "+dept.deptName);
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>