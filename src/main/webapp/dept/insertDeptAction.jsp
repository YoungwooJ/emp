<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%@ page import="java.net.URLEncoder" %>
<%
	// 1. 요청 분석(Controller)
	request.setCharacterEncoding("utf-8"); // 한글 처리
	Department dept = new Department();
	dept.deptNo = request.getParameter("deptNo");
	dept.deptName = request.getParameter("deptName");
	// 안전장치 코드
	if(dept.deptNo == null || dept.deptName == null || dept.deptNo.equals("") || dept.deptName.equals("")) {
		String msg = URLEncoder.encode("부서번호와 부서이름을 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	
	// 2. 업무 처리(Model) -> 모델데이터(단일값 or 자료구조형태(배열, 리스트, ...))
	// 이미 존재하는 key(dept_no)값 동일한 값이 입력되면 예외(에러)가 발생한다. -> 동일한 dept_no값이 입력되었을 때 예외가 발생하지 않도록...
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");	// DB와 연결
	// 2-1. dept_no, dept_name 중복검사
	String sql1 = "SELECT * FROM departments WHERE dept_no = ? OR dept_name = ?"; // 입력하기전에 같은 dept_no가 존재하는지
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, dept.deptNo);
	stmt1.setString(2, dept.deptName);
	ResultSet rs = stmt1.executeQuery();
	if(rs.next()){ // 결과물있다 -> 같은 dept_no가 이미 존재한다.
		String msg = URLEncoder.encode("부서번호나 부서이름이 중복되었습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	// 2-2. 입력
	String sql2 = "INSERT into departments(dept_no, dept_name) values(?, ?)";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, dept.deptNo);
	stmt2.setString(2, dept.deptName);
	
	int row = stmt2.executeUpdate();
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