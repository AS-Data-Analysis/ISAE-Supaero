package BasicExercises;

public class RoundingErrors {
	public double x;
	
	public double f(double x) {
		return Math.pow(x,2) - 2*x + 1.0;
	}
	public double g(int x) {
		return (x-1.0)*(x-1.0);
	}
	public void run() {
		this.x = 0.999;
	}
}