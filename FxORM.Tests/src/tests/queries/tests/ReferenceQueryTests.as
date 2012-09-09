package tests.queries.tests {
import data.peopleAndCompanies.Company;
import data.peopleAndCompanies.Person;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertTrue;

import tests.queries.tests.BaseBusinessTests;

public class ReferenceQueryTests extends BaseBusinessTests {

    /**
     * person.name like
     */
    [Test]
    public function person_name_like_plain():void {
        createSimplePersons();
        cleanCache();
        var results:Array = FxORM.instance.entityManager.select(Person)
                .where("# like ?", ["name"], ["Joh%"])
                .query();
        assertEquals(results.length, 2);
    }
    /**
     * person.name like
     */
    [Test]
    public function person_name_like_orderBy():void {
        createSimplePersons();
        cleanCache();
        var results : Array = FxORM.instance.entityManager.select(Person)
                .where("# like ?", ["name"], ["J%"])
                .orderBy("name")
                .query();
        assertEquals(3, results.length);
        assertEquals("Jane", Person(results[0]).name);
        assertEquals("Johanna", Person(results[1]).name);
    }
    /**
     * person.name like
     */
    [Test]
    public function person_name_like_top():void {
        createSimplePersons();
        cleanCache();
        var results:Array = FxORM.instance.entityManager.select(Person)
                .where("# like ?", ["name"], ["J%"])
                .orderBy("name", true)
                .query(2);

        assertEquals(2, results.length);
        assertEquals("Jane", Person(results[0]).name);
        assertEquals("Johanna", Person(results[1]).name);
    }

    [Test]
    public function person_book_name_like_order_by_1():void {
        createSimplePersons();
        var results:Array = FxORM.instance.entityManager.select(Person)
                .where("# like ?", ["favouriteBook.name"], ["Harry Potter%"])
                .orderBy("name")
                .query();
        assertEquals(2, results.length);
        assertEquals("Alex", Person(results[0]).name);
        assertEquals("John", Person(results[1]).name);
    }

    // ordered by book name
    [Test]
    public function person_book_name_like_order_by_2():void {
        createSimplePersons();
        cleanCache();
        var results:Array = FxORM.instance.entityManager.select(Person)
                .where("# like ?", ["favouriteBook.name"], ["Harry Potter%"])
                .orderBy("favouriteBook.name", true)
                .query();
        assertEquals(2, results.length);
        assertEquals("John", Person(results[0]).name);
        assertEquals("Alex", Person(results[1]).name);
    }

    /**
     * should return a list of persons whose manager lives in the same city as them.
     * the result should be ordered by the city name
     * should return andrea (London), alex (Edinburgh), jon (Edinburgh)
     */
    [Test]
    public function person_manager_address_city_equals_person_city() : void {
        createPersonsMap();
        cleanCache();
        var results:Array = FxORM.instance.entityManager.select(Person)
                .where("#=#", ["manager.vault.city", "vault.city"])
                .orderBy("vault.city")
                .query();

        assertEquals(3, results.length);
        assertTrue(results[0].name == "Alex" && results[1].name, "Jon" || results[1].name == "Alex" && results[0].name, "Jon");
        assertEquals("Andrea", results[2].name);
    }

    /**
     * should return a list of persons whose manager lives in the same city as them, and whoes fav. book contains "Ha Ha" text.
     * the result should be ordered by the city name descending
     * should return andrea (London) and jon (Edinburgh)
     */
    [Test]
    public function person_manager_address_city_equals_person_city_and_fav_book_like() : void {
        createPersonsMap();
        cleanCache();
        var results:Array = FxORM.instance.entityManager.select(Person)
                .where("#=#", ["manager.vault.city", "vault.city"])
                .where("# like ?", ["favouriteBook.name"], ["%Ha Ha%"])
                .orderBy("vault.city", false)
                .query();

        assertEquals(2, results.length);
        assertEquals("Andrea", results[0].name);
        assertEquals("Jon", results[1].name);
    }

    /**
     * returns persons whose fav.book has the same name as a fav.book of manager of a htc company, ordered by their name:
     * Alex, Johanna, John, Jon
     */
    [Test]
    public function person_book_name_equals_company_manager_book_name() : void {
        createManagersAndCompaniesMap();
        cleanCache();
        var results:Array = FxORM.instance.entityManager.select(Person)
                .where("#=#", ["favouriteBook.name", new PropertyChain("manager.favouriteBook.name", Company)])
                .where("#=?", [new PropertyChain("name", Company)], ["htc"])
                .orderBy("name")
                .query();

        assertEquals(4, results.length);
        assertEquals("Alex", results[0].name);
        assertEquals("Johanna", results[1].name);
        assertEquals("John", results[2].name);
        assertEquals("Jon", results[3].name);
    }


    /**
     * returns persons whose fav.book has the same name as a fav.book of manager of a htc company, ordered by their name:
     * Alex, Johanna, John, Jon
     */
    [Test]
    public function person_book_name_equals_company_manager_book_name_paging() : void {
        createManagersAndCompaniesMap();
        cleanCache();
        var results:Array = FxORM.instance.entityManager.select(Person)
                .where("#=#", ["favouriteBook.name", new PropertyChain("manager.favouriteBook.name", Company)])
                .where("#=?", [new PropertyChain("name", Company)], ["htc"])
                .orderBy("name")
                .queryPage(1, 3);

        assertEquals(1, results.length);
        assertEquals("Jon", results[0].name);
    }

    [Test]
    public function person_manager_manager_address_city_equals_Edinburgh() : void {
        var john : Person = person("John").city("London").build(); // (Lon)
        var jane : Person = person("Jane").city("Edinburgh").build(); // (Edi)

        var johanna : Person = person("Johanna").city("London").manager(jane).build(); // (Lon) --> Edi
        var alex : Person = person("Alex").city("Edinburgh").manager(jane).build(); // (Edi) --> Edi
        var andrea : Person = person("Andrea").city("London").manager(john).build(); // (Lon) --> Lon

        var jon : Person = person("Jon").city("Edinburgh").manager(alex).build();// (Edi) --> Edi --> Edi
        var sarah : Person = person("Sarah").city("Glasgow").manager(jane).build();// (Gla)--> Edi
        var richard : Person = person("Richard").city("Manchester").manager(johanna).build(); // (Man)--> Lon --> Edi
        var natasha : Person = person("Natasha").city("Edinburgh").manager(andrea).build(); // (Edi) --> Lon --> Lon

        saveAll(john, jane, johanna, alex, andrea, jon, sarah, richard, natasha);

        cleanCache();

        var results:Array = FxORM.instance.entityManager.select(Person)
                .where("#=?", ["manager.manager.vault.city"], ["Edinburgh"])
                .orderBy("name", false)
                .query();

        assertEquals(2, results.length);
        assertEquals("Richard", results[0].name);
        assertEquals("Jon", results[1].name);

    }

    [Test]
    public function person_manager_manager_address_city_equals_person_city() : void {
        var john : Person = person("John").city("London").build(); // (Lon)
        var jane : Person = person("Jane").city("Edinburgh").build(); // (Edi)

        var johanna : Person = person("Johanna").city("London").manager(jane).build(); // (Lon) --> Edi
        var alex : Person = person("Alex").city("Edinburgh").manager(jane).build(); // (Edi) --> Edi
        var andrea : Person = person("Andrea").city("London").manager(john).build(); // (Lon) --> Lon

        var jon : Person = person("Jon").city("Edinburgh").manager(alex).build();// (Edi) --> Edi --> Edi
        var sarah : Person = person("Sarah").city("Glasgow").manager(jane).build();// (Gla)--> Edi
        var richard : Person = person("Richard").city("Manchester").manager(johanna).build(); // (Man)--> Lon --> Edi
        var natasha : Person = person("Natasha").city("London").manager(andrea).build(); // (Lon) --> Lon --> Lon

        saveAll(john, jane, johanna, alex, andrea, jon, sarah, richard, natasha);

        cleanCache();

        var results:Array = FxORM.instance.entityManager.select(Person)
                .where("#=#", ["manager.manager.vault.city","vault.city"])
                .orderBy("vault.city", false)
                .query();

        assertEquals(2, results.length);
        assertEquals("Natasha", results[0].name);
        assertEquals("Jon", results[1].name);

    }

    private function createPersonsMap() : void {
        createBooks(false);
        var john : Person = person("John").book(hahaBook1).city("London").build(); //{andrea:London, Ha Ha}
        var jane : Person = person("Jane").book(hahaBook2).city("Edinburgh").build(); //{johanna:London}, {alex: Edinburgh}, {jon: Edinburgh, Ha Ha}, {sarah: Glasgow}

        var johanna : Person = person("Johanna").book(harryPotter).city("London").manager(jane).build();
        var andrea : Person = person("Andrea").book(hahaBook3).city("London").manager(john).build();
        var alex : Person = person("Alex").book(harryPotter).city("Edinburgh").manager(jane).build();
        var jon : Person = person("Jon").book(hahaBook4).city("Edinburgh").manager(jane).build();
        var sarah : Person = person("Sarah").book(harryPotter).city("Glasgow").manager(jane).build();
        var richard : Person = person("Richard").book(harryPotter).city("Manchester").build();

        saveAll(john, jane, johanna, andrea, alex, jon, sarah, richard);
    }

    private function createManagersAndCompaniesMap() : void {
        createBooks(false);

        var john : Person = person("John").book(harryPotter).city("London").build(); //{andrea:London, Life Isn't All Ha Ha Hee Hee}
        var jane : Person = person("Jane").book(janeEyre).city("Edinburgh").build(); //{johanna:London}, {alex: Edinburgh, Harry Potter}, {jon: Edinburgh, Humphrey's Ha Ha Ha Joke Book}, {sarah: Glasgow}
        
        var samsung : Company = company("samsung", jane);
        var htc : Company = company("htc", john);//    --> harryPotter

        var johanna : Person = person("Johanna").book(harryPotter).build();
        var alex : Person = person("Alex").book(harryPotter).build();
        var jon : Person = person("Jon").book(harryPotter).build();

        var richard : Person = person("Richard").book(janeEyre).build();
        var andrea : Person = person("Andrea").book(janeEyre).build();

        var sarah : Person = person("Sarah").book(hahaBook2).build();

        saveAll(john, jane, johanna, andrea, alex, jon, sarah, richard, samsung, htc);
    }

    private function createSimplePersons():void {
        createBooks(false);
        person("John").book(harryPotter).build().save();
        person("Johanna").book(janeEyre).build().save();
        person("Jane").book(janeEyre).build().save();
        person("Alex").book(harryPotter2).build().save();
    }

    private function createPersonWithName(name : String):void {
        var person:Person = new Person();
        person.name = name;
        person.save();
    }
}
}
