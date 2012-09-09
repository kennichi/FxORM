package core.typeMappingSqlBuilders {
import core.utils.fieldMappings.SqlFieldMapping;

public class ReferenceUpdateSqlBuilder implements IReferenceSqlStatementsBuilder {
    public function build(tableName:String, fieldColumns:Object, dbColumns:Object):Array {
        var updateSQL:String = "UPDATE " + tableName + " SET ";
        var hasFields : Boolean = false;
        for (var field : String in fieldColumns) {
            var fieldMapping : SqlFieldMapping = fieldColumns[field] as SqlFieldMapping;
            if (!fieldMapping.isId)  {
                updateSQL += fieldMapping.columnName + "=:" + fieldMapping.fieldName + ",";
                hasFields = true;
            }
        }
        if (!hasFields) return [""];
        return [updateSQL.substring(0, updateSQL.length-1)];
    }
}
}
