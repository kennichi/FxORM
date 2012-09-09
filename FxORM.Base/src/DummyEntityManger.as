package {
import IPersistentObject;

import contexts.CollectionContext;

import interfaces.IEntityManager;
import interfaces.ISelectionBuilder;

public class DummyEntityManger implements IEntityManager
{
    public function getProperty(persistentObject:IPersistentObject, fieldName:String):* {
        return null;
    }

    public function beginTran():void {
    }

    public function commitTran():void {
    }

    public function rollbackTran():void {
    }

    public function findAll(clazz:Class):Array {
        return null;
    }

    public function save(persistentObject:IPersistentObject, pendingObjectsToSave : Array = null):uint {
        return 0;
    }

    public function saveJustObject(persistentObject:IPersistentObject, pendingObjectsToSave : Array):uint {
        return 0;
    }

    public function remove(persistentObject:IPersistentObject):void {
    }

    public function getObject(objectId:uint):IPersistentObject {
        return null;
    }

    public function refresh(objectId:uint):IPersistentObject {
        return null;
    }

    public function getObjectByClass(objectId:uint, clazz:Class):IPersistentObject {
        return null;
    }

    public function commitCollectionChanges(context:CollectionContext, pendingObjectsToSave : Array):void {
    }

    public function select(clazz:Class, alias:String = null):ISelectionBuilder {
        return null;
    }

    public function getByDuplicatedId(idField:String, type:Class):IPersistentObject {
        return null;
    }
}
}