<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%
	// 1. 요청 분석(Controller)
	
	// session 유효성 검증 코드 후 필요하다면 redirect!
	if(session.getAttribute("loginEmp") == null){
		// 로그인이 안 된 상태
		response.sendRedirect(request.getContextPath()+"/member/loginForm.jsp");
		return;
	}
	
	request.setCharacterEncoding("utf-8");
	String commentNo = request.getParameter("commentNo");
	String currentPage = request.getParameter("currentPage");
	String boardNo = request.getParameter("boardNo");
	// 안전 장치 코드
	if(boardNo == null){
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
		return;
	}
	// 2. 업무 처리(Model)
	// 3. 출력 (View)
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<title>updateBoardForm</title>
	<!-- 부트스트랩5 CDN -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- CSS -->
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/style.css">
	<Style>
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
		.box:hover {
		outline: none !important;
		border-color: rgb(60, 179, 113);
		box-shadow: 0 0 10px rgb(60, 179, 113);
		}
		input, textarea{
		 	display: inline-block;
			font-size: 15px;
			border: 0;
			border-radius: 15px;
			outline: none;
			padding-left: 10px;
			background-color: rgb(233, 233, 233);
			float: left;
			width:100%
		}
	</Style>
</head>
<body class="container text-center">
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	
	<h2 class="p-3 bg-success text-white rounded">댓글 삭제</h2>
	<!-- msg 파라메타값이 있으면 출력 -->
	<%
		String msg = request.getParameter("msg");
		if(msg != null) {
	%>
			<div class="text-danger"><%=msg%></div>
	<%		
		}
	%>
	<form method="post" action="<%=request.getContextPath()%>/board/deleteCommentAction.jsp?currentPage=<%=currentPage%>">
		<input type="hidden" name="boardNo" value="<%=boardNo%>">
		<input type="hidden" name="commentNo" value="<%=commentNo%>">
		<table class="table table-bordered">
			<tr>
				<td style="width: 100px;" class="bg-success text-white">번호</td>
				<td><span style="float:left;"><%=commentNo%></span></td>
			</tr>
			<tr>
				<td class="bg-success text-white">비밀번호</td>
				<td><input class="box" type="password" name="commentPw"></td>
			</tr>
		</table>
		<a href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage%>&boardNo=<%=boardNo%>" type="button" style="float: left;" class="btn btn-white btn-outline-secondary" >이전</a>
		<button class="btn btn-outline-danger" type="submit" style="float: right;" >삭제</button>
	</form>
</body>
</html>
