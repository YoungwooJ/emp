<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%@ page import="java.net.URLEncoder" %>
<%
	// 1. 요청 분석(Controller)
	request.setCharacterEncoding("utf-8");
	String boardNo = request.getParameter("boardNo");
	String boardPw = request.getParameter("boardPw");
	
	//디버깅 코드
	System.out.println(boardNo);
	System.out.println(boardPw);
	
	//안전장치 코드
	if(boardPw == null || boardPw.equals("")) {
		String msg = URLEncoder.encode("비밀번호를 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?msg="+msg+"&boardNo="+boardNo);
		return;
	}
	if(boardPw.equals("1234") != true) {
		String msg = URLEncoder.encode("비밀번호가 틀렸습니다.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?msg="+msg+"&boardNo="+boardNo);
		return;
	}
	
	// 2. 업무 처리(Model)
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	String sql = "DELETE FROM board WHERE board_no = ? AND board_pw = ?;";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, boardNo);
	stmt.setString(2, boardPw);
	// 디버깅 코드
	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("삭제성공");
	} else {
		System.out.println("삭제실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
	// 3. 출력(View)
%>