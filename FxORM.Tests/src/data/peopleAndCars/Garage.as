package data.peopleAndCars {
import mx.collections.ArrayCollection;

[Table("garages")]
public class Garage extends PersistentObject {
    private var _cars:ArrayCollection;

    [Column(name="cars", isCollection=true, collectionItemType="data.peopleAndCars.Car", isCascade=true)]
    public function get cars():ArrayCollection {
        if (!_cars) _cars = getCollection("cars", false);
        return _cars;
    }

    public function set cars(value:ArrayCollection):void {
        _cars = value;
        setCollection("cars", value);
    }
}
}
