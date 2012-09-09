package core.entityOperations {
import IPersistentObject;

import cache.CacheManager;

import core.utils.fieldMappings.ReferenceFieldMapping;

import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;

import namespaces.data_mapping;

import utils.PersistenceUtils;

use namespace data_mapping;

/**
 * saves reference only if it is not already in DB
 */
public class SaveJustReference extends BaseEntityOperation {
    /**
     * saves reference stored in field {#link field} of {#link owner} instance, only if it is not already in the DB.
     * @param owner
     * @param field
     * @param pendingObjectsToSave
     * @return updated objectId of the reference property
     */
    public function execute(owner : IPersistentObject, field : ReferenceFieldMapping, pendingObjectsToSave : Array) : uint {
        var referencedValue : IPersistentObject = owner[field.fieldName];
        if (referencedValue == null)  {
            return 0;
        }
        // only if the field is non-persistant and we need to change this instance and set id to this obj
        else if (!PersistenceUtils.existsInDB(referencedValue)) {
            var referenceId : uint = operations.saveJustObject(referencedValue, pendingObjectsToSave);
            return referenceId;
        } else {
            return referencedValue.objectId;
        }
    }

    public function SaveJustReference(typeMappings:TypeMappings, sqlConnection:SQLConnection, cacheManager:CacheManager, operations:EntityOperationsFacade) {
        super(typeMappings, sqlConnection, cacheManager, operations);
    }
}
}
