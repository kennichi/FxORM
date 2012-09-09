package core.entityOperations {
import cache.CacheManager;

import core.utils.FxORMManager;

import core.utils.DataUtils;

import core.utils.fieldMappings.CollectionFieldMapping;

import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;

import namespaces.data_mapping;

use namespace data_mapping;
public class RemoveCollection extends BaseEntityOperation {

    public function execute(rawOwnerFromDB : Object, field : CollectionFieldMapping, removeFromCacheOnly : Boolean) : void {
        var collectionId : uint = rawOwnerFromDB[field.columnName] as uint;
        var collectionExistsInDB : Boolean = collectionId != 0;
        var collectionItemClass : Class = DataUtils.getClass(field.collectionItemType);
        // remove collection items if the collection is an aggregate
        if (collectionExistsInDB && field.isCascade) {
            //1. remove items from cache.
            var collectionItemIds : Array = FxORMManager.selectObjectIdsFromCollection(collectionId, sqlConnection);
            for each (var itemObjectId : uint in collectionItemIds) {
                removeFromCache(itemObjectId);
            }
            //2. remove items and their aggregate properties from DB or just cache (removeFromCacheOnly).
            for each (itemObjectId in collectionItemIds)
            {
                operations.removeById(itemObjectId, collectionItemClass, removeFromCacheOnly);
            }
        }
        // remove collection from COLLECTION_OBJECTS table
        var removeFromDB:Boolean = !removeFromCacheOnly;
        if (collectionExistsInDB && removeFromDB) {
            FxORMManager.removeFromCollectionObjectsTable(collectionId, sqlConnection);
        }
    }

    public function RemoveCollection(typeMappings:TypeMappings, sqlConnection:SQLConnection, cacheManager:CacheManager, operations:EntityOperationsFacade) {
        super(typeMappings, sqlConnection, cacheManager, operations);
    }
}
}
