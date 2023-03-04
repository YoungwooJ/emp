<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%@ page import="java.net.URLEncoder" %>
<%
	// 1. 요청 분석(Controller)
	
	// session 유효성 검증 코드 후 필요하다면 redirect!
	if(session.getAttribute("loginEmp") == null){
		// 로그인이 안 된 상태
		response.sendRedirect(request.getContextPath()+"/member/loginForm.jsp");
		return;
	}
	
	request.setCharacterEncoding("utf-8");
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	// 디버깅 코드
	System.out.println(deptNo);
	System.out.println(deptName);
	// 안전장치 코드
	if(deptNo == null || deptName == null || deptNo.equals("") || deptName.equals("")) {
		String msg = URLEncoder.encode("부서이름을 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩
		response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp?msg="+msg+"&deptNo="+deptNo);
		return;
	}
	Department dept = new Department();
	dept.deptNo = deptNo;
	dept.deptName = deptName;
	
	// 2. 업무 처리(Model) -> 모델데이터(단일값 or 자료구조형태(배열, 리스트, ...))
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// 2-1. dept_name 중복검사
	String sql1 = "SELECT dept_name deptName FROM departments WHERE dept_name = ?"; // 수정하기전에 같은 dept_name가 존재하는지
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, dept.deptName);
	ResultSet rs = stmt1.executeQuery();
	if(rs.next()){ // 결과물 있다 -> 같은 dept_name이 이미 존재한다.
		String msg = URLEncoder.encode("부서이름이 중복되었습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp?msg="+msg+"&deptNo="+dept.deptNo+"&deptName="+dept.deptName);
		return;
	}
	
	// 2-2. 입력
	String sql2 = "UPDATE departments set dept_name = ? WHERE dept_no = ?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, dept.deptName);
	stmt2.setString(2, dept.deptNo);
	// 디버깅 코드
	int row = stmt2.executeUpdate();
	if(row == 1) {
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}
	
	// 3. 출력(View) -> 모델데이터를 고객이 원하는 형태로 출력 -> 뷰(리포트)
	System.out.println("수정된 데이터 : " + dept.deptNo + " " + dept.deptName);
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");	
%>