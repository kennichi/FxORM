package core.entityOperations {
import IPersistentObject;

import cache.CacheManager;

import core.SqlStatementsFactory;

import core.utils.FxORMManager;
import core.utils.SqlUtils;
import core.utils.fieldMappings.SqlFieldMapping;
import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.utils.getQualifiedClassName;

import interfaces.IDuplicatedReference;

import namespaces.data_mapping;
import utils.ObjectUtils;

import metadata.TypeMapping;

import utils.PersistenceUtils;

use namespace data_mapping;

/**
 * saves changes only relevant to the table of this object, includes collections, and new references (not from db).
 */
public class SaveJustObject extends BaseEntityOperation {

    /**
     * saves changes only relevant to the table of {#link persistentObject}.
     * Also saves collections, and new references which have not yet been saved to DB. This is necessary to allocate ids for them.
     * @param persistentObject
     * @param pendingObjectsToSave
     * @return objectId of the saved object.
     */
    public function execute(persistentObject : IPersistentObject, pendingObjectsToSave : Array) : uint
    {
        var clazz : Class = ObjectUtils.getClassByInstance(persistentObject);
        var mapping : TypeMapping = getMapping(clazz);
        // if we are dealing with an {#link IDuplicatedReference}, we need to make sure that we don't create a new record if
        // there's already a record with the same idField and the same type.
        if (persistentObject is IDuplicatedReference) {
            var objectIdByBeId:uint = FxORMManager.selectObjectIdByBeId(IDuplicatedReference(persistentObject).idField, getQualifiedClassName(persistentObject), mapping.table, sqlConnection);
            if (objectIdByBeId > 0) persistentObject.objectId = objectIdByBeId;
        }
        ensureExistsInDB(persistentObject, mapping);
        // ensure this object is not already being saved
        if (pendingObjectsToSave.indexOf(persistentObject.objectId) >= 0) {
            return persistentObject.objectId;
        }
        pendingObjectsToSave.push(persistentObject.objectId);
        // update fields
        var updateStatement : SQLStatement = SqlStatementsFactory.create(mapping.updateStatement);
        for each (var field : SqlFieldMapping in mapping.fields) {
            updateStatement.parameters[":"+field.fieldName] = field.saveRawValue(persistentObject, operations, pendingObjectsToSave);
        }
        SqlUtils.execute(updateStatement, sqlConnection);
        return persistentObject.objectId;
    }

    private function ensureExistsInDB(persistentObject:IPersistentObject, mapping:TypeMapping) : void {
        var existsInDB:Boolean = PersistenceUtils.existsInDB(persistentObject);
        if (!existsInDB) {
            var id:uint = FxORMManager.allocatePersistantObjectId(persistentObject, sqlConnection);
            var insertStatement : SQLStatement = SqlStatementsFactory.create(mapping.insertStubStatement);
            insertStatement.parameters[":objectId"] = id;
            SqlUtils.execute(insertStatement, sqlConnection);
            persistentObject.objectId = id;
            markReferencedPropertiesAsDirty(persistentObject, mapping);
        }
    }

    private function markReferencedPropertiesAsDirty(persistentObject:IPersistentObject, mapping:TypeMapping):void {
        for each (var field : SqlFieldMapping in mapping.fields) {
            field.markAsDirty(persistentObject);
        }
    }

    public function SaveJustObject(typeMappings:TypeMappings, sqlConnection:SQLConnection, cacheManager:CacheManager, operations:EntityOperationsFacade) {
        super(typeMappings, sqlConnection, cacheManager, operations);
    }
}
}
