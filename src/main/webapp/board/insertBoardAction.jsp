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
	
	request.setCharacterEncoding("utf-8"); // 한글 처리
	String boardPw = request.getParameter("boardPw");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	
	// 안전장치 코드
	if(boardTitle == null || boardTitle.equals("")) {
		String msg = URLEncoder.encode("제목을 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
		return;
	}
	if(boardContent == null || boardContent.equals("")) {
		String msg = URLEncoder.encode("내용을 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
		return;
	}
	if(boardWriter == null || boardWriter.equals("")) {
		String msg = URLEncoder.encode("글쓴이를 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
		return;
	}
	
	Board board = new Board();
	board.boardPw = boardPw;
	board.boardTitle = boardTitle;
	board.boardContent = boardContent;
	board.boardWriter = boardWriter;
	
	// 2. 업무 처리(Model)
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");	// DB와 연결
	// 입력
	String sql = "INSERT into board(board_pw, board_title, board_content, board_writer, createdate) values(?, ?, ?, ?, curdate())"; // 쿼리 입력
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, board.boardPw);
	stmt.setString(2, board.boardTitle);
	stmt.setString(3, board.boardContent);
	stmt.setString(4, board.boardWriter);
	
	int row = stmt.executeUpdate();
	// 디버깅 코드
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	System.out.println("입력된 데이터 값: "+ board.boardNo + " " + board.boardPw + " " + board.boardTitle + " " + board.boardContent + " " + board.boardWriter);
	// 3. 출력(View)
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
%>