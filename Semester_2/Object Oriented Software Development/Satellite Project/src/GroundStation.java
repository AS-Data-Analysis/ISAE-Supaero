import java.time.Duration;
import java.time.Instant;

public class GroundStation {
	
	// Objects of the rocket and the satellite controller are created which serve as the handles to control both these parts of the mission
	private Rocket rocket = new Rocket();
	private SatelliteController SC = new SatelliteController();
	
    // This method - 'launch' is responsible for conducting the rocket launch and transferring the satellite to the specified orbit
    public void Launch(double initialFuelMass, double initialRocketMass, double fuelBurnRate, double hLEO, double fuelRatio) {
    	
    	// A timer is started the moment the rocket takesoff
    	Instant launchTime = rocket.takeoff();
    	
    	// All rocket parameters are initialized
    	rocket.setRocketMass(initialRocketMass, 1.0);
    	rocket.setFuelMass(launchTime, initialFuelMass);
    	rocket.setFuelBurnRate(fuelBurnRate);
    	rocket.setFuelRatio(fuelRatio);
    	
    	// This while loop runs throughout the course of the launch. 
    	// The rocket is reusable which means it will land after separation.
    	while(rocket.getFuelMass() > 0) {
    		
    		// The fuel is continuously burnt to propel the rocket, so the fuel mass and altitude values are updated here.
    		rocket.setFuelMass(launchTime, initialFuelMass);
    		rocket.setTrajectory(launchTime);
    		
    		// A concept of a flag is used to identify the stage of engine separation. 
    		// The mass of the rocket structure reduces once an engine separates, so the rocket mass is updated depending on the flag value.
    		int flag = rocket.releaseEngine(initialFuelMass, fuelRatio);
    		if(flag == 1) {
            	rocket.setRocketMass(initialRocketMass, 0.5);
            	System.out.println("\n1st stage separation successful.");
            	rocket.land();
            	System.out.println("Rocket Mass = " + rocket.getRocketMass() + "kg\n");
            	try {
            		Thread.sleep(1500); 	// delay to show values at each instant
            	}
            	catch(InterruptedException ex) {
            	}
            }

    		// Evolution of the fuel mass, altitude and the time taken are printed.
    		Duration duration = Duration.between(launchTime, Instant.now());
    		System.out.print("Fuel Mass = " + rocket.getFuelMass() + " kg");
    		System.out.print("		Altitude = " + rocket.getTrajectory()/1000 + " km");
    		System.out.print("		Time = " + Math.round(duration.toNanos()*1E-7*100.0)/100.0 + " seconds\n");
    		
    		// This is the landing criteria, once the orbit is reached by satellite, the rocket lands.
    		if(rocket.getTrajectory() >= hLEO) {
    			rocket.setRocketMass(initialRocketMass, 0.0);
				System.out.println("\n2nd stage separation successful.");
		    	rocket.land();
				System.out.println("Rocket Mass = " + rocket.getRocketMass() + "kg\n");
				
    			System.out.println("\nOrbit reached");
    	    	System.out.println("\n\nThe satellite has started its orbit\n");
    	    	try {
            		Thread.sleep(1500);
            	}
            	catch(InterruptedException ex) {
            	}
    			break;
    		}
    	}	
    }
    
    
    // This method consists of satellite related operations including image capture, transmission and image quality checks
    public void SatelliteOperations(int dpiRef, double latISAE, double longISAE, double latInitial, double longInitial) {
    	
    	// The life of the satellite in the orbit is tracked
    	Instant orbitLife = Instant.now();
    	
    	// For the sake of simplicity, we have run the simulation for 20 seconds
    	while(Duration.between(orbitLife, Instant.now()).getSeconds() < 20) {
    		
    		// Satellite parameters of position, time and power status are initialized
    		SC.setPosition(orbitLife, latInitial, longInitial);
    		SC.setTime();
    		SC.setPower();
    		
    		// The satellite continuously checks whether it is over the ISAE campus or not and also whether the power is ON or not
    		if(SC.checkPosition(latISAE, longISAE) && SC.getPower()) {
    			
    			// The satellite controller instructs the camera to take the picture
    			int dpiImage = SC.captureImage();
    			
    			// The satellite controller instructs the transmitter to the send the image
    			SC.transmitImage();
    			System.out.println("Image received at Ground Station\n");
    			
    			// An image quality check for minimum pixel size is performed at the ground station
    			if(dpiImage > dpiRef) {
            		System.out.println("The quality is good");
            		System.out.println("The image is saved\n");
            	}
    			else {
            		System.out.println("The quality is not good enough\n");
            	}
    			try {
            		Thread.sleep(1500);
            	}
            	catch(InterruptedException ex) {
            	}
    		}
    		
    		// Coordinates, time and power status are printed. Some post processing has been done here to make them look good
    		if(SC.getLatitude() > 0 && SC.getLongitude() >= 0) {
    			System.out.print("Satellite coordinates = " + Math.round(SC.getLatitude()*10.0)/10.0 + "°N " + SC.getLongitude() + "°E" );
    		}
    		else if(SC.getLatitude() > 0 && SC.getLongitude() < 0) {
    			System.out.print("Satellite coordinates = " + Math.round(SC.getLatitude()*10.0)/10.0 + "°N " + -1*SC.getLongitude() + "°W" );
    		}
    		else if(SC.getLatitude() < 0 && SC.getLongitude() > 0) {
    			System.out.print("Satellite coordinates = " + -1*Math.round(SC.getLatitude()*10.0)/10.0 + "°S " + SC.getLongitude() + "°E" );
    		}
    		else {
    			System.out.print("Satellite coordinates = " + Math.abs(Math.round(SC.getLatitude()*10.0)/10.0) + "°S " 
    					+ Math.abs(SC.getLongitude()) + "°W" );
    		}
    		System.out.print("		Timestamp = " + SC.getTime());
    		if(SC.getPower()) {
    			System.out.println("		Power = ON");
    		}
    		else {
    			System.out.println("		Power = OFF");
    		}
    	}
    	System.out.println("\nThe mission of the satellite has ended.\nAu revoir, bissou, bissou :(");
	}
}