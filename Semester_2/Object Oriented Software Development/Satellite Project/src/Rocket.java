import java.time.Instant;
import java.time.Duration;

public class Rocket {
	
    // Rocket Parameters are declared
    private double rocketMass;
    private double fuelBurnRate;
    private double fuelMass;
    private double trajectory;
    private double fuelRatio;

    // The take-off method returns the time-stamp of the rocket launch
    public Instant takeoff() {
    	Instant launchTime = Instant.now();
    	System.out.println("We have liftoff!\n");
        return launchTime;
    }

    // Initiates landing of separated engine
    public void land() {
    	System.out.println("Landing initiated");
    }

    // The engine release procedure occurs when half fuel has been burnt and when all the fuel has been burnt
    // flag=1 --> 1st engine separation
    // second flag is not required as orbit altitude condition can be used instead
    public int releaseEngine(double initialFuelMass, double fuelRatio) {
    	int flag = 0;
        if(Math.abs(this.fuelMass-fuelRatio*initialFuelMass)<=this.fuelBurnRate/2) {
        	flag ++;
        	return flag;
        }
    	return flag;
    }

    // getter function for the fuel mass
    public double getFuelMass() {
        return this.fuelMass;
    }
    
    // This method computes the evolution of the fuel mass according to the fuel burn rate. 
    // A time delay of 10 milliseconds in the simulation has been placed to run the simulation faster.
    public void setFuelMass(Instant launchTime, double initialFuelMass) {
    	Duration duration = Duration.between(launchTime, Instant.now());
    	long c = duration.toNanos()/1000;
    	int a = (int)c;
    	if(a == 0) {
    		this.fuelMass = initialFuelMass;
    	}
    	else {
    		try {
        		Thread.sleep(10);
        	}
        	catch(InterruptedException ex) {
        	}
    		this.fuelMass -= this.fuelBurnRate;
    	}
    }

    // getter function for the trajectory of the rocket
    public double getTrajectory() {
        return this.trajectory;
    }

    // This function calculates the altitude change of the rocket
    public void setTrajectory(Instant launchTime) {
    	Duration duration = Duration.between(launchTime, Instant.now());
    	long c = duration.toNanos()/1000;
    	int a = (int)c;
    	if(a == 0) {
    		this.trajectory = 0.0;				// This is when the trajectory is set to 0 when launchTime has not begun.
    	}
    	else {
    		this.trajectory += 876;			// The trajectory is increased by 876 m (calculated to reach orbit as fuel reaches zero).
    	}
    }

    // getter function for rocket mass
    public double getRocketMass() {
        return this.rocketMass;
    }

    // This function reduces the mass of the rocket when an engine separation occurs. 
    // The coefficient 'c' depends on the stage of the engine separation.
    // c = 1 --> initial rocket mass
    // c = 0.5 --> 1st stage engine separation
    public void setRocketMass(double initialRocketMass, double c) {
    	this.rocketMass = initialRocketMass*c;
    }

    // Fuel burn rate is constant and set to 140 kg/s
    public void setFuelBurnRate(double fuelBurnRate) {
    	this.fuelBurnRate = fuelBurnRate;
    }
    
    // getter function for fuel ratio
    public double getFuelRatio() {
    	return this.fuelRatio;
    }
    
    // Fuel ratio is constant and set to 0.5 (50%)
    public void setFuelRatio(double fuelRatio) {
    	this.fuelRatio = fuelRatio;
    }
}