public class TestRandom {
    public static void main(String[] args) {
        double r; // random number
        r = Math.random();
        System.out.println(r);
        int percent = (int) (r * 100); // casting
        System.out.println(percent);
    }
}