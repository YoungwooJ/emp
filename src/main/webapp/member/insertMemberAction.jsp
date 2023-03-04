<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
	// 1. 요청 분석 (Controller)
	request.setCharacterEncoding("UTF-8");
	
	//session 유효성 검증 코드 후 필요하다면 redirect!
	if(session.getAttribute("loginEmp") != null){
		// 로그인이 된 상태
		response.sendRedirect(request.getContextPath()+"/empList.jsp");
		return;
	}

	// 안전 장치 코드
	if(request.getParameter("memberName")==null||request.getParameter("memberName").equals("")
		||request.getParameter("memberId")==null || request.getParameter("memberId").equals("")
		||request.getParameter("memberPw")==null||request.getParameter("memberPw").equals("")
		||request.getParameter("firstName")==null||request.getParameter("firstName").equals("")
		||request.getParameter("lastName")==null||request.getParameter("lastName").equals("")
		||request.getParameter("birthDate")==null||request.getParameter("birthDate").equals("")
		||request.getParameter("gender")==null||request.getParameter("gender").equals("")
		||request.getParameter("hireDate")==null||request.getParameter("hireDate").equals("")){
		String msg = URLEncoder.encode("정보를 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
		return;
	}
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	String memberName = request.getParameter("memberName");
	String firstName = request.getParameter("firstName");
	String lastName = request.getParameter("lastName");
	String birthDate = request.getParameter("birthDate");
	String gender = request.getParameter("gender");
	String hireDate = request.getParameter("hireDate");
	
	// VO setter 호출
	Member member = new Member();
	member.setMemberId(memberId);
	member.setMemberPw(memberPw);
	member.setMemberName(memberName);
	member.setFirstName(firstName);
	member.setLastName(lastName);
	member.setBirthDate(birthDate);
	member.setGender(gender);
	member.setHireDate(hireDate);
	
	// 2. 요청 처리 (Model)
	// db 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// id 중복안되게
	String idSql = "SELECT member_id FROM member WHERE member_id = ?"; 
	PreparedStatement idStmt = conn.prepareStatement(idSql);
	idStmt.setString(1, memberId);
	ResultSet rs = idStmt.executeQuery();
	if(rs.next()){
		System.out.println("아이디 중복");
		String msg = URLEncoder.encode("아이디가 중복되었습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);

		rs.close();
		idStmt.close();
		conn.close();
		
		return;
	} 
	
	// 쿼리
	String empSql = null;
	int empNo = 0;
	PreparedStatement empStmt = null;
	empSql = "INSERT INTO employees(birth_date, first_name, last_name, gender, hire_date) VALUES(?, ?, ?, ?, ?)";
	empStmt = conn.prepareStatement(empSql, Statement.RETURN_GENERATED_KEYS);
	empStmt.setString(1, member.getBirthDate());
	empStmt.setString(2, member.getFirstName());
	empStmt.setString(3, member.getLastName());
	empStmt.setString(4, member.getGender());
	empStmt.setString(5, member.getHireDate());
	int empRow = empStmt.executeUpdate();
	ResultSet empRs = empStmt.getGeneratedKeys();
	if(empRs.next()) {
		empNo = empRs.getInt(1);
	}
	if(empRow==1){
		System.out.println("직원 등록 성공");
		// 디버깅 코드
		System.out.println(member.getBirthDate()+" "+member.getFirstName()+" "+ member.getLastName()+" "+member.getGender()+" "+member.getHireDate());
	} else {
		System.out.println("직원 등록 실패");
		String msg = URLEncoder.encode("회원가입에 실패하였습니다.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
		return;
	}
	
	// 쿼리
	String sql = null;
	PreparedStatement stmt = null;
	sql = "INSERT INTO member(member_id, member_pw, member_name, emp_no) VALUES(?, PASSWORD(?), ?, ?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, member.getMemberId());
	stmt.setString(2, member.getMemberPw());
	stmt.setString(3, member.getMemberName());
	stmt.setInt(4, empNo);
	int row = stmt.executeUpdate();
	if(row==1){
		System.out.println("회원가입 성공");
		String msg = URLEncoder.encode("회원가입이 완료되었습니다.", "utf-8");
		//디버깅 코드
		System.out.println(memberId+" "+memberPw+" "+ memberName);
		response.sendRedirect(request.getContextPath()+"/member/loginForm.jsp?msg="+msg);
	} else {
		System.out.println("회원가입 실패");
		String msg = URLEncoder.encode("회원가입에 실패하였습니다.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
		return;
	}
	
	empRs.close();
	stmt.close();
	conn.close();
	
	// 3. 출력 (View)
%>