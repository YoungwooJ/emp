<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%
	//1. 요청 분석(Controller)
	String strBoardNo = request.getParameter("boardNo");
	// 안전 장치 코드
	if(strBoardNo == null){
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
	String currentPage = request.getParameter("currentPage");
	int boardNo = Integer.parseInt(strBoardNo);

	// 2. 업무 처리(Model)
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sql = "SELECT board_title boardTitle, board_content boardContent, board_Writer boardWriter, createdate FROM board WHERE board_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	Board board = null;
	if(rs.next()){
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWriter = rs.getString("boardWriter");
		board.createdate = rs.getString("createdate");
	}
	// 3. 
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<title>deletBoardForm</title>
	<!-- 부트스트랩5 CDN -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- CSS -->
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/style.css">
	<style>
		table {
			font-weight: bold;
		}
	</style>
</head>
<body class="container text-center">
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	
	<div>
		<h2 class="mt-1 p-3 bg-success text-white rounded">게시물을 삭제합니다</h2>
	</div>
	<!-- msg 파라메타값이 있으면 출력 -->
	<%
		String msg = request.getParameter("msg");
		if(msg != null) {
	%>
			<div class="text-danger"><%=msg%></div>
	<%		
		}
	%>
	<form method="post" action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp?boardNo=<%=board.boardNo%>">
		<table class ="table table-bordered">
			<tr>
				<td style="width: 100px;" class="bg-success text-white">번호</td>
				<td><%=board.boardNo%></td>
			</tr>
			<tr>
				<td class="bg-success text-white">작성일</td>
				<td><%=board.createdate%></td>
			</tr>
			<tr>
				<td class="bg-success text-white">작성자</td>
				<td><%=board.boardWriter%></td>
			</tr>						
			<tr>
				<td class="bg-success text-white">제목</td>
				<td><%=board.boardTitle%></td>
			</tr>
			<tr>
				<td class="bg-success text-white">내용</td>
				<td><%=board.boardContent%></td>
			</tr>
			<tr>
				<td class="bg-success text-white">
					<div>비밀번호</div>
				</td>
				<td>
					<input type="password" name="boardPw" value="">
				</td>
			</tr>
		</table>
		<a href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage%>&boardNo=<%=board.boardNo%>" type="button" style="float: left;" class="btn btn-white btn-outline-dark" >이전</a>
		<button style="float: right;" class="btn btn-danger btn-outline-dark text-white" type="submit">삭제</button>
	</form>
</body>
</html>