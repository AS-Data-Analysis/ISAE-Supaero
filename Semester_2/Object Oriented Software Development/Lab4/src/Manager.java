
public class Manager extends Employee {

    public Manager(String name, String firstname, float salary, float bonus) {
    	super(name, firstname, salary);
    	this.Bonus=bonus;
    }
    
    public Manager() {
    	super();
    }

    private float Bonus;

    public float getBonus() {
        return this.Bonus;
    }

    public void setBonus(float bonus) {
        this.Bonus=bonus;
    }

    public float giveBonus() {
        this.Salary += this.Bonus;
        return this.Salary;
    }

}