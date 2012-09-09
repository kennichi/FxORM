package contexts
{
import IPersistentObject;

import namespaces.data_mapping;
import utils.ArrayUtils;
import utils.CollectionUtils;

import interfaces.IEntityManager;

import mx.collections.ArrayCollection;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.PropertyChangeEvent;

import org.spicefactory.lib.errors.IllegalStateError;

import utils.PersistenceUtils;

use namespace data_mapping;

/**
 * ReferenceContext which represents an field of ArrayCollection of persistent objects.
 */
public class CollectionContext extends ReferenceContext
{
    /**
     * the value of the collection represented by this object.
     */
    private var _value : ArrayCollection;
    /**
     * the name of the field of the collection represented by this object.
     */
    public var fieldName : String;
    /**
     * a collection of changes made to the collection represented by this instance.
     * @see CollectionAction
     */
    public var actions : ArrayCollection = new ArrayCollection();

    /**
     *
     * @param owner owner of the collection which is represented by this CollectionContext
     * @param entityManager
     */
    public function CollectionContext(owner : IPersistentObject, entityManager : IEntityManager) : void {
        super(owner, entityManager);
    }

    data_mapping override function clearChanges(pendingContexts : Array) : void {
        if (pendingContexts.indexOf(this) >= 0) return;
        pendingContexts.push(this);
        actions = new ArrayCollection();
        for each (var item : IPersistentObject in value) {
            item.getContext().clearChanges(pendingContexts);
        }
    }

    data_mapping override function commitChanges(pendingObjectsToSave : Array) : void {
        entityManager.commitCollectionChanges(this, pendingObjectsToSave);
    }

    private function onValueCollectionChange(e : CollectionEvent) : void {
        switch(e.kind) {
            case CollectionEventKind.ADD:
                var item : IPersistentObject = e.items[0] as IPersistentObject;
                onAdd(item);
                break;
            case CollectionEventKind.REMOVE:
                item = e.items[0] as IPersistentObject;
                onRemove(item);
                break;
            case CollectionEventKind.REPLACE:
                var propertyEvent : PropertyChangeEvent = e.items[0] as PropertyChangeEvent;
                var oldItem : IPersistentObject = propertyEvent.oldValue as IPersistentObject;
                var newItem : IPersistentObject = propertyEvent.newValue as IPersistentObject;
                onReplace(oldItem, newItem);
                break;
        }
    }

    /***** handle changes to collection ****/

    private function onAdd(item : IPersistentObject) : void {
        // if objects can be deleted - we need to remove from collection when they are deleted...
        var revertedRemove : Boolean = removeActionsOfType(CollectionAction.REMOVE_ACTION, item);
        if (!revertedRemove) {
            actions.addItem(new CollectionAction(CollectionAction.ADD_ACTION, item));
        }
    }

    private function onRemove(item : IPersistentObject) : void {
        var revertedAdd : Boolean = removeActionsOfType(CollectionAction.ADD_ACTION, item);
        if (!revertedAdd && PersistenceUtils.existsInDB(item)) {
            actions.addItem(new CollectionAction(CollectionAction.REMOVE_ACTION, item));
        }
    }

    private function onReplace(oldItem : IPersistentObject, newItem : IPersistentObject) : void {
        onRemove(oldItem);
        onAdd(newItem);
    }

    /**
     * Removes from history of changes to the collection all changes that involved {#link item} and had actionType {#link actionType}.
     * @param actionType
     * @param item
     * @return returns whether any actions have been removed
     */
    private function removeActionsOfType(actionType : int, item : IPersistentObject) : Boolean {
        var removedAnyActions : Boolean = false;
        for each (var action : CollectionAction in actions) {
            if (action.actionType == actionType && PersistenceUtils.areEqual(action.item, item)) {
                CollectionUtils.remove(actions, action);
                removedAnyActions = true;
            }
        }
        return removedAnyActions;
    }

    data_mapping override function getDirtyContexts(checkedContexts : Array) : Array {
        var result : Array = [];
        if (checkedContexts.indexOf(this) >= 0) return result;
        checkedContexts.push(this);
        if (actions.length > 0 && PersistenceUtils.existsInDB(owner)) {
            result.push(this);
        }
        for each (var item : IPersistentObject in value) {
            if (item == null) {
                throw new IllegalStateError("null items are not supported in pesistent collections");
            }
            ArrayUtils.joinWithArray(result, IPersistentObject(item).getContext().getDirtyContexts(checkedContexts));
        }
        return result;
    }

    public function set value(val : ArrayCollection) : void {
        if (_value != null) {
            _value.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onValueCollectionChange);
        }
        _value = val;
        if (_value != null) {
            _value.addEventListener(CollectionEvent.COLLECTION_CHANGE, onValueCollectionChange);
        }
        clearChanges([]);
    }

    public function get value() : ArrayCollection {
        return _value;
    }

}
}