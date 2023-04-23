
public class TestShape {
	
	public static void main(String args[]) {
		//Rectangle test
		
		Shape rect = new Rectangle(1,1,2,4);
		
		System.out.println("Rectangle details");
		System.out.println("XPOS: " + rect.getxPos());
		System.out.println("YPOS: " + rect.getyPos());
		System.out.println("Perimeter: " + rect.perimeter());
		System.out.println("Area: " + rect.area() + "\n");
		
		//Circle test
		
		Shape cir = new Circle(4,5,2);
		
		System.out.println("Circle details");
		System.out.println("XPOS: " + cir.getxPos());
		System.out.println("YPOS: " + cir.getyPos());
		System.out.println("Perimeter: " + cir.perimeter());
		System.out.println("Area: " + cir.area());
		
	}
}
