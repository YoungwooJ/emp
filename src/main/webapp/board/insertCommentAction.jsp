<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%@ page import="java.net.URLEncoder" %>
<%
	//1. 요청 분석(Controller)
	request.setCharacterEncoding("utf-8");
	String commentContent = request.getParameter("commentContent");
	String commentPw = request.getParameter("commentPw");
	String boardNo = request.getParameter("boardNo");
	String currentPage = request.getParameter("currentPage");
	
	
	// 안전장치 코드
	if(commentContent == null || commentContent.equals("")) {
		String msg = URLEncoder.encode("내용을 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?msg="+msg + "&currentPage=" + currentPage + "&boardNo=" + boardNo);
		return;
	}
	if(commentPw == null || commentPw.equals("")) {
		String msg = URLEncoder.encode("비밀번호를 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?msg="+msg + "&currentPage=" + currentPage + "&boardNo=" + boardNo);
		return;
	}
	
	// 2. 업무 처리(Model)
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");	// DB와 연결
	String sql = "INSERT into comment(board_no, comment_pw, comment_content, createdate) values(?, ?, ?, curdate())";	
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, boardNo);
	stmt.setString(2, commentPw);
	stmt.setString(3, commentContent);
	
	int row = stmt.executeUpdate();
	// 디버깅 코드
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	System.out.println("입력된 데이터 값: "+ commentPw + " " + commentContent);
	// 3. 출력(View)
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?currentPage=" + currentPage + "&boardNo=" + boardNo);
%>