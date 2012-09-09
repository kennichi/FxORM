package core.entityOperations {
import IPersistentObject;

import cache.CacheManager;

import core.utils.DataUtils;
import core.utils.fieldMappings.ReferenceFieldMapping;
import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;

import namespaces.data_mapping;

use namespace data_mapping;
public class GetReferenceFromRaw extends BaseEntityOperation {

    public function execute(raw : Object, field : ReferenceFieldMapping) : IPersistentObject {
        var referenceKey : * = raw[field.columnName];
        if (referenceKey == null || referenceKey == 0) {
            return null;
        }
        else {
            var id : uint = referenceKey as uint;
            return operations.getObjectByClass(id, DataUtils.getClass(field.typeName)) as IPersistentObject;
        }
    }

    public function GetReferenceFromRaw(typeMappings:TypeMappings, sqlConnection:SQLConnection, cacheManager:CacheManager, operations:EntityOperationsFacade) {
        super(typeMappings, sqlConnection, cacheManager, operations);
    }
}
}
