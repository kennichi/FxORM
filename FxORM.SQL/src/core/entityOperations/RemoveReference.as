package core.entityOperations {
import cache.CacheManager;

import core.utils.DataUtils;

import core.utils.fieldMappings.ReferenceFieldMapping;

import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;

import namespaces.data_mapping;

use namespace data_mapping;
public class RemoveReference extends BaseEntityOperation {

    public function execute(rawOwnerFromDB : Object, field : ReferenceFieldMapping, removeFromCacheOnly : Boolean) : void {
        var referenceKey : * = rawOwnerFromDB[field.fieldName];
        if (referenceKey == null) return;
        var referenceObjectId : uint = referenceKey as uint;
        var referenceType : Class = DataUtils.getClass(field.typeName);
        // 0 means empty ref
        if (referenceObjectId == 0) return;
        operations.removeById(referenceObjectId, referenceType, removeFromCacheOnly);
        removeFromCache(referenceObjectId);
        var removeFromDB:Boolean = !removeFromCacheOnly;
        if (removeFromDB) {
            addDeletedId(referenceObjectId);
        }
    }

    public function RemoveReference(typeMappings:TypeMappings, sqlConnection:SQLConnection, cacheManager:CacheManager, operations:EntityOperationsFacade) {
        super(typeMappings, sqlConnection, cacheManager, operations);
    }
}}
