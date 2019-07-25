public class Employee {
    String EmployeeName;
    Integer EmpNo;
    public Employee()
    {
        EmployeeName = 'Sumit Pandey';
        EmpNo = 1090;
    }
    public void show()
    {
        System.debug('Employee name is ' +EmployeeName);
        System.debug('Employee no. is ' +EmpNo);
    }

}