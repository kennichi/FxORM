package core.utils.fieldMappings {
import IPersistentObject;

import core.Constants;
import core.entityOperations.EntityOperationsFacade;
import core.utils.DataUtils;

import utils.StringUtils;

/**
 * in this case we have a "primitives" object of type Array (Array of primitive values) - store it's values as a string of SIMPLE_COLLECTION_SEPARATOR-separated values.
 */
public class ArrayFieldMapping extends SqlFieldMapping {
    public var collectionItemType : String;

    override public function saveRawValue(owner:IPersistentObject, entityOperations:EntityOperationsFacade, pendingObjectsToSave : Array):* {
        var array : Array = getValue(owner);
        return saveRawArray(array);
    }

    override public function getValueFromRaw(rawOwnerFromDB:Object, entityOperations:EntityOperationsFacade):* {
        var strValue : String = rawOwnerFromDB[columnName] as String;
        if (StringUtils.isEmpty(strValue)) return null;
        var strValues : Array = strValue.split(Constants.SIMPLE_COLLECTION_SEPARATOR);
        var converted : Array = [];
        for each (var str : String in strValues) {
            converted.push(DataUtils.convertStringToSimpleType(str, collectionItemType));
        }
        return converted;
    }

    override public function getSqlType():String {
        return "TEXT";
    }

    protected function saveRawArray(array :Array) : * {
        return array.join(Constants.SIMPLE_COLLECTION_SEPARATOR);

    }

    private function getValue(owner:IPersistentObject):Array {
        return owner[fieldName] as Array;
    }

    public function ArrayFieldMapping(fieldName:String, columnName:String, collectionItemType:String) {
        super(fieldName, columnName, "Primitive Array Type");
        this.collectionItemType = collectionItemType;
    }
}
}
