package data.peopleAndCompanies {

import mx.collections.ArrayCollection;

[Table("book")]
[Bindable]
public class Book extends PersistentObject {
    private var _authors : ArrayCollection;

    [Column]
    public var name : String;

    [Column(name="authors", isCollection=true, collectionItemType="data.peopleAndCompanies.Person")]
    public function get authors():ArrayCollection
    {
        if (!_authors) _authors = getCollection("authors", false);
        return _authors;

    }

    public function set authors(value:ArrayCollection):void
    {
        _authors = value;
        setCollection("authors", value);
    }
}
}
