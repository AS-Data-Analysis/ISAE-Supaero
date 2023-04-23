import java.time.Duration;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.format.FormatStyle;
import java.util.Locale;

public class SatelliteController {

	// Satellite parameters are declared
	private double[] position = new double[2];						
	// This parameters hold both the values of the latitude and the longitude. Hence, there will be two getter functions associated to it.
    private boolean power;
    private int time;

    // The satellite controller commands both the camera and the transmitter through these objects.
    private Camera camera = new Camera();
	private Transmitter transmitter = new Transmitter();

	// This method checks the satellite current location against the location of ISAE-SUPAERO. 
	// It returns a true value when the satellite is less than 2 degrees of latitude and longitude above the campus.
    public boolean checkPosition(double latISAE,double longISAE) {
    	if(Math.abs(this.position[0] - latISAE) <= 2.0 && Math.abs(this.position[1] - longISAE) <= 2.0) {
    		return true;
    	}
    	else {
    		return false;
    	}
    }

    // getter function for the latitude
    public double getLatitude() {
        return position[0];
    }
    // getter function for the longitude
    public double getLongitude() {
    	return position[1];
    }

    // This method serves as the GPS of the satellite which updates the coordinates of the satellite. 
    // A similar time delay of 10 milliseconds has been introduced to control the speed of the simulation.
    public void setPosition(Instant orbitLife, double latInitial, double longInitial) {
    	Duration duration = Duration.between(orbitLife, Instant.now());
    	long c = duration.toNanos()/1000;
    	int a = (int)c;
    	if(a == 0 | this.time == 0) {
    		this.position[0] = latInitial;			// When the satellite commences its orbit the coordinates are set to their initial values
    		this.position[1] = longInitial;
    	}
    	else {
    		try {
        		Thread.sleep(10);
        	}
        	catch(InterruptedException ex) {
        	}
    		this.position[1] += 4.0;           										// Longitude updated by 4 degrees to imitate orbit
    		this.position[0] = 45*Math.cos(this.position[1]*Math.PI/180);         	// Latitude updated as a function of the longitude
    	}
    }

    // getter function for power status (i.e. solar panels on/off)
    public boolean getPower() {
    	return power;
    }

    // the power is assumed to be OFF for every 15 minutes in the 90 minute orbit of the satellite. 
    // This period is when the satellite is in the shadow and the solar panels receive no power from the sun.
    public void setPower() {
    	if(this.time < 75) {
    		this.power = true;
    	}
    	else {
    		this.power = false;
    	}
    }

    // This method returns the current time-stamp in a specified format.
    public String getTime() {
    	DateTimeFormatter formatter = DateTimeFormatter.ofLocalizedDateTime( FormatStyle.FULL )
                .withLocale( Locale.FRENCH )
                .withZone( ZoneId.systemDefault() );
    	Instant instant = Instant.now();
        String instantStr = formatter.format(instant);
        return instantStr;
    }

    // A timer tracks the orbit time of the satellite. It goes till 90 and is reset when the satellite completes an orbit. 
    // It is used to determine the power status.
    public void setTime() {
        if(this.time >= 90) {
        	this.time = 0;
        }
        else {
        	this.time++;
        }
    }

    // Command to the camera to take an image
    public int captureImage() {
    	return camera.getImage();
    }
    // Command to the transmitter to send the captured image
    public void transmitImage() {
    	transmitter.sendImage();
    }
}