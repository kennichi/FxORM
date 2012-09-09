package core.utils.fieldMappings {
import IPersistentObject;

import core.entityOperations.EntityOperationsFacade;

import mx.collections.ArrayCollection;

/**
 * in this case we have a "primitives" object of type ArrayCollection (ArrayCollection of primitive values)- store it's values as a string of SIMPLE_COLLECTION_SEPARATOR-separated values.
 */
public class ArrayCollectionFieldMapping extends ArrayFieldMapping {
    override public function saveRawValue(owner:IPersistentObject, entityOperations:EntityOperationsFacade, pendingObjectsToSave : Array):* {
        var arrayColl : ArrayCollection = getValue(owner);
        return saveRawArray(arrayColl.source);
    }

    override public function getValueFromRaw(rawOwnerFromDB:Object, entityOperations:EntityOperationsFacade):* {
        return new ArrayCollection(super.getValueFromRaw(rawOwnerFromDB, entityOperations));
    }

    private function getValue(owner:IPersistentObject):ArrayCollection {
        return owner[fieldName] as ArrayCollection;
    }

    public function ArrayCollectionFieldMapping(fieldName:String, columnName:String, collectionItemType:String) {
        super(fieldName, columnName, collectionItemType);
    }
}
}
