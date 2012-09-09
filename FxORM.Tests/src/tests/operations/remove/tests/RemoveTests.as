package tests.operations.remove.tests {
import cache.CacheManager;

import data.peopleAndCars.Car;
import data.peopleAndCars.Garage;
import data.peopleAndCars.Person;

import mx.collections.ArrayCollection;

import org.flexunit.asserts.assertEquals;

import tests.BaseTest;

public class RemoveTests extends BaseTest {

    private var cars : Array = [new Car(), new Car(), new Car(), new Car(), new Car()];
    private var garage1 : Garage;
    private var garage2 : Garage;
    private var mainPerson : Person;
    private var friend : Person;

    [Test]
    public function testCascadeRemoveCollection() : void {
        setUp();
        // garage1 references 3 cars out of 5.
        garage1.remove();
        CacheManager.instance.reset();
        var allCarsFromDB:Array = FxORM.instance.entityManager.findAll(Car);
        assertEquals(2, allCarsFromDB.length);
    }

    [Test]
    public function testCascadeRemoveProperty() : void {
        setUp();
        CacheManager.instance.reset();
        friend.remove();
        CacheManager.instance.reset();
        assertEquals(1, FxORM.instance.entityManager.findAll(Garage).length);
    }

    [Test]
    public function testCascadeRemoveCascadePropertyWithCascadeCollection() : void {
        setUp();
        CacheManager.instance.reset();
        friend.remove();
        CacheManager.instance.reset();
        var allCarsFromDB:Array = FxORM.instance.entityManager.findAll(Car);
        assertEquals(3, allCarsFromDB.length);
    }

    [Test]
    public function testCascadePropertyOfItemOfCascadeCollection() : void {
        setUp();
        CacheManager.instance.reset();
        mainPerson.remove();
        CacheManager.instance.reset();

        var allGarages:Array = FxORM.instance.entityManager.findAll(Garage);
        var allPersons:Array = FxORM.instance.entityManager.findAll(Person);
        var allCars:Array = FxORM.instance.entityManager.findAll(Car);

        assertEquals(0, allGarages.length)
        assertEquals(0, allPersons.length)
        assertEquals(0, allCars.length)
    }

    private function setUp():void {
        garage1 = new Garage();
        garage2 = new Garage();
        garage1.cars = new ArrayCollection([cars[0], cars[1], cars[2]]);
        garage2.cars = new ArrayCollection([cars[3], cars[4]]);
        friend = new Person();
        friend.garage = garage2;
        mainPerson = new Person();
        mainPerson.garage = garage1;
        mainPerson.friends = new ArrayCollection([friend, new Person()]);

        mainPerson.save();

        CacheManager.instance.reset();

        var allGarages:Array = FxORM.instance.entityManager.findAll(Garage);
        var allPersons:Array = FxORM.instance.entityManager.findAll(Person);
        var allCars:Array = FxORM.instance.entityManager.findAll(Car);

        assertEquals(2, allGarages.length)
        assertEquals(3, allPersons.length)
        assertEquals(5, allCars.length)
    }
}
}


