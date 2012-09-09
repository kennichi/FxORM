package core.utils.fieldMappings {
import IPersistentObject;

import core.entityOperations.EntityOperationsFacade;

import utils.DateUtils;

public class DateFieldMapping extends PrimitiveFieldMapping {
    override public function saveRawValue(owner:IPersistentObject, entityOperations:EntityOperationsFacade, pendingObjectsToSave : Array):* {
        var date : Date = getValue(owner);
        return date ? uint(date.time / 1000) : null;
    }

    override public function getValueFromRaw(rawOwnerFromDB:Object, entityOperations:EntityOperationsFacade):* {
        var dbValue : * = rawOwnerFromDB[columnName];
        var seconds:Number = Number(dbValue);
        return dbValue ? DateUtils.fromSQLite(seconds) : null;
    }

    private function getValue(owner:IPersistentObject):Date {
        return owner[fieldName] as Date;
    }


    public function DateFieldMapping(fieldName:String, columnName:String) {
        super(fieldName, columnName, "Date");
    }
}
}
