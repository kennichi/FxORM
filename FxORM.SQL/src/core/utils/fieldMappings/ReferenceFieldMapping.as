package core.utils.fieldMappings {
import IPersistentObject;

import core.Constants;

import namespaces.data_mapping;

use namespace data_mapping;
import core.entityOperations.EntityOperationsFacade;

public class ReferenceFieldMapping extends NonPrimitiveFieldMapping {
    override public function saveRawValue(owner:IPersistentObject, entityOperations:EntityOperationsFacade, pendingObjectsToSave : Array):* {
        return entityOperations.saveJustReference(owner, this, pendingObjectsToSave);
    }

    override public function getValueFromRaw(rawOwnerFromDB:Object, entityOperations:EntityOperationsFacade):* {
        return entityOperations.getReferenceFromRaw(rawOwnerFromDB, this);
    }

    override public function remove(rawOwnerFromDB:Object, removeFromCacheOnly:Boolean, entityOperations:EntityOperationsFacade):void {
        if (isCascade) {
            entityOperations.removeReference(rawOwnerFromDB, this, removeFromCacheOnly);
        }
    }

    override public function getSqlType():String {
        return Constants.ID_TYPE_NAME;
    }

    public function ReferenceFieldMapping(fieldName:String, columnName:String, typeName:String, lazyLoad:Boolean, isCascade:Boolean) {
        super(fieldName, columnName, typeName, lazyLoad, isCascade);
    }
}
}
