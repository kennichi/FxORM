package data.peopleAndCompanies {

[Table("address")]
[Bindable]
public class Address extends PersistentObject{
    [Column]
    public var city : String;
}
}
