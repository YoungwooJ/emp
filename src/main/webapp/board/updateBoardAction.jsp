<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
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
	String boardNo = request.getParameter("boardNo");
	String boardPw = request.getParameter("boardPw");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	//createdate는 받을 필요 없다
	
	//디버깅 코드
	System.out.println(boardNo);
	System.out.println(boardTitle);
	System.out.println(boardContent);
	System.out.println(boardWriter);
	
	//안전장치 코드
	if(boardNo == null || boardNo.equals("")) {
		String msg = URLEncoder.encode("번호를 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+msg+"&boardNo="+boardNo);
		return;
	}
	if(boardPw == null || boardPw.equals("")) {
		String msg = URLEncoder.encode("비밀번호를 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+msg+"&boardNo="+boardNo);
		return;
	}
	if(boardPw.equals("1234") != true) {
		String msg = URLEncoder.encode("비밀번호가 틀렸습니다.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+msg+"&boardNo="+boardNo);
		return;
	}
	if(boardTitle == null || boardTitle.equals("")) {
		String msg = URLEncoder.encode("제목을 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+msg+"&boardNo="+boardNo);
		return;
	}
	if(boardContent == null || boardContent.equals("")) {
		String msg = URLEncoder.encode("내용을 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+msg+"&boardNo="+boardNo);
		return;
	}
	if(boardWriter == null || boardWriter.equals("")) {
		String msg = URLEncoder.encode("글쓴이를 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+msg+"&boardNo="+boardNo);
		return;
	}
	
	Board board = new Board();
	board.boardNo = Integer.parseInt(boardNo);
	board.boardPw = boardPw;
	board.boardTitle = boardTitle;
	board.boardContent = boardContent;
	board.boardWriter = boardWriter;
	
	// 2. 업무 처리(Model)
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// 2. 수정
	String sql = "UPDATE board SET board_title = ?, board_content = ?, board_writer = ? WHERE board_no = ? AND board_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, board.boardTitle);
	stmt.setString(2, board.boardContent);
	stmt.setString(3, board.boardWriter);
	stmt.setInt(4, board.boardNo);
	stmt.setString(5, board.boardPw);
	
	// 디버깅 코드
	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}
		
	// 3. 출력(View)
	//디버깅 코드
	System.out.println("수정된 번호 : " + board.boardNo);
	System.out.println("수정된 제목 : " + board.boardTitle);
	System.out.println("수정된 내용 : " + board.boardContent);
	System.out.println("수정된 글쓴이 : " + board.boardWriter);
	System.out.println("수정된 날짜 : " + board.createdate);
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
%>