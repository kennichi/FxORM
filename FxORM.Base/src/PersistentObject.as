package {
import contexts.ReferenceContext;

import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;

/** Persistent objects which need to be stored in the DB need to extend this base class.
 * Example:
 * <code>
 * [Bindable]
 * [Table(name="myTable")]
 * public class MyPersistentObject extends IIPersistentObject
 * </code>
 *
 * All properties which need to be saved to the DB, need to be marked with [Column] metadata tag,
 * and if they are references/collections, they need to be wrapped in getters/setters and marked with [Column] metadata tag.
 * Primitive properties: you may define them in a field (not getter/setter), but the fields need to be marked as Bindable.
 * Example:
 * <code>
 * [Bindable]
 * [Column]
 * public var endDate : Date;
 *
 * [Column("BEId")]
 * public var id : int;
 * </code>
 * If you don't want to mark a field as Bindable, you need to define a getter/setter and call {#link setPrimitiveValue} in the setter.
 * in the setter.
 * Example:
 * <code>
 * [Column(name="midLevelProperty")]
 * public function get midLevelProperty():String
 * {
 *  return _midLevelProperty;
 * }
 *
 * public function set midLevelProperty(value:String):void
 * {
 *  _midLevelProperty = value;
 *  setPrimitiveValue("midLevelProperty", value);
 * }
 * </code>
 * Reference properties: need to be wrapped in getters/setters and marked with [Column] metadata tag, and a call to {@link #setReference} is necessary in the setter.
 * Example: Reference column example:
 * <code>
 * [Column(name="reference", isReference=true, lazyLoad=true)]
 * public function get reference() : MyReferenceObject
 * {
 * if (!_reference) _reference = getReference("reference") as MyReferenceObject;
 * return _reference;
 * }
 *
 * public function set reference(value : MyReferenceObject):void
 * {
 * _reference = value;
 * setReference("reference", value)
 * }
 * </code>
 * Collection properties: need to be wrapped in getters/setters and marked with [Column] metadata tag, and a call to {@link #setCollection} is necessary in the setter.
 * Example:
 * <code>
 * [Column(name="referenceObjectsCollection", isCollection=true, collectionItemType="data.MyReferenceObject")]
 * public function get referenceObjectsCollection():ArrayCollection
 * {
 * if (!_referenceObjectsCollection) _referenceObjectsCollection = getCollection("referenceObjectsCollection", false);
 * return _referenceObjectsCollection;
 * }
 *
 * public function set referenceObjectsCollection(value:ArrayCollection):void
 * {
 * _referenceObjectsCollection = value;
 * setCollection("referenceObjectsCollection", value);
 * }
 * </code>
 *
 * Collection of Primitives. They are stored as a comma separated values. Need to be wrapped in getters/setters and marked with [Column] metadata tag, and a call to {@link #setPrimitiveValue} is necessary in the setter.
 * <code>
 * // todo: write test for this!
 * // in this particular example we want selectedIds to always be not null.
 * [Column(name="selectedIds", collectionItemType="uint")]
 * public function get selectedIds():ArrayCollection
 * {
 * if (!_selectedIds)
 * {
 * _selectedIds = new ArrayCollection();
 * setPrimitiveValue("selectedIds", _selectedIds);
 * }
 * return _selectedIds;
 * }
 *
 * public function set selectedIds(value:ArrayCollection):void
 * {
 * _selectedIds = value;
 * setPrimitiveValue("selectedIds", value);
 * }
 * </code>
 */
public class PersistentObject extends EventDispatcher implements IPersistentObject
{
    private var context : ReferenceContext;

    /**
     * this property is a PK in DB for the object.
     */
    [Transient] [Id]
    public function get objectId() : uint {
        return context.objectId;
    }

    public function set objectId(v : uint) : void {
        context.objectId = v;
    }

    /**
     * dumps all changes made to the instance and it's references tree to DB
     * @return
     */
    public function save() : uint {
        return context.save();
    }

    /**
     * removes instance from DB
     */
    public function remove() : void {
        context.remove();
    }

    public function PersistentObject() : void {
        context = new ReferenceContext(this, FxORM.instance.entityManager);
    }

    /**
     * saves {#link val} to DB
     * @param fieldName
     * @param val
     */
    protected function setReference(fieldName : String, val : IPersistentObject) : void {
        context.setReference(fieldName, val);
    }

    /**
     * returns reference from DB
     * @param fieldName
     * @return
     */
    protected function getReference(fieldName : String) : IPersistentObject {
        return context.getReference(fieldName);
    }


    protected function setPrimitiveValue(fieldName : String, val : *) : void {
        context.setPrimitiveValue(fieldName, val);
    }

    /**
     * saves collection {#link val} to DB
     * @param fieldName
     * @param val
     */
    protected function setCollection(fieldName : String, val : ArrayCollection) : void {
        context.setCollection(fieldName, val);
    }

    /**
     * returns collection value from DB
     * @param fieldName
     * @allowNull if the collection is not in DB, it will create an empty collection and return it. (the user will not need to check on null when working with it).
     */
    protected function getCollection(fieldName : String, allowNull : Boolean = true) : ArrayCollection {
        var result : ArrayCollection = context.getCollection(fieldName);
        if (result == null && !allowNull) {
            result = new ArrayCollection();
            setCollection(fieldName, result);
        }
        return result;
    }

    /**
     * #private
     * @return context
     */
    public function getContext():ReferenceContext {
        return context;
    }


    override public function toString():String {
        return super.toString() + " with objectId " + objectId;
    }
}
}