
import java.util.*;

/**
 * 
 */
public class Account {

    /**
     * Default constructor
     */
    public Account(int balance) {
    	this.Amount = balance;
    }

    /**
     * 
     */
    private int Amount;

    /**
     * @return
     */
    public void withdraw(int amt) {
    	if (this.Amount>=amt) {
        	this.Amount -= amt;
        	System.out.println("Money left - " + this.Amount);
    	} else {
    		System.out.println("you broke!");
    	}
    }

    /**
     * @return
     */
    public void deposit(int amt) {
        this.Amount += amt;
        System.out.println("You have " + this.Amount);
    }

    /**
     * @return
     */
    public int GetAmt() {
        // TODO implement here
        return this.Amount;
    }

}