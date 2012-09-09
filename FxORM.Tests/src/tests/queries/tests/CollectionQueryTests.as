package tests.queries.tests {
import data.peopleAndCompanies.Book;
import data.peopleAndCompanies.Person;

import org.flexunit.asserts.assertEquals;

public class CollectionQueryTests extends BaseBusinessTests {
    [Test]
    public function book_authors_name_like() : void {
        createBooks(true)
        saveAll.apply(this, books);

        cleanCache();

        var results:Array = FxORM.instance.entityManager.select(Book)
                .where("# like ?", ["authors.name"], ["%Bronte%"])
                .orderBy("name")
                .query();

        assertEquals(5, results.length);
        assertEquals(agnesGrey.name, results[0].name);
        assertEquals(janeEyre.name, results[1].name);
        assertEquals(theTenantOfWildfellHall.name, results[2].name);
        assertEquals(theWorksOfBronteFamily.name, results[3].name);
        assertEquals(wutheringHeights.name, results[4].name);
    }

    /**
     * all books who have author which has friends who like this book.
     */
    [Test]
    public function book_authors_friends_book_same() : void {
        createBooks(true);

        var john_harryPotter:Person = person("A").book(harryPotter).build();
        var jack_harryPotter:Person = person("B").book(harryPotter).build();
        var josh_harryPotter:Person = person("C").book(harryPotter).build();
        var matt_harryPotter:Person = person("D").book(harryPotter).build();

        var lucy_janeEyre:Person = person("E").book(janeEyre).build();
        var jane_janyEyre:Person = person("F").book(janeEyre).build();
        var linda_wildfellHall:Person = person("G").book(theTenantOfWildfellHall).build();
        var janet_wildfellHall:Person = person("H").book(theTenantOfWildfellHall).build();

        rowling.friends.addItem(john_harryPotter);
        rowling.friends.addItem(lucy_janeEyre);

        anneBronte.friends.addItem(rowling);
        anneBronte.friends.addItem(charlotteBronte);
        anneBronte.friends.addItem(humphryWard);
        anneBronte.friends.addItem(emilyBronte);
        anneBronte.friends.addItem(linda_wildfellHall);

        saveAll(john_harryPotter, jack_harryPotter, josh_harryPotter, matt_harryPotter, lucy_janeEyre, jane_janyEyre, linda_wildfellHall, janet_wildfellHall);

        cleanCache();

        var results:Array = FxORM.instance.entityManager.select(Book)
                .where("#=#", ["authors.friends.favouriteBook", new PropertyChain(null, Book)])
                .orderBy("name")
                .query();

        assertEquals(2, results.length);
        assertEquals(harryPotter.name, results[0].name);
        assertEquals(theTenantOfWildfellHall.name, results[1].name);
    }
}
}
