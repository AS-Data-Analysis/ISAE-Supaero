
public class Circle extends Shape {

    public Circle(double xpos, double ypos, double radius) {
    	super(xpos, ypos);
    	this.radius = radius;
    }

    public double radius;

    public double getRadius() {
		return radius;
	}

	public void setRadius(double radius) {
		this.radius = radius;
	}

    public double perimeter() {
        return 2*Math.PI*this.radius;
    }

    public double area() {
        return Math.PI*this.radius*this.radius;
    }
}