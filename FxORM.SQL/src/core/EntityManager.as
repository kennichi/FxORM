package core
{
import avmplus.getQualifiedClassName;

import cache.CacheManager;

import contexts.CollectionContext;

import core.entityOperations.EntityOperationsFacade;

import core.sqlCommands.InitDBCommand;
import core.utils.FxORMManager;
import core.utils.SqlUtils;
import core.selectionBuilder.SelectionBuilder;
import core.utils.typeMappings.TypeMappings;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.events.EventDispatcher;

import interfaces.ISelectionBuilder;

import namespaces.data_mapping;
import interfaces.IEntityManager;

import metadata.ColumnMetadata;
import metadata.IdMetadata;
import metadata.TableMetadata;
import metadata.TypeMapping;

import org.spicefactory.lib.reflect.Metadata;

use namespace data_mapping;
[Exclude(name="setReference", kind="method")]
[Exclude(name="setCollection", kind="method")]
public class EntityManager extends EventDispatcher implements IEntityManager {

    private var _sqlConnection : SQLConnection;
    private var typeMappings : TypeMappings;
    private var operations : EntityOperationsFacade = new EntityOperationsFacade();

    /**
     * Should be singleton. Create it once and cache it somewhere.
     */
    public function EntityManager() {
        registerMetadatas();
    }

    public static function registerMetadatas() : void {
        Metadata.registerMetadataClass(TableMetadata);
        Metadata.registerMetadataClass(ColumnMetadata);
        Metadata.registerMetadataClass(IdMetadata);
    }

    /**
     * should be called for referenced {#link IPersistentObject} properties and collections of {#link IPersistentObject} items.
     * @param instance owner of the property
     * @param fieldName name of the field referencing the property
     * @return fieldName value from DB
     */
    public function getProperty(instance : IPersistentObject, fieldName : String) : * {
        // load property data, update table if necessary
        return operations.getPropertyFromDB(instance, fieldName);
    }

    public function save(persistentObject:IPersistentObject, pendingObjectsToSave : Array = null):uint {
        if (!pendingObjectsToSave) pendingObjectsToSave = [];
        return operations.save(persistentObject, pendingObjectsToSave);
    }

    public function remove(persistentObject:IPersistentObject):void {
        operations.remove(persistentObject);
    }

    public function getObject(objectId:uint):IPersistentObject {
        return operations.getObject(objectId);
    }

    public function getObjectByClass(objectId:uint, clazz:Class):IPersistentObject {
        return operations.getObjectByClass(objectId, clazz);
    }

    public function refresh(objectId:uint):IPersistentObject {
        return operations.refreshObject(objectId);
    }

    public function saveJustObject(persistentObject:IPersistentObject, pendingObjectsToSave : Array):uint {
        return operations.saveJustObject(persistentObject, pendingObjectsToSave);
    }

    public function commitCollectionChanges(context:CollectionContext, pendingObjectsToSave : Array):void {
        operations.commitCollectionChanges(context, pendingObjectsToSave);
    }

    public function findAll(clazz : Class) : Array {
        return select(clazz).query();
    }

    public function beginTran() : void {
        FxORM.instance.profiler.onBeginTransaction();
        sqlConnection.begin();
    }

    public function commitTran() : void {
        sqlConnection.commit();
        FxORM.instance.profiler.onCommitTransaction();
    }

    public function rollbackTran() : void {
        sqlConnection.rollback();
        FxORM.instance.profiler.onRollbackTransaction();
    }

    private function initDB() : void {
        try {
            beginTran();
            new InitDBCommand().execute(sqlConnection);
            commitTran();
        } catch(e : Error) {
            FxORM.instance.profiler.onError(e.message);
            rollbackTran();
        }
    }

    public function execute(statement : SQLStatement) : SQLResult {
        return SqlUtils.execute(statement, sqlConnection);
    }

    private function reset(sqlConnection : SQLConnection):void {
        typeMappings = new TypeMappings(sqlConnection);
        initDB();
        var cacheManager:CacheManager = CacheManager.instance;
        cacheManager.reset();
        operations.reset(typeMappings, sqlConnection, cacheManager);
    }

    public function set sqlConnection(sqlConnection:SQLConnection):void {
        _sqlConnection = sqlConnection;
        reset(sqlConnection);
    }


    public function get sqlConnection():SQLConnection {
        return _sqlConnection;
    }

    public function select(clazz:Class, alias:String = null):ISelectionBuilder {
        return new SelectionBuilder(typeMappings, sqlConnection, operations).on(clazz, alias);
    }

    /**
     * when you need to update an object with its own idField (an instance of {#link IDuplicatedReference}, i.e. an object from Back End), and you don't want to completely overwrite
     * object in DB with the same idField, then first retrieve an object from DB using this method, and update the properties you want to overwrite.
     * If you are willing to override all the properties, then just call save() on the original object (and you don't need this call).
     * @param idField id value of {#link IDuplicatedReference}
     * @param type type of the object you want to get (i.e. Employee)
     * @return null, if there was no object in the DB with specified idField and type. Otherwise, an object from DB.
     */
    public function getByDuplicatedId(idField:String, type:Class):IPersistentObject {
        var mapping:TypeMapping = typeMappings.getMapping(type);
        return operations.convertObject(FxORMManager.selectObjectByBeId(idField, getQualifiedClassName(type), mapping.table, sqlConnection), type);
    }
}
}