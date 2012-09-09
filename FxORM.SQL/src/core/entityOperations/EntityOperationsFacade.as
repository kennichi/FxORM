package core.entityOperations {

import cache.CacheManager;

import contexts.CollectionContext;

import core.utils.FxORMManager;
import core.utils.DataUtils;

import core.utils.fieldMappings.CollectionFieldMapping;
import core.utils.fieldMappings.ReferenceFieldMapping;
import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;

import namespaces.data_mapping;
import utils.ObjectUtils;

import mx.collections.ArrayCollection;

import org.spicefactory.lib.errors.IllegalArgumentError;

use namespace data_mapping;

public class EntityOperationsFacade {
    private var sqlConnection : SQLConnection;

    private var getObjectRawOperation : GetObjectRaw;
    private var saveJustCollectionOperation : SaveJustCollection;
    private var getCollectionFromRawOperation : GetCollectionFromRaw;
    private var removeCollectionOperation : RemoveCollection;
    private var saveJustReferenceOperation : SaveJustReference;
    private var getReferenceFromRawOperation : GetReferenceFromRaw;
    private var removeReferenceOperation : RemoveReference;
    private var saveJustObjectOperation : SaveJustObject;
    private var saveOperation : Save;
    private var removeOperation : Remove;
    private var getObjectOperation : GetObject;
    private var refreshObjectOperation : RefreshObject;
    private var convertObjectOperation : ConvertObject;
    private var commitCollectionChangesOperation : CommitCollectionChanges;
    private var getPropertyFromDBOperation : GetPropertyFromDB;

    data_mapping function reset(typeMappings : TypeMappings, sqlConnection : SQLConnection, cacheManager : CacheManager) : void {
        if (typeMappings == null || sqlConnection == null || cacheManager == null) throw new IllegalArgumentError("State incomplete");
        this.sqlConnection = sqlConnection;
        getObjectRawOperation = new GetObjectRaw(typeMappings, sqlConnection, cacheManager, this);
        saveJustCollectionOperation = new SaveJustCollection(typeMappings, sqlConnection, cacheManager, this);
        getCollectionFromRawOperation = new GetCollectionFromRaw(typeMappings, sqlConnection, cacheManager, this);
        removeCollectionOperation = new RemoveCollection(typeMappings, sqlConnection, cacheManager, this);
        saveJustReferenceOperation = new SaveJustReference(typeMappings, sqlConnection, cacheManager, this);
        getReferenceFromRawOperation = new GetReferenceFromRaw(typeMappings, sqlConnection, cacheManager, this);
        removeReferenceOperation = new RemoveReference(typeMappings, sqlConnection, cacheManager, this);
        saveJustObjectOperation = new SaveJustObject(typeMappings, sqlConnection, cacheManager, this);
        saveOperation = new Save(typeMappings, sqlConnection, cacheManager, this);
        removeOperation = new Remove(typeMappings, sqlConnection, cacheManager, this);
        getObjectOperation = new GetObject(typeMappings, sqlConnection, cacheManager, this);
        refreshObjectOperation = new RefreshObject(typeMappings, sqlConnection, cacheManager, this);
        convertObjectOperation = new ConvertObject(typeMappings, sqlConnection, cacheManager, this);
        commitCollectionChangesOperation = new CommitCollectionChanges(typeMappings, sqlConnection, cacheManager, this);
        getPropertyFromDBOperation = new GetPropertyFromDB(typeMappings, sqlConnection, cacheManager, this);
    }

    private static function executeOperation(operation : BaseEntityOperation, arguments : Array) : * {
        var start : Number = new Date().milliseconds;
        FxORM.instance.profiler.onOperationStart(operation["constructor"], arguments);
        var execute : Function = operation["execute"];
        var result : * = execute.apply(null, arguments);
        var end : Number = new Date().milliseconds;
        FxORM.instance.profiler.onOperationFinish(operation["constructor"], arguments, result, end - start);
        return result;
    }

    data_mapping function getObjectRaw(objectId : uint, clazz : Class) : Object {
        return executeOperation(getObjectRawOperation, [objectId, clazz]);
    }

    data_mapping function saveJustObject(persistentObject : IPersistentObject, pendingObjectsToSave : Array) : uint {
        return executeOperation(saveJustObjectOperation, [persistentObject, pendingObjectsToSave]);
    }

    data_mapping function save(persistentObject : IPersistentObject, pendingObjectsToSave : Array) : uint {
        return executeOperation(saveOperation, [persistentObject, pendingObjectsToSave]);
    }

    data_mapping function remove(persistentObject : IPersistentObject):void {
        removeById(persistentObject.objectId, ObjectUtils.getClassByInstance(persistentObject), false);
    }

    data_mapping function removeFromCache(persistentObject : IPersistentObject) : void {
        removeById(persistentObject.objectId, ObjectUtils.getClassByInstance(persistentObject), true);
    }

    data_mapping function removeById(objectId : uint, clazz : Class, removeFromCacheOnly : Boolean) : void {
        executeOperation(removeOperation, [objectId, clazz, removeFromCacheOnly]);
    }

    /**
     * @param objectId
     * @return object with specified {#link objectId}. From cache if it is in cache, from DB otherwise.
     * Also updates cache
     */
    data_mapping function getObjectByClass(objectId : uint, clazz : Class) : IPersistentObject {
        return executeOperation(getObjectOperation, [objectId, clazz]);
    }

    /**
     * @param objectId
     * @return object with specified {#link objectId}. From cache if it is in cache, from DB otherwise.
     * Also updates cache
     */
    data_mapping function getObject(objectId : uint) : IPersistentObject {
        var clazz:Class = DataUtils.getClass(FxORMManager.getTypeNameById(objectId, sqlConnection));
        return executeOperation(getObjectOperation, [objectId, clazz]);
    }

    /**
     * use this operation if you need to take the whole data (inc. aggregated collections and references)
     * from DB, not from cache
     * @param objectId
     * @return {#link IPersistentObject} fresh from DB. Also updates cache.
     */
    data_mapping function refreshObject(objectId : uint) : IPersistentObject {
        return executeOperation(refreshObjectOperation, [objectId]);
    }

    data_mapping function convertObject(rawObjectFromDB : Object, clazz : Class) : IPersistentObject {
        return executeOperation(convertObjectOperation, [rawObjectFromDB, clazz]);
    }

    data_mapping function commitCollectionChanges(context : CollectionContext, pendingObjectsToSave : Array) : uint {
        return executeOperation(commitCollectionChangesOperation, [context, pendingObjectsToSave]);
    }

    data_mapping function getPropertyFromDB(persistentObject : IPersistentObject, fieldName : String) : * {
        return executeOperation(getPropertyFromDBOperation, [persistentObject, fieldName]);
    }

    // FIELD OPERATIONS:

    data_mapping function saveJustCollection(owner : IPersistentObject, field : CollectionFieldMapping, pendingObjectsToSave : Array) : uint {
        return executeOperation(saveJustCollectionOperation, [owner, field, pendingObjectsToSave]);
    }

    data_mapping function saveJustReference(owner : IPersistentObject, field : ReferenceFieldMapping, pendingObjectsToSave : Array) : uint {
        return executeOperation(saveJustReferenceOperation, [owner, field, pendingObjectsToSave]);
    }

    data_mapping function getReferenceFromRaw(raw : Object, field : ReferenceFieldMapping) : IPersistentObject {
        return executeOperation(getReferenceFromRawOperation, [raw, field]);
    }

    data_mapping function removeReference(rawOwner : Object, field : ReferenceFieldMapping, removeFromCacheOnly : Boolean) : void {
        executeOperation(removeReferenceOperation, [rawOwner, field, removeFromCacheOnly]);
    }

    data_mapping function getCollectionFromRaw(raw : Object, field : CollectionFieldMapping) : ArrayCollection {
        return executeOperation(getCollectionFromRawOperation, [raw, field]);
    }

    data_mapping function removeCollection(rawOwner : Object, field : CollectionFieldMapping, removeFromCacheOnly : Boolean) : void {
        executeOperation(removeCollectionOperation, [rawOwner, field, removeFromCacheOnly]);
    }
}
}
