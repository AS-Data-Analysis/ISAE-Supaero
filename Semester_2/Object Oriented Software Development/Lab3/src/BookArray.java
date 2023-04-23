/*
 * The program manages a toy bookstore (3 titles only).
 * The program contains a bug.
 *
 */


public class BookArray {
    
    static Book [] books = new Book[3]; // toy bookstore with only three titles!
    
    public static void main(String[] args) {
    	
    	books[0] = new Book();
    	books[1] = new Book();
    	books[2] = new Book();

        //books[0].author.name = "Verne";
        books[0].author.firstName = "Jules";
        books[0].title = "Le tour du monde en 80 jours";
        books[1].author.name = "Coelho";
        books[1].author.firstName = "Paulo";
        books[1].title = "O Alquimista";
        books[2].author.name = "Roy";
        books[2].author.firstName = "Gabrielle";
        books[2].title = "Bonheur d'Occasion";
        for (int i=0; i<books.length; i++)
            System.out.println(books[i].title + " ( " +
            books[i].author.firstName + " " + books[i].author.name + " ) ");
    }
}