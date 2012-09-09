package core.entityOperations {
import IPersistentObject;

import cache.CacheManager;

import core.utils.fieldMappings.SqlFieldMapping;
import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;

import namespaces.data_mapping;
import utils.ObjectUtils;

import metadata.TypeMapping;

import utils.PersistenceUtils;

use namespace data_mapping;
public class GetPropertyFromDB extends BaseEntityOperation {
    /**
     * should be called for referenced {#link IPersistentObject} properties and collections of {#link IPersistentObject} items.
     * @param persistentObject owner of the property
     * @param fieldName name of the field referencing the property
     * @return fieldName value from DB
     */
    public function execute(persistentObject : IPersistentObject, fieldName : String) : * {
        if (!PersistenceUtils.existsInDB(persistentObject)) return null;
        var clazz : Class = ObjectUtils.getClassByInstance(persistentObject);
        var field : SqlFieldMapping = getFieldMapping(clazz, fieldName);
        return field.getValueFromRaw(selectRawFromDB(persistentObject), operations);
    }

    public function GetPropertyFromDB(typeMappings:TypeMappings, sqlConnection:SQLConnection, cacheManager:CacheManager, operations:EntityOperationsFacade) {
        super(typeMappings, sqlConnection, cacheManager, operations);
    }
}
}
