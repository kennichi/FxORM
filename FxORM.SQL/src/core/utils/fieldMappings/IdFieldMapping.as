package core.utils.fieldMappings {
import core.Constants;

// todo: add support for non-number id fields!
public class IdFieldMapping extends PrimitiveFieldMapping {

    override public function getSqlType():String {
        return Constants.ID_TYPE_NAME + " PRIMARY KEY ASC";
    }

    override public function get isId():Boolean {
        return true;
    }

    public function IdFieldMapping(fieldName:String, columnName:String) {
        super(fieldName, columnName, "uint");
    }
}
}
