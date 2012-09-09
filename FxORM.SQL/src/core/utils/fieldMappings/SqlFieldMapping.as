package core.utils.fieldMappings {
import IPersistentObject;

import core.entityOperations.EntityOperationsFacade;

import org.spicefactory.lib.errors.AbstractMethodError;

public class SqlFieldMapping {
    public var fieldName : String;
    public var typeName : String;
    public var columnName : String;

    public function SqlFieldMapping(fieldName : String, columnName : String, typeName : String) {
        this.fieldName = fieldName;
        this.typeName = typeName;
        this.columnName = columnName ? columnName : fieldName;
    }

    /**
     * @param owner
     * @return raw value of the field to be stored in the relevant cell
     */
    public function saveRawValue(owner : IPersistentObject, entityOperations : EntityOperationsFacade, pendingObjectsToSave : Array) : * {
        throw new AbstractMethodError();
    }

    public function getValueFromRaw(rawOwnerFromDB:Object, entityOperations:EntityOperationsFacade) :* {
        throw new AbstractMethodError();
    }

    public function remove(rawOwnerFromDB : Object, removeFromCacheOnly : Boolean, entityOperations:EntityOperationsFacade) : void {
    }

    public function getSqlType() : String {
        throw new AbstractMethodError();
    }

    public function get isId() : Boolean {
        return false;
    }

    public function markAsDirty(persistentObject:IPersistentObject):void {

    }
}
}
