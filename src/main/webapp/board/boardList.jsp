<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 요청분석
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 2. 요청처리 후 필요하다면 모델데이터를 생성
	final int ROW_PER_PAGE = 10; // 상수 선언 문법 : final로 int 변수를 상수로 만들어준다
	int beginRow = (currentPage-1)*ROW_PER_PAGE; // ...Limit(beginRow, ROW_PER_PAGE) 
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 2-1. 페이지 출력
	String cntSql = "SELECT COUNT(*) cnt FROM board";
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0; //전체 행의 수
	if(cntRs.next()){
		cnt = cntRs.getInt("cnt");
	}
	
	// 올림 5.3 -> 6.0, 5.0 -> 5.0
	int lastPage = (int)Math.ceil((double)cnt / (double)ROW_PER_PAGE); //마지막 페이지 번호 구하기
	
	// 2-2. 페이지당 목록 출력
	String listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?,?";
	PreparedStatement listStmt = conn.prepareStatement(listSql);
	listStmt.setInt(1, beginRow);
	listStmt.setInt(2, ROW_PER_PAGE);
	ResultSet listRs = listStmt.executeQuery();
	ArrayList<Board> boardList = new ArrayList<Board>();
	while(listRs.next()){
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");
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
	
	<h2 class="mt-1 p-3 bg-success text-white rounded">자유 게시판</h2>
	<!-- 3-1. 모델 데이터(ArrayList<Board> 출력 -->
	<table class ="table table-bordered">
		<thead class="mt-1 p-3 bg-success text-white">
		<tr>
			<td>제목</td>
			<td>내용</td>
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
						<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>">
							<%=b.boardTitle%>
						</a>
					</td>
				</tr>
		<%
			}
		%>
		</tbody>
	</table>
	<div>
		<a style="float: right;" class="btn btn-primary text-white btn-outline-dark" href="<%=request.getContextPath()%>/board/insertBoardForm.jsp">게시글 작성</a>
	</div>
	<!-- 3-2. 페이징 -->
	<br><br>
	<div>
		<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1" style="text-decoration: none;" class="text-dark">&lt;처음</a>
		<%
			if(currentPage > 1) {
		%>
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>" style="text-decoration: none;" class="text-dark">이전</a>
		<%
			}
		%>
		<span><%=currentPage%></span>
		<%
			if(currentPage < lastPage){
		%>
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>" style="text-decoration: none;" class="text-dark">다음</a>
		<%		
			}
		%>
		<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>" style="text-decoration: none;" class="text-dark">마지막&gt;</a>
	</div>
</body>
</html>