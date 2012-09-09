package core.entityOperations {
import cache.CacheManager;

import core.Constants;

import core.SqlStatementsFactory;

import core.utils.FxORMManager;
import core.utils.SqlUtils;

import core.utils.fieldMappings.SqlFieldMapping;

import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;
import flash.data.SQLStatement;

import namespaces.data_mapping;

import metadata.TypeMapping;

import utils.PersistenceUtils;
use namespace data_mapping;

public class Remove extends BaseEntityOperation {
    public function execute(objectId : uint, clazz : Class, removeFromCacheOnly : Boolean):void {
        if (objectId == 0) return;
        var mapping : TypeMapping = getMapping(clazz);
        var removeFromDB:Boolean = !removeFromCacheOnly;
        if (PersistenceUtils.isPersistantId(objectId)) {
            var rawObjectFromDB : Object = operations.getObjectRaw(objectId, clazz);
            for each (var field : SqlFieldMapping in mapping.fields) {
                field.remove(rawObjectFromDB, removeFromCacheOnly, operations);
            }
            if (removeFromDB) {
                FxORMManager.removeFromObjectsTable(objectId, sqlConnection);
                var deleteStatement : SQLStatement = SqlStatementsFactory.create(mapping.deleteStatement);
                deleteStatement.parameters[":objectId"] = objectId;
                SqlUtils.execute(deleteStatement, sqlConnection);
            }
        }
        removeFromCache(objectId);
        if (removeFromDB) {
            addDeletedId(objectId);
        }
    }

    public function Remove(typeMappings:TypeMappings, sqlConnection:SQLConnection, cacheManager:CacheManager, operations:EntityOperationsFacade) {
        super(typeMappings, sqlConnection, cacheManager, operations);
    }
}
}
