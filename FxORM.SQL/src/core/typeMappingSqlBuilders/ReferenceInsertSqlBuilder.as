package core.typeMappingSqlBuilders {
import core.utils.fieldMappings.SqlFieldMapping;

public class ReferenceInsertSqlBuilder implements IReferenceSqlStatementsBuilder {
    public function build(tableName:String, fieldColumns:Object, dbColumns:Object) : Array {
        var insertParams:String = "";
        var insertSQL:String = "INSERT INTO " + tableName + " (";
        for (var field : String in fieldColumns) {
            var fieldMapping : SqlFieldMapping = fieldColumns[field] as SqlFieldMapping;
            insertSQL += fieldMapping.columnName + ",";
            insertParams += ":" + fieldMapping.fieldName + ",";
        }
        insertParams = insertParams.substring(0, insertParams.length-1);
        return [insertSQL.substring(0, insertSQL.length-1) + ") VALUES (" + insertParams + ")"];
    }
}
}
