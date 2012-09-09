package core.entityOperations {
import IPersistentObject;

import cache.CacheManager;

import core.Constants;
import core.utils.fieldMappings.NonPrimitiveFieldMapping;
import core.utils.fieldMappings.SqlFieldMapping;
import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;

import namespaces.data_mapping;

import metadata.TypeMapping;

use namespace data_mapping;

/**
 * converts raw record from DB into a IPersistentObject of specified {#link clazz}
 */
public class ConvertObject extends BaseEntityOperation {

    /**
     * converts row from DB ({#link rawObjectFromDB}) into a IPersistentObject of specified {#link clazz}
     * @param rawObjectFromDB
     * @param clazz
     * @return instance of {#link clazz} represented by {#link rawObjectFromDB}
     */
    public function execute(rawObjectFromDB : Object, clazz : Class) : IPersistentObject {
        if (rawObjectFromDB == null) return null;
        var objectId : uint = rawObjectFromDB[Constants.ID_COLUMN_NAME] as uint;
        var cached : IPersistentObject = getFromCache(objectId);
        if (cached != null) {
            return cached;
        }
        var mapping : TypeMapping = getMapping(clazz);
        var instance : IPersistentObject = new clazz() as IPersistentObject;
        for each (var field : SqlFieldMapping in mapping.fields) {
            if (field is NonPrimitiveFieldMapping && NonPrimitiveFieldMapping(field).lazyLoad) continue;
            instance[field.fieldName] = field.getValueFromRaw(rawObjectFromDB, operations);
        }
        // todo: do we need this call???
        instance.getContext().clearChanges([]);
        putToCache(instance);
        return instance;
    }

    public function ConvertObject(typeMappings:TypeMappings, sqlConnection:SQLConnection, cacheManager:CacheManager, operations:EntityOperationsFacade) {
        super(typeMappings, sqlConnection, cacheManager, operations);
    }
}
}
