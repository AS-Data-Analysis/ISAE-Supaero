public class Counter {

	/** 
	 * A counter using an integer value.
	 * @author pierre.de-saqui-sannes@isae-supaero.fr
	 * @version 3
	 * February 26, 2018
	 */
	
	/** The only characteristics of the counter we are interested in is its value.
	 * @param value denotes the current value of the counter
	 */
	private int value;

	/** Create a counter with zero as initial value 
	 */
	public Counter(){
		this.value = 0;
	}
	
	/** Create a counter with a an initial value that is not necessarily 0
	 * @param intialValue initial value of the counter
	 */
	public Counter(int intialValue){
		this.value = intialValue;
	}
	
	/** Get current value of the counter
	 * @return current value of the counter
	 */
	public int getValue(){
		return this.value;
	}
	
	/** Assign a value to the counter
	 * @param val the value to be assigned to the counter
	 */
	public void setValue(int val){
		this.value = val;
	}
	
	/** Increase the value of the counter
	 * @param step the value to be added to the counter
	 */
	public void increase(int step){
		this.value += step;
	}
	
	/** Decrease the value of the counter
	 * @param step the value to be removed from the counter
	 */
	public void decrease(int step){
		this.value -= step;
	}
	
}