<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %> <!--  vo.Salary -->
<%@ page import = "java.util.*" %>
<%
	// 1. 요청분석(Controller)
	// 페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 검색
	request.setCharacterEncoding("UTF-8");	//한글
	String searchName = request.getParameter("searchName");
	// 1) searchName == null, 2) searchName == "" or "단어"
	
	// 2. 요청 처리(Model)
	final int ROW_PER_PAGE = 10; // 상수 선언 문법 : final로 int 변수를 상수로 만들어준다
	int beginRow = (currentPage-1)*ROW_PER_PAGE; // ...Limit(beginRow, ROW_PER_PAGE) 
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	// 2-1. 마지막 페이지
	// 검색 기능 넣기 위한 null 초기화
	String cntSql = null;
	PreparedStatement cntStmt = null;
	if(searchName == null || searchName.equals("")){
		cntSql = "SELECT COUNT(*) cnt FROM salaries";
		cntStmt = conn.prepareStatement(cntSql);	
	} else {
		cntSql = "SELECT COUNT(*) cnt FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		// 성 or 이름에 검색하고자 하는 단어가 포함되어 있다면
		cntStmt.setString(1, "%"+searchName+"%");
		cntStmt.setString(2, "%"+searchName+"%");
	}
	
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()){
		cnt = cntRs.getInt("cnt");
	}
	int lastPage = (int)Math.ceil((double)cnt/ROW_PER_PAGE);
	
	// 2-2. 조인 처리
	// 테이블1 JOIN 테이블2 ON 조건
	String sql = null;
	PreparedStatement stmt = null;
	if(searchName == null){
		sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_Date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, ROW_PER_PAGE);
	} else {
		sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? ORDER BY s.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+searchName+"%");
		stmt.setString(2, "%"+searchName+"%");
		stmt.setInt(3, beginRow);
		stmt.setInt(4, ROW_PER_PAGE);
	}
	
	ResultSet rs = stmt.executeQuery();
	ArrayList<Salary> salaryList = new ArrayList<>();
	while(rs.next()){
		Salary s = new Salary();
		s.emp = new Employee(); // ☆☆☆☆☆ ☆객체에 객체 넣기☆
		s.emp.empNo = rs.getInt("empNo");
		s.salary = rs.getInt("salary");
		s.fromDate = rs.getString("fromDate");
		s.toDate = rs.getString("toDate");
		s.emp.firstName = rs.getString("firstName");
		s.emp.lastName = rs.getString("lastName");
		salaryList.add(s);
	}
	
	// 닫아주는 메소드
	cntRs.close();
	cntStmt.close();
	
	rs.close();
	stmt.close();
	conn.close();
	
	// 3. 출력(View)
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
	<title>salaryList</title>
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
	
	<h2 style="float:left">연봉 목록</h2>
	
	<table class ="table table-bordered">
		<thead class="mt-1 p-3 bg-success text-white">
		<tr>
			<th>사원번호</th>
			<th>사원이름</th>
			<th>연봉</th>
			<th>입사날짜</th>
			<th>퇴사날짜</th>
		</tr>
		</thead>
		<tbody>
		<%
			for(Salary s : salaryList) {
		%>
				<tr>
					<td><%=s.emp.empNo%></td>
					<td><%=s.emp.firstName%>&nbsp;<%=s.emp.lastName%></td>
					<td><%=s.salary%></td>
					<td><%=s.fromDate%></td>
					<td><%=s.toDate%></td>
				</tr>
		<%		
			}
		%>
		</tbody>
	</table>
	<!-- 페이징 -->
	<ul class="pagination justify-content-center">
		<%
			if(searchName == null || searchName.equals("")){			
		%>
				<li class="page-item"><a class="page-link text-success" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1">처음</a></li>
				<%
					if(currentPage > 1){
				%>
						<li class="page-item"><a class="page-link text-success" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage-1%>">이전</a></li>
				<%
					}
				%>
				<li class="page-item"><span class="page-link text-success"><%=currentPage%></span></li>
				<%
					if(currentPage < lastPage){
				%>
						<li class="page-item"><a class="page-link text-success" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>">다음</a></li>
				<%
					}
				%>
				<li class="page-item"><a class="page-link text-success" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>">마지막</a></li>
		<% 
			}else{			
		%>
				<li class="page-item"><a class="page-link text-success" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1&searchName=<%=searchName%>">처음</a></li>
				<%
					if(currentPage > 1){
				%>
						<li class="page-item"><a class="page-link text-success" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage-1%>&searchName=<%=searchName%>">이전</a></li>
				<%
					}
				%>
				<li class="page-item"><span class="page-link text-success"><%=currentPage%></span></li>
				<%
					if(currentPage < lastPage){
				%>
						<li class="page-item"><a class="page-link text-success" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>&searchName=<%=searchName%>">다음</a></li>
				<%
					}
				%>
				<li class="page-item"><a class="page-link text-success" href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>&searchName=<%=searchName%>">마지막</a></li>
		<% 
			}
		%>
	</ul>
		
	<!-- 검색창 -->
	<!-- 즐겨찾기 등에 쓸 주소를 저장하려고 get 방식을 사용해야할 때가 있음 / <a>는 무조건 get 방식 -->
	<form action="<%=request.getContextPath()%>/salary/salaryList.jsp" method="post">
		<label for="searchName">
		<%
			if(searchName != null){
		%>
				<input type="text" name="searchName" id="searchName" value="<%=searchName%>" placeholder="사원 이름 검색">
		<%
			} else {
		%>
				<input type="text" name="searchName" id="searchName" placeholder="사원 이름 검색">
		<%	
			}
		%>
		 </label>
		<button type="submit" class="btn btn-outline-info">검색</button>
	</form>
</body>
</html>