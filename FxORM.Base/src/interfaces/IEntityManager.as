package interfaces
{

import contexts.CollectionContext;

/**
 * a core on top of DB
 */
public interface IEntityManager
{
    /**
     * should be called for referenced {#link IPersistentObject} properties and collections of {#link IPersistentObject} items.
     * @param persistentObject owner of the property
     * @param fieldName name of the field referencing the property
     * @return fieldName value from DB
     */
    function getProperty(persistentObject : IPersistentObject, fieldName : String) : *;

    function beginTran() : void;
    function commitTran() : void;
    function rollbackTran() : void;

    /**
     *
     * @param clazz
     * @return all instances of specified {#link clazz} type from DB
     */
    function findAll(clazz : Class) : Array;

    /**
     *
     * @param persistentObject object to save to DB
     * @param pendingObjectsToSave Do no specify this value when calling the method.
     * An array of ids which are to be saved during the save process which is recursive.
     * @return
     */
    function save(persistentObject : IPersistentObject, pendingObjectsToSave : Array = null) : uint;

    /**
     * removes {#link persistentObject} from DB
     * @param persistentObject
     */
    function remove(persistentObject : IPersistentObject):void;


    /**
     * retrieves object either from cache or DB with specified {#link objectId}
     * @param objectId
     * @return object either from cache or DB with specified {#link objectId}
     */
    function getObject(objectId : uint) : IPersistentObject;

    /**
     * refreshes object with {#link objectId} in cache with data from DB
     * @param objectId
     * @return refreshed object from DB with {#link objectId}
     */
    function refresh(objectId : uint) : IPersistentObject;

    /**
     * use this method to start querying for objects of type {#link clazz}
     * @param clazz type of objects to select
     * @param alias
     * @return builder for querying objects from DB
     */
    function select(clazz : Class, alias : String = null) : ISelectionBuilder;

    /**
     * when you need to update an object with its own idField (an instance of {#link IDuplicatedReference}, i.e. an object from Back End), and you don't want to completely overwrite
     * object in DB with the same idField, then first retrieve an object from DB using this method, and update the properties you want to overwrite.
     * If you are willing to override all the properties, then just call save() on the original object (and you don't need this call).
     * @param idField id value of {#link IDuplicatedReference}
     * @param type type of the object you want to get (i.e. Employee), must implement {#link IDuplicatedReference}
     * @return null, if there was no object in the DB with specified idField and type. Otherwise, an object of type {#link type} from DB which has the same idField as specified {#link idField}.
     */
    function getByDuplicatedId(idField : String, type : Class) : IPersistentObject;

    /**
     * #private
     * you don't normally need to call this method.
     * Saves changes only relevant to the table of {#link persistentObject} (this includes referenced objects not yet saved to the DB)
     * @param persistentObject
     * @param pendingObjectsToSave
     * @return
     */
    function saveJustObject(persistentObject : IPersistentObject, pendingObjectsToSave : Array) : uint;

    /**
     * #private
     * speeds up {#link getObject} method invocation as no reflection needed to get the expected type of the object.
     * @param objectId
     * @param clazz
     * @return @see {#link getObject}
     */
    function getObjectByClass(objectId : uint, clazz : Class) : IPersistentObject;

    /**
     * #private
     * saves all changes to the collection to DB.
     * @param context
     * @param pendingObjectsToSave
     */
    function commitCollectionChanges(context : CollectionContext, pendingObjectsToSave : Array) : void;
}
}