package data.peopleAndCompanies {
import mx.collections.ArrayCollection;

[Table("person")]
[Bindable]
public class Person extends PersistentObject {
    private var _manager : Person;
    private var _vault : Address;
    private var _favouriteBook : Book;
    private var _company : Company;
    private var _friends : ArrayCollection;

    [Column]
    public var name : String;

    [Column(isReference=true)]
    public function get manager():Person
    {
        if (!_manager)
            _manager = getReference("manager") as Person;
        return _manager;
    }

    public function set manager(value:Person):void
    {
        _manager = value;
        setReference("manager", value);
    }

    [Column(isReference=true)]
    public function get favouriteBook():Book
    {
        if (!_favouriteBook)
            _favouriteBook = getReference("favouriteBook") as Book;
        return _favouriteBook;
    }

    public function set favouriteBook(value:Book):void
    {
        _favouriteBook = value;
        setReference("favouriteBook", value);
    }


    [Column(isReference=true)]
    public function get vault():Address
    {
        if (!_vault)
            _vault = getReference("vault") as Address;
        return _vault;
    }

    public function set vault(value:Address):void
    {
        _vault = value;
        setReference("vault", value);
    }

    [Column(isReference=true)]
    public function get company():Company
    {
        if (!_company)
            _company = getReference("company") as Company;
        return _company;
    }

    public function set company(value:Company):void
    {
        _company = value;
        setReference("company", value);
    }

    [Column(isCollection=true, collectionItemType="data.peopleAndCompanies.Person")]
    public function get friends():ArrayCollection
    {
        if (!_friends) _friends = getCollection("friends", false);
        return _friends;

    }

    public function set friends(value:ArrayCollection):void
    {
        _friends = value;
        setCollection("friends", value);
    }
}
}
