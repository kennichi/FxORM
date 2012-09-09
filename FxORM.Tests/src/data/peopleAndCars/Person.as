package data.peopleAndCars {
import mx.collections.ArrayCollection;

[Table("persons")]
public class Person extends PersistentObject {
    private var _garage:Garage;
    private var _friends:ArrayCollection;

    [Column(name="garage", isReference=true, isCascade=true)]
    public function get garage():Garage {
        if (!_garage) _garage = getReference("garage") as Garage;
        return _garage;
    }

    public function set garage(value:Garage):void {
        _garage = value;
        setReference("garage", value)
    }

    [Column(name="friends", isCollection=true, collectionItemType="data.peopleAndCars.Person", isCascade=true)]
    public function get friends():ArrayCollection {
        if (!_friends) _friends = getCollection("friends", false);
        return _friends;
    }

    public function set friends(value:ArrayCollection):void {
        _friends = value;
        setCollection("friends", value);
    }
}
}
