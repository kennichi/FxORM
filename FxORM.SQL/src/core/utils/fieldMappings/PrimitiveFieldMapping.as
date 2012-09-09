package core.utils.fieldMappings {
import IPersistentObject;

import core.entityOperations.EntityOperationsFacade;
import core.utils.SqlUtils;

public class PrimitiveFieldMapping extends SqlFieldMapping {

    override public function saveRawValue(owner:IPersistentObject, entityOperations:EntityOperationsFacade, pendingObjectsToSave : Array):* {
        return owner[fieldName];
    }

    override public function getValueFromRaw(rawOwnerFromDB:Object, entityOperations:EntityOperationsFacade):* {
        return rawOwnerFromDB[columnName];
    }

    override public function getSqlType():String {
        return SqlUtils.getSQLType(typeName);
    }

    public function PrimitiveFieldMapping(fieldName:String, columnName:String, typeName:String) {
        super(fieldName, columnName, typeName);
    }
}
}
