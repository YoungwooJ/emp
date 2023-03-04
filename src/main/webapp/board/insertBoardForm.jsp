<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 1. 요청 분석(Controller)
	
	// session 유효성 검증 코드 후 필요하다면 redirect!
	if(session.getAttribute("loginEmp") == null){
		// 로그인이 안 된 상태
		response.sendRedirect(request.getContextPath()+"/member/loginForm.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<title>insertBoardForm</title>
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
	</style>
</head>
<body class="container text-center">
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<h2 class="p-3 bg-success text-white rounded">게시물을 등록합니다</h2>
	<!-- msg 파라메타값이 있으면 출력 -->
	<%
		String msg = request.getParameter("msg");
		if(request.getParameter("msg") != null) {
	%>
			<div class="text-danger"><%=msg%></div>
	<%		
		}
	%>
	<form method="post" action="<%=request.getContextPath()%>/board/insertBoardAction.jsp">
		<table class ="table table-bordered">
			<tr>
				<td style="width: 100px;" class="bg-success text-white">작성자</td>
				<td>
					<input type="text" name="boardWriter" value="" class="box" placeholder="작성자를 입력해주세요.">
				</td>
			</tr>			
			<tr>
				<td class="bg-success text-white">제목</td>
				<td>
					<input type="text" name="boardTitle" value="" class="box" placeholder="제목을 입력해주세요.">
				</td>
			</tr>
			<tr>
				<td class="bg-success text-white" class="box">내용</td>
				<td>
					<textarea rows="25" cols="60" name="boardContent" class="box" placeholder="내용을 입력해주세요."></textarea>
				</td>
			</tr>
			<tr>
				<td class="bg-success text-white">
					<div>비밀번호</div>
				</td>
				<td>
					<input type="number" name="boardPw" value="1234" readonly="readonly" class="box">
				</td>
			</tr>
		</table>
		<a href="<%=request.getContextPath()%>/board/boardList.jsp" type="button" style="float: left;" class="btn btn-white btn-outline-secondary" >이전</a>
		<button style="float: right;" class="btn btn-outline-warning" type="submit">등록</button>
	</form>
</body>
</html>