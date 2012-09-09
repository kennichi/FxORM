package core.entityOperations {
import IPersistentObject;

import cache.CacheManager;

import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;

import namespaces.data_mapping;

use namespace data_mapping;

public class GetObject extends BaseEntityOperation {

    public function execute(objectId : uint, clazz : Class) : IPersistentObject {
        if (objectId == 0) return null;
        var cached : IPersistentObject = getFromCache(objectId);
        if (cached != null) return cached;
        var rawObject : Object = operations.getObjectRaw(objectId, clazz);
        if (rawObject == null) return null;
        var result : IPersistentObject = operations.convertObject(rawObject, clazz);
        return result;
    }

    public function GetObject(typeMappings:TypeMappings, sqlConnection:SQLConnection, cacheManager:CacheManager, operations:EntityOperationsFacade) {
        super(typeMappings, sqlConnection, cacheManager, operations);
    }
}
}
