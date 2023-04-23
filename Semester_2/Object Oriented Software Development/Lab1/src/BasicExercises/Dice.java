public class Dice {
	protected double number;
	
	public void RollDice() {
		this.number = Math.floor(6*Math.random()+1);
		System.out.println(number);
	}
	public void Roll_k_Dice(int k) {
		for(int i=1;i<=k;i++) {
			this.number = Math.floor(6*Math.random()+1);
			System.out.println(number);
		}
	}
}