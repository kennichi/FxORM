package core.entityOperations {
import cache.CacheManager;

import core.SqlStatementsFactory;

import core.utils.SqlUtils;
import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;
import flash.data.SQLStatement;

import namespaces.data_mapping;

import metadata.TypeMapping;

public class GetObjectRaw extends BaseEntityOperation {

    data_mapping function execute(objectId : uint, clazz : Class) : Object {
        if (objectId == 0) return null;
        var mapping : TypeMapping = getMapping(clazz);
        var statement : SQLStatement = SqlStatementsFactory.create(mapping.getByIdStatement);
        statement.parameters[":objectId"] = objectId;
        var readItems : Array = SqlUtils.executeWithResult(statement, sqlConnection);
        if (readItems == null || readItems.length == 0) return null;
        return readItems[0];
    }

    public function GetObjectRaw(typeMappings:TypeMappings, sqlConnection:SQLConnection, cacheManager:CacheManager, operations:EntityOperationsFacade) {
        super(typeMappings, sqlConnection, cacheManager, operations);
    }

}
}
