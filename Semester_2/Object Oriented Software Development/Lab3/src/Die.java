public class Die {

	/** Die models a &quot;normal&quot; die (not a &quot;loaded&quot; one).
	 * @author p&#105;&#101;&#114;&#114;&#101;&#46;&#100;&#101;-&#115;a&#113;&#117;&#105;&#45;&#115;&#97;&#110;n&#101;&#115;&#64;&#105;&#115;&#97;e-&#115;&#117;&#112;&#97;&#101;&#114;&#111;.fr
	 * @version 3
	 * February 26, 2018
	 */
	
	/** The only characteristics of the die we are interested in is its face value
	 * @param faceValue the value that appears on the top face of the dice
	 */
	private int faceValue;
	
	/** Create a die with an initial value being randomly chosen
	 */
	public Die(){
		this.faceValue=(int)(Math.random()*6+1);
	}
	
	/** Get the current face value of the die
	 * @return upper face of the die
	 */
	public int getFaceValue(){
		return(this.faceValue);
	}
	
	/** Give the die a new value
	 */
	public void roll (){
		this.faceValue = (int)(Math.random()*6+1);
	}
	
}