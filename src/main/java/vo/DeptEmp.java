package vo;
	//FM 방식
public class DeptEmp {
	// 테이블 컬럼과 일치하는 도메인 타입
	// 단점 : JOIN결과를 처리할 수 없다
	// public int empNO;
	// public int deptNo;
	
	// 장점 : dept_emp테이블의 행뿐만 아니라 JOIN결과의 행도 처리할 수 있다
	// 단점 : 복잡하다.
	public Employee emp;
	public Department dept;
	public String fromDate;
	public String toDate;
}
