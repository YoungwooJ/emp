<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %> <!--  vo.DeptEmp -->
<%@ page import="vo.*" %>
<%
	// 1. 요청분석(Controller)
	// 페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 검색
	request.setCharacterEncoding("UTF-8"); //한글
	String searchName = request.getParameter("searchName");
	// 1) searchName == null, 2) searchName == "" or "단어"
	
	// 2. 요청 처리(Model)
	final int ROW_PER_PAGE = 10; // 상수 선언 문법 : final로 int 변수를 상수로 만들어준다
	int beginRow = (currentPage-1)*ROW_PER_PAGE; // ...Limit(beginRow, ROW_PER_PAGE) 
	// db연결 -> 모델생성, 변수를 선언해서 db에 연결해준다
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw); // ("프로토콜(ex. https:)//주소(IP주소나 도메인 주소): 포트번호", "", ""); 
	// 2-1. 마지막 페이지
	// 검색 기능 넣기 위한 null 초기화
	String cntSql = null;
	PreparedStatement cntStmt = null;
	if(searchName == null || searchName.equals("")){
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp";
		cntStmt = conn.prepareStatement(cntSql);	
	} else {
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ?";
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
	// 다중 조인 처리
	String sql = null;
	PreparedStatement stmt = null;
	if(searchName == null){
		sql = "SELECT de.emp_no empNo, d.dept_name deptName, de.from_date fromDate, de.to_date toDate, e.first_name firstName, e.last_name lastName FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no ORDER BY de.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, ROW_PER_PAGE);
	} else {
		sql = "SELECT de.emp_no empNo, d.dept_name deptName, de.from_date fromDate, de.to_date toDate, e.first_name firstName, e.last_name lastName FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? ORDER BY de.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+searchName+"%");
		stmt.setString(2, "%"+searchName+"%");
		stmt.setInt(3, beginRow);
		stmt.setInt(4, ROW_PER_PAGE);
	}
	
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empNo", rs.getInt("empNo"));
		m.put("firstName", rs.getString("firstName"));
		m.put("lastName", rs.getString("lastName"));
		m.put("fromDate", rs.getString("fromDate"));
		m.put("toDate", rs.getString("toDate"));
		m.put("deptName", rs.getString("deptName"));
		list.add(m);
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
	<title>deptEmpMapList</title>
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
	
	<h2 style="float:left">사원 상세정보</h2>
	
	<table class ="table table-bordered">
		<thead class="mt-1 p-3 bg-success text-white">
		<tr>
			<td>사원번호</td>
			<td>이름</td>
			<td>입사날짜</td>
			<td>퇴사날짜</td>
			<td>부서이름</td>
		</tr>
		</thead>
		<tbody>
		<%
			for(HashMap<String, Object> m : list) {
		%>
				<tr>
					<td><%=m.get("empNo")%></td>
					<td><%=m.get("firstName")%>&nbsp;<%=m.get("lastName")%></td>
					<td><%=m.get("fromDate")%></td>
					<td><%=m.get("toDate")%></td>
					<td><%=m.get("deptName")%></td>
				</tr>
		<%		
			}
		%>
		</tbody>
	</table>
	<!-- 페이징 -->
		<div class="text-center">
			<%
				if(searchName == null){			
			%>
					<a class="btn btn-sm btn-outline-success mr-3" href="<%=request.getContextPath()%>/deptemp/deptEmpMapList.jsp?currentPage=1">처음</a>
					<%
						if(currentPage > 1){
					%>
							<a class="btn btn-sm btn-outline-success mr-3" href="<%=request.getContextPath()%>/deptemp/deptEmpMapList.jsp?currentPage=<%=currentPage-1%>">이전</a>
					<%
						}
					%>
					<span class="btn btn-sm btn-outline-success mr-3"><%=currentPage%></span>
					<%
						if(currentPage < lastPage){
					%>
							<a class="btn btn-sm btn-outline-success mr-3" href="<%=request.getContextPath()%>/deptemp/deptEmpMapList.jsp?currentPage=<%=currentPage+1%>">다음</a>
					<%
						}
					%>
					<a class="btn btn-sm btn-outline-success mr-3" href="<%=request.getContextPath()%>/deptemp/deptEmpMapList.jsp?currentPage=<%=lastPage%>">마지막</a>
			<% 
				}else{			
			%>
					<a class="btn btn-sm btn-outline-success mr-3" href="<%=request.getContextPath()%>/deptemp/deptEmpMapList.jsp?currentPage=1&searchName=<%=searchName%>">처음</a>
					<%
						if(currentPage > 1){
					%>
							<a class="btn btn-sm btn-outline-success mr-3" href="<%=request.getContextPath()%>/deptemp/deptEmpMapList.jsp?currentPage=<%=currentPage-1%>&searchName=<%=searchName%>">이전</a>
					<%
						}
					%>
					<span class="btn btn-sm btn-outline-success mr-3"><%=currentPage%></span>
					<%
						if(currentPage < lastPage){
					%>
							<a class="btn btn-sm btn-outline-success mr-3" href="<%=request.getContextPath()%>/deptemp/deptEmpMapList.jsp?currentPage=<%=currentPage+1%>&searchName=<%=searchName%>">다음</a>
					<%
						}
					%>
					<a class="btn btn-sm btn-outline-success mr-3" href="<%=request.getContextPath()%>/deptemp/deptEmpMapList.jsp?currentPage=<%=lastPage%>&searchName=<%=searchName%>">마지막</a>
			<% 
				}
			%>
		</div>
		
		<!-- 검색창 -->
		<!-- 즐겨찾기 등에 쓸 주소를 저장하려고 get 방식을 사용해야할 때가 있음 / <a>는 무조건 get 방식 -->
		<form action="<%=request.getContextPath()%>/salary/salaryList.jsp" method="post">
			<label for="searchName">
			<%
				if(searchName != null){
			%>
					<input type="text" name="searchName" id="searchName" value="<%=searchName%>" placeholder="사원 성/이름 검색">
			<%
				} else {
			%>
					<input type="text" name="searchName" id="searchName" placeholder="사원 성/이름 검색">
			<%	
				}
			%>
			 </label>
			<button type="submit" class="btn btn-outline-info">검색</button>
		</form>
</body>
</html>