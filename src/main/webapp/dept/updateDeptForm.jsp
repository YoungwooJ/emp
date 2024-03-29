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

	request.setCharacterEncoding("utf-8"); // 한글 처리
	String deptNo = request.getParameter("deptNo");
	
	//deptList의 링크를 호출하지 않고 updateDeptForm.jsp 주소창에 직접 호출하면 deptNo는 null값이 된다.
	if(deptNo == null) {
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
		return;
	}
	
	
// 2. 업무 처리(Model) -> 모델도출
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");	// DB와 연결
	String sql = "SELECT dept_name deptName FROM departments where dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);
	ResultSet rs = stmt.executeQuery();
	
	Department dept = null;
	if(rs.next()) { // ResultSet의 API(사용방법)를 모른다면 사용할 수 없는 반복문
		dept = new Department();
		dept.deptNo = deptNo;
		dept.deptName = rs.getString("deptName");
	}
// 3. 출력(View) -> 모델데이터를 고객이 원하는 형태로 출력 -> 뷰(리포트)
	// 디버깅 코드
	System.out.println("수정할 데이터 : " + deptNo);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<title>updateDeptForm</title>
	<!-- 부트스트랩5 CDN -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
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
	</style>
</head>
<body class="container text-center">
		<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<form method="post" action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp">
		<h2 class="p-3 bg-success text-white rounded">부서를 수정합니다</h2>
		<!-- msg 파라메타값이 있으면 출력 -->
		<%
			String msg = request.getParameter("msg");
			if(request.getParameter("msg") != null) {
		%>
				<div class="text-danger"><%=msg%></div>
		<%		
			}
		%>
		<table class="table table-bordered">
			<tr>
				<td class="bg-success text-white">부서 번호 </td>
				<td><input type="text" name="deptNo" value="<%=dept.deptNo%>" readonly = "readonly"></td>
			</tr>
			<tr>
				<td class="bg-success text-white">부서 이름 </td>
				<td><input type="text" name="deptName" value="<%=dept.deptName%>"></td>
			</tr>
		</table>
		<a href="<%=request.getContextPath()%>/dept/deptList.jsp" type="button" style="float: left;" class="btn btn-white btn-outline-secondary" >이전</a>
		<button class="btn btn-outline-warning" type="submit" style="float: right;">수정</button>
	</form>
</body>
</html>