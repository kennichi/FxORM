package core.entityOperations {

import cache.CacheManager;

import core.utils.fieldMappings.SqlFieldMapping;

import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;

import namespaces.data_mapping;

import utils.ObjectUtils;

import metadata.TypeMapping;

import utils.PersistenceUtils;

use namespace data_mapping;

public class BaseEntityOperation {
    protected var sqlConnection : SQLConnection;
    protected var operations : EntityOperationsFacade;
    private var cacheManager : CacheManager;
    private var typeMappings : TypeMappings;

    public function BaseEntityOperation(typeMappings:TypeMappings, sqlConnection:SQLConnection, cacheManager : CacheManager, operations : EntityOperationsFacade) {
        this.typeMappings = typeMappings;
        this.sqlConnection = sqlConnection;
        this.operations = operations;
        this.cacheManager = cacheManager;
    }

    protected static function existsInDB(persistentObject : IPersistentObject) : Boolean {
        return PersistenceUtils.existsInDB(persistentObject);
    }

    protected function selectRawFromDB(persistentObject : IPersistentObject) : Object {
        return existsInDB(persistentObject) ? operations.getObjectRaw(persistentObject.objectId, ObjectUtils.getClassByInstance(persistentObject)) : null;
    }

    protected function getFromCache(objectId : uint) : IPersistentObject {
        return cacheManager.getObject(objectId);
    }

    protected function putToCache(persistentObject : IPersistentObject) : void {
        cacheManager.setObject(persistentObject);
    }

    protected function removeFromCache(objectId : uint) : void {
        cacheManager.removeObject(objectId);
    }

    protected function addDeletedId(objectId : uint) : void {
        cacheManager.addDeletedId(objectId);
    }

    protected function getMapping(clazz:Class):TypeMapping {
        return typeMappings.getMapping(clazz);
    }

    protected function getFieldMapping(clazz : Class, fieldName : String) : SqlFieldMapping {
        return typeMappings.getFieldMapping(clazz, fieldName);
    }
}
}
