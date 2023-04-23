
public abstract class Shape {

    public Shape(double xpos, double ypos) {
    	super();
    	this.xPos = xpos;
    	this.yPos = ypos;
    }

    protected double xPos;
    protected double yPos;

    public abstract double perimeter();

    public double getxPos() {
		return xPos;
	}

	public void setxPos(double xPos) {
		this.xPos = xPos;
	}

	public double getyPos() {
		return yPos;
	}

	public void setyPos(double yPos) {
		this.yPos = yPos;
	}

    public abstract double area();
}