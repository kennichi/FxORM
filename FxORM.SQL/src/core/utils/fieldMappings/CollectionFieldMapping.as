package core.utils.fieldMappings {
import IPersistentObject;
import contexts.CollectionValue;

import core.Constants;
import core.entityOperations.EntityOperationsFacade;

import namespaces.data_mapping;

use namespace data_mapping;

public class CollectionFieldMapping extends NonPrimitiveFieldMapping {
    public var collectionItemType : String;

    /**
     * @param owner
     * @return raw value of the collection (collection id)
     */
    public override function saveRawValue(owner : IPersistentObject, entityOperations : EntityOperationsFacade, pendingObjectsToSave : Array) : *
    {
        return entityOperations.saveJustCollection(owner, this, pendingObjectsToSave);
    }

    override public function getValueFromRaw(rawOwnerFromDB:Object, entityOperations:EntityOperationsFacade):* {
        return entityOperations.getCollectionFromRaw(rawOwnerFromDB, this);
    }

    override public function remove(rawOwnerFromDB:Object, removeFromCacheOnly:Boolean, entityOperations:EntityOperationsFacade):void {
        entityOperations.removeCollection(rawOwnerFromDB, this, removeFromCacheOnly);
    }

    override public function getSqlType():String {
        return Constants.ID_TYPE_NAME;
    }

    override public function markAsDirty(persistentObject:IPersistentObject):void {
        var collectionValue:CollectionValue = persistentObject.getContext().getFieldValue(fieldName) as CollectionValue;
        if (collectionValue == null) return;
        collectionValue.changed = true;
    }

    public function CollectionFieldMapping(fieldName:String, columnName:String, typeName:String, lazyLoad:Boolean, isCascade:Boolean, collectionItemType:String) {
        super(fieldName, columnName, typeName, lazyLoad, isCascade);
        this.collectionItemType = collectionItemType;
    }
}
}
