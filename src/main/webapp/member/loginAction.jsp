<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*"%>
<%@ page import = "java.sql.*"%>
<%@ page import="java.net.URLEncoder" %>
<%
	// 1) controller
	// session 유효성 검증 코드 후 필요하다면 redirect!
	if(session.getAttribute("loginEmp") != null){
		// 로그인이 된 상태
		response.sendRedirect(request.getContextPath()+"/empList.jsp");
		return;
	}
	// request 유효성 검증
	request.setCharacterEncoding("UTF-8");
	
	//안전 장치 코드
	if(request.getParameter("memberId")==null 
			|| request.getParameter("memberPw")==null
			|| request.getParameter("memberId").equals("") 
			|| request.getParameter("memberPw").equals("")){
		String msg = URLEncoder.encode("정보를 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/member/loginForm.jsp?msg="+msg);
		return;
	}
	
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	// VO setter 호출
	Member member	= new Member();
	member.setMemberId(memberId);
	member.setMemberPw(memberPw);
	System.out.println(member.getMemberId() + " <--- ID");
	System.out.println(member.getMemberPw() + " <--- PW");
	
	// 2) Model
	String driver	= "org.mariadb.jdbc.Driver";
	String dbUrl	= "jdbc:mariadb://localhost:3306/employees";
	String dbUser	= "root";
	String dbPw		= "java1234";
	
	Class.forName(driver); // 외부 드라이브 로딩
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw); // db 연결
	
	/*
	SELECT member_id memberId
	FROM MEMBER
	WHERE member_id=? AND member_pw=PASSWORD(?);
	*/
	// 쿼리
	String memberSql = "SELECT member_id memberId, member_name memberName, emp_no empNo FROM member WHERE member_id=? AND member_pw = PASSWORD(?)";
	PreparedStatement memberStmt = conn.prepareStatement(memberSql);
	memberStmt.setString(1, member.getMemberId());
	memberStmt.setString(2, member.getMemberPw());
	ResultSet memberRs = memberStmt.executeQuery();
	
	Member loginEmp = new Member();
	if(memberRs.next()) {
		// 로그인 성공
		loginEmp = new Member(); 
		loginEmp.setMemberId(memberRs.getString("memberId"));
		loginEmp.setMemberName(memberRs.getString("memberName"));
		loginEmp.setEmpNo(memberRs.getInt("empNo"));
	}	
	
	/*
		SELECT emp_no empNo, last_name lastName
		FROM employee
		WHERE emp_no =? AND first_name =? AND last_name=?
	*/
	String sql = "SELECT emp_no empNo, birth_date birthDate, first_name firstName, last_name lastName, gender, hire_date hireDate FROM employees WHERE emp_no =?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// getter 사용
	stmt.setInt(1, loginEmp.getEmpNo());
	
	ResultSet rs = stmt.executeQuery();
	
	String targetUrl = "/loginForm.jsp";
	
	if(rs.next()) {
		// 로그인 성공
		System.out.println("success");
		loginEmp.setEmpNo(rs.getInt("empNo"));
		loginEmp.setBirthDate(rs.getString("birthDate"));
		loginEmp.setFirstName(rs.getString("firstName"));
		loginEmp.setLastName(rs.getString("lastName"));
		loginEmp.setGender(rs.getString("gender"));
		loginEmp.setHireDate(rs.getString("hireDate"));
		// 로그인 성공했다는 값을 저장 -> session
		session.setAttribute("loginEmp", loginEmp); // 키 : "loginEmp", 값 : Object object = loginEmp; 
		// Object loginMemberId = rs.getString("memberId"); // 다형성 + 연산자 오버로딩
		// Object 타입을 대입할 떄는 상관 없지만 가져올 때는 형변환 필수, 다형성 -> 상속이 되야 한다 -> 참조타입을 만드려면 추상화 / 캡슐
		// String loginMemberId = (String)(session.getAttribute("loginMemberId"));
		targetUrl = "/index.jsp";
	}
	rs.close();
	stmt.close();
	conn.close();
	response.sendRedirect(request.getContextPath()+targetUrl);
	// 3) view
%>