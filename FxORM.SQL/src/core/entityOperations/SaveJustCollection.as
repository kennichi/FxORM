package core.entityOperations {
import IPersistentObject;

import cache.CacheManager;

import contexts.CollectionValue;

import core.utils.FxORMManager;
import core.utils.DataUtils;
import core.utils.fieldMappings.CollectionFieldMapping;
import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;

import namespaces.data_mapping;
import utils.ArrayUtils;

import metadata.TypeMapping;

import utils.PersistenceUtils;

use namespace data_mapping;

public class SaveJustCollection extends BaseEntityOperation{

    /**
     * Updates list of objectIds related to collectionId of collection stored in field {#link field} of {#link owner} instance.
     * If collection has items not yet saved to DB, it saves them, otherwise, it ignores all changes to the items of the collection.
     * @param owner
     * @param field
     * @param pendingObjectsToSave
     * @return updated collectionId
     */
    public function execute(owner : IPersistentObject, field : CollectionFieldMapping, pendingObjectsToSave : Array) : uint {
        // if collection has been reset
        var collectionValue : CollectionValue = owner.getContext().getFieldValue(field.fieldName) as CollectionValue;
        var rawObjectFromDB : Object = selectRawFromDB(owner);
        var ownerExistsInDB : Boolean = existsInDB(owner);
        if (collectionValue != null && collectionValue.changed || !ownerExistsInDB) {
            var collId : uint = ownerExistsInDB ?
                    updateCollection(owner, field, rawObjectFromDB, pendingObjectsToSave)
                    :createCollection(owner, field, pendingObjectsToSave);
            return owner[field.fieldName] ? collId : 0;
        }
        else {
            return rawObjectFromDB ? rawObjectFromDB[field.columnName] : 0;
        }
    }

    private function createCollection(owner : Object, field : CollectionFieldMapping, pendingObjectsToSave : Array) : uint {
        var newCollId : uint = FxORMManager.allocateCollectionId(sqlConnection);
        saveCollection(owner[field.fieldName], newCollId, DataUtils.getClass(field.collectionItemType), pendingObjectsToSave);
        return newCollId;
    }

    // returns collectionId
    private function updateCollection(owner : Object, field : CollectionFieldMapping, ownerInDB : Object, pendingObjectsToSave : Array) : uint {
        var oldCollId : uint = ownerInDB[field.columnName] as uint;
        if (oldCollId != 0) {
            saveCollection(owner[field.fieldName], oldCollId, DataUtils.getClass(field.collectionItemType), pendingObjectsToSave);
            return oldCollId;
        } else {
            return createCollection(owner, field, pendingObjectsToSave);
        }
    }

    /**
     *
     * @param itemsCollection can be either Array or ArrayCollection of items which need to be saved
     * @param collectionId id of a collection which needs to be updated with {#link items}
     * @param collectionItemType class of collection item
     */
    private function saveCollection(itemsCollection : Object, collectionId : uint, collectionItemType : Class, pendingObjectsToSave : Array) : void {
        FxORMManager.removeFromCollectionObjectsTable(collectionId, sqlConnection);
        var items : Array = ArrayUtils.toArray(itemsCollection);
        for each (var item : IPersistentObject in items) {
            if (!PersistenceUtils.existsInDB(item)) {
                operations.saveJustObject(item, pendingObjectsToSave);
            }
            var objectId : uint = item.objectId;
            FxORMManager.insertIntoCollectionObjectsTable(objectId, collectionId, sqlConnection);
        }
    }

    public function SaveJustCollection(typeMappings:TypeMappings, sqlConnection:SQLConnection, cacheManager:CacheManager, operations:EntityOperationsFacade) {
        super(typeMappings, sqlConnection, cacheManager, operations);
    }
}
}
