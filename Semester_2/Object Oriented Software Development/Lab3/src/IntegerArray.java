
public class IntegerArray {
	public static int minimumInArray(int nums[]) {
		int min = nums[0];
		for(int i=0;i<nums.length;i++) {
			if(nums[i]<min)
				min = nums[i];
		}
		return min;
	}
	public static int maximumInArray(int nums[]) {
		int max = nums[0];
		for(int i=0;i<nums.length;i++) {
			if(nums[i]>max)
				max = nums[i];
		}
		return max;
	}
	public static int averageInArray(int nums[]) {
		int sum=0;
		for(int i=0;i<nums.length;i++) {
			sum += nums[i];
		}
		return sum/nums.length;
	}
}
