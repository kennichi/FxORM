package data.peopleAndCompanies {
import interfaces.IDuplicatedReference;

[Table("company")]
[Bindable]
public class Company extends PersistentObject implements IDuplicatedReference{
    private var _address : Address;
    private var _manager : Person;



    [Column]
    public var name : String;
    private var _beId : String;

    [Column(isReference=true)]
    public function get address():Address
    {
        if (!_address)
            _address = getReference("address") as Address;
        return _address;
    }

    public function set address(value:Address):void
    {
        _address = value;
        setReference("address", value);
    }

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

    public function get idField():* {
        return _beId;
    }

    public function set idField(v:*):void {
        _beId = v;
    }
}
}
