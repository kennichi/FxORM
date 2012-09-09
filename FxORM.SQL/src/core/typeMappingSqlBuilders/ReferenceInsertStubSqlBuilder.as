package core.typeMappingSqlBuilders {
import core.utils.fieldMappings.SqlFieldMapping;

public class ReferenceInsertStubSqlBuilder implements IReferenceSqlStatementsBuilder {
    public function build(tableName:String, fieldColumns:Object, dbColumns:Object) : Array {
        var idFieldMapping : SqlFieldMapping = null;
        for (var field : String in fieldColumns) {
            var fieldMapping : SqlFieldMapping = fieldColumns[field] as SqlFieldMapping;
            if (fieldMapping.isId)  {
                idFieldMapping = fieldMapping;
                break;
            }
        }
        var insertSQL:String = "INSERT INTO " + tableName + " (" + idFieldMapping.columnName + ") VALUES (:objectId)";
        return [insertSQL];
    }
}
}
