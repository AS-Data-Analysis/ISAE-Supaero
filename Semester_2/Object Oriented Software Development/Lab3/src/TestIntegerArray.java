public class TestIntegerArray {

    public static void main(String[] args) {
        
        // Temperatures on seven days
        int [] temperatures = {10, 12, 8, 9, 7, 12, 13};
        
        System.out.println("Lowest temperature on seven days: " + (IntegerArray.minimumInArray(temperatures)));
        System.out.println("Highest temperature on seven days: " + (IntegerArray.maximumInArray(temperatures)));
        System.out.println("Average temperature on seven days: " + (IntegerArray.averageInArray(temperatures)));
    }

}