package contexts
{
import namespaces.data_mapping;
import mx.collections.ArrayCollection;
import mx.events.CollectionEvent;

use namespace data_mapping;

/**
 * Represents the current state of a field (column) of a IPersistentObject. Can represent either primitive value - value which can be stored in a single DB cell (i.e. int, boolean, date, string), a reference value - a reference to another IPersistentObject, or an
 * an ArrayCollection of primitive values. Automatically updates {#link changed} status when value is set, or, in case of a collection of primitive values, when items of this collection change.
 * Invalidated instance (with {#link changed} set to true) means that owner IPersistentObject needs to be saved to DB.
 *
 * @see CollectionValue
 */
public class FieldValue
{
    private var _value : *;
    public var fieldName : String;
    public var changed : Boolean;

    public function get value():* {
        return _value;
    }

    public function set value(value:*):void {
        // if field represents a collection of primitive values [isCollection=false, collectionItemType=int] which are stored in DB as a comma separated string
        if (_value is ArrayCollection) {
            ArrayCollection(_value).removeEventListener(CollectionEvent.COLLECTION_CHANGE, onArrayCollectionValueChanage);
        }
        _value = value;
        if (value is ArrayCollection) {
            ArrayCollection(_value).addEventListener(CollectionEvent.COLLECTION_CHANGE, onArrayCollectionValueChanage);
        }
    }

    private function onArrayCollectionValueChanage(event : CollectionEvent) : void {
        changed = true;
    }

}
}