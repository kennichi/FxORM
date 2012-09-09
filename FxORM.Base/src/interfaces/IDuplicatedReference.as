package interfaces
{
/**
 * Different instances of this interface can share same {#link IDuplicatedReference.idField},
 * but should all represent same DB object if they share the same {#link IDuplicatedReference.idField}.
 * For example, when data is loaded from AMF,
 * and the same object is referenced in multiple responses, it will be deserialized into different instances.
 * The {#link IPersistentObject.objectId} property will need to be updated to the correct value. If the value is already stored in DB, it
 * will need to take objectId from there, otherwise, it will need to generate the same objectId for all instances of deserialized objects
 * with the same {#link IDuplicatedReference.idField}.
 */
public interface IDuplicatedReference {
    function get idField() : *;
    function set idField(v : *) : void;
}
}