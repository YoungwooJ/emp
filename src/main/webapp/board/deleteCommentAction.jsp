<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%@ page import="java.net.URLEncoder" %>
<%
	//1. 요청 분석(Controller)
	
	// session 유효성 검증 코드 후 필요하다면 redirect!
	if(session.getAttribute("loginEmp") == null){
		// 로그인이 안 된 상태
		response.sendRedirect(request.getContextPath()+"/member/loginForm.jsp");
		return;
	}
	
	request.setCharacterEncoding("utf-8");
	String commentNo = request.getParameter("commentNo");
	String commentPw = request.getParameter("commentPw");
	
	String currentPage = request.getParameter("currentPage");
	String boardNo = request.getParameter("boardNo");
	
	// 디버깅 코드
	System.out.println(commentNo);
	System.out.println(currentPage);
	System.out.println(boardNo);
	
	// 안전장치 코드
	if(commentPw == null || commentPw.equals("")) {
		String msg = URLEncoder.encode("비밀번호를 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?msg="+msg+"&currentPage="+currentPage+"&boardNo="+boardNo+"&commentNo="+commentNo);
		return;
	}
	if(commentPw.equals("1234") != true) {
		String msg = URLEncoder.encode("비밀번호가 틀렸습니다.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?msg="+msg+"&currentPage="+currentPage+"&boardNo="+boardNo+"&commentNo="+commentNo);
		return;
	}
	
	// 2. 업무 처리(Model)
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	String sql = "DELETE FROM comment WHERE comment_no = ? AND comment_pw = ?;";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, commentNo);
	stmt.setString(2, commentPw);
	// 디버깅 코드
	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("삭제성공");
	} else {
		System.out.println("삭제실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?currentPage="+currentPage+"&boardNo="+boardNo);
	// 3. 출력(View)
%>