public class Book {
    String title;
    Person author = new Person();
    public Book(){
        this.title = " ";
        author.name = "Elise";
        System.out.println(author.getName());
        
    }
}