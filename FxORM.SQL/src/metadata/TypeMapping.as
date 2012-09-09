package metadata
{
import core.SqlStatementsFactory;
import core.utils.SqlUtils;
import core.utils.fieldMappings.SqlFieldMapping;

import flash.data.SQLConnection;

public class TypeMapping {

    public var table : String;
    /**
     * Array of field mappings
     * @see FieldMapping.
     */
    public var fields : Array;
    /**
     * name of id field in type
     */
//    public var identity : String;

    public var insertStubStatement : String;
    public var insertStatement : String;
    public var updateStatement : String;
    public var deleteStatement : String;
    public var findAllStatement : String;
    public var getByIdStatement : String;
    public var updateTableStatements : Array;

    public function getFieldMapping(fieldName : String) : SqlFieldMapping {
        for each (var field : SqlFieldMapping in fields) {
            if (field.fieldName == fieldName) return field;
        }
        return null;
    }

    public function updateTable(sqlConnection : SQLConnection) : void {
        for each (var sql : String in updateTableStatements) {
            SqlUtils.execute(SqlStatementsFactory.create(sql), sqlConnection);
        }
    }
}
}