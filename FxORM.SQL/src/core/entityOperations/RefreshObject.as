package core.entityOperations {
import IPersistentObject;

import cache.CacheManager;

import core.utils.FxORMManager;
import core.utils.DataUtils;

import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;

import namespaces.data_mapping;

use namespace data_mapping;

/**
 * use this operation if you need to take the whole data (inc. aggregated collections and references)
 * from DB, not from cache
 */
public class RefreshObject extends BaseEntityOperation {

    public function execute(objectId : uint) : IPersistentObject {
        if (objectId == 0) return null;
        var cached : IPersistentObject = getFromCache(objectId);
        if (cached != null) {
            operations.removeFromCache(cached);
        }

        var typeName : String = FxORMManager.getTypeNameById(objectId, sqlConnection);
        return operations.getObjectByClass(objectId, DataUtils.getClass(typeName));
    }

    public function RefreshObject(typeMappings:TypeMappings, sqlConnection:SQLConnection, cacheManager:CacheManager, operations:EntityOperationsFacade) {
        super(typeMappings, sqlConnection, cacheManager, operations);
    }
}
}
