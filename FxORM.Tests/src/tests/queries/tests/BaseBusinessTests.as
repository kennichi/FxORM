package tests.queries.tests {
import data.peopleAndCompanies.Book;
import data.peopleAndCompanies.Company;
import data.peopleAndCompanies.Person;

import tests.BaseTest;

public class BaseBusinessTests extends BaseTest {

    private static const HARRY_POTTER:String = "Harry Potter";
    private static const HARRY_POTTER__THE_GOBLET_OF_FIRE:String = "Harry Potter: the Goblet of Fire";
    private static const LIFE_ISN_T_ALL_HA_HA_HEE_HEE:String = "Life Isn't All Ha Ha Hee Hee";
    private static const THE_HA_HA_BONK_BOOK:String = "The Ha Ha Bonk Book";
    private static const PADDY_CLARKE_HA_HA_HA:String = "Paddy Clarke Ha Ha Ha";
    private static const HUMPHREY_S_HA_HA_HA_JOKE_BOOK:String = "Humphrey's Ha Ha Ha Joke Book";
    private static const JANE_EYRE:String = "Jane Eyre";
    private static const WUTHERING_HEIGHTS:String = "Wuthering Heights";
    private static const THE_TENANT_OF_WILDFELL_HALL:String = "The Tenant of Wildfell Hall";
    private static const AGNES_GREY:String = "Agnes Grey";
    private static const THE_WORKS_OF_THE_BRONTE_FAMILY:String = "The Works of the Bronte Family";

    protected function person(name : String) : PersonBuilder {
        return new PersonBuilder(name);
    }

    protected function book(name : String, ...authors) : Book {
        var book : Book = new Book();
        book.name = name;
        for each (var author : Person in authors) {
            book.authors.addItem(author);
        }
        return book;
    }

    protected function company(name : String, manager : Person) : Company {
        var company : Company = new Company();
        company.name = name;
        company.manager = manager;
        return company;
    }

    protected function createBooks(setAuthors : Boolean):void {
        if (setAuthors) {
            rowling = person("J.K. Rowling").build();
            someGuy = person("Some Guy").build();
            charlotteBronte = person("Charlotte Bronte").build();
            emilyBronte = person("Emily Bronte").build();
            anneBronte = person("Anne Bronte").build();
            humphryWard = person("Humphry Ward").build();
        }

        harryPotter = setAuthors ? book(HARRY_POTTER, rowling) : book(HARRY_POTTER);
        harryPotter2 = setAuthors ? book(HARRY_POTTER__THE_GOBLET_OF_FIRE, rowling) : book(HARRY_POTTER__THE_GOBLET_OF_FIRE);
        hahaBook1 = setAuthors ? book(LIFE_ISN_T_ALL_HA_HA_HEE_HEE, someGuy) : book(LIFE_ISN_T_ALL_HA_HA_HEE_HEE);
        hahaBook2 = setAuthors ? book(THE_HA_HA_BONK_BOOK, someGuy) : book(THE_HA_HA_BONK_BOOK);
        hahaBook3 = setAuthors ? book(PADDY_CLARKE_HA_HA_HA, someGuy) : book(PADDY_CLARKE_HA_HA_HA);
        hahaBook4 = setAuthors ? book(HUMPHREY_S_HA_HA_HA_JOKE_BOOK, someGuy) : book(HUMPHREY_S_HA_HA_HA_JOKE_BOOK);
        janeEyre = setAuthors ? book(JANE_EYRE, charlotteBronte) : book(JANE_EYRE);
        wutheringHeights = setAuthors ? book(WUTHERING_HEIGHTS, emilyBronte) : book(WUTHERING_HEIGHTS);
        theTenantOfWildfellHall = setAuthors ? book(THE_TENANT_OF_WILDFELL_HALL, anneBronte, humphryWard) : book(THE_TENANT_OF_WILDFELL_HALL);
        agnesGrey = setAuthors ? book(AGNES_GREY, anneBronte) : book(AGNES_GREY);
        theWorksOfBronteFamily = setAuthors ? book(THE_WORKS_OF_THE_BRONTE_FAMILY, anneBronte, charlotteBronte, emilyBronte, humphryWard) : book(THE_WORKS_OF_THE_BRONTE_FAMILY);
    }

    protected function get books() : Array {
        return [harryPotter, harryPotter2, hahaBook1, hahaBook2, hahaBook3, hahaBook4, janeEyre, wutheringHeights, theTenantOfWildfellHall, agnesGrey, theWorksOfBronteFamily];
    }

    protected var harryPotter : Book;
    protected var harryPotter2 : Book;
    protected var hahaBook1 : Book;
    protected var hahaBook2 : Book;
    protected var hahaBook3 : Book;
    protected var hahaBook4 : Book;
    protected var janeEyre : Book;
    protected var wutheringHeights : Book;
    protected var theTenantOfWildfellHall  : Book;
    protected var agnesGrey : Book;
    protected var theWorksOfBronteFamily : Book;

    protected var rowling : Person;
    protected var someGuy : Person;
    protected var charlotteBronte : Person;
    protected var emilyBronte : Person;
    protected var anneBronte : Person;
    protected var humphryWard : Person;
}
}

import data.peopleAndCompanies.Address;
import data.peopleAndCompanies.Book;
import data.peopleAndCompanies.Person;


class PersonBuilder {
    private var person : Person;
    public function PersonBuilder(name : String) {
        person = new Person();
        person.name = name;
    }

    public function book(book : Book) : PersonBuilder {
        person.favouriteBook = book;
        return this;
    }

    public function city(name : String) : PersonBuilder {
        var address : Address = new Address();
        address.city = name;
        person.vault = address;
        return this;
    }

    public function manager(manager : Person) : PersonBuilder {
        person.manager = manager;
        return this;
    }

    public function build() : Person {
        return person;
    }
}

