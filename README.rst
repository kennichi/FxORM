============
FxORM
============

FxORM is a simple Object Relational Mapping (ORM) framework for Air and Flex Mobile applications which works with SQLite databases.

It allows the following features:
 * Allows to configure classes to be stored in the SQLite using metadata tags (annotations), and writing simple getter/setter functions following the same pattern.
 * Generates schema for the database based on the metadata tags (annotations) on your classes. Maps new columns when you add new property/field mappings.
 * Supports references to other objects and collections of other objects of the same type
 * Provides caching
 * Supports unifying objects from backend by their backend id field.
 * Provides an easy querying mechanism.
 * Supports logging.
 * Allows sharing same data objects in both Flex and Air applications (by sharing the base core-swc)

Example of Mapped Object
-----------------------------------------------

.. code-block:: as3

 [Table("persons")]
 public class Person extends PersistentObject {
     private var _friends:ArrayCollection;

     [Column]
     public var firstName : String;
     [Column]
     public var lastName : String;
     [Column]
     public var birthDay : Date;

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


FxORM.Base and FxORM.SQL Libraries
-----------------------------------------------

As you will see later, the client classes which need to be mapped to the database need to implement **IPersistentObject**. The easiest way
to do this is to extend **PersistentObject**

Very often developers need to write 2 instances of applications which generally do the same thing but differ in that the one of them
must be an offline version of the online application.
One of the approaches for writing such applications is to extract common code into a separate library and re-use it from both applications.
Generally, developers would want to reuse the data classes in both online and offline applications by putting them to this library.
This can be accomplished by adding a reference to **FxORM.Base** library to the library with data classes. **FxORM.Base** contains **IPersistentObject**, and does not use libraries
available only for Air applications. Therefore, **FxORM.Base** can be referenced from both Flex and Air applications.

This project contains two libraries:

* **FxORM.Base**, and
* **FxORM.SQL**.

You will need to reference **FxORM.Base** in the library which defines classes which have to be mapped to the database.
You will need to reference **FxORM.SQL** in the AIR project.

Getting started
---------------

1. Adding Dependencies
#############################

Add the following dependencies:

 * Add a dependency to the **FxORM.Base** to the projects where you declare classes which you intend to eventually store in the database.
 * Add dependency to the **FxORM.SQL** to the Air project.


2. Setting Up
####################

In the Air project add **preinitialize** event handler:

.. code-block:: mxml

 <s:WindowedApplication xmlns:fx="http://ns.adobe.com/mxml/2009"
 					   xmlns:s="library://ns.adobe.com/flex/spark"
 					   xmlns:mx="library://ns.adobe.com/flex/mx"
 					   preinitialize="setUpFxORM()">

 	<fx:Script>
 		<![CDATA[
 			import EntityManager;
 			import FxORM;

            private function setUpFxORM() : void
            {
 			    FxORM.instance.entityManager = new EntityManager();
 			    var dbFile : File = File.applicationStorageDirectory.resolvePath( "my_database.db" );
 			    var sqlConnection = new SQLConnection();
 			    sqlConnection.open( dbFile );
 			    FxORM.instance.entityManager.sqlConnection = sqlConnection;
            }

 		]]>
	</fx:Script>

	<!-- ... -->

 </s:WindowedApplication>

The file *my_database.db* you specified here does not need to exist on your harddrive. FxORM generates schema for the database when you start using it. It will update tables with new columns when you map new properties.


3. Implementing IPersistentObject
##########################################################################################

Make all classes which need to be stored in the database extend **IPersistentObject**.

The easiest way to do this is to extend PersistentObject class.
But you can add your own implementation of the interface if you want.
See how_to_implement_ipersistenobject_:

4.[Table] metadata
############################################################

For each class which needs to be stored in the database add **[Bindable]** metadata tag (optional), and **[Table]** metadata tag with the
name of the database table where you want to store instances of this class:

.. code-block:: as3

 [Table("persons")]
 [Bindable]
 public class Person extends IPersistentObject

**************************
Inheritance
**************************

There is a special case, when you have a parent-child hierarchy like **Animal-Dog**, you need to put **[Table("animals")]** metadata tag only on **Animal** (base) class.
All types from a single hierarchy are stored in the same database table.

5. Columns
############################

All properties which need to be saved to the database, need to be marked with **[Column]** metadata tag. **[Column]** metadata has an optional parameter name which defines the name of the column in which property will be stored.

************************************************************
Primitive properties/fields
************************************************************

By **primitive** we mean properties which can be stored in a single cell of a database table.

You have two choices of enabling primitive properties to be mapped to the database:

 * Make them **Bindable** (simply by either adding **[Bindable]** to the fields/properties, or by marking the owner class with **[Bindable]** metadata tag.
 * Define getter and setter for the field and call **setPrimitiveValue** in the setter.

Here is an example of these approaches:

.. code-block:: as3

 [Bindable]
 [Column]
 public var endDate : Date;



.. code-block:: as3

 [Column(name="myStringColumnName")]
 public function get myString():String
 {
    return _myString;
 }

 public function set myString(value:String):void
 {
     _myString = value;
     setPrimitiveValue("myString", value);
 }

************************************************************
Reference properties
************************************************************

By **reference properties** we mean properties which reference other **IPersistentObject** instances (other instances which need to be mapped to the database).

In order to map such properties to the database, you need to wrap them in getter and setter functions, marked with **[Column(isReference=true)]** metadata tag, and a call **setReference** from the setter:

.. code-block:: as3

 [Column(name="reference", isReference=true, lazyLoad=true)]
 public function get reference() : MyReferenceObject
 {
     if (!_reference) _reference = getReference("reference") as MyReferenceObject;
     return _reference;
 }

 public function set reference(value : MyReferenceObject):void
 {
     _reference = value;
     setReference("reference", value)
 }


************************************************************
Collection properties
************************************************************

By **collection properties** we mean properties which are ArrayCollections of **IPersistentObject** instances (other instances which need to be mapped to the database), of the same type.

In order to map such properties to the database, you need to wrap them in getter and setter functions,
marked with **[Column(isCollection=true, collectionItemType="*full class name of items references by this collection*")]** metadata tag,
and a call **setCollection** from the setter:

.. code-block:: as3

 [Column(name="referenceObjectsCollection", isCollection=true, collectionItemType="data.MyReferenceObject")]
 public function get referenceObjectsCollection():ArrayCollection
 {
     if (!_referenceObjectsCollection) _referenceObjectsCollection = getCollection("referenceObjectsCollection", false);
     return _referenceObjectsCollection;
 }

 public function set referenceObjectsCollection(value:ArrayCollection):void
 {
     _referenceObjectsCollection = value;
     setCollection("referenceObjectsCollection", value);
 }


************************************************************
Collection of Primitives
************************************************************

.. code-block:: as3

 [Column(name="selectedIds", collectionItemType="uint")]
 public function get selectedIds():ArrayCollection
 {
     if (!_selectedIds)
     {
         _selectedIds = new ArrayCollection();
         setPrimitiveValue("selectedIds", _selectedIds);
     }
     return _selectedIds;
 }

 public function set selectedIds(value:ArrayCollection):void
 {
     _selectedIds = value;
     setPrimitiveValue("selectedIds", value);
 }


6. Saving
###########################

When making calls to the database, make sure that you wrap them in **FxORM.entityManager.beginTran()**,
**FxORM.entityManager.commitTran()** and **FxORM.entityManager.rollbackTran()**.

Let's save some of your objects into the database:

.. code-block:: as3

 var myObjects : Array = backendGateway.getMyObjects();
 try
 {   FxORM.entityManager.beginTran();
     for each (var obj : MyObject in myObjects)
     {
         obj.save();
     }
     FxORM.entityManager.commitTran();
 } catch (e : Error)
 {
     FxORM.entityManager.rollbackTran();
     // log error
 }


7. Cleaning Cache
###########################

Now, let's test that the objects we saved are indeed in the database.

.. code-block:: as3

 var objectsFromDataBase : Array = FxORM.entityManager.findAll(MyObject);

Here, if you run this code immediately after the previous step (without restarting), the objects won't actually be taken from the database (unless you saved really **a lot** of them).
So, in order to test objects **from the database**, first call:

.. code-block:: as3

 CacheManager.reset();

This will clean the cache. Normally, you would not need to directly use this class.

8. Deleting
###########################

Now, if you want to remove objects from the database, simply call:

.. code-block:: as3

 obj.remove()

but remember to wrap it in the try-catch block and rollback the transaction if error occurs, like we did in the step where we saved objects to the database:

.. code-block:: as3

 var myObjects : Array = FxORM.entityManager.findAll(MyObject);
 try
 {   FxORM.entityManager.beginTran();
     for each (var obj : MyObject in myObjects)
     {
         obj.remove();
     }
     FxORM.entityManager.commitTran();
 } catch (e : Error)
 {
     FxORM.entityManager.rollbackTran();
     // log error
 }


**isCascade**


So, what happens to other objects referenced by the object we remove? By default, they won't be removed, but if you want to change this behaviour,
add **isCascade=true** to the **[Column]** metadata tag on the referenced properties and collections which should also get removed:

.. code-block:: as3

 [Column(name="objectsCascadeDeleteCollection", isCascade=true, isCollection=true, collectionItemType="data.MyReferenceObject")]
 public function get objectsCascadeDeleteCollection():ArrayCollection
 {
     if (!_objectsCascadeDeleteCollection) _objectsCascadeDeleteCollection = getCollection("objectsCascadeDeleteCollection", false);
     return _objectsCascadeDeleteCollection;
 }

Working with Backend
----------------------

Normally, when working with backend, your application receives objects from the backend in its response. The same object from backend can be present in more than one response.


 For example, suppose you have two requests:
    1 **getAllCars()**;
    2 **getOwnedCars(person)**;

And your application first invokes request **getAllCars()**.
Suppose, that the backend returns 4 cars with ids: "1", "2", "3", "4".
When your application receives the response, it parses it into **Car** instances (which extend **PersistentObject**), and saves them to the database.

Next, your application invokes **getOwnedCars(person)**. Suppose, the backend returns 2 cars with ids: "1" and "4".
Your application receives the response from the backend, parses it, and assigns the parsed cars as a collection of **Car** objects to the **person** object (which is a **IPersistentObject** too).
Then it saves the **person** object.

So, what will happen? Will the cars from **getOwnedCars(person)** call replace their counterparts saved after **getAllCars()** call? Will we still have 4 records in the cars table?
The answer is no, we will have 6 records. This is because the cars received in the second call will be parsed into brand new objects with no reference to the database, and there is not telling in how they are connected to the cars we saved after the first call to the backend.

In order to solve this problem, you have to implement an interface **IDuplicatedReference** in your Car class, and you need to assign car
ids to the **idField** of this interface.
Now, after you call person.save(), the cars from the second call should replace their counterparts already present in the database:

.. code-block:: as3

 [Table("cars")]
 public class Car extends PersistentObject implements IDuplicatedReference
 {
     public var carId : String;
     public function get idField() : * { return carId; }
     public function set idField(v : *) : void { carId = v; }
     // other fields
 }


You save IPersistentObject by calling "save()" method. This method saves all the properties/changes to the properties of the object.

Suppose your Car class references a collection of servicing companies. For each car this collection is long,
and you don't get them with **getAllCars()** call, but get them separately for each car when the need arises.
Suppose, for a car "1", you have already retrieved a collection of servicing companies, and saved it to the database.
Suppose, then, you call a **getAllCars()** method, and get "1" car without any servicing companies.
If you saved it now, its servicing companies would have been erased.
You will need to update a "1" car in the database, and you don't want to completely overwrite it.
To do this, first retrieve the "1" car from the database using **FxORM.entityManagement.getByDuplicatedId("1", Car)**.
Then update the properties you want to overwrite, and finally, call **car.save()**;

However, if you are willing to override all the properties of an object, just call save() method on the object.


.. _how_to_implement_ipersistenobject:
How to implement IPersistentObject (without extending **PersistentObject**)
---------------------------------------------------------------------------

If you prefer not to extend **PersistentObject**, you can implement **IPersistentObject**.
Please refer to the  **PersistentObject**'s source code to see how to implement the interface.

Basically, what you need to do is:

 # instantiate an instance of **ReferenceContext** in your constructor/init method, and store it as a field of your object (or use any other injection way). For each **IPersistentObject** there should be its own **ReferenceContext** (the one-to-one relationship).
 # delegate method calls of **IPersistentObject** to **ReferenceContext**. Mark **objectId** getter with [Id] metadata tag.
 # instead of calling **getReference**, **setReference**, **setPrimitiveValue**, **getCollection**, **setCollection** in your getters setters, as we did in examples above, delegate to the corresponding methods of **ReferenceContext**.

It is a good idea to create one such class and extend it by other classes.

Queries
-------

You can query database for **IPersistentObjects**.

Starting a Query
#############################

To start a query call:

.. code-block:: as3

 FxORM.instance.entityManager.select(YourPersistentObjectClass)

This call will return a query builder. Use this builder to build the query.


Getting a Query results
#############################


To get all objects matching query call:

.. code-block:: as3

    .query();

To get only first **n** objects matching query call:

.. code-block:: as3

    .query(n);

To get only items from page **pageNumber** (when number of items per page is **itemsPerPage**) for the matching query call:

.. code-block:: as3

    .queryPage(pageNumber, itemsPerPage);

Query example (simple)
#############################

This call will return all objects of type Person from the database:

.. code-block:: as3

 var allPersons : Array = FxORM.instance.entityManager.select(Person).query();

This call will return the first 100 objects of type Person from the database:

.. code-block:: as3

 var first100Persons : Array = FxORM.instance.entityManager.select(Person).query(100);

This call will return Person objects from the database for the page 2 when number of items per page is 30 (pageNumber argument is 0-based, so the number of the second page is actually 1):

.. code-block:: as3

 var personsForPage2 : Array = FxORM.instance.entityManager.select(Person).queryPage(1, 30);



Property Chains
#############################

When building selections you will most likely need to add restrictions to queried objects (which will be then translated into WHERE clause of the SQL request by the selection builder).
*Property chains* represent references to properties chained to the queries object.

Lets review an example.

Assume, that there is a class *Person* with a String property *name*.

The query which selects all Persons who have name which start from "Joh" would be:

.. code-block:: as3

 var results:Array = FxORM.instance.entityManager.select(Person)
                 .where("# like ?", ["name"], ["Joh%"])
                 .query();


Notice the *where* call. The first parameter is the query text. It may contain symbols **#** and **?**:

 * **#** symbols represent *property chains*, specified in the second parameter of the *where* call (in the order specified). If your are adding restriction on the objects you are querying, the property chains are names of the properties on which you want to add a condition, joined with **.** (dot).
 * **?** symbols represent sql arguments, specified in the third parameter of the *where* call (in the order specified). If you do not reference any arguments in your selection, you can leave out the third parameter.

Lets also suppose that a *Person* object has a reference to a *Book* object in a property called *favouriteBook*. Lets find all the persons whose favourite book's name starts with "Harry Potter":

.. code-block:: as3

  var results:Array = FxORM.instance.entityManager.select(Person)
                 .where("# like ?", ["favouriteBook.name"], ["Harry Potter%"])
                 .query();

Now, lets suppose that *Person* object also references another *Person* object in a property called *manager*. And *Person* also has a reference to an *Address* object in property called *address*.
Lets find a list of persons who live in the same city as their manager:

.. code-block:: as3

   var results:Array = FxORM.instance.entityManager.select(Person)
                  .where("#=#", ["manager.address.city", "address.city"])
                  .query();

Now, lets concatenate the above two queries and find a list of persons who live in the same city as their manager, and whose favourite book starts with "Harry Potter":

.. code-block:: as3

   var results:Array = FxORM.instance.entityManager.select(Person)
                   .where("#=#", ["manager.address.city", "address.city"])
                   .where("# like ?", ["favouriteBook.name"], ["Harry Potter%"])
                   .query();

As you can see, you can specify more than one *where* clause. In the resulting sql query, all *where* clauses will be concatenated using AND keyword.
Now, lets suppose that there is also a class *Company* which references a *Person* in its *manager* property, and *Address* in its *address* property, and String property *name*.
Lets find all persons whose favourite book has the same name as a favourite book of manager of a company with name "HTC":

.. code-block:: as3

   var results:Array = FxORM.instance.entityManager.select(Person)
                   .where("#=#", ["favouriteBook.name", new PropertyChain("manager.favouriteBook.name", Company)])
                   .where("#=?", [new PropertyChain("name", Company)], ["HTC"])
                   .query();

In the above example because we are joining on a different type,
we have to specify more information in the property chain for it: we need to specify type (and optionally alias).
You can use PropertyChains for the objects of type different from the one your are querying on by specifying different classes in PropertyChain objects.
If you specify several PropertyChains/selection criteria with the same class in PropertyChain,
they will all be mapped to the same selection from the corresponding table, unless you specify different aliases, in which case different joins will be made.

Find all persons whose manager's manager lives in London:

.. code-block:: as3

 var results:Array = FxORM.instance.entityManager.select(Person)
                .where("#=?", ["manager.manager.address.city"], ["London"])
                .query();

Find all persons whose manager's manager lives in the same city as the person:

.. code-block:: as3

 var results:Array = FxORM.instance.entityManager.select(Person)
                .where("#=#", ["manager.manager.address.city", "address.city"])
                .query();

In the previous examples the last property in the property chains was always a property with a primitive value. This is not a rule.
Here's an example where we search for persons whose favourite book is the same as the one of their manager:

.. code-block:: as3

 var results:Array = FxORM.instance.entityManager.select(Person)
                .where("#=#", ["favouriteBook", "manager.favouriteBook"])
                .query();

Now, lets have a couple of examples with collection properties:

Suppose, *Book* object has a reference to a collection of *Person* objects in its property *authors*.

All books written by Bronte:

.. code-block:: as3

  var results:Array = FxORM.instance.entityManager.select(Book)
                  .where("# like ?", ["authors.name"], ["%Bronte"])
                  .query();

Now, lets suppose that *Person* object has a reference to a collection of other *Person* objects in its property *friends*.
Select all books favoured by friends of the authors:

.. code-block:: as3

    var results:Array = FxORM.instance.entityManager.select(Book)
                .where("#=#", ["authors.friends.favouriteBook", new PropertyChain(null, Book)])
                .query();

Pay attention to *new PropertyChain(null, Book)*. It references the objects we are querying on.

Specifying Order By clauses
#############################

you can add Order By clauses using *property chains*. Here are several examples:

.. code-block:: as3

    var results:Array = FxORM.instance.entityManager.select(Person)
                .where("# like ?", ["favouriteBook.name"], ["Harry Potter%"])
                .orderBy("favouriteBook.name")
                .query();

.. code-block:: as3

    var results:Array = FxORM.instance.entityManager.select(Book)
                    .where("# like ?", ["authors.name"], ["%Bronte"])
                    .orderBy("name")
                    .query();

To specify descending (DESC) direction to the orderBy, add *false* as a second parameter to *orderBy*.

.. code-block:: as3

     var results:Array = FxORM.instance.entityManager.select(Person)
                    .where("#=#", ["manager.manager.address.city","address.city"])
                    .orderBy("address.city", false)
                    .query();

You can specify multiple *orderBy* clauses.

Metadata tags
-------------

When you map your data, you specify the following Metadata tags:

 * [Table]
 * [Column]

[Table]
#######

This metadata tag must be defined for classes which need to be mapped to the database. You mast specify the name of the database table in which instances of this class should be stored:

.. code-block:: as3

 [Table("persons")]
 public class Person extends IPersistentObject

[Column]
########

This metadata tag must be placed on properties (getters) or fields (for primitive values only, fields must be Bindable) of your mapped class to identify which properties/fields need to be stored in the database.
It has the following parameters:

 * **name** : String - the name of the column in which property value should be stored. Can be omitted. In that case, the column name will be the same as the property name.
 * **isReference** : Boolean - must be set to true for referenced objects and collection of persistent objects. Should be false for primitive properties and collections/array of primitive values. By default it is false.
 * **isCollection** : Boolean - must be set to true only for references of collections of persistent objects.
 * **collectionItemType** : String - must be defined only for references of collections of persistent objects. Specify the full type name of the items stored in the collection (for example, "maf.FxORM.examples.data.Person").
 * **referenceType** : String - can only be specified for properties which are isReference. Normally, you don't have to set this value and it will be taken from the return type of the getter. But if you want to override it (for example when the return type is an interface), you must specify this value.
 * **lazyLoad** : Boolean - specify only for isReference or isCollection columns. True by default.
 * **isCascade** : Boolean - specify only for isReference or isCollection columns. Defines whether the property/collection items should be deleted in a cascade when the owner object is deleted. False by default.

Logging
-------

Sometimes you will need to see debugging info from FxORM.
In order to enable logging of FxORM events, execute the following:

.. code-block:: as3

 FxORMProfiler.DEBUG = true

It uses mx.logging to log messages with LogEventLevel.DEBUG for all events except errors.

You can also define your own IFxORMProfiler implementation and set it:

.. code-block:: as3

 FxORM.instance.profiler = new MyFxORMProfiler()

Please take a look at IFxORMProfiler for further details.

Examples
--------

For more examples, please check FxORM.Tests project.

