<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 요청분석
	// 페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 검색
	request.setCharacterEncoding("UTF-8");	//한글
	String searchContent = request.getParameter("searchContent");
	// 1) searchContent == null / 2) searchContent == "" or "단어"
	
	// 2. 요청처리 후 필요하다면 모델데이터를 생성
	final int ROW_PER_PAGE = 10; // 상수 선언 문법 : final로 int 변수를 상수로 만들어준다
	int beginRow = (currentPage-1)*ROW_PER_PAGE; // ...Limit(beginRow, ROW_PER_PAGE) 
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 2-1. 페이지 출력 / 검색 불러오기
	String cntSql = null;
	PreparedStatement cntStmt = null;
	if(searchContent == null || searchContent.equals("")){ // null 이거나 검색 값이 없으면 -> 전체 데이터 개수
		cntSql = "SELECT COUNT(*) cnt FROM board";
		cntStmt = conn.prepareStatement(cntSql);
	} else { // 내용에 searchContent를 포함하는 게시글 행 개수
		cntSql = "SELECT COUNT(*) cnt FROM board WHERE board_content LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+searchContent+"%");
	}
	
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0; //전체 행의 수
	if(cntRs.next()){
		cnt = cntRs.getInt("cnt");
	}
	
	// 올림 5.3 -> 6.0, 5.0 -> 5.0
	int lastPage = (int)Math.ceil((double)cnt / (double)ROW_PER_PAGE); //마지막 페이지 번호 구하기
	
	// 2-2. 페이지당 목록 출력 / 검색 출력
	String listSql = null;
	PreparedStatement listStmt = null;
	if(searchContent == null || searchContent.equals("")){ // null 이거나 검색 값이 없으면 -> 전체 출력
		listSql = "SELECT board_no boardNo, board_title boardTitle, board_writer boardWriter, createdate FROM board ORDER BY board_no ASC LIMIT ?,?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setInt(1, beginRow);
		listStmt.setInt(2, ROW_PER_PAGE);
	} else { // 내용에 searchContent를 포함하는 게시글만 출력 
		listSql = "SELECT board_no boardNo, board_title boardTitle, board_writer boardWriter, createdate FROM board WHERE board_content LIKE ? ORDER BY board_no ASC LIMIT ?,?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, "%"+searchContent+"%");
		listStmt.setInt(2, beginRow);
		listStmt.setInt(3, ROW_PER_PAGE);
	}
	
	ResultSet listRs = listStmt.executeQuery();
	ArrayList<Board> boardList = new ArrayList<Board>();
	while(listRs.next()){
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");
		b.boardWriter = listRs.getString("boardWriter");
		b.createdate = listRs.getString("createdate");
		boardList.add(b);
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<title>boardList</title>
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
	
	<h2 style="float:left">자유 게시판</h2>
	
	<!-- 3-1. 모델 데이터(ArrayList<Board> 출력 -->
	<table class ="table table-bordered">
		<thead class="mt-1 p-3 bg-success text-white">
		<tr>
			<td style="width: 100px">번호</td>
			<td>제목</td>
			<td>작성자</td>
			<td>작성일</td>
		</tr>
		</thead>
		<tbody>
		<%
			for(Board b : boardList){
		%>
				<tr>
					<td><%=b.boardNo%></td>
					<!-- 제목 클릭시 상세보기 이동 -->
					<td>
						<a class="title" href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage%>&boardNo=<%=b.boardNo%>">
							<%=b.boardTitle%>
						</a>
					</td>
					<td><%=b.boardWriter%></td>
					<td><%=b.createdate%></td>					
				</tr>
		<%
			}
		%>
		</tbody>
	</table>
	<div>
		<a style="float: right;" class="btn btn-infomation btn-outline-info" href="<%=request.getContextPath()%>/board/insertBoardForm.jsp">게시글 작성</a>
	</div>
	<!-- 3-2. 페이징 -->
	<br><br>
	<div>
		<%
			if(searchContent == null){
		%>
				<a class="btn btn-sm btn-outline-success mr-3" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1" style="text-decoration: none;" class="text-dark">처음</a>
				<%
					if(currentPage > 1) {
				%>
						<a class="btn btn-sm btn-outline-success mr-3" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>" style="text-decoration: none;" class="text-dark">이전</a>
				<%
					}
				%>
				<a class="btn btn-sm btn-outline-success mr-3"><%=currentPage%></a>
				<%
					if(currentPage < lastPage){
				%>
						<a class="btn btn-sm btn-outline-success mr-3" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>" style="text-decoration: none;" class="text-dark">다음</a>
				<%		
					}
				%>
				<a class="btn btn-sm btn-outline-success mr-3" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>" style="text-decoration: none;" class="text-dark">마지막</a>
		<%		
			} else {
		%>
				<a class="btn btn-sm btn-outline-success mr-3" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1&searchContent=<%=searchContent%>" style="text-decoration: none;" class="text-dark">처음</a>	
				<%
					if(currentPage > 1) {
				%>
						<a class="btn btn-sm btn-outline-success mr-3" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>&searchContent=<%=searchContent%>" style="text-decoration: none;" class="text-dark">이전</a>
				<%
					}
				%>
	</div>
	
	<!-- 검색창 -->
	<!-- 즐겨찾기 등에 쓸 주소를 저장하려고 get 방식을 사용해야할 때가 있음 / <a>는 무조건 get 방식 -->
	<form action="<%=request.getContextPath()%>/board/boardList.jsp" method="post">
		<label for="searchContent">
		<%
			if(searchContent != null){
		%>
				<input type="text" name="searchContent" id="searchContent" value="<%=searchContent%>" placeholder="글 내용 검색">
		<%		
			} else {
		%>
				<input type="text" name="searchContent" id="searchContent" placeholder="글 내용 검색">
		<%
			}
		%>
		</label>
		<button type="submit" class="btn btn-outline-info">검색</button>
	</form>
</body>
</html>