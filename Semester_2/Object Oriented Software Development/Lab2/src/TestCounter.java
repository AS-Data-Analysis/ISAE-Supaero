/*
 * @author p.de-saqui-sannes@isae-supaero.fr
 * @date March 1, 2017
 * @version 1
 */
public class TestCounter {

	public static void main(String[] args) {
		Counter counter = new Counter();
		System.out.println("counter = " + counter.getValue());
		counter.increase(1);
		System.out.println("counter = " + counter.getValue());
		counter.decrease(10);
		System.out.println("counter = " + counter.getValue());
	}
}