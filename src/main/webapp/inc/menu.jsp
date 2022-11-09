<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- partial jsp 페이지 사용할 코드 -->
<div class="mt-1 p-3 bg-dark text-white" style="width:100%;">
			<a class="text-white" style="text-decoration: none; text-align: center;" href="<%=request.getContextPath()%>/index.jsp">홈으로</a>
			<a class="text-white" style="text-decoration: none; text-align: center;" href="<%=request.getContextPath()%>/dept/deptList.jsp">부서관리</a>
			<a class="text-white" style="text-decoration: none; text-align: center;" href="<%=request.getContextPath()%>/emp/empList.jsp">사원관리</a>
			<a class="text-white" style="text-decoration: none; text-align: center;" href="<%=request.getContextPath()%>/emp/empList.jsp">연봉관리</a>
</div>