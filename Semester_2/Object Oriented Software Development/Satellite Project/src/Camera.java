import java.util.*;

public class Camera {

	
	// The camera takes the image when it receives the instructions from the satellite controller
    public int getImage() {
        System.out.println("\nPicture taken");
        
        // this random number generator is used to simulate image dpi. It generates a random integer between 250 and 350 dpi representing the quality of the image taken
        Random random = new Random();
        int dpiImage = random.nextInt(250,350);
        return dpiImage;
    }
}