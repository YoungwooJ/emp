<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%
	//1. 요청 분석(Controller)
	
	// session 유효성 검증 코드 후 필요하다면 redirect!
	if(session.getAttribute("loginEmp") == null){
		// 로그인이 안 된 상태
		response.sendRedirect(request.getContextPath()+"/member/loginForm.jsp");
		return;
	}
	
	String memberId = request.getParameter("memberId");
	
	// 안전 장치 코드
	if(memberId == null || memberId.equals("")){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	
	// 2. 업무 처리(Model)
	// db 연결
	String driver	= "org.mariadb.jdbc.Driver";
	String dbUrl	= "jdbc:mariadb://localhost:3306/employees";
	String dbUser	= "root";
	String dbPw		= "java1234";
	
	Class.forName(driver); // 외부 드라이브 로딩
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 쿼리
	String sql = "SELECT member_id memberId, member_name memberName FROM member WHERE member_id = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	ResultSet rs = stmt.executeQuery();
	
	Member member = null;
	if(rs.next()){
		member = new Member();
		member.setMemberId(rs.getString("memberId"));
		member.setMemberName(rs.getString("memberName"));
	}
	
	// 3. 출력(View)
	// 디버깅 코드
	System.out.println("수정할 이름 : " + member.getMemberName());
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>updateMemberForm</title>
	<!-- 부트스트랩5 CDN -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
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
		input:hover {
			outline: none !important;
			border-color: rgb(60, 179, 113);
			box-shadow: 0 0 10px rgb(60, 179, 113);
		}
	</style>
</head>
<body class="container text-center">
	<!-- msg 파라메타값이 있으면 출력 -->
	<%
		String msg = request.getParameter("msg");
		if(msg != null) {
	%>
			<div class="text-danger"><%=msg%></div>
	<%		
		}
	%>
	<form action="<%=request.getContextPath()%>/member/updateMemberAction.jsp">
		<h2 class="p-3 bg-success text-white rounded">닉네임 수정</h2>
		<table class="table">
			<tr>
				<td class="bg-success text-white">아이디</td>
				<td>
					<input type="text" name="memberId" value="<%=member.getMemberId()%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="bg-success text-white">기존 닉네임</td>
				<td>
					<input type="text" name="memberName" value="<%=member.getMemberName()%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="bg-success text-white">변경할 닉네임</td>
				<td>
					<input type="text" name="newMemberName" value="">
				</td>
			</tr>
			<tr>
				<td class="bg-success text-white">비밀번호 확인</td>
				<td>
					<input type="password" name="memberPw" value="">
				</td>
			</tr>
		</table>
		<button style="float: right;" class="btn btn-white btn-outline-info" type="submit">변경</button>
	</form>
</body>
</html>