<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청분석(Controller)
	
	request.setCharacterEncoding("UTF-8");
	String search = request.getParameter("search");
	// 1) search -> null 2) search -> '' or search -> '단어' 2가지 형태로 쿼리가 분기	

	// session 유효성 검증 코드 후 필요하다면 redirect!
	if(session.getAttribute("loginEmp") == null){
		// 로그인이 안 된 상태
		response.sendRedirect(request.getContextPath()+"/member/loginForm.jsp");
		return;
	}
	
	Object objLoginEmp = session.getAttribute("loginEmp");
	Member loginEmp = (Member)objLoginEmp;
	//System.out.println(loginEmp);
	
	// 페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	String sort = "ASC";
	if(request.getParameter("sort") != null && request.getParameter("sort").equals("DESC")){
		sort = "DESC";
	}
	//System.out.println(sort);
	
	// 2) Model
	String driver	= "org.mariadb.jdbc.Driver";
	String dbUrl	= "jdbc:mariadb://localhost:3306/employees";
	String dbUser	= "root";
	String dbPw		= "java1234";
	
	Class.forName(driver); // 외부 드라이브 로딩
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 페이징
	final int ROW_PER_PAGE = 10; // 상수 선언 문법 : final로 int 변수를 상수로 만들어준다
	int beginRow = (currentPage-1)*ROW_PER_PAGE;

	// lastPage 알고리즘 코드
	String countSql = null;
	PreparedStatement countStmt = null;
	if(search == null || search.equals("")){ // null 이거나 검색 값이 없으면 -> 전체 데이터 개수
		countSql = "SELECT COUNT(*) FROM employees";
		countStmt = conn.prepareStatement(countSql);
	} else {
		countSql = "SELECT COUNT(*) FROM employees WHERE first_name LIKE ? OR last_name LIKE ?";
		countStmt = conn.prepareStatement(countSql);
		countStmt.setString(1, "%"+search+"%");
		countStmt.setString(2, "%"+search+"%");
	}
	
	ResultSet countRs = countStmt.executeQuery();
	int count = 0;
	if(countRs.next()){
		count = countRs.getInt("COUNT(*)");
	}
	
	int lastPage = count / ROW_PER_PAGE;
	if(count % ROW_PER_PAGE != 0) {
		lastPage = lastPage + 1; // lastPage++, lastPage+=1
	}
	countRs.close();
	countStmt.close();
	
	// 사원목록
	String sql = null;
	PreparedStatement stmt = null;
	
	if(search == null || search.equals("")){ // null 이거나 검색 값이 없으면 -> 전체 데이터 개수
		sql = "SELECT emp_no empNo, birth_date birthDate, first_name firstName, last_name lastName, hire_date hireDate FROM employees ORDER BY first_name ASC Limit ?, ?";
		if(sort != null && sort.equals("DESC")){
			sql = "SELECT emp_no empNo, birth_date birthDate, first_name firstName, last_name lastName, hire_date hireDate FROM employees ORDER BY first_name DESC LIMIT ?, ?";
		}
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, ROW_PER_PAGE);
		//System.out.println(sql);
	} else {
		sql = "SELECT emp_no empNo, birth_date birthDate, first_name firstName, last_name lastName, hire_date hireDate FROM employees WHERE first_name LIKE ? OR last_name LIKE ? ORDER BY first_name ASC LIMIT ?, ?";
		if(sort != null && sort.equals("DESC")){
			sql = "SELECT emp_no empNo, birth_date birthDate, first_name firstName, last_name lastName, hire_date hireDate FROM employees WHERE first_name LIKE ? OR last_name LIKE ? ORDER BY first_name DESC LIMIT ?, ?";
		}
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+search+"%");
		stmt.setString(2, "%"+search+"%");
		stmt.setInt(3, beginRow);
		stmt.setInt(4, ROW_PER_PAGE);
		//System.out.println(sql);
	}
	
	ResultSet rs = stmt.executeQuery();
	
	ArrayList<Employee> list = new ArrayList<Employee>();
	while(rs.next()){
		Employee e = new Employee();
		e.setEmpNo(rs.getInt("empNo"));
		e.setBirthDate(rs.getString("birthDate"));
		e.setFirstName(rs.getString("firstName"));
		e.setLastName(rs.getString("lastName"));
		e.setHireDate(rs.getString("hireDate"));
		list.add(e);
	}
	rs.close();
	stmt.close();
	conn.close();
	// 3) View
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<title>index</title>
	<!-- 부트스트랩5 CDN -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- CSS -->
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/style.css">
	<style>
		.ol {
			font-weight: bold;
		}
	</style>
</head>
<body class="container text-center">
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<h1 class="p-3 bg-success text-white" style="width:100%;">사원 페이지</h1>
	
	<div class="alert alert-primary" role="alert">
		<%=loginEmp.getFirstName()%>(<%=loginEmp.getEmpNo()%>)님 반갑습니다.
	</div>
	<h3 style="float:left;">내 정보</h3>
	<!-- msg 파라메타값이 있으면 출력 -->
	<%
		String msg = request.getParameter("msg");
		if(msg != null) {
	%>
			<div class="text-danger"><%=msg%></div>
	<%		
		}
	%>
	<table class ="table table-bordered">
		<tr>
			<td>사원 번호</td>
			<td><%=loginEmp.getEmpNo()%></td>
		</tr>
		<tr>
			<td>아이디</td>
			<td><%=loginEmp.getMemberId()%></td>
		</tr>
		<tr>
			<td>이름</td>
			<td><%=loginEmp.getFirstName()%></td>
		</tr>
		<tr>
			<td>성</td>
			<td><%=loginEmp.getLastName()%></td>
		</tr>
		<tr>
			<td>닉네임</td>
			<td><%=loginEmp.getMemberName()%></td>
		</tr>
		<tr>
			<td>성별</td>
			<td><%=loginEmp.getGender()%></td>
		</tr>
		<tr>
			<td>출생일</td>
			<td><%=loginEmp.getBirthDate()%></td>
		</tr>
		<tr>
			<td>입사일</td>
			<td><%=loginEmp.getHireDate()%></td>
		</tr>
	</table>
	<div>
		<a style="float: right;" type="button" class="btn btn-white btn-outline-danger" href="<%=request.getContextPath()%>/member/deleteMemberForm.jsp?memberId=<%=loginEmp.getMemberId()%>">회원탈퇴</a>
		<!-- deleteMemberAction.jsp 비밀번호 확인 후 삭제 session.invalidate()-->
	</div>
	<div>
		<a style="float: right;" type="button" class="btn btn-white btn-outline-info" href="<%=request.getContextPath()%>/member/updateMemberForm.jsp?memberId=<%=loginEmp.getMemberId()%>">개인정보수정</a>
		<!-- updateMemberAction.jsp 비밀번호 수정은 안됨-->
	</div>		
	<div>
		<a style="float: right;" type="button" class="btn btn-white btn-outline-info" href="<%=request.getContextPath()%>/member/updateMemberPwForm.jsp?memberId=<%=loginEmp.getMemberId()%>">비밀번호수정</a>
		<!-- updateMemberPwAction.jsp 수정 전 비밀번호, 변경할 비밀번호를 입력받아야 함-->
	</div>
	
	<a style="float: left;" type="button" class="btn btn-white btn-outline-info" href="<%=request.getContextPath()%>/member/logout.jsp">로그아웃</a>
	<br><br>
	<h2 style="float:left;">사원목록</h2>
	<%
		if(sort.equals("ASC")){
	%>
			<a style="float: right;" type="button" class="btn btn-white btn-outline-secondary" href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=currentPage%>&sort=DESC">내림차순</a>
	<%		
		} else {
	%>
			<a style="float: right;" type="button" class="btn btn-white btn-outline-secondary" href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=currentPage%>&sort=ASC">오름차순</a>
	<%		
		}
	%>
	<table class ="table table-bordered">
		<thead class="mt-1 p-3 bg-success text-white">
		<tr>
			<th>번호</th>
			<th>이름</th>
			<th>성</th>
			<th>출생일</th>
			<th>입사일</th>
		</tr>
		</thead>
		<tbody>
		<%
			for(Employee e : list){
		%>
				<tr>
					<td><%=e.getEmpNo()%></td>
					<td><%=e.getFirstName()%></td>
					<td><%=e.getLastName()%></td>
					<td><%=e.getBirthDate()%></td>
					<td><%=e.getHireDate()%></td>
				</tr>
		<%
			}
		%>
		</tbody>
	</table>
	<!-- 검색창 -->
	<!-- 즐겨찾기 등에 쓸 주소를 저장하려고 get 방식을 사용해야할 때가 있음 / <a>는 무조건 get 방식 -->
	<form style="float:right;" action="<%=request.getContextPath()%>/index.jsp?sort=<%=sort%>" method="post">
		<label for="search">
		사원검색: 
		<%
			if(search != null){
		%>
				<input type="text" name="search" id="search" value="<%=search%>" placeholder="성/이름 검색">
		<%		
			} else {
		%>
				<input type="text" name="search" id="search" placeholder="성/이름 검색">
		<%		
			}
		%>
		 </label>
		<button type="submit" class="btn btn-outline-info">검색</button>
	</form>	
	<br><br>
	<!-- 페이징 코드 -->
	<ul class="pagination justify-content-center">
		<%
			if(search == null || search.equals("")){
		%>
				<li class="page-item"><a class="page-link text-success" href="<%=request.getContextPath()%>/index.jsp?currentPage=1&sort=<%=sort%>" class="text-dark">처음</a></li>
				<%
					if(currentPage > 1) {
				%>
						<li class="page-item"><a class="page-link text-success" href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=currentPage-1%>&sort=<%=sort%>" class="text-dark">이전</a></li>
				<%
					}
				%>
				<li class="page-item"><span class="page-link text-success"><%=currentPage%></span></li>
				<%
					if(currentPage < lastPage){
				%>
						<li class="page-item"><a class="page-link text-success" href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=currentPage+1%>&sort=<%=sort%>" class="text-dark">다음</a></li>
				<%		
					}
				%>
				<li class="page-item"><a class="page-link text-success" href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=lastPage%>&sort=<%=sort%>" class="text-dark">마지막</a></li>
		<%		
			} else { // 검색 값이 있을 때 페이징(계속 값을 넘겨준다)
		%>
				<li class="page-item"><a class="page-link text-success" href="<%=request.getContextPath()%>/index.jsp?currentPage=1&search=<%=search%>&sort=<%=sort%>" class="text-dark">처음</a></li>	
				<%
					if(currentPage > 1) {
				%>
						<li class="page-item"><a class="page-link text-success" href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=currentPage-1%>&search=<%=search%>&sort=<%=sort%>" class="text-dark">이전</a></li>
				<%
					}
				%>
				<li class="page-item"><span class="page-link text-success"><%=currentPage%></span></li>
				<%
					if(currentPage < lastPage){
				%>
						<li class="page-item"><a class="page-link text-success" href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=currentPage+1%>&search=<%=search%>&sort=<%=sort%>" class="text-dark">다음</a></li>
				<%		
					}
				%>
				<li class="page-item"><a class="page-link text-success" href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=lastPage%>&search=<%=search%>&sort=<%=sort%>" class="text-dark">마지막</a></li>
		<%
			}
		%>	
	</ul>
</body>
</html>