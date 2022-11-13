<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
	// 1. 요청 분석(Controller)
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 댓글페이지가 1초과일 때 이전을 누르면 다른 페이지로 이동해버리기 때문에 댓글 페이지는 따로 출력
	int cmtCurrentPage = 1;
	if(request.getParameter("cmtCurrentPage") != null){
		cmtCurrentPage = Integer.parseInt(request.getParameter("cmtCurrentPage"));
	}
	// 1-1. 댓글 페이지 변수 선언
	final int ROW_PER_PAGE = 5; // final로 상수 선언
	int beginRow = (cmtCurrentPage-1)*ROW_PER_PAGE; // ...Limit(beginRow, ROW_PER_PAGE)
	
	// 2. 업무 처리(Model)
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String boardSql = "SELECT board_title boardTitle, board_content boardContent, board_Writer boardWriter, createdate FROM board WHERE board_no = ?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	ResultSet boardRs = boardStmt.executeQuery();
	Board board = null;
	if(boardRs.next()){
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = boardRs.getString("boardTitle");
		board.boardContent = boardRs.getString("boardContent");
		board.boardWriter = boardRs.getString("boardWriter");
		board.createdate = boardRs.getString("createdate");
	}
	
	// 2-1. 페이지당 댓글 목록
	String commentSql = "SELECT comment_no commentNo, comment_content commentContent FROM comment WHERE board_no = ? ORDER BY Comment_no DESC LIMIT ?, ?";
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	commentStmt.setInt(2, beginRow);
	commentStmt.setInt(3, ROW_PER_PAGE);
	ResultSet commentRs = commentStmt.executeQuery();
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()){
		Comment c = new Comment();
		c.commentNo = commentRs.getInt("commentNo");
		c.commentContent = commentRs.getString("commentContent");
		commentList.add(c);
		// 이슈) 댓글도 페이징이 필요하다
		// 페이징 하기 -> Limit(?, ?)
	}
	// 2-2. 페이지 출력
	String cntSql = "SELECT COUNT(*) cnt FROM comment WHERE board_no = ?";
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	cntStmt.setInt(1, boardNo);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0; //전체 행의 수
	if(cntRs.next()){
		cnt = cntRs.getInt("cnt");
	}
	// 디버깅 코드
	//System.out.println(cnt);
	// 2-3. 댓글 전체 행의 수 -> lastPage
	// 올림 5.3 -> 6.0, 5.0 -> 5.0
	int lastPage = (int)Math.ceil((double)cnt / (double)ROW_PER_PAGE); //마지막 페이지 번호 구하기
	
	// 3. 출력(View)
%><%@page import="vo.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<title>boardOne</title>
	<!-- 부트스트랩5 CDN -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- CSS -->
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/style.css">
	<style>
		body {
				padding:1.5em;
				background: #f5f5f5
			}
		table {
			border: 1px #BDBDBD solid;
			font-size: .9em;
			box-shadow: 0 2px 5px #BDBDBD;
			width: 100%;
			border-collapse: collapse;
			border-radius: 20px;
			overflow: hidden;
		}
		a {
			text-decoration: none;
		}
	</style>
</head>
<body class="container text-center">
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	
	<h2 class="p-3 bg-success text-white rounded">자유 게시판</h2>
	<table class ="table table-bordered">
		<tr>
			<td style="width: 100px;" class="bg-success text-white" class="formbox">번호</td>
			<td><span style="float:left;"><%=board.boardNo%></span></td>
		</tr>
		<tr>
			<td class="bg-success text-white" class="formbox">작성일</td>
			<td><span style="float:left;"><%=board.createdate%></span></td>
		</tr>		
		<tr>
			<td class="bg-success text-white" class="formbox">작성자</td>
			<td><span style="float:left;"><%=board.boardWriter%></span></td>
		</tr>		
		<tr>
			<td class="bg-success text-white" class="formbox">제목</td>
			<td><span style="float:left;"><%=board.boardTitle%></span></td>
		</tr>
		<tr>
			<td class="bg-success text-white" class="formbox">내용</td>
			<td><span style="float:left;"><%=board.boardContent%></span></td>
		</tr>
	</table>
	<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage%>" type="button" style="float: left;" class="btn btn-white btn-outline-secondary" >이전</a>
	<a href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?currentPage=<%=currentPage%>&boardNo=<%=board.boardNo%>" type="button" style="float: right;"  class="btn btn-outline-danger">삭제</a>
	<a href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?currentPage=<%=currentPage%>&boardNo=<%=board.boardNo%>" type="button" style="float: right;"  class="btn btn-outline-warning">수정</a>

	<!-- 댓글 게시판 -->
	<br><br>
	<!-- 댓글 목록 -->
	<div>
		<h5 style="float:left;">댓글</h5><br><br>
		<%
			for(Comment c : commentList){
		%>
				<div>
				<table class="table table-border">
					<tr>
						<td style="width:100px;">
							<%=c.commentNo%>
						</td>
						<td>
							<span style="float:left;"><%=c.commentContent%></span>
						</td>
						<td style="width:100px;">
							<a type="button" class="btn btn-white btn-outline-secondary" href="<%=request.getContextPath()%>/board/deleteCommentForm.jsp?commentNo=<%=c.commentNo%>&currentPage=<%=currentPage%>&boardNo=<%=boardNo%>">
							삭제
							</a>	
						</td>
					</tr>
				</table>
				</div>
		<%
			}
		%>
	</div>
	
	<div>
		<!-- 댓글 입력 폼 -->
		<h5 style="float:left;">댓글 입력</h5>
		<!-- msg 파라메타값이 있으면 출력 -->
		<%
			String msg = request.getParameter("msg");
			if(request.getParameter("msg") != null) {
		%>
				<div class="text-danger"><%=msg%></div>
		<%		
			}
		%>
		<form method="post" action="<%=request.getContextPath()%>/board/insertCommentAction.jsp?currentPage=<%=currentPage%>">
			<input type="hidden" name="boardNo" value="<%=board.boardNo%>">
			<input type="hidden" name="currentPage" value="<%=currentPage%>">
			<table class="table table-border">
				<tr>
					<td style="width:100px;">내용</td>
					<td><textarea rows="3" cols="80" name="commentContent" placeholder="댓글을 남겨보세요." class="cmtBox"></textarea></td>
				</tr>
				<tr>
					<td style="width:100px;">비밀번호</td>
					<td>
						<input type="number" name="commentPw" value="1234" readonly="readonly" class="cmtBox">
						<button type="submit" class="btn btn-white btn-outline-secondary">댓글입력</button>
					</td>
				</tr>
			</table>

		</form>
	</div>
	
	<!-- 페이징 코드 -->
	<div>
		<%
			if(cmtCurrentPage > 1) {
		%>
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage%>&cmtCurrentPage=<%=cmtCurrentPage-1%>&boardNo=<%=boardNo%>" style="text-decoration: none;" class="text-dark">이전</a>
		<%
			}
		%>
		<span style="font-weight: bold;"><%=cmtCurrentPage%></span>
		<%
			if(cmtCurrentPage < lastPage){
		%>
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage%>&cmtCurrentPage=<%=cmtCurrentPage+1%>&boardNo=<%=boardNo%>" style="text-decoration: none;" class="text-dark">다음</a>
		<%		
			}
		%>
	</div>
</body>
</html>