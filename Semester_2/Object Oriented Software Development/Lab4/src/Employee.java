
public class Employee {

    public Employee(String name, String firstname, float salary) {
    	this.Name=name;
    	this.FirstName=firstname;
    	this.Salary=salary;
    }
    
    public Employee() {
    }

    protected String Name;
    protected String FirstName;
    protected float Salary;

    public void setName(String name) {
        this.Name=name;
    }

    public String getName() {
        return this.Name;
    }

    public void setFirstName(String firstname) {
        this.FirstName=firstname;
    }

    public String getFirstName() {
        return this.FirstName;
    }

    public void setSalary(float salary) {
        this.Salary=salary;
    }

    public float getSalary() {
        return this.Salary;
    }

}