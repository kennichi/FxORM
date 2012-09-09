package core.utils.fieldMappings {
import core.entityOperations.EntityOperationsFacade;

public class BooleanFieldMapping extends PrimitiveFieldMapping {

    override public function getValueFromRaw(rawOwnerFromDB:Object, entityOperations:EntityOperationsFacade):* {
        return rawOwnerFromDB[columnName] == "1";
    }

    public function BooleanFieldMapping(fieldName:String, columnName:String) {
        super(fieldName, columnName, "Boolean");
    }
}
}
