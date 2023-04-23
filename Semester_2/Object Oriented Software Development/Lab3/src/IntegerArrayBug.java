/*
 * The program randomly attributes values to the elements
 * of an integer array and displays the values of the array elements.
 * The program contains bugs to be fixed by the students.
 * 
 * @author pierre.de-saqui-sannes@isae-supaero.fr
 * @version 3
 * February 28, 2020
 * 
 */
public class IntegerArrayBug {

    final static int MAX = 6;
    static int [] numbers = new int [20];
    
    public static void main(String[] args) {

        // Randomly fills the array
        for (int index=1; index<numbers.length; index++)
            numbers[index] = (int) (MAX * Math.random()) + 1;
        
        // displays the content of the array
        for (int index=0; index<numbers.length; index++)
            System.out.println(numbers[index]);
    }
}