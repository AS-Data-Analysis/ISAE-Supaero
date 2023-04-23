public class MissionControl {

    public static void main(String[] args) {
    	GroundStation GS = new GroundStation();
    	
    	
    	// Datasheet of parameters related to the rocket launch and the satellite
    	
    	final double totalRocketMass = 1.5*1E+5;						// Total mass of the rocket
    	final double initialFuelMass = 0.8*totalRocketMass;				// Mass of the fuel = 80% of the total rocket mass
    	final double initialRocketMass = 0.1*totalRocketMass;			// Mass of the empty rocket = 10% of the total rocket mass
    	final double fuelBurnRate = 140.0;								// Rate at which fuel is consumed
    	final double hLEO = 7.5*1E+5;									// Altitude of the satellite orbit to be reached
    	final double fuelRatio = 0.5;				// Fuel ratio = mass of fuel after engine separation/mass of fuel before engine separation
    	
    	final int dpiRef = 300;						// The minimum number of pixels (dots per inch) that the received image should have
    	final double latISAE = 43.5655;				// ISAE campus latitude
    	final double longISAE = 1.4740;				// ISAE campus longitude
    	final double longInitial = -180.0;			// Initial longitude where the satellite starts its orbit from
    	final double latInitial = 45*Math.cos(longInitial*Math.PI/180.0);				
    	// Inital latitude where the satellite commences its operations from. 
    	//The latitudes of orbit are a cosine curve depending on the longitudes.
    	
    	// Ground Station sends the command to start the rocket launch with all the necessary parameters
    	GS.Launch(initialFuelMass, initialRocketMass, fuelBurnRate, hLEO, fuelRatio);
    	
    	// Once the satellite reaches the orbit, satellite operations begin.
    	// The Operations include tracking coordinates, taking and transmitting images of ISAE campus.
    	GS.SatelliteOperations(dpiRef, latISAE, longISAE, latInitial, longInitial);																																					
    }
    
}