package core.entityOperations {
import IPersistentObject;

import cache.CacheManager;

import contexts.ReferenceContext;

import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;

import namespaces.data_mapping;

import utils.PersistenceUtils;

use namespace data_mapping;

public class Save extends BaseEntityOperation{

    /**
     * recursevly saves all changes done to the {#link persistentObject} and its references/collections
     * @param persistentObject
     * @return ObjectId of the saved instance.
     */
    public function execute(persistentObject : IPersistentObject, pendingObjectsToSave : Array) : uint {
        var dirtyContexts : Array = persistentObject.getContext().getDirtyContexts([]);
        if (!PersistenceUtils.existsInDB(persistentObject)) {
            operations.saveJustObject(persistentObject, pendingObjectsToSave);
        }
        for each (var context : ReferenceContext in dirtyContexts) {
            context.commitChanges(pendingObjectsToSave);
        }
        persistentObject.getContext().clearChanges([]);
        putToCache(persistentObject);
        return persistentObject.objectId;
    }

    public function Save(typeMappings:TypeMappings, sqlConnection:SQLConnection, cacheManager:CacheManager, operations:EntityOperationsFacade) {
        super(typeMappings, sqlConnection, cacheManager, operations);
    }
}
}
