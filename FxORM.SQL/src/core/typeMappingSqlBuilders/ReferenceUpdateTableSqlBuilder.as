package core.typeMappingSqlBuilders {
import core.utils.fieldMappings.SqlFieldMapping;

public class ReferenceUpdateTableSqlBuilder implements IReferenceSqlStatementsBuilder {
    public function build(tableName:String, fieldColumns:Object, dbColumns:Object) : Array {
        var columnDefinitions:Array = getColumnDefinitions(fieldColumns, dbColumns);
        var updateTableStatements : Array = [];
        if (dbColumns == null) {
            updateTableStatements.push("CREATE TABLE IF NOT EXISTS " + tableName + "(" + columnDefinitions.join(",") + ")");
        }
        else if (columnDefinitions.length > 0) {
            for each (var columnDefinition : String in columnDefinitions) {
                var alterTableSQL : String = "ALTER TABLE " + tableName + " ADD COLUMN " + columnDefinition + ";";
                updateTableStatements.push(alterTableSQL);
            }
        }
        return updateTableStatements;
    }

    /**
     *
     * @param fieldColumns map where reference's field names are keys, and {#link FieldMapping} objects are values
     * @param dbColumns map where reference's field names are keys, and column names in DB are values
     * @return array of String DB column definitions in the form "COLUMN_NAME COLUMN_TYPE"
     */
    private function getColumnDefinitions(fieldColumns:Object, dbColumns:Object):Array {
        var columnDefinitions:Array = new Array();
        for (var field:String in fieldColumns) {
            var fieldMapping:SqlFieldMapping = fieldColumns[field] as SqlFieldMapping;
            // only new dbColumns
            if (dbColumns == null || dbColumns[fieldMapping.columnName] == null) {
                columnDefinitions.push(fieldMapping.columnName + " " + fieldMapping.getSqlType());
            }
        }
        return columnDefinitions;
    }
}
}
