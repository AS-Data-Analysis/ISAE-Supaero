import java.util.Arrays;

public class TestDice {
	
	static Die [] dice = new Die[3];
	
	public static void main(String[] args) {
		dice[0] = new Die();
		dice[1] = new Die();
		dice[2] = new Die();
		
		int [] rolls = {0,0,0};
		int [] value = {4,2,1};
		int counter = 0;
		do {
			counter++;
			for(int i=0;i<3;i++) {
				dice[i].roll();
				rolls[i] = dice[i].getFaceValue();
			}
		}while (!Arrays.equals(rolls, value));
		System.out.print("Win! after " + counter + " rolls");
	}
}
