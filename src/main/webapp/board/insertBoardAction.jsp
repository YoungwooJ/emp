<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%@ page import="java.net.URLEncoder" %>
<%
	//1. 요청 분석(Controller)
	request.setCharacterEncoding("utf-8"); // 한글 처리
	String boardNo = request.getParameter("boardNo");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	
	// 안전장치 코드
	if(boardNo == null || boardNo.equals("")) {
		String msg = URLEncoder.encode("번호를 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
		return;
	}
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
	board.boardNo = Integer.parseInt(boardNo);
	board.boardPw = "1234";
	board.boardTitle = boardTitle;
	board.boardContent = boardContent;
	board.boardWriter = boardWriter;
	
	// 2. 업무 처리(Model)
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");	// DB와 연결
	// 2-1. 중복검사
	String dcSq1 = "SELECT * FROM board WHERE board_no = ?"; // 같은 게시물 번호가 존재하는지 검사
	PreparedStatement dcStmt = conn.prepareStatement(dcSq1);
	dcStmt.setInt(1, board.boardNo);
	ResultSet rs = dcStmt.executeQuery();
	if(rs.next()){
		String msg = URLEncoder.encode("게시물 번호가 중복되었습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
		return;
	}
	// 2-2. 입력
	String insertSql = "INSERT into board(board_no, board_pw, board_title, board_content, board_writer, createdate) values(?, ?, ?, ?, ?, curdate())"; // 쿼리 입력
	PreparedStatement insertStmt = conn.prepareStatement(insertSql);
	insertStmt.setInt(1, board.boardNo);
	insertStmt.setString(2, "1234");
	insertStmt.setString(3, board.boardTitle);
	insertStmt.setString(4, board.boardContent);
	insertStmt.setString(5, board.boardWriter);
	
	int row = insertStmt.executeUpdate();
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