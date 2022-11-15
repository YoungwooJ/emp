<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- partial jsp 페이지 사용할 코드 -->
<div class="p-3 text-white" align="left" style="float:left; background-color: #005000; width:100%;">
	<a class="text-white" style="text-decoration: none;" href="<%=request.getContextPath()%>/index.jsp">홈으로</a>
	<a class="text-white" style="text-decoration: none;" href="<%=request.getContextPath()%>/dept/deptList.jsp">부서관리</a>
	<a class="text-white" style="text-decoration: none;" href="<%=request.getContextPath()%>/emp/empList.jsp">사원관리</a>
<!--<a class="text-white" style="text-decoration: none;" href="<%=request.getContextPath()%>/deptemp/deptEmpList.jsp">부서별사원관리</a>-->
	<a class="text-white" style="text-decoration: none;" href="<%=request.getContextPath()%>/salary/salaryList.jsp">연봉관리</a>
	<a class="text-white" style="text-decoration: none;" href="<%=request.getContextPath()%>/board/boardList.jsp">게시판관리</a>
</div>