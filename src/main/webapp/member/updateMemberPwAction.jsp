<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%@ page import="java.net.URLEncoder" %>
<%
	// 1. 요청 분석(Controller)
	request.setCharacterEncoding("UTF-8");

	//session 유효성 검증 코드 후 필요하다면 redirect!
	if(session.getAttribute("loginEmp") == null){
		// 로그인이 안 된 상태
		response.sendRedirect(request.getContextPath()+"/member/loginForm.jsp");
		return;
	}

	String msg = null;
	
	// 안전장치 코드
	if(request.getParameter("memberId")==null 
			|| request.getParameter("memberPw")==null
			|| request.getParameter("newMemberPw")==null 
			|| request.getParameter("memberId").equals("") 
			|| request.getParameter("memberPw").equals("")
			|| request.getParameter("newMemberPw").equals("")){
		msg = URLEncoder.encode("비밀번호 변경에 실패하였습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/updateMemberPwForm.jsp");
		return;
	}
	
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	String newMemberPw = request.getParameter("newMemberPw");
	
	/* 
	// vo로 묶고 싶다면
	Member member = new Member();
	member.memberId = memberId;
	member.memberName = memberName;
	*/
	
	// 디버깅 코드
	System.out.println(memberId);
	System.out.println(memberPw);
	System.out.println(newMemberPw);
	
	// 2. 요청 처리 (Model)
	// db 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 쿼리
	String sql = null;
	PreparedStatement stmt = null;
	sql = "UPDATE member SET member_pw = PASSWORD(?) where member_id=? and member_pw = PASSWORD(?);";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, newMemberPw);
	stmt.setString(2, memberId);
	stmt.setString(3, memberPw);
	
	int row = stmt.executeUpdate();
	
	if(row==1){
		System.out.println("변경 성공");
		msg = URLEncoder.encode("비밀번호가 변경되었습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/index.jsp?msg="+msg);
	} else {
		System.out.println("변경 실패");
		msg = URLEncoder.encode("비밀번호 변경에 실패하였습니다.", "utf-8");
		System.out.println(memberId+" "+memberPw+" "+ newMemberPw);
		response.sendRedirect(request.getContextPath()+"/member/updateMemberPwForm.jsp?msg="+msg+"&memberId="+memberId);
		return;
	}
	
	stmt.close();
	conn.close();
	
	// 3. 출력 (View)
%>