package contexts
{
import flash.events.IEventDispatcher;
import namespaces.data_mapping;
import utils.ArrayUtils;
import interfaces.IEntityManager;
import metadata.ColumnMetadata;

import mx.collections.ArrayCollection;
import mx.events.PropertyChangeEvent;

import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;

import utils.PersistenceUtils;

use namespace data_mapping;

/**
 * Belongs to a IPersistentObject. Represents gateway for this IPersistentObject to persistence.
 * Caches columns (fields) data of its owner (IPersistentObject).
 * Tracks changes to the object, so that when time comes, the EntityManager can retrieve all the changes ({#link getDirtyContexts}) and make decision
 * on what needs to be saved to DB.
 */
public class ReferenceContext
{
    public var objectId : uint;
    /**
     * cache of field values of the owner IPersistentObject.
     * @see FieldValue.
     */
    public var fieldValues : Array = new Array();

    protected var entityManager : IEntityManager;
    private var changed : Boolean;

    private var _owner : IPersistentObject;
    private var _classInfo : ClassInfo;

    public function ReferenceContext(owner : IPersistentObject, entityManager : IEntityManager) : void {
        setOwner(owner);
        this.entityManager = entityManager;
        objectId = PersistenceUtils.allocateNonPersistantId();
    }

    public function setReference(field : String, value : IPersistentObject) : void {
        setFieldValue(field, value);
    }

    /**
     * returns value from DB.
     * Example of usage:
     * <code>
     * Column(isReference=true)]
     * public function get manager():Person
     * {
     *  if (!_manager)
     *      _manager = getReference("manager") as Person;
     *  return _manager;
     * }
     * </code>
     * Normally called when the field is null.
     * @param field
     * @return
     */
    public function getReference(field : String) : IPersistentObject {
        var fieldValue : FieldValue = getFieldValue(field);
        // this function is normally called when the field behind the property is null.
        // Could be that the field is null because it was set to null, but not saved yet. We don't want to go to the DB in this situation.
        if (fieldValue && fieldValue.value == null && fieldValue.changed) {
            return null;
        }
        var result : IPersistentObject = entityManager.getProperty(_owner, field);
        setFieldValue(field, result);
        return result;
    }

    public function setCollection(fieldName : String, val : ArrayCollection) : void {
        var collectionValue : CollectionValue = getFieldValue(fieldName) as CollectionValue;
        if (collectionValue == null) {
            collectionValue = new CollectionValue();
            collectionValue.fieldName = fieldName;
            collectionValue.context = new CollectionContext(_owner, entityManager);
            collectionValue.context.fieldName = fieldName;
            fieldValues.push(collectionValue);
        }
        collectionValue.context.value = val;
        collectionValue.changed = true;
    }

    public function getCollection(field : String) : ArrayCollection {
        var collectionValue : CollectionValue = getFieldValue(field) as CollectionValue;
        // this function is normally called when the field behind the property is null.
        // Could be that the field is null because it was set to null, but not saved yet. We don't want to go to the DB in this situation.
        if (collectionValue && collectionValue.context.value == null && collectionValue.changed) {
            return null;
        }
        var result : ArrayCollection = entityManager.getProperty(_owner, field);
        setCollection(field, result);
        return result;
    }

    public function setPrimitiveValue(fieldName : String, val : *) : void {
        setFieldValue(fieldName, val);
    }

    public function save(pendingObjectsToSave : Array = null) : uint {
        if (!pendingObjectsToSave) pendingObjectsToSave = [];
        return entityManager.save(_owner, pendingObjectsToSave);
    }

    public function remove() : void {
        entityManager.remove(_owner);
    }

    data_mapping function getFieldValue(field : String) : FieldValue {
        for each (var fieldValue : FieldValue in fieldValues) {
            if (fieldValue.fieldName == field) return fieldValue;
        }
        return null;
    }

    /**
     * This method validates all invalidated {#link fieldValues}.
     * It should be called:
     *  1. after object is loaded from DB.
     *  2. after object is saved to DB.
     */
    data_mapping function clearChanges(pendingContexts : Array) : void {
        if (pendingContexts.indexOf(this) >= 0) return;
        pendingContexts.push(this);
        for each (var fieldValue : FieldValue in fieldValues) {
            fieldValue.changed = false;
            if (fieldValue.value is IPersistentObject) {
                IPersistentObject(fieldValue.value).getContext().clearChanges(pendingContexts);
            }
            // TODO: check that this indeed is necessary:
            else if (fieldValue is CollectionValue) {
                CollectionValue(fieldValue).context.clearChanges(pendingContexts);
            }
        }
        changed = false;
    }

    /**
     * @return ReferenceContexts of all the objects and collections referenced by owner IPersistentObject
     * (can be references not directly, method uses recursion).
     * Additionally, includes in the result this context if it has changed.
     */
    data_mapping function getDirtyContexts(checkedContexts : Array) : Array {
        var result : Array = [];
        if (checkedContexts.indexOf(this) >= 0) return result;
        checkedContexts.push(this);
        var hasChangedFields : Boolean = false;
        for each (var fieldValue : FieldValue in fieldValues) {
            if (fieldValue.changed) {
                hasChangedFields = true;
            }
            if (fieldValue.value == null) continue;
            if (fieldValue.value is IPersistentObject) {
                ArrayUtils.joinWithArray(result, IPersistentObject(fieldValue.value).getContext().getDirtyContexts(checkedContexts));
            }
            else if (fieldValue is CollectionValue) {
                ArrayUtils.joinWithArray(result, CollectionValue(fieldValue).context.getDirtyContexts(checkedContexts));
            }
        }
        // only for persistent items (the ones which are in db already). if not persistent - check in save, deal with non-persistent properties (the ones which have not ever been saved to db).
        if ((hasChangedFields || changed) && PersistenceUtils.existsInDB(_owner)) {// || !EntityManager.instance.isPersistant(_owner)) - no need for that, will check in save procedure (for non-persistant properties)
            result.push(this);
        }
        return result;
    }

    data_mapping function commitChanges(pendingObjectsToSave : Array) : void {
        entityManager.saveJustObject(owner, pendingObjectsToSave);
    }

    data_mapping function get owner() : IPersistentObject {
        return _owner;
    }

    /**
     * called from the owner when its property changes. If the property is persistent, updates internal flag which marks object as invalidated (dirty).
     * @param e event details
     */
    private function onPropertyChange(e : PropertyChangeEvent) : void {
        if (_owner == null) throw new IllegalStateError("This situation should not happen (check set value)!");
        var property : Property = classInfo.getProperty(e.property.toString());
        if (property.getMetadata(ColumnMetadata).length > 0) {
            changed = true;
        }
    }

    private function setFieldValue(field : String, val : *) : FieldValue {
        var fieldValue : FieldValue = getFieldValue(field);
        if (fieldValue && PersistenceUtils.areEqual(fieldValue.value, val)) return fieldValue;
        if (fieldValue == null) {
            fieldValue = new FieldValue();
            fieldValue.fieldName = field;
            fieldValue.value = null;
            fieldValues.push(fieldValue);
        }
        fieldValue.value = val;
        fieldValue.changed = true;
        return fieldValue;
    }

    private function unsubscribeToOwnerChanges():void {
        if (_owner is IEventDispatcher) {
            IEventDispatcher(_owner).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
        }
    }

    private function subscribeToOwnersChanges():void {
        if (_owner is IEventDispatcher) {
            IEventDispatcher(_owner).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
        }
    }

    private function setOwner(value : IPersistentObject) : void {
        if (this._owner != null) {
            unsubscribeToOwnerChanges();
        }
        this._owner = value;
        subscribeToOwnersChanges();
    }

    private function get classInfo() : ClassInfo {
        if (_classInfo == null) {
            _classInfo = ClassInfo.forInstance(_owner);
        }
        return _classInfo;
    }
}
}