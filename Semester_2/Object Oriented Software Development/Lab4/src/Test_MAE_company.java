
public class Test_MAE_company {

    public Test_MAE_company() {
    }

    public static void main(String args[]) {
        
    	Employee [] company = new Employee[3];
    	
    	company[0] = new Manager("Hudson","Alice",3000,150);
    	company[1] = new Employee("Smith","George",2000);
    	company[2] = new Employee("Hoffman","Katherine",4500);
    	
    	for (int i=0; i<company.length; i++) {
    		if(company[i] instanceof Manager) {
    			System.out.println(company[i].getFirstName()+" "+company[i].getName()+" is a manager with a salary of "+company[i].getSalary()
    			+" and the salary after adding the bonus is "+ ((Manager) (company[i])).giveBonus());
    		}
    		else {
    			System.out.println(company[i].getFirstName()+" "+company[i].getName()+" is an employee with a salary of "+company[i].getSalary());
    		}
    	}
    }

}